/datum/ai_planning_subtree/pursue_to_range
	var/target_key = BB_BASIC_MOB_CURRENT_TARGET
	var/range = 1

/datum/ai_planning_subtree/pursue_to_range/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	if(!controller.blackboard_key_exists(target_key))
		return
	controller.queue_behavior(/datum/ai_behavior/pursue_to_range, target_key, range)
