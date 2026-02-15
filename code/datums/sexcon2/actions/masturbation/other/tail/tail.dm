/datum/sex_action/masturbate/other/tailjob //Handjob but with a tail I GUESS???
	name = "Jerk them off with a tail"
	check_same_tile = FALSE

/datum/sex_action/masturbate/other/tailjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_TAIL))
		return FALSE
	if(check_sex_lock(user, ORGAN_SLOT_TAIL))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/tailjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_TAIL))
		return FALSE
	if(check_sex_lock(user, ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/tailjob/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] coils [user.p_their()] tail around [target]'s cock...")

/datum/sex_action/masturbate/other/tailjob/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] stops jerking [target]'s cock.")

/datum/sex_action/masturbate/other/tailjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] strokes [target]'s cock with [user.p_their()] tail...."))
	playsound(user, 'sound/misc/mat/fingering.ogg', 30, TRUE, -2, ignore_walls = FALSE)

	sex_session.perform_sex_action(target, 3, 7, TRUE)

	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/masturbate/other/tailjob/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	sex_locks |= new /datum/sex_session_lock(user, ORGAN_SLOT_TAIL)
	sex_locks |= new /datum/sex_session_lock(target, ORGAN_SLOT_PENIS)
