
/datum/sex_action/blowjob
	name = "Suck them off"
	require_grab = FALSE
	check_same_tile = FALSE
	target_priority = 100

/datum/sex_action/blowjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_PENIS))
		return FALSE
	if(check_sex_lock(user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE

	return TRUE

/datum/sex_action/blowjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] starts sucking [target]'s cock..."))

/datum/sex_action/blowjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.make_sucking_noise()
	// you want to know how i got these scars?
	if(istype(user.head, /obj/item/clothing/head/roguetown/jester))
		playsound(user, SFX_JINGLE_BELLS, 30, TRUE, -2, ignore_walls = FALSE)
	do_thrust_animate(user, target)

	var/datum/sex_session/sex_session = get_sex_session(user, target)

	sex_session.perform_sex_action(target, 2, 0, TRUE)

/datum/sex_action/blowjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] stops sucking [target]'s cock ..."))

/datum/sex_action/blowjob/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	sex_locks |= new /datum/sex_session_lock(target, ORGAN_SLOT_PENIS)
	sex_locks |= new /datum/sex_session_lock(user, BODY_ZONE_PRECISE_MOUTH)

/datum/sex_action/blowjob/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	target.visible_message(span_love("[target] cums into [user]'s mouth!"))
	return "into"
