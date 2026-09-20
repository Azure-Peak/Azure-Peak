/*
*/
/datum/ai_controller/infernal

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,

		/datum/ai_planning_subtree/targeted_mob_ability/any/continue_planning,

		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/simple_self_recovery,
	)

/*
*/
/datum/ai_controller/infernal/harasser

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,

		/datum/ai_planning_subtree/targeted_mob_ability/any/continue_planning,

		/datum/ai_planning_subtree/spacing/ranged,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/spaced,
		/datum/ai_planning_subtree/simple_self_recovery,
	)

/*
*/
/datum/ai_controller/infernal/hound

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,

		/datum/ai_planning_subtree/targeted_mob_ability/any/continue_planning,

		/datum/ai_planning_subtree/basic_melee_attack_subtree/circler,
		/datum/ai_planning_subtree/simple_self_recovery,
	)
