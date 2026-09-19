/datum/preferences/proc/ui_act_popup_quirk(action, list/params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("select_quirk")
			return ui_act_popup_quirk_select(action, params, ui, state)

/datum/preferences/proc/ui_act_popup_quirk_select(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	var/index = params["id"]
	if(!validate_quirk_index(index))
		return CHARACTER_ACT_DATA_UPDATE

	var/path = text2path(params["quirk"])
	if(!ispath(path, /datum/quirk))
		return CHARACTER_ACT_DATA_UPDATE

	// Prechecks to make sure all is kosher
	var/datum/quirk/Q = GLOB.quirks[path]
	if(!Q || !Q.name)
		return CHARACTER_ACT_DATA_UPDATE

	var/list/already_taken = get_all_quirk_names()
	if(Q.name in already_taken)
		return CHARACTER_ACT_DATA_UPDATE

	if(!quirk_check(Q, src))
		return CHARACTER_ACT_DATA_UPDATE

	// Ok we're good, switch time
	var/datum/quirk/old = get_quirk_by_index(index)
	var/datum/quirk/new_quirk = new Q.type()
	verbose_pref_log_change(user, "notice", "Quirk [index]", old.name, new_quirk.name)
	set_quirk_by_index(index, new_quirk)

	return CHARACTER_ACT_PREVIEW_UPDATE
