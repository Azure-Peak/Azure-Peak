/datum/round_event_control/antagonist/solo
	typepath = /datum/round_event/antagonist/solo
	/// How many baseline antags do we spawn
	var/base_antags = 1
	/// How many slots each scaling step adds once this antag is eligible.
	var/antag_scaling = 1
	/// How many maximum antags can we spawn
	var/maximum_antags = 3
	/// For this many players we'll add 1 up to the maximum antag amount
	var/denominator = 20
	/// The antag flag to be used
	var/antag_flag
	/// The antag datum to be applied
	var/antag_datum
	/// Prompt players for consent to turn them into antags before doing so. Dont allow this for roundstart.
	var/prompted_picking = FALSE
	/// A list of extra events to force whenever this one is chosen by the storyteller.
	/// Can either be normal list or a weighted list.
	var/list/extra_spawned_events
	/// Similar to extra_spawned_events however these are only used by roundstart events and will only try and run if we have the points to do so
	var/list/preferred_events

/datum/round_event_control/antagonist/solo/from_ghosts/get_candidates()
	var/round_started = SSticker.HasRoundStarted()
	var/midround_antag_pref_arg = round_started ? FALSE : TRUE

	var/list/candidates = SSgamemode.get_candidates(antag_flag, antag_flag, observers = TRUE, midround_antag_pref = midround_antag_pref_arg, restricted_roles = restricted_roles)
	candidates = trim_candidates(candidates)
	return candidates

/datum/round_event_control/antagonist/solo/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return
	var/antag_amt = get_antag_amount()
	if(antag_amt < 1)
		return FALSE
	var/list/candidates = get_candidates()
	if(length(candidates) < antag_amt && !open_slots(players_amt))
		return FALSE

/datum/round_event_control/antagonist/solo/proc/open_slots(player_count = null)
	return SSgamemode.story_antag_open_slots(antag_datum, player_count)

/datum/round_event_control/antagonist/solo/proc/get_base_antag_amount(player_count = null)
	if(isnull(player_count))
		player_count = SSgamemode.get_correct_popcount()
	var/base_amount = min(base_antags + FLOOR(player_count / denominator, 1), maximum_antags)
	if(antag_scaling <= 1 || base_amount <= 0)
		return base_amount
	return min(maximum_antags, antag_scaling + max(0, base_amount - 1) * antag_scaling)

/datum/round_event_control/antagonist/solo/proc/get_antag_amount()
	var/people = SSgamemode.get_correct_popcount()
	var/amount = get_base_antag_amount(people)
	amount = SSgamemode.story_antag_slots(amount, antag_datum, people)
	return guaranteed_villain_cap(amount, people)

/datum/round_event_control/antagonist/solo/proc/guaranteed_villain_cap(amount, player_count = null)
	if(amount <= 0)
		return 0
	if(open_slots(player_count))
		return amount
	if(!(roundstart && (storyteller_antag_flags & STORYTELLER_ANTAG_VILLAIN)))
		return amount
	if(!SSgamemode.storyteller_guarantees_antag(storyteller_guarantee_flags, roundstart = TRUE))
		return amount
	var/candidate_count = length(get_candidates())
	if(candidate_count <= 0)
		return 0
	return min(amount, candidate_count)

/datum/round_event_control/antagonist/solo/proc/get_candidates()
	var/round_started = SSticker.HasRoundStarted()
	var/new_players_arg = round_started ? FALSE : TRUE
	var/living_players_arg = round_started ? TRUE : FALSE
	var/midround_antag_pref_arg = round_started ? FALSE : TRUE

	var/list/candidates = SSgamemode.get_candidates(antag_flag, antag_flag, FALSE, new_players_arg, living_players_arg, midround_antag_pref = midround_antag_pref_arg, \
													restricted_roles = restricted_roles, required_roles = exclusive_roles)
	candidates = trim_candidates(candidates)
	return candidates


/datum/round_event_control/antagonist/solo/return_failure_string(players_amt)
	. =..()

	var/antag_amt = get_antag_amount()
	var/list/candidates = get_candidates() //we should optimize this
	if(length(candidates) < antag_amt && !open_slots(players_amt))
		if(.)
			. += ", "
		. += "Not Enough Candidates!"

	return .


