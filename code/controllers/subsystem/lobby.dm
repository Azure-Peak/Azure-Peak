SUBSYSTEM_DEF(lobbymenu)
	name = "Lobbyrefresh"
	wait = 20
	priority = 100
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_SETUP | RUNLEVEL_LOBBY
	var/list/currentrun = list()

/datum/controller/subsystem/lobbymenu/fire(resumed = 0)
	if(!resumed)
		currentrun = GLOB.new_player_list.Copy()

	var/list/ready_players_by_job = list()
	var/list/wanderer_jobs = list(
		"Adventurer",
		"Wretch",
		"Court Agent"
	)
	var/list/count_only_job = list(
		"Hag"
	)
	for (var/mob/dead/new_player/ready_player in GLOB.player_list)
		if (ready_player.client?.ckey in GLOB.hiderole)
			continue
		var/job_choice = ready_player.client?.prefs?.job_preferences
		if (job_choice)
			for (var/job_name in job_choice)
				if (job_choice[job_name] == JP_HIGH)
					if (job_name in wanderer_jobs)
						job_name = "Wanderer"
					if (ready_player.ready == PLAYER_READY_TO_PLAY)
						if (!ready_players_by_job[job_name])
							ready_players_by_job[job_name] = list()
						ready_players_by_job[job_name] += ready_player.client.prefs.real_name
						break
	var/list/job_list = list()
	for (var/job_name in ready_players_by_job)
		var/list/job_players = ready_players_by_job[job_name]
		if (job_name in count_only_job)
			job_list += "<B>[job_name]</B> ([job_players.len])<br>"
		else
			job_list += "<B>[job_name]</B> ([job_players.len]) - [job_players.Join(", ")]<br>"
	sortTim(job_list, cmp = GLOBAL_PROC_REF(cmp_text_asc))
	var/job_list_html = job_list.Join()

	while(currentrun.len)
		var/mob/dead/new_player/player = currentrun[currentrun.len]
		currentrun.len--
		if(player.client)
			player.lobby_refresh(job_list_html)
		if (MC_TICK_CHECK)
			return
