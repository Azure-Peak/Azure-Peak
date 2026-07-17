/datum/round_event_control/antagonist/solo/assassins
	name = "Assassins"
	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
		TAG_BLOOD
	)
	roundstart = TRUE
	antag_flag = ROLE_ASSASSIN
	shared_occurence_type = SHARED_MINOR_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_ROUNDSTART | STORYTELLER_ANTAG_SOFT

	restricted_roles = list(
		"Grand Duke",
		"Grand Duchess",
		"Consort",
		"Sergeant",
		"Men-at-arms",
		"Marshal",
		"Merchant",
		"Bishop",
		"Acolyte",
		"Martyr",
		"Templar",
		"Councillor",
		"Prince",
		"Princess",
		"Hand",
		"Steward",
		"Head Physician",
		"Captain",
		"Archivist",
		"Knight",
		"Court Magician",
		"Inquisitor",
		"Orthodoxist",
		"Absolver",
		"Warden",
		"Squire",
		"Veteran",
		"Apothecary"
	)

	base_antags = 1
	maximum_antags = 2

	earliest_start = 0 SECONDS
	max_occurrences = 2

	weight = 10

	typepath = /datum/round_event/antagonist/solo/assassins
	antag_datum = /datum/antagonist/assassin

/datum/round_event_control/antagonist/solo/assassins/canSpawnEvent(players_amt, gamemode, fake_check)
	if(!count_hunted_players())
		return FALSE
	return ..()

/datum/round_event_control/antagonist/solo/assassins/preRunEvent()
	if(is_storyteller_soft_antag_blocked())
		return EVENT_CANT_RUN
	return ..()

/datum/round_event/antagonist/solo/assassins/start()
	var/datum/job/assassin_job = SSjob.GetJob("Assassin")
	assassin_job.total_positions = length(setup_minds)
	assassin_job.spawn_positions = length(setup_minds)
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

		H.unequip_everything()
		SSjob.AssignRole(H, "Assassin")
		H.job = "Assassin"
		SSmapping.retainer.assassins |= H
		antag_mind.add_antag_datum(/datum/antagonist/assassin)

		SSrole_class_handler.setup_class_handler(H, list(CTAG_ASSASSIN = 20))
		H.advsetup = TRUE
		H.hud_used?.set_advclass()

	SSrole_class_handler.assassins_in_round = TRUE

/proc/count_hunted_players()
	var/count = 0
	for(var/mob/living/carbon/human/player as anything in GLOB.human_list)
		if(!player.mind || !player.client)
			continue
		if(player.has_flaw(/datum/charflaw/targeted))
			count++
	return count
