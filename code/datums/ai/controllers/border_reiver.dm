
/datum/ai_controller/reiver_rider
	movement_delay = REIVER_RIDER_MOVEMENT_SPEED
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic/event_loc,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
	)

/datum/ai_controller/reiver_rider/lance

	movement_delay = REIVER_RIDER_MOVEMENT_SPEED
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic/event_loc,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
		/datum/ai_planning_subtree/spacing/melee,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/spear,
	)

/datum/ai_controller/reiver_crossbow
	movement_delay = REIVER_CROSSBOW_MOVEMENT_SPEED * 1.2 //ranged malus

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(

		/datum/ai_planning_subtree/being_a_minion,
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree,
		/datum/ai_planning_subtree/simple_find_target/closest,
	)
