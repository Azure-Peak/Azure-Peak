/datum/round_event_control/antagonist/migrant_wave/assassins
	name = "Assassin Migration"
	typepath = /datum/round_event/migrant_wave/assassins
	wave_type = /datum/migrant_wave/assassin
	max_occurrences = 2

	weight = 10

	earliest_start = 0 SECONDS

	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
	)

/datum/round_event/migrant_wave/assassins/start()
	var/datum/job/assassin_job = SSjob.GetJob("Assassin")
	assassin_job.total_positions = min(assassin_job.total_positions + 1, 2)
	assassin_job.spawn_positions = min(assassin_job.spawn_positions + 1, 2)
	if(assassin_job.total_positions < 2) // Not at max capacity, increasing goal.
		SSrole_class_handler.assassins_in_round = TRUE
		for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
			if(!player.client)
				continue

			to_chat(player, span_danger("Graggar demands blood, assassins flock to Azuria. An assassin slot has been opened."))
