/datum/preferences/proc/ui_act_popup_species(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("select_species")
			var/species_path = text2path(params["species"])
			if(!(species_path in get_selectable_species_paths()))
				return CHARACTER_ACT_DATA_UPDATE

			if(pref_species.type == species_path)
				return CHARACTER_ACT_DATA_UPDATE

			var/datum/species/new_species = new species_path()
			verbose_pref_log_change(user, "notice", "Species", pref_species.name, new_species.name)
			set_new_race(new_species, user)
			return CHARACTER_ACT_PREVIEW_UPDATE
