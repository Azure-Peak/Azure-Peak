/datum/quest_faction/proc/compose_preamble(datum/quest/Q)
	if(!Q)
		return
	var/list/crime_ids
	if(category == FACTION_CAT_BEAST)
		crime_ids = pick_crimes(rand(1, 2))
	else
		crime_ids = pick_crimes(rand(2, 3))
	Q.rolled_crimes = render_crimes(crime_ids)
	Q.sacral_hook = crimes_invoke_tens(crime_ids)
	Q.oath_breach = crimes_invoke_oath(crime_ids)
	if(category == FACTION_CAT_HUMANOID)
		Q.condemnation_variant = pick(
			CONDEMNATION_CAPUT_LUPINUM,
			CONDEMNATION_UTLAGATUS,
			CONDEMNATION_VOLKOMIR,
		)
