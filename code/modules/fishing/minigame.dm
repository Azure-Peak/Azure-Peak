// float bobbing
#define WAIT_PHASE 1
// Click now to start tgui part
#define BITING_PHASE 2
// UI minigame phase
#define MINIGAME_PHASE 3

/// The minimum velocity required for the bait to bounce
#define BAIT_MIN_VELOCITY_BOUNCE 150

/// Reduce initial completion rate depending on difficulty
#define MAX_FISH_COMPLETION_MALUS 15
/// The window of time between biting phase and back to baiting phase
#define BITING_TIME_WINDOW 3 SECONDS

/// The multiplier of how much the difficulty negatively impacts the bait height
#define BAIT_HEIGHT_DIFFICULTY_MALUS 1.3

/// Defines to know how the bait is moving on the minigame slider.
#define REELING_STATE_IDLE 0
#define REELING_STATE_UP 1
#define REELING_STATE_DOWN 2

/// The pixel height of the minigame bar
#define MINIGAME_SLIDER_HEIGHT 76
/// The standard pixel height of the bait
#define MINIGAME_BAIT_HEIGHT 27
/// How many pixels bottom and top parts of the bait take up
#define MINIGAME_BAIT_TOP_AND_BOTTOM_HEIGHT 6
/// The standard pixel height of the fish (minus a pixel on each direction for the sake of a better looking sprite)
#define MINIGAME_FISH_HEIGHT 4
/// Pixel height of the completion bar
#define MINIGAME_COMPLETION_BAR_HEIGHT 80

GLOBAL_LIST_EMPTY(fishing_challenges_by_user)

/datum/fishing_challenge
	/// When the ui minigame phase started
	var/start_time
	/// Is it finished (either by win/lose or window closing)
	var/completed = FALSE
	/// Rule modifiers (eg weighted bait)
	var/special_effects = NONE
	/// A list of possible active minigame effects. If not empty, one will be picked from time to time.
	var/list/active_effects
	/// The cooldown between switching active effects
	COOLDOWN_DECLARE(active_effect_cd)
	/// The current active effect
	var/current_active_effect
	/// Result path
	var/reward_path = FISHING_DUD
	/// Minigame difficulty
	var/difficulty = FISHING_DEFAULT_DIFFICULTY
	/// Current phase
	var/phase = WAIT_PHASE
	/// Timer for the next phase
	var/next_phase_timer
	/// The lower and upper bounds of the waiting phase timer
	var/list/wait_time_range = list(3 SECONDS, 25 SECONDS)
	/// The last time we clicked during the baiting phase
	var/last_baiting_click
	/// Fishing mob
	var/mob/user
	/// Rod that is used for the challenge
	var/obj/item/fishingrod/used_rod
	/// float visual
	var/obj/effect/fishing_float/float
	///The physical fishing spot our float is hovering
	var/atom/location
	/// Background icon state from fishing_hud.dmi
	var/background = "background_default"
	/// Fish icon state from fishing_hud.dmi
	var/fish_icon = FISH_ICON_DEF

	/// Fishing line visual
	var/datum/beam/fishing_line

	var/experience_multiplier = 1

	/// How much space the fish takes on the minigame slider
	var/fish_height = 50
	/// How much space the bait takes on the minigame slider
	var/bait_height = 360
	/// The height in pixels of the bait bar
	var/bait_pixel_height = MINIGAME_BAIT_HEIGHT
	/// The height in pixels of the fish
	var/fish_pixel_height = MINIGAME_FISH_HEIGHT
	/// The position of the fish on the minigame slider
	var/fish_position = 0
	/// The position of the bait on the minigame slider
	var/bait_position = 0
	/// The current speed the bait is moving at
	var/bait_velocity = 0

	/// The completion score. If it reaches 100, it's a win. If it reaches 0, it's a loss.
	var/completion = 30
	/// How much completion is lost per second when the bait area is not intersecting with the fish's
	var/completion_loss = 6
	/// How much completion is gained per second when the bait area is intersecting with the fish's
	var/completion_gain = 5

	var/datum/fish_movement/mover

	/// Whether the bait is idle or reeling up or down (left and right click)
	var/reeling_state = REELING_STATE_IDLE
	/// The acceleration of the bait while not reeling
	var/gravity_velocity = -800
	/// The acceleration of the bait while reeling
	var/reeling_velocity = 1200
	/// Maximum absolute bait velocity - prevents runaway speed on slow ticks or high reeling_velocity
	var/max_bait_velocity = 1800
	/// By how much the bait recoils back when hitting the bounds of the slider while idle. Should be never above 1
	var/bait_bounce_mult = 0.6
	/// The multiplier of deceleration of velocity that happens when the bait switches direction
	var/deceleration_mult = 1.8
	/// Multiplier of the velocity applied when the bait is overlapping the fish
	var/overlap_velocity_mult = 0.6

	///The background as shown in the minigame, and the holder of the other visual overlays
	var/atom/movable/screen/fishing_hud/fishing_hud

	///Keep track of the fish source from which we're pulling the reward
	var/datum/fish_source/fish_source
	///this is basically our "idle variable"
	var/auto_handling = FALSE

	/// Seconds the minigame has run
	var/fight_time = 0
	/// Seconds of those the bait spent on the fish
	var/on_fish_time = 0
	/// CATCH_BAND_* judged from the two above. This sets the progress bar tint and the roll for the catch's quality. Starts as clean (Highest tier) and decays.
	var/catch_band = CATCH_BAND_CLEAN
	/// Timer that lets the fish go when the minigame runs too long
	var/minigame_timer
	var/lag_seconds = 0
	var/list/fish_history = list()
	var/ping_speed_mult = 1

