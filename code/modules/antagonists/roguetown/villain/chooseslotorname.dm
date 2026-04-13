/mob/living/carbon/human/proc/load_char_or_namechoice()
	if(QDELETED(src))
		return

	if(!client?.prefs?.path)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup)), 3 SECONDS)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)
		return

	var/list/choices = list()
	var/savefile/S = new /savefile(client.prefs.path)
	if(S)
		for(var/i=1, i<=client.prefs.max_save_slots, i++)
			var/name
			S.cd = "/character[i]"
			S["real_name"] >> name
			if(!name)
				name = "Slot[i]"
			choices[name] = i

	choices += "Choose A Name"

	var/choice = tgui_input_list(src, "Would you like to play as one of your characters or choose a name yourself?","CHOOSE A HERO", choices)
	if(QDELETED(src))
		return

	if(!client?.prefs || choice == "Choose A Name")
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup)), 3 SECONDS)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)
		return
	else
		choice = choices[choice]
		if(!client.prefs.load_character(choice))
			to_chat(src, span_userdanger("Char load failed, choosing name, body and pronouns now."))
			addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup)), 3 SECONDS)
			addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)
		else
			client.prefs.copy_to(src, TRUE, FALSE, FALSE, TRUE)
