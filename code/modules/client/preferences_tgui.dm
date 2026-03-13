/proc/get_tgui_themes()
	var/static/list/themes = list(
		"azure_default" = "Ascendant",
		"azure_green" = "Undivided",
		"azure_lane" = "Azuria",
		// "azure_gold" = "Lirvas",
		"azure_purple" = "Raneshen",
		// "azure_gilbranze" = "Gilbranze", - Coming soon :tm:
		"trey_liam" = "Trey Liam"
	)
	return themes

// Get the display name of the current TGUI theme
/datum/preferences/proc/get_tgui_theme_display_name()
	var/list/themes = get_tgui_themes()
	return themes[tgui_theme] || tgui_theme

// Cycle through TGUI styles
/datum/preferences/proc/setTguiStyle(mob/user)
	var/list/themes = get_tgui_themes()
	var/list/theme_keys = list()
	for(var/key in themes)
		theme_keys += key
	var/current_index = theme_keys.Find(tgui_theme)
	if(!current_index)
		current_index = 1
	var/next_index = (current_index % theme_keys.len) + 1
	tgui_theme = theme_keys[next_index]
	to_chat(usr, "<span class='notice'>TGUI style set to [get_tgui_theme_display_name()].</span>")
	save_preferences()
