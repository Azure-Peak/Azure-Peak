#define BB_BOAR_CHARGE_COOLDOWN "boar_charge_cooldown"
#define BB_BOAR_CHARGE_ATTEMPTS "boar_charge_attempts"

/datum/ai_controller/boar
	movement_delay = BOAR_MOVEMENT_SPEED
	ai_movement = /datum/ai_movement/hybrid_pathing
	idle_behavior = /datum/idle_behavior/idle_random_walk

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
		BB_BOAR_CHARGE_COOLDOWN = 0,
		BB_BOAR_CHARGE_ATTEMPTS = 0
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		// Whee!!
		/datum/ai_planning_subtree/boar_charge,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/eat_food,
	)

/datum/ai_planning_subtree/boar_charge

/datum/ai_planning_subtree/boar_charge/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target))
		return

	if(controller.blackboard[BB_BOAR_CHARGE_COOLDOWN] > world.time)
		return

	controller.queue_behavior(/datum/ai_behavior/boar_charge, BB_BASIC_MOB_CURRENT_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/boar_charge
	//action_cooldown = 20 SECONDS

/datum/ai_behavior/boar_charge/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	var/mob/living/simple_animal/boar = controller.pawn
	var/atom/target = controller.blackboard[target_key]

	if(QDELETED(target) || boar.buckled || boar.incapacitated())
		finish_action(controller, FALSE)
		return

	controller.set_blackboard_key(BB_BOAR_CHARGE_COOLDOWN, world.time + 20 SECONDS)
	boar.visible_message("<b>[boar]</b> lowers its head and charges!")
	playsound(boar, 'sound/vo//mobs/boar/boar_charge.ogg', 75, TRUE)
	var/charge_dir = get_dir(boar, target)
	boar.throw_at(target, 7, 3, boar, callback = CALLBACK(src, .proc/on_charge_end, controller, charge_dir))
	finish_action(controller, TRUE)

/datum/ai_behavior/boar_charge/proc/on_charge_end(datum/ai_controller/controller, charge_dir)
	var/mob/living/boar = controller.pawn
	if(QDELETED(boar))
		return
	var/turf/landing_turf = get_turf(boar)
	var/turf/impact_turf = get_step(landing_turf, charge_dir)
	var/did_hit = FALSE
	if(!impact_turf)
		return
	var/list/turfs_to_check = list(impact_turf)
	if(charge_dir & (charge_dir - 1)) 
		// It's diagonal! Add the two cardinal tiles that make up the diagonal.
		// e.g. If NORTHEAST, this adds NORTH and EAST.
		turfs_to_check += get_step(landing_turf, (charge_dir & (NORTH|SOUTH)))
		turfs_to_check += get_step(landing_turf, (charge_dir & (EAST|WEST)))
	else
		// It's cardinal! Use the standard turn logic.
		turfs_to_check += get_step(impact_turf, turn(charge_dir, 90))
		turfs_to_check += get_step(impact_turf, turn(charge_dir, -90))

	var/swing_sfx = pick('sound/combat/ground_smash_start.ogg', 'sound/combat/flail_sweep_hit_minor.ogg')
	for(var/turf/T in turfs_to_check)
		var/delay = 0.5 SECONDS
		var/obj/effect/temp_visual/special_intent/fx = new (T, delay)
		fx.icon = 'icons/effects/effects.dmi'
		fx.icon_state = "sweep_fx"
	playsound(impact_turf, swing_sfx, 80, TRUE)

	// DIRECT HIT ON A MOB
	var/mob/living/victim
	for(var/turf/check_turf in turfs_to_check)
		victim = locate(/mob/living) in check_turf
		if(victim && victim != boar)
			break // We found a target!
	if(victim)
		did_hit = TRUE
		victim.visible_message(span_userdanger("[boar] gores [victim]!</span>"))
		if(iscarbon(victim))
			var/mob/living/carbon/C = victim
			var/obj/item/bodypart/chest = C.get_bodypart(BODY_ZONE_CHEST)
			if(chest)
				chest.add_wound(/datum/wound/slash/boar_gore)
		victim.Stun(5 SECONDS)
		victim.apply_status_effect(/datum/status_effect/debuff/exposed, 10 SECONDS)
		boar.Stun(3 SECONDS)
		victim.adjustBruteLoss(50)
		playsound(victim, 'sound/combat/crit.ogg', 75, TRUE)
		return
	if(impact_turf.is_blocked_turf(exclude_mobs = TRUE))
		did_hit = TRUE
		boar.visible_message("<span class='danger'>[boar] slams into [impact_turf] with bone-shattering force!</span>")
		playsound(boar, 'sound/combat/hits/onwood/fence_hit3.ogg', 100, TRUE)
		boar.Stun(3 SECONDS)
		for(var/turf/T in range(1, impact_turf))
			var/obj/effect/temp_visual/special_intent/smash = new (T, 0.5 SECONDS)
			smash.icon = 'icons/effects/effects.dmi'
			smash.icon_state = "strike"
		// Anyone within 1 tile of the point of impact gets knocked down and dazed.
		for(var/mob/living/L in range(1, impact_turf))
			if(L == boar)
				continue
			L.visible_message("<span class='warning'>The shockwave from [boar]'s impact knocks [L] off their feet!</span>")
			L.Knockdown(3 SECONDS)
			L.apply_status_effect(/datum/status_effect/debuff/dazed)
			L.adjustBruteLoss(20)
	if(!did_hit)
		var/attempts = controller.blackboard[BB_BOAR_CHARGE_ATTEMPTS]
		if(attempts < 1)
			controller.set_blackboard_key(BB_BOAR_CHARGE_ATTEMPTS, 1)
			controller.set_blackboard_key(BB_BOAR_CHARGE_COOLDOWN, 0) // Reset cooldown
			boar.visible_message(span_notice("[boar] skids to a halt and prepares to lunges again!"))
		else
			// If they miss the second time, they have to wait for the full cooldown
			controller.set_blackboard_key(BB_BOAR_CHARGE_ATTEMPTS, 0)

#undef BB_BOAR_CHARGE_COOLDOWN
#undef BB_BOAR_CHARGE_ATTEMPTS
