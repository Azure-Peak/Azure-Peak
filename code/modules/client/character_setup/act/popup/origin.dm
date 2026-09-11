/datum/preferences/proc/ui_act_popup_origin(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("select_origin")
			// Typepath index
			var/picked = text2path(params["origin"])
			if(!ispath(picked, /datum/virtue/origin))
				return CHARACTER_ACT_DATA_UPDATE

			var/datum/virtue/origin/V = GLOB.virtues[picked]
			if(!V.name)
				return CHARACTER_ACT_DATA_UPDATE
			if(V.restricted == TRUE && (pref_species.type in V.races))
				return
			if(istype(V, /datum/virtue/origin/racial) && !(pref_species.type in V.races))
				return

			V = new V.type()
			verbose_pref_log_change(user, "notice", "Origin", virtue_origin.name, V.name)
			virtue_origin = V
			return CHARACTER_ACT_DATA_UPDATE
