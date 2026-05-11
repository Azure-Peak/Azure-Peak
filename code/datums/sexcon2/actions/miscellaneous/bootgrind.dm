/datum/sex_action/miscellaneous/stompjob
	name = "Stomp on them"
	check_same_tile = FALSE
	intensity = 3
	debug_erp_panel_verb = FALSE

/datum/sex_action/sex/other/stompjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(target, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(user.resting)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_TESTICLES))
		return FALSE
	return TRUE

/datum/sex_action/sex/other/stompjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(target, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	// Need to stand up
	if(user.resting)
		return FALSE
	// Target can't stand up
	if(!target.resting)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_TESTICLES))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_TESTICLES))
		return FALSE
	return TRUE

/datum/sex_action/sex/other/stompjob/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] puts [user.p_their()] feet on [target]...")

/datum/sex_action/sex/other/stompjob/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] pulls [user.p_their()] feet off [target]...")

/datum/sex_action/sex/other/stompjob/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_love("[user] cums over [target]'s feet!"))
	return "onto"

/datum/sex_action/sex/other/stompjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] stomps [target]'s balls with [user.p_their()] feet..."))
	playsound(user, 'sound/combat/hits/kick/stomp.ogg', 30, TRUE, -2, ignore_walls = FALSE)
	// and i had never had c hance to interact with the jesters...
	if(istype(user.shoes, /obj/item/clothing/shoes/roguetown/jester))
		playsound(user, SFX_JINGLE_BELLS, 30, TRUE, -2, ignore_walls = FALSE)

	if(istype(user.shoes, /obj/item/clothing/shoes/roguetown))
		sex_session.perform_sex_action(target, 2, 10, TRUE)
		sex_session.handle_passive_ejaculation(target)
	else
		sex_session.perform_sex_action(target, 2, 4, TRUE)
		sex_session.handle_passive_ejaculation(target)
