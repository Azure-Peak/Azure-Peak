//Dead mobs can exist whenever. This is needful

INITIALIZE_IMMEDIATE(/mob/dead)

/mob/dead
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	move_resist = INFINITY
	throwforce = 0

/mob/dead/Initialize()
	SHOULD_CALL_PARENT(FALSE)
	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1
	tag = "mob_[next_mob_id++]"
	GLOB.mob_list += src

	prepare_huds()

	if(length(CONFIG_GET(keyed_list/cross_server)))
		verbs += /mob/dead/proc/server_hop
	set_focus(src)
	return INITIALIZE_HINT_NORMAL

/mob/dead/Destroy()
	GLOB.mob_list -= src
	return ..()

/mob/dead/canUseStorage()
	return FALSE

/mob/dead/dust(just_ash, drop_items, force)	//ghosts can't be vaporised.
	return

/mob/dead/gib()		//ghosts can't be gibbed.
	return

/mob/dead/ConveyorMove()	//lol
	return

/mob/dead/forceMove(atom/destination)
	var/turf/old_turf = get_turf(src)
	var/turf/new_turf = get_turf(destination)
	if (old_turf?.z != new_turf?.z)
		onTransitZ(old_turf?.z, new_turf?.z)
	var/oldloc = loc
	loc = destination
	Moved(oldloc, NONE, TRUE)


/mob/dead/new_player/proc/lobby_refresh()
	set waitfor = 0
//	src << browse(null, "window=lobby_window")

	if(!client)
		return

	if(client.is_new_player())
		return

	if(SSticker.HasRoundStarted())
		src << browse(null, "window=lobby_window")
		return

	var/list/dat = list("<center>")

	var/time_remaining = SSticker.GetTimeLeft()
	if(time_remaining > 0)
		dat += "Time To Start: [round(time_remaining/10)]s<br>"
	else if(time_remaining == -10)
		dat += "Time To Start: DELAYED<br>"
	else
		dat += "Time To Start: SOON<br>"

	dat += "Total players ready: [SSticker.totalPlayersReady]<br>"
	if(src.ready)
		dat += (span_good("Ready Bonus!") + "<a href='?src=[REF(src)];explainreadyupbonus=1'>(?)</a><br>")
	else
		dat += (span_highlight("No bonus! Ready up!") + "<a href='?src=[REF(src)];explainreadyupbonus=1'>(?)</a><br>")
	dat += "<B>Classes:</B><br>"

	dat += "</center>"

	var/list/job_list = list()
	var/list/ready_players_by_job = list()
	var/list/wanderer_jobs = list(
		"Adventurer",
		"Wretch",
		"Court Agent"
	)

	for (var/mob/dead/new_player/player in GLOB.player_list)
		if (player.client?.ckey in GLOB.hiderole)
			continue
		var/job_choice = player.client?.prefs?.job_preferences
		if (job_choice)
			for (var/job_name in job_choice)
				if (job_choice[job_name] == JP_HIGH)
					if (job_name in wanderer_jobs)
						job_name = "Wanderer"
					if (player.ready == PLAYER_READY_TO_PLAY)
						if (!ready_players_by_job[job_name])
							ready_players_by_job[job_name] = list()
						ready_players_by_job[job_name] += player.client.prefs.real_name
						break

	for (var/job_name in ready_players_by_job)
		var/list/job_players = ready_players_by_job[job_name]
		job_list += "<B>[job_name]</B> ([job_players.len]) - [job_players.Join(", ")]<br>"
	
	sortTim(job_list, cmp = GLOBAL_PROC_REF(cmp_text_asc))

	dat += job_list
	var/datum/browser/popup = new(src, "lobby_window", "<div align='center'>LOBBY</div>", 330, 430)
	popup.set_window_options("can_close=1;can_minimize=0;can_maximize=0;can_resize=1;")
	popup.set_content(dat.Join())
	if(!client)
		return
	if(winexists(src, "lobby_window"))
		src << browse(popup.get_content(), "window=lobby_window") //dont update the size or annoyingly refresh
		qdel(popup)
		return
	else
		popup.open(FALSE)

/mob/dead/proc/server_hop()
	set category = "OOC"
	set name = "Server Hop!"
	set desc= "Jump to the other server"
	set hidden = 1
	if(notransform)
		return
	var/list/csa = CONFIG_GET(keyed_list/cross_server)
	var/pick
	switch(csa.len)
		if(0)
			verbs -= /mob/dead/proc/server_hop
			to_chat(src, span_notice("Server Hop has been disabled."))
		if(1)
			pick = csa[1]
		else
			pick = input(src, "Pick a server to jump to", "Server Hop") as null|anything in csa

	if(!pick)
		return

	var/addr = csa[pick]

	if(alert(src, "Jump to server [pick] ([addr])?", "Server Hop", "Yes", "No") != "Yes")
		return

	var/client/C = client
	to_chat(C, span_notice("Sending you to [pick]."))
	new /atom/movable/screen/splash(C)

	notransform = TRUE
	sleep(29)	//let the animation play
	notransform = FALSE

	if(!C)
		return

	winset(src, null, "command=.options") //other wise the user never knows if byond is downloading resources

	C << link("[addr]?server_hop=[key]")

/mob/dead/proc/update_z(new_z) // 1+ to register, null to unregister
	if (registered_z != new_z)
		if (registered_z)
			SSmobs.dead_players_by_zlevel[registered_z] -= src
		if (client)
			if (new_z)
				SSmobs.dead_players_by_zlevel[new_z] += src
			registered_z = new_z
		else
			registered_z = null

/mob/dead/Login()
	. = ..()
	var/turf/T = get_turf(src)
	if (isturf(T))
		update_z(T.z)

/mob/dead/auto_deadmin_on_login()
	return

/mob/dead/Logout()
	update_z(null)
	return ..()

/mob/dead/onTransitZ(old_z,new_z)
	..()
	update_z(new_z)
