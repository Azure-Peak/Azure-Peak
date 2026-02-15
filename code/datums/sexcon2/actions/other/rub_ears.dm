/datum/sex_action/rub_ears
	name = "Rub their ears"
	check_same_tile = FALSE
	target_priority = 100
	user_priority = 0
	flipped = TRUE	

/datum/sex_action/rub_ears/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/rub_ears/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	var/locked = user.get_active_precise_hand()
	if(check_sex_lock(user, locked))
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_EARS, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/rub_ears/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] places [user.p_their()] hands against [target] ears..."))

/datum/sex_action/rub_ears/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] stops rubbing [target]'s ears ..."))

/datum/sex_action/rub_ears/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.make_sucking_noise()

	if(iself(target) || ishalfelf(target) || isdarkelf(target) || ishalforc(target) || isgoblinp(target))
		sex_session.perform_sex_action(target, 5, 0, TRUE)
		user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] rubs [target]'s ears... [target.p_their()] weakness..."))
	else
		sex_session.perform_sex_action(target, 0.5, 0, TRUE)
		user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] rubs [target]'s ears..."))

	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/rub_ears/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/locked = user.get_active_precise_hand()
	sex_locks |= new /datum/sex_session_lock(user, locked)
