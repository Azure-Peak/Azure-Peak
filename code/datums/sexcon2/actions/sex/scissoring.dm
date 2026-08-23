/datum/sex_action/scissoring
	name = "Scissor them"
	intensity = 4
	debug_erp_panel_verb = FALSE //Because who cares how backend is.

/datum/sex_action/scissoring/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return TRUE

/datum/sex_action/scissoring/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(check_sex_lock(user, ORGAN_SLOT_VAGINA))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_VAGINA))
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return TRUE

/datum/sex_action/scissoring/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	return span_warning("[user] [do_subtle ? "subtly " : ""]spreads [user.p_their()] legs and aligns [user.p_their()] cunt against [target]'s own!")

/datum/sex_action/scissoring/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	return span_warning("[user] stops [do_subtle ? "subtly " : ""]scissoring with [target].")

///if someone can convince me you can somehow find a way to do another action on scissoring that shouldn't be a seperate action I will remove this
/datum/sex_action/scissoring/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	sex_locks |= new /datum/sex_session_lock(user, ORGAN_SLOT_VAGINA)
	sex_locks |= new /datum/sex_session_lock(target, ORGAN_SLOT_VAGINA)

/datum/sex_action/scissoring/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] scissors with [target]'s cunt."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/scissoring/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	playsound(target, 'sound/misc/mat/segso.ogg', 50, TRUE, (do_subtle ? -6 : -2), ignore_walls = FALSE)
	if(!do_subtle)
		do_thrust_animate(user, target, sex_session)
		do_onomatopoeia(user)

	sex_session.perform_sex_action(user, 1, 4, TRUE, sex_session.speed, sex_session.force)
	sex_session.handle_passive_ejaculation()

	sex_session.perform_sex_action(target, 1, 4, TRUE, sex_session.speed, sex_session.force)
	sex_session.handle_passive_ejaculation(target)
