// This is where all of the data for all popups lives

// Make sure you include !all! data that the popup needs, there's no guarantee the underlying page won't change!
/datum/preferences/proc/ui_data_for_popup(mob/user)
	var/list/data

	var/popup_id = LAZYACCESS(tgui_shared_states, "popup")

	// Abort early for downstream popups
	data = ui_data_for_popup_downstream(user, popup_id)
	if(data)
		data["popup_data_ready"] = TRUE
		return data

	switch(popup_id)
		if(PREFERENCE_POPUP_CHARACTER_SELECT)
			data = ui_data_popup_character_select(user)
		if(PREFERENCE_POPUP_CHARFLAW)
			data = ui_data_popup_charflaw(user)
		if(PREFERENCE_POPUP_COMBAT_MUSIC)
			data = ui_data_popup_combat_music(user)
		if(PREFERENCE_POPUP_CUSTOMIZER_SELECT)
			data = ui_data_popup_customizer_select(user)
		if(PREFERENCE_POPUP_MARKING_SELECT)
			data = ui_data_popup_marking_select(user)
		if(PREFERENCE_POPUP_ORIGIN)
			data = ui_data_popup_origin(user)
		if(PREFERENCE_POPUP_PATRON_SELECT)
			data = ui_data_popup_patron_select(user)
		if(PREFERENCE_POPUP_SPECIES)
			data = ui_data_popup_species(user)
		if(PREFERENCE_POPUP_STATPACK)
			data = ui_data_popup_statpack(user)
		if(PREFERENCE_POPUP_TAUR_TYPE)
			data = ui_data_popup_taur_type(user)
		if(PREFERENCE_POPUP_VERBOSE_LOGS)
			data = ui_data_popup_verbose_logs(user)
		if(PREFERENCE_POPUP_VIRTUE)
			data = ui_data_popup_virtue(user)

	// doing this kinda weird pattern allows us to shrink the switch statement
	if(!data)
		return list("popup_data_ready" = FALSE)
	data["popup_data_ready"] = TRUE
	return data

// INSTRUCTIONS FOR DOWNSTREAM: Override this in your modular folder
/datum/preferences/proc/ui_data_for_popup_downstream(mob/user, popup_id)
	RETURN_TYPE(/list)
	SHOULD_CALL_PARENT(FALSE)

	return null
