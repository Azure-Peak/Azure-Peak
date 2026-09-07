/datum/preferences/proc/ui_act_popup_statpack(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("statpack")
			var/picked = text2path(params["statpack"])
			if(!ispath(picked, /datum/statpack))
				return CHARACTER_ACT_DATA_UPDATE

			var/datum/statpack/statpack_chosen = GLOB.statpacks[picked]
			if(!statpack_chosen?.name)
				return CHARACTER_ACT_DATA_UPDATE

			verbose_pref_log_change(user, "notice", "Statpack", statpack.name, statpack_chosen.name)
			statpack = statpack_chosen
			return CHARACTER_ACT_DATA_UPDATE
