/datum/sex_action/oral/suck_nipples
	name = "Suck their nipples"
	check_same_tile = FALSE
	intensity = 3
	flipped = TRUE
	debug_erp_panel_verb = FALSE

/datum/sex_action/oral/suck_nipples/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, target, BODY_ZONE_CHEST, TRUE))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/oral/suck_nipples/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(check_sex_lock(user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_BREASTS))
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, target, BODY_ZONE_CHEST, TRUE))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/oral/suck_nipples/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(span_warning("[user] starts [do_subtle ? "subtly " : ""]sucking [target]'s nipples..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/oral/suck_nipples/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(span_warning("[user] stops [do_subtle ? "subtly " : ""]sucking [target]'s nipples ..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/oral/suck_nipples/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	sex_locks |= new /datum/sex_session_lock(user, BODY_ZONE_PRECISE_MOUTH)

/datum/sex_action/oral/suck_nipples/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] sucks [target]'s nipples..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/oral/suck_nipples/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.make_sucking_noise(do_subtle)

	sex_session.perform_sex_action(target, 1, 3, TRUE, sex_session.speed, sex_session.force)
	sex_session.handle_passive_ejaculation(target)

//No we really don't need remnants of milking code in here.
