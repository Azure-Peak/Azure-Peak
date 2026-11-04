// float bobbing
#define WAIT_PHASE 1
// Click now to start tgui part
#define BITING_PHASE 2
// UI minigame phase
#define MINIGAME_PHASE 3

/// Reduce initial completion rate depending on difficulty
#define MAX_FISH_COMPLETION_MALUS 15
/// The window of time between biting phase and back to baiting phase
#define BITING_TIME_WINDOW 3 SECONDS

/// The multiplier of how much the difficulty negatively impacts the bait height
#define BAIT_HEIGHT_DIFFICULTY_MALUS 1.3

GLOBAL_LIST_EMPTY(fishing_challenges_by_user)

/datum/fishing_challenge
	/// When the ui minigame phase started
	var/start_time
	/// Is it finished (either by win/lose or window closing)
	var/completed = FALSE
	/// Rule modifiers (eg weighted bait)
	var/special_effects = NONE
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
	/// Background icon state from /datum/asset/spritesheet/fishing_hud
	var/background = "background_default"
	/// Fish icon state from /datum/asset/spritesheet/fishing_hud
	var/fish_icon = FISH_ICON_DEF

	/// Fishing line visual
	var/datum/beam/fishing_line

	var/experience_multiplier = 1

	/// How much space the fish takes on the minigame slider
	var/fish_height = 50
	/// How much space the bait takes on the minigame slider
	var/bait_height = 360
	/// The starting position of the fish on the minigame slider
	var/fish_position = 0
	/// The starting position of the bait on the minigame slider
	var/bait_position = 0

	/// The starting completion score. If it reaches 100, it's a win. If it reaches 0, it's a loss.
	var/completion = 30
	/// How much completion is lost per second when the bait area is not intersecting with the fish's
	var/completion_loss = 6
	/// How much completion is gained per second when the bait area is intersecting with the fish's
	var/completion_gain = 5

	var/datum/fish_movement/mover

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

	///Keep track of the fish source from which we're pulling the reward
	var/datum/fish_source/fish_source
	///this is basically our "idle variable"
	var/auto_handling = FALSE

	/// CATCH_BAND_* judged from how long the bait spent on the fish. This sets the roll for the catch's quality.
	var/catch_band = CATCH_BAND_CLEAN
	/// Timer that lets the fish go when the minigame runs too long
	var/minigame_timer
	/// Whether the fisher is already reeling in to give up
	var/stopping = FALSE
	/// Add a time limit before it get away. Counted from when the UI is ready
	var/time_limit

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
	bait_height *= rod.bait_height_mult
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

/datum/fishing_challenge/proc/on_client_mousedown(client/source, atom/object, turf/location, control, params)
	SIGNAL_HANDLER
	send_right_mouse_event(params, "byond/rightmousedown")

/datum/fishing_challenge/proc/on_client_mouseup(client/source, atom/object, turf/location, control, params)
	SIGNAL_HANDLER
	send_right_mouse_event(params, "byond/rightmouseup")

/datum/fishing_challenge/proc/send_right_mouse_event(params, event)
	if(completed || phase != MINIGAME_PHASE)
		return
	var/list/modifiers = params2list(params)
	if(!LAZYACCESS(modifiers, RIGHT_CLICK))
		return
	var/datum/tgui/ui = SStgui.get_open_ui(user, src)
	ui?.window.send_message(event)

/// Challenge interrupted by something external
/datum/fishing_challenge/proc/interrupt()
	if(!completed)
		experience_multiplier *= 0.5
		complete(FALSE)

/datum/fishing_challenge/proc/on_attack_self(obj/item/source, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(stop_fishing), source, user)

/datum/fishing_challenge/proc/stop_fishing(obj/item/rod, mob/user)
	if(stopping)
		return
	stopping = TRUE
	if(phase == MINIGAME_PHASE)
		to_chat(user, span_warning("Not worth my time. Reeling it in."))
	if((phase != MINIGAME_PHASE || do_after(user, 2 SECONDS, target = rod)) && !QDELETED(src) && !completed)
		experience_multiplier *= 0.5
		send_alert("stopped fishing")
		complete(FALSE)
		return
	stopping = FALSE

