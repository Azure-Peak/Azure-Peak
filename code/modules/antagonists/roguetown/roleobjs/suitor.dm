/datum/antagonist/suitor
	name = "Suitor"
	increase_votepwr = FALSE

/datum/antagonist/suitor/get_antag_cap_weight()
	return 0

/datum/antagonist/suitor/on_gain()
	if(!(locate(/datum/objective/marry) in objectives))
		var/datum/objective/marry/marry_objective = new
		marry_objective.owner = owner
		objectives += marry_objective
		if(!owner.active)
			addtimer(CALLBACK(src, PROC_REF(greet)), 5 SECONDS)
		else
			greet()
		return
//	ADD_TRAIT(owner.current, TRAIT_ANTAG, TRAIT_GENERIC)
	return ..()

/datum/antagonist/suitor/on_removal()
	return ..()

/datum/antagonist/suitor/greet()
	to_chat(owner.current, span_userdanger("I've been sent here with a purpose. I must secure a marriage with the local duke in order to bolster my house's relations with Azuria, by any means necessary."))
	owner.announce_objectives()
	..()

/datum/antagonist/suitor/roundend_report()
	var/traitorwin = TRUE
	var/count = 0
	var/mob/living/carbon/human/marriagepartner = owner.current
	marriagepartner = marriagepartner.marriedto

	if(objectives.len)//If the traitor had no objectives, don't need to process this.
		for(var/datum/objective/objective in objectives)
			objective.update_explanation_text()
			if(!objective.check_completion())
				traitorwin = FALSE
			count++

	if(!count)
		count = 1

	if(traitorwin)
		owner.adjust_triumphs(3)
		to_chat(owner.current, span_greentext("I've successfully married into the throne and secured an alliance for my house!"))
		to_chat(world, span_greentext("[owner.current.real_name] successfully married [marriagepartner] and secured an alliance with Azuria for their house!"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		to_chat(owner.current, span_redtext("I've failed to secure a marriage into the throne of Azuria! My house will be disappointed!"))
		to_chat(world, span_redtext("[owner.current.real_name] failed to secure a marriage with the throne!"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)