/datum/fishing_challenge/New(datum/component/fishing_spot/comp, obj/item/fishingrod/rod, mob/user, _auto_handling)
	src.user = user
	used_rod = rod
	location = comp.parent
	float = new(get_turf(location), location)
	RegisterSignal(location, COMSIG_QDELETING, PROC_REF(on_spot_gone))
	RegisterSignal(comp, COMSIG_QDELETING, PROC_REF(on_spot_gone))
	register_reward_signals(comp.fish_source)
	RegisterSignal(fish_source, COMSIG_FISHING_SOURCE_INTERRUPT_CHALLENGE, PROC_REF(interrupt_challenge))
	background = comp.fish_source.background
	if(comp.fish_source.wait_time_range)
		wait_time_range = comp.fish_source.wait_time_range
	SEND_SIGNAL(user, COMSIG_MOB_BEGIN_FISHING, src)
	SEND_SIGNAL(rod, COMSIG_ROD_BEGIN_FISHING, src)
	GLOB.fishing_challenges_by_user[user] = src
	auto_handling = _auto_handling

	/// Enable special parameters
	if(rod.line)
		completion_gain += FISHING_LINE_ANY_GAIN
	if(rod.hook)
		if(rod.hook.fishing_hook_traits & FISHING_HOOK_WEIGHTED)
			bait_bounce_mult = FISHING_HOOK_IRON_BOUNCE
		if(rod.hook.fishing_hook_traits & FISHING_HOOK_BIDIRECTIONAL)
			special_effects |= FISHING_MINIGAME_RULE_BIDIRECTIONAL
		if(rod.hook.fishing_hook_traits & FISHING_HOOK_NO_ESCAPE)
			special_effects |= FISHING_MINIGAME_RULE_NO_ESCAPE
		if(rod.hook.fishing_hook_traits & FISHING_HOOK_KILL)
			special_effects |= FISHING_MINIGAME_RULE_KILL
	if(rod.line && (rod.line.fishing_line_traits & FISHING_LINE_BOBBER))
		gravity_velocity *= FISHING_BOBBER_GRAVITY_MULT
	if(rod.reel)
		var/obj/item/fishing/reel/reel = rod.reel
		if(reel.fishing_reel_traits & FISHING_REEL_FRAYED)
			completion_loss += FISHING_REEL_FRAYED_LOSS
		if(reel.fishing_reel_traits & FISHING_REEL_SMOOTH)
			completion_loss += FISHING_REEL_SMOOTH_LOSS
		if(reel.fishing_reel_traits & FISHING_REEL_BLESSED)
			completion_loss += FISHING_REEL_BLESSED_LOSS
			completion_gain += FISHING_REEL_BLESSED_GAIN

	var/skill_completion = (min(user.get_skill_level(/datum/skill/labor/fishing), SKILL_LEVEL_LEGENDARY) - SKILL_LEVEL_NOVICE) * FISHING_SKILL_COMPLETION_PERCENT / 100
	completion_gain *= 1 + skill_completion
	completion_loss *= 1 - skill_completion
	// Floor so high skill can never make completion_loss zero or negative (minigame must remain losable)
	completion_loss = max(1, completion_loss)

	reeling_velocity *= rod.bait_speed_mult
	max_bait_velocity *= rod.bait_speed_mult
	if(auto_handling)
		reeling_velocity *= FISHING_AUTO_REEL_SPEED_MULT
		max_bait_velocity *= FISHING_AUTO_REEL_SPEED_MULT
	completion_gain *= rod.completion_speed_mult
	bait_bounce_mult *= rod.bounciness_mult
	deceleration_mult *= rod.deceleration_mult
	gravity_velocity *= rod.gravity_mult
	/**
	 * The overlap multiplier is lower than 1 by default and exponentiation will make it even lower,
	 * to offset the harder control however a bait velocity higher (or lower) than normal.
	 */
	overlap_velocity_mult = overlap_velocity_mult ** rod.bait_speed_mult

/datum/fishing_challenge/Destroy(force)
	GLOB.fishing_challenges_by_user -= user
	if(!completed)
		complete(win = FALSE)
	if(fishing_line)
		//Stops the line snapped message from appearing everytime the minigame is over.
		UnregisterSignal(fishing_line, COMSIG_QDELETING)
		QDEL_NULL(fishing_line)
	QDEL_NULL(float)
	SStgui.close_uis(src)
	user = null
	used_rod = null
	location = null
	QDEL_NULL(mover)
	return ..()

/**
 * Proc responsible for registering the signals for difficulty, possible reward, and challenge completion.
 * Call this if you want to override the fish source from which we roll rewards (preferably before the minigame phase).
 */
/datum/fishing_challenge/proc/register_reward_signals(datum/fish_source/new_fish_source)
	if(fish_source)
		fish_source.UnregisterSignal(src, list(
			COMSIG_FISHING_CHALLENGE_ROLL_REWARD,
			COMSIG_FISHING_CHALLENGE_GET_DIFFICULTY,
		))
		fish_source.UnregisterSignal(user, COMSIG_MOB_COMPLETE_FISHING)
	fish_source = new_fish_source
	fish_source.RegisterSignal(src, COMSIG_FISHING_CHALLENGE_ROLL_REWARD, TYPE_PROC_REF(/datum/fish_source, roll_reward_minigame))
	fish_source.RegisterSignal(src, COMSIG_FISHING_CHALLENGE_GET_DIFFICULTY, TYPE_PROC_REF(/datum/fish_source, calculate_difficulty_minigame))
	fish_source.RegisterSignal(user, COMSIG_MOB_COMPLETE_FISHING, TYPE_PROC_REF(/datum/fish_source, on_challenge_completed))

/datum/fishing_challenge/proc/send_alert(message)
	location?.balloon_alert(user, message)

/datum/fishing_challenge/proc/on_spot_gone(datum/source)
	SIGNAL_HANDLER
	send_alert("fishing spot gone!")
	interrupt()

/datum/fishing_challenge/proc/interrupt_challenge(datum/source, reason)
	SIGNAL_HANDLER
	if(reason)
		send_alert(reason)
	interrupt()

