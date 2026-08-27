/datum/preferences/proc/ui_data_popup_charflaw(mob/user)
	var/list/data = list(
		"availability" = null,
		"charflaws" = null,
	)

	var/list/availability = list()
	for(var/cf_path in GLOB.character_flaws_singletons)
		var/datum/charflaw/cf = GLOB.character_flaws_singletons[cf_path]
		availability[cf_path] = cannot_take_flaw(cf)
	data["availability"] = availability

	var/list/cf_data = list()
	for(var/cf_type in charflaws)
		UNTYPED_LIST_ADD(cf_data, cf_type)
	data["charflaws"] = cf_data

	return data

// Returns PREFERENCE_CHARFLAW_X define
/datum/preferences/proc/cannot_take_flaw(datum/charflaw/cf)
	if(cf.type == /datum/charflaw/noflaw)
		return PREFERENCE_CHARFLAW_DENIAL_HIDE
	if(has_flaw(cf.type) && !istype(cf, /datum/charflaw/randflaw))
		return PREFERENCE_CHARFLAW_DENIAL_ALREADY_TAKEN
	if(length(cf.restricted_species) && (pref_species.type in cf.restricted_species))
		return PREFERENCE_CHARFLAW_DENIAL_RESTRICTION
	if(LAZYLEN(charflaws) >= MAX_VICES)
		return PREFERENCE_CHARFLAW_DENIAL_FULL
	return PREFERENCE_CHARFLAW_APPROVED

/datum/preferences/proc/flaw_denial_to_string(denial)
	switch(denial)
		if(PREFERENCE_CHARFLAW_APPROVED)
			return null
		if(PREFERENCE_CHARFLAW_DENIAL_HIDE)
			return "Hidden"
		if(PREFERENCE_CHARFLAW_DENIAL_ALREADY_TAKEN)
			return "Already Taken"
		if(PREFERENCE_CHARFLAW_DENIAL_RESTRICTION)
			return "Species Restriction"
		if(PREFERENCE_CHARFLAW_DENIAL_FULL)
			return "I can't be any more flawed."

/datum/preferences/proc/has_flaw(flaw_path)
	return flaw_path in charflaws
