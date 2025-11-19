/datum/sex_action/scissoring
	name = "Scissor them"

/datum/sex_action/scissoring/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return
	return TRUE

/datum/sex_action/scissoring/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(check_sex_lock(user, ORGAN_SLOT_VAGINA))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/scissoring/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] spreads [user.p_their()] legs and aligns [user.p_their()] cunt against [target]'s own!")

/datum/sex_action/scissoring/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] scissors with [target]'s cunt."))
	playsound(target, 'sound/misc/mat/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE)
	do_thrust_animate(user, target)

	sex_session.perform_sex_action(user, 1, 4, TRUE)
	sex_session.handle_passive_ejaculation()

	sex_session.perform_sex_action(target, 1, 4, TRUE)
	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/scissoring/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] stops scissoring with [target].")

///if someone can convince me you can somehow find a way to do another action on scissoring that shouldn't be a seperate action I will remove this
/datum/sex_action/scissoring/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	sex_locks |= new /datum/sex_session_lock(user, ORGAN_SLOT_VAGINA)
	sex_locks |= new /datum/sex_session_lock(target, ORGAN_SLOT_VAGINA)
