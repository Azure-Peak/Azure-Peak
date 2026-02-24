/datum/component/arousal
	/// Our arousal level
	var/arousal = 0
	/// Arousal won't change if active
	var/arousal_frozen = FALSE
	/// Last time arousal increased
	var/last_arousal_increase_time = 0
	/// Last moan time for cooldowns
	var/last_moan = 0
	/// Last pain effect time
	var/last_pain = 0
	///our multiplier
	var/arousal_multiplier = 1
	/// Our charge gauge
	var/charge = SEX_MAX_CHARGE
	/// Last ejaculation time
	var/last_ejaculation_time = 0

/datum/component/arousal/Destroy(force)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/datum/component/arousal/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_SEX_ADJUST_AROUSAL, PROC_REF(adjust_arousal))
	RegisterSignal(parent, COMSIG_SEX_SET_AROUSAL, PROC_REF(set_arousal))
	RegisterSignal(parent, COMSIG_SEX_FREEZE_AROUSAL, PROC_REF(freeze_arousal))
	RegisterSignal(parent, COMSIG_SEX_GET_AROUSAL, PROC_REF(get_arousal))
	RegisterSignal(parent, COMSIG_SEX_RECEIVE_ACTION, PROC_REF(receive_sex_action))
	RegisterSignal(parent, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(check_processing))
	RegisterSignal(parent, COMSIG_MOB_LOGOUT, PROC_REF(check_processing))

/datum/component/arousal/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_SEX_ADJUST_AROUSAL)
	UnregisterSignal(parent, COMSIG_SEX_SET_AROUSAL)
	UnregisterSignal(parent, COMSIG_SEX_FREEZE_AROUSAL)
	UnregisterSignal(parent, COMSIG_SEX_GET_AROUSAL)
	UnregisterSignal(parent, COMSIG_SEX_RECEIVE_ACTION)
	UnregisterSignal(parent, COMSIG_MOB_CLIENT_LOGIN)
	UnregisterSignal(parent, COMSIG_MOB_LOGOUT)

/datum/component/arousal/process(dt)
	handle_charge(dt * 1)
	if(!can_lose_arousal())
		return
	adjust_arousal(parent, dt * -1)

/// Checks if our parent has a client and adjusts processing.
/datum/component/arousal/proc/check_processing()
	SIGNAL_HANDLER
	var/mob/parent_mob = parent
	if(parent_mob.client)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/datum/component/arousal/proc/can_lose_arousal()
	if(last_arousal_increase_time + AROUSAL_TIME_TO_UNHORNY > world.time)
		return FALSE
	return TRUE

/datum/component/arousal/proc/set_arousal(datum/source, amount, forced = FALSE)
	if(amount > arousal)
		last_arousal_increase_time = world.time
	var/clamp_max = MAX_AROUSAL
	var/mob/user = parent
	if(user.has_flaw(/datum/charflaw/addiction/thrillseeker))
		clamp_max = THRILLSEEKER_THRESHOLD
		if(forced)
			clamp_max = 50
	arousal = clamp(amount, 0, clamp_max)
	update_arousal_effects()
	try_ejaculate()
	SEND_SIGNAL(parent, COMSIG_SEX_AROUSAL_CHANGED)
	return arousal

/datum/component/arousal/proc/adjust_arousal(datum/source, amount, forced = FALSE)
	if(arousal_frozen)
		return arousal
	if(arousal > 0)
		arousal *= arousal_multiplier
	return set_arousal(source, arousal + amount, forced)

/datum/component/arousal/proc/adjust_arousal_special(datum/source, amount, forced = FALSE)
	var/mob/living/mob = parent
	if(!mob.has_flaw(/datum/charflaw/addiction/thrillseeker))
		return
	if(arousal_frozen)
		return arousal
	if(arousal > 0)
		arousal *= arousal_multiplier
	return set_arousal_special(source, arousal + amount, THRILLSEEKER_THRESHOLD)

/datum/component/arousal/proc/set_arousal_special(datum/source, amount, limit)
	if(last_ejaculation_time > world.time - (3 MINUTES))	//Short break to not cover the screen in pink too quickly.
		return
	if(amount > arousal)
		last_arousal_increase_time = world.time
	var/clamp_max = MAX_AROUSAL
	if(limit)
		clamp_max = limit
	arousal = clamp(amount, 0, clamp_max)
	update_arousal_effects()
	SEND_SIGNAL(parent, COMSIG_SEX_AROUSAL_CHANGED)
	return arousal

