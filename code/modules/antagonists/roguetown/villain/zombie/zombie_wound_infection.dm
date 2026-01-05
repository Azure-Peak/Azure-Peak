/datum/wound

	/// Actual infection timer
	var/zombie_infection_timer

/*
	ZOMBIFICATION
*/
/datum/wound/proc/zombie_infect_attempt()
	if (QDELETED(src) || QDELETED(owner) || QDELETED(bodypart_owner))
		return
	if (zombie_infection_timer || werewolf_infection_timer || !ishuman(owner)) //Other timers present
		return
	if(!prob(ZOMBIE_INFECTION_PROBABILITY))	//Failed the probability of infection
		return

	var/mob/living/carbon/human/wound_owner = owner

	wound_owner.attempt_zombie_infection(source = usr, infection_type = "wound", wake_delay = ZOMBIE_INFECTION_TIME) //Infect the unit

	severity = WOUND_SEVERITY_BIOHAZARD //Show the wound
	if (bodypart_owner)
		sortTim(bodypart_owner.wounds, GLOBAL_PROC_REF(cmp_wound_severity_dsc))
	return TRUE

/datum/wound/proc/zombie_wound_convert()
	if (QDELETED(src) || QDELETED(owner) || QDELETED(bodypart_owner))
		return FALSE
	if (!ishuman(owner))
		return FALSE

	// Clear conflicting infection timers
	werewolf_infection_timer = null

	// Initiate conversion
	if (istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/wound_owner = owner
		wound_owner.attempt_zombie_infection(src, "wound")
