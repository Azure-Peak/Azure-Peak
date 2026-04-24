SUBSYSTEM_DEF(city_assembly)
	name = "City Assembly"
	// Wakes up only until the first-session timer is armed post-round-start; see fire().
	wait = 10 SECONDS
	var/datum/assembly_session/current_session
	var/datum/assembly_warrant/current_warrant
	/// The sitting Alderman is the MOB, not the ckey. A body swap or re-spawn is a new person
	/// politically; the seat doesn't follow the player to a new body. Mob death triggers the
	/// "seat vacated" notification via death.dm / Destroy hooks.
	var/datum/weakref/alderman_ref
	var/list/censured_refs = list()
	var/list/history = list()
	var/session_counter = 0
	/// Cached preview_tallies() output; null when dirty. Invalidated by writes.
	var/list/cached_tallies = null
	/// Set TRUE once the first-session kickoff timer is armed. Prevents double-arming.
	var/first_session_armed = FALSE
	/// world.time at which Session 1 will resolve automatically. 0 if not yet armed.
	var/first_session_resolve_at = 0

/datum/controller/subsystem/city_assembly/Initialize()
	current_warrant = new /datum/assembly_warrant()
	open_session()
	// Don't schedule timers here - Initialize predates round-start. fire() arms the first-
	// session timer the moment it observes GAME_STATE_PLAYING, anchoring to the real start.
	// Subsequent sessions resolve on the day-tick (on_day_tick proc from time.dm).
	return ..()

/datum/controller/subsystem/city_assembly/fire(resumed = FALSE)
	if(first_session_armed)
		can_fire = FALSE
		return
	if(!SSticker || SSticker.current_state != GAME_STATE_PLAYING)
		return
	first_session_armed = TRUE
	first_session_resolve_at = world.time + (ASSEMBLY_FIRST_SESSION_MINUTES MINUTES)
	addtimer(CALLBACK(src, PROC_REF(resolve_session), "first_session", null, FALSE), ASSEMBLY_FIRST_SESSION_MINUTES MINUTES, TIMER_STOPPABLE)
	can_fire = FALSE

/datum/controller/subsystem/city_assembly/proc/open_session()
	session_counter++
	current_session = new(session_counter)
	var/mob/alderman = resolve_get_alderman()
	if(alderman && can_hold_office(alderman))
		current_session.candidates[WEAKREF(alderman)] = list(
			"name" = alderman.real_name || "(incumbent)",
			"job" = alderman.job || "no station",
			"pledge" = "(the sitting Alderman, automatically listed)",
		)
	invalidate_tallies()

/datum/controller/subsystem/city_assembly/proc/invalidate_tallies()
	cached_tallies = null

/datum/controller/subsystem/city_assembly/proc/on_day_tick()
	// Don't convene during round init. settod() can flip GLOB.tod to "dawn" as SSnightshift
	// initializes, which would fire a zero-voter session before the round is even open.
	if(!SSticker || SSticker.current_state != GAME_STATE_PLAYING)
		return
	resolve_session("day_tick")