///The multiplier of the fishing experience malus if the user's level is substantially above the difficulty.
#define EXPERIENCE_MALUS_MULT 0.08

/datum/fishing_challenge/proc/complete(win = FALSE)
	if(completed)
		return
	deltimer(next_phase_timer)
	deltimer(minigame_timer)
	completed = TRUE
	if(user?.client)
		UnregisterSignal(user.client, list(COMSIG_CLIENT_MOUSEDOWN, COMSIG_CLIENT_MOUSEUP))

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

/datum/fishing_challenge/proc/adjust_to_difficulty()
	mover.adjust_to_difficulty()
	bait_height -= round(difficulty * BAIT_HEIGHT_DIFFICULTY_MALUS)
	experience_multiplier += difficulty * 0.015

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
		var/bite_elapsed = BITING_TIME_WINDOW - timeleft(next_phase_timer)
		if(bite_elapsed < 1 SECONDS)
			completion *= 0.82
		else if(bite_elapsed >= 2.5 SECONDS)
			completion *= 1.2
		else if(bite_elapsed >= 2 SECONDS)
			completion *= 1.4
	//randomize the position of the fish a little
	fish_position = rand(0, (FISHING_MINIGAME_AREA - fish_height) * 0.8)
	var/diff_dist = 100 + difficulty
	bait_position = clamp(round(fish_position + rand(-diff_dist, diff_dist) - bait_height * 0.5), 0, FISHING_MINIGAME_AREA - bait_height)

	if(!user.client || user.incapacitated())
		get_stack_trace("couldn't open the minigame ui for a fishing challenge.") //just to be sure. This shouldn't happen.
		qdel(src)
		return

	adjust_to_difficulty()

	phase = MINIGAME_PHASE
	deltimer(next_phase_timer)
	if((special_effects & FISHING_MINIGAME_RULE_KILL) && (ispath(reward_path,/obj/item/reagent_containers/food/snacks/fish) || is_fish_instance))
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
	RegisterSignal(user, COMSIG_MOB_LOGOUT, PROC_REF(on_user_logout))
	if(special_effects & FISHING_MINIGAME_RULE_BIDIRECTIONAL)
		RegisterSignal(user.client, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(on_client_mousedown))
		RegisterSignal(user.client, COMSIG_CLIENT_MOUSEUP, PROC_REF(on_client_mouseup))
	INVOKE_ASYNC(src, TYPE_PROC_REF(/datum, ui_interact), user)
	var/hardness = clamp((difficulty - FISHING_DEFAULT_DIFFICULTY) / (FISHING_MINIGAME_HARD_DIFFICULTY - FISHING_DEFAULT_DIFFICULTY), 0, 1)
	announce_hardness(hardness)
	if(!(special_effects & FISHING_MINIGAME_RULE_NO_ESCAPE))
		time_limit = LERP(FISHING_MINIGAME_EASY_TIME, FISHING_MINIGAME_HARD_TIME, hardness)
		addtimer(CALLBACK(src, PROC_REF(start_time_limit)), FISHING_UI_READY_GRACE, TIMER_DELETE_ME)

/datum/fishing_challenge/proc/start_time_limit()
	if(completed || minigame_timer || !time_limit)
		return
	minigame_timer = addtimer(CALLBACK(src, PROC_REF(out_of_time)), time_limit, TIMER_STOPPABLE|TIMER_DELETE_ME)

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
	user.balloon_alert(user, LOWERT_TEXT(line))
	to_chat(user, span_notice(line))

/datum/fishing_challenge/proc/out_of_time()
	if(completed || phase != MINIGAME_PHASE)
		return
	user.balloon_alert(user, "it got away!")
	complete(FALSE)

