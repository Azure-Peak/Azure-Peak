/datum/ai_controller/voiddragon

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path/walls,
		/datum/ai_planning_subtree/targeted_mob_ability/any/continue_planning,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_controller/voidstoneobelisk

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path/walls,
		/datum/ai_planning_subtree/targeted_mob_ability/any/continue_planning,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk
