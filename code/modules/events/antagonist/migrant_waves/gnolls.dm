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

/proc/update_gnoll_slots()
	var/datum/job/gnoll_job = SSjob.GetJob("Gnoll")
	if(!gnoll_job)
		return

	var/player_count = length(GLOB.joined_player_list)
	
	//Add 1 slot for every 10 players over 30. Less than 40 players, 5 slots. 40 or more players, 6 slots. 50 or more players, 7 slots - etc.
	if(player_count > 40 && gnoll_job.total_positions <= 0)
		gnoll_job.total_positions = 1
		gnoll_job.spawn_positions = 1
