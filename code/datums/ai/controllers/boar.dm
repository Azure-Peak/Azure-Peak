#define BB_BOAR_CHARGE_COOLDOWN "boar_charge_cooldown"

/datum/ai_controller/boar
	movement_delay = BOAR_MOVEMENT_SPEED
	ai_movement = /datum/ai_movement/hybrid_pathing
	idle_behavior = /datum/idle_behavior/idle_random_walk

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
		BB_BOAR_CHARGE_COOLDOWN = 0
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
	if(!impact_turf)
		return

	// DIRECT HIT ON A MOB
	var/mob/living/victim = locate(/mob/living) in impact_turf
	if(victim)
		victim.visible_message(span_userdanger("[boar] gores [victim]!</span>"))
		if(iscarbon(victim))
			var/mob/living/carbon/C = victim
			var/obj/item/bodypart/chest = C.get_bodypart(BODY_ZONE_CHEST)
			if(chest)
				chest.add_wound(/datum/wound/slash/boar_gore)
		victim.Stun(5 SECONDS)
		boar.Stun(3 SECONDS)
		victim.adjustBruteLoss(50)
		playsound(victim, 'sound/combat/crit.ogg', 75, TRUE)
		return
	if(impact_turf.is_blocked_turf(exclude_mobs = TRUE))
		boar.visible_message("<span class='danger'>[boar] slams into [impact_turf] with bone-shattering force!</span>")
		playsound(boar, 'sound/combat/hits/onwood/fence_hit3.ogg', 100, TRUE)
		boar.Stun(3 SECONDS)
		// Anyone within 1 tile of the point of impact gets knocked down and dazed.
		for(var/mob/living/L in range(1, impact_turf))
			if(L == boar)
				continue
			L.visible_message("<span class='warning'>The shockwave from [boar]'s impact knocks [L] off their feet!</span>")
			L.Knockdown(3 SECONDS)
			L.apply_status_effect(/datum/status_effect/debuff/dazed)
			L.adjustBruteLoss(20)

#undef BB_BOAR_CHARGE_COOLDOWN
