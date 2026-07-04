/datum/component/voice_handler
	var/original_color
	var/second_color
	var/natural_desc_path
	var/second_desc_path
	var/active_state = FALSE // FALSE = Natural, TRUE = Second
	var/virtue_setup = FALSE

/datum/component/voice_handler/proc/setup(mob/living/carbon/human/H)
	src.original_color = H.voice_color
	var/datum/descriptor_choice/VC = DESCRIPTOR_CHOICE(/datum/descriptor_choice/voice)
	var/list/current_descs = H.get_mob_descriptors()
	for(var/path in current_descs)
		if(path in VC.descriptors)
			src.natural_desc_path = path
			break
	virtue_setup = TRUE

/datum/component/voice_handler/proc/toggle_voice()
	var/mob/living/carbon/human/H = parent
	if(!virtue_setup)
		setup(H)
	if(!second_color)
		to_chat(H, span_info("I haven't decided on my second voice yet."))
		return

	active_state = !active_state

	if(active_state)
		// Switch to Second
		H.voice_color = second_color
		if(natural_desc_path) H.remove_mob_descriptor(natural_desc_path)
		if(second_desc_path) H.add_mob_descriptor(second_desc_path)
		to_chat(H, span_info("I've changed my voice to the second one."))
	else
		// Switch to Natural
		H.voice_color = original_color
		if(second_desc_path) H.remove_mob_descriptor(second_desc_path)
		if(natural_desc_path) H.add_mob_descriptor(natural_desc_path)
		to_chat(H, span_info("I've returned to my natural voice."))

	//parent.update_appearance()
