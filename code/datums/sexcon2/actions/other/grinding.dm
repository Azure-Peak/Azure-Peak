/datum/sex_action/grind_body
	name = "Grind against them"
	check_same_tile = FALSE

/datum/sex_action/grind_body/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/grind_body/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/grind_body/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] pulls themselves onto [target]...")

/datum/sex_action/grind_body/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] grinds against [target]."))
	playsound(target, 'sound/misc/mat/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE)
	do_thrust_animate(user, target)

	sex_session.perform_sex_action(user, 1, 0.5, TRUE)
	sex_session.handle_passive_ejaculation()

	sex_session.perform_sex_action(target, 1, 0.5, TRUE)
	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/grind_body/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] stops grinding against [target].")