/datum/fishing_challenge/proc/judge_catch_band(fight_time, on_fish_time)
	fight_time = max(fight_time, 0)
	on_fish_time = clamp(on_fish_time, 0, fight_time)
	var/ratio = (on_fish_time + FISHING_CATCH_BAND_GRACE) / (fight_time + FISHING_CATCH_BAND_GRACE)
	if(ratio >= FISHING_CLEAN_CATCH_RATIO)
		catch_band = CATCH_BAND_CLEAN
	else if(ratio >= FISHING_FAIR_CATCH_RATIO)
		catch_band = CATCH_BAND_FAIR
	else
		catch_band = CATCH_BAND_POOR

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

/datum/fishing_challenge/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Fishing")
		ui.set_autoupdate(FALSE)
		ui.set_mouse_hook(TRUE)
		ui.open()

/datum/fishing_challenge/ui_state(mob/user)
	return GLOB.always_state

// Manually closing the ui is treated as lose
/datum/fishing_challenge/ui_close(mob/user)
	. = ..()
	if(!completed)
		send_alert("stopped fishing")
		complete(FALSE)

/datum/fishing_challenge/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet/fishing_hud))

/datum/fishing_challenge/ui_static_data(mob/user)
	var/list/data = list()
	data["difficulty"] = difficulty
	data["background"] = background
	data["frame"] = used_rod?.frame_state || "frame_wood"
	data["fish_icon"] = fish_icon
	data["fish_height"] = fish_height
	data["fish_position"] = fish_position
	data["bait_height"] = bait_height
	data["base_bait_height"] = initial(bait_height)
	data["bait_position"] = bait_position
	data["completion"] = completion
	data["completion_gain"] = completion_gain
	data["completion_loss"] = completion_loss
	data["gravity_velocity"] = gravity_velocity
	data["reeling_velocity"] = reeling_velocity
	data["max_bait_velocity"] = max_bait_velocity
	data["bait_bounce_mult"] = bait_bounce_mult
	data["deceleration_mult"] = deceleration_mult
	data["overlap_velocity_mult"] = overlap_velocity_mult
	data["auto_reel"] = auto_handling
	data["bidirectional"] = !!(special_effects & FISHING_MINIGAME_RULE_BIDIRECTIONAL)
	data["no_escape"] = !!(special_effects & FISHING_MINIGAME_RULE_NO_ESCAPE)
	var/list/effects = list()
	if(special_effects & FISHING_MINIGAME_RULE_ANTIGRAV)
		effects += "antigrav"
	if(special_effects & FISHING_MINIGAME_RULE_CAMO)
		effects += "camo"
	data["active_effects"] = effects
	data["mover"] = mover.get_ui_data()
	data["catch_band_grace"] = FISHING_CATCH_BAND_GRACE
	data["clean_catch_ratio"] = FISHING_CLEAN_CATCH_RATIO
	data["fair_catch_ratio"] = FISHING_FAIR_CATCH_RATIO
	return data

/datum/fishing_challenge/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(phase != MINIGAME_PHASE || completed)
		return

	switch(action)
		if("ready")
			start_time_limit()
		if("win")
			judge_catch_band(text2num(params["fight_time"]), text2num(params["on_fish_time"]))
			complete(win = TRUE)
		if("lose")
			user.balloon_alert(user, "it got away!")
			complete(win = FALSE)
		if("effect")
			play_effect_sound(params["effect"], text2num(params["active"]))
	return TRUE

///Active minigame effects run in the ui, which tells us when to play their sounds
/datum/fishing_challenge/proc/play_effect_sound(effect, active)
	switch(effect)
		if("antigrav")
			var/sound/jump_sound = sound('sound/effects/arcade_jump.ogg', volume = 50)
			if(!active)
				jump_sound.frequency = -1
			SEND_SOUND(user, jump_sound)
		if("camo")
			SEND_SOUND(user, sound(active ? 'sound/effects/nightmare_poof.ogg' : 'sound/effects/nightmare_reappear.ogg', volume = 15))

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

#undef BAIT_HEIGHT_DIFFICULTY_MALUS
#undef MAX_FISH_COMPLETION_MALUS
#undef BITING_TIME_WINDOW
