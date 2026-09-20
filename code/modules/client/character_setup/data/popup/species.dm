/datum/preferences/proc/ui_data_popup_species(mob/user)
	var/list/data = list(
		"current_species" = pref_species.base_name,
		"current_subspecies" = pref_species.sub_name,
	)

	return data
