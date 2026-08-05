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

/proc/get_parchment_skins()
	var/static/list/skins = list(
		"vellum" = "Vellum",
		"parchment" = "Parchment",
		"leatherbound" = "Leatherbound",
	)
	return skins

/proc/sanitize_parchment_skin(value)
	var/list/skins = get_parchment_skins()
	if(value in skins)
		return value
	return "leatherbound"

/datum/preferences/proc/get_parchment_skin_display_name()
	var/list/skins = get_parchment_skins()
	return skins[parchment_skin] || skins["leatherbound"]

/datum/preferences/proc/cycle_parchment_skin()
	var/list/skins = get_parchment_skins()
	var/list/keys = list()
	for(var/k in skins)
		keys += k
	var/idx = keys.Find(parchment_skin)
	if(!idx)
		idx = 1
	parchment_skin = keys[(idx % keys.len) + 1]

/proc/get_statbrowser_themes()
	var/static/list/themes = list(
		"dark" = "Matte Black",
		"light" = "Leatherbound",
	)
	return themes

/proc/sanitize_statbrowser_theme(value)
	if(value in get_statbrowser_themes())
		return value
	return "dark"

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

// Open the theme picker with live preview
/datum/preferences/proc/setTguiStyle(mob/user)
	var/datum/theme_picker/picker = new(user)
	picker.ui_interact(user)
