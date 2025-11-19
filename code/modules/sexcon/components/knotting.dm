///chief i'm gonna be real this is whats gonna get me barred from entering the pearly gates
/datum/component/knotting
	/// Current knotted state
	var/knotted_status = KNOTTED_NULL
	/// Whether we're currently tugging a knot
	var/tugging_knot = FALSE
	/// Check counter for tugging validation
	var/tugging_knot_check = 0
	/// Whether knot area is blocked by clothing
	var/tugging_knot_blocked = FALSE
	/// Who owns the knot (the one with the penis)
	var/mob/living/carbon/knotted_owner = null
	/// Who received the knot (the one being knotted)
	var/mob/living/carbon/knotted_recipient = null
	/// How many knots are active (1 for single, 2 for double penetration)
	var/knot_count = 0

/datum/component/knotting/Destroy(force)
	if(knotted_status)
		knot_exit()
	. = ..()

/datum/component/knotting/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_SEX_TRY_KNOT, PROC_REF(try_knot))
	RegisterSignal(parent, COMSIG_SEX_REMOVE_KNOT, PROC_REF(knot_remove))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

/datum/component/knotting/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_SEX_TRY_KNOT)
	UnregisterSignal(parent, COMSIG_SEX_REMOVE_KNOT)
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

/datum/component/knotting/proc/check_knot_penis_type()
	var/mob/living/carbon/human/user = parent
	var/obj/item/organ/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)
	if(!penis)
		return FALSE
	switch(penis.penis_type)
		if(PENIS_TYPE_KNOTTED, PENIS_TYPE_TAPERED_DOUBLE_KNOTTED, PENIS_TYPE_BARBED_KNOTTED)
			return TRUE
	return FALSE

/datum/component/knotting/proc/try_knot(datum/source, mob/living/carbon/human/target, force_level, knot_count_param = 1)
	var/mob/living/carbon/human/user = parent

	if(!can_knot(user, target))
		return FALSE
	handle_existing_knots(user, target)
	apply_knot(user, target, force_level, knot_count_param)
	return TRUE

/datum/component/knotting/proc/can_knot(mob/living/carbon/human/user, mob/living/carbon/human/target)
	// Check if user can knot
	if(!check_knot_penis_type())
		return FALSE

	// Check if user is aroused enough
	var/list/arousal_data = list()
	SEND_SIGNAL(user, COMSIG_SEX_GET_AROUSAL, arousal_data)
	if(arousal_data["arousal"] < AROUSAL_HARD_ON_THRESHOLD)
		if(!knotted_status)
			to_chat(user, span_notice("My knot was too soft to tie."))
		if(knotted_recipient != target) // Only notify if this target isn't already knotted by us
			to_chat(target, span_notice("I feel their deflated knot slip out."))
		return FALSE

	//! VERY IMPORTANT A BETTER CONSENT SYSTEM

	return TRUE

/datum/component/knotting/proc/handle_existing_knots(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(knotted_status)
		var/repeated_customer = (knotted_recipient == target)
		var/user_was_top = (knotted_status == KNOTTED_AS_TOP)
		var/user_was_bottom = (knotted_status == KNOTTED_AS_BTM)

		knot_remove(keep_btm_status = user_was_bottom, keep_top_status = (user_was_top && repeated_customer))

		// Apply fucked stupid status if target was previously bottom
		if(user_was_top && knotted_owner && !target.has_status_effect(/datum/status_effect/knot_fucked_stupid))
			target.apply_status_effect(/datum/status_effect/knot_fucked_stupid)
			to_chat(target, span_userdanger("You can't think straight!"))

	var/mob/living/carbon/human/other_knotter = find_knotter_for_target(target)
	if(other_knotter && other_knotter != user)
		var/datum/component/knotting/other_knot = other_knotter.GetComponent(/datum/component/knotting)
		if(other_knot?.knotted_recipient == target)
			other_knot.knot_remove(forceful_removal = TRUE)
			if(other_knot.knotted_status == KNOTTED_AS_BTM && !target.has_status_effect(/datum/status_effect/knot_fucked_stupid))
				target.apply_status_effect(/datum/status_effect/knot_fucked_stupid)

/datum/component/knotting/proc/find_knotter_for_target(mob/living/carbon/human/target)
	for(var/mob/living/carbon/human/potential_knotter in view(10, target))
		var/datum/component/knotting/knot_comp = potential_knotter.GetComponent(/datum/component/knotting)
		if(knot_comp?.knotted_recipient == target && knot_comp.knotted_status)
			return potential_knotter
	return null

/datum/component/knotting/proc/count_active_knots(mob/living/carbon/human/target)
	var/count = 0
	for(var/mob/living/carbon/human/potential_knotter in view(10, target))
		var/datum/component/knotting/knot_comp = potential_knotter.GetComponent(/datum/component/knotting)
		if(knot_comp?.knotted_recipient == target && knot_comp.knotted_status == KNOTTED_AS_TOP)
			count += knot_comp.knot_count
	return count

/datum/component/knotting/proc/apply_knot(mob/living/carbon/human/user, mob/living/carbon/human/target, force_level, knot_count_param = 1)
	knotted_owner = user
	knotted_recipient = target
	knotted_status = KNOTTED_AS_TOP
	tugging_knot_blocked = FALSE
	knot_count = knot_count_param

	handle_knot_force_effects(user, target, force_level)
	var/knot_plural = knot_count > 1 ? "s" : ""
	user.visible_message(span_notice("[user] ties their knot[knot_plural] inside of [target]!"),
		span_notice("I tie my knot inside of [target]."))

	if(target.stat != DEAD)
		var/knot_count = count_active_knots(target)
		switch(knot_count)
			if(1)
				to_chat(target, span_userdanger("You have been knotted!"))
			if(2)
				to_chat(target, span_userdanger("You have been double-knotted!"))
			if(3)
				to_chat(target, span_userdanger("You have been triple-knotted!"))
			if(4)
				to_chat(target, span_userdanger("You have been quad-knotted!"))
			if(5)
				// LЄДGЦЄ ФF LЄGЄЙDS ЯЄFЄЯЄЙCЄ
				to_chat(target, span_userdanger("You have been penta-knotted!"))
			else
				// Six is the appropriate number for a joke message here
				to_chat(target, span_userdanger("You have been ultra-knotted!"))

	apply_knot_status_effects(user, target)

	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(knot_movement))
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(knot_movement))

	log_combat(user, target, "Started knot tugging")

/datum/component/knotting/proc/handle_knot_force_effects(mob/living/carbon/human/user, mob/living/carbon/human/target, force_level)
	if(force_level > SEX_FORCE_MID)
		var/datum/component/arousal/target_arousal = target.GetComponent(/datum/component/arousal)
		if(force_level == SEX_FORCE_EXTREME)
			target.apply_damage(30, BRUTE, BODY_ZONE_CHEST)
			target_arousal?.try_do_pain_effect(PAIN_HIGH_EFFECT, FALSE)
		else
			target_arousal?.try_do_pain_effect(PAIN_MILD_EFFECT, FALSE)
		target.Stun(80)

/datum/component/knotting/proc/apply_knot_status_effects(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/should_apply_fucked_stupid = FALSE
	if(user.patron && istype(user.patron, /datum/patron/inhumen/baotha))
		should_apply_fucked_stupid = TRUE

	if(should_apply_fucked_stupid && !target.has_status_effect(/datum/status_effect/knot_fucked_stupid))
		target.apply_status_effect(/datum/status_effect/knot_fucked_stupid)

	if(!target.has_status_effect(/datum/status_effect/knot_tied))
		target.apply_status_effect(/datum/status_effect/knot_tied)
	if(!user.has_status_effect(/datum/status_effect/knotted))
		user.apply_status_effect(/datum/status_effect/knotted)

	target.remove_status_effect(/datum/status_effect/knot_gaped)

/datum/component/knotting/proc/on_moved(atom/movable/mover, atom/oldloc, direction)
	if(!knotted_status)
		return

	var/mob/living/carbon/human/user = parent
	if(mover == user)
		addtimer(CALLBACK(src, PROC_REF(knot_movement_top)), 1)
	else if(mover == knotted_recipient && !tugging_knot)
		addtimer(CALLBACK(src, PROC_REF(knot_movement_btm)), 1)

/datum/component/knotting/proc/knot_movement(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER
	if(QDELETED(mover) || !ishuman(mover))
		if(ishuman(mover))
			UnregisterSignal(mover, COMSIG_MOVABLE_MOVED)
		return

	if(!knotted_status)
		UnregisterSignal(mover, COMSIG_MOVABLE_MOVED)
		return

	var/mob/living/carbon/human/user = parent
	if(mover == user)
		addtimer(CALLBACK(src, PROC_REF(knot_movement_top)), 1)
	else if(mover == knotted_recipient && !tugging_knot)
		addtimer(CALLBACK(src, PROC_REF(knot_movement_btm)), 1)

/datum/component/knotting/proc/knot_movement_top()
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient

	if(!validate_knot_participants(top, btm))
		return

	if(handle_special_movement_cases(top, btm))
		return

	if(should_remove_knot_on_movement(top, btm))
		return

	handle_knot_distance_management(top, btm)

/datum/component/knotting/proc/knot_movement_btm()
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient

	if(!validate_knot_participants(top, btm))
		return

	// Bottom-specific movement logic
	handle_bottom_movement(top, btm)

/datum/component/knotting/proc/validate_knot_participants(mob/living/carbon/human/top, mob/living/carbon/human/btm)
	if(!ishuman(btm) || QDELETED(btm) || !ishuman(top) || QDELETED(top))
		knot_exit()
		return FALSE

	#ifndef LOCALTEST
	if(isnull(top.client) || isnull(btm.client))
		knot_remove()
		return FALSE
	#endif

	return TRUE

/datum/component/knotting/proc/handle_special_movement_cases(mob/living/carbon/human/top, mob/living/carbon/human/btm)
	// Fireman carry case
	if(prob(10) && top.m_intent == MOVE_INTENT_WALK && (btm in top.buckled_mobs))
		var/obj/item/organ/penis/penis = top.getorganslot(ORGAN_SLOT_PENIS)
		var/datum/sex_session/session = get_sex_session(top, btm)
		if(session)
			session.perform_sex_action(btm, penis?.penis_size > DEFAULT_PENIS_SIZE ? 6.0 : 3.0, 2, FALSE)
			var/datum/component/arousal/btm_arousal = btm.GetComponent(/datum/component/arousal)
			btm_arousal?.try_ejaculate()
		if(prob(50))
			to_chat(top, span_love("I feel [btm] tightening over my knot."))
			to_chat(btm, span_love("I feel [top] rubbing inside."))
		return TRUE

	// Pulling case
	if(btm.pulling == top || top.pulling == btm)
		return TRUE

	return FALSE

/datum/component/knotting/proc/should_remove_knot_on_movement(mob/living/carbon/human/top, mob/living/carbon/human/btm)
	var/list/arousal_data = list()
	SEND_SIGNAL(top, COMSIG_SEX_GET_AROUSAL, arousal_data)
	if(arousal_data["arousal"] < AROUSAL_HARD_ON_THRESHOLD)
		knot_remove()
		return TRUE

	var/dist = get_dist(top, btm)
	if(dist > 1 && dist < 6)
		return FALSE

	if(dist > 1)
		knot_remove(forceful_removal = TRUE)
		return TRUE

	var/lupine_op = top.STASTR > (btm.STACON + 3)
	if(!lupine_op && top.m_intent == MOVE_INTENT_RUN && (top.mobility_flags & MOBILITY_STAND))
		knot_remove(forceful_removal = TRUE)
		return TRUE

	return FALSE

/datum/component/knotting/proc/handle_knot_distance_management(mob/living/carbon/human/top, mob/living/carbon/human/btm)
	var/dist = get_dist(top, btm)

	if(dist > 1 && dist < 6)
		tugging_knot = TRUE
		for(var/i in 1 to 3)
			step_towards(btm, top)
			dist = get_dist(top, btm)
			if(dist <= 1)
				break
		tugging_knot = FALSE

	btm.face_atom(top)
	top.set_pull_offsets(btm, GRAB_AGGRESSIVE)

	update_clothing_check()

	apply_movement_penalties(top, btm)

/datum/component/knotting/proc/update_clothing_check()
	if(tugging_knot_check == 0)
		var/mob/living/carbon/human/top = knotted_owner
		tugging_knot_blocked = !get_location_accessible(top, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE)
		tugging_knot_check = 5
	else
		tugging_knot_check--

/datum/component/knotting/proc/apply_movement_penalties(mob/living/carbon/human/top, mob/living/carbon/human/btm)
	if(!top.IsStun())
		var/stun_chance = !top.cmode && !tugging_knot_blocked ? 7 : 20
		if(prob(stun_chance))
			var/datum/component/arousal/top_arousal = top.GetComponent(/datum/component/arousal)
			top_arousal?.try_do_pain_effect(PAIN_MILD_EFFECT, FALSE)

			if(tugging_knot_blocked && (top.mobility_flags & MOBILITY_STAND))
				top.Knockdown(10)
				to_chat(top, span_warning("I trip trying to move while my knot is covered."))
				tugging_knot_blocked = FALSE
				tugging_knot_check = 0
			top.Stun(15)

	if(!btm.IsStun())
		if(prob(5))
			btm.emote("groan")
			var/datum/component/arousal/btm_arousal = btm.GetComponent(/datum/component/arousal)
			btm_arousal?.try_do_pain_effect(PAIN_MED_EFFECT, FALSE)
			btm.Stun(15)
		else if(prob(3))
			btm.emote("painmoan")

/datum/component/knotting/proc/handle_bottom_movement(mob/living/carbon/human/top, mob/living/carbon/human/btm)
	// Bottom-specific checks
	if(top.stat >= SOFT_CRIT)
		knot_remove()
		return

	var/list/arousal_data = list()
	SEND_SIGNAL(top, COMSIG_SEX_GET_AROUSAL, arousal_data)
	if(arousal_data["arousal"] < AROUSAL_HARD_ON_THRESHOLD)
		knot_remove()
		return

	var/dist = get_dist(top, btm)
	if(dist > 2)
		knot_remove(forceful_removal = TRUE)
		return

	// Move bottom towards top
	for(var/i in 2 to dist)
		step_towards(btm, top)

	top.set_pull_offsets(btm, GRAB_AGGRESSIVE)

	// Handle running penalty
	if(btm.mobility_flags & MOBILITY_STAND && btm.m_intent == MOVE_INTENT_RUN)
		btm.Knockdown(10)
		btm.Stun(30)
		btm.emote("groan", forced = TRUE)
		return

	// Regular movement penalties
	if(!btm.IsStun())
		if(prob(10))
			btm.emote("groan")
			//! TODO: replace this with a sginal I'mtired boss
			var/datum/component/arousal/btm_arousal = btm.GetComponent(/datum/component/arousal)
			btm_arousal?.try_do_pain_effect(PAIN_MED_EFFECT, FALSE)
			btm.Stun(15)
		else if(prob(4))
			btm.emote("painmoan")

	addtimer(CALLBACK(src, PROC_REF(knot_movement_btm_after)), 0.1 SECONDS)

/datum/component/knotting/proc/knot_movement_btm_after()
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient
	if(!ishuman(btm) || QDELETED(btm) || !ishuman(top) || QDELETED(top))
		return
	btm.face_atom(top)

/datum/component/knotting/proc/knot_remove(forceful_removal = FALSE, notify = TRUE, keep_top_status = FALSE, keep_btm_status = FALSE)
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient

	if(ishuman(btm) && !QDELETED(btm) && ishuman(top) && !QDELETED(top))
		handle_knot_removal_effects(top, btm, forceful_removal, notify, keep_btm_status)

	knot_exit(keep_top_status, keep_btm_status)

/datum/component/knotting/proc/handle_knot_removal_effects(mob/living/carbon/human/top, mob/living/carbon/human/btm, forceful_removal, notify, keep_btm_status)
	if(forceful_removal)
		var/damage = 40
		var/list/arousal_data = list()
		SEND_SIGNAL(top, COMSIG_SEX_GET_AROUSAL, arousal_data)

		if(arousal_data["arousal"] > MAX_AROUSAL / 2)
			damage += 30
			btm.Knockdown(10)
			if(notify && !keep_btm_status && !btm.has_status_effect(/datum/status_effect/knot_gaped))
				btm.apply_status_effect(/datum/status_effect/knot_gaped)

		btm.apply_damage(damage, BRUTE, BODY_ZONE_CHEST)
		btm.Stun(80)
		playsound(btm, 'sound/misc/mat/pop.ogg', 100, TRUE, -2, ignore_walls = FALSE)
		playsound(top, 'sound/misc/mat/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE)
		btm.emote("paincrit", forced = TRUE)

		if(notify)
			top.visible_message(span_notice("[top] yanks their knot out of [btm]!"),
				span_notice("I yank my knot out from [btm]."))
			var/datum/component/arousal/btm_arousal = btm.GetComponent(/datum/component/arousal)
			btm_arousal?.try_do_pain_effect(PAIN_HIGH_EFFECT, FALSE)
	else if(notify)
		playsound(btm, 'sound/misc/mat/insert (1).ogg', 50, TRUE, -2, ignore_walls = FALSE)
		top.visible_message(span_notice("[top] slips their knot out of [btm]!"),
			span_notice("I slip my knot out from [btm]."))
		btm.emote("painmoan", forced = TRUE)
		var/datum/component/arousal/btm_arousal = btm.GetComponent(/datum/component/arousal)
		btm_arousal?.try_do_pain_effect(PAIN_MILD_EFFECT, FALSE)

	// Add aftermath effects
	var/turf/turf = get_turf(btm)
	new /obj/effect/decal/cleanable/coom(turf)

/datum/component/knotting/proc/knot_exit(keep_top_status = FALSE, keep_btm_status = FALSE)
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient

	if(istype(top))
		if(!keep_top_status)
			top.remove_status_effect(/datum/status_effect/knotted)
		UnregisterSignal(top, COMSIG_MOVABLE_MOVED)
		log_combat(top, top, "Stopped knot tugging")

	if(istype(btm))
		if(!keep_btm_status)
			btm.remove_status_effect(/datum/status_effect/knot_tied)
		UnregisterSignal(btm, COMSIG_MOVABLE_MOVED)
		log_combat(btm, btm, "Stopped knot tugging")

	knotted_owner = null
	knotted_recipient = null
	knotted_status = KNOTTED_NULL
	knot_count = 0
