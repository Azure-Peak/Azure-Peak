/datum/sex_action/sex/other
	abstract_type = /datum/sex_action/sex/other
	target_priority = 100
	user_priority = 0
	flipped = TRUE

/datum/sex_action/sex/other/try_knot_on_climax(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!knot_on_finish)
		return FALSE
	if(!can_knot)
		return FALSE

	var/datum/sex_session/session = get_sex_session(user, target)
	if(!session)
		return FALSE
	return SEND_SIGNAL(target, COMSIG_SEX_TRY_KNOT, user, session.force)

/datum/sex_action/sex/other/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	sex_locks |= new /datum/sex_session_lock(target, ORGAN_SLOT_PENIS)
