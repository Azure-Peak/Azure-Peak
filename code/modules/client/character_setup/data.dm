// Note: Because of set_autoupdate(FALSE), ui_static_data is basically useless,
// everything should just go in the non-autoupdating ui_data.

/datum/preferences/ui_data(mob/user)
	var/list/data = ui_data_all_pages(user)

	data += ui_data_for_tab(user)
	data["popup"] = ui_data_for_popup(user) // see data/popup.dm

	return data

/datum/preferences/proc/ui_data_all_pages(mob/user)
	var/list/data = list()

	data["current_tab"] = current_tab

	return data

/datum/preferences/proc/ui_data_for_tab(mob/user)
	switch(current_tab)
		if(PREFERENCE_TAB_CHARACTER_CREATOR)
			. = ui_data_character_creator(user)
		if(PREFERENCE_TAB_GAME_SETTINGS)
			. = ui_data_game_settings(user)
		if(PREFERENCE_TAB_KEYBINDINGS)
			. = ui_data_keybinds(user)
