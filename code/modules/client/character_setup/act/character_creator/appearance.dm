/datum/preferences/proc/ui_act_character_creator_appearance(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ui_act_character_creator_appearance_body(action, params, ui, state)
	if(.)
		return

	. = ui_act_character_creator_appearance_customizers(action, params, ui, state)
	if(.)
		return

	. = ui_act_character_creator_appearance_markings(action, params, ui, state)
	if(.)
		return


/datum/preferences/proc/ui_act_character_creator_appearance_body(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("bodytype")
			var/static/list/friendlyGenders = list("male" = "masculine", "female" = "feminine")
			var/pickedGender = gender == "male" ? "female" : "male"
			verbose_pref_log_change(user, "notice", "Body Type", friendlyGenders[gender], friendlyGenders[pickedGender])
			gender = pickedGender
			genderize_customizer_entries()
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("race_bonus_select")
			if(length(pref_species.custom_selection))
				var/choice = tgui_input_list(user, "What has fate blessed your race with?", "BONUS", pref_species.custom_selection, race_bonus)
				if(choice)
					verbose_pref_log_change(user, "notice", "Racial Bonus", race_bonus, choice)
					race_bonus = choice
			return CHARACTER_ACT_DATA_UPDATE
		if("taur_color")
			var/new_taur_color = tgui_color_picker(user, "Choose your character's taur color:", "Taur Color", taur_color)
			if(new_taur_color)
				verbose_pref_log_change(user, "notice", "Taur Color", "[taur_color]", "[new_taur_color]")
				taur_color = new_taur_color
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("set_skin_tone")
			var/list/valid_skin_tones = get_valid_skin_tones()

			var/selected = params["skin_tone"]
			if(!(selected in valid_skin_tones))
				return CHARACTER_ACT_DATA_UPDATE

			// Reverse mapping for logging
			var/current_tone = "<unknown>"
			for(var/tone in valid_skin_tones)
				if(valid_skin_tones[tone] == skin_tone)
					current_tone = tone

			verbose_pref_log_change(user, "notice", "[pref_species.skin_tone_wording]", "[current_tone]", "[selected]")
			skin_tone = valid_skin_tones[selected]
			features["mcolor"] = sanitize_hexcolor(skin_tone)
			try_update_mutant_colors(user)
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("update_mutant_colors")
			update_mutant_colors = !update_mutant_colors
			verbose_pref_log_change(user, "notice", "Update Mutant Colors", "[update_mutant_colors ? "not resetting" : "resetting"] colors", "[update_mutant_colors ? "resetting" : "not resetting"] colors")
			return CHARACTER_ACT_DATA_UPDATE
		if("mutant_color")
			var/new_mutantcolor = tgui_color_picker(user, "Choose your character's mutant #1 color:", "Mutant Color #1", "#"+features["mcolor"], include_crunch = FALSE)
			if(new_mutantcolor)
				verbose_pref_log_change(user, "notice", "Mutant Color #1", "#[features["mcolor"]]", "#[new_mutantcolor]")
				features["mcolor"] = new_mutantcolor
				try_update_mutant_colors(user)
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("mutant_color2")
			var/new_mutantcolor = tgui_color_picker(user, "Choose your character's mutant #2 color:", "Mutant Color #2", "#"+features["mcolor2"], include_crunch = FALSE)
			if(new_mutantcolor)
				verbose_pref_log_change(user, "notice", "Mutant Color #2", "#[features["mcolor2"]]", "#[new_mutantcolor]")
				features["mcolor2"] = new_mutantcolor
				try_update_mutant_colors(user)
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("mutant_color3")
			var/new_mutantcolor = tgui_color_picker(user, "Choose your character's mutant #3 color:", "Mutant Color #3", "#"+features["mcolor3"], include_crunch = FALSE)
			if(new_mutantcolor)
				verbose_pref_log_change(user, "notice", "Mutant Color #3", "#[features["mcolor3"]]", "#[new_mutantcolor]")
				features["mcolor3"] = new_mutantcolor
				try_update_mutant_colors(user)
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("body_size")
			var/new_body_size = tgui_input_number(user, "Choose your desired sprite size:\n([BODY_SIZE_MIN*100]%-[BODY_SIZE_MAX*100]%), Warning: May make your character look distorted", "Character Preference", features["body_size"]*100, ceil(BODY_SIZE_MAX*100), floor(BODY_SIZE_MIN*100))
			if(new_body_size)
				new_body_size = round(clamp(new_body_size * 0.01, BODY_SIZE_MIN, BODY_SIZE_MAX), 0.01)
				verbose_pref_log_change(user, "notice", "Body Size", "[features["body_size"] * 100]%", "[new_body_size * 100]%")
				features["body_size"] = new_body_size
			return CHARACTER_ACT_PREVIEW_UPDATE

/datum/preferences/proc/try_update_mutant_colors(user)
	if(update_mutant_colors)
		verbose_pref_log_notification(user, "warning", "Body Marking & Feature colors reset due to mutant color change")
		reset_body_marking_colors()
		reset_all_customizer_accessory_colors()

/datum/preferences/proc/ui_act_character_creator_appearance_customizers(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(action != "change_customizer")
		return

	var/mob/user = ui.user
	var/customizer_type = text2path(params["customizer"])
	var/datum/customizer_entry/entry = get_customizer_entry_for_customizer_type(customizer_type)
	if(!entry)
		return CHARACTER_ACT_DATA_UPDATE
	var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
	var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
	switch(params["customizer_task"])
		if("toggle_missing")
			if(customizer.allows_disabling)
				entry.disabled = !entry.disabled
			verbose_pref_log_change(user, "notice", "Feature [choice.name]", entry.disabled ? "Enabled" : "Disabled", entry.disabled ? "Disabled" : "Enabled")
			return CHARACTER_ACT_PREVIEW_UPDATE
		else
			choice.handle_tgui_act(params, ui, src, entry, customizer_type)
			return CHARACTER_ACT_PREVIEW_UPDATE

/datum/preferences/proc/ui_act_character_creator_appearance_markings(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("marking_use_preset")
			var/confirm = alert(usr, "Are you sure you want to use a preset (This will clear your existing markings)?", "Markings Preset", "Yes", "No")
			if(confirm != "Yes")
				return CHARACTER_ACT_DATA_UPDATE
			var/list/candidates = marking_sets_for_species(pref_species)
			if(length(candidates) == 0)
				return CHARACTER_ACT_DATA_UPDATE
			var/desired_set = tgui_input_list(user, "Choose your new body markings:", "Marking Preset", candidates)
			if(!desired_set)
				return CHARACTER_ACT_DATA_UPDATE
			var/datum/body_marking_set/BMS = GLOB.body_marking_sets[desired_set]
			body_markings = assemble_body_markings_from_set(BMS, features, pref_species)
			verbose_pref_log_notification(user, "notice", "Now using marking preset \"[desired_set]\"")
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("marking_reset_color")
			var/zone = params["key"]
			var/name = params["name"]
			if(!body_markings[zone] || !body_markings[zone][name])
				return CHARACTER_ACT_DATA_UPDATE
			var/datum/body_marking/BM = GLOB.body_markings[name]
			body_markings[zone][name] = BM.get_default_color(features, pref_species)
			verbose_pref_log_notification(user, "warning", "Marking \"[name]\" color reset in \"[capitalize(zone)]\"")
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("marking_change_color")
			var/zone = params["key"]
			var/name = params["name"]
			if(!body_markings[zone] || !body_markings[zone][name])
				return CHARACTER_ACT_DATA_UPDATE
			var/color = body_markings[zone][name]
			var/new_color = tgui_color_picker(user, "Choose your markings color:", "Marking Color", "#[color]", include_crunch = FALSE)
			if(!new_color)
				return CHARACTER_ACT_DATA_UPDATE
			if(!body_markings[zone] || !body_markings[zone][name])
				return CHARACTER_ACT_DATA_UPDATE
			verbose_pref_log_change(user, "notice", "Marking \"[name]\" in \"[capitalize(zone)]\" color", "#[color]", "#[new_color]")
			body_markings[zone][name] = new_color
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("reorder_zone")
			var/zone = params["zone"]
			// Validate zone
			if(!(zone in GLOB.marking_zones))
				return CHARACTER_ACT_DATA_UPDATE
			// Validate their new zone order
			var/list/new_zone = sanitize_new_body_marking_zone_entry(zone, params["new_zone"])
			if(!new_zone)
				return CHARACTER_ACT_DATA_UPDATE
			body_markings[zone] = new_zone
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("remove_marking")
			var/zone = params["key"]
			var/name = params["name"]
			if(!body_markings[zone] || !body_markings[zone][name])
				return CHARACTER_ACT_DATA_UPDATE
			remove_marking_from_zone(zone, name)
			verbose_pref_log_notification(user, "warning", "Marking \"[name]\" removed from \"[capitalize(zone)]\"")
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("change_marking")
			var/zone = params["key"]
			var/changing_name = params["name"]
			var/list/possible_candidates = marking_list_of_zone_for_species(zone, pref_species)
			if(body_markings[zone])
				//Remove already used markings from the candidates
				for(var/keyed_name in body_markings[zone])
					possible_candidates -= keyed_name
			if(possible_candidates.len == 0)
				return CHARACTER_ACT_DATA_UPDATE
			var/desired_marking = tgui_input_list(user, "Choose a marking to change the current one to:", "Change Marking", possible_candidates)
			if(desired_marking)
				if(!(zone in body_markings) || !(changing_name in body_markings[zone]))
					return CHARACTER_ACT_DATA_UPDATE
				var/held_index = LAZYFIND(body_markings[zone], changing_name)
				var/datum/body_marking/BD = GLOB.body_markings[desired_marking]
				var/marking_content = BD.get_default_color(features, pref_species)
				remove_marking_from_zone(zone, changing_name, FALSE)
				body_markings[zone].Insert(held_index, desired_marking)
				body_markings[zone][desired_marking] = marking_content
				verbose_pref_log_change(user, "notice", "Marking in \"[capitalize(zone)]\"", changing_name, desired_marking)
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("marking_reset_all_colors")
			reset_body_marking_colors()
			verbose_pref_log_notification(user, "warning", "All marking colors reset")
			return CHARACTER_ACT_PREVIEW_UPDATE

/* So, a correct body_markings list looks like this:
 * {3
 *   head: {
 *     // This inner list is what we're expecting
 *     marking_name: "#00ffff",
 *     marking_name2: "#ff00ff",
 *   }
 * }
 */
/datum/preferences/proc/sanitize_new_body_marking_zone_entry(zone, list/potential_list)
	// Zone must already be validated
	// Must be a list, must follow MAXIMUM_MARKINGS_PER_LIMB
	if(!islist(potential_list) || length(potential_list) > MAXIMUM_MARKINGS_PER_LIMB)
		return null

	// Must be an active zone, also check length matches for fast case failure
	if(!islist(body_markings[zone]) || length(body_markings[zone]) != length(potential_list))
		return null

	// Must match current markings but potentially different order
	for(var/marking_key in body_markings[zone])
		// Potential list has removed a key we expect
		if(!(marking_key in potential_list))
			return null
		// Potential list has different content
		if(potential_list[marking_key] != body_markings[zone][marking_key])
			return null

	// We've established that it has all of the current markings with no changes, but we also need
	// to make sure it hasn't added any!
	for(var/marking_key in potential_list)
		if(!(marking_key in body_markings[zone]))
			return null

	// Everything's good!
	return potential_list


/datum/preferences/proc/validate_body_markings()
	//validating body markings
	for(var/zone in body_markings)
		for(var/name in body_markings[zone])
			if(!(name in GLOB.body_markings_per_limb[zone]))
				body_markings[zone] -= name

/datum/preferences/proc/reset_body_marking_colors()
	for(var/zone in body_markings)
		var/list/bml = body_markings[zone]
		for(var/key in bml)
			var/datum/body_marking/BM = GLOB.body_markings[key]
			bml[key] = BM.get_default_color(features, pref_species)

/datum/preferences/proc/remove_marking_from_zone(zone, marking_name, lazyremovezone = TRUE)
	if(!(zone in body_markings) || !(marking_name in body_markings[zone]))
		return FALSE
	body_markings[zone] -= marking_name
	if(lazyremovezone && LAZYLEN(body_markings[zone]) == 0)
		body_markings -= zone
	return TRUE
