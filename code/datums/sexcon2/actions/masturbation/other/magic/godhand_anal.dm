/datum/sex_action/masturbate/other/godjob_anal
	name = "Finger their butt with godhand"
	check_same_tile = FALSE
	ranged_action = TRUE
	debug_erp_panel_verb = FALSE

/datum/sex_action/masturbate/other/godjob_anal/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item || !istype(held_item, /obj/item/melee/touch_attack/orison))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_ANUS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/godjob_anal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item || !istype(held_item, /obj/item/melee/touch_attack/orison))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_ANUS))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_ANUS))
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

/datum/sex_action/masturbate/other/godjob_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/skill_level = user.get_skill_level(/datum/skill/magic/holy)
	playsound(user, 'sound/misc/mat/fingering.ogg', 30, TRUE, -2, ignore_walls = FALSE)

	switch(user.patron?.type)//There has to be better way to do this but whoever comes after that is a YOU problem not mine.
		if(/datum/patron/old_god, /datum/patron/divine/undivided)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fingers [target]'s butt.. but nothing happens..."))
			sex_session.perform_sex_action(target, 0, 0, TRUE)
		if(/datum/patron/divine/astrata, /datum/patron/divine/malum, /datum/patron/inhumen/matthios)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fingers [target]'s butt... the glow looks painful..."))
			sex_session.perform_sex_action(target, (2*skill_level), 5, TRUE)
		if(/datum/patron/divine/eora, /datum/patron/inhumen/baotha)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fingers [target]'s butt... [target] looks in extasy..."))
			sex_session.perform_sex_action(target, (15*skill_level), 0, TRUE)
		if(/datum/patron/divine/ravox, /datum/patron/inhumen/graggar)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fingers [target]'s butt... that looks painful..."))
			sex_session.perform_sex_action(target, (2*skill_level), 15, TRUE)
		if(/datum/patron/divine/noc)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fingers [target]'s butt... ominous veil enveloping it..."))
			sex_session.perform_sex_action(target, (1*skill_level), 0, TRUE)
		if(/datum/patron/divine/abyssor, /datum/patron/divine/dendor)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fingers [target]'s butt with primal force..."))
			sex_session.perform_sex_action(target, (6*skill_level), 10, TRUE)
		if(/datum/patron/divine/necra, /datum/patron/inhumen/zizo)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fingers [target]'s butt... cold aura enveloping it..."))
			sex_session.perform_sex_action(target, (4*skill_level), 5, TRUE)
		if(/datum/patron/divine/xylix)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fingers [target]'s butt... where is that jingle coming from?"))
			playsound(user, SFX_JINGLE_BELLS, 30, TRUE, -2, ignore_walls = FALSE)
			sex_session.perform_sex_action(target, (4*skill_level), 0, TRUE)
		else
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fingers [target]'s butt..."))
			sex_session.perform_sex_action(target, (2*skill_level), 0, TRUE)
	sex_session.handle_passive_ejaculation(target)
