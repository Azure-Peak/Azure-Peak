/datum/round_event_control/antagonist/solo/rebel
	name = "Peasant Rebellion"
	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_PREBEL
	shared_occurence_type = SHARED_HIGH_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	storyteller_rumour_name = "rebels"

	base_antags = REBELLION_ROUNDSTART_TOTAL
	maximum_antags = REBELLION_ROUNDSTART_TOTAL

	max_occurrences = 1

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/rebel
	antag_datum = /datum/antagonist/prebel/head

	weight = 12

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES

/datum/round_event_control/antagonist/solo/rebel/New()
	..()
	restricted_roles |= GLOB.noble_positions
	restricted_roles |= GLOB.courtier_positions
	restricted_roles |= GLOB.retinue_positions
	restricted_roles |= GLOB.garrison_positions
	restricted_roles |= GLOB.church_positions
	restricted_roles |= GLOB.inquisition_positions
	restricted_roles |= GLOB.aspirant_eligible_positions
	restricted_roles |= "Mercenary"

/datum/round_event_control/antagonist/solo/rebel/proc/get_leader_candidates()
	var/round_started = SSticker.HasRoundStarted() || SSgamemode?.roundstart_live
	var/newplayers_arg = round_started ? FALSE : TRUE
	var/living_arg = round_started ? TRUE : FALSE
	var/midround_arg = round_started ? FALSE : TRUE

	var/list/candidates = SSgamemode.get_candidates(ROLE_REBEL_LEADER, antag_flag, FALSE, newplayers_arg, living_arg, midround_antag_pref = midround_arg, \
													restricted_roles = restricted_roles, required_roles = exclusive_roles)
	candidates = trim_candidates(candidates)
	for(var/mob/candidate in candidates)
		if(HAS_TRAIT(candidate, TRAIT_NOBLE))
			candidates -= candidate
	return candidates

/datum/round_event_control/antagonist/solo/rebel/proc/get_convert_candidates()
	var/round_started = SSticker.HasRoundStarted() || SSgamemode?.roundstart_live
	var/newplayers_arg = round_started ? FALSE : TRUE
	var/living_arg = round_started ? TRUE : FALSE
	var/midround_arg = round_started ? FALSE : TRUE

	var/list/candidates = SSgamemode.get_candidates(antag_flag, antag_flag, FALSE, newplayers_arg, living_arg, midround_antag_pref = midround_arg, \
													restricted_roles = restricted_roles, required_roles = exclusive_roles)
	candidates = trim_candidates(candidates)
	for(var/mob/candidate in candidates)
		if(HAS_TRAIT(candidate, TRAIT_NOBLE))
			candidates -= candidate
	return candidates

/datum/round_event_control/antagonist/solo/rebel/get_candidates()
	return get_leader_candidates() | get_convert_candidates()

/datum/round_event_control/antagonist/solo/rebel/preRunEvent()
	if(is_storyteller_villain_blocked())
		return EVENT_CANT_RUN
	return ..()

/datum/round_event_control/antagonist/solo/rebel/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return
	if(length(get_candidates()) < 2)
		return FALSE
	return TRUE

/datum/round_event/antagonist/solo/rebel
	var/list/leader_minds = list()
	var/datum/mind/field_promoted