/datum/component/arousal/proc/freeze_arousal(datum/source, freeze_state = null)
	var/mob/user = parent
	if(user.has_flaw(/datum/charflaw/addiction/thrillseeker))
		return
	if(freeze_state == null)
		arousal_frozen = !arousal_frozen
	else
		arousal_frozen = freeze_state
	return arousal_frozen

/datum/component/arousal/proc/get_arousal(datum/source, list/arousal_data)
	arousal_data += list(
		"arousal" = arousal,
		"frozen" = arousal_frozen,
		"last_increase" = last_arousal_increase_time,
		"arousal_multiplier" = arousal_multiplier
	)

/datum/component/arousal/proc/receive_sex_action(datum/source, arousal_amt, pain_amt, giving, applied_force, applied_speed)
	var/mob/user = parent

	// Apply multipliers
	arousal_amt *= get_force_pleasure_multiplier(applied_force, giving)
	pain_amt *= get_force_pain_multiplier(applied_force)
	pain_amt *= get_speed_pain_multiplier(applied_speed)

	if(user.stat == DEAD)
		arousal_amt = 0
		pain_amt = 0

	if(!arousal_frozen)
		adjust_arousal(source, arousal_amt)

	damage_from_pain(pain_amt)
	try_do_moan(arousal_amt, pain_amt, applied_force, giving)
	try_do_pain_effect(pain_amt, giving)

/datum/component/arousal/proc/update_arousal_effects()
	update_pink_screen()
	update_blueballs()
	update_erect_state()

/datum/component/arousal/proc/try_ejaculate()
	if(arousal < PASSIVE_EJAC_THRESHOLD)
		return
	if(is_spent())
		return
	ejaculate()
	record_round_statistic(STATS_PLEASURES)

