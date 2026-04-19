////////
//ZIZO//
////////

/proc/execute_rite(atom/source, mob/living/leader, ritual_length = 4, max_cultists = 5, silent = FALSE)
	if(!leader || QDELETED(source))
		return FALSE

	// GATHER CABALISTS
	var/list/mob/living/cabalists = list()
	var/list/mob/living/participants = list()

	for(var/mob/living/M in range(1, source))
		if(HAS_TRAIT(M, TRAIT_CABAL) && M.stat == CONSCIOUS)
			cabalists += M

	// Always include leader if valid
	if(!(leader in cabalists) && HAS_TRAIT(leader, TRAIT_CABAL))
		cabalists += leader

	if(!length(cabalists))
		to_chat(leader, span_warning("None nearby can answer the rite."))
		return FALSE

	// CONSENT PHASE (7s timeout)
	var/list/responders = list()

	for(var/mob/living/M in cabalists)
		spawn()
			var/choice = alert(M, "Do you wish to contribute to the rite?", "Ritual Invocation", "Yes", "No")
			if(choice == "Yes")
				responders += M

	sleep(7 SECONDS)

	// Clamp participants
	for(var/mob/living/M in responders)
		if(length(participants) >= max_cultists)
			break
		if(QDELETED(M) || M.stat != CONSCIOUS)
			continue
		participants += M

	if(!(leader in participants))
		participants += leader

	if(!length(participants))
		to_chat(leader, span_warning("The rite finds no willing voices."))
		return FALSE

	// CHANT PHASE
	var/list/chant_lines = list(
		"Ol sonf vorsg-hoath iaida.",
		"Zirdo madriax, soba lonshi.",
		"Faxs to faxs-athan velor.",
		"Ph'nglui mglw'nafh.",
		"R'lyeh wgah'nagl fhtagn.",
		"ZIZO! HEAR US!",
		"ZIZO! ZIZO! ZIZO!",
	)

	var/list/silent_chant_lines = list(
		"#Ol sonf vorsg-hoath iaida.",
		"#Zirdo madriax, soba lonshi.",
		"#Faxs to faxs-athan velor.",
		"#Ph'nglui mglw'nafh.",
		"#R'lyeh wgah'nagl fhtagn.",
		"#ZIZO! HEAR US!",
		"#ZIZO! ZIZO! ZIZO!",
	)

	var/phases = ritual_length
	var/list/datum/beam/active_beams = list()

	for(var/phase in 1 to phases)
		// Chant
		for(var/mob/living/P in participants)
			if(silent)
				P.say(silent_chant_lines[min(phase, length(silent_chant_lines))], forced = "rite invocation", ignore_spam = TRUE)
			else
				P.say(chant_lines[min(phase, length(chant_lines))], forced = "rite invocation", ignore_spam = TRUE)

		// Visual beams (optional but consistent with TP)
		var/turf/T = get_turf(source)
		for(var/mob/living/P in participants)
			active_beams += T.Beam(P, icon_state = "b_beam", time = 5 SECONDS, maxdistance = 10)

		// Pain / cost (light, reusable)
		for(var/mob/living/P in participants)
			P.adjustBruteLoss(10)
			if(prob(30) && !(HAS_TRAIT(P, TRAIT_NOPAIN)))
				P.emote("painscream")

		// Channel time
		if(!do_after(leader, 5 SECONDS, target = source))
			to_chat(leader, span_warning("The rite collapses before completion."))
			for(var/datum/beam/B in active_beams)
				B.End()
			return FALSE

	// Cleanup beams
	for(var/datum/beam/B in active_beams)
		B.End()

	return TRUE

/obj/effect/proc_holder/spell/invoked/rituos/proc/grant_poke_spell(mob/living/carbon/human/user)
	var/list/poke_options = list("Spitfire", "Frost Bolt", "Arc Bolt", "Gravel Blast", "Stygian Efflorescence", "Arcyne Lance")
	var/poke_choice = tgui_input_list(user, "Choose your offensive cantrip.", "Arcyne Awakening", poke_options)
	if(!poke_choice || !user.mind)
		return
	switch(poke_choice)
		if("Spitfire")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
		if("Frost Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/frost_bolt)
		if("Arc Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arc_bolt)
		if("Gravel Blast")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/gravel_blast)
		if("Stygian Efflorescence")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/stygian_efflorescence)
		if("Arcyne Lance")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_lance)

