/mob/living/proc/checkdefense(datum/intent/intenty, mob/living/user)

	if(!cmode)
		return FALSE
	if(stat)
		return FALSE
	if(!canparry && !candodge) //mob can do neither of these
		return FALSE
	if(user == src)
		return FALSE
	if(!(mobility_flags & MOBILITY_MOVE))
		return FALSE

	if(client && used_intent)
		if(client.charging && used_intent.tranged && !used_intent.tshield)
			return FALSE

	switch(d_intent)
		if(INTENT_PARRY)
			return attempt_parry(intenty, user)
		if(INTENT_DODGE)
			return attempt_dodge(intenty, user)
			