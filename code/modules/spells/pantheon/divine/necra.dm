#define CHURN_FILTER "churn_glow"

// T1: Avert End (channel on an adjacent target to slowly spend devotion to grant them NODEATH and ticks of oxyloss healing)

/obj/effect/proc_holder/spell/invoked/avert
	name = "Borrowed Time"
	desc = "Shield your fellow man from the Undermaiden's gaze, preventing them from slipping into death for as long as your faith and fatigue may muster."
	overlay_state = "borrowtime"
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	miracle = TRUE
	devotion_cost = 10
	var/list/near_death_lines = list(
		"A haze begins to envelop me, but then suddenly recedes, as if warded back by some great light...",
		"A terrible weight bears down upon me, as if the wyrld itself were crushing me with its heft...",
		"The sound of a placid river drifts into hearing, followed by the ominous toll of a ferryman's bell...",
		"Some vast, immeasurably distant figure looms beyond my perception - I feel it, more than I see. It waits. It watches.",
	)

/obj/effect/proc_holder/spell/invoked/avert/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	var/atom/target = targets[1]
	if (!isliving(target))
		revert_cast()
		return FALSE

	var/mob/living/living_target = target
	if (!user.Adjacent(target))
		to_chat(user, span_warning("I must be beside [living_target] to avert Her gaze from [living_target.p_them()]!"))
		revert_cast()
		return FALSE

	// add the no-death trait to them....
	user.visible_message(span_notice("Whispering motes gently bead from [user]'s fingers as [user.p_they()] place a hand near [living_target], scriptures of the Undermaiden spilling from their lips..."), span_notice("I stand beside [living_target] and utter the hallowed words of Aeon's Intercession, staying Her grasp for just a little while longer..."))
	to_chat(user, span_small("I must remain still and at [living_target]'s side..."))
	to_chat(living_target, span_warning("An odd sensation blossoms in my chest, cold and unknown..."))

	ADD_TRAIT(living_target, TRAIT_NODEATH, "avert_spell")

	var/our_holy_skill = user.get_skill_level(associated_skill)
	var/tickspeed = 30 + (5 * our_holy_skill)

	while (do_after(user, tickspeed, target = living_target))
		user.stamina_add(2.5)

		living_target.adjustOxyLoss(-10)
		living_target.blood_volume = max((BLOOD_VOLUME_SURVIVE * 1.5), living_target.blood_volume)

		if (living_target.health <= 5)
			if (prob(5))
				to_chat(living_target, span_small(pick(near_death_lines)))

		if (user.devotion?.check_devotion(src))
			user.devotion?.update_devotion(-10)
		else
			to_chat(span_warning("My devotion runs dry - the Intercession fades from my lips!"))
			break

	REMOVE_TRAIT(living_target, TRAIT_NODEATH, "avert_spell")

	user.visible_message(span_danger("[user]'s concentration breaks, the motes receding from [living_target] and into [user.p_their()] hand once more."), span_danger("My concentration breaks, and the Intercession falls silent."))

/obj/effect/proc_holder/spell/targeted/abrogation
	name = "Abrogation"
	desc = "Debuffs targeted undead as long as they remain near you, slowly getting set on fire if they stay."
	range = 8
	overlay_state = "necra"
	releasedrain = 30
	chargedloop = /datum/looping_sound/invokeholy
	chargetime = 50
	chargedrain = 0.5
	recharge_time = 30 SECONDS
	max_targets = 0
	cast_without_targets = TRUE
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("The Undermaiden rebukes!")
	invocation_type = "shout" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 20

/obj/effect/proc_holder/spell/targeted/abrogation/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/debuff_power = 1
	if (user && user.mind)
		debuff_power = clamp((user.get_skill_level(/datum/skill/magic/holy) / 2), 1, 3)

	var/too_powerful = FALSE
	var/list/things_to_churn = list()
	var/list/things_to_stun = list()
	for (var/mob/living/L in targets)
		var/is_vampire = FALSE
		var/is_zombie = FALSE
		if(L.stat == DEAD)
			continue
		if (L.mind)
			var/datum/antagonist/vampire/V = L.mind.has_antag_datum(/datum/antagonist/vampire)
			if(V && SEND_SIGNAL(L, COMSIG_DISGUISE_STATUS))
				is_vampire = TRUE
			if (L.mind.has_antag_datum(/datum/antagonist/zombie))
				is_zombie = TRUE
				things_to_stun += L
			if (L.mind.special_role == "Vampire Lord")
				too_powerful = L
				user.visible_message(span_warning("[user] suddenly pales before an unseen presence, and gasps!"), span_warning("The sound of rushing blood fills my ears and mind, drowning out my abrogation!"))
				break
		if (L.mob_biotypes & MOB_UNDEAD || is_vampire || is_zombie)
			things_to_churn += L

	if (!too_powerful)
		if (LAZYLEN(things_to_churn))
			user.visible_message(span_warning("A frigid blue glower suddenly erupts in [user]'s eyes as a whispered prayer summons forth a winding veil of ghostly mists!"), span_notice("I perform the sacred rite of Abrogation, bringing forth Her servants to harry and weaken the unliving!"))
			for(var/mob/living/thing in things_to_churn)
				if(spell_guard_check(thing, TRUE))
					thing.visible_message(span_warning("[thing] resists the abrogation!"))
					things_to_churn -= thing
					continue
				thing.apply_status_effect(/datum/status_effect/churned, user, debuff_power)
		if(LAZYLEN(things_to_stun))
			for(var/mob/living/thing in things_to_churn)
				thing.Stun(100)
				thing.Knockdown(50)
				thing.emote("scream")
		if(!LAZYLEN(things_to_churn))
			to_chat(user, span_notice("The rite of Abrogation passes from my lips in silence, having found nothing to assail."))
			return
	else
		user.Stun(25)
		user.throw_at(get_ranged_target_turf(user, get_dir(user,too_powerful), 7), 7, 1, too_powerful, spin = FALSE)
		user.visible_message(span_warning("[user] ceases their prayer, suddenly choking upon a gout of blood in their throat!"), span_boldwarning("My vision swims in red!"))

