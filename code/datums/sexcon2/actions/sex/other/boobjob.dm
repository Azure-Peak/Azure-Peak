/datum/sex_action/sex/other/boobjob
	name = "Give them a boob job"

/datum/sex_action/sex/other/boobjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return
	return TRUE

/datum/sex_action/sex/other/boobjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(target, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(target, user, BODY_ZONE_CHEST))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/sex/other/boobjob/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[target] shoves [user]'s cock between [user.p_their()] tits!")

/datum/sex_action/sex/other/boobjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	target.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fucks [target]'s tits."))
	playsound(target, 'sound/misc/mat/fingering.ogg', 20, TRUE, -2, ignore_walls = FALSE)

	sex_session.perform_sex_action(target, 2, 4, TRUE)

/datum/sex_action/sex/other/boobjob/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] pulls [user]'s cock out from inbetween [user.p_their()] tits.")
