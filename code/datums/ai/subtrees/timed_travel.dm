/datum/ai_controller/proc/travel_for(atom/destination, duration)
	set_blackboard_key(BB_TIMED_TRAVEL_TARGET, destination)
	set_blackboard_key(BB_TIMED_TRAVEL_UNTIL, world.time + duration)
	add_subtree_at(/datum/ai_planning_subtree/timed_travel, 1)
	COOLDOWN_RESET(src, failed_planning_cooldown)
	wake_for_combat()

/datum/ai_controller/proc/is_timed_traveling()
	return blackboard[BB_TIMED_TRAVEL_TARGET] && world.time < blackboard[BB_TIMED_TRAVEL_UNTIL]

/datum/ai_planning_subtree/timed_travel

/datum/ai_planning_subtree/timed_travel/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/atom/destination = controller.blackboard[BB_TIMED_TRAVEL_TARGET]
	if(!destination)
		return
	if(!controller.is_timed_traveling())
		controller.clear_blackboard_key(BB_TIMED_TRAVEL_TARGET)
		controller.clear_blackboard_key(BB_TIMED_TRAVEL_UNTIL)
		return
	if(controller.has_aggro() || controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		return
	controller.queue_behavior(ismob(destination) ? /datum/ai_behavior/travel_towards/hold/adjacent : /datum/ai_behavior/travel_towards/hold, BB_TIMED_TRAVEL_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING
