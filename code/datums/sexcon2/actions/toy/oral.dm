/datum/sex_action/toy/oral
	name = "Suck off toy"
	stamina_cost = 1.0

/datum/sex_action/toy/oral/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	// Check if user has a toy in hand
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item || !istype(held_item, /obj/item/dildo))
		return FALSE
	if(check_sex_lock(user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE

	return TRUE

/datum/sex_action/toy/oral/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item || !istype(held_item, /obj/item/dildo))
		return FALSE
	return TRUE


/datum/sex_action/toy/oral/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] starts sucking off a dildo..."))

/datum/sex_action/toy/oral/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.make_sucking_noise()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/obj/item/dildo/used_item = user.get_active_held_item()
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] sucks off a dildo!"))
	sex_session.perform_sex_action(user, 0, used_item.pleasure, TRUE)


/datum/sex_action/toy/oral/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] stops sucking off a dildo."))

/datum/sex_action/toy/oral/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	sex_locks |= new /datum/sex_session_lock(user, BODY_ZONE_PRECISE_MOUTH)