/datum/controller/subsystem/city_assembly/proc/resolve_session(source = "unknown", flavor_prefix = null, skip_quorum = FALSE)
	if(!current_session)
		open_session()
	var/datum/assembly_session/S = current_session
	S.state = ASSEMBLY_SESSION_RESOLVED
	var/voter_count = S.count_distinct_voters()
	var/quorate = skip_quorum || (voter_count >= ASSEMBLY_QUORUM_VOTERS)
	var/list/summary = list(
		"session" = S.number,
		"source" = source,
		"day" = GLOB.dayspassed,
		"voter_count" = voter_count,
		"quorate" = quorate,
		"quorum_skipped" = skip_quorum ? TRUE : FALSE,
		"flavor_prefix" = flavor_prefix,
		"results" = list(),
	)

	if(!quorate)
		log_game("CITY ASSEMBLY: session [S.number] below quorum ([voter_count]/[ASSEMBLY_QUORUM_VOTERS]). Status quo retained.")
		summary["rendered_text"] = build_summary_text(summary)
		history += list(summary)
		refresh_warrant()
		open_session()
		return

	var/list/election_result = resolve_election(S)
	summary["results"]["election"] = election_result

	var/list/trade_result = resolve_bracket_motion(S, ASSEMBLY_MOTION_TRADE_AUTH, ASSEMBLY_TRADE_BRACKETS)
	summary["results"]["trade_auth"] = trade_result
	apply_trade_authorization(trade_result)

	var/list/defense_result = resolve_bracket_motion(S, ASSEMBLY_MOTION_DEFENSE_AUTH, ASSEMBLY_DEFENSE_BRACKETS)
	summary["results"]["defense_auth"] = defense_result
	apply_defense_authorization(defense_result)

	// Poll tax disabled pending anti-dodge design (see docs/design/estates_general_stage1.md).
	// var/list/poll_result = resolve_bracket_motion(S, ASSEMBLY_MOTION_POLL_TAX, ASSEMBLY_POLL_BRACKETS)
	// summary["results"]["poll_tax"] = poll_result
	// apply_poll_tax(poll_result)

	if(resolve_get_alderman())
		var/list/recall_result = resolve_yae_motion(S, ASSEMBLY_MOTION_RECALL, ASSEMBLY_RECALL_THRESHOLD_PCT)
		summary["results"]["recall"] = recall_result
		if(recall_result["passed"])
			demote_alderman("recalled by the Assembly")

		var/list/censure_result = resolve_yae_motion(S, ASSEMBLY_MOTION_CENSURE, ASSEMBLY_CENSURE_THRESHOLD_PCT)
		summary["results"]["censure"] = censure_result
		if(censure_result["passed"])
			var/mob/target = resolve_get_alderman()
			if(target)
				apply_censure(target)
				demote_alderman("censured by the Assembly")

	summary["rendered_text"] = build_summary_text(summary)
	history += list(summary)
	announce_session_summary(summary)
	refresh_warrant()
	open_session()

/datum/controller/subsystem/city_assembly/proc/resolve_get_alderman()
	var/mob/M = alderman_ref?.resolve()
	if(!M || QDELETED(M))
		alderman_ref = null
		return null
	return M

/datum/controller/subsystem/city_assembly/proc/can_vote(mob/user)
	// Intentionally narrow: only TRAIT_OUTLAW disqualifies. Not the client (AFK/disconnected is
	// fine - the TGUI can't act anyway), not the stat (voters don't have a coroner's certificate
	// - if the elected mob was dead, that's the dead man's problem for not saying so), not human
	// type (dormant for future non-human civic members). Keeps the gate simple and permissive.
	if(!user)
		return FALSE
	if(HAS_TRAIT(user, TRAIT_OUTLAW))
		return FALSE
	return TRUE

/datum/controller/subsystem/city_assembly/proc/can_hold_office(mob/user)
	if(!can_vote(user))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_ALDERMAN_CENSURED))
		return FALSE
	return TRUE

/datum/controller/subsystem/city_assembly/proc/get_vote_weight(mob/living/carbon/human/user)
	if(!can_vote(user))
		return ASSEMBLY_WEIGHT_NONE
	var/base = assembly_job_weight(user.job)
	// Residency/citizenry uplifts transients and peasantry to full burgher weight.
	if(base > ASSEMBLY_WEIGHT_NONE && base < ASSEMBLY_WEIGHT_2 && HAS_TRAIT(user, TRAIT_RESIDENT))
		return ASSEMBLY_WEIGHT_2
	return base

/datum/controller/subsystem/city_assembly/proc/cast_vote(mob/user, motion_id, choice)
	if(!can_vote(user))
		return FALSE
	if(!current_session)
		return FALSE
	if(!(motion_id in current_session.ballots))
		return FALSE
	if(!validate_choice(motion_id, choice))
		return FALSE
	var/w = get_vote_weight(user)
	if(w <= 0)
		return FALSE
	// Capture weight at cast time so tally passes never re-resolve weakrefs or recompute weight.
	current_session.ballots[motion_id][WEAKREF(user)] = list(
		"choice" = choice,
		"weight" = w,
	)
	invalidate_tallies()
	return TRUE

