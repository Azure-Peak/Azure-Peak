/datum/ai_controller/minotaur
	movement_delay = MINOTAUR_MOVEMENT_SPEED

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()

	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		
		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,

		/datum/ai_planning_subtree/simple_self_recovery,
		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/eat_food,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk
