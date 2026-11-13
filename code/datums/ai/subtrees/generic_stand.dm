/datum/ai_planning_subtree/generic_stand/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/living_pawn = controller.pawn

	if(!SHOULD_STAND(living_pawn) || living_pawn.IsKnockdown() || living_pawn.IsStun() || living_pawn.IsParalyzed())
		if(!isnull(controller.blackboard[BB_HUMAN_NPC_STAND_UP_AT]))
			controller.clear_blackboard_key(BB_HUMAN_NPC_STAND_UP_AT)
		return

	var/stand_up_at = controller.blackboard[BB_HUMAN_NPC_STAND_UP_AT]
	if(isnull(stand_up_at))
		controller.set_blackboard_key(BB_HUMAN_NPC_STAND_UP_AT, world.time + rand(NPC_STAND_UP_DELAY_MIN, NPC_STAND_UP_DELAY_MAX))
		return SUBTREE_RETURN_FINISH_PLANNING
	if(world.time < stand_up_at)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(SPT_PROB(50, seconds_per_tick) && !HAS_TRAIT(living_pawn, TRAIT_FLOORED) && !living_pawn.stat)
		controller.queue_behavior(/datum/ai_behavior/stand) //BRO IM ON FUCKING FIRE BRO
		return SUBTREE_RETURN_FINISH_PLANNING //IM NOT DOING ANYTHING ELSE BUT EXTINGUISH MYSELF, GOOD GOD HAVE MERCY.

/datum/ai_behavior/stand/perform(seconds_per_tick, datum/ai_controller/controller)
	var/mob/living/carbon/human/living_pawn = controller.pawn
	living_pawn.stand_up()
	return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_SUCCEEDED