/// Per-motion choice whitelist. Prevents ballot pollution from malformed ui_act payloads. Each
/// motion type has a fixed choice set:
///   - Election: candidate weakref strings (must match a declared candidate) or NO_ALDERMAN.
///   - Bracket motions: stringified numbers from that motion's bracket list, NAE, or ABSTAIN.
///   - Yae/Nay motions: YAE, NAY, or ABSTAIN.
/datum/controller/subsystem/city_assembly/proc/validate_choice(motion_id, choice)
	if(isnull(choice))
		return FALSE
	if(!istext(choice))
		return FALSE
	switch(motion_id)
		if(ASSEMBLY_MOTION_ELECTION)
			if(choice == "NO_ALDERMAN")
				return TRUE
			for(var/datum/weakref/wr in current_session.candidates)
				if("[wr]" == choice)
					return TRUE
			return FALSE
		if(ASSEMBLY_MOTION_TRADE_AUTH)
			return validate_bracket_choice(choice, ASSEMBLY_TRADE_BRACKETS)
		if(ASSEMBLY_MOTION_DEFENSE_AUTH)
			return validate_bracket_choice(choice, ASSEMBLY_DEFENSE_BRACKETS)
		if(ASSEMBLY_MOTION_POLL_TAX)
			return validate_bracket_choice(choice, ASSEMBLY_POLL_BRACKETS)
		if(ASSEMBLY_MOTION_RECALL, ASSEMBLY_MOTION_CENSURE)
			return (choice == ASSEMBLY_YAE || choice == ASSEMBLY_NAY || choice == ASSEMBLY_ABS)
	return FALSE

/datum/controller/subsystem/city_assembly/proc/validate_bracket_choice(choice, list/brackets)
	if(choice == ASSEMBLY_BRACKET_NAE || choice == ASSEMBLY_BRACKET_ABSTAIN)
		return TRUE
	var/as_num = text2num(choice)
	if(isnull(as_num))
		return FALSE
	return (as_num in brackets)

/datum/controller/subsystem/city_assembly/proc/retract_vote(mob/user, motion_id)
	if(!current_session)
		return FALSE
	var/datum/weakref/wr = WEAKREF(user)
	if(current_session.ballots[motion_id])
		current_session.ballots[motion_id] -= wr
	invalidate_tallies()
	return TRUE

/datum/controller/subsystem/city_assembly/proc/declare_candidacy(mob/user, pledge_text)
	if(!can_hold_office(user))
		return FALSE
	if(!current_session)
		return FALSE
	current_session.candidates[WEAKREF(user)] = list(
		"name" = user.real_name || "(unknown)",
		"job" = user.job || "no station",
		"pledge" = copytext(pledge_text || "", 1, 301),
	)
	invalidate_tallies()
	return TRUE

/datum/controller/subsystem/city_assembly/proc/withdraw_candidacy(mob/user)
	if(!current_session)
		return FALSE
	current_session.candidates -= WEAKREF(user)
	invalidate_tallies()
	return TRUE

/datum/controller/subsystem/city_assembly/proc/promote_to_alderman(mob/user)
	if(!can_hold_office(user))
		return FALSE
	var/mob/current = resolve_get_alderman()
	if(current == user)
		return TRUE
	if(current)
		REMOVE_TRAIT(current, TRAIT_ALDERMAN, "assembly")
	alderman_ref = WEAKREF(user)
	ADD_TRAIT(user, TRAIT_ALDERMAN, "assembly")
	log_game("CITY ASSEMBLY: [key_name(user)] promoted to Alderman.")
	invalidate_tallies()
	return TRUE

