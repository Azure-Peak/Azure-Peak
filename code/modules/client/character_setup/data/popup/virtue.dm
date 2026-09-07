/datum/preferences/proc/ui_data_popup_virtue(mob/user)
	var/list/data = list(
		"slot_names" = get_virtue_slot_names(),
		"virtues" = get_all_virtue_types(),
		"virtue_availability" = null,
	)

	var/list/virtue_availability = list()
	for(var/path as anything in GLOB.virtues)
		var/datum/virtue/V = GLOB.virtues[path]
		// we straight up do not show these, they are invalid
		if(!V.name || V.unlisted || istype(V, /datum/virtue/origin))
			continue

		// everything else is available for the UI to display, but may not be able to be selected.
		var/unavailable = null
		if(istype(V, /datum/virtue/heretic) && !istype(selected_patron, /datum/patron/inhumen))
			unavailable = "Must be an Ascendent worshipper."
		if(V.restricted == TRUE)
			if((pref_species.type in V.races))
				unavailable = "Restricted from species \"[pref_species.name]\"."
		if(V.virtuous_only && !statpack.virtuous)
			unavailable = "Must have a Virtuous statpack."
		UNTYPED_LIST_ADD(virtue_availability, list(
			"path" = path,
			"unavailable" = unavailable,
		))
	data["virtue_availability"] = virtue_availability

	return data

// Virtue Helpers
// WARNING: The indicies of this list must MATCH set_virtue_by_index
/datum/preferences/proc/get_all_virtues()
	return list(virtue, virtuetwo)

/* INSTRUCTIONS FOR DOWNSTREAM:
Add a new override in your modular folder that looks like this:
/datum/preferences/get_all_virtues()
	var/list/data = ..()
	data += virtuethree
	return data
*/

// WARNING: The indicies of this must MATCH get_all_virtues's list
/datum/preferences/proc/set_virtue_by_index(index, datum/virtue/new_virtue)
	switch(index)
		if(1)
			QDEL_NULL(virtue)
			virtue = new_virtue
			return TRUE
		if(2)
			QDEL_NULL(virtuetwo)
			virtuetwo = new_virtue
			return TRUE
	return FALSE

/* INSTRUCTIONS FOR DOWNSTREAM:
Add a new override in your modular folder that looks like this:

/datum/preferences/set_virtue_by_index(index, datum/virtue/new_virtue)
	if(index == 3)
		QDEL_NULL(virtuethree)
		virtuethree = new_virtue
		return TRUE
	return ..()
*/


// WARNING: This must match in length to get_all_virtues()!
/datum/preferences/proc/get_virtue_slot_names()
	return list("Virtue", "Second Virtue")

/* INSTRUCTIONS FOR DOWNSTREAM:
Add a new override in your modular folder that looks like this:
/datum/preferences/proc/get_virtue_slot_names()
	var/list/data = ..()
	data += "Third Virtue"
	return data
*/

// no downstream overrides necessary, these derive correct behavior from the above implementations
/datum/preferences/proc/validate_virtue_index(index)
	if(get_virtue_by_index(index))
		return TRUE
	return FALSE

/datum/preferences/proc/get_virtue_by_index(index)
	return LAZYACCESS(get_all_virtues(), index)

/datum/preferences/proc/get_all_virtue_names()
	var/list/virtues = get_all_virtues()

	. = list()
	for(var/datum/virtue/V as anything in virtues)
		. += V.name

/datum/preferences/proc/get_all_virtue_types()
	var/list/virtues = get_all_virtues()

	. = list()
	for(var/datum/virtue/V as anything in virtues)
		. += V.type