/datum/action/cooldown/spell/bonemend // note should work like conjure arcyne ward
	name = "Bone Mend"
	desc = "A necromantic Arcyne spell that attempts to repair skeletons around you through the use of bones, or limbs on the ground."
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "churn_living"
	associated_skill = /datum/skill/magic/holy
	click_to_activate = FALSE
	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR
	charge_required = FALSE
	cooldown_time = 45 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/bonemend/cast(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/user = owner
	if(!user)
		return FALSE

	var/list/targets = list()

	for(var/mob/living/carbon/human/H in view(5, user))
		if(H.mob_biotypes & MOB_UNDEAD)
			targets += H

	if(user.mob_biotypes & MOB_UNDEAD)
		targets |= user

	if(!targets.len)
		to_chat(user, span_warning("No undead nearby to mend."))
		return FALSE

	var/list/nearby_parts = list()
	var/list/bones = list()

	for(var/obj/item/I in view(2, user))
		if(istype(I, /obj/item/bodypart))
			var/obj/item/bodypart/BP = I
			if(BP.skeletonized)
				nearby_parts += BP

		else if(istype(I, /obj/item/bone) || istype(I, /obj/item/natural/bundle/bone))
			bones += I

	var/attached_count = 0

	for(var/mob/living/carbon/human/H in targets)
		if(!H || QDELETED(H))
			continue

		var/list/missing_limbs = H.get_missing_limbs()
		if(!missing_limbs.len)
			continue

		for(var/obj/item/bodypart/limb in nearby_parts.Copy())
			if(!(limb.body_zone in missing_limbs))
				continue

			if(!limb.skeletonized)
				continue

			if(limb.owner && limb.owner != H)
				continue

			if(H.get_bodypart(limb.body_zone))
				continue

			if(limb.attach_limb(H))
				nearby_parts -= limb
				missing_limbs -= limb.body_zone

				H.visible_message(
					span_boldwarning("The bones of [limb] jerk and snap into place on [H]!"),
					span_notice("A limb reattaches itself to your body.")
				)

				attached_count++
			else
				to_chat(user, span_warning("Failed to attach [limb]"))

		for(var/zone in missing_limbs.Copy())
			if(bones.len < 2)
				break

			var/obj/item/B1 = bones[1]
			var/obj/item/B2 = bones[2]

			bones -= B1
			bones -= B2

			qdel(B1)
			qdel(B2)

			var/obj/item/bodypart/new_limb = null
			switch(zone)
				if(BODY_ZONE_L_ARM)
					new_limb = new /obj/item/bodypart/l_arm
				if(BODY_ZONE_R_ARM)
					new_limb = new /obj/item/bodypart/r_arm
				if(BODY_ZONE_L_LEG)
					new_limb = new /obj/item/bodypart/l_leg
				if(BODY_ZONE_R_LEG)
					new_limb = new /obj/item/bodypart/r_leg

			if(!new_limb)
				continue

			new_limb.skeletonize(FALSE)

			if(new_limb.attach_limb(H))
				H.visible_message(
					span_boldwarning("Loose bones twist and fuse into a new limb on [H]!"),
					span_notice("A new skeletal limb forms and binds to you.")
				)

				attached_count++
			else
				qdel(new_limb)

		H.update_body()

	if(attached_count)
		playsound(user.loc, 'sound/magic/swap.ogg', 50, FALSE)
		to_chat(user, span_notice("Bone answers your call."))
	else
		to_chat(user, span_warning("The bones lie still. Nothing answers your call."))

	return TRUE
	
////////////
//MATTHIOS//
////////////

//Mammonite Utils
#define MAMMON_FILTER "mammon_glow"
/proc/remove_mammons_from_atom(atom/A, amount)
	if(!A || amount <= 0)
		return 0

	var/remaining = amount
	var/list/coins = list()

	collect_coins_recursive(A, coins)

	coins = sortTim(coins, /proc/cmp_coin_value_desc)

	for(var/obj/item/roguecoin/C in coins)
		if(remaining <= 0)
			break

		if(QDELETED(C))
			continue

		var/value_per = C.sellprice
		if(value_per <= 0)
			continue

		var/max_value = value_per * C.quantity

		if(max_value <= remaining)
			remaining -= max_value
			qdel(C)
		else
			var/coins_to_remove = ceil(remaining / value_per)
			coins_to_remove = min(coins_to_remove, C.quantity)

			C.set_quantity(C.quantity - coins_to_remove)

			if(C.quantity <= 0)
				qdel(C)

			remaining = 0

	return amount - remaining

/proc/collect_coins_recursive(atom/A, list/out)
	for(var/atom/movable/AM in A.contents)
		if(istype(AM, /obj/item/roguecoin))
			out += AM
		if(AM.contents && length(AM.contents))
			collect_coins_recursive(AM, out)

/proc/cmp_coin_value_desc(obj/item/roguecoin/A, obj/item/roguecoin/B)
	return B.sellprice - A.sellprice

/atom/movable/screen/alert/status_effect/buff/mammonite
	name = "Mammonite Strike"
	desc = "My next strike is empowered by wealth."
	icon_state = "buff"

/datum/status_effect/buff/mammonite
	id = "mammonite"
	alert_type = /atom/movable/screen/alert/status_effect/buff/mammonite
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	var/bonus_damage = 0

/datum/status_effect/buff/mammonite/on_apply()
	. = ..()

	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	RegisterSignal(owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))

	owner.add_filter(MAMMON_FILTER, 2, list(
		"type" = "outline",
		"color" = "#d4af37",
		"alpha" = 175,
		"size" = 2
	))

