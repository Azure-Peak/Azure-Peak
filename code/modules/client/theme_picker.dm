/datum/theme_picker
	/// The user browsing themes
	var/mob/user
	/// The theme key they had when they opened the picker
	var/original_theme
	/// Whether the user confirmed a selection
	var/confirmed = FALSE
	/// Whether the picker has been closed
	var/closed = FALSE

/datum/theme_picker/New(mob/user)
	src.user = user
	original_theme = user.client.prefs.tgui_theme

/datum/theme_picker/Destroy(force)
	// Revert if they closed without confirming
	if(!confirmed && user?.client)
		user.client.prefs.tgui_theme = original_theme
		user.client.prefs.save_preferences()
	user = null
	return ..()

/datum/theme_picker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ThemePicker")
		ui.open()

/datum/theme_picker/ui_state(mob/user)
	return GLOB.tgui_always_state

/datum/theme_picker/ui_data(mob/user)
	var/list/themes = get_tgui_themes()
	var/list/theme_list = list()
	for(var/key in themes)
		theme_list += list(list("key" = key, "name" = themes[key]))
	return list(
		"themes" = theme_list,
		"current" = user.client.prefs.tgui_theme,
	)

/datum/theme_picker/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("preview")
			var/theme_key = params["theme"]
			var/list/themes = get_tgui_themes()
			if(!(theme_key in themes))
				return
			user.client.prefs.tgui_theme = theme_key
			user.client.prefs.save_preferences()
			confirmed = TRUE
			return TRUE

/datum/theme_picker/ui_close(mob/user)
	. = ..()
	closed = TRUE
	QDEL_IN(src, 1) // clean up next tick
