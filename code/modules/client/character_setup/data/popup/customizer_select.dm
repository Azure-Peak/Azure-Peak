/datum/preferences/proc/ui_data_popup_customizer_select(mob/user)
	var/list/data = list(
		"customizer_entries" = null,
	)

	var/list/customizer_entries_data = list()
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		customizer_entries_data[entry.customizer_type] = entry.ui_data(user)
	data["customizer_entries"] = customizer_entries_data

	return data