/datum/fishing_challenge/proc/start(mob/living/user)
	/// Create fishing line visuals
	if(!used_rod.internal)
		fishing_line = used_rod.create_fishing_line(float, user, target_py = float.pixel_y + 4)
		if(isnull(fishing_line)) //couldn't create a fishing line, probably because we don't have a good line of sight.
			qdel(src)
			return
		RegisterSignal(fishing_line, COMSIG_QDELETING, PROC_REF(on_line_deleted))
	else //if the rod doesnt have a fishing line, then it ends when they move away
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_float_or_user_move))
		RegisterSignal(float, COMSIG_MOVABLE_MOVED, PROC_REF(on_float_or_user_move))
		RegisterSignal(user, SIGNAL_ADDTRAIT(TRAIT_HANDS_BLOCKED), PROC_REF(on_hands_blocked))
	active_effects = bitfield_to_list(special_effects & FISHING_MINIGAME_ACTIVE_EFFECTS)
	// If fishing line breaks los / rod gets dropped / deleted
	RegisterSignal(used_rod, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_attack_self))
	RegisterSignal(user, COMSIG_MOB_CLICKON, PROC_REF(handle_click))
	start_baiting_phase()
	to_chat(user, span_notice("You start fishing..."))
	playsound(location, 'sound/effects/splash.ogg', 100)

/datum/fishing_challenge/proc/on_line_deleted(datum/source)
	SIGNAL_HANDLER
	fishing_line = null
	///The float may be out of sight if the user has moed around a corner, so the message should be displayed over him instead.
	user.balloon_alert(user, user.is_holding(used_rod) ? "line snapped" : "rod dropped")
	interrupt()

/datum/fishing_challenge/proc/on_float_or_user_move(datum/source)
	SIGNAL_HANDLER

	if(!user.CanReach(location))
		user.balloon_alert(user, "too far!")
		interrupt()

/datum/fishing_challenge/proc/on_hands_blocked(datum/source)
	SIGNAL_HANDLER
	if(completed) //the rod was dropped and therefore challenge already completed.
		return
	user.balloon_alert(user, "hands blocked!")
	interrupt()

/datum/fishing_challenge/proc/handle_click(mob/source, atom/target, params)
	SIGNAL_HANDLER
	var/list/modifiers = params2list(params)
	if(HAS_TRAIT(source, TRAIT_HANDS_BLOCKED)) //blocked, can't do stuff
		return
	//Doing other stuff
	if(LAZYACCESS(modifiers, SHIFT_CLICKED) || LAZYACCESS(modifiers, CTRL_CLICKED) || LAZYACCESS(modifiers, ALT_CLICKED))
		return
	//You need to be actively holding on the fishing rod to use it.
	if(source.get_active_held_item() != used_rod)
		return
	//Clicking the rod itself is handled by the rod, which pulls the line in.
	if(target == used_rod)
		return
	if(LAZYACCESS(modifiers, RIGHT_CLICK) && phase != MINIGAME_PHASE)
		INVOKE_ASYNC(src, PROC_REF(stop_fishing), used_rod, source)
		return COMSIG_MOB_CANCEL_CLICKON
	if(phase == WAIT_PHASE)
		if(world.time < last_baiting_click + 0.25 SECONDS)
			return COMSIG_MOB_CANCEL_CLICKON //Don't punish players if they accidentally double clicked.
		send_alert("miss!")
		start_baiting_phase(TRUE) //Add in another 3 to 5 seconds for that blunder.
	else if(phase == BITING_PHASE)
		start_minigame_phase()
	return COMSIG_MOB_CANCEL_CLICKON

/// Challenge interrupted by something external
/datum/fishing_challenge/proc/interrupt()
	if(!completed)
		experience_multiplier *= 0.5
		complete(FALSE)

/datum/fishing_challenge/proc/on_attack_self(obj/item/source, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(stop_fishing), source, user)

/datum/fishing_challenge/proc/stop_fishing(obj/item/rod, mob/user)
	if((phase != MINIGAME_PHASE || do_after(user, 3 SECONDS, target = rod)) && !QDELETED(src) && !completed)
		experience_multiplier *= 0.5
		send_alert("stopped fishing")
		complete(FALSE)

///The multiplier of the fishing experience malus if the user's level is substantially above the difficulty.
#define EXPERIENCE_MALUS_MULT 0.08

/datum/fishing_challenge/proc/complete(win = FALSE)
	if(completed)
		return
	deltimer(next_phase_timer)
	deltimer(minigame_timer)
	completed = TRUE
	if(phase == MINIGAME_PHASE)
		remove_minigame_hud()

	if(!QDELETED(user) && user.mind && start_time && !(special_effects & FISHING_MINIGAME_RULE_NO_EXP))
		var/seconds_spent = (world.time - start_time) * 0.1
		// Base XP: flat difficulty reward + small time component so longer fights still count
		// This means a hard fish is worth more than an easy one regardless of how long it took,
		// and winning gives the full difficulty bonus rather than penalising a clean fast win.
		var/base_xp = (difficulty * 1.5) + (seconds_spent * 0.8)
		var/extra_exp_malus = (user.get_skill_level(/datum/skill/labor/fishing) * 10 - difficulty) * 0.1
		if(extra_exp_malus > 0)
			experience_multiplier /= (1 + extra_exp_malus * EXPERIENCE_MALUS_MULT)
		if(auto_handling)
			experience_multiplier *= 0.5
		experience_multiplier *= used_rod.experience_multiplier
		user.mind.add_sleep_experience(/datum/skill/labor/fishing, round(base_xp * experience_multiplier))

	if(!win)
		SEND_SIGNAL(user, COMSIG_MOB_COMPLETE_FISHING, src, FALSE)
		if(!QDELETED(src))
			qdel(src)
		return

	if(reward_path != FISHING_DUD)
		playsound(location, 'sound/effects/bigsplash.ogg', 100)

	SEND_SIGNAL(user, COMSIG_MOB_COMPLETE_FISHING, src, TRUE)
	if(!QDELETED(src))
		qdel(src)

#undef EXPERIENCE_MALUS_MULT