/atom/movable/screen/alert/status_effect/churned
	name = "Churning Essence"
	desc = "The magicks that bind me into being are being disrupted! I should get away from the source as soon as I can!"
	icon_state = "stressvb"

/datum/status_effect/churned
	id = "necra_churned"
	alert_type = /atom/movable/screen/alert/status_effect/churned
	duration = 30 SECONDS
	examine_text = "<b>SUBJECTPRONOUN is wreathed in a wild frenzy of ghostly motes!</b>"
	effectedstats = list(STATKEY_STR = -2, STATKEY_CON = -2, STATKEY_WIL = -2, STATKEY_SPD = -2)
	status_type = STATUS_EFFECT_REFRESH
	var/datum/weakref/debuffer
	var/outline_colour = "#33cabc"
	var/base_tick = 0.2
	var/intensity = 1
	var/range = 10

/datum/status_effect/churned/on_creation(mob/living/new_owner, mob/living/caster, potency)
	intensity = potency
	if (caster)
		debuffer = WEAKREF(caster)
	return ..()

/datum/status_effect/churned/on_apply()
	var/filter = owner.get_filter(CHURN_FILTER)
	to_chat(owner, span_warning("Wisps leap from the cloying mists to surround me, their chill disrupting my body! FLEE!"))
	if (!filter)
		owner.add_filter(CHURN_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))
	return TRUE

/datum/status_effect/churned/refresh()
	. = ..()
	intensity += 1
	to_chat(owner, span_boldwarning("The mists intensify, the glowing wisps steadily disrupting my body..."))

/datum/status_effect/churned/process()
	. = ..()
	if (!owner)
		return
	if (prob(33))
		owner.adjustFireLoss(base_tick * intensity)
	if (prob(10))
		to_chat(owner, span_warning("A frenzy of ghostly motes assail my form!"))
		owner.emote("scream")

	var/mob/living/our_debuffer = debuffer.resolve()
	if (get_dist(our_debuffer, owner) > range)
		to_chat(owner, span_notice("I've escaped the cloying mists!"))
		qdel(src)

/datum/status_effect/churned/on_remove()
	owner.remove_filter(CHURN_FILTER)

#undef CHURN_FILTER

#define NECRA_HATES        1
#define NECRA_DISAPPROVES  2
#define NECRA_NEUTRAL      3
#define NECRA_APPROVES     4

/obj/effect/proc_holder/spell/self/locate_dead
	name = "Locate Corpse"
	desc = "Invoke the Undermaiden's guidance to sense the direction of those within her domain who lack proper burial. She may also reveal the earthbound, though seeking those newly claimed risks her displeasure.<br><br>Costs 20 Devotion to use, and the sustain cost varies on corpse freshness."
	overlay_state = "necraeye"
	sound = 'sound/magic/whiteflame.ogg'
	cast_without_targets = TRUE
	miracle = TRUE
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)

/mob/living
	var/mob/living/necra_tracked_corpse = null
	var/last_necra_ping = 0
	var/necra_judgement = 0
	var/necra_score = 0

/proc/get_necra_score(mob/living/carbon/C)
	if(!C || QDELETED(C))
		return 0
	var/score = 0
	var/time_dead = 0
	if(C.timeofdeath)
		time_dead = world.time - C.timeofdeath
	var/minutes_dead = round(time_dead / 600)
	if(minutes_dead < 0)
		minutes_dead = 0
	score += minutes_dead
	var/is_skeleton = istype(C, /mob/living/carbon/human/species/skeleton)
	var/is_player = !!C.client
	var/has_ghost = !!C.get_ghost(FALSE, TRUE)
	var/is_earthbound = (is_player && has_ghost)
	var/is_departed = (is_player && !has_ghost)
	var/is_forsaken = (!is_player)
	if(minutes_dead < 5 && is_earthbound) // fresh + earthbound = VERY BAD
		score -= 15
	if(is_forsaken || is_departed) // forsaken or departed = good, this means it's only 2 minutes till they're valid
		score += 3
	if(is_skeleton) // skeletons start on neutral, unless they're players
		score += 2

	return score

