/datum/preferences/proc/ui_data_popup_origin(mob/user)
	var/list/data = list(
		"virtue_origin" = "[virtue_origin]",
		"available_origins" = null,
	)

	var/list/available_origins = list()
	for(var/path as anything in GLOB.virtues)
		var/datum/virtue/V = GLOB.virtues[path]
		if(!V.name || !istype(V, /datum/virtue/origin))
			continue
		// Skip familiar origins
		if(istype(V, /datum/virtue/origin/familiar))
			continue
		// Restricted uses races as a blacklist
		if(V.restricted == TRUE)
			if(pref_species.type in V.races)
				continue
		// Racial uses races as a whitelist
		if(istype(V, /datum/virtue/origin/racial))
			if(!(pref_species.type in V.races))
				continue
		UNTYPED_LIST_ADD(available_origins, V.type)
	data["available_origins"] = available_origins

	return data


