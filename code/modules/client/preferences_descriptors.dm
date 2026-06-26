/datum/preferences/proc/validate_descriptors()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
		var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(choice_type)
		if(entry)
			continue
		entry = new /datum/descriptor_entry()
		if(choice.default_descriptor)
			entry.set_values(choice_type, choice.default_descriptor)
		else
			entry.set_values(choice_type, pick(choice.descriptors))
		descriptor_entries += entry

	for(var/datum/descriptor_entry/entry as anything in descriptor_entries)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(entry.descriptor_choice_type)
		if(!choice)
			continue
		if(entry.descriptor_type == null || !(entry.descriptor_type in choice.descriptors))
			if(choice.default_descriptor)
				entry.descriptor_type = choice.default_descriptor
			else
				entry.descriptor_type = pick(choice.descriptors)
	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		if(length(custom_descriptors) >= i)
			continue
		var/datum/custom_descriptor_entry/custom_entry = new /datum/custom_descriptor_entry()
		custom_descriptors += custom_entry
	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[i]
		custom_entry.prefix_type = sanitize_integer(custom_entry.prefix_type, 1, CUSTOM_PREFIX_AMOUNT, CUSTOM_PREFIX_HAS_A)
		custom_entry.content_text = STRIP_HTML_SIMPLE(lowertext(custom_entry.content_text), CUSTOM_DESCRIPTOR_TEXT_LENGTH)

/datum/preferences/proc/reset_descriptors()
	descriptor_entries = list()
	custom_descriptors = list()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
		var/datum/descriptor_entry/entry = new /datum/descriptor_entry()
		if(choice.default_descriptor)
			entry.set_values(choice_type, choice.default_descriptor)
		else
			entry.set_values(choice_type, pick(choice.descriptors))
		descriptor_entries += entry
	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		var/datum/custom_descriptor_entry/custom_entry = new /datum/custom_descriptor_entry()
		custom_descriptors += custom_entry

/datum/preferences/proc/handle_descriptors_topic(mob/user, href_list)
	switch(href_list["preference"])
		if("choose_descriptor")
			var/choice_type = text2path(href_list["descriptor_choice"])
			if(!(choice_type in pref_species.descriptor_choices))
				return
			var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
			if(!choice)
				return
			var/list/picklist = list()
			for(var/desc_type in choice.descriptors)
				var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(desc_type)
				picklist[descriptor.name] = desc_type
			var/picked_descriptor_name = input(user, "Describe my [lowertext(choice.name)]", "Describe myself") as null|anything in picklist

			if(!picked_descriptor_name)
				return
			var/picked_type = picklist[picked_descriptor_name]
			var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(choice_type)
			entry.descriptor_type = picked_type
		if("custom_descriptor_prefix")
			var/static/list/full_translation = CUSTOM_PREFIX_TRANSLATION_LIST
			var/static/list/full_input = CUSTOM_PREFIX_INPUT_LIST
			var/static/list/article_translation = CUSTOM_ARTICLE_TRANSLATION_LIST
			var/static/list/article_input = CUSTOM_ARTICLE_INPUT_LIST
			var/static/list/article_only_types = CUSTOM_DESCRIPTOR_ARTICLE_ONLY
			var/static/list/custom_descriptor_types = CUSTOM_DESCRIPTOR_TYPE_LIST
			var/index = text2num(href_list["index"])
			var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[index]
			var/is_article_only = (custom_descriptor_types[index] in article_only_types)
			var/translation = is_article_only ? article_translation : full_translation
			var/input_list = is_article_only ? article_input : full_input
			var/current_prefix_text = translation["[custom_entry.prefix_type]"]
			if(!current_prefix_text)
				current_prefix_text = is_article_only ? "a" : "Has a"
			var/new_prefix_text = input(user, "Choose the article", "Describe myself", current_prefix_text) as null|anything in input_list
			if(!new_prefix_text)
				return
			custom_entry.prefix_type = input_list[new_prefix_text]
		if("custom_descriptor_content")
			var/index = text2num(href_list["index"])
			var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[index]
			var/new_content = input(user, "Describe the feature", "Describe myself") as text|null
			if(!new_content)
				return
			new_content = STRIP_HTML_SIMPLE(lowertext(new_content), CUSTOM_DESCRIPTOR_TEXT_LENGTH)
			custom_entry.content_text = new_content
		if("print_descriptor_setup")
			var/mob/living/temp = new /mob/living(null)
			temp.pronouns = pronouns
			apply_descriptors(temp)
			var/list/desc_lines = build_cool_description(temp.get_mob_descriptors(FALSE, null), temp)
			qdel(temp)
			var/output = ""
			if(!(user.client?.prefs?.full_examine))
				output = "<details><summary>[span_info("Details")]</summary>"
			for(var/line in desc_lines)
				output += span_info(line)
				output += "<br>"
			if(!(user.client?.prefs?.full_examine))
				if(length(desc_lines))
					output += "</details>"
			to_chat(user, output)

