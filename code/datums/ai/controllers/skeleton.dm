/datum/ai_controller/simple_skeleton
	movement_delay = SKELETON_MOVEMENT_SPEED

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/being_a_minion,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/attack_obstacle_in_path,


	)

	idle_behavior = /datum/idle_behavior/idle_random_walk


/datum/ai_controller/skeleton_spear
	movement_delay = SKELETON_MOVEMENT_SPEED

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/being_a_minion,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/spacing/melee,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/spear,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_controller/skeleton_ranged
	movement_delay = SKELETON_MOVEMENT_SPEED * 1.2 //ranged malus

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/being_a_minion,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk

///Key difference is minion is at the end and that it is an /event, so they will attack on the way there
/datum/ai_controller/simple_skeleton/event
	planning_subtrees = list(

		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic/event_loc,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
	)

/datum/ai_controller/skeleton_spear/event

	planning_subtrees = list(

		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic/event_loc,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
		/datum/ai_planning_subtree/spacing/melee,
	)
///Try not to spawn these, the ai will be poor
/datum/ai_controller/skeleton_ranged/event
	planning_subtrees = list(

		/datum/ai_planning_subtree/basic_ranged_attack_subtree,
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
		/datum/ai_planning_subtree/spacing/ranged,
	)
