/datum/ai_planning_subtree/outskirts_attack

/datum/ai_planning_subtree/outskirts_attack/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()

	var/atom/objective = controller.blackboard[BB_OUTSKIRTS_OBJECTIVE_REF]
	if(!objective || QDELETED(objective))
		return

	if(!controller.blackboard[BB_OUTSKIRTS_REACHED_OBJECTIVE])
		var/mob/living/early_target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
		if(early_target && !QDELETED(early_target) && early_target.stat != DEAD)
			reach_objective(controller)
			return // if they got a new target on their way there (such as someone attacking them), we pretend they reached the objective

		if(get_dist(controller.pawn, objective) <= 5)
			reach_objective(controller)
			return // if they're within 5 tiles of the objective, they've reached it

		var/movement_start = controller.blackboard[BB_OUTSKIRTS_MOVEMENT_START]
		if(movement_start && (world.time - movement_start) > 30 SECONDS)
			reach_objective(controller)
			return // if they're fumbling towards the objective for 30 seconds, we pretend they reached it and move on

		var/turf/objective_turf = get_turf(objective)
		if(!movement_start)
			controller.blackboard[BB_OUTSKIRTS_MOVEMENT_START] = world.time
			controller.blackboard[BB_MOVEMENT_PATH_PROTECTED] = TRUE
		controller.set_blackboard_key(BB_TRAVEL_DESTINATION, objective_turf)

		controller.queue_behavior(/datum/ai_behavior/travel_towards/outskirts_travel, BB_TRAVEL_DESTINATION)
		return SUBTREE_RETURN_FINISH_PLANNING

	// AFTER reaching the objective, we use aggro_from_list to receive viable players (collected and provided by the outskirts manager) to Hunt & Murder
	var/mob/living/current_target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(current_target)
		if(QDELETED(current_target) || current_target.stat == DEAD)
			controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		else
			return

	controller.queue_behavior(/datum/ai_behavior/aggro_from_list, BB_OUTSKIRTS_BESIEGING_MOBS, BB_BASIC_MOB_CURRENT_TARGET)

/datum/ai_planning_subtree/outskirts_attack/proc/reach_objective(datum/ai_controller/controller)
	controller.blackboard[BB_OUTSKIRTS_REACHED_OBJECTIVE] = TRUE
	controller.blackboard[BB_OUTSKIRTS_MOVEMENT_START] = 0
	controller.blackboard[BB_MOVEMENT_PATH_PROTECTED] = FALSE
	controller.blackboard[BB_AGGRO_MAINTAIN_RANGE] = 130 // important for encounter_targeting.dm
	controller.clear_blackboard_key(BB_TRAVEL_DESTINATION)
	controller.blackboard[BB_OUTSKIRTS_NEXT_TARGET_ATTEMPT] = 0
