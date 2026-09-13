/datum/preferences/proc/ui_act_popup_marking_select(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("toggle_marking")
			// Verify zone
			var/zone = params["zone"]
			if(!GLOB.body_markings_per_limb[zone])
				return CHARACTER_ACT_DATA_UPDATE
			// Verify marking is infact a marking
			var/marking_type = text2path(params["type"])
			var/datum/body_marking/BM = GLOB.body_markings_by_type[marking_type]
			if(!BM)
				return CHARACTER_ACT_DATA_UPDATE

			// If already present, remove!
			if((zone in body_markings) && (BM.name in body_markings[zone]))
				remove_marking_from_zone(zone, BM.name)
				verbose_pref_log_notification(user, "notice", "Marking \"[BM.name]\" removed from \"[capitalize(zone)]\"")
				return CHARACTER_ACT_PREVIEW_UPDATE

			// Else, add

			// Verify that marking is not already selected or not allowed for species
			var/list/possible_candidates = marking_list_of_zone_for_species(zone, pref_species)
			if(body_markings[zone])
				//To prevent exploiting hrefs to bypass the marking limit
				if(LAZYLEN(body_markings[zone]) >= MAXIMUM_MARKINGS_PER_LIMB)
					return CHARACTER_ACT_DATA_UPDATE
				//Remove already used markings from the candidates
				for(var/keyed_name in body_markings[zone])
					possible_candidates -= keyed_name
			if(!(BM.name in possible_candidates))
				return CHARACTER_ACT_DATA_UPDATE

			// All checks pass, add the marking
			if(!body_markings[zone])
				body_markings[zone] = list()
			body_markings[zone][BM.name] = BM.get_default_color(features, pref_species)
			verbose_pref_log_notification(user, "notice", "Marking \"[BM.name]\" added to \"[capitalize(zone)]\"")

			return CHARACTER_ACT_PREVIEW_UPDATE
