/datum/sex_action/masturbate/other/godjob_anal
	name = "Finger their butt with godhand"
	check_same_tile = FALSE
	ranged_action = TRUE
	debug_erp_panel_verb = FALSE

/datum/sex_action/masturbate/other/godjob_anal/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item || !istype(held_item, /obj/item/melee/new_touch_attack/orison))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/godjob_anal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item || !istype(held_item, /obj/item/melee/new_touch_attack/orison))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_ANUS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/godjob_anal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] starts to finger [target]'s butt with divine help..."))

/datum/sex_action/masturbate/other/godjob_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] stops fingering [target]."))

/datum/sex_action/masturbate/other/godjob_anal/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	sex_locks |= new /datum/sex_session_lock(target, ORGAN_SLOT_ANUS)

/datum/sex_action/masturbate/other/godjob_anal/proc/get_patron_data(patron_type)
	switch(patron_type)
		if(/datum/patron/old_god, /datum/patron/divine/undivided)
			return list(
				"message" = "but nothing happens...",
				"arousal_mult" = 0,
				"pain" = 0
			)

		if(/datum/patron/divine/astrata, /datum/patron/divine/malum, /datum/patron/inhumen/matthios)
			return list(
				"message" = "the glow looks painful...",
				"arousal_mult" = 2,
				"pain" = 5
			)

		if(/datum/patron/divine/eora, /datum/patron/inhumen/baotha)
			return list(
				"message" = "the air grows sweet with indulgence...",
				"arousal_mult" = 15,
				"pain" = 0
			)

		if(/datum/patron/divine/ravox, /datum/patron/inhumen/graggar)
			return list(
				"message" = "that looks painful...",
				"arousal_mult" = 2,
				"pain" = 15
			)

		if(/datum/patron/divine/noc)
			return list(
				"message" = "an ominous veil enveloping it...",
				"arousal_mult" = 1,
				"pain" = 0
			)

		if(/datum/patron/divine/abyssor, /datum/patron/divine/dendor)
			return list(
				"message" = "with primal force...",
				"arousal_mult" = 6,
				"pain" = 10
			)

		if(/datum/patron/divine/necra, /datum/patron/inhumen/zizo)
			return list(
				"message" = "a cold aura enveloping it...",
				"arousal_mult" = 4,
				"pain" = 5
			)

		if(/datum/patron/divine/xylix)
			return list(
				"message" = "where is that jingle coming from?",
				"arousal_mult" = 4,
				"pain" = 0,
				"jingle" = TRUE
			)

		if(/datum/patron/mossmother)
			return list(
				"message" = "with a primordial energy that seems to take root...",
				"arousal_mult" = 3,
				"pain" = 10
			)

	return list(
		"message" = "",
		"arousal_mult" = 2,
		"pain" = 0
	)

/datum/sex_action/masturbate/other/godjob_anal/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/list/data = get_patron_data(user.patron?.type)

	user.visible_message(
		sex_session.spanify_force(
			"[user] [sex_session.get_generic_force_adjective()] fingers [target]'s butt... [data["message"]]"
		)
	)


/datum/sex_action/masturbate/other/godjob_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/skill_level = user.get_skill_level(/datum/skill/magic/holy)

	playsound(user, 'sound/misc/mat/fingering.ogg', 30, TRUE, -2, ignore_walls = FALSE)

	var/list/data = get_patron_data(user.patron?.type)

	if(data["jingle"])
		playsound(user, SFX_JINGLE_BELLS, 30, TRUE, -2, ignore_walls = FALSE)

	sex_session.perform_sex_action(
		target,
		data["arousal_mult"] * skill_level,
		data["pain"],
		TRUE
	)

	sex_session.handle_passive_ejaculation(target)
