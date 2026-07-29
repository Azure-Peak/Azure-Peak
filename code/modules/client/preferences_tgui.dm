/proc/get_tgui_themes()
	var/static/list/themes = list(
		"parchment" = "Parchment",
		"parchment_leatherbound" = "Parchment (Leatherbound)",
		"parchment_vellum" = "Parchment (Vellum)",
		"azure_default" = "Ascendant",
		"azure_ascendant" = "New Ascendant",
		"azure_green" = "Oaken",
		"azure_lane" = "Noccite",
		"azure_purple" = "Raneshen",
		"azure_gilbranze" = "Gilbranze",
		"azure_psydonic" = "Psydonic",
		"azure_lingyue" = "Lingyue",
		"trey_liam" = "Trey Liam"
	)
	return themes

/// Sets and saves the tgui theme, then re-sends configs so every open window
/// restyles immediately (the theme rides in the payload sent at window open).
/datum/preferences/proc/set_tgui_theme(new_theme)
	if(!(new_theme in get_tgui_themes()))
		return FALSE
	tgui_theme = new_theme
	save_preferences()
	var/mob/M = parent?.mob
	if(M)
		for(var/datum/tgui/ui as anything in M.tgui_open_uis)
			ui.send_full_update(force = TRUE)
	return TRUE

/// Legacy menu path: pick a theme from a list input.
/datum/preferences/proc/pick_tgui_theme(mob/user)
	var/list/themes = get_tgui_themes()
	var/list/by_name = list()
	for(var/key in themes)
		by_name[themes[key]] = key
	var/choice = tgui_input_list(user, "Choose your TGUI theme:", "TGUI Theme", by_name, themes[tgui_theme])
	if(!choice)
		return
	set_tgui_theme(by_name[choice])

/proc/get_statbrowser_themes()
	var/static/list/themes = list(
		"dark" = "Matte Black",
		"light" = "Leatherbound",
	)
	return themes

/proc/sanitize_statbrowser_theme(value)
	if(value in get_statbrowser_themes())
		return value
	return "light"

/datum/preferences/proc/get_statbrowser_theme_display_name()
	var/list/themes = get_statbrowser_themes()
	return themes[statbrowser_theme] || themes["dark"]

/datum/preferences/proc/cycle_statbrowser_theme()
	var/list/themes = get_statbrowser_themes()
	var/list/keys = list()
	for(var/k in themes)
		keys += k
	var/idx = keys.Find(statbrowser_theme)
	if(!idx)
		idx = 1
	statbrowser_theme = keys[(idx % keys.len) + 1]

// Get the display name of the current TGUI theme
/datum/preferences/proc/get_tgui_theme_display_name()
	var/list/themes = get_tgui_themes()
	return themes[tgui_theme] || tgui_theme

