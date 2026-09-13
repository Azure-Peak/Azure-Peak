/datum/sex_action/masturbate/anus
	name = "Finger butt"
	debug_erp_panel_verb = FALSE

/datum/sex_action/masturbate/anus/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user != target)
		return FALSE
	if(check_sex_lock(user, ORGAN_SLOT_ANUS))
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/anus/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user != target)
		return FALSE
	if(check_sex_lock(user, ORGAN_SLOT_ANUS))
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/anus/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(span_warning("[user] starts [sex_session.doing_subtly ? "subtly " : ""]fingering [user.p_their()] butt..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/masturbate/anus/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(span_warning("[user] stops [sex_session.doing_subtly ? "subtly " : ""]fingering [user.p_their()] butt."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/masturbate/anus/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	sex_locks |= new /datum/sex_session_lock(user, ORGAN_SLOT_ANUS)

/datum/sex_action/masturbate/anus/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] fingers [user.p_their()] butt..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/masturbate/anus/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	playsound(user, 'sound/misc/mat/fingering.ogg', 30, TRUE, (do_subtle ? -6 : -2), ignore_walls = FALSE)

	sex_session.perform_sex_action(user, 2, 6, TRUE, sex_session.speed, sex_session.force)
	sex_session.handle_passive_ejaculation()
