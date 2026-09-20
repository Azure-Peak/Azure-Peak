/datum/preferences
	var/current_tab = PREFERENCE_TAB_CHARACTER_CREATOR
	var/list/history_log = list()

// kept for legacy reasons
/datum/preferences/proc/ShowChoices(mob/user, tabchoice = null)
	if(!user || !user.client)
		return

	if(tabchoice != null)
		current_tab = tabchoice

	ui_interact(user)

/datum/preferences/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		character_preview_view = create_character_preview_view(user)
		ui = new(user, src, "PreferencesMenu", "Preferences")
		// Note: Because of this, ui_static_data is basically useless,
		// everything should just go in the non-autoupdating ui_data
		ui.set_autoupdate(FALSE)
		ui.open()
		character_preview_view.display_to(user, ui.window)

// bastardized version of update_static_data_for_all_viewers that skips the cooldown and ignores static data
/datum/preferences/proc/update_pref_data_for_all_viewers()
	for(var/datum/tgui/window as anything in open_uis)
		window.send_update()

/datum/preferences/ui_state(mob/user)
	return GLOB.tgui_always_state

// This makes sure that no one but our owner can interact or see us
/datum/preferences/ui_status(mob/user, datum/ui_state/state)
	return user.client == parent ? UI_INTERACTIVE : UI_CLOSE

/datum/preferences/ui_close(mob/user)
	. = ..()
	close_subwindows(user)

/datum/preferences/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/json/preferences)
	. += get_asset_datum(/datum/asset/simple/webworkers)
