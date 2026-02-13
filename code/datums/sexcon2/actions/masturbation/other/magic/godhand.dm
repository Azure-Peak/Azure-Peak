/datum/sex_action/masturbate/other/godjob
	name = "Jerk them off with godhand"
	check_same_tile = FALSE
	ranged_action = TRUE

/datum/sex_action/masturbate/other/godjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item || !istype(held_item, /obj/item/melee/touch_attack/orison))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/godjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
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
	if(check_sex_lock(target, ORGAN_SLOT_PENIS))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/godjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] starts jerking [target]'s cock off..."))

/datum/sex_action/masturbate/other/godjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] stops jerking [target] off."))

/datum/sex_action/masturbate/other/godjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	playsound(user, 'sound/misc/mat/fingering.ogg', 30, TRUE, -2, ignore_walls = FALSE)

	switch(user.patron?.type)//There has to be better way to do this but whoever comes after that is a YOU problem not mine.
		if(/datum/patron/old_god, /datum/patron/divine/undivided)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] jerks [target]'s cock off... but nothing happens..."))
			sex_session.perform_sex_action(target, 0, 0, TRUE)
		if(/datum/patron/divine/astrata, /datum/patron/divine/malum, /datum/patron/inhumen/matthios)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] jerks [target]'s cock off... the glow looks painful..."))
			sex_session.perform_sex_action(target, 2, 5, TRUE)
		if(/datum/patron/divine/eora, /datum/patron/inhumen/baotha)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] jerks [target]'s cock off... [target] looks in extasy..."))
			sex_session.perform_sex_action(target, 8, 0, TRUE)
		if(/datum/patron/divine/ravox, /datum/patron/inhumen/graggar)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] jerks [target]'s cock off... that looks painful..."))
			sex_session.perform_sex_action(target, 2, 15, TRUE)
		if(/datum/patron/divine/noc)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] jerks [target]'s cock off... ominous veil enveloping it..."))
			sex_session.perform_sex_action(target, 0.5, 0, TRUE)
		if(/datum/patron/divine/abyssor, /datum/patron/divine/dendor)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] jerks [target]'s cock off with primal force..."))
			sex_session.perform_sex_action(target, 6, 10, TRUE)
		if(/datum/patron/divine/necra, /datum/patron/inhumen/zizo)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] jerks [target]'s cock off... cold aura enveloping it..."))
			sex_session.perform_sex_action(target, 4, 5, TRUE)
		if(/datum/patron/divine/xylix)
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] jerks [target]'s cock off... where is that jingle coming from?"))
			playsound(user, SFX_JINGLE_BELLS, 30, TRUE, -2, ignore_walls = FALSE)
			sex_session.perform_sex_action(target, 4, 0, TRUE)
		else
			user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] jerks [target]'s cock off..."))
			sex_session.perform_sex_action(target, 2, 0, TRUE)
	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/masturbate/other/godjob/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	sex_locks |= new /datum/sex_session_lock(target, ORGAN_SLOT_PENIS)
