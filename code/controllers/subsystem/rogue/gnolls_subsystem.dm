SUBSYSTEM_DEF(gnoll_scaling)
	name = "Gnoll Scaling Controller"
	flags = SS_NO_FIRE

	var/gnoll_scaling_mode = 0
	var/gnoll_playercount_lock = TRUE
	var/desired_gnoll_slots = 1

/datum/controller/subsystem/gnoll_scaling/proc/unlock_gnoll_scaling()
	var/players_amt = get_active_player_count(alive_check = 1, afk_check = 1, human_check = 1)
	if(players_amt < 25)
		addtimer(CALLBACK(src, .proc/unlock_gnoll_scaling), 6000)
		return

	gnoll_playercount_lock = FALSE

	var/mode = get_gnoll_scaling()
	var/target_slots = 1

	switch(mode)
		if(GNOLL_SCALING_SINGLE)
			target_slots = 1
		if(GNOLL_SCALING_FLAT)
			target_slots = 2
		if(GNOLL_SCALING_DYNAMIC)
			target_slots = 3

	// Increase this automatically even if no further people with hunted join.
	var/datum/job/gnoll_job = SSjob.GetJob("Gnoll")

	if(gnoll_job.total_positions < target_slots)
		gnoll_job.total_positions = target_slots
		gnoll_job.spawn_positions = target_slots

		for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
			if(player.client)
				to_chat(player, span_alert("Graggar demands blood, gnolls flock to Azuria."))

/datum/controller/subsystem/gnoll_scaling/proc/get_gnoll_scaling()
	if(gnoll_scaling_mode != 0)
		return gnoll_scaling_mode

	// Aiming for rougly 30 minutes into the round
	// Will not unlock scaling if there's too few players
	addtimer(CALLBACK(src, .proc/unlock_gnoll_scaling), 24000)
	var/datum/storyteller/ST = SSgamemode.selected_storyteller
	// Roll a coinflip to decide the round's behavior when default value is supplied.
	if(ST.preferred_gnoll_mode == GNOLL_SCALING_RANDOM)
		gnoll_scaling_mode = pick(GNOLL_SCALING_FLAT, GNOLL_SCALING_SINGLE)
	else
		gnoll_scaling_mode = ST.preferred_gnoll_mode
	return gnoll_scaling_mode
