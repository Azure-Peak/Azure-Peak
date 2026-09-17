/datum/preferences/proc/ui_data_popup_statpack(mob/user)
	var/list/data = list(
		"current_statpack" = statpack.type,
	)

	return data
