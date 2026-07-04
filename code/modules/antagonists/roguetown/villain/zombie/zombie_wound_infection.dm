/datum/wound

	/// Actual infection timer
	var/zombie_infection_timer
/*
	ZOMBIFICATION
*/
/datum/wound/proc/zombie_infect_attempt(mob/living/carbon/human/infection_source)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(bodypart_owner))
		return FALSE
	if(zombie_infection_timer || werewolf_infection_timer || !ishuman(owner))
		return FALSE
	if(!prob(ZOMBIE_INFECTION_PROBABILITY))
		return FALSE

	if(!ishuman(infection_source))
		return FALSE

	var/mob/living/carbon/human/wound_owner = owner
	if(!wound_owner.attempt_zombie_infection(infection_source, "wound", ZOMBIE_INFECTION_TIME))
		return FALSE

	severity = WOUND_SEVERITY_BIOHAZARD
	if(bodypart_owner)
		sortTim(bodypart_owner.wounds, GLOBAL_PROC_REF(cmp_wound_severity_dsc))
	return TRUE
