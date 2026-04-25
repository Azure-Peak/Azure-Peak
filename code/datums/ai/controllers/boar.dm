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
	var/mob/living/L = controller.pawn
	if(QDELETED(L))
		return
	var/turf/T = get_turf(L)
	var/hit_obstacle = FALSE
	for(var/dir in GLOB.cardinals)
		var/turf/neighbor = get_step(T, dir)
		if(neighbor.is_blocked_turf(exclude_mobs = TRUE))
			hit_obstacle = TRUE
			break
	if(hit_obstacle)
		L.visible_message("<span class='danger'>[L] slams into the wall and is dazed!</span>")
		L.Stun(3 SECONDS)
		playsound(L, 'sound/combat/hits/onwood/fence_hit3.ogg', 75, TRUE)

#undef BB_BOAR_CHARGE_COOLDOWN
