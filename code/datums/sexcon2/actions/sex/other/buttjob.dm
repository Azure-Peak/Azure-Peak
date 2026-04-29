/datum/sex_action/sex/other/buttjob
	name = "Give them a butt job"
	intensity = 3
	debug_erp_panel_verb = FALSE

/datum/sex_action/sex/other/buttjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(target, target, BODY_ZONE_PRECISE_GROIN, TRUE, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return
	return TRUE

/datum/sex_action/sex/other/buttjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(target, target, BODY_ZONE_PRECISE_GROIN, TRUE, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/sex/other/buttjob/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] shoves [target]'s pintle between [user.p_their()] butt!")

/datum/sex_action/sex/other/buttjob/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] pulls [target]'s pintle out from inbetween [user.p_their()] butt.")

/datum/sex_action/sex/other/buttjob/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_love("[user] cums over [target]'s butt!"))
	return "onto"

/datum/sex_action/sex/other/buttjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	target.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] rubs [target]'s pintle with [user.p_their()] butt..."))
	playsound(target, 'sound/misc/mat/fingering.ogg', 20, TRUE, -2, ignore_walls = FALSE)

	sex_session.perform_sex_action(target, 2, 4, TRUE)
	sex_session.handle_passive_ejaculation(target)
