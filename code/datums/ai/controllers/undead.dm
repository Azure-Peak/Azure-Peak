/datum/ai_controller/undead
	movement_delay = MOSSBACK_MOVEMENT_SPEED

	ai_movement = /datum/ai_movement/basic_avoidance

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/being_a_minion,
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)


/datum/ai_controller/undead/wolf
    movement_delay = WOLF_MOVEMENT_SPEED