/datum/status_effect/buff/mammonite/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_ITEM_ATTACK, COMSIG_HUMAN_MELEE_UNARMED_ATTACK))
	owner.remove_filter(MAMMON_FILTER)
	. = ..()

/datum/status_effect/buff/mammonite/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(source != owner || !isliving(target) || target.stat == DEAD)
		return
	INVOKE_ASYNC(src, PROC_REF(resolve_attack), target, weapon)
	return COMPONENT_ITEM_NO_ATTACK

/datum/status_effect/buff/mammonite/proc/on_unarmed_attack(mob/living/source, atom/target, proximity) 
	SIGNAL_HANDLER 
	if(!isliving(target) || target == owner) 
		return 
	var/mob/living/L = target 
	if(L.stat == DEAD) 
		return
	INVOKE_ASYNC(src, PROC_REF(resolve_attack), L, null)
	return COMPONENT_HAND_NO_ATTACK

//Mammonite Jakk
/datum/status_effect/buff/mammonite/proc/resolve_attack(mob/living/target, obj/item/weapon)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(target))
		return
	var/damage = calculate_damage()
	var/npc_mult = (!target.mind) ? 2 : 1
	var/apen = damage * 0.75

	arcyne_strike(
		owner,
		target,
		weapon,
		damage,
		owner.zone_selected,
		BCLASS_SMASH,
		apen,
		"Mammonite",
		FALSE,
		FALSE,
		FALSE,
		BRUTE,
		npc_mult,
		1
	)
	owner.visible_message(
		span_danger("[owner]'s strike crashes down with the weight of greed!"),
		span_notice("My investment pays off in full!")
	)
	mammon_coin_burst(get_turf(target))
	playsound(get_turf(target), 'sound/combat/hits/burn (2).ogg', 60, TRUE)

	consume()

/datum/status_effect/buff/mammonite/proc/calculate_damage()
	return bonus_damage

/datum/status_effect/buff/mammonite/proc/consume()
	if(owner)
		playsound(get_turf(owner), 'sound/magic/antimagic.ogg', 20, TRUE)
		playsound(get_turf(owner), 'sound/misc/coininsert.ogg', 40, TRUE)
		playsound(get_turf(owner), 'sound/effects/matth_barter.ogg', 40, TRUE)
		owner.remove_status_effect(/datum/status_effect/buff/mammonite)

