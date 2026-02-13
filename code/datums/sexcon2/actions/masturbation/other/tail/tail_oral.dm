/datum/sex_action/masturbate/other/tailjob_oral
	name = "Prod their throat with a tail"
	check_same_tile = FALSE

/datum/sex_action/masturbate/other/tailjob_oral/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_TAIL))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/tailjob_oral/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_TAIL))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/tailjob_oral/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] slides [user.p_their()] tail into [target]'s throat!")

/datum/sex_action/masturbate/other/tailjob_oral/get_start_sound(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg')

/datum/sex_action/masturbate/other/tailjob_oral/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] pulls [user.p_their()] tail out of [target]'s throat.")

/datum/sex_action/masturbate/other/tailjob_oral/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] prods [target]'s throat with [user.p_their()] tail..."))
	playsound(user, 'sound/misc/mat/fingering.ogg', 30, TRUE, -2, ignore_walls = FALSE)

	sex_session.perform_sex_action(target, 3, 7, TRUE)

	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/masturbate/other/tailjob_oral/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	sex_locks |= new /datum/sex_session_lock(user, ORGAN_SLOT_TAIL)
	sex_locks |= new /datum/sex_session_lock(target, BODY_ZONE_PRECISE_MOUTH)