/datum/round_event/antagonist/solo
	// ALL of those variables are internal. Check the control event to change them
	/// The antag flag passed from control
	var/antag_flag
	/// The antag datum passed from control
	var/antag_datum
	/// The antag count passed from control
	var/antag_count
	/// The restricted roles (jobs) passed from control
	var/list/restricted_roles
	/// The minds we've setup in setup() and need to finalize in start()
	var/list/setup_minds = list()
	/// Whether we prompt the players before picking them.
	var/prompted_picking = FALSE //TODO: Implement this
	/// DO NOT SET THIS MANUALLY, THIS IS INHERITED FROM THE EVENT CONTROLLER ON NEW
	var/list/extra_spawned_events
	// Same as above
	var/list/preferred_events

/datum/round_event/antagonist/solo/New(my_processing, datum/round_event_control/event_controller)
	. = ..()
	if(istype(event_controller, /datum/round_event_control/antagonist/solo))
		var/datum/round_event_control/antagonist/solo/antag_event_controller = event_controller
		if(antag_event_controller)
			if(antag_event_controller.extra_spawned_events)
				extra_spawned_events = fill_with_ones(antag_event_controller.extra_spawned_events)
			if(antag_event_controller.preferred_events)
				preferred_events = fill_with_ones(antag_event_controller.preferred_events)

/datum/round_event/antagonist/solo/setup()
	var/datum/round_event_control/antagonist/solo/cast_control = control
	var/player_count = SSgamemode.get_correct_popcount()
	var/base_antag_count = cast_control.get_base_antag_amount(player_count)
	antag_count = cast_control.get_antag_amount()
	if(cast_control == SSgamemode.current_roundstart_event && (cast_control.storyteller_antag_flags & STORYTELLER_ANTAG_VILLAIN) && antag_count < 1)
		var/min_players = SSgamemode.story_antag_min_players(cast_control.antag_datum)
		SSgamemode.log_roundstart_antag_failure(cast_control, "insufficient population opened 0 slots[min_players > 0 ? " (minimum [min_players] players required)" : ""]", player_count)
	message_admins("STORYTELLER:[cast_control.name] spawning [antag_count].")
	SSgamemode.log_antag_slot_choice(cast_control.name, antag_count, player_count)
	SSgamemode.log_antag_slot_scaling(cast_control.name, base_antag_count, antag_count, player_count, "roundstart event")
	antag_flag = cast_control.antag_flag
	antag_datum = cast_control.antag_datum
	restricted_roles = cast_control.restricted_roles
	prompted_picking = cast_control.prompted_picking
	var/list/possible_candidates = cast_control.get_candidates()
	var/list/candidates = list()
	if(cast_control == SSgamemode.current_roundstart_event && length(SSgamemode.roundstart_antag_minds))
		log_storyteller("Running roundstart antagonist assignment, event: [src], roundstart_antag_minds: [english_list(SSgamemode.roundstart_antag_minds)]")
		for(var/datum/mind/antag_mind in SSgamemode.roundstart_antag_minds)
			if(!antag_mind.current)
				log_storyteller("Roundstart antagonist setup error: antag_mind([antag_mind]) in roundstart_antag_minds without a set mob")
				continue
			candidates += antag_mind.current
			SSgamemode.roundstart_antag_minds -= antag_mind
			log_storyteller("Roundstart antag_mind, [antag_mind]")

	//guh
	var/list/cliented_list = list()
	for(var/mob/living/mob as anything in possible_candidates)
		cliented_list += mob.client

	while(length(possible_candidates) && length(candidates) < antag_count) //both of these pick_n_take from weighted_candidates so this should be fine
		var/mob/picked_ckey = pick_n_take(possible_candidates)
		var/client/picked_client = picked_ckey.client
		if(QDELETED(picked_client))
			continue
		var/mob/picked_mob = picked_client.mob
		picked_mob?.mind?.picking = TRUE
		log_storyteller("Picked antag event mob: [picked_mob], special role: [picked_mob.mind?.special_role ? picked_mob.mind.special_role : "none"]")
		candidates |= picked_mob

	if(cast_control == SSgamemode.current_roundstart_event && (cast_control.storyteller_antag_flags & STORYTELLER_ANTAG_VILLAIN) && antag_count > 0 && !length(candidates) && !cast_control.open_slots(player_count))
		SSgamemode.log_roundstart_antag_failure(cast_control, "no ready candidates were available for [antag_count] slot(s)", player_count)

	var/list/picked_mobs = list()
	for(var/i in 1 to antag_count)
		if(!length(candidates))
			message_admins("A roleset event got fewer antags then its antag_count and may not function correctly.")
			break

		var/mob/candidate = pick_n_take(candidates)
		log_storyteller("Antag event spawned mob: [candidate], special role: [candidate.mind?.special_role ? candidate.mind.special_role : "none"]")

		if(!candidate.mind)
			candidate.mind = new /datum/mind(candidate.key)

		setup_minds += candidate.mind
		candidate.mind.special_role = antag_flag
		candidate.mind.restricted_roles = restricted_roles
		picked_mobs += WEAKREF(candidate.client)

	setup = TRUE
	if(LAZYLEN(extra_spawned_events))
		var/event_type = pickweight(extra_spawned_events)
		if(!event_type)
			return
		var/datum/round_event_control/triggered_event = locate(event_type) in SSgamemode.control
		//wait a second to avoid any potential omnitraitor bs
		addtimer(CALLBACK(triggered_event, TYPE_PROC_REF(/datum/round_event_control, runEvent), FALSE), 1 SECONDS)