/proc/get_necra_judgement(mob/living/carbon/C)
	var/score = get_necra_score(C)
	if(score <= 0)
		return NECRA_HATES
	if(score <= 5)
		return NECRA_DISAPPROVES
	if(score <= 10)
		return NECRA_NEUTRAL

	return NECRA_APPROVES

var/global/list/_corpse_sort_list = null
var/global/mob/_corpse_sort_ref = null

/proc/_corpse_dist_compare_simple(a, b)
	var/mob/A = _corpse_sort_list[a]
	var/mob/B = _corpse_sort_list[b]

	if(!A || QDELETED(A))
		return 1
	if(!B || QDELETED(B))
		return -1

	var/da = get_dist(_corpse_sort_ref, A)
	var/db = get_dist(_corpse_sort_ref, B)

	if(da < db)
		return -1
	if(da > db)
		return 1
	return 0

/proc/sort_corpse_list_by_distance_simple(var/list/L, var/mob/ref)
	if(!L || !length(L) || !ref)
		return L

	_corpse_sort_list = L
	_corpse_sort_ref = ref

	var/list/keys = list()
	for(var/k in L)
		keys += k

	sortTim(keys, GLOBAL_PROC_REF(_corpse_dist_compare_simple))

	_corpse_sort_list = null
	_corpse_sort_ref = null

	var/list/new_list = list()
	for(var/k in keys)
		new_list[k] = L[k]

	return new_list

/obj/effect/proc_holder/spell/self/locate_dead/cast(mob/living/user = usr)
	. = ..()

	if(user.necra_tracked_corpse)
		to_chat(user, span_notice("The Undermaiden releases your hand."))
		user.necra_tracked_corpse = null
		user.necra_judgement = 0
		user.necra_score = 0
		STOP_PROCESSING(SSprocessing, user)
		revert_cast()
		return

	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.devotion || H.devotion.devotion < 20)
		to_chat(user, span_notice("I don't nearly have enough devotion to sustain this."))
		return

	user.visible_message(
		span_purple("<i>A ghastly fog embraces [user] momentarily as they focus...</i>"),
		span_purple("<i>You plead for the Undermaiden to offer you insight on the restless.</i>")
	)

	var/list/earthbound = list()
	var/list/departed = list()
	var/list/forsaken = list()

	for(var/mob/living/carbon/C in GLOB.mob_list)
		if(!C || QDELETED(C))
			continue

		// --- corpse logic ---
		var/is_dead = (C.stat == DEAD)
		var/is_deadite = FALSE
		if(C.mind)
			is_deadite = C.mind.has_antag_datum(/datum/antagonist/zombie)

		var/is_skeleton = istype(C, /mob/living/carbon/human/species/skeleton)
		var/is_skeleton_valid = (is_skeleton && !(C.mobility_flags & MOBILITY_STAND))
		var/no_burialrites = !C.burialrited

		var/is_corpse = ((is_dead || is_deadite || is_skeleton_valid) && no_burialrites)
		if(!is_corpse)
			continue

		// --- classification ---
		var/has_player_identity = (C.mind && C.mind.key)
		var/has_presence = (C.key || C.get_ghost(FALSE, TRUE))

		var/is_earthbound = FALSE
		var/is_departed = FALSE
		var/is_forsaken = FALSE

		if(has_player_identity)
			if(has_presence)
				is_earthbound = TRUE
			else
				is_departed = TRUE
		else
			is_forsaken = TRUE

		// --- filters ---
		var/time_dead = 0
		if(C.timeofdeath)
			time_dead = world.time - C.timeofdeath

		var/fuhgeddaboutit = (time_dead > 45 MINUTES)
		var/same_z = (C.z == user.z)

		// --- name ---
		var/corpse_name

		if(time_dead < 5 MINUTES)
			corpse_name = "Fresh corpse "
		else if(time_dead < 10 MINUTES)
			corpse_name = "Recently deceased "
		else if(time_dead < 30 MINUTES)
			corpse_name = "Long dead "
		else
			corpse_name = "Forgotten remains "

		var/descriptor_name

		if(istype(C, /mob/living/carbon/human))
			var/list/d_list = C.get_mob_descriptors()

			var/trait_desc = ""
			var/stature_desc = ""

			if(d_list)
				trait_desc = capitalize(build_coalesce_description_nofluff(d_list, C, list(MOB_DESCRIPTOR_SLOT_TRAIT), "%DESC1%"))
				stature_desc = capitalize(build_coalesce_description_nofluff(d_list, C, list(MOB_DESCRIPTOR_SLOT_STATURE), "%DESC1%"))

			descriptor_name = trim("[trait_desc] [stature_desc]")

			if(!length(descriptor_name) || descriptor_name == "()")
				descriptor_name = C.name ? C.name : "Unknown"
		else
			descriptor_name = C.name ? C.name : "Unknown"

		corpse_name += "of \a [descriptor_name]"

		// --- markers ---
		if(is_deadite && C.stat != DEAD)
			corpse_name += " (!!☣︎!!)"
		else if(is_deadite)
			corpse_name += " (☣︎)"
		else if(is_skeleton_valid)
			corpse_name += " (☠)"

		// --- pick list ---
		var/list/target_list = null

		if(is_earthbound)
			target_list = earthbound
		else if(is_departed && !fuhgeddaboutit)
			target_list = departed
		else if(is_forsaken && !fuhgeddaboutit && same_z)
			target_list = forsaken

		if(!target_list)
			continue

		// --- unique key ---
		var/list_key = corpse_name
		var/i = 1
		while(list_key in target_list)
			i++
			list_key = "[corpse_name] ([i])"

		target_list[list_key] = C

	// --- SORT ---
	if(length(earthbound))
		earthbound = sort_corpse_list_by_distance_simple(earthbound, user)
	if(length(departed))
		departed = sort_corpse_list_by_distance_simple(departed, user)
	if(length(forsaken))
		forsaken = sort_corpse_list_by_distance_simple(forsaken, user)

	// --- UI ---
	var/list/type_options = list()
	if(length(earthbound)) type_options += "Earthbound"
	if(length(departed)) type_options += "Departed"
	if(length(forsaken)) type_options += "Forsaken"

	if(!length(type_options))
		to_chat(user, span_purple("You reach out. Nothing answers. The Undermaiden is silent..."))
		return

	var/type_choice = tgui_input_list(user, "What doth thy seek?", "Corpse Type", type_options)
	if(!type_choice || QDELETED(user))
		return

	var/list/selected_list
	switch(type_choice)
		if("Earthbound") selected_list = earthbound
		if("Departed") selected_list = departed
		if("Forsaken") selected_list = forsaken

	if(!length(selected_list))
		return

	var/choice = tgui_input_list(user, "Which body shall I seek?", "Available Bodies", selected_list)
	if(!choice || QDELETED(user))
		return

	var/mob/living/carbon/target = selected_list[choice]
	if(!target || QDELETED(target))
		return

	user.say("#Undermaiden, guide my hand to those who have lost their way...")

	var/score = get_necra_score(target)
	var/judgement = get_necra_judgement(target)

	user.necra_tracked_corpse = target
	user.necra_score = score
	user.necra_judgement = judgement
	user.last_necra_ping = 0

	switch(judgement)
		if(NECRA_HATES)
			to_chat(user, span_purple("<i>You feel utterly scorned as your breath is nearly completely taken away.</i>"))
			user.Jitter(10)
			user.emote("breathgasp")
			user.adjustOxyLoss(40)

		if(NECRA_DISAPPROVES)
			to_chat(user, span_purple("<i>The Undermaiden answers your pleas with clear disapproval.</i>"))
			user.emote("whimper")
			user.Jitter(5)

		if(NECRA_NEUTRAL)
			to_chat(user, span_purple("<i>A cold, indifferent presence answers to your pleas. You feel her hand.</i>"))

		if(NECRA_APPROVES)
			to_chat(user, span_purple("<i>The Undermaiden guides your hand. You can almost feel a smile.</i>"))

	if(H.devotion?.check_devotion(src))
		H.devotion?.update_devotion(-20)

	START_PROCESSING(SSprocessing, user)

