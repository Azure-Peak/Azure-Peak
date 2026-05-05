/datum/decree_setter

/datum/decree_setter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DecreeSetter", "Charters of the Realm")
		ui.open()

/datum/decree_setter/ui_data(mob/user)
	// Flavor text lives in ui_data (not ui_static_data) because the Magna Carta now
	// interpolates the current ruler's name into its charter - and ruler identity can
	// change mid-round via succession.
	var/list/decree_list = list()
	for(var/id in SStreasury.decrees)
		var/datum/decree/D = SStreasury.decrees[id]
		decree_list += list(list(
			"id" = D.id,
			"name" = D.name,
			"year" = D.year,
			"category" = D.category,
			"mechanical" = D.mechanical_text,
			"flavor" = D.get_display_flavor_text(),
		))
	var/list/states = list()
	for(var/id in SStreasury.decrees)
		var/datum/decree/D = SStreasury.decrees[id]
		var/cooldown_left = max(0, D.cooldown_expires - world.time)
		states += list(list(
			"id" = D.id,
			"active" = D.active,
			"cooldown_left" = round(cooldown_left / 10),
		))
	return list(
		"decrees" = decree_list,
		"states" = states,
		"revoke_used_today" = SStreasury.decree_revoke_used_day == GLOB.dayspassed,
		"restore_used_today" = SStreasury.decree_restore_used_day == GLOB.dayspassed,
	)

/datum/decree_setter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("toggle")
			var/decree_id = params["id"]
			var/datum/decree/D = SStreasury.get_decree(decree_id)
			if(!D)
				return FALSE
			if(!D.can_change_state())
				return FALSE
			SStreasury.set_decree_active(decree_id, !D.active)
			return TRUE

/datum/decree_setter/ui_state(mob/user)
	return GLOB.conscious_state
