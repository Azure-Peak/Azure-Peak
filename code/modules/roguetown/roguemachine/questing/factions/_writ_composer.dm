/datum/quest_faction/proc/compose_preamble(datum/quest/Q)
	if(!Q)
		return
	var/list/crime_ids
	switch(category)
		if(FACTION_CAT_BEAST)
			crime_ids = pick_crimes(rand(1, 2))
		if(FACTION_CAT_UNDEAD)
			crime_ids = list()
		if(FACTION_CAT_GOBLINOID)
			crime_ids = pick_crimes(rand(1, 2))
		else
			crime_ids = pick_crimes(rand(2, 3))
	Q.rolled_crimes = render_crimes(crime_ids)
	Q.sacral_hook = crimes_invoke_tens(crime_ids)
	Q.oath_breach = crimes_invoke_oath(crime_ids)
	if(category == FACTION_CAT_BOG_DESERTER)
		Q.oath_breach = TRUE
	if(category == FACTION_CAT_HUMANOID || category == FACTION_CAT_BOG_DESERTER)
		Q.condemnation_variant = pick(
			CONDEMNATION_CAPUT_LUPINUM,
			CONDEMNATION_UTLAGATUS,
			CONDEMNATION_VOLKOMIR,
		)
