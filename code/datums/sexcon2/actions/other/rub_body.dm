/datum/sex_action/rub_body
	name = "Rub their body"
	check_same_tile = FALSE

/datum/sex_action/rub_body/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/rub_body/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	var/locked = user.get_active_precise_hand()
	if(check_sex_lock(user, locked))
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_CHEST, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/rub_body/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] places [user.p_their()] hands onto [target]..."))

/datum/sex_action/rub_body/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] rubs [target]'s body..."))
	user.make_sucking_noise()

	sex_session.perform_sex_action(target, 0.5, 0, TRUE)
	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/rub_body/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] stops rubbing [target]'s body ..."))

/datum/sex_action/rub_body/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/locked = user.get_active_precise_hand()
	sex_locks |= new /datum/sex_session_lock(user, locked)
