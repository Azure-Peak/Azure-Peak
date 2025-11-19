/datum/sex_action/sex/throat
	name = "Fuck their throat"
	stamina_cost = 1.0

/datum/sex_action/sex/throat/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/sex/throat/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(check_sex_lock(user, ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/sex/throat/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] slides [user.p_their()] cock into [target]'s throat!")

/datum/sex_action/sex/throat/get_start_sound(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg')

/datum/sex_action/sex/throat/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/is_knotting = sex_session.do_knot_action
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] [is_knotting ? "knot-fucks" : "fucks"] [target]'s throat."))
	playsound(target, 'sound/misc/mat/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE)
	do_thrust_animate(user, target)

	sex_session.perform_sex_action(user, 2, 0, TRUE)

	if(sex_session.considered_limp(user))
		sex_session.perform_sex_action(target, 0, 2, FALSE)
	else
		var/target_pleasure = is_knotting ? 11 : 7
		sex_session.perform_sex_action(target, 0, target_pleasure, FALSE)
	sex_session.handle_passive_ejaculation()

/datum/sex_action/sex/throat/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_love("[user] cums into [target]'s throat!"))
	user.virginity = FALSE
	return "into"


/datum/sex_action/sex/throat/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] pulls [user.p_their()] cock out of [target]'s throat.")

/datum/sex_action/sex/throat/get_knot_count()
	return 1

/datum/sex_action/sex/throat/double
	name = "Fuck their throat with both cocks"

/datum/sex_action/sex/throat/double/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!has_double_penis(user))
		return FALSE
	return ..()

/datum/sex_action/sex/throat/double/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!has_double_penis(user))
		return FALSE
	return ..()

/datum/sex_action/sex/throat/double/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] slides [user.p_their()] cocks into [target]'s throat!")

/datum/sex_action/sex/throat/double/get_start_sound(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg')

/datum/sex_action/sex/throat/double/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/is_knotting = sex_session.do_knot_action
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] [is_knotting ? "double-knots" : "double-fucks"] [target]'s throat."))
	playsound(target, 'sound/misc/mat/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE)
	do_thrust_animate(user, target)

	do_onomatopoeia(user)

	sex_session.perform_sex_action(user, 2, 0, TRUE)

	if(sex_session.considered_limp(user))
		sex_session.perform_sex_action(target, 0, 2, FALSE)
	else
		var/target_pleasure = is_knotting ? 11 : 7
		sex_session.perform_sex_action(target, 0, target_pleasure, FALSE)
	sex_session.handle_passive_ejaculation()

/datum/sex_action/sex/throat/double/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] pulls [user.p_their()] cocks out of [target]'s throat.")

/datum/sex_action/sex/throat/double/get_knot_count()
	return 2
