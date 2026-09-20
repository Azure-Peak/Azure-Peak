/datum/preferences/proc/ui_act_popup_taur_type(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("taur_type")
			if(isnull(params["taur_type"]))
				var/obj/item/bodypart/taur/tt = taur_type
				verbose_pref_log_change(user, "notice", "Taur Type", tt::name, "")
				taur_type = null
				return CHARACTER_ACT_PREVIEW_UPDATE

			var/picked = text2path(params["taur_type"])
			if(!ispath(picked, /obj/item/bodypart/taur))
				return CHARACTER_ACT_DATA_UPDATE

			var/list/species_taur_list = pref_species.get_taur_list()
			if(!LAZYLEN(species_taur_list))
				taur_type = null
				to_chat(user, span_warning("There are no available taur bodies for this species."))
				return CHARACTER_ACT_DATA_UPDATE

			if(!(picked in species_taur_list))
				return CHARACTER_ACT_DATA_UPDATE

			var/obj/item/bodypart/taur/old = taur_type
			taur_type = picked
			var/obj/item/bodypart/taur/tt = taur_type
			verbose_pref_log_change(user, "notice", "Taur Type", old::name, tt::name)
			return CHARACTER_ACT_PREVIEW_UPDATE
