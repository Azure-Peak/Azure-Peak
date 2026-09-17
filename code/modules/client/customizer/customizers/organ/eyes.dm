/datum/customizer/organ/eyes
	abstract_type = /datum/customizer/organ/eyes
	name = "Eyes"

/datum/customizer_choice/organ/eyes
	abstract_type = /datum/customizer_choice/organ/eyes
	name = "Eyes"
	organ_type = /obj/item/organ/eyes
	organ_slot = ORGAN_SLOT_EYES
	customizer_entry_type = /datum/customizer_entry/organ/eyes
	organ_dna_type = /datum/organ_dna/eyes
	allows_accessory_color_customization = FALSE //Customized through eye color
	tgui_template = "FeatureChoiceEyes"
	var/allows_heterochromia = TRUE

/datum/customizer_choice/organ/eyes/on_randomize_entry(datum/customizer_entry/entry, datum/preferences/prefs)
	var/datum/customizer_entry/organ/eyes/eye_entry = entry
	var/picked_color = pick(EYE_COLOR_LIST)
	eye_entry.eye_color = picked_color
	eye_entry.second_color = picked_color

/datum/customizer_choice/organ/eyes/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/organ/eyes/eyes_entry = entry
	eyes_entry.eye_color = sanitize_hexcolor(eyes_entry.eye_color, 6, TRUE, initial(eyes_entry.eye_color))
	eyes_entry.second_color = sanitize_hexcolor(eyes_entry.second_color, 6, TRUE, initial(eyes_entry.second_color))
	eyes_entry.heterochromia = sanitize_integer(eyes_entry.heterochromia, FALSE, TRUE, initial(eyes_entry.heterochromia))

/datum/customizer_choice/organ/eyes/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	var/datum/organ_dna/eyes/eyes_dna = organ_dna
	var/datum/customizer_entry/organ/eyes/eyes_entry = entry
	eyes_dna.eye_color = eyes_entry.eye_color
	if(allows_heterochromia)
		eyes_dna.heterochromia	= eyes_entry.heterochromia
		eyes_dna.second_color = eyes_entry.second_color

/datum/customizer_choice/organ/eyes/tgui_pref_choices(datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	var/list/data = ..()

	var/datum/customizer_entry/organ/eyes/eyes_entry = entry
	data["eye_color"] = eyes_entry.eye_color
	data["allows_heterochromia"] = allows_heterochromia
	data["heterochromia"] = eyes_entry.heterochromia
	data["second_color"] = eyes_entry.second_color

	return data


/datum/customizer_choice/organ/eyes/handle_tgui_act(list/params, datum/tgui/ui, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	var/datum/customizer_entry/organ/eyes/eyes_entry = entry
	switch(params["customizer_task"])
		if("eye_color")
			var/new_color = tgui_color_picker(user, "Choose your eyes color:", "Eye Color", eyes_entry.eye_color)
			if(new_color)
				prefs.verbose_pref_log_change(user, "notice", "\"[name]\" eye color", eyes_entry.eye_color, new_color)
				eyes_entry.eye_color = new_color
			return TRUE

		if("heterochromia")
			if(!allows_heterochromia)
				return TRUE
			eyes_entry.heterochromia = !eyes_entry.heterochromia
			prefs.verbose_pref_log_change(user, "notice", "\"[name]\" heterochromia", !eyes_entry.heterochromia ? "Yes" : "No", eyes_entry.heterochromia ? "Yes" : "No")
			return TRUE

		if("second_eye_color")
			if(!allows_heterochromia)
				return TRUE
			var/new_color = tgui_color_picker(user, "Choose your eyes' secondary color:", "Secondary Eye Color", eyes_entry.second_color)
			if(new_color)
				prefs.verbose_pref_log_change(user, "notice", "\"[name]\" secondary eye color", eyes_entry.second_color, new_color)
				eyes_entry.second_color = new_color
			return TRUE

/datum/customizer_entry/organ/eyes
	var/eye_color = "#111111"
	var/heterochromia = FALSE
	var/second_color = "#111111"

/datum/customizer/organ/eyes/humanoid
	customizer_choices = list(/datum/customizer_choice/organ/eyes/humanoid)
	default_choice = /datum/customizer_choice/organ/eyes/humanoid

/datum/customizer_choice/organ/eyes/humanoid

/datum/customizer/organ/eyes/moth
	customizer_choices = list(/datum/customizer_choice/organ/eyes/moth)
	default_choice = /datum/customizer_choice/organ/eyes/moth

/datum/customizer_choice/organ/eyes/moth
	organ_type = /obj/item/organ/eyes/moth
