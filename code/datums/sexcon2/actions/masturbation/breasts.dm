/datum/sex_action/masturbate/breasts
	name = "Fondle breasts"
	debug_erp_panel_verb = FALSE

/datum/sex_action/masturbate/breasts/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(check_sex_lock(user, ORGAN_SLOT_BREASTS))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_CHEST, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/breasts/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(user != target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_CHEST, TRUE))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(check_sex_lock(user, ORGAN_SLOT_BREASTS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/breasts/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] starts fondling [user.p_their()] breasts..."))

/datum/sex_action/masturbate/breasts/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] stops fondling [user.p_their()] breasts."))

/datum/sex_action/masturbate/anus/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	sex_locks |= new /datum/sex_session_lock(user, ORGAN_SLOT_BREASTS)

/datum/sex_action/masturbate/breasts/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fondles [user.p_their()] breasts..."))

	sex_session.perform_sex_action(user, 1, 4, TRUE)
	sex_session.handle_passive_ejaculation()
