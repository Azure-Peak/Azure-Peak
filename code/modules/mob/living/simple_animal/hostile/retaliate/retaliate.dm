/mob/living/simple_animal/hostile/retaliate/examine(mob/user)
	. = ..()
	if(!ai_controller)
		return
	if(user == ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		. += span_danger("[src] is currently targeting you!")
	else if(ai_controller.has_aggro(user))
		. += span_danger("[src] seems hostile towards you.")

/mob/living/simple_animal/hostile/retaliate/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(M.used_intent.type == INTENT_HELP && tame)
		if(ai_controller?.has_aggro())
			if(!(M in friends))
				to_chat(M, span_warning("[src] doesn't seem to react to your petting!"))
				return
			ai_controller.clear_aggro()
			visible_message(span_notice("[src] calms down."))
		else
			if(!(M in friends))
				friends += M
				visible_message(span_notice("[src] seems to like [M]."))

/mob/living/simple_animal/hostile/retaliate
	var/aggressive = 0

/mob/living/simple_animal/hostile/retaliate/can_be_held(mob/by)
	return ..() && !aggressive && !ai_controller?.has_aggro(by)