/proc/mammon_coin_burst(turf/T)
	if(!T)
		return
	for(var/i = 3 to 8)
		var/obj/effect/temp_visual/coinburst/C = new(T)
		C.pixel_x = rand(-8, 8)
		C.pixel_y = rand(-8, 8)

/obj/effect/temp_visual/coinburst
	icon = 'icons/roguetown/items/valuable.dmi'
	icon_state = "g1"
	layer = ABOVE_MOB_LAYER
	duration = 6

/obj/effect/temp_visual/coinburst/Initialize()
	. = ..()

	var/matrix/M = matrix()
	M.Scale(0.25, 0.25) // 25% size

	transform = M

	animate(src,
		pixel_x = pixel_x + rand(-16,16),
		pixel_y = pixel_y + rand(8,20),
		alpha = 0,
		time = duration,
		easing = EASE_OUT
	)

#undef MAMMON_FILTER 

//Skulduggery Utils

/atom/movable/screen/alert/status_effect/buff/skulduggery 
	name = "Skulduggery" 
	desc = span_notice("I prepare to slip inside attacks and punish aggressors, like a true Free Man would.") 
	icon_state = "clash"

/datum/status_effect/buff/skulduggery
	id = "skulduggery"
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/skulduggery
	status_type = STATUS_EFFECT_REFRESH
	var/mob/living/carbon/human/grappled
	var/waiting_followup = FALSE
	var/list/grapple_counts = list() // free grapple can only happen twice vs players
	var/parries_left = 0 // only got X free parries based on miracle level
	tick_interval = 1 SECONDS

/datum/status_effect/buff/skulduggery/on_creation(mob/living/new_owner, ...)
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_BEING_ATTACKED, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ATTACKED_BY_HAND, PROC_REF(process_Wfist))
	RegisterSignal(new_owner, COMSIG_LIVING_STATUS_STUN, PROC_REF(on_incapacitate))
	RegisterSignal(new_owner, COMSIG_LIVING_STATUS_KNOCKDOWN, PROC_REF(on_incapacitate))

	parries_left = new_owner.get_skill_level(/datum/skill/magic/holy)
	. = ..()

/datum/status_effect/buff/skulduggery/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_STATUS_STUN)
	UnregisterSignal(owner, COMSIG_LIVING_STATUS_KNOCKDOWN)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_BEING_ATTACKED)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED)
	UnregisterSignal(owner, COMSIG_MOB_ATTACKED_BY_HAND)

	owner.stop_pulling()
	waiting_followup = FALSE
	. = ..()

/datum/status_effect/buff/skulduggery/proc/trigger_afterimage(duration = 2)
	if(!owner) return
	if(owner.GetComponent(/datum/component/after_image))
		return
	var/datum/component/after_image/A = owner.AddComponent(/datum/component/after_image)
	spawn(duration)
		if(A)
			qdel(A)

/datum/status_effect/buff/skulduggery/proc/on_incapacitate()
	SIGNAL_HANDLER 
	if(!owner) 
		return 
	if(!owner.IsKnockdown() && !owner.IsStun()) 
		return 
	to_chat(owner, span_warning("My footing falters! Carkin'--!")) 
	qdel(src)

/datum/status_effect/buff/skulduggery/tick()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!owner) return
	if(prob(40))
		trigger_afterimage(2)
		owner.Jitter(1)

	if(waiting_followup && grappled)
		if(owner.pulling != grappled)
			waiting_followup = FALSE
			grappled = null
			
	if((H.highest_ac_worn() <= ARMOR_CLASS_LIGHT)&&(owner.has_status_effect(/datum/status_effect/buff/tempo_one) || owner.has_status_effect(/datum/status_effect/buff/tempo_two) || owner.has_status_effect(/datum/status_effect/buff/tempo_three) || owner.has_status_effect(/datum/status_effect/buff/equalizebuff)))
		owner.apply_status_effect(/datum/status_effect/buff/skulduggery)
		return

// SIGNAL HOOKS
/datum/status_effect/buff/skulduggery/proc/process_Wfist(mob/living/carbon/human/parent,mob/living/carbon/human/attacker,mob/living/carbon/human/defender)
	if(!ishuman(defender)) return
	if(defender.process_skd(attacker, null))
		return COMPONENT_HAND_NO_ATTACK

/datum/status_effect/buff/skulduggery/proc/process_Wattack(mob/living/parent,mob/living/target,mob/user,obj/item/I)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.process_skd(user, I))
			return COMPONENT_NO_ATTACK

/mob/living/carbon/human/proc/process_skd(mob/living/carbon/human/attacker, obj/item/I)
	var/datum/status_effect/buff/skulduggery/S = has_status_effect(/datum/status_effect/buff/skulduggery)
	if(!S) return FALSE
	return S.process_skd(attacker, I)

// CORE LOGIC
/datum/status_effect/buff/skulduggery/proc/process_skd(mob/living/carbon/human/attacker, obj/item/I)
	if(!owner || !ishuman(owner) || !ishuman(attacker) || owner.IsKnockdown() || owner.lying || owner.IsParalyzed() || owner.IsStun() || owner.stat != CONSCIOUS || !(owner.mobility_flags & MOBILITY_STAND))
		return FALSE

	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/A = attacker

	// FOLLOW-UP STATE
	if(waiting_followup)
		if(A == grappled)
			slam_target(A)
		else
			slam_into(A)
		return TRUE

	// PRONE CHECK
	if(A.IsKnockdown() || A.lying)
		return stomp_prone(A)

	// THROW MODE = INTERCEPT-GRAPPLE
	if(H.in_throw_mode)
		return attempt_grapple(H, A)

	// NPC BAMBOOZLING
	if(!A.mind)
		return auto_flank_move(H, A)

	// PLAYER STANDARD PARRY
	return attempt_parry(H, A, I)

/datum/status_effect/buff/skulduggery/proc/attempt_grapple(mob/living/carbon/human/H, mob/living/carbon/human/A)
	if(A.mind)
		if(!grapple_counts[A])
			grapple_counts[A] = 0

		if(grapple_counts[A] >= 2)
			H.visible_message(
				span_warning("[H] reaches for [A], but they anticipate it!"),
				span_notice("They've adapted... I can't grab them again!")
			)
			return FALSE
		grapple_counts[A]++

	H.start_pulling(A)
	H.setDir(get_dir(H, A))
	playsound(H, 'sound/combat/riposte.ogg', 100, TRUE)

	H.visible_message(
		span_boldwarning("[H] intercepts [A] and seizes them!"),
		span_notice("Got them!")
	)

	H.balloon_alert_to_viewers("SKD!!", "SKD!!", 10)

	grappled = A
	waiting_followup = TRUE

	return TRUE

/datum/status_effect/buff/skulduggery/proc/attempt_parry(mob/living/carbon/human/H, mob/living/carbon/human/A, obj/item/I)
	var/my_skill = H.get_skill_level(/datum/skill/magic/holy)
	var/enemy_skill = A.get_skill_level(I.associated_skill)
	if(!enemy_skill)
		enemy_skill = 0

	// Skill difference
	var/skill_diff = my_skill - enemy_skill
	// Base success chance (10% per point of advantage)
	var/base_chance = skill_diff * 10
	// Parry bonus (+20% per remaining parry)
	var/parry_bonus = parries_left * 20
	// Final success chance
	var/success_chance = base_chance + parry_bonus
	success_chance = clamp(success_chance, 0, 90)

	// Roll
	if(!prob(success_chance))
		H.visible_message(
			span_warning("[H] tries to read [A]'s attack, but fails!"),
			span_notice("Gah, I can't keep up!")
		)
		parries_left--
		to_chat(owner, span_warning("Failed, [parries_left] left. ([success_chance]%)")) 
		return FALSE
	// Success
	if(parries_left > 0)
		parries_left--

	to_chat(owner, span_warning("Success, [parries_left] left. ([success_chance]%)")) 
	auto_flank_move(H, A)
	return TRUE

/datum/status_effect/buff/skulduggery/proc/is_valid_step(mob/living/carbon/human/H, turf/dest)
	if(!dest)
		return FALSE
	if(arcyne_validate_blink_dest(dest, H))
		return FALSE
	if(istransparentturf(dest))
		return FALSE
	return TRUE

