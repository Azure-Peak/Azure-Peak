/datum/customizer_choice
	abstract_type = /datum/customizer_choice
	/// User facing name of the customizer choice.
	var/name = "Customizer"
	/// Type of the entry datum which is used for save/load of information.
	var/customizer_entry_type = /datum/customizer_entry
	/// List of sprite accessories this choice allows. Can be null
	var/list/sprite_accessories
	/// The default sprite accessory from `sprite_accessories`.
	var/default_accessory
	/// Whether this customizer choice allows to customize colors of sprite accessories.
	var/allows_accessory_color_customization = TRUE
	/// Whether to pick a random accessory from all possible ones in `sprite_accessories` rather than use the proc for randomization
	var/generic_random_pick = FALSE
	/// Set to a key in FEATURE_CHOICE_LIST to have a unique tgui template loaded
	var/tgui_template = null

/datum/customizer_choice/New()
	. = ..()
	if(length(sprite_accessories))
		if(!default_accessory)
			default_accessory = sprite_accessories[1]
		if(!(default_accessory in sprite_accessories))
			CRASH("Customizer choice [type] has a default accessory which is unavailable in its accessory list.")

/datum/customizer_choice/proc/apply_customizer_to_character(mob/living/carbon/human/human, datum/preferences/prefs, datum/customizer_entry/entry)
	return

/datum/customizer_choice/proc/make_default_customizer_entry(datum/preferences/prefs, customizer_type, changed_entry = TRUE)
	var/datum/customizer_entry/entry = new customizer_entry_type()
	entry.customizer_type = customizer_type
	entry.customizer_choice_type = type
	if(sprite_accessories)
		set_accessory_type(prefs, default_accessory, entry)
	return entry

/datum/customizer_choice/proc/randomize_entry(datum/customizer_entry/entry, datum/preferences/prefs)
	var/random_accessory
	if(generic_random_pick && sprite_accessories)
		random_accessory = pick(sprite_accessories)
	else
		random_accessory = get_random_accessory(entry, prefs)
	if(random_accessory)
		set_accessory_type(prefs, random_accessory, entry)
	var/random_color = get_random_color(entry, prefs, entry.accessory_type)
	if(random_color)
		entry.accessory_colors = random_color
	on_randomize_entry(entry, prefs)

/datum/customizer_choice/proc/on_randomize_entry(datum/customizer_entry/entry, datum/preferences/prefs)
	return

/datum/customizer_choice/proc/get_random_accessory(datum/customizer_entry/entry, datum/preferences/prefs)
	return

/datum/customizer_choice/proc/get_random_color(datum/customizer_entry/entry, datum/preferences/prefs, accessory_type)
	return

// TGUI
/datum/customizer_choice/proc/tgui_pref_choices(datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	var/list/data = list()

	var/datum/sprite_accessory/accessory
	if(sprite_accessories && entry.accessory_type)
		accessory = SPRITE_ACCESSORY(entry.accessory_type)

	data["name"] = name
	data["template"] = tgui_template

	if(accessory)
		var/list/accessory_data = list(
			"name" = accessory.name,
			"colors" = null,
		)

		if(allows_accessory_color_customization && !(accessory.color_disabled))
			var/list/color_data = list()
			var/list/color_list = color_string_to_list(entry.accessory_colors)
			for(var/index in 1 to accessory.color_keys)
				var/named_index = (accessory.color_keys == 1) ? accessory.color_key_name : accessory.color_key_names[index]
				UNTYPED_LIST_ADD(color_data, list(
					"name" = named_index,
					"index" = index,
					"color" = color_list[index],
				))
			accessory_data["colors"] = color_data

		data["accessory"] = accessory_data
	else
		data["accessory"] = null

	return data

/datum/customizer_choice/proc/handle_tgui_act(list/params, datum/tgui/ui, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	var/mob/user = ui.user

	switch(params["customizer_task"])
		if("acc_color")
			if(!sprite_accessories || !allows_accessory_color_customization)
				return TRUE
			var/index = text2num(params["color_index"])
			var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry.accessory_type)
			if(index > accessory.color_keys)
				return TRUE
			var/list/color_list = color_string_to_list(entry.accessory_colors)
			var/new_color = tgui_color_picker(user, "Choose your accessory color:", "Accessory Color", "[color_list[index]]")
			if(!new_color)
				return TRUE
			prefs.verbose_pref_log_change(user, "notice", "Feature \"[name]\"", color_list[index], new_color)
			color_list[index] = new_color
			entry.accessory_colors = color_list_to_string(color_list)
			return TRUE

		if("reset_colors")
			if(!sprite_accessories || !allows_accessory_color_customization)
				return TRUE
			prefs.verbose_pref_log_notification(user, "warning", "Feature \"[name]\" colors reset")
			reset_accessory_colors(prefs, entry)
			return TRUE

/datum/customizer_choice/proc/constant_ui_data()
	return list(
		"name" = name,
		"sprite_accessories" = sprite_accessories,
	)

/datum/customizer_choice/proc/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	/// Validate chosen accessory
	if(entry.accessory_type && !sprite_accessories)
		entry.accessory_type = null
		entry.accessory_colors = null
	else if (sprite_accessories && (!entry.accessory_type || !(entry.accessory_type in sprite_accessories)))
		set_accessory_type(prefs, default_accessory, entry)
	/// Validate colors
	if(entry.accessory_type)
		var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry.accessory_type)
		if(accessory.color_keys != 0)
			var/reset_colors = FALSE
			if(!entry.accessory_colors)
				reset_colors = TRUE
			else
				var/list/color_list = color_string_to_list(entry.accessory_colors)
				if(color_list.len != accessory.color_keys)
					reset_colors = TRUE
			if(reset_colors)
				entry.accessory_colors = accessory.get_default_colors(color_key_source_list_from_prefs(prefs))

