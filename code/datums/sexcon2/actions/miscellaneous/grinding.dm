/datum/sex_action/miscellaneous/grind_body
	name = "Grind against them"
	check_same_tile = FALSE
	intensity = 2
	debug_erp_panel_verb = FALSE

/datum/sex_action/miscellaneous/grind_body/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/miscellaneous/grind_body/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/miscellaneous/grind_body/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	return span_warning("[user] [do_subtle ? "subtly " : ""]pulls themselves onto [target]...")

/datum/sex_action/miscellaneous/grind_body/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	return span_warning("[user] stops [do_subtle ? "subtly " : ""]grinding against [target].")

/datum/sex_action/miscellaneous/grind_body/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] grinds against [target]."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/miscellaneous/grind_body/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	playsound(target, 'sound/misc/mat/segso.ogg', 50, TRUE, (do_subtle ? -6 : -2), ignore_walls = FALSE)
	if(!do_subtle)
		do_thrust_animate(user, target)

	sex_session.perform_sex_action(user, 1, 0.5, TRUE, sex_session.speed, sex_session.force)
	sex_session.handle_passive_ejaculation()

	sex_session.perform_sex_action(target, 1, 0.5, TRUE, sex_session.speed, sex_session.force)
	sex_session.handle_passive_ejaculation(target)
