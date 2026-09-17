/datum/preferences/proc/ui_data_character_creator_appearance(mob/user)
	var/list/data = list()

	data += ui_data_character_creator_appearance_body(user)
	data += ui_data_character_creator_appearance_features(user)
	data += ui_data_character_creator_appearance_markings(user)

	return data

/datum/preferences/proc/ui_data_character_creator_appearance_body(mob/user)
	var/list/data = list(
		"body_type" = ui_data_bodytype(),

		// Appearance stuff
		"use_skintones" = pref_species.use_skintones,
		"skin_tone_wording" = pref_species.skin_tone_wording,
		"available_skin_tones" = get_valid_skin_tones(),
		"skin_tone" = skin_tone,
		"body_size" = (features["body_size"] * 100),

		"update_mutant_colors" = update_mutant_colors,
		"use_mutcolor" = (MUTCOLORS in pref_species.species_traits) || (MUTCOLORS_PARTSONLY in pref_species.species_traits),
		"mcolor" = features["mcolor"],
		"mcolor2" = features["mcolor2"],
		"mcolor3" = features["mcolor3"],

		// Taur stuff
		"taur_type" = taur_type,
		"taur_name" = "None",
		"taur_color" = taur_color,
		"allowed_taur_types" = pref_species.allowed_taur_types,
	)

	var/obj/item/bodypart/taur/T = taur_type
	data["taur_name"] = ispath(T) ? T::name : "None"

	return data

/// Gets the body type as a user friendly string
/datum/preferences/proc/ui_data_bodytype()
	var/bodytype = null
	if(!(AGENDER in pref_species.species_traits))
		if(gender == MALE)
			bodytype = "Masculine"
		else if(gender == FEMALE)
			bodytype = "Feminine"
		else
			bodytype = "Other"
	return bodytype

/// Gets all valid skintones as an assoc list Name -> Hex
/datum/preferences/proc/get_valid_skin_tones()
	if(!pref_species.use_skintones)
		return list()

	. = pref_species.get_skin_list()
	if(istype(virtue, /datum/virtue/combat/second_chance) || istype(virtuetwo, /datum/virtue/combat/second_chance))
		.["Rotten"] = SKIN_COLOR_ROT

/datum/preferences/proc/ui_data_character_creator_appearance_features(mob/user)
	var/list/data = list(
		"customizers" = list(),
	)

	var/list/customizers = pref_species.customizers
	if(!customizers)
		return data

	var/list/customizers_data = list()
	for(var/customizer_type in customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!customizer.is_allowed(src))
			continue
		var/datum/customizer_entry/entry = get_customizer_entry_for_customizer_type(customizer_type)
		if(!entry)
			stack_trace("Missing customizer entry in preferences for customizer [customizer_type]")
			continue
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)

		UNTYPED_LIST_ADD(customizers_data, list(
			"name" = customizer.name,
			"type" = customizer_type,
			"disabled" = entry.disabled,
			"allows_disabling" = customizer.allows_disabling,
			"customizer_choices_enabled" = length(customizer.customizer_choices) > 1,
			"choices" = choice.tgui_pref_choices(src, entry, customizer_type)
		))
	data["customizers"] = customizers_data

	return data

// also called by ui_data_popup_marking_select!
/datum/preferences/proc/ui_data_character_creator_appearance_markings(mob/user)
	var/list/data = list(
		"marking_zones" = list(),
	)

	var/list/marking_zones = list()
	for(var/zone in GLOB.marking_zones)
		var/list/zone_data = list(
			"zone" = zone,
			"name" = capitalize(parse_zone(zone)),
			"may_add" = !(body_markings[zone]) || body_markings[zone].len < MAXIMUM_MARKINGS_PER_LIMB,
			"markings" = null,
		)

		if(body_markings[zone])
			var/list/marking_data = list()
			for(var/key in body_markings[zone])
				var/current_index = LAZYFIND(body_markings[zone], key)
				var/color = body_markings[zone][key]

				UNTYPED_LIST_ADD(marking_data, list(
					"key" = key,
					"color" = "#[color]",
					"can_move_up" = current_index > 1,
					"can_move_down" = current_index < length(body_markings[zone]),
				))
			zone_data["markings"] = marking_data

		UNTYPED_LIST_ADD(marking_zones, zone_data)
	data["marking_zones"] = marking_zones

	return data
