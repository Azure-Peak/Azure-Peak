/datum/preferences/proc/validate_customizer_entries()
	customizer_entries = SANITIZE_LIST(customizer_entries)
	listclearnulls(customizer_entries)
	var/datum/species/species = pref_species
	var/list/customizers = species.customizers
	/// Check if we have any customizer entries that don't match.
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/validated = FALSE
		for(var/customizer_type as anything in customizers)
			if(customizer_type != entry.customizer_type)
				continue
			var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
			if(!(entry.customizer_choice_type in customizer.customizer_choices))
				continue
			var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
			if(entry.type != customizer_choice.customizer_entry_type)
				continue
			validated = TRUE
			break

		if(!validated)
			customizer_entries -= entry

	/// Check if we have any missing customizer entries
	for(var/customizer_type as anything in customizers)
		var/found = FALSE
		for(var/datum/customizer_entry/entry as anything in customizer_entries)
			if(entry.customizer_type != customizer_type)
				continue
			found = TRUE
			break
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!found)
			customizer_entries += customizer.make_default_customizer_entry(src, FALSE)

	/// Validate the variables within customizer entries
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		customizer_choice.validate_entry(src, entry)

/// We dont associate the entries just to be safer for save/load, so we can't lookup easily and we do this.
/datum/preferences/proc/get_customizer_entry_for_customizer_type(customizer_type)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		if(entry.customizer_type == customizer_type)
			return entry

/// Gets an associative list of organ slots to organ dna created from organ customization
/datum/preferences/proc/get_organ_dna_list()
	var/list/organ_list = list()
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		var/datum/customizer/customizer = CUSTOMIZER(entry.customizer_type)
		if(!customizer.is_allowed(src))
			continue
		if(entry.disabled)
			continue
		var/datum/organ_dna/dna = customizer_choice.create_organ_dna(entry, src)
		if(!dna)
			continue
		organ_list[customizer_choice.get_organ_slot()] = dna

	return organ_list

/datum/preferences/proc/customize_organ(obj/item/organ/organ)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		var/datum/customizer/customizer = CUSTOMIZER(entry.customizer_type)
		if(!customizer.is_allowed(src))
			continue
		if(entry.disabled)
			continue
		if(!(customizer_choice.get_organ_slot() == organ.slot))
			continue
		customizer_choice.customize_organ(organ, entry)

/datum/preferences/proc/apply_customizers_to_character(mob/living/carbon/human/human)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		var/datum/customizer/customizer = CUSTOMIZER(entry.customizer_type)
		if(!customizer.is_allowed(src))
			continue
		if(entry.disabled)
			continue
		customizer_choice.apply_customizer_to_character(human, src, entry)

/datum/preferences/proc/reset_all_customizer_accessory_colors()
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		choice.reset_accessory_colors(src, entry)

/datum/preferences/proc/randomize_all_customizer_accessories()
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		choice.randomize_entry(entry, src)

/datum/preferences/proc/get_hair_color()
	var/datum/customizer_entry/hair/entry = get_customizer_entry_of_type(/datum/customizer_entry/hair)
	if(entry)
		return entry.hair_color
	else
		return "FFFFFF"

/datum/preferences/proc/get_facial_hair_color()
	var/datum/customizer_entry/hair/entry = get_customizer_entry_of_type(/datum/customizer_entry/hair/facial)
	if(entry)
		return entry.hair_color
	else
		return "FFFFFF"

/datum/preferences/proc/get_eye_color()
	var/datum/customizer_entry/organ/eyes/entry = get_customizer_entry_of_type(/datum/customizer_entry/organ/eyes)
	if(entry)
		return entry.eye_color
	else
		return "FFFFFF"

/datum/preferences/proc/get_chest_color()
	var/list/zone_list = body_markings[BODY_ZONE_CHEST]
	if(!zone_list)
		return null
	for(var/marking_name in zone_list)
		var/datum/body_marking/marking = GLOB.body_markings[marking_name]
		if(!marking.covers_chest)
			continue
		var/marking_color = zone_list[marking_name]
		return marking_color
	return null

/datum/preferences/proc/get_customizer_entry_of_type(entry_type)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		if(entry.type == entry_type)
			return entry
	return null

/datum/preferences/proc/genderize_customizer_entries()
	customizer_entries = SANITIZE_LIST(customizer_entries)
	var/datum/species/species = pref_species
	var/list/customizers = species.customizers

	/// Check if we have any missing customizer entries
	for(var/datum/customizer/customizer_type as anything in customizers)
		if(customizer_type.gender_enabled == null)
			continue
		for(var/datum/customizer_entry/entry as anything in customizer_entries)
			if(entry.customizer_type != customizer_type)
				continue
			if(customizer_type.gender_enabled == gender)
				entry.disabled = FALSE
			else
				entry.disabled = TRUE
			break