/proc/get_nearest_corpse(list/L, atom/ref)
	if(!L || !length(L) || !ref)
		return null

	var/mob/living/carbon/closest = null
	var/min_dist = INFINITY

	for(var/k in L)
		var/mob/living/carbon/C = L[k]
		if(!C || QDELETED(C))
			continue

		var/d = get_dist(ref, C)
		if(d < min_dist)
			min_dist = d
			closest = C

	return closest

/mob/living/process()
	..()

	var/mob/living/carbon/human/H = src

	if(!necra_tracked_corpse || QDELETED(necra_tracked_corpse) || !istype(H))
		src.necra_tracked_corpse = null
		STOP_PROCESSING(SSprocessing, src)
		return

	if(necra_tracked_corpse.burialrited)
		to_chat(src, span_purple("<i>The Undermaiden is seemingly content, you briefly sense your bounty being buried and consecrated.</i>"))
		src.necra_tracked_corpse = null
		STOP_PROCESSING(SSprocessing, src)
		return
	
	if(necra_tracked_corpse?.mind && !necra_tracked_corpse.mind.has_antag_datum(/datum/antagonist/zombie) && necra_tracked_corpse.stat != DEAD)
		to_chat(src, span_purple("<i>The Undermaiden's interest wanes, you briefly sense your bounty back from undeath, alive once more.</i>"))
		src.necra_tracked_corpse = null
		STOP_PROCESSING(SSprocessing, src)
		return

	if(src.stat == DEAD)
		to_chat(src, span_purple("<i>As you hold Her hand, you realize late that you are now directly holding onto it. The Undermaiden mourns your demise.</i>"))
		src.necra_tracked_corpse = null
		STOP_PROCESSING(SSprocessing, src)
		return

	if(src.stat == UNCONSCIOUS)
		to_chat(src, span_purple("<i>As you lose consciousness, your connection to Necra's guidance abruptly breaks!</i>"))
		src.necra_tracked_corpse = null
		STOP_PROCESSING(SSprocessing, src)
		return

	var/score = get_necra_score(necra_tracked_corpse)
	var/judgement = get_necra_judgement(necra_tracked_corpse)

	var/old_judgement = src.necra_judgement
	var/judgement_changed = (old_judgement && old_judgement != judgement)

	src.necra_score = score
	src.necra_judgement = judgement
	
	// --- Devotion cost ---
	var/devotion_cost = 2
	switch(judgement)
		if(NECRA_HATES) devotion_cost = 5
		if(NECRA_DISAPPROVES) devotion_cost = 4
		if(NECRA_NEUTRAL) devotion_cost = 3
		if(NECRA_APPROVES) devotion_cost = 2

	if(!H.devotion || H.devotion.devotion < devotion_cost)
		to_chat(src, span_notice("<i>You let her hand slip. You don't have enough Devotion.</i>"))
		src.necra_tracked_corpse = null
		STOP_PROCESSING(SSprocessing, src)
		return

	// --- Ping delay ---
	var/ping_delay = 3 SECONDS
	switch(judgement)
		if(NECRA_HATES) ping_delay = 18 SECONDS
		if(NECRA_DISAPPROVES) ping_delay = 12 SECONDS
		if(NECRA_NEUTRAL) ping_delay = 6 SECONDS
		if(NECRA_APPROVES) ping_delay = 3 SECONDS

	if(world.time < last_necra_ping + ping_delay)
		return

	last_necra_ping = world.time
	H.devotion.update_devotion(-devotion_cost)

	if(judgement_changed)
		if(judgement > old_judgement)
			to_chat(src, span_blue("<i>The Undermaiden's grip softens and her voice calms… her favor for your choice grows.</i>"))
		else
			to_chat(src, span_red("<i>A sudden chill runs through you. Her judgment worsens for some reason...</i>"))

	var/turf/user_turf = get_turf(src)
	var/turf/target_turf = get_turf(necra_tracked_corpse)

	if(!user_turf || !target_turf)
		return

	var/direction_name = "unknown"

	switch(get_dir(src, necra_tracked_corpse))
		if(NORTH) direction_name = "north"
		if(SOUTH) direction_name = "south"
		if(EAST) direction_name = "east"
		if(WEST) direction_name = "west"
		if(NORTHEAST) direction_name = "northeast"
		if(NORTHWEST) direction_name = "northwest"
		if(SOUTHEAST) direction_name = "southeast"
		if(SOUTHWEST) direction_name = "southwest"
		else direction_name = "here"

	var/z_hint

	if(target_turf.z != user_turf.z)
		z_hint = target_turf.z > user_turf.z ? "above" : "below"

	// NECRA HATES
	if(judgement == NECRA_HATES)
		var/true_dir = dir2text(get_cardinal_dir(src, necra_tracked_corpse))
		var/list/symbols = list("!","$","@","#","%","&","*")

		var/list/noise_words = list(
			"back","forward","run","stop","turn","leave","return","flee","sacrifice","Psydon",
			"heretic","heresy","blasphemy","profane","unworthy","defile","desecrate","ren",
			"fool","insolent","wretch","cur","vermin","filth","failure","disgrace","fortune",
			"die","rot","decay","wither","suffer","bleed","break","choke","drown","song",
			"silence","quiet","hush","listen","obey","kneel","submit","yield","will",
			"lost","blind","empty","hollow","forgotten","forsaken","abandoned","tea",
			"wrong","error","mistake","false","misguided","deceived","doomed","sapphire",
			"liar","traitor","betrayer","coward","weakling","pretender","lych","ansari",
			"where","here","there","nowhere","gone","vanished","deadite","unlyfe","free",
			"watch","seen","marked","judged","condemned","claimed","Noc","devourer","ryon",
			"endure","weep","mourn","grieve","scream","beg","Dendor","Necra","Souls","see you",
			"Xylix","Pestra","Eora","Malum","Astrata","Ravox","Abyssor","Ferryman","spirits","watching"
		)

		var/list/cardinals_pool = list("north","south","east","west","northeast","southeast","northwest","southwest")
		var/list/output = list()

		// build output FIRST
		output += true_dir
		output += true_dir
		output += true_dir

		var/list/cardinals = shuffle(cardinals_pool.Copy())
		for(var/i in 1 to 4)
			output += cardinals[i]

		var/list/noise_pool = shuffle(noise_words.Copy())
		for(var/i in 1 to 6)
			output += noise_pool[i]

		output = shuffle(output)

		// THEN build message with noise
		var/msg = "Ghastly whispers painfully claw at your mind: <br><i>"

		for(var/word in output)
			var/prefix = ""
			for(var/i in 1 to rand(1,6))
				prefix += pick(symbols)

			var/suffix = ""
			for(var/i in 1 to rand(1,8))
				suffix += pick(symbols)

			msg += "[prefix][word][suffix]"

		msg += "</i>"

		to_chat(src, span_warning(msg))
		src.adjustOxyLoss(20)
		if(src.hallucination < 200)
			src.hallucination += 50	
		if(prob(20))
			switch(rand(1,5))
				if(1) // CRITICAL HIIIIT!!!
					H.adjust_fire_stacks(10, /datum/status_effect/fire_handler/fire_stacks/divine)
					H.ignite_mob()
					H.add_stress(/datum/stressevent/psycurse)
					var/list/fire_reactions = list(
						"THIS ISN'T FIRE- WHAT IS THIS?!",
						"IT BURNS THROUGH MY VERY SOUL!",
						"THE FLAME WON'T LET GO!",
						"I CAN'T PUT IT OUT!"
					)
					to_chat(src, span_red(pick(fire_reactions)))
					src.emote("agony")
				if(2)
					src.adjustToxLoss(rand(1, 20))

					var/list/tox_reactions = list(
						"I CAN TASTE IT- SOMETHING IS WRONG!",
						"IT'S IN MY BLOOD!",
						"I'M ROTTING- CAN'T YOU SEE?!",
						"SOMETHING IS EATING ME FROM INSIDE!"
					)
					to_chat(src, span_red(pick(tox_reactions)))
					src.emote("breathgasp")
				if(3)
					src.adjustBruteLoss(rand(10, 20))

					var/list/brute_reactions = list(
						"IT'S TEARING ME APART!",
						"MY BONES- THEY'RE BREAKING!",
						"I CAN FEEL IT RIPPING THROUGH ME!",
						"STOP- YOU'RE PULLING ME TO PIECES!"
					)
					to_chat(src, span_red(pick(brute_reactions)))
					H.add_stress(/datum/stressevent/psycurse)
					src.emote("painscream")
				if(4)
					if(ishuman(src))
						var/list/valid_parts = list()
						for(var/obj/item/bodypart/BP in H.bodyparts)
							if(BP)
								valid_parts += BP

						if(length(valid_parts))
							var/obj/item/bodypart/BP = pick(valid_parts)
							BP.manage_dynamic_wound(BCLASS_LASHING, rand(10, 20), 0)

							var/list/wound_reactions = list(
								"SOMETHING JUST TORE OPEN!",
								"I'M BLEEDING- AM I BLEEDING?!",
								"SHE CUT ME WITHOUT TOUCHING ME!",
								"I'M SORRY, UNDERMAIDEN, I'M SORRY!"
							)
							to_chat(src, span_red(pick(wound_reactions)))
							src.emote("agony")
					else
						src.adjustBruteLoss(rand(15, 25))

						var/list/fallback_reactions = list(
							"MY BODY'S BREAKING APART!",
							"SOMETHING IS WRONG- DEEPLY WRONG!",
							"I CAN'T HOLD MYSELF TOGETHER!",
							"IT HURTS- EVERYWHERE!"
						)
						to_chat(src, span_red(pick(fallback_reactions)))
						src.emote("painscream")
				if(5)
					src.adjustBruteLoss(10)
					src.adjustToxLoss(10)

					var/list/mixed_reactions = list(
						"IT'S EVERYWHERE—IT HURTS EVERYWHERE!",
						"I CAN'T TELL WHERE IT'S COMING FROM!",
						"MAKE IT STOP- PLEASE!",
						"I'M FALLING APART!"
					)
					src.emote("painscream")
					to_chat(src, span_red(pick(mixed_reactions)))

		if(z_hint)
			msg += " <b>([z_hint])</b>"
		msg += "."
		return

	// NECRA DISAPPROVES
	if(judgement == NECRA_DISAPPROVES)
		var/true_dir = direction_name

		var/list/noise_words = list(
			"are you sure?","do you have to?","really?","why?","yae?","where?",
			"are you certain?","is this the right way?","are you lost?","did you forget something?",
			"should you be here?","who told you that?","what are you doing?","why would you go there?",
			"are you being watched?","can you hear me?","do you trust this?","is it safe?",
			"are you alone?","what was that?","did you see that?","are you afraid?",
			"should you turn back?","is that wise?","what if you're wrong?","do you feel it?",
			"why are you hesitating?","what's behind you?","who's there?","are you listening?",
			"do you remember?","have you forgotten?","why keep going?","what are you chasing?",
			"is it worth it?","what if it's a trap?","are you sure about that?","do you doubt yourself?",
			"why this path?","why not another way?","what are you missing?","can you feel her?",
			"does she approve?","are you being judged?","what does she see?","why are you still here?",
			"do you regret this?","should you stop?","are you going the wrong way?","what lies ahead?",
			"what lies behind?","are you too late?","are you too early?","is it watching you?",
			"do you hear the whispers?","are they getting louder?","can you ignore them?",
			"what do they want?","what do you want?","why continue?","why persist?",
			"are you close?","are you far?","does it matter?","are you sure it's not here?",
			"why not turn around?","what if you're mistaken?","is this your choice?",
			"are you being guided?","or misled?","do you understand?","are you certain you do?",
			"what are you becoming?","is this who you are?","should you keep going?"
		)

		var/list/cardinals_pool = list("northeast","southeast","northwest","southwest")
		var/list/output = list()

		for(var/i in 1 to 7)
			if(prob(50))
				output += pick(cardinals_pool)
			else
				output += pick(noise_words)
		output += true_dir
		output += true_dir
		output = shuffle(output)

		var/msg = "A ghastly whisper reaches you: <i><br>"
		for(var/word in output)
			msg += "[word]… "
		msg += "</i>"

		if(z_hint)
			msg += " <b>([z_hint])</b>"
		msg += "."
		to_chat(src, span_warning(msg))
		return

	// NECRA NEUTRAL / APPROVES
	var/dist = get_dist(user_turf, target_turf)

	var/msg = "The Undermaiden guides your hand <b>[direction_name]</b>"

	if(z_hint)
		msg += " <b>([z_hint])</b>"

	if(judgement == NECRA_APPROVES)
		msg += " - <b>[dist]</b> meters"
	
	msg += "."

	to_chat(src, span_warning(msg))

