/proc/fellowship_name_available(candidate)
	if(!candidate)
		return FALSE
	var/slug = ckey(candidate)
	if(length(slug) < 2)
		return FALSE
	var/full_tag = "[FELLOWSHIP_FACTION_PREFIX][slug]"
	for(var/datum/fellowship/F as anything in GLOB.fellowships)
		if(F.faction_tag == full_tag)
			return FALSE
		if(lowertext(F.name) == lowertext(candidate))
			return FALSE
	return TRUE

/proc/shares_fellowship(mob/living/A, mob/living/B)
	if(!istype(A) || !istype(B))
		return FALSE
	var/datum/fellowship/F = A.current_fellowship
	if(!F)
		return FALSE
	return F == B.current_fellowship

/proc/apply_fellowship_faction(mob/living/summoner, mob/living/summoned)
	if(!istype(summoner) || !istype(summoned))
		return
	var/datum/fellowship/F = summoner.current_fellowship
	if(!F)
		return
	summoned.faction |= F.faction_tag

/proc/refresh_fellowship_ui_for(mob/M)
	if(!M)
		return
	var/datum/fellowship_ui/holder = GLOB.fellowship_uis_by_mob[M]
	if(holder)
		holder.refresh()
