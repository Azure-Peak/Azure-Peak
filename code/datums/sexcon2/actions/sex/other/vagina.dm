/datum/sex_action/sex/other/vagina
	name = "Ride them with cunt"
	stamina_cost = 1.0
	aggro_grab_instead_same_tile = FALSE
	intensity = 4
	flipped = TRUE
	debug_erp_panel_verb = FALSE

/datum/sex_action/sex/other/vagina/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/sex/other/vagina/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/sex/other/vagina/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	return span_warning("[user] [do_subtle ? "subtly " : ""]gets on top of [target] and begins riding [target.p_them()] with [user.p_their()] cunt!")

/datum/sex_action/sex/other/vagina/get_start_sound(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg')

/datum/sex_action/sex/other/vagina/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	return span_warning("[user] [do_subtle ? "subtly " : ""]gets off [target].")

/datum/sex_action/sex/other/vagina/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/flipped = FALSE
	if(!sex_session)
		sex_session = get_sex_session(target, user)
		flipped = TRUE
	var/do_subtle = sex_session.doing_subtly
	if(flipped)	// The one being ridden is accessing this.
		target.visible_message(span_love("[user] [do_subtle ? "subtly " : ""]cums into [target]'s cunt!"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	else	// The rider
		user.visible_message(span_love("[user] [do_subtle ? "subtly " : ""]quivers onto [target]'s pintle!"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	target.virginity = FALSE
	user.virginity = FALSE
	target.try_impregnate(user)
	return "into"

/datum/sex_action/sex/other/vagina/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] rides [target]."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/sex/other/vagina/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	playsound(target, sex_session.get_force_sound(), 50, TRUE, (do_subtle ? -6 : -2), ignore_walls = FALSE)
	// i became a man at arms to get access to the keep...
	if(istype(user.head, /obj/item/clothing/head/roguetown/jester))
		playsound(user, SFX_JINGLE_BELLS, 30, TRUE, -2, ignore_walls = FALSE)
	if(!do_subtle)
		do_thrust_animate(user, target)
		do_onomatopoeia(user)

	sex_session.perform_sex_action(user, 2, 4, FALSE, sex_session.force, sex_session.speed)

	if(sex_session.considered_limp(target))
		sex_session.perform_sex_action(target, 1.2, 3, TRUE, sex_session.force, sex_session.speed)
	else
		sex_session.perform_sex_action(target, 2.4, 7, TRUE, sex_session.force, sex_session.speed)
	sex_session.handle_passive_ejaculation(target)