/datum/round_event/antagonist/solo/start()
	for(var/datum/mind/antag_mind as anything in setup_minds)
		add_datum_to_mind(antag_mind, antag_mind.current)

/datum/round_event/antagonist/solo/proc/add_datum_to_mind(datum/mind/antag_mind)
	antag_mind.add_antag_datum(antag_datum)

/datum/round_event/antagonist/solo/proc/spawn_extra_events()
	if(!LAZYLEN(extra_spawned_events))
		return
	var/datum/round_event_control/event = pickweight(extra_spawned_events)
	event?.runEvent(random = FALSE)

/datum/round_event/antagonist/solo/proc/create_human_mob_copy(turf/create_at, mob/living/carbon/human/old_mob, qdel_old_mob = TRUE)
	if(!old_mob?.client)
		return

	var/mob/living/carbon/human/new_character = new(create_at)
	if(!create_at)
		SSjob.SendToLateJoin(new_character)

	old_mob.client.prefs.copy_to(new_character)
	new_character.dna.update_dna_identity()
	old_mob.mind.transfer_to(new_character)
	if(qdel_old_mob)
		qdel(old_mob)
	return new_character

/datum/round_event/antagonist/solo/ghost/start()
	for(var/datum/mind/antag_mind as anything in setup_minds)
		add_datum_to_mind(antag_mind)

/datum/round_event/antagonist/solo/ghost/setup()
	var/datum/round_event_control/antagonist/solo/cast_control = control
	antag_count = cast_control.get_antag_amount()
	antag_flag = cast_control.antag_flag
	antag_datum = cast_control.antag_datum
	restricted_roles = cast_control.restricted_roles
	prompted_picking = cast_control.prompted_picking
	var/list/candidates = cast_control.get_candidates()

	//guh
	var/list/cliented_list = list()
	for(var/mob/living/mob as anything in candidates)
		cliented_list += mob.client

	/*
	if(prompted_picking)
		candidates = SSpolling.poll_candidates(
			question = "Would you like to be a [cast_control.name]?",
			check_jobban = antag_flag,
			role = antag_flag,
			poll_time = 20 SECONDS,
			group = candidates,
			alert_pic = antag_datum,
			role_name_text = lowertext(cast_control.name),
			chat_text_border_icon = antag_datum,
		)
	*/

	var/selected_count = 0
	while(length(candidates) && selected_count < antag_count)
		var/mob/candidate_ckey = pick_n_take(candidates)
		var/client/candidate_client = candidate_ckey.client
		if(QDELETED(candidate_client) || QDELETED(candidate_client.mob))
			continue
		var/mob/candidate = candidate_client.mob

		if(!candidate.mind)
			candidate.mind = new /datum/mind(candidate.key)
		var/mob/living/carbon/human/new_human = make_body(candidate)
		new_human.mind.special_role = antag_flag
		new_human.mind.restricted_roles = restricted_roles
		setup_minds += new_human.mind
		selected_count++
	setup = TRUE


///Uses stripped down and bastardized code from respawn character
/proc/make_body(mob/dead/observer/ghost_player)
	if(!ghost_player || !ghost_player.key)
		return

	//First we spawn a dude.
	var/mob/living/carbon/human/new_character = new//The mob being spawned.
	SSjob.SendToLateJoin(new_character)

	ghost_player.client.prefs.copy_to(new_character)
	new_character.dna.update_dna_identity()
	new_character.key = ghost_player.key

	return new_character
