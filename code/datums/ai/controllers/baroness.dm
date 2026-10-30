/datum/ai_controller/baroness

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/baroness_summon,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree/opportunistic,
		/datum/ai_planning_subtree/spacing/baroness,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

/datum/ai_planning_subtree/baroness_summon

/datum/ai_planning_subtree/baroness_summon/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/simple_animal/hostile/boss/baroness/baroness = controller.pawn
	if(istype(baroness) && controller.blackboard_key_exists(BB_BASIC_MOB_CURRENT_TARGET))
		baroness.try_summon()

/datum/ai_planning_subtree/spacing/baroness
	minimum_distance = 3
	maximum_distance = 3
	need_los = TRUE

/datum/ai_planning_subtree/spacing/baroness/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/simple_animal/hostile/boss/baroness/baroness = controller.pawn
	if(!istype(baroness) || baroness.health >= baroness.phase_two_health)
		return
	var/atom/target = controller.blackboard[target_key]
	if(!isliving(target) || !can_see(baroness, target, view_distance))
		return
	..()
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/spacing/baroness/is_ready_to_attack(datum/ai_controller/controller, mob/living/living_pawn)
	return TRUE
