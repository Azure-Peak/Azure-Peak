/datum/preferences/proc/ui_data_popup_statbuy(mob/user)
	var/list/data = list(
		"statbuy" = statbuy,
		"statbuy_points_remaining" = STATBUY_POINTS - get_statbuy_points_spent(statbuy),
	)

	return data
