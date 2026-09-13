/datum/preferences/proc/ui_act_popup_charflaw(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("toggle_charflaw")
			var/path = text2path(params["flaw"])
			// This is just here to check that they're not passing us a bad path
			if(!(path in GLOB.character_flaws_singletons))
				return CHARACTER_ACT_DATA_UPDATE

			var/datum/charflaw/cf = GLOB.character_flaws_singletons[path]

			if(has_flaw(path))
				verbose_pref_log_notification(user, "notice", "Removed vice [cf.name]")
				return ui_remove_charflaw(user, path)
			verbose_pref_log_notification(user, "notice", "Added vice [cf.name]")
			return ui_add_charflaw(user, path)

/datum/preferences/proc/ui_add_charflaw(mob/user, cf_type)
	var/datum/charflaw/cf = GLOB.character_flaws_singletons[cf_type]
	var/cannot_take = cannot_take_flaw(cf)
	if(cannot_take == PREFERENCE_CHARFLAW_DENIAL_HIDE)
		// Hidden, cancel with no message.
		return CHARACTER_ACT_DATA_UPDATE
	else if(cannot_take)
		// Restricted, cancel with message.
		to_chat(user, span_danger("Error: Cannot take flaw [cf.name] because: [flaw_denial_to_string(cannot_take)]."))
		return CHARACTER_ACT_DATA_UPDATE
	// All good to add.

	// Remove noflaw when we add a flaw.
	charflaws -= /datum/charflaw/noflaw
	charflaws += cf_type
	return CHARACTER_ACT_PREVIEW_UPDATE

/datum/preferences/proc/ui_remove_charflaw(mob/user, cf_type)
	charflaws -= cf_type

	if(!LAZYLEN(charflaws))
		charflaws = list(/datum/charflaw/noflaw)
		verbose_pref_log_notification(user, "warning", "No vices selected. 'No Flaw' has been automatically selected")

	return CHARACTER_ACT_PREVIEW_UPDATE
