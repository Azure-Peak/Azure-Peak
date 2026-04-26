/datum/ai_controller/orc
	movement_delay = ORC_MOVEMENT_SPEED

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_REINFORCEMENTS_SAY = null
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/call_reinforcements,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

/datum/ai_controller/orc_ranged
	movement_delay = ORC_MOVEMENT_SPEED * 1.2 //ranged malus

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/spacing/ranged,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree,
	)

/datum/ai_controller/spear_orc
	movement_delay = ORC_MOVEMENT_SPEED

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/spacing/spear,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/spear,
		
	)


/datum/ai_controller/elite_orc
	movement_delay = ORC_MOVEMENT_SPEED

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/spacing/melee,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/spear,
		
	)

/datum/ai_controller/elite_orc/event
	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/spear,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
		/datum/ai_planning_subtree/spacing/melee,
		
	)
/datum/ai_controller/orc_ranged/event
	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
	)
/datum/ai_controller/orc/event
	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/call_reinforcements,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
	)
