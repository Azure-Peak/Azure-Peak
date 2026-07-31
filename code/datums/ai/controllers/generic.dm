/datum/ai_controller/generic //Placeholder for mobs missing their AI Controller
	movement_delay = MOLE_MOVEMENT_SPEED
	can_climb_structures = FALSE //farm animals stay penned

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

//Docile pet that fights back when struck but never starts anything. Pair with /datum/element/ai_retaliate on the mob.
/datum/ai_controller/generic/pet_retaliate
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_BASIC_MOB_TAMED = FALSE,
		BB_RETALIATE_ATTACKS_LEFT = 0,
		BB_BASIC_MOB_RETALIATE_LIST = list(),
		BB_RETALIATE_COOLDOWN = 0,
		BB_MAIN_TARGET = null,
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,

		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/eat_food/farm_animals,

		/datum/ai_planning_subtree/simple_self_recovery/genericanimal/pet,
	)

/datum/ai_controller/generic/goat
	can_climb_structures = TRUE //goats are renowned mountaineers

	planning_subtrees = list(
		/datum/ai_planning_subtree/target_retaliate,

		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/eat_food/farm_animals,
		)
