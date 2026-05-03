/datum/ai_controller/spirit_vengeance
	movement_delay = HAUNT_MOVEMENT_SPEED

	ai_movement = /datum/ai_movement/astar

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/being_a_minion,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)
