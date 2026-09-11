/datum/preferences/proc/ui_data_popup_patron_select(mob/user)
	var/list/data = list(
		"selected_patron" = selected_patron.type,
	)

	return data