/datum/round_event/antagonist/solo/rebel/setup()
	var/datum/round_event_control/antagonist/solo/rebel/cast_control = control
	var/requested_count = cast_control.get_antag_amount()
	antag_count = requested_count
	antag_flag = cast_control.antag_flag
	antag_datum = cast_control.antag_datum
	restricted_roles = cast_control.restricted_roles
	var/leader_cap = min(REBELLION_ROUNDSTART_LEADERS, antag_count)

	var/list/mob/picked = list()
	if(cast_control == SSgamemode.current_roundstart_event && length(SSgamemode.roundstart_antag_minds))
		log_storyteller("Running roundstart antagonist assignment, event: [src], roundstart_antag_minds: [english_list(SSgamemode.roundstart_antag_minds)]")
		for(var/datum/mind/antag_mind in SSgamemode.roundstart_antag_minds)
			if(!antag_mind.current)
				log_storyteller("Roundstart antagonist setup error: antag_mind([antag_mind]) in roundstart_antag_minds without a set mob")
				continue
			picked += antag_mind.current
			if(length(leader_minds) < leader_cap)
				leader_minds += antag_mind
			SSgamemode.roundstart_antag_minds -= antag_mind
			log_storyteller("Roundstart antag_mind, [antag_mind]")

	var/list/leader_candidates = cast_control.get_leader_candidates()
	while(length(leader_candidates) && length(leader_minds) < leader_cap)
		var/mob/picked_ckey = weighted_take(leader_candidates, GLOB.burgher_positions)
		var/client/picked_client = picked_ckey.client
		if(QDELETED(picked_client))
			continue
		var/mob/picked_mob = picked_client.mob
		if(!picked_mob?.mind || (picked_mob in picked))
			continue
		log_storyteller("Picked rebel leader mob: [picked_mob], special role: [picked_mob.mind?.special_role ? picked_mob.mind.special_role : "none"]")
		picked += picked_mob
		leader_minds += picked_mob.mind

	var/list/convert_candidates = cast_control.get_convert_candidates()
	while(length(convert_candidates) && length(picked) < antag_count)
		var/mob/picked_ckey = weighted_take(convert_candidates, GLOB.peasant_positions)
		var/client/picked_client = picked_ckey.client
		if(QDELETED(picked_client))
			continue
		var/mob/picked_mob = picked_client.mob
		if(!picked_mob?.mind || (picked_mob in picked))
			continue
		log_storyteller("Picked rebel convert mob: [picked_mob], special role: [picked_mob.mind?.special_role ? picked_mob.mind.special_role : "none"]")
		picked += picked_mob

	if(!length(picked))
		message_admins("STORYTELLER:[cast_control.name] failed to spawn because it had no valid candidates at setup.")
		log_storyteller("STORYTELLER:[cast_control.name] failed to spawn because it had no valid candidates at setup.")
		return

	// No one readied up to lead: one of the rebels takes matters into their own hands.
	if(!length(leader_minds))
		var/mob/promoted = pick(picked)
		field_promoted = promoted.mind
		leader_minds += promoted.mind
		message_admins("STORYTELLER:[cast_control.name] had no leader candidates; field-promoting [promoted] to rebellion leader.")
		log_storyteller("STORYTELLER:[cast_control.name] had no leader candidates; field-promoting [promoted] to rebellion leader.")

	antag_count = min(antag_count, length(picked))
	if(antag_count < requested_count)
		message_admins("STORYTELLER:[cast_control.name] partially filled from [requested_count] to [antag_count] due to limited valid candidates.")
		log_storyteller("STORYTELLER:[cast_control.name] partially filled from [requested_count] to [antag_count] due to limited valid candidates.")
	else
		message_admins("STORYTELLER:[cast_control.name] spawning [antag_count] ([length(leader_minds)] leaders).")

	for(var/mob/candidate as anything in picked)
		if(!candidate.mind)
			candidate.mind = new /datum/mind(candidate.key)
		candidate.mind.picking = TRUE
		setup_minds += candidate.mind
		candidate.mind.special_role = (candidate.mind in leader_minds) ? ROLE_REBEL_LEADER : ROLE_PREBEL
		candidate.mind.restricted_roles = restricted_roles

	setup = TRUE

/datum/round_event/antagonist/solo/rebel/proc/weighted_take(list/candidates, list/favored_jobs)
	if(!length(candidates))
		return null
	var/list/weighted = list()
	for(var/mob/candidate as anything in candidates)
		weighted[candidate] = (candidate.mind?.assigned_role in favored_jobs) ? REBELLION_CLASS_BIAS : 1
	var/mob/picked_mob = pickweight(weighted)
	candidates -= picked_mob
	return picked_mob

/datum/round_event/antagonist/solo/rebel/start()
	for(var/datum/mind/antag_mind as anything in setup_minds)
		if(!antag_mind.current)
			continue
		if(antag_mind in leader_minds)
			antag_mind.add_antag_datum(/datum/antagonist/prebel/head)
			if(antag_mind == field_promoted)
				to_chat(antag_mind.current, span_boldnotice("In the absence of a leader, I've decided to take matters into my own hands."))
		else
			antag_mind.add_antag_datum(/datum/antagonist/prebel)