#undef NECRA_HATES
#undef NECRA_DISAPPROVES
#undef NECRA_NEUTRAL
#undef NECRA_APPROVES

/obj/effect/proc_holder/spell/invoked/necra_vow
	name = "Vow to Necra"
	desc = "Make a vow to Necra. Your chances of revival or recovery of limb will be greatly reduced. You will harm undeath and heal yourself at a slow rate."
	range = 1
	overlay_state = "necra"
	releasedrain = 30
	chargedloop = /datum/looping_sound/invokeholy
	chargetime = 50
	chargedrain = 0.5
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("The Undermaiden Protects.")
	invocation_type = "shout"
	miracle = TRUE
	devotion_cost = 100

/obj/effect/proc_holder/spell/invoked/necra_vow/cast(list/targets, mob/living/user = usr)
	if(ishuman(targets[1]))
		var/mob/living/carbon/human/H = targets[1]
		if(HAS_TRAIT(H, TRAIT_ROTMAN) || HAS_TRAIT(H, TRAIT_NOBREATH) || H.mob_biotypes & MOB_UNDEAD)	//No Undead, no Rotcured, no Deathless
			to_chat(user, span_warning("Necra cares not for the vows of the corrupted."))
			revert_cast()
			return FALSE
		if(H.has_status_effect(/datum/status_effect/buff/necras_vow) || H.patron?.type != /datum/patron/divine/necra)
			to_chat(user, span_notice("They have already pledged a vow."))
			revert_cast()
			return FALSE
		var/choice = alert(H, "You are being asked to pledge a vow. Your chances of revival or recovery of limb will be greatly reduced. You will harm undeath and heal yourself at a slow rate. Do you agree?", "VOW", "Yes", "No")
		if(choice != "Yes")
			to_chat(user, span_notice("They declined."))
			return TRUE
		user.visible_message(span_warning("[user] grants [H] the blessing of their promise."))
		to_chat(H, span_warning("I have committed. There is no going back."))
		H.apply_status_effect(/datum/status_effect/buff/necras_vow)
		H.apply_status_effect(/datum/status_effect/buff/healing/necras_vow)

