/// Use in hand the currently held item
/datum/ai_behavior/use_in_hand
	behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/use_in_hand/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/pawn = controller.pawn
	if(pawn.incapacitated())
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	var/obj/item/held = pawn.get_active_held_item()
	if(!held)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	pawn.activate_hand(pawn.active_hand_index)
	return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED
