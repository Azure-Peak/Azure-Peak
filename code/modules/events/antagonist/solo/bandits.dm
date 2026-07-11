/datum/round_event_control/antagonist/solo/bandits
	name = "Bandits"
	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
		TAG_LOOT
	)
	roundstart = TRUE
	antag_flag = ROLE_BANDIT
	shared_occurence_type = SHARED_MINOR_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	storyteller_rumour_name = "bandits"

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES
	base_antags = 5
	maximum_antags = 10

	earliest_start = 0 SECONDS

	weight = 10

	typepath = /datum/round_event/antagonist/solo/bandits
	antag_datum = /datum/antagonist/bandit

/datum/round_event/antagonist/solo/bandits
	var/leader = FALSE

/datum/round_event_control/antagonist/solo/bandits/preRunEvent()
	if(is_storyteller_villain_blocked())
		return EVENT_CANT_RUN
	return ..()

/datum/round_event_control/antagonist/solo/bandits/get_antag_amount()
	var/admin_slot = SSgamemode.get_admin_slot(antag_datum, storyteller_slot_key)
	if(!isnull(admin_slot))
		return max(0, admin_slot)
	return SSgamemode.story_antag_slot_cap(antag_datum, roundstart = roundstart)

/datum/round_event/antagonist/solo/bandits/start()
	var/datum/job/bandit_job = SSjob.GetJob("Bandit")
	var/datum/round_event_control/antagonist/solo/cast_control = control
	var/max_slots = max(length(setup_minds), cast_control.get_antag_amount())
	bandit_job.total_positions = max_slots
	bandit_job.spawn_positions = max_slots
	SSmapping.retainer.bandit_goal = rand(200,400) + (length(setup_minds) * rand(200,400))
	for(var/datum/mind/antag_mind as anything in setup_minds)
		var/mob/living/carbon/human/H = antag_mind.current
		if(!H)
			continue
		var/datum/job/J = SSjob.GetJob(H.job)
		J?.current_positions = max(J?.current_positions-1, 0)

		if(H.client)
			var/datum/class_select_handler/stale = SSrole_class_handler.class_select_handlers[H.client.ckey]
			if(stale)
				SSrole_class_handler.class_select_handlers.Remove(H.client.ckey)
				qdel(stale)

		SSjob.AssignRole(H, "Bandit")
		H.job = "Bandit"
		SSmapping.retainer.bandits |= H
		antag_mind.add_antag_datum(/datum/antagonist/bandit)

		var/datum/antagonist/bandit/bandit_datum = antag_mind.has_antag_datum(/datum/antagonist/bandit)
		bandit_datum?.move_to_spawnpoint()
		H.unequip_everything()

		SSrole_class_handler.setup_class_handler(H, list(CTAG_BANDIT = 20))
		H.advsetup = TRUE
		H.hud_used?.set_advclass()

	SSrole_class_handler.bandits_in_round = TRUE

/datum/round_event_control/antagonist/solo/bandits/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return
	var/list/candidates = get_candidates()

	if(length(candidates) < 1)
		return FALSE

	return TRUE
