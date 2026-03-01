/datum/sex_action/sex/footjob
	name = "Use their feet to get off"
	intensity = 3
	debug_erp_panel_verb = FALSE //Makes it completely fine by me.

/datum/sex_action/sex/footjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/sex/footjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(check_sex_lock(user, ORGAN_SLOT_PENIS))
		return FALSE
	// Need to be on the floor
	if(user.resting)
		return FALSE
	// Target has to be standing / but also this is for SOME forsaken reason flipped
	if(!target.resting)
		return FALSE
	return TRUE

/datum/sex_action/sex/footjob/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] grabs [target]'s feet and shoves [user.p_their()] pintle inbetween!")

/datum/sex_action/sex/footjob/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] pulls [user.p_their()] pintle out from inbetween [target]'s feet.")

/datum/sex_action/sex/footjob/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_love("[user] cums over [target]'s feet!"))
	return "onto"

/datum/sex_action/sex/footjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fucks [target]'s feet."))
	playsound(user, 'sound/misc/mat/fingering.ogg', 20, TRUE, -2, ignore_walls = FALSE)
	do_thrust_animate(user, target, sex_session)
	do_onomatopoeia(user)

	sex_session.perform_sex_action(user, 2, 4, TRUE)
	sex_session.handle_passive_ejaculation(target)
