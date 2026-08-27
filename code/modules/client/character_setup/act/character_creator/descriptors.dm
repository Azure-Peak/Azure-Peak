/datum/preferences/proc/ui_act_character_creator_descriptors(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("set_descriptor")
			// Validate our DESCRIPTOR_CHOICE
			var/descriptor_choice = text2path(params["descriptor_choice"])
			if(!(descriptor_choice in pref_species.descriptor_choices))
				return CHARACTER_ACT_DATA_UPDATE
			var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(descriptor_choice)
			if(!choice)
				return CHARACTER_ACT_DATA_UPDATE

			// Validate our MOB_DESCRIPTOR
			var/mob_descriptor = text2path(params["mob_descriptor"])
			if(!(mob_descriptor in choice.descriptors))
				return CHARACTER_ACT_DATA_UPDATE
			var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(mob_descriptor)
			if(!descriptor)
				return CHARACTER_ACT_DATA_UPDATE

			// Set the entry
			var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(descriptor_choice)
			var/datum/mob_descriptor/prev = MOB_DESCRIPTOR(entry.descriptor_type)
			entry.descriptor_type = mob_descriptor

			verbose_pref_log_change(user, "notice", "Descriptor [LOWER_TEXT(choice.name)]", LOWER_TEXT(prev.name), LOWER_TEXT(descriptor.name))
			return CHARACTER_ACT_DATA_UPDATE

		if("custom_descriptor_prefix")
			var/static/list/full_translation = CUSTOM_PREFIX_TRANSLATION_LIST
			var/static/list/full_input = CUSTOM_PREFIX_INPUT_LIST
			var/static/list/article_translation = CUSTOM_ARTICLE_TRANSLATION_LIST
			var/static/list/article_input = CUSTOM_ARTICLE_INPUT_LIST
			var/static/list/article_only_types = CUSTOM_DESCRIPTOR_ARTICLE_ONLY
			var/static/list/custom_descriptor_types = CUSTOM_DESCRIPTOR_TYPE_LIST

			var/index = text2num(params["index"])
			var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[index]
			var/is_article_only = (custom_descriptor_types[index] in article_only_types)
			var/translation = is_article_only ? article_translation : full_translation
			var/input_list = is_article_only ? article_input : full_input
			var/current_prefix_text = translation["[custom_entry.prefix_type]"]
			if(!current_prefix_text)
				current_prefix_text = is_article_only ? "a" : "Has a"

			var/new_prefix_text = tgui_input_list(user, "Choose the article", "Describe myself", input_list, current_prefix_text)
			if(!new_prefix_text)
				return CHARACTER_ACT_DATA_UPDATE

			custom_entry.prefix_type = input_list[new_prefix_text]
			return CHARACTER_ACT_DATA_UPDATE

		if("custom_descriptor_content")
			var/index = text2num(params["index"])
			var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[index]
			var/new_content = tgui_input_text(user, "Describe the feature", "Describe myself", custom_entry.content_text, max_length = CUSTOM_DESCRIPTOR_TEXT_LENGTH)
			if(!new_content)
				return CHARACTER_ACT_DATA_UPDATE

			new_content = STRIP_HTML_SIMPLE(LOWER_TEXT(new_content), CUSTOM_DESCRIPTOR_TEXT_LENGTH)
			custom_entry.content_text = new_content
			verbose_pref_log_notification(user, "notice", "Custom Descriptor changed to \"[new_content]\"")
			return CHARACTER_ACT_DATA_UPDATE

		if("print_descriptor_setup")
			preview_descriptors(user)
			return CHARACTER_ACT_DATA_UPDATE

		if("preview_examine")
			var/datum/examine_panel/preview_examine_panel = new(user)
			preview_examine_panel.pref = src
			preview_examine_panel.holder = user
			preview_examine_panel.viewing = user
			preview_examine_panel.ui_interact(user)
			return CHARACTER_ACT_DATA_UPDATE

		if("save_markdown_text")
			var/type = params["type"]

			var/max_length = 0
			var/type_name = ""
			var/log = ""

			switch(type)
				if("flavortext")
					max_length = MAX_NOTE_SIZE
					type_name = "Flavor Text"
					log = "[user] has set their flavortext."
				if("ooc_notes")
					max_length = MAX_NOTE_SIZE
					type_name = "OOC Notes"
					log = "[user] has set their OOC notes."
				if("nsfwflavortext")
					max_length = MAX_NOTE_SIZE
					type_name = "NSFW Flavortext"
					log = "[user] has set their NSFW flavortext."
				if("erpprefs")
					max_length = MAX_NOTE_SIZE
					type_name = "ERP Preferences"
					log = "[user] has set their ERP Preferences."
				if("rumour")
					max_length = 400
					type_name = "Rumours"
					log = "[user] has set their rumour to %VALUE%."
				if("noble_gossip")
					max_length = 400
					type_name = "Noble Gossip"
					log = "[user] has set their noble gossip to %VALUE%."
				else
					return CHARACTER_ACT_DATA_UPDATE

			if(length(params["value"]) > max_length)
				to_chat(user, span_danger("Warning: [type_name] exceeds maximum length [max_length], it will be cut to size. Reload editors to see the final result in your Preferences Menu."))

			var/value = trim(params["value"], PREVENT_CHARACTER_TRIM_LOSS(max_length)) || null
			var/value_parsed = value ? parsemarkdown_basic(html_encode(value), hyperlink = TRUE) : null

			var/prev_length
			switch(type)
				if("flavortext")
					prev_length = length(flavortext)
					flavortext = value
					flavortext_cached = value_parsed
				if("ooc_notes")
					prev_length = length(ooc_notes)
					ooc_notes = value
					ooc_notes_cached = value_parsed
				if("nsfwflavortext")
					prev_length = length(nsfwflavortext)
					nsfwflavortext = value
					nsfwflavortext_cached = value_parsed
				if("erpprefs")
					prev_length = length(erpprefs)
					erpprefs = value
					erpprefs_cached = value_parsed
				if("rumour")
					prev_length = length(rumour)
					rumour = value
					rumour_cached = value_parsed
				if("noble_gossip")
					prev_length = length(noble_gossip)
					noble_gossip = value
					noble_gossip_cached = value_parsed

			verbose_pref_log_change(user, "notice", "[type_name]", "[prev_length] characters", "[length(value)] characters")
			log_game(replacetext(log, "%VALUE%", html_encode(value)))
			return CHARACTER_ACT_DATA_UPDATE

		// SFW Gallery
		if("add_img_gallery")
			if(length(img_gallery) >= 3)
				to_chat(user, span_danger("You already have three images in your gallery!"))
				return CHARACTER_ACT_DATA_UPDATE

			var/new_galleryimg = input_image_gallery_entry(user, "Gallery")
			if(new_galleryimg == null || new_galleryimg == "")
				return CHARACTER_ACT_DATA_UPDATE

			img_gallery += new_galleryimg
			verbose_pref_log_notification(user, "notice", "Added image '[html_encode(new_galleryimg)]' to gallery")
			log_game("[user] has added an image to their gallery: '[html_encode(new_galleryimg)]'.")
			return CHARACTER_ACT_DATA_UPDATE

		if("clear_img_gallery")
			if(!length(img_gallery))
				to_chat(user, span_danger("You don't have any images in your gallery to clear!"))
				return CHARACTER_ACT_DATA_UPDATE
			var/dachoice = tgui_alert(user, "Do you really want to clear your image gallery?", "Clear Gallery", list("Yae", "Nae"))
			if(dachoice == "Nae")
				return CHARACTER_ACT_DATA_UPDATE
			img_gallery = list()
			verbose_pref_log_notification(user, "warning", "Cleared image gallery")
			log_game("[user] has cleared their image gallery.")
			return CHARACTER_ACT_DATA_UPDATE

		if("set_img_gallery")
			var/index = params["index"]
			if(index < 1 || index > length(img_gallery))
				return CHARACTER_ACT_DATA_UPDATE

			var/new_galleryimg = input_image_gallery_entry(user, "Gallery", img_gallery[index])

			if(new_galleryimg == null)
				return CHARACTER_ACT_DATA_UPDATE
			if(new_galleryimg == "")
				// Remove entry
				verbose_pref_log_notification(user, "notice", "Removed image '[html_encode(img_gallery[index])]' from image gallery")
				img_gallery.Cut(index, index + 1)
				return CHARACTER_ACT_DATA_UPDATE

			verbose_pref_log_change(user, "notice", "Image Gallery #[index]", html_encode(img_gallery[index]), html_encode(new_galleryimg))
			log_game("[user] has changed an image in their gallery: '[html_encode(img_gallery[index])]' to '[html_encode(new_galleryimg)]'.")
			img_gallery[index] = new_galleryimg
			return CHARACTER_ACT_DATA_UPDATE

		// NSFW Gallery
		if("add_nsfw_img_gallery")
			if(length(nsfw_img_gallery) >= 3)
				to_chat(user, span_danger("You already have three images in your NSFW gallery!"))
				return CHARACTER_ACT_DATA_UPDATE

			var/new_galleryimg = input_image_gallery_entry(user, "NSFW Gallery")
			if(new_galleryimg == null || new_galleryimg == "")
				return CHARACTER_ACT_DATA_UPDATE

			nsfw_img_gallery += new_galleryimg
			verbose_pref_log_notification(user, "notice", "Added image '[html_encode(new_galleryimg)]' to NSFW gallery")
			log_game("[user] has added an image to their NSFW gallery: '[html_encode(new_galleryimg)]'.")
			return CHARACTER_ACT_DATA_UPDATE

		if("clear_nsfw_img_gallery")
			if(!length(nsfw_img_gallery))
				to_chat(user, span_danger("You don't have any images in your NSFW gallery to clear!"))
				return CHARACTER_ACT_DATA_UPDATE
			var/dachoice = tgui_alert(user, "Do you really want to clear your NSFW image gallery?", "Clear NSFW Gallery", list("Yae", "Nae"))
			if(dachoice == "Nae")
				return CHARACTER_ACT_DATA_UPDATE
			nsfw_img_gallery = list()
			verbose_pref_log_notification(user, "warning", "Cleared NSFW image gallery")
			log_game("[user] has cleared their NSFW image gallery.")
			return CHARACTER_ACT_DATA_UPDATE

		if("set_nsfw_img_gallery")
			var/index = params["index"]
			if(index < 1 || index > length(nsfw_img_gallery))
				return CHARACTER_ACT_DATA_UPDATE

			var/new_galleryimg = input_image_gallery_entry(user, "NSFW Gallery", nsfw_img_gallery[index])

			if(new_galleryimg == null)
				return CHARACTER_ACT_DATA_UPDATE
			if(new_galleryimg == "")
				// Remove entry
				verbose_pref_log_notification(user, "notice", "Removed image '[html_encode(nsfw_img_gallery[index])]' from NSFW gallery")
				nsfw_img_gallery.Cut(index, index + 1)
				return CHARACTER_ACT_DATA_UPDATE

			verbose_pref_log_change(user, "notice", "NSFW Gallery #[index]", html_encode(nsfw_img_gallery[index]), html_encode(new_galleryimg))
			log_game("[user] has changed an image in their NSFW gallery: '[html_encode(nsfw_img_gallery[index])]' to '[html_encode(new_galleryimg)]'.")
			nsfw_img_gallery[index] = new_galleryimg
			return CHARACTER_ACT_DATA_UPDATE

		// Rumours
		if("rumour_preview")
			var/msg = ""
			if(length(rumour_cached))
				msg += "<b>You recall what you heard around Town about [real_name]...</b><br>[rumour_cached]"
			if(length(noble_gossip_cached))
				if(msg)
					msg += "<br><br>"
				msg += "<b>You recall what the other Blue-bloods hushed about [real_name]...</b><br>[noble_gossip_cached]"
			if(msg)
				to_chat(user, span_info("[msg]"))
			else
				to_chat(user, span_warning("Your rumors and noble gossip entries are empty."))
			return CHARACTER_ACT_DATA_UPDATE

		if("examine_theme")
			var/list/choices = list("None (Use Viewer's)")
			for(var/theme_key in GLOB.tgui_themes)
				if(theme_key == "trey_liam")
					continue
				choices += GLOB.tgui_themes[theme_key]
			var/current_display = "None (Use Viewer's)"
			if(examine_theme)
				current_display = GLOB.tgui_themes[examine_theme] || examine_theme
			var/picked = tgui_input_list(user, "Choose the theme others see on your examine panel:", "Examine Theme", choices, current_display)
			if(!picked)
				return
			if(picked == "None (Use Viewer's)")
				examine_theme = null
			else
				for(var/theme_key in GLOB.tgui_themes)
					if(GLOB.tgui_themes[theme_key] == picked)
						examine_theme = theme_key
						break
			verbose_pref_log_change(user, "notice", "Examine Theme", current_display, picked)
			return CHARACTER_ACT_DATA_UPDATE

		if("ooc_extra")
			to_chat(user, span_notice("Add a link from a suitable host (catbox, etc) to an mp3 to embed in your flavor text."))
			to_chat(user, span_notice("If the song doesn't  play properly, ensure that it's a direct link that opens properly in a browser."))
			to_chat(user, "<font color='#d6d6d6'>Leave blank to clear your current song.</font>")
			to_chat(user, span_danger("Abuse of this will get you banned."))
			var/new_extra_link = tgui_input_text(user, "Input the accessory link (https, hosts: discord, catbox):", "Song URL", ooc_extra, max_length = MAX_MESSAGE_LEN, encode = FALSE)
			if(new_extra_link == null)
				return CHARACTER_ACT_DATA_UPDATE
			if(new_extra_link == "")
				verbose_pref_log_change(user, "notice", "Song URL", html_encode(ooc_extra), "")
				ooc_extra = null
				return CHARACTER_ACT_DATA_UPDATE
			var/static/list/valid_extensions = list("mp3")
			if(!valid_headshot_link(user, new_extra_link, FALSE, valid_extensions))
				return CHARACTER_ACT_DATA_UPDATE

			var/list/value_split = splittext(new_extra_link, ".")

			// extension will always be the last entry
			var/extension = value_split[length(value_split)]
			if((extension in valid_extensions))
				verbose_pref_log_change(user, "notice", "Song URL", html_encode(ooc_extra), html_encode(new_extra_link))
				ooc_extra = new_extra_link
				log_game("[user] has set their Song URL to '[html_encode(ooc_extra)]'.")
			return CHARACTER_ACT_DATA_UPDATE

		if("change_artist")
			var/new_artist = tgui_input_text(user, "Input your song's artist:", "Song Artist", song_artist, max_length = MAX_MESSAGE_LEN, encode = FALSE)
			if(new_artist == null)
				return CHARACTER_ACT_DATA_UPDATE
			verbose_pref_log_change(user, "notice", "Song Artist", song_artist, new_artist)
			if(new_artist == "")
				song_artist = null
			else
				song_artist = new_artist
			log_game("[user] has set their song artist.")
			return CHARACTER_ACT_DATA_UPDATE

		if("change_title")
			var/new_title = tgui_input_text(user, "Input your song's title:", "Song title", song_title, max_length = MAX_SONG_TITLE_LENGTH, encode = FALSE)
			if(new_title == null)
				return CHARACTER_ACT_DATA_UPDATE
			verbose_pref_log_change(user, "notice", "Song Title", song_title, new_title)
			if(new_title == "")
				song_title = null
			else
				song_title = new_title
			log_game("[user] has set their song title.")
			return CHARACTER_ACT_DATA_UPDATE

/datum/preferences/proc/input_image_gallery_entry(mob/user, gallery_name, default)
	// Print disclaimers
	if(gallery_name == "NSFW Gallery")
		to_chat(user, span_notice("Please use an explicit image [span_bold("of your character")] only when it fits the character and server rules."))
		to_chat(user, span_notice("If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser."))
		to_chat(user, span_notice("Keep in mind that all three images are displayed next to eachother and justified to fill a horizontal rectangle. As such, vertical images work best."))
		to_chat(user, span_notice("You can only have a maximum of [span_bold("THREE IMAGES")] in your NSFW gallery at a time."))
	else
		to_chat(user, span_notice("Please use a relatively SFW image [span_bold("of your character")] to maintain immersion level. Lastly, [span_bold("do not use a real life photo or use any image that is less than serious.")]"))
		to_chat(user, span_notice("If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser."))
		to_chat(user, span_notice("Keep in mind that all three images are displayed next to eachother and justified to fill a horizontal rectangle. As such, vertical images work best."))
		to_chat(user, span_notice("You can only have a maximum of [span_bold("THREE IMAGES")] in your gallery at a time."))

	// Get input
	var/new_galleryimg = tgui_input_text(user, "Input the image link (https, hosts: gyazo, discord, lensdump, imgbox, catbox, file garden) (empty clears):", "[gallery_name] Image", default, max_length = MAX_MESSAGE_LEN, encode = FALSE)

	if(new_galleryimg == null || new_galleryimg == "")
		return new_galleryimg

	if(!valid_headshot_link(user, new_galleryimg))
		to_chat(user, span_notice("Invalid image link. Make sure it's a direct link from a valid host (gyazo, discord, lensdump, imgbox, catbox, file garden)."))
		return null

	return new_galleryimg

/datum/preferences/proc/preview_descriptors(mob/user)
	if(!COOLDOWN_FINISHED(src, descriptor_preview))
		to_chat(user, span_warning("You must wait before previewing descriptors again."))
		return
	COOLDOWN_START(src, descriptor_preview, 5 SECONDS)
	to_chat(user, span_notice("-- Preview of [real_name]'s descriptors --"))

	// someone please fix this horror one day
	var/mob/living/temp = new /mob/living(null)
	temp.pronouns = pronouns
	apply_descriptors(temp)

	// Calculate speaking name
	to_chat(user, \
		"[SPAN_TOOLTIP("This will be displayed when you speak when your face is hidden or out of view range.", span_notice("Anonymous Speaking Name"))]: \
		<font color='[voice_color]'>[get_speaking_name_preview(temp)]</font>")

	// Calculate visible name
	var/list/descriptors = temp.get_mob_descriptors(FALSE, null)
	to_chat(user, \
		"[SPAN_TOOLTIP("This will be displayed when you emote or are examined when your face is hidden.", span_notice("Anonymous Visible Name"))]: \
		<font color='[voice_color]'>[get_visible_name_preview(temp, descriptors.Copy())]</font>")

	// Calculate descriptor blurb
	var/list/desc_lines = build_cool_description(descriptors, temp)
	QDEL_NULL(temp)

	// Output blurb
	var/output = "<details><summary>[span_info("Details")]</summary>"
	for(var/line in desc_lines)
		output += span_info(line)
		output += "<br>"
	output += "</details>"
	to_chat(user, output)

// This should mirror /mob/living/carbon/human/get_alt_name()
/datum/preferences/proc/get_speaking_name_preview(mob/living/temp)
	// Get voice
	var/datum/mob_descriptor/voice/voice_descriptor = temp.get_descriptor_type(/datum/mob_descriptor/voice)
	if(!voice_descriptor)
		return "Unknown Person"
	var/voice_gender = "Person"
	switch(voice_type)
		if(VOICE_TYPE_FEM)
			voice_gender = "Woman"
		if(VOICE_TYPE_MASC)
			voice_gender = "Man"
		if(VOICE_TYPE_ANDR)
			voice_gender = "Person"
	return voice_descriptor.get_speaking_name(voice_gender, src)

// This should mirror /mob/living/carbon/human/get_visible_name()
/datum/preferences/proc/get_visible_name_preview(mob/living/temp, list/descriptors)
	var/trait_desc = "[capitalize(build_coalesce_description_nofluff(descriptors, temp, list(MOB_DESCRIPTOR_SLOT_TRAIT), "%DESC1%"))]"
	var/stature_desc = "[capitalize(build_coalesce_description_nofluff(descriptors, temp, list(MOB_DESCRIPTOR_SLOT_STATURE), "%DESC1%"))]"
	return "[trait_desc] [stature_desc]"
