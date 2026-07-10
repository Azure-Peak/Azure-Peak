/datum/round_event_control/antagonist/migrant_wave/only_gnolls
	name = "Gnoll Migration"
	typepath = /datum/round_event/migrant_wave/only_gnolls
	wave_type = /datum/migrant_wave/gnolls
	max_occurrences = 2

	weight = 18

	earliest_start = 30 MINUTES
	min_players = 30

	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
	)

/datum/round_event_control/antagonist/migrant_wave/only_gnolls/preRunEvent()
	if(is_storyteller_soft_antag_blocked())
		return EVENT_CANT_RUN
	if(SSgamemode.current_storyteller?.preferred_gnoll_mode == GNOLL_SCALING_NONE)
		return EVENT_CANT_RUN
	return ..()

/datum/round_event/migrant_wave/only_gnolls/start()
	if(SSgamemode.current_storyteller?.preferred_gnoll_mode == GNOLL_SCALING_NONE)
		return
	var/datum/job/gnoll_job = SSjob.GetJob("Gnoll")
	var/gnoll_maxcap = max(SSgamemode.story_antag_slot_cap(/datum/antagonist/gnoll), gnoll_job.total_positions)
	gnoll_job.total_positions = min(gnoll_job.total_positions + 2, gnoll_maxcap)
	gnoll_job.spawn_positions = min(gnoll_job.spawn_positions + 2, gnoll_maxcap)
	if(gnoll_job.total_positions < gnoll_maxcap)
		SSrole_class_handler.assassins_in_round = TRUE
		for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
			if(!player.client)
				continue
			to_chat(player, span_danger("Graggar demands blood, gnolls flock to Azuria."))
