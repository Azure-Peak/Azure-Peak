/datum/preferences/proc/ui_data_popup_quirk(mob/user)
	var/list/data = list(
		"slot_names" = get_quirk_slot_names(),
		"quirks" = get_all_quirk_types(),
		"quirk_availability" = null,
	)

	var/list/quirk_availability = list()
	for(var/path as anything in GLOB.quirks)
		var/datum/quirk/Q = GLOB.quirks[path]
		// we straight up do not show these, they are invalid
		if(!Q.name)
			continue

		// everything else is available for the UI to display, but may not be able to be selected.
		var/unavailable = null
		if(Q.greater) // do this first so it's overridden by other, more important reasons
			unavailable = "Can only be applied in a greater quirk slot."
		if(length(Q.restricted_species))
			if((pref_species.type in Q.restricted_species))
				unavailable = "Restricted from species \"[pref_species.name]\"."
		if(length(Q.allowed_species))
			if(!(pref_species.type in Q.allowed_species))
				if(!(length(Q.allowed_virtues) && ((virtue.type in Q.allowed_virtues) || (virtuetwo.type in Q.allowed_virtues))))
					var/out = "Only allowed for species: "
					for(var/datum/species/S as anything in Q.allowed_species)
						if(ispath(S, /datum/species))
							out += "[S::name], "
					out = copytext(out, 1, -2)
					if(length(Q.allowed_virtues))
						out += ", without an exempting virtue: "
						to_chat(world, out)
						for(var/datum/virtue/V as anything in Q.allowed_virtues)
							out += "[V::name], "
						out = copytext(out, 1, -2)
					unavailable = (out + ".")
		if(length(Q.restricted_virtues))
			if(virtue.type in Q.restricted_virtues)
				unavailable = "Restricted from virtue \"[virtue.name]\"."
			if(statpack.virtuous && (virtuetwo.type in Q.restricted_virtues))
				unavailable = "Restricted from virtue \"[virtuetwo.name]\"."
		if(length(job_preferences))
			var/highest_title = null
			for(var/title in job_preferences)
				if(job_preferences[title] == JP_HIGH)
					highest_title = title
			if(highest_title)
				var/datum/job/J = SSjob.GetJob(highest_title)
				if(J && length(J.quirk_restrictions) && (Q.type in J.quirk_restrictions))
					unavailable = "Disallowed for role [highest_title]."
		UNTYPED_LIST_ADD(quirk_availability, list(
			"path" = path,
			"unavailable" = unavailable,
		))
	data["quirk_availability"] = quirk_availability

	return data

// Quirk Helpers
// WARNING: The indicies of this list must MATCH set_quirk_by_index
/datum/preferences/proc/get_all_quirks()
	return list(quirklesser, quirkgreater)

/* INSTRUCTIONS FOR DOWNSTREAM:
Add a new override in your modular folder that looks like this:
/datum/preferences/get_all_quirks()
	var/list/data = ..()
	data += virtuethree
	return data
*/

// WARNING: The indicies of this must MATCH get_all_quirks's list
/datum/preferences/proc/set_quirk_by_index(index, datum/quirk/new_quirk)
	switch(index)
		if(1)
			QDEL_NULL(quirklesser)
			quirklesser = new_quirk
			return TRUE
		if(2)
			QDEL_NULL(quirkgreater)
			quirkgreater = new_quirk
			return TRUE
	return FALSE

/* INSTRUCTIONS FOR DOWNSTREAM:
Add a new override in your modular folder that looks like this:

/datum/preferences/set_quirk_by_index(index, datum/quirk/new_quirk)
	if(index == 3)
		QDEL_NULL(quirkthree)
		quirkthree = new_quirk
		return TRUE
	return ..()
*/


// WARNING: This must match in length to get_all_quirks()!
/datum/preferences/proc/get_quirk_slot_names()
	return list("Lesser Quirk", "Greater Quirk")

/* INSTRUCTIONS FOR DOWNSTREAM:
Add a new override in your modular folder that looks like this:
/datum/preferences/proc/get_quirk_slot_names()
	var/list/data = ..()
	data += "Third Quirk"
	return data
*/

// no downstream overrides necessary, these derive correct behavior from the above implementations
/datum/preferences/proc/validate_quirk_index(index)
	if(get_quirk_by_index(index))
		return TRUE
	return FALSE

/datum/preferences/proc/get_quirk_by_index(index)
	return LAZYACCESS(get_all_quirks(), index)

/datum/preferences/proc/get_all_quirk_names()
	var/list/quirks = get_all_quirks()

	. = list()
	for(var/datum/quirk/Q as anything in quirks)
		. += Q.name

/datum/preferences/proc/get_all_quirk_types()
	var/list/quirks = get_all_quirks()

	. = list()
	for(var/datum/quirk/Q as anything in quirks)
		. += Q.type
