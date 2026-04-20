//t1, the bends
/obj/effect/proc_holder/spell/invoked/abyssor_bends
	name = "Depth Bends"
	desc = "Drains the targets stamina, unless they worship Abyssor. Also makes them dizzy and blurs their screen."
	overlay_icon = 'icons/mob/actions/abyssormiracles.dmi'
	action_icon = 'icons/mob/actions/abyssormiracles.dmi'
	overlay_state = "bends"
	releasedrain = 15
	chargedrain = 0
	chargetime = 0.75 SECONDS
	range = 15
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/foley/bubb (5).ogg'
	invocations = list("Weight of the deep, crush!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 15
	var/base_fatdrain = 10

/obj/effect/proc_holder/spell/invoked/abyssor_bends/cast(list/targets, mob/user = usr)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		user.visible_message("<font color='yellow'>[user] makes a fist at [target]!</font>")
		if(spell_guard_check(target, TRUE))
			target.visible_message(span_warning("[target] endures the crushing pressure!"))
			return TRUE
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon = target
			if(carbon.patron?.type != /datum/patron/divine/abyssor)
				var/fatdrain = user.get_skill_level(associated_skill) * base_fatdrain
				carbon.stamina_add(fatdrain)
		target.Dizzy(10)
		target.blur_eyes(20)
		target.emote("drown")
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/abyssor_undertow // t1 offbalance someone for 5 seconds if on land, on water, knock them down.
	name = "Undertow"
	desc = "Throws target down if they are on water, otherwise puts them off balance."
	overlay_icon = 'icons/mob/actions/abyssormiracles.dmi'
	action_icon = 'icons/mob/actions/abyssormiracles.dmi'
	overlay_state = "undertow"
	releasedrain = 15
	chargedrain = 0
	chargetime = 0.75 SECONDS
	range = 15
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/misc/undertow.ogg'
	invocations = list("Strangling waters, pull!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 15

/obj/effect/proc_holder/spell/invoked/abyssor_undertow/cast(list/targets, mob/user = usr)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		user.visible_message("<font color='yellow'>[user] raises a hand towards [target]!</font>")
		if(spell_guard_check(target, TRUE))
			target.visible_message(span_warning("[target] stands firm against the undertow!"))
			return TRUE
		var/turf/targettile = get_turf(target)
		if(istype(targettile, /turf/open/water))
			target.Knockdown(10)
		else
			target.OffBalance(50)
		return TRUE
	revert_cast()
	return FALSE


//T0. Stands the character up, if they can stand.
/obj/effect/proc_holder/spell/self/abyssor_wind
	name = "Second Wind"
	desc = "Rise if fallen, regaining some of your stamina."
	overlay_state = "abyssor_wind"
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	sound = 'sound/magic/abyssor_splash.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	invocations = list("What is drowned shall rise anew!")
	invocation_type = "shout"
	recharge_time = 120 SECONDS
	devotion_cost = 30
	miracle = TRUE
	var/stamregenmod = 5	//How many % of stamina we regain after cast, scales with holy skill.

/obj/effect/proc_holder/spell/self/abyssor_wind/cast(list/targets, mob/user)
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.IsStun() || H.IsImmobilized() || H.IsOffBalanced())
		to_chat(user, span_warning("I am too incapacitated!"))
		revert_cast()
		return FALSE
	var/msg = span_warning("[user] ")
	if(H.resting)
		H.set_resting(FALSE, FALSE)
		msg += span_warning("rises and ")
	var/regen = (stamregenmod / 100) * H.get_skill_level(associated_skill)
	H.stamina_add(-(regen * H.max_stamina))
	H.energy_add(regen * H.max_energy)
	msg += span_warning("becomes invigorated!")
	H.visible_message(msg)
	return TRUE

//T0 The Fishing
/obj/effect/proc_holder/spell/invoked/aquatic_compulsion
	name = "Aquatic Compulsion"
	desc = "Compel a random fish to leap out from targeted water tile and towards you. Standing still may yield you continuously, as long as your Devotion and stamina holds. Costs will increase over time."
	overlay_state = "aqua"
	releasedrain = 20
	chargedrain = 0
	range = 6 // so people can appreciate them leaps in fishing events
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/foley/bubb (5).ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 45 SECONDS // still too short
	miracle = TRUE
	devotion_cost = 10
	var/channeling
	//Horrendous carry-over from fishing code
	var/list/fishingMods = list(
		"commonFishingMod" = 0.8,
		"rareFishingMod" = 1,
		"treasureFishingMod" = 0,
		"trashFishingMod" = 0,
		"dangerFishingMod" = 0.1,
		"ceruleanFishingMod" = 0 // 1 on cerulean aril, 0 on everything else
	)

/proc/abyssor_fish_arc(atom/movable/AF, turf/T, mob/user)
	var/turf/user_turf = get_turf(user)

	var/dx_dir = T.x - user_turf.x
	var/dy_dir = T.y - user_turf.y

	var/dir_to_water
	if(abs(dx_dir) > abs(dy_dir))
		dir_to_water = (dx_dir > 0) ? EAST : WEST
	else
		dir_to_water = (dy_dir > 0) ? NORTH : SOUTH

	var/turf/target_turf = get_step(user_turf, dir_to_water) || user_turf

	var/dist = max(1, get_dist(T, target_turf))

	if(dist == 1)
		AF.forceMove(target_turf)
		AF.pixel_x = 0
		AF.pixel_y = 0
		AF.pixel_z = 0
		return

	if(dist <= 0)
		AF.forceMove(user_turf)
		AF.pixel_x = 0
		AF.pixel_y = 0
		AF.pixel_z = 0
		return

	var/dx = (target_turf.x - T.x) * 32
	var/dy = (target_turf.y - T.y) * 32

	var/time_total = max(4, dist * 2)
	var/time_up = round(time_total * 0.25)
	var/time_down = time_total - time_up

	var/arc_height = clamp(dist * 10 + rand(-4, 8), 12, 48)

	if(abs(dx) > abs(dy))
		arc_height *= 1.2

	var/wobble_x = rand(-4, 4)
	var/wobble_y = rand(-4, 4)

	AF.pixel_x = 0
	AF.pixel_y = 0
	AF.pixel_z = 0

	animate(AF,
		pixel_x = (dx * 0.5) + wobble_x,
		pixel_y = (dy * 0.5) + wobble_y,
		pixel_z = arc_height,
		time = time_up,
		easing = QUAD_EASING|EASE_OUT)

	animate(
		pixel_x = dx,
		pixel_y = dy,
		pixel_z = 0,
		time = time_down,
		easing = QUAD_EASING|EASE_IN)

	spawn(time_total)
		if(!AF)
			return
		AF.forceMove(target_turf)
		AF.pixel_x = 0
		AF.pixel_y = 0
		AF.pixel_z = 0

/obj/effect/proc_holder/spell/invoked/aquatic_compulsion/cast(list/targets, mob/user = usr)
	. = ..()
	if(!user || !user.client)
		return 
	var/mob/living/carbon/human/H = user
	var/turf/T = targets[1]

//	to_chat(user, "CAST START")

	if(channeling)
//		to_chat(user, "FAIL: already channeling")
		to_chat(H, span_notice("<i>You are already inducing compulsion upon the abyssals.</i>"))
		revert_cast()
		return FALSE

	if(!isturf(targets[1]))
//		to_chat(user, "FAIL: invalid turf target")
		revert_cast()
		return FALSE

	if(!H)
//		to_chat(user, "FAIL: user not human")
		revert_cast()
		return FALSE

	var/miracleskill = H.get_skill_level(/datum/skill/magic/holy)
//	to_chat(user, "Skill: [miracleskill]")

	channeling = TRUE
	var/streak = 0
	var/delay = clamp(((10 - miracleskill) + streak), 5, 10)

//	to_chat(user, "Initial delay: [delay]")

	to_chat(user, span_blue("<i>[user] makes a beckoning gesture at [T] as a white fog swirls momentarily!</i>"))
	user.say(pick("The Dreamer commands you, splash forth.","By Abyssor's will, spring forth.","Splash forth.","Come hither, abyssals.","Leap in Abyssor's name.","I call to you, denizens of the depths."), language = /datum/language/common)

	// === FIRST INSTANT PULL ===
	if(!H.devotion || H.devotion.devotion < devotion_cost)
//		to_chat(user, "FAIL: not enough devotion ([H.devotion?.devotion])")
		to_chat(H, span_notice("<i>Your connection to the Dreamer is too faint...</i>"))
		H.emote("yawn")
		channeling = FALSE
		revert_cast()
		return FALSE

	var/A = getfishingloot(user, fishingMods, T, 0.5)
	if(!A)
//		to_chat(user, "FAIL: no loot roll")
		to_chat(user, span_warning("The waters remain still."))
		channeling = FALSE
		revert_cast()
		return FALSE

//	to_chat(user, "First pull success: [A]")

	var/atom/movable/AF = new A(T)
	if(!AF)
//		to_chat(user, "FAIL: spawn failed")
		channeling = FALSE
		revert_cast()
		return FALSE

	var/cost = devotion_cost + (streak * (miracleskill/2))
	H.devotion.devotion -= cost
//	to_chat(user, "Devotion spent: [cost], remaining: [H.devotion.devotion]")

	streak++
//	to_chat(user, "Streak now: [streak]")

	AF.pixel_x = 0
	AF.pixel_y = 0
	AF.pixel_z = 0

	spawn(1)
		abyssor_fish_arc(AF, T, user)

	record_featured_stat(FEATURED_STATS_FISHERS, user)
	record_round_statistic(STATS_FISH_CAUGHT)
	playsound(T, 'sound/foley/footsteps/FTWAT_1.ogg', 100)
	teleport_to_dream(user, 10000, 1)

	// === LOOPED PULLING ===
	while(TRUE)
		if(!user || !user.client)
			break // me when I gib myself and crash the server, on god

		delay = clamp(((10 - miracleskill) + streak), 5, 10)
//		to_chat(user, "Loop start | streak=[streak] delay=[delay] devotion=[H.devotion?.devotion]")

		if(!H || !H.devotion || H.devotion.devotion < devotion_cost)
//			to_chat(user, "BREAK: devotion too low ([H?.devotion?.devotion])")
			to_chat(H, span_notice("<i>Your connection to the Dreamer is too faint...</i>"))
			H?.emote("yawn")
			break

		if(!do_after(user, delay SECONDS, target = user))
//			to_chat(user, "BREAK: do_after failed (movement/interruption)")
			to_chat(user, span_warning("Your focus breaks, and Abyssor's pull fades."))
			break

//		to_chat(user, "do_after success")

		var/A2 = getfishingloot(user, fishingMods, T, 0.5)
		if(!A2)
//			to_chat(user, "BREAK: no loot roll")
			to_chat(user, span_warning("The waters remain still."))
			break

//		to_chat(user, "Loop pull success: [A2]")

		var/atom/movable/AF2 = new A2(T)
		if(!AF2)
//			to_chat(user, "BREAK: spawn failed")
			break

		var/cost2 = devotion_cost + (streak * (miracleskill/2))
		H.devotion.devotion -= cost2
//		to_chat(user, "Devotion spent: [cost2], remaining: [H.devotion.devotion]")

		streak++
//		to_chat(user, "Streak now: [streak]")

		AF2.pixel_x = 0
		AF2.pixel_y = 0
		AF2.pixel_z = 0

		spawn(1)
			abyssor_fish_arc(AF2, T, user)

		record_featured_stat(FEATURED_STATS_FISHERS, user)
		record_round_statistic(STATS_FISH_CAUGHT)
		playsound(T, 'sound/foley/footsteps/FTWAT_1.ogg', 100)
		teleport_to_dream(user, 10000, 1)

	// === CLEANUP ===
//	to_chat(user, "CLEANUP: channeling ended at streak=[streak]")

	channeling = FALSE
	return TRUE

//T2, Abyssal Healing. Totally stole most of this from lesser heal.
/obj/effect/proc_holder/spell/invoked/abyssheal
	name = "Abyssal Healing"
	desc = "Heals target over time, more if there is water around you. Weakens if cast away from water for too long"
	overlay_icon = 'icons/mob/actions/abyssormiracles.dmi'
	action_icon = 'icons/mob/actions/abyssormiracles.dmi'
	overlay_state = "deepheal"
	releasedrain = 15
	chargedrain = 0
	chargetime = 0.75 SECONDS
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/foley/waterenter.ogg'
	invocations = list("Healing waters, come forth!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 SECONDS
	miracle = TRUE
	devotion_cost = 45
	var/slickness = 20
	var/max_slickness = 20
	var/max_slickness_greater_caster = 40
	var/base_healing = 6.5

/obj/effect/proc_holder/spell/invoked/abyssheal/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE
		if(user.patron?.undead_hater && (target.mob_biotypes & MOB_UNDEAD))
			// We do nothing to avoid meta checking for undead
			target.visible_message(span_info("A wave of divine energy crashes over [target]!"), span_notice("I'm crushed by healing energies!"))
			return TRUE

		var/conditional_buff = FALSE
		var/situational_bonus = 0
		target.visible_message(span_info("A wave of divine energy crashes over [target]!"), span_notice("I'm crushed by healing energies!"))

		var/list/water = list(/turf/open/water/bath, /turf/open/water/ocean, /turf/open/water/cleanshallow, /turf/open/water/swamp, /turf/open/water/swamp/deep, /turf/open/water/pond, /turf/open/water/river)

		// Calculate situational bonus based on water nearby
		for (var/turf/O in oview(3, user))
			if (is_type_in_list(O, water))
				situational_bonus = min(situational_bonus + 0.1, 2)
		for (var/turf/open/water/ocean/deep/O in oview(3, user))
			situational_bonus += 0.5

		var/holy_skill = user.get_skill_level(associated_skill)
		// It's annoying to have to do a check here -every- time for a one time change, but it's the only way I can think of without a refactor of job systems or spells...
		if(holy_skill > 3)
			max_slickness = max_slickness_greater_caster

		// Update slickness based on situational bonus
		if (situational_bonus > 0)
			slickness = max_slickness
			conditional_buff = TRUE
			to_chat(user, "Calling upon Abyssor's power is easier in these conditions!")

		// Warning messages
		if((slickness / max_slickness) <= 0.5)
			to_chat(user, span_warning("Your connection to Abyssor is weakening. Cast near water to renew it."))

		// Calculate healing based on slickness and situational bonus
		var/healing = max(base_healing * (slickness / max_slickness) + situational_bonus, 3)
		if (situational_bonus == 0)
			slickness = max(0, slickness - 1)

		target.adjustFireLoss(-80)
		if (conditional_buff)
			target.adjustFireLoss(-40)

		target.apply_status_effect(/datum/status_effect/buff/healing, healing)
		return TRUE

	revert_cast()
	return FALSE
//t3 alt, land surf, i just removed it but if this idea is like better... we'll see

//t3, possible t4 if I put in land surf, summon mossback
/obj/effect/proc_holder/spell/invoked/call_mossback
	name = "Call Mossback"
	desc = "Calls a Mossback that is friendly to you and that you can command."
	overlay_icon = 'icons/mob/actions/abyssormiracles.dmi'
	action_icon = 'icons/mob/actions/abyssormiracles.dmi'
	overlay_state = "crab"
	range = 7
	no_early_release = TRUE
	charging_slowdown = 1
	releasedrain = 20
	chargedrain = 0
	chargetime = 4 SECONDS
	chargedloop = null
	sound = 'sound/foley/bubb (1).ogg'
	invocations = list("From the abyss, rise!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 SECONDS
	miracle = TRUE
	devotion_cost = 100
	var/townercrab = TRUE //I was looking at this for three days and i am utterly stupid for not fixing it
	var/mob/living/simple_animal/hostile/retaliate/rogue/mossback/summoned

/obj/effect/proc_holder/spell/invoked/call_mossback/cast(list/targets, mob/living/user)
	. = ..()
	var/turf/T = get_turf(targets[1])
	if(isopenturf(T))
		if(!user.mind.has_spell(/obj/effect/proc_holder/spell/invoked/minion_order))
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
		QDEL_NULL(summoned)
		summoned = new /mob/living/simple_animal/hostile/retaliate/rogue/mossback(T, user, townercrab)
		return TRUE
	else
		to_chat(user, span_warning("The targeted location is blocked. My call fails to draw a mossback."))
		return FALSE

/obj/effect/proc_holder/spell/invoked/call_dreamfiend
	name = "Summon Dreamfiend"
	desc = "Summons a Dreamfiend to hound your target."
	overlay_state = "dreamfiend"
	range = 7
	no_early_release = TRUE
	charging_slowdown = 1
	chargetime = 1.25 SECONDS
	sound = 'sound/foley/bubb (1).ogg'
	invocations = list("From the dream, consume!")
	invocation_type = "shout"
	recharge_time = 300 SECONDS
	miracle = TRUE
	devotion_cost = 150

	// Teleport parameters
	var/inner_tele_radius = 1
	var/outer_tele_radius = 2
	var/include_dense = FALSE
	var/include_teleport_restricted = FALSE

/obj/effect/proc_holder/spell/invoked/call_dreamfiend/cast(list/targets, mob/living/user)
	. = ..()
	var/mob/living/carbon/target = targets[1]
	
	if(!istype(target))
		to_chat(user, span_warning("This spell only works on creatures capable of dreaming!"))
		revert_cast()
		return FALSE
	
	if(!summon_dreamfiend(
		target = target,
		user = user,
		F = /mob/living/simple_animal/hostile/rogue/dreamfiend,
		outer_tele_radius = outer_tele_radius,
		inner_tele_radius = inner_tele_radius,
		include_dense = FALSE,
		include_teleport_restricted = FALSE
	))
		to_chat(user, span_warning("No valid space to manifest the dreamfiend!"))
		revert_cast()
		return FALSE

	return TRUE

/proc/summon_dreamfiend(mob/living/target, mob/living/user, mob/F = /mob/living/simple_animal/hostile/rogue/dreamfiend, outer_tele_radius = 3, inner_tele_radius = 2, include_dense = FALSE, include_teleport_restricted = FALSE)
	var/turf/target_turf = get_turf(target)
	var/list/turfs = list()

	// Reused turf selection logic from blink_to_target
	for(var/turf/T in range(target_turf, outer_tele_radius))
		if(T in range(target_turf, inner_tele_radius))
			continue
		if(istransparentturf(T))
			continue
		if(T.density && !include_dense)
			continue
		if(T.teleport_restricted && !include_teleport_restricted)
			continue
		if(T.x>world.maxx-outer_tele_radius || T.x<outer_tele_radius)
			continue
		if(T.y>world.maxy-outer_tele_radius || T.y<outer_tele_radius)
			continue
		turfs += T

	if(!length(turfs))
		for(var/turf/T in orange(target_turf, outer_tele_radius))
			if(!(T in orange(target_turf, inner_tele_radius)))
				turfs += T

	if(!length(turfs))
		return FALSE

	var/turf/spawn_turf = pick(turfs)
	
	F = new F(spawn_turf)
	F.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
	F.ai_controller.set_blackboard_key(BB_MAIN_TARGET, target)
	F.ai_controller.insert_blackboard_key_lazylist(BB_BASIC_MOB_RETALIATE_LIST, target)

	F.visible_message(span_notice("A [F] manifests following after [target]... countless teeth bared with hostility!"))
	return TRUE

// No chargetime given this can be cast well in advance.
/obj/effect/proc_holder/spell/invoked/abyssal_infusion
	name = "Abyssal Infusion"
	desc = "Consumes an anglerfish to bless a target with ability to call upon Abyssal Strength."
	overlay_state = "abyssal_infusion"
	range = 7
	no_early_release = TRUE
	charging_slowdown = 1
	sound = 'sound/foley/bubb (1).ogg'
	//Each dreamfiend has a different name to call!
	invocations = list("shogg vulgt!")
	invocation_type = "shout"
	recharge_time = 600 SECONDS
	miracle = TRUE
	devotion_cost = 300

/obj/effect/proc_holder/spell/invoked/abyssal_infusion/cast(list/targets, mob/living/user)
	. = ..()
	var/mob/living/carbon/human/target = targets[1]

	if(!istype(target, /mob/living/carbon/human) || target.mind == null)
		to_chat(user, span_warning("This spell only works on creatures capable of dreaming!"))
		revert_cast()
		return FALSE

	if(target == user)
		to_chat(user, span_warning("You must maintain the connection to the dreamfiend from a safe spiritual distance or risk being consumed yourself!"))
		revert_cast()
		return FALSE

	if(target.mind.has_spell(/obj/effect/proc_holder/spell/invoked/abyssal_strength))
		to_chat(user, span_warning("[target] is already blessed with Abyssor's strength."))
		revert_cast()
		return FALSE

	var/anglerfish_found = FALSE
	var/list/held_items = list()

	for(var/obj/item/I in user.held_items)
		held_items += I

	for(var/obj/item/I in held_items)
		if(istype(I, /obj/item/reagent_containers/food/snacks/fish/angler))
			qdel(I)
			anglerfish_found = TRUE
			break

	if(!anglerfish_found)
		to_chat(user, span_warning("An anglerfish is required to channel the abyssal energies!"))
		revert_cast()
		return FALSE

	target.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/abyssal_strength)
	to_chat(target, span_warning("My mind writhes, revealing a new ability."))

	return TRUE

/obj/effect/proc_holder/spell/invoked/abyssal_strength
	name = "Abyssal Strength"
	desc = "Buffs all your stats besides fortune and lowers your perception."
	overlay_state = "abyssal_strength1"
	range = 0
	ignore_los = TRUE // this should probably be a /self spell but its not
	no_early_release = TRUE
	charging_slowdown = 1
	chargetime = 2 SECONDS
	sound = 'sound/foley/bubb (1).ogg'
	//Each dreamfiend has a different name to call!
	invocations = list("shogg vulgt!")
	invocation_type = "shout"
	recharge_time = 750 SECONDS

	var/stage = 1
	var/casts_in_stage = 0
	var/current_stage3_chance = 50
	var/static/list/stage_mobs = list(
		/mob/living/simple_animal/hostile/rogue/dreamfiend,
		/mob/living/simple_animal/hostile/rogue/dreamfiend/major,
		/mob/living/simple_animal/hostile/rogue/dreamfiend/ancient
	)

/obj/effect/proc_holder/spell/invoked/abyssal_strength/cast(list/targets, mob/living/user)
	. = ..()
	var/mob/living/carbon/target = user

	var/list/stats = list(
		"str" = 3 + ((stage - 1) * 1),
		"con" = 1 + (stage * 2),
		"end" = 1 + (stage * 2),
		"fort" = 1 - (stage * 2),
		"speed" = 1 - (stage * 2),
		"per" = -1 * stage
	)

	var/summon_chance = 0
	var/spawn_type
	switch(stage)
		if(1)
			summon_chance = 5 + (casts_in_stage * 35)
			spawn_type = stage_mobs[1]
		if(2)
			summon_chance = 10 + (casts_in_stage * 40)
			spawn_type = stage_mobs[2]
		if(3)
			summon_chance = current_stage3_chance
			current_stage3_chance += rand(1,20)
			spawn_type = stage_mobs[3]

	if(prob(summon_chance))
		summon_dreamfiend(target = user, user = user, F = spawn_type)
		to_chat(user, span_userdanger("You feel the dream manifest in reality, bearing a horrifying form!"))
		user.mind.RemoveSpell(src)
		return

	if(stage < 3)
		casts_in_stage++
		if(casts_in_stage > 2)
			stage++
			casts_in_stage = 0
			if(stage == 3)
				to_chat(user, span_warning("I can feel countless slimy and oozing teeth biting into my skin! Something horrifying is observing me!"))
			else
				to_chat(user, span_warning("The whispers in your head grow louder..."))
	else
		casts_in_stage = min(casts_in_stage + 1, 100)
	
	target.apply_status_effect(
		/datum/status_effect/buff/abyssal,
		stats["str"],
		stats["con"],
		stats["end"],
		stats["fort"],
		stats["speed"],
		stats["per"]
	)

	overlay_state = "abyssal_strength[stage]"

	return TRUE

/atom/movable/screen/alert/status_effect/buff/abyssal
	name = "Abyssal strength"
	desc = "I feel an unnatural power dwelling in my limbs."
	icon_state = "abyssal"

#define ABYSSAL_FILTER "abyssal_glow"

/datum/status_effect/buff/abyssal
	var/dreamfiend_chance = 0
	var/stage = 1
	var/str_buff = 3
	var/con_buff = 3
	var/end_buff = 3
	var/speed_malus = 0
	var/fortune_malus = 0
	var/perception_malus = 0
	var/outline_colour ="#00051f"
	alert_type = /atom/movable/screen/alert/status_effect/buff/abyssal
	examine_text = "SUBJECTPRONOUN has muscles swollen with a strange pale strength."
	id = "abyssal_strength"
	duration = 450 SECONDS

/datum/status_effect/buff/abyssal/on_creation(mob/living/new_owner, new_str, new_con, new_end, new_fort, new_speed, new_per)
	str_buff = new_str
	con_buff = new_con
	end_buff = new_end
	fortune_malus = new_fort
	speed_malus = new_speed
	perception_malus = new_per

	effectedstats = list(
		STATKEY_STR = str_buff,
		STATKEY_CON = con_buff,
		STATKEY_WIL = end_buff,
		STATKEY_LCK = fortune_malus,
		STATKEY_SPD = speed_malus,
		STATKEY_PER = perception_malus
	)
	
	return ..()

/datum/status_effect/buff/abyssal/on_apply()
	. = ..()
	var/filter = owner.get_filter(ABYSSAL_FILTER)
	ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_MIRACLE)
	if (!filter)
		owner.add_filter(ABYSSAL_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 180, "size" = 1))
	to_chat(owner, span_warning("My limbs swell with otherworldly power!"))

/datum/status_effect/buff/abyssal/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_MIRACLE)
	owner.remove_filter(ABYSSAL_FILTER)
	to_chat(owner, span_warning("The strange power fades."))

#undef ABYSSAL_FILTER
