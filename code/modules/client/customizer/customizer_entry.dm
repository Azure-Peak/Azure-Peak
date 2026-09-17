/// Customizer entry representing a saved/loaded information about a /datum/customizer_choice and its related information.
/datum/customizer_entry
	/// Used for identification.
	var/customizer_type
	var/customizer_choice_type
	var/accessory_type
	var/accessory_colors
	var/disabled = FALSE

/datum/customizer_entry/ui_data(mob/user)
	return list(
		"customizer_choice_type" = customizer_choice_type,
		"accessory_type" = accessory_type,
		"accessory_colors" = color_string_to_list(accessory_colors),
	)