/datum/status_effect/buff/skulduggery/proc/auto_flank_move(mob/living/carbon/human/H, mob/living/carbon/human/A)
	if(!H || !A)
		return FALSE

	var/original_dir = A.dir
	var/left_dir = turn(original_dir, 90)
	var/right_dir = turn(original_dir, -90)
	var/behind_dir = turn(original_dir, 180)
	var/turf/left = get_step(A, left_dir)
	var/turf/right = get_step(A, right_dir)
	var/turf/behind = get_step(A, behind_dir)
	var/dx = H.x - A.x
	var/dy = H.y - A.y
	var/use_left = (dx * dy >= 0)
	var/turf/side = use_left ? left : right
	var/turf/alt_side = use_left ? right : left

	if(!is_valid_step(H, side) || !is_valid_step(H, behind))
		side = alt_side

		if(!is_valid_step(H, side) || !is_valid_step(H, behind))
			if(!is_valid_step(H, behind))
				return FALSE

			trigger_afterimage(3)
			H.forceMove(behind)
		else
			trigger_afterimage(3)
			H.forceMove(side)

			sleep(1) 
			
			trigger_afterimage(3)
			H.forceMove(behind)
	else
		trigger_afterimage(3)
		H.forceMove(side)

		sleep(1) // 1 tick, enough to render
	
		H.forceMove(behind)
		trigger_afterimage(3)

	H.setDir(get_dir(H, A))

	if(!A.mind)
		A.Immobilize(8 SECONDS)
		A.OffBalance(8 SECONDS)
		A.apply_status_effect(/datum/status_effect/debuff/clickcd, 8 SECONDS)
		if(A.mob_biotypes != MOB_UNDEAD && prob(25))
			A.emote("huh")
	else
		A.apply_status_effect(/datum/status_effect/debuff/clickcd, 2 SECONDS)

	H.visible_message(
		span_boldwarning("[H] slips past [A] in a blur and appears at their back!"),
		span_notice("Too slow.")
	)

	return TRUE

// SKD - STOMP
/datum/status_effect/buff/skulduggery/proc/stomp_prone(mob/living/carbon/human/T)
	if(!T) return

	var/mob/living/carbon/human/H = owner
	H.visible_message(
			span_boldwarning("[H] delivers their foot onto [T] while they try to swing!"),
			span_notice("Deserved kick for trying that, fool!")
		)
	H.do_attack_animation(T)
	T.adjustBruteLoss(8)
	T.stamina_add(8)
	H.setDir(get_dir(H, T))

	if(!T.mind)
		T.stamina_add(12)
		T.apply_status_effect(/datum/status_effect/debuff/clickcd, 2 SECONDS)

	addtimer(CALLBACK(T, /mob/proc/slamdunked), 1)
	return TRUE
	
