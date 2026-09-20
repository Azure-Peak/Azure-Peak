/datum/preferences/proc/ui_data_popup_combat_music(mob/user)
	var/list/data = list(
		"combat_music" = combat_music?.name || null,
	)

	return data
