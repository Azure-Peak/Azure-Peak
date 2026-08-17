/datum/ai_planning_subtree/call_for_help
	/// Max tiles to scan/respond for allies. Kept deliberately tighter than max_target_distance
	/// so shouting doesn't drag in mobs from across the map.
	var/help_range = 9

/datum/ai_planning_subtree/call_for_help/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()

	if(!controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		return

	// Don't scan for allies every tick — check at most every 5 seconds
	var/next_call = controller.blackboard["bb_call_for_help_cooldown"]
	if(next_call && world.time < next_call)
		return

	var/mob/living/living_pawn = controller.pawn

	controller.set_blackboard_key("bb_call_for_help_cooldown", world.time + 5 SECONDS)

	var/allowed = FALSE
	for(var/mob/living/carbon/human/ally in view(help_range, living_pawn))
		if(ally == living_pawn)
			continue
		var/datum/ai_controller/ally_ctrl = ally.ai_controller
		if(!ally_ctrl)
			continue
		allowed = TRUE
		break

	if(!allowed)
		return

	controller.queue_behavior(/datum/ai_behavior/call_for_help, BB_BASIC_MOB_CURRENT_TARGET)

/datum/ai_behavior/call_for_help
	action_cooldown = 45 SECONDS
	behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION | AI_BEHAVIOR_EXECUTE_ALONGSIDE

/datum/ai_behavior/call_for_help/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	living_pawn.emote("scream")
	living_pawn.visible_message(span_danger("[living_pawn] shouts for aid!"))
	var/atom/current_target = controller.blackboard[target_key]

	for(var/mob/living/carbon/human/ally in view(9, living_pawn))
		if(ally == living_pawn)
			continue
		var/datum/ai_controller/ally_ctrl = ally.ai_controller
		if(!ally_ctrl)
			continue
		if(!living_pawn.faction_check_mob(ally, FALSE))
			continue
		if(ally_ctrl.blackboard[BB_BASIC_MOB_CURRENT_TARGET] == current_target)
			continue

		var/datum/component/ai_aggro_system/aggro_comp = ally_ctrl.pawn.GetComponent(/datum/component/ai_aggro_system)
		if(aggro_comp)
			aggro_comp.add_threat_to_mob_capped(current_target, AGGRO_CALL_FOR_HELP_THREAT, AGGRO_CALL_FOR_HELP_THREAT)
			continue

		if(!ally_ctrl.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
			ally_ctrl.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, current_target)
			ally_ctrl.wake_for_combat()
			ally_ctrl.CancelActions()

	finish_action(controller, TRUE, target_key)