/atom/movable/screen/alert/status_effect/buff/necras_vow
	name = "Vow to Necra"
	desc = "I have pledged a promise to Necra. Undeath shall be harmed or lit aflame if they strike me. Rot will not claim me. Lost limbs can only be restored if they are myne."
	icon_state = "necravow"

#define NECRAVOW_FILTER "necravow_glow"

/datum/status_effect/buff/necras_vow
	var/outline_colour ="#929186" // A dull grey.
	id = "necravow"
	alert_type = /atom/movable/screen/alert/status_effect/buff/necras_vow
	effectedstats = list(STATKEY_CON = 2)
	duration = -1

/datum/status_effect/buff/necras_vow/on_apply()
	. = ..()
	var/filter = owner.get_filter(NECRAVOW_FILTER)
	if (!filter)
		owner.add_filter(NECRAVOW_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))
	ADD_TRAIT(owner, TRAIT_NECRAS_VOW, TRAIT_MIRACLE)
	owner.rot_type = null
	to_chat(owner, span_warning("My limbs feel more alive than ever... I feel whole..."))

/datum/status_effect/buff/necras_vow/on_remove()
	. = ..()
	owner.remove_filter(NECRAVOW_FILTER)
	to_chat(owner, span_warning("My body feels strange... hollow..."))

#undef NECRAVOW_FILTER

/obj/effect/proc_holder/spell/invoked/necras_sight
	name = "Necra's Sight"
	desc = "Mark a psycross or a grave marker, and peer through them."
	releasedrain = 30
	chargetime = 0 SECONDS
	recharge_time = 10 SECONDS
	warnie = "spellwarning"
	invocation_type = "whisper"
	invocations = list("Undermaiden guide my gaze...")
	associated_skill = /datum/skill/magic/holy
	overlay_state = "necraeye"
	miracle = TRUE
	devotion_cost = 30
	range = 1
	var/static/list/whitelisted_objects = list(/obj/structure/gravemarker, /obj/structure/fluff/psycross, /obj/structure/fluff/psycross/copper, /obj/structure/fluff/psycross/crafted, /obj/structure/fluff/psycross/necra/cloth, /obj/structure/fluff/psycross/necra)
	var/list/marked_objects = list()
	var/outline_color = "#4ea1e6"
	var/last_index = 1

/obj/effect/proc_holder/spell/invoked/necras_sight/cast(list/targets, mob/user)
	var/success
	if(isobj(targets[1]))
		var/obj/O = targets[1]
		if((O.type in whitelisted_objects))
			add_to_scry(O, user)
			return TRUE
	if(isturf(targets[1]))
		var/turf/T = targets[1]
		for(var/obj/O in T)
			if((O.type in whitelisted_objects))
				add_to_scry(O, user)
				return TRUE
		if(length(marked_objects))
			success = try_scry(user)
	if(ismob(targets[1]))
		if(length(marked_objects))
			success = try_scry(user)
	if(success)
		return TRUE
	revert_cast()
	return FALSE

