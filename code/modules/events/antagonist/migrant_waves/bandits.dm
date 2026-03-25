/datum/round_event_control/antagonist/migrant_wave/banditsorgnolls
	name = "Bandits or Gnolls Migration"
	typepath = /datum/round_event/migrant_wave/banditsorgnolls
	wave_type = /datum/migrant_wave/bandit
	max_occurrences = 2

	weight = 18

	earliest_start = 30 MINUTES
	min_players = 30

	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
	)

/datum/round_event_control/antagonist/migrant_wave/banditsorgnolls/preRunEvent()
	if(is_storyteller_soft_antag_blocked())
		return EVENT_CANT_RUN
	return ..()

/datum/round_event/migrant_wave/banditsorgnolls/start()
	var/evilmode = is_storyteller_villain_blocked() ? "gnolls" : pick("gnolls", "bandits")
	if(evilmode == "bandits")
		var/datum/job/bandit_job = SSjob.GetJob("Bandit")
		bandit_job.total_positions = min(bandit_job.total_positions + 4, 10)
		bandit_job.spawn_positions = min(bandit_job.spawn_positions + 4, 10)
		if(bandit_job.total_positions < 10) // Not at max capacity, increasing goal.
			SSmapping.retainer.bandit_goal += 1 * rand(200, 400)
			SSrole_class_handler.bandits_in_round = TRUE
			for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
				if(!player.client)
					continue
				to_chat(player, span_danger("Matthios, is this true? Bandits flock to Azuria. four bandit slots have been opened."))
	if(evilmode == "gnolls")
		var/datum/job/gnoll_job = SSjob.GetJob("Gnoll")
		gnoll_job.total_positions = min(gnoll_job.total_positions + 2, 4)
		gnoll_job.spawn_positions = min(gnoll_job.spawn_positions + 2, 4)
		if(gnoll_job.total_positions < 10) // Not at max capacity, increasing goal.
			SSrole_class_handler.assassins_in_round = TRUE
			for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
				if(!player.client)
					continue
				to_chat(player, span_danger("Graggar demands blood, gnolls flock to Azuria."))
