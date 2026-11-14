/datum/ai_controller/lamia

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/lamia_sneak,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/eat_food,
	)

/datum/ai_planning_subtree/lamia_sneak

/datum/ai_planning_subtree/lamia_sneak/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/simple_animal/hostile/retaliate/rogue/lamia/lamia = controller.pawn
	if(istype(lamia))
		lamia.try_sneak()