/datum/fishing_challenge/proc/start_baiting_phase(penalty = FALSE)
	fish_source?.release_generated_fish(reward_path)
	reward_path = null //In case we missed the biting phase, set the path back to null
	var/wait_time
	last_baiting_click = world.time
	if(penalty)
		var/remaining = timeleft(next_phase_timer)
		deltimer(next_phase_timer)
		wait_time = min(remaining + rand(3 SECONDS, 5 SECONDS), 30 SECONDS)
	else
		deltimer(next_phase_timer)
		wait_time = rand(wait_time_range[1], wait_time_range[2])
	phase = WAIT_PHASE
	//Bobbing animation
	animate(float, pixel_z = 1, time = 1 SECONDS, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_z = -1, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	next_phase_timer = addtimer(CALLBACK(src, PROC_REF(start_biting_phase)), wait_time, TIMER_STOPPABLE|TIMER_DELETE_ME)

/datum/fishing_challenge/proc/start_biting_phase()
	phase = BITING_PHASE

	var/list/rewards = list()
	SEND_SIGNAL(src, COMSIG_FISHING_CHALLENGE_ROLL_REWARD, used_rod, user, location, rewards)
	if(length(rewards))
		reward_path = pick(rewards)
	playsound(location, 'sound/effects/fish_splash.ogg', 100)

	send_alert("!!!")
	//visual flair animation inbound
	animate(float, pixel_z = 4, time = 0.6 SECONDS, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_z = -4, time = 0.6 SECONDS, flags = ANIMATION_RELATIVE)
	addtimer(CALLBACK(src, PROC_REF(escalate_float_animation)), 1 SECONDS, TIMER_DELETE_ME)
	addtimer(CALLBACK(src, PROC_REF(peak_float_animation)), 2 SECONDS, TIMER_DELETE_ME)
	// Setup next phase
	next_phase_timer = addtimer(CALLBACK(src, PROC_REF(start_baiting_phase)), BITING_TIME_WINDOW, TIMER_STOPPABLE|TIMER_DELETE_ME)

/// Float bobs a bit harder mid-biting-window
/datum/fishing_challenge/proc/escalate_float_animation()
	if(phase != BITING_PHASE)
		return
	animate(float, pixel_z = 6, time = 0.4 SECONDS, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_z = -6, time = 0.4 SECONDS, flags = ANIMATION_RELATIVE)

/// Float thrashes at peak - this is when clicking gives the best bonus
/datum/fishing_challenge/proc/peak_float_animation()
	if(phase != BITING_PHASE)
		return
	animate(float, pixel_z = 9, time = 0.25 SECONDS, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_z = -9, time = 0.25 SECONDS, flags = ANIMATION_RELATIVE)
	send_alert("now!")

///The damage dealt per second to the fish when FISHING_MINIGAME_RULE_KILL is active.
#define FISH_DAMAGE_PER_SECOND 2

///The player is no longer around to play the minigame, so we interrupt it.
/datum/fishing_challenge/proc/on_user_logout(datum/source)
	SIGNAL_HANDLER
	interrupt()

/datum/fishing_challenge/proc/on_reward_removed(datum/source)
	SIGNAL_HANDLER
	send_alert("reward gone!")
	interrupt()

/datum/fishing_challenge/proc/on_fish_death(obj/item/reagent_containers/food/snacks/fish/source)
	SIGNAL_HANDLER
	if(source.dead)
		win_anyway()

/datum/fishing_challenge/proc/win_anyway()
	if(completed)
		return
	//winning by timeout / fish death shouldn't give as much experience.
	experience_multiplier *= 0.5
	complete(TRUE)

/datum/fishing_challenge/proc/get_difficulty()
	var/list/difficulty_holder = list(0)
	SEND_SIGNAL(src, COMSIG_FISHING_CHALLENGE_GET_DIFFICULTY, reward_path, used_rod, user, difficulty_holder)
	difficulty = difficulty_holder[1]
	//If you manage to be so well-equipped and skilled to completely crush the difficulty, just skip to the reward.
	if(difficulty <= 0)
		complete(TRUE)
		return FALSE
	difficulty = clamp(round(difficulty), FISHING_MINIMUM_DIFFICULTY, 100)
	return TRUE

/datum/fishing_challenge/proc/update_difficulty()
	if(phase != MINIGAME_PHASE)
		return
	var/old_difficulty = difficulty
	//early return if the difficulty is the same or we crush the minigame all the way to 0 difficulty
	if(!get_difficulty() || difficulty == old_difficulty)
		return
	// Remove the old difficulty's XP contribution before re-applying with new difficulty
	experience_multiplier -= old_difficulty * 0.015
	bait_height = initial(bait_height) * used_rod.bait_height_mult
	mover.reset_difficulty_values()
	adjust_to_difficulty()

/datum/fishing_challenge/proc/adjust_to_difficulty()
	mover.adjust_to_difficulty()
	bait_height -= round(difficulty * BAIT_HEIGHT_DIFFICULTY_MALUS)
	bait_pixel_height = round(MINIGAME_BAIT_HEIGHT * (bait_height/initial(bait_height)), 1)
	experience_multiplier += difficulty * 0.015
	fishing_hud.hud_bait.adjust_to_difficulty(src)

///Get the difficulty and other variables, than start the minigame
/datum/fishing_challenge/proc/start_minigame_phase(auto_reel = FALSE)
	SEND_SIGNAL(user, COMSIG_MOB_BEGIN_FISHING_MINIGAME, src)
	if(!get_difficulty()) //we totalized 0 or less difficulty, instant win.
		return

	if(difficulty > FISHING_DEFAULT_DIFFICULTY)
		completion -= MAX_FISH_COMPLETION_MALUS * (difficulty * 0.01)

	var/is_fish_instance = isfish(reward_path)
	var/icon_key = reward_path
	if(is_fish_instance)
		var/obj/item/reagent_containers/food/snacks/fish/caught = reward_path
		icon_key = caught.type
	fish_icon = GLOB.specific_fish_icons[icon_key] || FISH_ICON_DEF

	if(auto_handling && (ispath(reward_path, /obj/item/reagent_containers/food/snacks/fish) || is_fish_instance) && fish_source.is_limited(fish_source.get_fish_path(reward_path)))
		user.balloon_alert(user, "too strong for the auto reel!")
		complete(FALSE)
		return

	/// Fish minigame properties
	if(ispath(reward_path,/obj/item/reagent_containers/food/snacks/fish) || is_fish_instance)
		var/obj/item/reagent_containers/food/snacks/fish/fish = reward_path
		var/movement_path = initial(fish.fish_movement_type)
		mover = new movement_path(src)
		// Apply fish trait modifiers
		var/list/fish_traits = is_fish_instance ? fish.fish_traits : SSfishing.fish_properties[fish][FISH_PROPERTIES_TRAITS]
		for(var/fish_trait in fish_traits)
			var/datum/fish_trait/trait = GLOB.fish_traits[fish_trait]
			trait.minigame_mod(used_rod, user, src)
	else
		mover = new /datum/fish_movement(src)

	SEND_SIGNAL(src, COMSIG_FISHING_CHALLENGE_MOVER_INITIALIZED, mover)

	if(auto_reel)
		completion *= 1.3
	else
		var/time_left = timeleft(next_phase_timer)
		switch(time_left)
			if(0 to BITING_TIME_WINDOW - 3 SECONDS)
				completion *= 0.65
			if(BITING_TIME_WINDOW - 3 SECONDS to BITING_TIME_WINDOW - 2 SECONDS)
				completion *= 0.82
			if(BITING_TIME_WINDOW - 1 SECONDS to BITING_TIME_WINDOW - 0.5 SECONDS)
				completion *= 1.2
			if(BITING_TIME_WINDOW - 0.5 SECONDS to BITING_TIME_WINDOW)
				completion *= 1.4
	//randomize the position of the fish a little
	fish_position = rand(0, (FISHING_MINIGAME_AREA - fish_height) * 0.8)
	var/diff_dist = 100 + difficulty
	bait_position = clamp(round(fish_position + rand(-diff_dist, diff_dist) - bait_height * 0.5), 0, FISHING_MINIGAME_AREA - bait_height)

	if(!prepare_minigame_hud())
		get_stack_trace("couldn't prepare minigame hud for a fishing challenge.") //just to be sure. This shouldn't happen.
		qdel(src)
		return

	adjust_to_difficulty()
	adjust_to_ping()

	phase = MINIGAME_PHASE
	deltimer(next_phase_timer)
	if((FISHING_MINIGAME_RULE_KILL in special_effects) && (ispath(reward_path,/obj/item/reagent_containers/food/snacks/fish) || is_fish_instance))
		var/obj/item/reagent_containers/food/snacks/fish/fish = reward_path
		var/wait_time = ((initial(fish.max_integrity) * (1 - initial(fish.integrity_failure))) / FISH_DAMAGE_PER_SECOND) SECONDS
		addtimer(CALLBACK(src, PROC_REF(win_anyway)), wait_time, TIMER_DELETE_ME)
	else if(ismovable(reward_path))
		var/atom/movable/reward = reward_path
		if(!fish_source.generated_fish_pool?[reward])
			RegisterSignal(reward, COMSIG_MOVABLE_MOVED, PROC_REF(on_reward_removed))
		if(is_fish_instance)
			RegisterSignal(reward, COMSIG_FISH_STATUS_CHANGED, PROC_REF(on_fish_death))
	start_time = world.time
	fight_time = FISHING_CATCH_BAND_GRACE
	on_fish_time = FISHING_CATCH_BAND_GRACE
	apply_band_tint()
	var/hardness = clamp((difficulty - FISHING_DEFAULT_DIFFICULTY) / (FISHING_MINIGAME_HARD_DIFFICULTY - FISHING_DEFAULT_DIFFICULTY), 0, 1)
	announce_hardness(hardness)
	if(!(special_effects & FISHING_MINIGAME_RULE_NO_ESCAPE))
		var/time_limit = LERP(FISHING_MINIGAME_EASY_TIME, FISHING_MINIGAME_HARD_TIME, hardness)
		minigame_timer = addtimer(CALLBACK(src, PROC_REF(out_of_time)), time_limit, TIMER_STOPPABLE|TIMER_DELETE_ME)

/datum/fishing_challenge/proc/adjust_to_ping()
	if(auto_handling || !user.client)
		return
	var/ping = clamp(user.client.avgping, 0, FISHING_LAG_COMP_MAX_PING)
	lag_seconds = ping / 1000
	ping_speed_mult = clamp(1 - FISHING_PING_SLOWDOWN_PER_100MS * (ping / 100), FISHING_PING_SLOWDOWN_FLOOR, 1)
	reeling_velocity *= ping_speed_mult
	gravity_velocity *= ping_speed_mult
	max_bait_velocity *= ping_speed_mult

/datum/fishing_challenge/proc/record_fish_position(seconds_per_tick)
	fish_history += fish_position
	var/keep = round(lag_seconds / seconds_per_tick) + 1
	if(length(fish_history) > keep)
		fish_history.Cut(1, length(fish_history) - keep + 1)

/datum/fishing_challenge/proc/judged_fish_position()
	return length(fish_history) ? fish_history[1] : fish_position

/// Tells the fisher how hard the fight will be.
/datum/fishing_challenge/proc/announce_hardness(hardness)
	var/line
	if(hardness < FISHING_FIGHT_EASY_HARDNESS)
		line = "This is gonna be easy!"
	else if(hardness < FISHING_FIGHT_FAIR_HARDNESS)
		line = "A fair fight."
	else if(hardness < FISHING_FIGHT_HARD_HARDNESS)
		line = "This is gonna be a difficult catch."
	else
		line = "This one will fight for its life!"
	user.balloon_alert(user, lowertext(line))
	to_chat(user, span_notice(line))

/datum/fishing_challenge/proc/out_of_time()
	if(completed || phase != MINIGAME_PHASE)
		return
	user.balloon_alert(user, "it got away!")
	complete(FALSE)

/datum/fishing_challenge/proc/update_catch_band()
	var/ratio = on_fish_time / fight_time
	var/band = CATCH_BAND_POOR
	if(ratio >= FISHING_CLEAN_CATCH_RATIO)
		band = CATCH_BAND_CLEAN
	else if(ratio >= FISHING_FAIR_CATCH_RATIO)
		band = CATCH_BAND_FAIR
	if(band == catch_band)
		return
	catch_band = band
	apply_band_tint()

/datum/fishing_challenge/proc/apply_band_tint()
	if(QDELETED(fishing_hud))
		return
	switch(catch_band)
		if(CATCH_BAND_CLEAN)
			fishing_hud.hud_completion.color = color_matrix_recolor(FISHING_CLEAN_CATCH_COLOR, FISHING_CATCH_BAND_BRIGHTNESS)
		if(CATCH_BAND_FAIR)
			fishing_hud.hud_completion.color = color_matrix_recolor(FISHING_FAIR_CATCH_COLOR, FISHING_CATCH_BAND_BRIGHTNESS)
		else
			fishing_hud.hud_completion.color = color_matrix_recolor(FISHING_POOR_CATCH_COLOR, FISHING_CATCH_BAND_BRIGHTNESS)

/datum/fishing_challenge/proc/apply_catch_quality(obj/item/reagent_containers/food/snacks/fish/fish)
	switch(catch_band)
		if(CATCH_BAND_CLEAN)
			fish.randomize_size_and_weight(fish.average_size * FISHING_CLEAN_CATCH_SIZE_MULT, fish.average_weight * FISHING_CLEAN_CATCH_SIZE_MULT)
		if(CATCH_BAND_POOR)
			fish.randomize_size_and_weight(fish.average_size * FISHING_POOR_CATCH_SIZE_MULT, fish.average_weight * FISHING_POOR_CATCH_SIZE_MULT)

///Throws a stack with prefixed text.
/datum/fishing_challenge/proc/get_stack_trace(init_text)
	var/text = "[init_text] "
	text += "used rod: [used_rod || "null"], "
	if(used_rod)
		text += "bait: [used_rod.baited || "null"], "
	text += "reward: [reward_path || "null"], "
	text += "user: [user || "null"]"
	if(user)
		if(QDELING(user))
			text += ", user qdeling"
		else if(!user.client)
			text += ", user clientless"
	text += "."
	stack_trace(text)

#undef FISH_DAMAGE_PER_SECOND

///Initialize the minigame hud and register some signals to make it work.
/datum/fishing_challenge/proc/prepare_minigame_hud()
	if(!user.client || user.incapacitated())
		return FALSE
	. = TRUE
	fishing_hud = new
	fishing_hud.prepare_minigame(src)
	RegisterSignal(user.client, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(start_reeling))
	RegisterSignal(user.client, COMSIG_CLIENT_MOUSEUP, PROC_REF(stop_reeling))
	RegisterSignal(user, COMSIG_MOB_LOGOUT, PROC_REF(on_user_logout))
	if(length(active_effects))
		// Give the player a moment to prepare for active minigame effects
		COOLDOWN_START(src, active_effect_cd, rand(5, 9) SECONDS)
	START_PROCESSING(SSfishing, src)

///Stop processing and remove references to the minigame hud
/datum/fishing_challenge/proc/remove_minigame_hud()
	STOP_PROCESSING(SSfishing, src)
	QDEL_NULL(fishing_hud)

///While the mouse button is held down, the bait will be reeling up (or down on r-click if the bidirectional rule is enabled)
/datum/fishing_challenge/proc/start_reeling(client/source, datum/object, location, control, params)
	SIGNAL_HANDLER
	if(auto_handling)
		return
	var/bidirectional = special_effects & FISHING_MINIGAME_RULE_BIDIRECTIONAL
	var/list/modifiers = params2list(params)
	if(bidirectional && LAZYACCESS(modifiers, RIGHT_CLICK))
		reeling_state = REELING_STATE_DOWN
	else
		reeling_state = REELING_STATE_UP

///Reset the reeling state to idle once the mouse button is released
/datum/fishing_challenge/proc/stop_reeling(client/source, datum/object, location, control, params)
	SIGNAL_HANDLER
	if(auto_handling)
		return
	reeling_state = REELING_STATE_IDLE

///Update the state of the fish, the bait and the hud
/datum/fishing_challenge/process(seconds_per_tick)
	if(length(active_effects) && COOLDOWN_FINISHED(src, active_effect_cd))
		select_active_effect()
	mover.move_fish(seconds_per_tick)
	record_fish_position(seconds_per_tick)
	if(auto_handling)
		move_towards_fish(seconds_per_tick)
	move_bait(seconds_per_tick)
	if(!QDELETED(fishing_hud))
		update_visuals(seconds_per_tick)

///The proc that handles fancy effects like flipping the hud or skewing movement
/datum/fishing_challenge/proc/select_active_effect()
	///bring forth an active effect
	if(isnull(current_active_effect))
		current_active_effect = pick(active_effects)
		switch(current_active_effect)
			if(FISHING_MINIGAME_RULE_ANTIGRAV)
				fishing_hud.icon_state = "background_antigrav"
				SEND_SOUND(user, sound('sound/effects/arcade_jump.ogg', volume = 50))
				COOLDOWN_START(src, active_effect_cd, rand(6, 9) SECONDS)
			if(FISHING_MINIGAME_RULE_CAMO)
				fishing_hud.icon_state = "background_camo"
				SEND_SOUND(user, sound('sound/effects/nightmare_poof.ogg', volume = 15))
				COOLDOWN_START(src, active_effect_cd, rand(6, 8) SECONDS)
				animate(fishing_hud.hud_fish, alpha = 7, time = 2 SECONDS)
		return

	///go back to normal
	switch(current_active_effect)
		if(FISHING_MINIGAME_RULE_ANTIGRAV)
			var/sound/inverted_sound = sound('sound/effects/arcade_jump.ogg', volume = 50)
			inverted_sound.frequency = -1
			SEND_SOUND(user, inverted_sound)
			COOLDOWN_START(src, active_effect_cd, rand(10, 13) SECONDS)
		if(FISHING_MINIGAME_RULE_CAMO)
			COOLDOWN_START(src, active_effect_cd, rand(9, 16) SECONDS)
			SEND_SOUND(user, sound('sound/effects/nightmare_reappear.ogg', volume = 15))
			animate(fishing_hud.hud_fish, alpha = 255, time = 1.2 SECONDS)

	fishing_hud.icon_state = background
	current_active_effect = null

///this handles automatically moving the bait towards the fish
/datum/fishing_challenge/proc/move_towards_fish(seconds_per_tick)
	var/bait_center = bait_position + bait_height / 2
	var/fish_center = fish_position + fish_height / 2

	var/distance = fish_center - bait_center
	var/threshold = bait_height * 0.3 // Allow some overlap before adjusting

	if(abs(distance) > threshold)
		if(distance > 0)
			reeling_state = REELING_STATE_UP
		else if(special_effects & FISHING_MINIGAME_RULE_BIDIRECTIONAL)
			reeling_state = REELING_STATE_DOWN
		else
			reeling_state = REELING_STATE_IDLE
	else
		reeling_state = REELING_STATE_IDLE

///The proc that moves the bait around, just like in the old TGUI, mostly.
/datum/fishing_challenge/proc/move_bait(seconds_per_tick)
	var/should_bounce = abs(bait_velocity) > BAIT_MIN_VELOCITY_BOUNCE
	bait_position += bait_velocity * seconds_per_tick
	// Hitting the top bound
	if(bait_position > FISHING_MINIGAME_AREA - bait_height)
		bait_position = FISHING_MINIGAME_AREA - bait_height
		if(reeling_state == REELING_STATE_UP || !should_bounce)
			bait_velocity = 0
		else
			bait_velocity = -bait_velocity * bait_bounce_mult
	// Hitting rock bottom
	else if(bait_position < 0)
		bait_position = 0
		if(reeling_state == REELING_STATE_DOWN || !should_bounce)
			bait_velocity = 0
		else
			bait_velocity = -bait_velocity * bait_bounce_mult

	var/start_pos = bait_position - (bait_velocity * seconds_per_tick)
	var/end_pos = bait_position

	var/min_pos = min(start_pos, end_pos)
	var/max_pos = max(start_pos, end_pos)

	// sweep interval for bait: from min_pos .. max_pos + bait_height
	var/bait_sweep_top = min_pos
	var/bait_sweep_bottom = max_pos + bait_height

	var/fish_top = judged_fish_position()
	var/fish_bottom = fish_top + fish_height

	var/fish_on_bait = (bait_sweep_bottom >= fish_top) && (fish_bottom >= bait_sweep_top)

	var/bidirectional = special_effects & FISHING_MINIGAME_RULE_BIDIRECTIONAL

	var/velocity_change
	switch(reeling_state)
		if(REELING_STATE_UP)
			velocity_change = reeling_velocity
		if(REELING_STATE_DOWN)
			velocity_change = -reeling_velocity
		if(REELING_STATE_IDLE)
			if(!bidirectional || bait_velocity > 0)
				velocity_change = gravity_velocity
			else
				velocity_change = -gravity_velocity
	velocity_change *= (fish_on_bait ? overlap_velocity_mult : 1) * seconds_per_tick

	velocity_change = round(velocity_change)

	if(current_active_effect == FISHING_MINIGAME_RULE_ANTIGRAV)
		velocity_change = -velocity_change

	/**
	 * Pull the brake on the velocity if the current velocity and the acceleration
	 * have different directions, making the bait less slippery, thus easier to control
	 */
	if(bait_velocity > 0 && velocity_change < 0)
		bait_velocity += max(-bait_velocity, velocity_change * deceleration_mult)
	else if(bait_velocity < 0 && velocity_change > 0)
		bait_velocity += min(-bait_velocity, velocity_change * deceleration_mult)

	///bidirectional baits stay bouyant while idle
	if(bidirectional && reeling_state == REELING_STATE_IDLE)
		if(velocity_change < 0)
			bait_velocity = max(bait_velocity + velocity_change, 0)
		else if(velocity_change > 0)
			bait_velocity = min(bait_velocity + velocity_change, 0)
	else
		bait_velocity += velocity_change

	//check that the fish area is still intersecting the bait now that it has moved
	fight_time += seconds_per_tick
	if(fish_on_bait)
		on_fish_time += seconds_per_tick
	update_catch_band()
	if(fish_on_bait)
		completion += completion_gain * seconds_per_tick
		if(completion >= 100)
			complete(TRUE)
	else
		completion -= completion_loss * seconds_per_tick
		if(completion <= 0 && !(special_effects & FISHING_MINIGAME_RULE_NO_ESCAPE))
			user.balloon_alert(user, "it got away!")
			complete(FALSE)

	completion = clamp(completion, 0, 100)
	// Hard cap on bait velocity to prevent runaway speed on laggy or fast ticks
	bait_velocity = clamp(bait_velocity, -max_bait_velocity, max_bait_velocity)

///update the vertical pixel position of both fish and bait, and the icon state of the completion bar
/datum/fishing_challenge/proc/update_visuals(seconds_per_tick)
	var/bait_offset_mult = bait_position / FISHING_MINIGAME_AREA
	animate(fishing_hud.hud_bait, pixel_z = MINIGAME_SLIDER_HEIGHT * bait_offset_mult, time = seconds_per_tick SECONDS)
	var/fish_offset_mult = fish_position / FISHING_MINIGAME_AREA
	animate(fishing_hud.hud_fish, pixel_z = MINIGAME_SLIDER_HEIGHT * fish_offset_mult, time = seconds_per_tick SECONDS)
	fishing_hud.hud_completion.update_state(completion, seconds_per_tick)

///The screen object which bait, fish, and completion bar are visually attached to.
/atom/movable/screen/fishing_hud
	icon = 'icons/hud/fishing_hud.dmi'
	screen_loc = "CENTER+1:8,CENTER:2"
	name = "fishing minigame"
	appearance_flags = APPEARANCE_UI|KEEP_TOGETHER
	///The fish as shown in the minigame
	var/atom/movable/screen/hud_fish/hud_fish
	///The bait as shown in the minigame
	var/atom/movable/screen/hud_bait/hud_bait
	///The completion bar as shown in the minigame
	var/atom/movable/screen/hud_completion/hud_completion

///Initialize bait, fish and completion bar and add them to the visual appearance of this screen object.
/atom/movable/screen/fishing_hud/proc/prepare_minigame(datum/fishing_challenge/challenge)
	icon_state = challenge.background
	add_overlay(challenge.used_rod?.get_frame(challenge) || "frame_wood")
	hud_bait = new(null, null, challenge)
	hud_fish = new(null, null, challenge)
	hud_completion = new(null, null)
	vis_contents += list(hud_bait, hud_fish, hud_completion)
	challenge.user.client.screen += src
	challenge.update_visuals(0) // Set all states to their initial positions so they don't jump around when the game starts
	master_ref = WEAKREF(challenge)

/atom/movable/screen/fishing_hud/Destroy()
	var/datum/fishing_challenge/challenge = master_ref?.resolve()
	if(!isnull(challenge))
		challenge.user.client.screen -= src
	QDEL_NULL(hud_fish)
	QDEL_NULL(hud_bait)
	QDEL_NULL(hud_completion)
	return ..()

/atom/movable/screen/hud_bait
	icon = 'icons/hud/fishing_hud.dmi'
	icon_state = "bait_bottom"
	vis_flags = VIS_INHERIT_ID
	var/cur_height = MINIGAME_BAIT_HEIGHT

/atom/movable/screen/hud_bait/Initialize(mapload, datum/hud/hud_owner, datum/fishing_challenge/challenge)
	. = ..()
	if(!challenge || challenge.bait_pixel_height == MINIGAME_BAIT_HEIGHT)
		vand_update_appearance(UPDATE_OVERLAYS)
		return

	adjust_to_difficulty(challenge)

/atom/movable/screen/hud_bait/proc/adjust_to_difficulty(datum/fishing_challenge/challenge)
	cur_height = challenge.bait_pixel_height
	vand_update_appearance(UPDATE_OVERLAYS)

/atom/movable/screen/hud_bait/update_overlays()
	. = ..()
	var/mutable_appearance/bait_top = mutable_appearance(icon, "bait_top")
	bait_top.pixel_z += cur_height - MINIGAME_BAIT_TOP_AND_BOTTOM_HEIGHT
	. += bait_top
	for (var/i in 1 to (cur_height - MINIGAME_BAIT_TOP_AND_BOTTOM_HEIGHT))
		var/mutable_appearance/bait_bar = mutable_appearance(icon, "bait_bar")
		bait_bar.pixel_z += i
		. += bait_bar

/atom/movable/screen/hud_fish
	icon = 'icons/hud/fishing_hud.dmi'
	icon_state = "fish"
	vis_flags = VIS_INHERIT_ID

/atom/movable/screen/hud_fish/Initialize(mapload, datum/hud/hud_owner, datum/fishing_challenge/challenge)
	. = ..()
	if(challenge)
		icon_state = challenge.fish_icon

/atom/movable/screen/hud_completion
	icon = 'icons/hud/fishing_hud.dmi'
	icon_state = "completion_overlay"
	vis_flags = VIS_INHERIT_ID

/atom/movable/screen/hud_completion/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	add_filter("completion_mask", 1, alpha_mask_filter(icon = icon(icon, "completion_overlay")))

/atom/movable/screen/hud_completion/proc/update_state(completion, seconds_per_tick)
	animate(get_filter("completion_mask"), y = -MINIGAME_COMPLETION_BAR_HEIGHT * (1 - completion * 0.01), time = seconds_per_tick SECONDS)

/// The visual that appears over the fishing spot
/obj/effect/fishing_float
	name = "float"
	icon = 'icons/roguetown/items/fishing.dmi'
	icon_state = "float"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/fishing_float/Initialize(mapload, atom/spot)
	. = ..()
	if(!spot)
		return
	if(ismovable(spot)) // we want the float and therefore the fishing line to stay connected with the fishing spot.
		RegisterSignal(spot, COMSIG_MOVABLE_MOVED, PROC_REF(follow_movable))
	SET_BASE_PIXEL(spot.pixel_x, spot.pixel_y)
	pixel_w = spot.pixel_w
	pixel_z = spot.pixel_z
	// early return for spots with a plane lower than this. the floor plane is topdown and we don't want to inherit their layers.
	if(spot.plane < plane)
		return
	if(spot.plane > plane) //We want this to render above the fishing spot.
		plane = spot.plane
	if(spot.layer > layer) //Ditto. New stuff renders above old stuff if the layer is the same iirc (with some caveats).
		layer = spot.layer

/obj/effect/fishing_float/proc/follow_movable(atom/movable/source)
	SIGNAL_HANDLER

	set_glide_size(source.glide_size)
	forceMove(source.loc)

#undef WAIT_PHASE
#undef BITING_PHASE
#undef MINIGAME_PHASE

#undef MINIGAME_SLIDER_HEIGHT
#undef MINIGAME_BAIT_HEIGHT
#undef MINIGAME_FISH_HEIGHT
#undef MINIGAME_BAIT_TOP_AND_BOTTOM_HEIGHT
#undef MINIGAME_COMPLETION_BAR_HEIGHT

#undef BAIT_HEIGHT_DIFFICULTY_MALUS

#undef REELING_STATE_IDLE
#undef REELING_STATE_UP
#undef REELING_STATE_DOWN

#undef BAIT_MIN_VELOCITY_BOUNCE

#undef MAX_FISH_COMPLETION_MALUS
#undef BITING_TIME_WINDOW
