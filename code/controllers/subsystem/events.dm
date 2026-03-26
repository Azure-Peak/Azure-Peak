SUBSYSTEM_DEF(events)
	name = "Events"
	init_order = INIT_ORDER_EVENTS
	runlevels = RUNLEVEL_GAME


	var/list/control = list()	//list of all datum/round_event_control. Used for selecting events based on weight and occurrences.
	var/list/running = list()	//list of all existing /datum/round_event
	var/list/currentrun = list()

	var/scheduled = 0			//The next world.time that a naturally occuring random event can be selected.
	var/frequency_lower = 1800	//3 minutes lower bound.
	var/frequency_upper = 3000	//10 minutes upper bound. Basically an event will happen every 3 to 10 minutes.

	var/list/holidays			//List of all holidays occuring today or null if no holidays
	var/wizardmode = FALSE

/datum/controller/subsystem/events/Initialize(time, zlevel)
	for(var/type in typesof(/datum/round_event_control))
		var/datum/round_event_control/E = new type()
		if(!E.typepath)
			continue				//don't want this one! leave it for the garbage collector
		control += E				//add it to the list of all events (controls)
	return ..()


/datum/controller/subsystem/events/fire(resumed = 0)
	if(!resumed)
		src.currentrun = running.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/datum/thing = currentrun[currentrun.len]
		currentrun.len--
		if(thing)
			thing.process()
		else
			running.Remove(thing)
		if (MC_TICK_CHECK)
			return

//selects a random event based on whether it can occur and it's 'weight'(probability)
/datum/controller/subsystem/events/proc/spawnEvent()
	set waitfor = FALSE	//for the admin prompt
	if(!CONFIG_GET(flag/allow_random_events))
		return

	var/players_amt = get_active_player_count(alive_check = 1, afk_check = 1, human_check = 1)
	// Only alive, non-AFK human players count towards this.

	var/sum_of_weights = 0
	for(var/datum/round_event_control/E in control)
		if(!E.canSpawnEvent(players_amt, null))
			continue
		if(E.weight < 0)						//for round-start events etc.
			var/res = TriggerEvent(E)
			if(res == EVENT_INTERRUPTED)
				continue	//like it never happened
			if(res == EVENT_CANT_RUN)
				return
		sum_of_weights += E.weight

	sum_of_weights = rand(0,sum_of_weights)	//reusing this variable. It now represents the 'weight' we want to select

	for(var/datum/round_event_control/E in control)
		if(!E.canSpawnEvent(players_amt, null))
			continue
		sum_of_weights -= E.weight

		if(sum_of_weights <= 0)				//we've hit our goal
			if(TriggerEvent(E))
				return

/datum/controller/subsystem/events/proc/TriggerEvent(datum/round_event_control/E)
	. = E.preRunEvent()
	if(. == EVENT_CANT_RUN)//we couldn't run this event for some reason, set its max_occurrences to 0
		E.max_occurrences = 0
	else if(. == EVENT_READY)
		E.runEvent(random = TRUE)

//allows a client to trigger an event
//aka Badmin Central
// > Not in modules/admin
// REEEEEEEEE
/client/proc/forceEvent()
	set name = "Trigger Event"
	set category = "-GameMaster-"
	if(!holder ||!check_rights(R_FUN))
		return
	holder.forceEvent(usr)

/datum/admins/proc/forceEvent(mob/user)
	SSgamemode.event_panel(user)

/client/proc/forceGamemode()
	set name = "Storyteller - Panel"
	set category = "-GameMaster-"
	if(!holder ||!check_rights(R_FUN))
		return
	holder.forceGamemode(usr)

/datum/admins/proc/forceGamemode(mob/user)
	SSgamemode.admin_panel(user)

/datum/controller/subsystem/events/proc/resetFrequency()
	frequency_lower = initial(frequency_lower)
	frequency_upper = initial(frequency_upper)

/client/proc/view_storyteller_vote_log()
	set category = "-GameMaster-"
	set name = "Storyteller - Log"

	if(!check_rights(R_ADMIN))
		return

	var/mob/user = mob
	if(!user)
		return

	var/file_path = "data/last_round/storyteller_vote.json"
	if(!fexists(file_path))
		to_chat(src, span_warning("No storyteller vote log found."))
		return

	var/file_text = file2text(file_path)
	var/list/file_data = safe_json_decode(file_text)
	if(!islist(file_data))
		var/datum/browser/raw_popup = new(user, "storyteller_vote_log", "Storyteller Vote Log", 700, 500)
		raw_popup.set_content("<pre>[html_encode(file_text)]</pre>")
		raw_popup.open()
		return

	var/state = file_data["state"]
	if(!state)
		state = "unknown"

	var/winner = file_data["winner"]
	if(!winner)
		winner = "None"

	var/list/dat = list()
	dat += "<h2>Storyteller Vote Log</h2>"
	dat += "<b>State:</b> [html_encode(state)]<br>"
	dat += "<b>Winner:</b> [html_encode(winner)]<br><hr>"

	var/list/votes = file_data["votes"]
	if(!islist(votes) || !length(votes))
		dat += "No votes recorded."
	else
		dat += "<table width='100%' style='text-align:left'>"
		dat += "<tr><th>Ckey</th><th>Choice</th><th>Vote Power</th></tr>"
		for(var/voter_ckey in votes)
			var/list/vote_data = votes[voter_ckey]
			if(!islist(vote_data))
				continue
			var/choice = vote_data["choice"]
			if(!choice)
				choice = "Unknown"
			var/vote_power = vote_data["vote_power"]
			if(isnull(vote_power))
				vote_power = 0
			dat += "<tr><td>[html_encode(voter_ckey)]</td><td>[html_encode(choice)]</td><td>[vote_power]</td></tr>"
		dat += "</table>"

	var/datum/browser/popup = new(user, "storyteller_vote_log", "Storyteller Vote Log", 700, 500)
	popup.set_content(dat.Join())
	popup.open()
