/mob/living/carbon/human/proc/request_law()
	set name = "Request Law"
	set category = "Voice of Command"
	if(stat)
		return
	var/inputty = input("Write a new law", "MARSHAL") as text|null
	if(inputty)
		if(hasomen(OMEN_NOLORD))
			make_law(inputty)
		else
			var/lord = find_lord()
			if(lord)
				INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(lord_law_requested), src, lord, inputty)
			else
				make_law(inputty)

/mob/living/carbon/human/proc/request_law_removal()
	set name = "Request Law Removal"
	set category = "Voice of Command"
	if(stat)
		return
	var/inputty = input("Remove a law", "MARSHAL") as text|null
	var/law_index = text2num(inputty) || 0
	if(law_index && GLOB.laws_of_the_land[law_index])
		if(hasomen(OMEN_NOLORD))
			remove_law(law_index)
		else
			var/lord = find_lord()
			if(lord)
				INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(lord_law_removal_requested), src, lord, law_index)
			else
				remove_law(law_index)

/mob/living/carbon/human/proc/request_purge()
	set name = "Request Purge"
	set category = "Voice of Command"
	if(stat)
		return
	if(hasomen(OMEN_NOLORD))
		purge_laws()
	else
		var/lord = find_lord()
		if(lord)
			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(lord_purge_requested), src, lord)
		else
			purge_laws()

/mob/living/carbon/human/proc/request_outlaw()
	set name = "Request Outlaw"
	set category = "Voice of Command"
	if(stat)
		return
	var/inputty = input("Outlaw a person", "MARSHAL") as text|null
	if(inputty)
		if(hasomen(OMEN_NOLORD))
			make_outlaw(inputty)
		else
			var/lord = find_lord()
			if(lord)
				INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(lord_outlaw_requested), src, lord, inputty)
			else
				make_outlaw(inputty)

/proc/find_lord(required_stat = CONSCIOUS)
	var/mob/living/lord
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.mind || H.job != "Grand Duke" || (H.stat > required_stat))
			continue
		lord = H
		break
	return lord

/proc/lord_law_requested(mob/living/bailiff, mob/living/carbon/human/lord, requested_law)
	var/choice = alert(lord, "The Marshal requests a new law!\n[requested_law]", "MARSHAL LAW REQUEST", "Yes", "No")
	message_admins("MARSHAL LAW REMOVAL: [bailiff.real_name] ([bailiff.ckey]) has requested law [requested_law]")
	log_game("MARSHAL LAW REMOVAL: [bailiff.real_name] ([bailiff.ckey]) has requested law [requested_law]")
	if(choice != "Yes" || QDELETED(lord) || lord.stat > CONSCIOUS)
		if(bailiff)
			to_chat(span_warning("The lord has denied the request for a new law!"))
		return
	make_law(requested_law)

/proc/lord_law_removal_requested(mob/living/bailiff, mob/living/carbon/human/lord, requested_law)
	if(!requested_law || !GLOB.laws_of_the_land[requested_law])
		return
	var/choice = alert(lord, "The Marshal requests the removal of a law!\n[GLOB.laws_of_the_land[requested_law]]", "MARSHAL LAW REQUEST", "Yes", "No")
	message_admins("MARSHAL LAW REMOVAL: [bailiff.real_name] ([bailiff.ckey]) has requested a removal of law [requested_law]")
	log_game("MARSHAL LAW REMOVAL: [bailiff.real_name] ([bailiff.ckey]) has requested a removal of law [requested_law]")
	if(choice != "Yes" || QDELETED(lord) || lord.stat > CONSCIOUS)
		if(bailiff)
			to_chat(span_warning("The lord has denied the request for a law removal!"))
		return
	remove_law(requested_law)

/proc/lord_purge_requested(mob/living/bailiff, mob/living/carbon/human/lord)
	var/choice = alert(lord, "The Marshal requests a purge of all laws!", "MARSHAL PURGE REQUEST", "Yes", "No")
	message_admins("MARSHAL LAW PURGE: [bailiff.real_name] ([bailiff.ckey]) has requested a law purge")
	log_game("MARSHAL LAW PURGE: [bailiff.real_name] ([bailiff.ckey]) has requested a law purge")
	if(choice != "Yes" || QDELETED(lord) || lord.stat > CONSCIOUS)
		if(bailiff)
			to_chat(span_warning("The lord has denied the request for a purge of all laws!"))
		return
	purge_laws()


/proc/lord_outlaw_requested(mob/living/bailiff, mob/living/carbon/human/lord, requested_outlaw)
	var/choice = alert(lord, "The Marshal requests to outlaw someone!\n[requested_outlaw]", "MARSHAL OUTLAW REQUEST", "Yes", "No")
	message_admins("MARSHAL OUTLAW REQUEST: [bailiff.real_name] ([bailiff.ckey]) has requested to outlaw [requested_outlaw]")
	log_game("MARSHAL OUTLAW REQUEST: [bailiff.real_name] ([bailiff.ckey]) has requested to outlaw [requested_outlaw]")
	if(choice != "Yes" || QDELETED(lord) || lord.stat > CONSCIOUS)
		if(bailiff)
			to_chat(span_warning("The lord has denied the request for declaring an outlaw!"))
		return
	make_outlaw(requested_outlaw)
