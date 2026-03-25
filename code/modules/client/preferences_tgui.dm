/proc/get_tgui_themes()
	var/static/list/themes = list(
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

// Get the display name of the current TGUI theme
/datum/preferences/proc/get_tgui_theme_display_name()
	var/list/themes = get_tgui_themes()
	return themes[tgui_theme] || tgui_theme

// Open the theme picker with live preview
/datum/preferences/proc/setTguiStyle(mob/user)
	var/datum/theme_picker/picker = new(user)
	picker.ui_interact(user)
