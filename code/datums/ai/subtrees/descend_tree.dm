/datum/ai_planning_subtree/tree_descend

/datum/ai_planning_subtree/tree_descend/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	var/turf/my_turf = get_turf(pawn)
	if(!istype(my_turf, /turf/open/transparent/openspace))
		return
	if(!(locate(/obj/structure/flora/newbranch) in my_turf))
		return
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	var/turf/their_turf = get_turf(target)
	if(their_turf && their_turf.z >= my_turf.z)
		return
	if(!pawn.mid_climb)
		controller.queue_behavior(/datum/ai_behavior/human_npc_descend_tree)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/human_npc_descend_tree
	action_cooldown = 1 SECONDS

/datum/ai_behavior/human_npc_descend_tree/proc/is_landing_clear(turf/landing)
	if(!isopenturf(landing) || landing.density)
		return FALSE
	if(istype(landing, /turf/open/transparent/openspace))
		return FALSE
	for(var/obj/O in landing)
		if(O.density)
			return FALSE
	return TRUE

/datum/ai_behavior/human_npc_descend_tree/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/carbon/human/pawn = controller.pawn
	var/turf/my_turf = get_turf(pawn)
	if(!istype(my_turf, /turf/open/transparent/openspace))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	if(pawn.stat != CONSCIOUS || pawn.incapacitated() || pawn.mid_climb)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	controller.ai_movement.stop_moving_towards(controller)
	walk(pawn, 0)
	var/list/exits = list()
	for(var/turf/open/transparent/openspace/exit in orange(1, my_turf))
		var/turf/landing = GET_TURF_BELOW(exit)
		if(!is_landing_clear(landing))
			continue
		if(!pawn.can_zTravel(landing, DOWN, exit))
			continue
		exits += exit
	if(length(exits))
		var/turf/open/transparent/openspace/chosen = pick(exits)
		chosen.attack_hand(pawn)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED
	var/turf/below = GET_TURF_BELOW(my_turf)
	if(!is_landing_clear(below))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	pawn.forceMove(below)
	return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED
