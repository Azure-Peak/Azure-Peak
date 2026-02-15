/datum/sex_action/masturbate/other/tailjob_vagina
	name = "Prod their pussy with a tail"
	check_same_tile = FALSE

/datum/sex_action/masturbate/other/tailjob_vagina/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_TAIL))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/tailjob_vagina/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/tailjob_vagina/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] starts pressing [user.p_their()] tail into [target]'s [pick("slit","cunt","pussy","snatch")]..."))

/datum/sex_action/masturbate/other/tailjob_vagina/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] pulls out [user.p_their()] tail out of [target]'s [pick("slit","cunt","pussy","snatch")]."))

/datum/sex_action/masturbate/other/tailjob_vagina/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] presses [user.p_their()] tail into [target]'s [pick("slit","cunt","pussy","snatch")]..."))
	playsound(user, 'sound/misc/mat/fingering.ogg', 30, TRUE, -2, ignore_walls = FALSE)

	sex_session.perform_sex_action(target, 3, 4, TRUE)

	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/masturbate/other/tailjob_vagina/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	sex_locks |= new /datum/sex_session_lock(user, ORGAN_SLOT_TAIL)
	sex_locks |= new /datum/sex_session_lock(target, ORGAN_SLOT_VAGINA)
