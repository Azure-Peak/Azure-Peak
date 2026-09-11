/// This subsystem handles data generation for lobby menu for everyone to minimize server load
SUBSYSTEM_DEF(lobbymenu)
	name = "Lobbyrefresh"
	wait = 20
	priority = 100
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_SETUP | RUNLEVEL_LOBBY
	var/list/lobby_player_display = list()

/datum/controller/subsystem/lobbymenu/fire(resumed = 0)
	var/static/list/wanderer_jobs = list(
		"Adventurer",
		"Wretch",
		"Court Agent"
	)
	var/static/list/count_only_job = list(
		"Hag"
	)

	var/list/ready_players_by_job = list()
	for(var/mob/dead/new_player/player in GLOB.player_list)
		var/job_choice = player.client?.prefs?.job_preferences
		for(var/job_name in job_choice)
			if(job_choice[job_name] == JP_HIGH)
				if(job_name in wanderer_jobs)
					job_name = "Wanderer"
				if(player.ready == PLAYER_READY_TO_PLAY)
					if(!ready_players_by_job[job_name])
						ready_players_by_job[job_name] = list()
					ready_players_by_job[job_name] += player.client.prefs.real_name
					break

	LAZYCLEARLIST(lobby_player_display)
	for(var/job_name in ready_players_by_job)
		var/list/job_players = ready_players_by_job[job_name]
		UNTYPED_LIST_ADD(lobby_player_display, list(
			"name" = "[job_name]",
			"length" = "[LAZYLEN(job_players)]",
			"players" = (job_name in count_only_job) ? null : job_players.Join(", "),
		))

/// this returns lobby_player_display when the subsystem is running and an empty list all other times
/datum/controller/subsystem/lobbymenu/proc/get_lobby_player_display()
	if(Master.current_runlevel & (RUNLEVEL_SETUP | RUNLEVEL_LOBBY))
		return lobby_player_display
	return list()
