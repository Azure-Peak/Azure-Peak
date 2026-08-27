/datum/preferences/proc/ui_data_character_creator_descriptors(mob/user)
	// Data that doesn't require any conditionals goes inline here!
	var/list/data = list(
		"descriptors" = ui_data_descriptors(),
		"descriptors_custom" = ui_data_descriptors_custom(),
		// Examine Data
		"examine_theme" = "None (Use Viewer's)",
		"ooc_extra" = ooc_extra,
		"song_artist" = song_artist,
		"song_title" = song_title,

		"img_gallery" = img_gallery,
		"nsfw_img_gallery" = nsfw_img_gallery,

		"flavortext" = flavortext,
		"nsfwflavortext" = nsfwflavortext,
		"ooc_notes" = ooc_notes,
		"erpprefs" = erpprefs,
		"rumour" = rumour,
		"noble_gossip" = noble_gossip,

		"flavortext_cached" = null,
		"nsfwflavortext_cached" = null,
		"ooc_notes_cached" = null,
		"erpprefs_cached" = null,
		"rumour_cached" = null,
		"noble_gossip_cached" = null,
	)

	if(examine_theme)
		data["examine_theme"] = GLOB.tgui_themes[examine_theme] || examine_theme

	// clever way to reduce data: only send the markdown if they wanna see it
	if(LAZYACCESS(tgui_shared_states, "preview_flavortext"))
		data["flavortext_cached"] = flavortext_cached

	if(LAZYACCESS(tgui_shared_states, "preview_nsfwflavortext"))
		data["nsfwflavortext_cached"] = nsfwflavortext_cached

	if(LAZYACCESS(tgui_shared_states, "preview_ooc_notes"))
		data["ooc_notes_cached"] = ooc_notes_cached

	if(LAZYACCESS(tgui_shared_states, "preview_erpprefs"))
		data["erpprefs_cached"] = erpprefs_cached

	if(LAZYACCESS(tgui_shared_states, "preview_rumour"))
		data["rumour_cached"] = rumour_cached

	if(LAZYACCESS(tgui_shared_states, "preview_gossip"))
		data["noble_gossip_cached"] = noble_gossip_cached

	return data

/datum/preferences/proc/ui_data_descriptors(mob/user)
	var/list/descriptor_data = list()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
		var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(choice_type)
		UNTYPED_LIST_ADD(descriptor_data, list(
			"name" = choice.name,
			"type" = choice_type,
			"selected" = entry.descriptor_type,
		))

	return descriptor_data

/datum/preferences/proc/ui_data_descriptors_custom(mob/user)
	var/static/list/full_translation = CUSTOM_PREFIX_TRANSLATION_LIST
	var/static/list/article_translation = CUSTOM_ARTICLE_TRANSLATION_LIST
	var/static/list/custom_descriptor_types = CUSTOM_DESCRIPTOR_TYPE_LIST
	var/static/list/prefix_support = CUSTOM_DESCRIPTOR_SHOWS_PREFIX
	var/static/list/article_only_types = CUSTOM_DESCRIPTOR_ARTICLE_ONLY

	var/list/descriptors_custom = list()
	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		if(!has_descriptor_type_in_entries(custom_descriptor_types[i]))
			continue
		var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[i]
		var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(custom_descriptor_types[i])
		var/desc_type = custom_descriptor_types[i]

		var/prefix_display = null
		if(desc_type in prefix_support)
			var/is_article_only = (desc_type in article_only_types)
			var/translation = is_article_only ? article_translation : full_translation
			prefix_display = translation["[custom_entry.prefix_type]"]
			if(!prefix_display)
				prefix_display = is_article_only ? "a" : "Has a"

		UNTYPED_LIST_ADD(descriptors_custom, list(
			"index" = i,
			"name" = descriptor.name,
			"content" = custom_entry.content_text,
			"prefix_display" = prefix_display,
		))

	return descriptors_custom