/datum/controller/subsystem/city_assembly/proc/demote_alderman(reason = "vacated")
	var/mob/current = resolve_get_alderman()
	if(!current)
		alderman_ref = null
		return
	REMOVE_TRAIT(current, TRAIT_ALDERMAN, "assembly")
	log_game("CITY ASSEMBLY: Alderman [key_name(current)] removed ([reason]).")
	alderman_ref = null
	current_warrant?.reset()
	invalidate_tallies()

/datum/controller/subsystem/city_assembly/proc/apply_censure(mob/target)
	if(!target)
		return
	ADD_TRAIT(target, TRAIT_ALDERMAN_CENSURED, "assembly")
	var/datum/weakref/wr = WEAKREF(target)
	if(!(wr in censured_refs))
		censured_refs += wr
	log_game("CITY ASSEMBLY: [key_name(target)] censured, barred from office.")

/datum/controller/subsystem/city_assembly/proc/notify_alderman_lost_ref(departing_name = null, departing_job = null, reason = null)
	var/mob/current = resolve_get_alderman()
	if(current)
		return
	if(current_warrant)
		current_warrant.reset()
	var/who = null
	if(departing_name)
		who = departing_job ? "[departing_name], the [departing_job]" : departing_name
	var/reason_tag = null
	switch(reason)
		if("resigned")     reason_tag = "has resigned the seat"
		if("died")         reason_tag = "has died in office"
		if("disconnected") reason_tag = "has left the Realm"
		if("admin")        reason_tag = "has been removed by admin fiat"
		if("recalled")     reason_tag = "has been recalled by the Assembly"
		if("censured")     reason_tag = "has been censured by the Assembly"
	var/prefix
	if(who && reason_tag)
		prefix = "[who] [reason_tag]. "
	else if(who)
		prefix = "[who] has left the seat. "
	else
		prefix = ""
	priority_announce(
		"[prefix]The Alderman's seat has been vacated - the citizenry must choose anew at the next session.",
		ASSEMBLY_ANNOUNCE_TITLE,
		'sound/misc/royal_decree.ogg',
		"Town Crier",
	)

/datum/controller/subsystem/city_assembly/proc/refresh_warrant()
	if(!current_warrant)
		current_warrant = new /datum/assembly_warrant()
	var/mob/alderman = resolve_get_alderman()
	if(!alderman)
		current_warrant.reset()
		return
	current_warrant.refresh_for_day()

/datum/controller/subsystem/city_assembly/proc/can_consume_trade(amount)
	var/mob/alderman = resolve_get_alderman()
	if(!alderman || !current_warrant)
		return FALSE
	return current_warrant.trade_remaining >= amount

/datum/controller/subsystem/city_assembly/proc/consume_trade(amount, mob/actor, reason = "")
	if(!can_consume_trade(amount))
		return FALSE
	current_warrant.trade_remaining -= amount
	log_game("CITY ASSEMBLY WARRANT: trade -[amount]m by [key_name(actor)] ([reason]). Remaining: [current_warrant.trade_remaining]m.")
	return TRUE

/datum/controller/subsystem/city_assembly/proc/can_consume_defense(amount)
	var/mob/alderman = resolve_get_alderman()
	if(!alderman || !current_warrant)
		return FALSE
	return current_warrant.defense_remaining >= amount

/datum/controller/subsystem/city_assembly/proc/consume_defense(amount, mob/actor, reason = "")
	if(!can_consume_defense(amount))
		return FALSE
	current_warrant.defense_remaining -= amount
	log_game("CITY ASSEMBLY WARRANT: defense -[amount]p by [key_name(actor)] ([reason]). Remaining: [current_warrant.defense_remaining]p.")
	return TRUE

/datum/controller/subsystem/city_assembly/proc/is_alderman(mob/user)
	var/mob/current = resolve_get_alderman()
	return current && current == user

/datum/controller/subsystem/city_assembly/proc/announce_session_summary(list/summary)
	var/body = summary["rendered_text"] || build_summary_text(summary)
	priority_announce(
		body,
		ASSEMBLY_ANNOUNCE_TITLE,
		'sound/misc/royal_decree.ogg',
		"Town Crier",
		strip_html = FALSE,
	)
