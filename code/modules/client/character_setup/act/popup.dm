/datum/preferences/proc/ui_act_popup(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ui_act_popup_character_select(action, params, ui, state)
	if(.)
		return
	. = ui_act_popup_charflaw(action, params, ui, state)
	if(.)
		return
	. = ui_act_popup_combat_music(action, params, ui, state)
	if(.)
		return
	. = ui_act_popup_customizer_select(action, params, ui, state)
	if(.)
		return
	. = ui_act_popup_marking_select(action, params, ui, state)
	if(.)
		return
	. = ui_act_popup_origin(action, params, ui, state)
	if(.)
		return
	. = ui_act_popup_patron_select(action, params, ui, state)
	if(.)
		return
	. = ui_act_popup_species(action, params, ui, state)
	if(.)
		return
	. = ui_act_popup_statpack(action, params, ui, state)
	if(.)
		return
	. = ui_act_popup_taur_type(action, params, ui, state)
	if(.)
		return
	. = ui_act_popup_virtue(action, params, ui, state)
	if(.)
		return

/* INSTRUCTIONS FOR DOWNSTREAM:
Add a new override in your modular folder that looks like this:
/datum/preferences/ui_act_popup(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	// helpers/switch(action) as needed
*/
