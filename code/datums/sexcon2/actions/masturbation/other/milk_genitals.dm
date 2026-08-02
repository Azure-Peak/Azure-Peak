//VALMORIAN: Emerald Summit's force_milk_genitals, rebuilt on the sexcon2 session API. ES filed it
//under its "force" category; VI has no such category, so it sits with the other hands-on-them acts.
/datum/sex_action/masturbate/other/milk_genitals
	name = "Forcibly milk cock"
	check_same_tile = FALSE
	intensity = 2
	debug_erp_panel_verb = FALSE

/datum/sex_action/masturbate/other/milk_genitals/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!istype(user.get_active_held_item(), /obj/item/reagent_containers/glass))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS) && !target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/milk_genitals/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!istype(user.get_active_held_item(), /obj/item/reagent_containers/glass))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS) && !target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/milk_genitals/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] starts masturbating [target] over [user.get_active_held_item()]..."))

/datum/sex_action/masturbate/other/milk_genitals/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(target.getorganslot(ORGAN_SLOT_PENIS))
		user.visible_message(span_warning("[user] stops jerking [target] into the container."))
	else
		user.visible_message(span_warning("[user] stops fingering [target] over the container."))

/datum/sex_action/masturbate/other/milk_genitals/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	if(target.getorganslot(ORGAN_SLOT_PENIS))
		user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] jerks [target]'s cock into the [user.get_active_held_item()]..."))
	else
		user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fingers [target]'s cunt over the [user.get_active_held_item()]..."))

/datum/sex_action/masturbate/other/milk_genitals/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	playsound(user, 'sound/misc/mat/fingering.ogg', 30, TRUE, -2, ignore_walls = FALSE)

	sex_session.perform_sex_action(target, 2, 4, TRUE)

	//Not handle_passive_ejaculation() - the whole point is that the climax goes into the container.
	var/datum/component/arousal/arousal_comp = target.GetComponent(/datum/component/arousal)
	arousal_comp?.handle_cock_milking(user)
