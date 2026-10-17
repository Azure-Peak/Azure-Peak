/datum/ai_controller/goat_tough
	can_climb_structures = TRUE
	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_BASIC_MOB_TAMED = FALSE,
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/circler,
		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/eat_food,
	)
