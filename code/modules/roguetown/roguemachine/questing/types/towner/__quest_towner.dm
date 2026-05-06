/proc/towner_can_claim_check(datum/quest/Q, mob/living/user)
	if(Q?.source != QUEST_SOURCE_TOWNER)
		return TRUE
	var/mob/poster = Q.quest_giver_reference?.resolve()
	if(!poster)
		return FALSE
	var/datum/fellowship/F = user?.current_fellowship
	if(!F || !F.has_member(poster))
		return FALSE
	return TRUE

/proc/towner_claim_failure_reason(datum/quest/Q, mob/living/user)
	if(Q?.source != QUEST_SOURCE_TOWNER)
		return null
	var/mob/poster = Q.quest_giver_reference?.resolve()
	if(!poster)
		return "The contract-poster is no longer with us."
	var/datum/fellowship/F = user?.current_fellowship
	if(!F)
		return "You must form a Fellowship that includes [Q.quest_giver_name] before signing."
	if(!F.has_member(poster))
		return "[Q.quest_giver_name] must be in your Fellowship before you can sign."
	return null
