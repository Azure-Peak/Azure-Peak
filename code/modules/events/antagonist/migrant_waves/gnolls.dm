/datum/round_event_control/antagonist/migrant_wave/gnolls
	name = "Gnolls Migration"
	typepath = /datum/round_event/migrant_wave/gnolls
	wave_type = /datum/migrant_wave/gnolls
	max_occurrences = 2
	weight = 5
	earliest_start = 0 SECONDS
	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
	)

/datum/round_event/migrant_wave/gnolls/start()
	var/datum/job/gnoll_job = SSjob.GetJob("Gnoll")
	gnoll_job.total_positions = min(gnoll_job.total_positions + 2, 10)
	gnoll_job.spawn_positions = min(gnoll_job.spawn_positions + 2, 10)
	if(gnoll_job.total_positions < 10) // Not at max capacity, increasing goal.
		SSrole_class_handler.assassins_in_round = TRUE
		for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
			if(!player.client)
				continue

			to_chat(player, span_danger("Graggar demands blood, gnolls flock to Azuria."))