#define GRAVE_SPY "grave_spy"

/obj/effect/proc_holder/spell/invoked/necras_sight/proc/try_scry(mob/living/carbon/human/user)
	listclearnulls(marked_objects)
	if(!length(marked_objects))
		return FALSE
// Build a display list: label -> obj
	var/list/choices = list()
	for(var/obj/O as anything in marked_objects)
		choices[marked_objects[O]] = O

	var/choice = input(user, "Which grave shall we peer through?", "") as null|anything in choices
	if(!choice)
		return FALSE

	var/obj/structure/gravemarker/spygrave = choices[choice]
	if(!spygrave)
		return FALSE

	// Add outline filter if missing
	var/filter = spygrave.get_filter(GRAVE_SPY)
	if(!filter)
		spygrave.add_filter(
			GRAVE_SPY,
			2,
			list(
				"type" = "outline",
				"color" = outline_color,
				"alpha" = 200,
				"size" = 1
			)
		)

	// Create scry eye
	var/mob/dead/observer/screye/S = user.scry_ghost()
	if(!S)
		return FALSE

	spygrave.visible_message(span_warning("[spygrave] shimmers with an eerie glow."))
	S.ManualFollow(spygrave)

	user.visible_message(
		span_danger("[user] blinks, [user.p_their()] eyes rolling back into [user.p_their()] head.")
	)

	user.playsound_local(get_turf(user), 'sound/magic/necra_sight.ogg', 80)

	// Cleanup after duration
	addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), 8 SECONDS)

	addtimer(CALLBACK(spygrave, TYPE_PROC_REF(/atom/movable, remove_filter), GRAVE_SPY), 8 SECONDS)

	return TRUE

#undef GRAVE_SPY

/obj/effect/proc_holder/spell/invoked/necras_sight/proc/add_to_scry(obj/O, mob/living/carbon/human/user)
	if(O in marked_objects)
		revert_cast()
		return
	var/holyskill = user.get_skill_level(/datum/skill/magic/holy)
	var/label = input(user, "Name this grave for your sight:", "Mark Holy Object") as text|null
	if(!label || !length(label))
		label = "[O.name]"

// Replace logic when at cap
	if(length(marked_objects) >= holyskill)
		to_chat(user, span_warning("I'm focusing on too many graves already. One slips from my mind..."))

		var/old_obj = marked_objects[last_index]
		marked_objects -= old_obj

		marked_objects[O] = label

		last_index++
		if(last_index > holyskill)
			last_index = 1
		return

	to_chat(user, span_info("I whisper a name and mark the grave for later use..."))
	marked_objects[O] = label

/obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance
	name = "Avenging Spirits"
	desc = "Summon rancorous spirits to tear at an opponent!"
	range = 7
	sound = list('sound/magic/magnet.ogg')
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	releasedrain = 40
	chargetime = 30
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokeholy
	gesture_required = TRUE 
	associated_skill = /datum/skill/magic/holy
	recharge_time = 90 SECONDS
	hide_charge_effect = TRUE
	miracle = TRUE
	devotion_cost = 50
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "vengeful_spirit"
	action_icon_state = "vengeful_spirit"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	invocations = list("Awaken, rancor!!")
	invocation_type = "shout"



/obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance/cast(list/targets, mob/living/user)
	. = ..()

	if(istype(get_area(user), /area/rogue/indoors/ravoxarena))
		to_chat(user, span_userdanger("I reach for outer help, but something rebukes me! This challenge is only for me to overcome!"))
		revert_cast()
		return FALSE

	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(user.dir == SOUTH || user.dir == NORTH)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_turf(user),user)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_step(user, EAST),user)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_step(user, WEST),user)
		else
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_turf(user),user)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_step(user, NORTH),user)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_step(user, SOUTH),user)
		for(var/mob/living/simple_animal/hostile/rogue/spirit_vengeance/swarm in view(2, user))
			swarm.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target) 
		return TRUE
	revert_cast()
	return FALSE