/datum/component/arousal/proc/ejaculate()
	var/mob/living/mob = parent
	var/list/parent_sessions = return_sessions_with_user(parent)
	var/datum/sex_session/highest_priority = return_highest_priority_action(parent_sessions, parent)
	var/mob/living/carbon/human/climaxer
	var/mob/living/carbon/human/partner 
	var/datum/sex_action/action = SEX_ACTION(highest_priority.current_action)

	if(action.flipped)
		climaxer = highest_priority.target
		partner = highest_priority.user
	else
		climaxer = highest_priority.user
		partner = highest_priority.target

	playsound(parent, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
	// Special case for when the climaxer has a penis but no testicles
	if(!mob.getorganslot(ORGAN_SLOT_TESTICLES) && mob.getorganslot(ORGAN_SLOT_PENIS))
		mob.visible_message(span_love("[mob] climaxes, yet nothing is released!"))
		after_ejaculation(action, climaxer, partner)
		return
	if(!highest_priority)
		mob.visible_message(span_love("[mob] makes a mess!"))
		var/turf/turf = get_turf(parent)
		new /obj/effect/decal/cleanable/coom(turf)
		after_ejaculation(action, climaxer, partner)
	else	
		var/return_message = action.handle_climax_message(climaxer, partner)
		if(!return_message)
			mob.visible_message(span_love("[mob] makes a mess!"))
			var/turf/turf = get_turf(parent)
			new /obj/effect/decal/cleanable/coom(turf)
			after_ejaculation(action, climaxer, partner)
		else
			handle_climax(return_message, climaxer, partner, action)
		if(action.knot_on_finish)
			action.try_knot_on_climax(mob, partner)

/datum/component/arousal/proc/ejaculate_special()
	var/mob/living/mob = parent
	after_ejaculation_special(mob)
	last_ejaculation_time = world.time

/datum/component/arousal/proc/after_ejaculation_special(mob/living/parent)
	parent.add_stress(/datum/stressevent/thrill)
	if(prob(1))
		parent.emote("groan", forced = TRUE)

/datum/component/arousal/proc/handle_climax(climax_type, mob/living/carbon/human/climaxer, mob/living/carbon/human/partner, action)

	switch(climax_type)
		if("onto")
			log_combat(climaxer, partner, "Came onto [partner]")
			playsound(partner, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
			var/turf/turf = get_turf(partner)
			new /obj/effect/decal/cleanable/coom(turf)
		if("into")
			log_combat(climaxer, partner, "Came inside [partner]")
			playsound(partner, 'sound/misc/mat/endin.ogg', 50, TRUE, ignore_walls = FALSE)
		if("self")
			log_combat(climaxer, climaxer, "Ejaculated")
			climaxer.visible_message(span_love("[climaxer] makes a mess!"))
			playsound(climaxer, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
			var/turf/turf = get_turf(partner)
			new /obj/effect/decal/cleanable/coom(turf)

	after_ejaculation(action, climaxer, partner)

/datum/component/arousal/proc/after_ejaculation(datum/sex_action/action, mob/living/carbon/human/climaxer, mob/living/carbon/human/partner)
	SEND_SIGNAL(climaxer, COMSIG_SEX_SET_AROUSAL, 20)
	SEND_SIGNAL(climaxer, COMSIG_SEX_CLIMAX)

	charge = max(0, charge - CHARGE_FOR_CLIMAX)

	var/intensity
	if(action)
		intensity = action.intensity
		if(!action.masturbation) //If the action's masturbation, no good lover bonus
			if(HAS_TRAIT(partner, TRAIT_GOODLOVER)) //If your partner is a good lover, your climax is more intense
				intensity += 1

	if(climaxer.has_flaw(/datum/charflaw/addiction/thrillseeker))
		var/datum/charflaw/addiction/thrill = climaxer.get_flaw(/datum/charflaw/addiction/thrillseeker)
		climaxer.playsound_local(climaxer, 'sound/misc/mat/end.ogg', 100)
		last_ejaculation_time = world.time
		if(!thrill.sated)
			climaxer.add_stress(/datum/stressevent/thrillsex)
		if(prob(10))
			climaxer.emote("groan", forced = TRUE)
		return	

	climaxer.emote("moan", forced = TRUE)
	climaxer.playsound_local(climaxer, 'sound/misc/mat/end.ogg', 100)
	last_ejaculation_time = world.time

	if(HAS_TRAIT(climaxer, TRAIT_UNSATISFIED)) //Given for 30 seconds when someone sets their arousal, it prevents gaining any benefits from orgasm
		return

	climaxer.sate_addiction(/datum/charflaw/addiction/lovefiend)
	partner.sate_addiction(/datum/charflaw/addiction/lovefiend)

	switch(intensity)
		if(1) //Should only be achievable with masturbation
			climaxer.add_stress(/datum/stressevent/cumself)
		if(2)
			climaxer.add_stress(/datum/stressevent/cumok)
		if(3)
			climaxer.add_stress(/datum/stressevent/cummid)
		if(4)
			climaxer.add_stress(/datum/stressevent/cumgood)
		if(5) //Should only be achievable with a good lover and a normally intimate action
			climaxer.add_stress(/datum/stressevent/cummax)
		else //This should not trigger but just in case
			climaxer.add_stress(/datum/stressevent/cumok)

	if(HAS_TRAIT(partner, TRAIT_GOODLOVER) && intensity >= 4)
		if(!climaxer.mob_timers["cumtri"])
			climaxer.mob_timers["cumtri"] = world.time
			climaxer.adjust_triumphs(1)
			to_chat(climaxer, span_love("Our loving is a true TRIUMPH!"))
		if(!partner.mob_timers["cumtri"])
			partner.mob_timers["cumtri"] = world.time
			partner.adjust_triumphs(1)
			to_chat(partner, span_love("Our loving is a true TRIUMPH!"))


/datum/component/arousal/proc/set_charge(amount)
	var/empty = (charge < CHARGE_FOR_CLIMAX)
	charge = clamp(amount, 0, SEX_MAX_CHARGE)
	var/after_empty = (charge < CHARGE_FOR_CLIMAX)
	if(empty && !after_empty)
		to_chat(parent, span_notice("I feel like I'm not so spent anymore"))
	if(!empty && after_empty)
		to_chat(parent, span_notice("I'm spent!"))

/datum/component/arousal/proc/adjust_charge(amount)
	set_charge(charge + amount)

/datum/component/arousal/proc/handle_charge(dt)
	adjust_charge(dt * CHARGE_RECHARGE_RATE)
	if(is_spent())
		if(arousal > 60)
			to_chat(parent, span_warning("I'm too spent!"))
			adjust_arousal(parent, -20)
			return
		adjust_arousal(parent, -dt * SPENT_AROUSAL_RATE)

/datum/component/arousal/proc/is_spent()
	if(charge < CHARGE_FOR_CLIMAX)
		return TRUE
	return FALSE

/datum/component/arousal/proc/update_pink_screen()
	var/mob/user = parent
	var/severity = min(10, CEILING(arousal * 0.1, 1))
	if(severity > 0)
		user.overlay_fullscreen("horny", /atom/movable/screen/fullscreen/love, severity)
	else
		user.clear_fullscreen("horny")

/datum/component/arousal/proc/update_blueballs()
	var/mob/user = parent
	if(last_arousal_increase_time + 30 SECONDS > world.time)
		return
	if(arousal >= BLUEBALLS_GAIN_THRESHOLD)
		user.add_stress(/datum/stressevent/blue_balls)
	else if(arousal <= BLUEBALLS_LOOSE_THRESHOLD)
		user.remove_stress(/datum/stressevent/blue_balls)

/datum/component/arousal/proc/update_erect_state()


/datum/component/arousal/proc/damage_from_pain(pain_amt)
	var/mob/living/carbon/user = parent
	if(pain_amt < PAIN_MINIMUM_FOR_DAMAGE)
		return
	var/damage = (pain_amt / PAIN_DAMAGE_DIVISOR)
	var/obj/item/bodypart/part = user.get_bodypart(BODY_ZONE_CHEST)
	if(!part)
		return
	user.apply_damage(damage, BRUTE, part)

/datum/component/arousal/proc/try_do_moan(arousal_amt, pain_amt, applied_force, giving)
	var/mob/user = parent
	if(arousal_amt < 1.5)
		return
	if(user.stat != CONSCIOUS)
		return
	if(last_moan + MOAN_COOLDOWN >= world.time)
		return
	if(prob(50))
		return
	var/chosen_emote
	switch(arousal_amt)
		if(0 to 5)
			chosen_emote = "sexmoanlight"
		if(5 to INFINITY)
			chosen_emote = "sexmoanhvy"

	if(pain_amt >= PAIN_MILD_EFFECT)
		if(giving)
			if(prob(30))
				chosen_emote = "groan"
		else
			if(prob(40))
				chosen_emote = "painmoan"
	if(pain_amt >= PAIN_MED_EFFECT)
		if(giving)
			if(prob(50))
				chosen_emote = "groan"
		else
			if(prob(60))
				chosen_emote = "painmoan"

	last_moan = world.time
	user.emote(chosen_emote)

/datum/component/arousal/proc/try_do_pain_effect(pain_amt, giving)
	var/mob/user = parent
	if(pain_amt < PAIN_MILD_EFFECT)
		return
	if(last_pain + PAIN_COOLDOWN >= world.time)
		return
	if(prob(50))
		return
	last_pain = world.time
	if(pain_amt >= PAIN_HIGH_EFFECT)
		var/pain_msg = pick(list("IT HURTS!!!", "IT NEEDS TO STOP!!!", "I CAN'T TAKE IT ANYMORE!!!"))
		to_chat(user, span_boldwarning(pain_msg))
		if(user.show_redflash())
			user.flash_fullscreen("redflash2")
		if(prob(70) && user.stat == CONSCIOUS)
			user.visible_message(span_warning("[user] shudders in pain!"))
	else if(pain_amt >= PAIN_MED_EFFECT)
		var/pain_msg = pick(list("It hurts!", "It pains me!"))
		to_chat(user, span_boldwarning(pain_msg))
		if(user.show_redflash())
			user.flash_fullscreen("redflash1")
		if(prob(40) && user.stat == CONSCIOUS)
			user.visible_message(span_warning("[user] shudders in pain!"))
	else
		var/pain_msg = pick(list("It hurts a little...", "It stings...", "I'm aching..."))
		to_chat(user, span_warning(pain_msg))

/datum/component/arousal/proc/get_force_pleasure_multiplier(passed_force, giving)
	switch(passed_force)
		if(SEX_FORCE_LOW)
			if(giving)
				return 0.8
			else
				return 0.8
		if(SEX_FORCE_MID)
			if(giving)
				return 1.2
			else
				return 1.2
		if(SEX_FORCE_HIGH)
			if(giving)
				return 1.6
			else
				return 1.2
		if(SEX_FORCE_EXTREME)
			if(giving)
				return 2.0
			else
				return 0.8

/datum/component/arousal/proc/get_force_pain_multiplier(passed_force)
	switch(passed_force)
		if(SEX_FORCE_LOW)
			return 0.5
		if(SEX_FORCE_MID)
			return 1.0
		if(SEX_FORCE_HIGH)
			return 2.0
		if(SEX_FORCE_EXTREME)
			return 3.0

/datum/component/arousal/proc/get_speed_pain_multiplier(passed_speed)
	switch(passed_speed)
		if(SEX_SPEED_LOW)
			return 0.8
		if(SEX_SPEED_MID)
			return 1.0
		if(SEX_SPEED_HIGH)
			return 1.2
		if(SEX_SPEED_EXTREME)
			return 1.4
