/datum/preferences/proc/ui_act_popup_virtue(action, list/params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("select_virtue")
			return ui_act_popup_virtue_select(action, params, ui, state)

/datum/preferences/proc/ui_act_popup_virtue_select(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	var/index = params["id"]
	if(!validate_virtue_index(index))
		return CHARACTER_ACT_DATA_UPDATE

	var/path = text2path(params["virtue"])
	if(!ispath(path, /datum/virtue) || ispath(path, /datum/virtue/origin))
		return CHARACTER_ACT_DATA_UPDATE

	// Prechecks to make sure all is kosher
	var/datum/virtue/V = GLOB.virtues[path]
	if(!V || !V.name || V.unlisted)
		return CHARACTER_ACT_DATA_UPDATE

	var/list/already_taken = get_all_virtue_names()
	if(!V.stackable && (V.name in already_taken))
		return CHARACTER_ACT_DATA_UPDATE

	if(istype(V, /datum/virtue/heretic) && !istype(selected_patron, /datum/patron/inhumen))
		return CHARACTER_ACT_DATA_UPDATE
	if(V.restricted == TRUE)
		if((pref_species.type in V.races))
			return CHARACTER_ACT_DATA_UPDATE
	if(V.virtuous_only && !statpack.virtuous)
		return CHARACTER_ACT_DATA_UPDATE

	// Ok we're good, switch time
	var/datum/virtue/old = get_virtue_by_index(index)
	var/datum/virtue/new_virt = new V.type()
	verbose_pref_log_change(user, "notice", "Virtue [index]", old.name, new_virt.name)
	set_virtue_by_index(index, new_virt)

	if(skin_tone == SKIN_COLOR_ROT)
		var/list/all_virtues = get_all_virtues()
		var/should_rot = FALSE
		for(var/datum/virtue/combat/second_chance/R in all_virtues)
			should_rot = TRUE
			break
		if(!should_rot)
			var/new_tone = random_skin_tone()
			skin_tone = new_tone
			features["mcolor"] = sanitize_hexcolor(new_tone)
			try_update_mutant_colors(user)

	return CHARACTER_ACT_PREVIEW_UPDATE