/datum/preferences/proc/print_descriptors_page()
	var/list/dat = list()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
		var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(choice_type)
		var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(entry.descriptor_type)
		dat += "<b>[choice.name]:</b> <a href='?_src_=prefs;descriptor_choice=[choice_type];preference=choose_descriptor;task=change_descriptor'>[descriptor.name]</a><br>"

	var/static/list/custom_descriptor_types = CUSTOM_DESCRIPTOR_TYPE_LIST
	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		if(!has_descriptor_type_in_entries(custom_descriptor_types[i]))
			continue
		var/list/custom_data = print_custom_descriptor_customization(i)
		if(custom_data)
			dat += custom_data

	dat += "<br><a href='?_src_=prefs;preference=print_descriptor_setup;task=change_descriptor'>Print descriptor setup to chat</a>"
	dat += "<br><center><b>Custom descriptor rules:</b> No proper nouns. No immersion breaking words. No overtly sexual descriptors. Look at the pre-written descriptors for examples of what is acceptable. Capitalization is handled automatically.</center>"
	return dat

/datum/preferences/proc/print_custom_descriptor_customization(index)
	var/static/list/full_translation = CUSTOM_PREFIX_TRANSLATION_LIST
	var/static/list/article_translation = CUSTOM_ARTICLE_TRANSLATION_LIST
	var/static/list/custom_descriptor_types = CUSTOM_DESCRIPTOR_TYPE_LIST
	var/static/list/prefix_support = CUSTOM_DESCRIPTOR_SHOWS_PREFIX
	var/static/list/article_only_types = CUSTOM_DESCRIPTOR_ARTICLE_ONLY
	var/list/dat = list()
	var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[index]
	var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(custom_descriptor_types[index])
	var/desc_type = custom_descriptor_types[index]
	if(desc_type in prefix_support)
		var/is_article_only = (desc_type in article_only_types)
		var/translation = is_article_only ? article_translation : full_translation
		var/prefix_display = translation["[custom_entry.prefix_type]"]
		if(!prefix_display)
			prefix_display = is_article_only ? "a" : "Has a"
		dat += "<br><b>[descriptor.name]:</b> <a href='?_src_=prefs;index=[index];preference=custom_descriptor_prefix;task=change_descriptor'>[prefix_display]</a> <a href='?_src_=prefs;index=[index];preference=custom_descriptor_content;task=change_descriptor'>[custom_entry.content_text]</a>"
	else
		dat += "<br><b>[descriptor.name]:</b> <a href='?_src_=prefs;index=[index];preference=custom_descriptor_content;task=change_descriptor'>[custom_entry.content_text]</a>"
	return dat

/datum/preferences/proc/show_descriptors_ui(mob/user)
	var/list/dat = list()
	dat += print_descriptors_page()
	var/datum/browser/popup = new(user, "descriptors_customization", "<div align='center'>Describe myself</div>", 350, 510)
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/has_descriptor_type_in_entries(descriptor_type)
	if(length(descriptor_entries))
		for(var/datum/descriptor_entry/entry as anything in descriptor_entries)
			if(entry.descriptor_type != descriptor_type)
				continue
			return TRUE
	return FALSE

/datum/preferences/proc/get_descriptor_entry_for_choice(choice_type)
	if(length(descriptor_entries))
		for(var/datum/descriptor_entry/entry as anything in descriptor_entries)
			if(entry.descriptor_choice_type != choice_type)
				continue
			return entry
	return null

/datum/preferences/proc/apply_descriptors(mob/living/character)
	character.clear_mob_descriptors()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(choice_type)
		character.add_mob_descriptor(entry.descriptor_type)
	character.custom_descriptors = list()
	for(var/datum/custom_descriptor_entry/entry as anything in custom_descriptors)
		var/datum/custom_descriptor_entry/new_entry = new /datum/custom_descriptor_entry()
		new_entry.prefix_type = entry.prefix_type
		new_entry.content_text = entry.content_text
		character.custom_descriptors += new_entry
