/datum/ai_planning_subtree/proc/plan_target_sight(datum/ai_controller/controller)
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(target)
		controller.refresh_target_sight(target)
		return
	if(controller.blackboard[BB_BASIC_MOB_FLEEING] || !controller.blackboard[BB_TARGET_SEARCH_TURF])
		return
	controller.queue_behavior(/datum/ai_behavior/travel_towards/hold/search, BB_TARGET_SEARCH_TURF)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/simple_find_target
	var/find_behavior = /datum/ai_behavior/find_potential_targets

/datum/ai_planning_subtree/simple_find_target/SelectBehaviors(datum/ai_controller/controller, delta_time)
	controller.queue_behavior(find_behavior, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	return plan_target_sight(controller)

/datum/ai_planning_subtree/simple_find_target/rat
	find_behavior = /datum/ai_behavior/find_potential_targets/rat

/datum/ai_planning_subtree/simple_find_target/spider
	find_behavior = /datum/ai_behavior/find_potential_targets/spider

/datum/ai_planning_subtree/simple_find_target/mimic
	find_behavior = /datum/ai_behavior/find_potential_targets/mimic

/datum/ai_planning_subtree/simple_find_target/mole
	find_behavior = /datum/ai_behavior/find_potential_targets/mole

/datum/ai_planning_subtree/simple_find_target/troll
	find_behavior = /datum/ai_behavior/find_potential_targets/troll

/datum/ai_planning_subtree/simple_find_target/bog_troll
	find_behavior = /datum/ai_behavior/find_potential_targets/bog_troll

/datum/ai_planning_subtree/simple_find_target/closest //nearest
	find_behavior = /datum/ai_behavior/find_potential_targets/nearest

/datum/ai_planning_subtree/aggro_find_target
	var/find_behavior = /datum/ai_behavior/find_aggro_targets

/datum/ai_planning_subtree/aggro_find_target/SelectBehaviors(datum/ai_controller/controller, delta_time)
	controller.queue_behavior(find_behavior, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	return plan_target_sight(controller)

/datum/ai_planning_subtree/aggro_find_target/bum
	find_behavior = /datum/ai_behavior/find_aggro_targets/bum

/datum/ai_planning_subtree/aggro_find_target/species_hostile
	find_behavior = /datum/ai_behavior/find_aggro_targets/species_hostile
