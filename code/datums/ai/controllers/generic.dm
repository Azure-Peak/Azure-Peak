/datum/ai_controller/generic //Placeholder for mobs missing their AI Controller
	movement_delay = MOLE_MOVEMENT_SPEED

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()

	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee,

		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/eat_food/farm_animals,

		/datum/ai_planning_subtree/simple_self_recovery/genericanimal,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk/less_walking

/datum/ai_controller/generic/goat

	planning_subtrees = list(
		/datum/ai_planning_subtree/target_retaliate,

		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/eat_food/farm_animals,
		)
