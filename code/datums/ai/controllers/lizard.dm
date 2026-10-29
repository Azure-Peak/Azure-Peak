/datum/ai_controller/lizard

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/lizard()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk/less_walking

/datum/targetting_datum/basic/lizard

/datum/targetting_datum/basic/lizard/can_attack(mob/living/living_mob, atom/the_target)
	var/mob/living/simple_animal/hostile/lizard/lizard = living_mob
	if(!istype(lizard) || !is_type_in_typecache(the_target, lizard.edibles))
		return FALSE
	return ..()