/datum/customizer_choice/proc/set_accessory_type(datum/preferences/prefs, new_accessory_type, datum/customizer_entry/entry)
	if(entry.accessory_type == new_accessory_type)
		return
	if(!entry.customizer_choice_type)
		CRASH("Tried to set a customizer entry accessory without a customizer choice.")
	if(!(new_accessory_type in sprite_accessories))
		CRASH("Tried to set an customizer entry accessory that isn't allowed for the customizer choice.")

	entry.accessory_type = new_accessory_type
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry.accessory_type)
	entry.accessory_colors = accessory.get_default_colors(color_key_source_list_from_prefs(prefs))

/datum/customizer_choice/proc/reset_accessory_colors(datum/preferences/prefs, datum/customizer_entry/entry)
	if(!entry.accessory_type)
		return
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry.accessory_type)
	entry.accessory_colors = accessory.get_default_colors(color_key_source_list_from_prefs(prefs))

/// When you want to customize an organ but not through DNA (hair dye for example)
/datum/customizer_choice/proc/get_organ_slot(obj/item/organ/organ, datum/customizer_entry/entry)
	return FALSE

/datum/customizer_choice/proc/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	return

/datum/customizer_choice/proc/create_organ_dna(datum/customizer_entry/entry, datum/preferences/prefs)
	return

/datum/customizer_choice/proc/customize_organ(obj/item/organ/organ, datum/customizer_entry/entry)
	return

/datum/customizer_choice/organ
	abstract_type = /datum/customizer_choice/organ
	name = "Organ"
	/// Typepath of the organ this choice yields.
	var/organ_type
	/// Slot of the organ.
	var/organ_slot
	/// Typepath of the organ DNA.
	var/organ_dna_type = /datum/organ_dna

/// When you want to customize an organ but not through DNA (hair dye for example)
/datum/customizer_choice/organ/get_organ_slot(obj/item/organ/organ, datum/customizer_entry/entry)
	return organ_slot

/// When you want to customize an organ but not through DNA (hair dye for example)
/datum/customizer_choice/organ/customize_organ(obj/item/organ/organ, datum/customizer_entry/entry)
	return

/datum/customizer_choice/organ/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	organ_dna.organ_type = organ_type
	if(entry.accessory_type)
		organ_dna.accessory_type = entry.accessory_type
		if(allows_accessory_color_customization)
			organ_dna.accessory_colors = entry.accessory_colors
		else
			var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry.accessory_type)
			organ_dna.accessory_colors = accessory.get_default_colors(color_key_source_list_from_prefs(prefs))

/datum/customizer_choice/organ/create_organ_dna(datum/customizer_entry/entry, datum/preferences/prefs)
	var/datum/organ_dna/organ_dna = new organ_dna_type()
	imprint_organ_dna(organ_dna, entry, prefs)
	return organ_dna

/datum/customizer_choice/bodypart_feature
	abstract_type = /datum/customizer_choice/bodypart_feature
	name = "Bodypart Feature"
	/// Typepath of the bodypart feature
	var/feature_type = /datum/bodypart_feature

/datum/customizer_choice/bodypart_feature/apply_customizer_to_character(mob/living/carbon/human/human, datum/preferences/prefs, datum/customizer_entry/entry)
	var/datum/bodypart_feature/feature = new feature_type()
	if(entry.accessory_type)
		var/colors_used = allows_accessory_color_customization ? entry.accessory_colors : null
		feature.set_accessory_type(entry.accessory_type, colors_used, human)
	customize_feature(feature, human, prefs, entry)
	human.add_bodypart_feature(feature)

/datum/customizer_choice/bodypart_feature/proc/customize_feature(datum/bodypart_feature/feature, mob/living/carbon/human/human, datum/preferences/prefs, datum/customizer_entry/entry)
	return
