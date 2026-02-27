/datum/sex_action/masturbate/other/magejob_anal
	name = "Finger their butt with magehand"
	check_same_tile = FALSE
	ranged_action = TRUE
	debug_erp_panel_verb = FALSE

/datum/sex_action/masturbate/other/magejob_anal/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item || !istype(held_item, /obj/item/melee/touch_attack/prestidigitation))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_ANUS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/magejob_anal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item || !istype(held_item, /obj/item/melee/touch_attack/prestidigitation))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_ANUS))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_ANUS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/magejob_anal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] starts to finger [target]'s butt with arcyne..."))

/datum/sex_action/masturbate/other/magejob_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] stops fingering [target]."))

/datum/sex_action/masturbate/other/magejob_anal/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	sex_locks |= new /datum/sex_session_lock(target, ORGAN_SLOT_ANUS)

/datum/sex_action/masturbate/other/magejob_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/skill_level = user.get_skill_level(/datum/skill/magic/arcane)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fingers [target]'s butt..."))
	playsound(user, 'sound/misc/mat/fingering.ogg', 30, TRUE, -2, ignore_walls = FALSE)

	sex_session.perform_sex_action(target, (2*skill_level), 0, TRUE)

	sex_session.handle_passive_ejaculation(target)
