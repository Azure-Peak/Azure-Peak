/datum/sex_action/toy/other/oral
	name = "Fuck their mouth with a toy"
	stamina_cost = 1.0

/datum/sex_action/toy/other/oral/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	// Check if user has a toy in hand
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item || !istype(held_item, /obj/item/dildo))
		return FALSE
	if(check_sex_lock(target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH, TRUE))
		return FALSE

	return TRUE

/datum/sex_action/toy/other/oral/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item || !istype(held_item, /obj/item/dildo))
		return FALSE
	return TRUE


/datum/sex_action/toy/other/oral/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] slides a dildo into [target]'s mouth!"))

/datum/sex_action/toy/other/oral/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.make_sucking_noise()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/obj/item/dildo/used_item = user.get_active_held_item()
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fucks [target]'s throat with a dildo!"))
	sex_session.perform_sex_action(target, 0, used_item.pleasure, TRUE)


/datum/sex_action/toy/other/oral/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] pulls [user.p_their()] dildo from [target]'s mouth."))

/datum/sex_action/toy/other/oral/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	sex_locks |= new /datum/sex_session_lock(target, BODY_ZONE_PRECISE_MOUTH)
