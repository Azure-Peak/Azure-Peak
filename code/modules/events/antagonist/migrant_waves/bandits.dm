/datum/round_event_control/antagonist/migrant_wave/bandits
	name = "Bandit Migration"
	typepath = /datum/round_event/migrant_wave/bandits
	wave_type = /datum/migrant_wave/bandit
	max_occurrences = 2

	weight = 18

	earliest_start = 0 SECONDS

	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
	)

/datum/round_event/migrant_wave/bandits/start()
	var/datum/job/bandit_job = SSjob.GetJob("Bandit")
	bandit_job.total_positions = min(bandit_job.total_positions + 5, 10)
	bandit_job.spawn_positions = min(bandit_job.spawn_positions + 5, 10)
	if(bandit_job.total_positions < 4) // Not at max capacity, increasing goal.
		SSmapping.retainer.bandit_goal += 1 * rand(200, 400)
		SSrole_class_handler.bandits_in_round = TRUE
		for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
			if(!player.client)
				continue

			to_chat(player, span_danger("Matthios, is this true? Bandits flock to Azuria. Three bandit slots have been opened."))