// SKD - GROUND SLAM
/datum/status_effect/buff/skulduggery/proc/slam_target(mob/living/carbon/human/T)
	if(!T) return

	var/mob/living/carbon/human/H = owner

	var/power = H.get_skill_level(/datum/skill/combat/unarmed) + (H.get_skill_level(/datum/skill/magic/holy) / 2)
	var/resist = (T.get_stat(STAT_CONSTITUTION) + T.get_stat(STAT_SPEED)/4)

	var/chance = clamp(50 + (power - resist), 10, 90)
	if(prob(chance))
		H.stop_pulling()
		waiting_followup = FALSE
		grappled = null
		H.visible_message(
			span_boldwarning("[H] turns [T] upside their head and slams them into the ground!"),
			span_notice("<i>I drive them into the floor with sheer skill!</i>")
		)
		H.setDir(get_dir(H, T))
		H.balloon_alert_to_viewers(message = "SKD Slam!!", self_message = "SKD Slam!!", y_offset = 10)
		playsound(get_turf(T), 'sound/combat/wooshes/blunt/wooshhuge (2).ogg', 100, FALSE)
		T.Knockdown(4 SECONDS)
		sleep(3)
		T.apply_status_effect(/datum/status_effect/debuff/clickcd, 4 SECONDS)
		T.adjustBruteLoss(40)
		T.stamina_add(60)
		shake_camera(H, 2, 1)
		shake_camera(T, 2, 1)
		var/da_slam = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
		playsound(T, da_slam, 100, TRUE)
		playsound(T, 'sound/combat/tf2crit.ogg', 100, TRUE)
		if(!T.mind && T.mob_biotypes != MOB_UNDEAD)
			if(prob(50))
				T.Unconscious(800)
	else
		H.visible_message(
			span_warning("[T] resists the slam, forcing [H] to kick them away!"),
			span_notice("They resist my attempt to slam! I have to kick them off!")
		)
		H.balloon_alert_to_viewers(message = "SKD Kick!!", self_message = "SKD Kick!!", y_offset = 10)
		H.setDir(get_dir(H, T))
		playsound(T, 'sound/combat/hits/punch/punch_hard (2).ogg', 100, TRUE)
		T.Knockdown(1 SECONDS)
		var/dir = turn(get_dir(T, H), 180)
		if(dir & (NORTH|SOUTH))
			dir = (dir & NORTH) ? NORTH : SOUTH
		else
			dir = (dir & EAST) ? EAST : WEST
		var/turf/current = get_turf(T)
		for(var/i = 1 to 3)
			var/turf/next = get_step(current, dir)
			if(!next || next.density)
				break
			current = next
		T.throw_at(current, 2, 4)
		waiting_followup = FALSE

	addtimer(CALLBACK(T, /mob/proc/slamdunked), 1)

	grappled = null
	waiting_followup = FALSE

// SKD - SLAM INTO ANOTHER
/datum/status_effect/buff/skulduggery/proc/slam_into(mob/living/carbon/human/other)
	if(!other || !grappled) return

	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/G = grappled

	H.visible_message(
		span_boldwarning("[H] redirects [G] full force into [other]!"),
		span_notice("<i>Consecutive Skulduggery! Hells yae! Bring me more!</i>")
	)
	H.balloon_alert_to_viewers(message = "Consecutive SKD!!", self_message = "Consecutive SKD!!", y_offset = 10)
	H.setDir(get_dir(H, other))
	var/attack_sound = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
	playsound(other, attack_sound, 100, TRUE)

	G.forceMove(get_turf(other))

	G.adjustBruteLoss(30)
	other.adjustBruteLoss(30)
	other.stamina_add(25)

	G.Knockdown(1 SECONDS)
	other.Knockdown(1 SECONDS)

	shake_camera(H, 2, 1)
	shake_camera(G, 2, 1)
	shake_camera(other, 2, 1)

	var/dir = turn(get_dir(other, H), 180)

	if(dir & (NORTH|SOUTH))
		dir = (dir & NORTH) ? NORTH : SOUTH
	else
		dir = (dir & EAST) ? EAST : WEST

	var/turf/current = get_turf(other)

	for(var/i = 1 to 3)
		var/turf/next = get_step(current, dir)
		if(!next || next.density)
			break
		current = next

	other.throw_at(current, 1, 4)
	waiting_followup = FALSE

	addtimer(CALLBACK(src, .proc/_slam_followup, other, G), 0.5)

	grappled = null
	waiting_followup = FALSE

/datum/status_effect/buff/skulduggery/proc/_slam_followup(mob/living/carbon/human/other, mob/living/carbon/human/G)
	if(!other || !G) return

	G.forceMove(get_turf(other))

	var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
	var/turf/T = get_step(G, pick(dirs))
	if(T && !T.density)
		G.forceMove(T)

	addtimer(CALLBACK(G, /mob/proc/slamdunked), 1)
	addtimer(CALLBACK(other, /mob/proc/slamdunked), 1)

	if(!G.mind && G.mob_biotypes != MOB_UNDEAD)
		if(prob(50))
			G.Unconscious(800)

// EFFECTS
/mob/proc/slamdunked()
	var/amp = 6
	animate(src, pixel_x = 0, time = 0)
	for(var/i in 1 to 5)
		animate(src, pixel_x = -amp, time = 1)
		animate(src, pixel_x = amp, time = 1)
		amp = round(amp * 0.6)
	animate(src, pixel_x = 0, time = 2)
