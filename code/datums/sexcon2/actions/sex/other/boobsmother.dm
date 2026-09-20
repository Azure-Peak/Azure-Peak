/datum/sex_action/sex/other/boobsmother
	name = "Smother them with boobs"
	intensity = 3
	debug_erp_panel_verb = FALSE

/datum/sex_action/sex/other/boobsmother/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(target, user, BODY_ZONE_CHEST))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return
	return TRUE

/datum/sex_action/sex/other/boobsmother/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(target, user, BODY_ZONE_CHEST))
		return FALSE
	return TRUE

/datum/sex_action/sex/other/boobsmother/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	return span_warning("[user] [do_subtle ? "subtly " : ""]shoves [target]'s head between [user.p_their()] tits!")

/datum/sex_action/sex/other/boobsmother/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	return span_warning("[user] [do_subtle ? "subtly " : ""]pulls [target]'s head out from inbetween [user.p_their()] tits.")

/datum/sex_action/sex/other/boobsmother/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	target.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] smothers [target]'s face with [user.p_their()] tits..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/sex/other/boobsmother/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	playsound(target, 'sound/misc/mat/fingering.ogg', 20, TRUE, (do_subtle ? -6 : -2), ignore_walls = FALSE)

	sex_session.perform_sex_action(target, 2, 4, TRUE, sex_session.speed, sex_session.force)
	sex_session.handle_passive_ejaculation(target)
