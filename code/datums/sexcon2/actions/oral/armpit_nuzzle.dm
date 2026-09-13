/datum/sex_action/oral/armpit_nuzzle
	name = "Nuzzle their armpit"
	intensity = 2
	flipped = TRUE
	debug_erp_panel_verb = FALSE

/datum/sex_action/oral/armpit_nuzzle/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, target, BODY_ZONE_CHEST))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/oral/armpit_nuzzle/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(check_sex_lock(user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, target, BODY_ZONE_CHEST))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/oral/armpit_nuzzle/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(span_warning("[user] [do_subtle ? "subtly " : ""]moves [user.p_their()] head against [target]'s armpit..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/oral/armpit_nuzzle/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(span_warning("[user] stops [do_subtle ? "subtly " : ""]nuzzling [target]'s armpit..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/oral/armpit_nuzzle/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	sex_locks |= new /datum/sex_session_lock(user, BODY_ZONE_PRECISE_MOUTH)

/datum/sex_action/oral/armpit_nuzzle/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] nuzzles [target]'s armpit..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
