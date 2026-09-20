/mob/dead/new_player/verb/new_player_panel()
	set category = "Preferences.New Player"
	set name = "Reopen Lobby Menu"
	return ui_interact(src)

/mob/dead/new_player/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NewPlayerPanel", "Lobby Menu")
		ui.open()

/mob/dead/new_player/ui_state(mob/user)
	return GLOB.new_player_state

/mob/dead/new_player/ui_data(mob/user)
	var/list/data = ..()

	data["server_name"] = CONFIG_GET(string/servername)
	data["ticker_state"] = SSticker.current_state
	data["ready"] = ready
	data["migrant"] = client?.prefs?.is_active_migrant() || FALSE // turns null into 0
	data["active_character"] = client?.prefs?.real_name

	data["time_remaining"] = SSticker.GetTimeLeft()
	data["ready_count"] = SSticker.totalPlayersReady
	data["ready_jobs"] = SSlobbymenu.get_lobby_player_display()

	return data

/mob/dead/new_player/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("ready")
			var/is_pregame = SSticker.current_state <= GAME_STATE_PREGAME
			if(is_pregame)
				if(ready == PLAYER_NOT_READY)
					if(SSticker.job_change_locked)
						to_chat(src, span_boldwarning("Setting up, roles are locked..."))
						return
					if(length(client.prefs.flavortext) < MINIMUM_FLAVOR_TEXT)
						to_chat(src, span_boldwarning("You need a minimum of [MINIMUM_FLAVOR_TEXT] characters in your flavor text in order to play."))
						return TRUE
					if(length(client.prefs.ooc_notes) < MINIMUM_OOC_NOTES)
						to_chat(src, span_boldwarning("You need at least a few words in your OOC notes in order to play."))
						return TRUE

					ready = PLAYER_READY_TO_PLAY
				else
					ready = PLAYER_NOT_READY
			return TRUE
		if("migrants")
			client.prefs.migrant.show_ui()
			return TRUE
		if("manifest")
			client.view_actors_manifest()
			return TRUE
		if("observe")
			make_me_an_observer()
			return TRUE
		if("show_preferences")
			client.prefs.ShowChoices(src, PREFERENCE_TAB_CHARACTER_CREATOR)
			return TRUE
		if("show_options")
			client.prefs.ShowChoices(src, PREFERENCE_TAB_GAME_SETTINGS)
			return TRUE
		if("show_keybinds")
			client.prefs.ShowChoices(src, PREFERENCE_TAB_KEYBINDINGS)
			return TRUE
		if("late_join")
			// Determine relevant population cap.
			var/relevant_cap
			var/hpc = CONFIG_GET(number/hard_popcap)
			var/epc = CONFIG_GET(number/extreme_popcap)
			if(hpc && epc)
				relevant_cap = min(hpc, epc)
			else
				relevant_cap = max(hpc, epc)

			if(!SSticker?.IsRoundInProgress())
				to_chat(src, span_boldwarning("The game is starting. You cannot join yet."))
				return TRUE

			if(client && client.prefs.is_active_migrant())
				to_chat(src, span_boldwarning("You are in the migrant queue."))
				return TRUE

			var/timetojoin = 5 MINUTES
#ifdef ALLOWPLAY
			timetojoin = 1 SECONDS
#endif
#ifdef TESTSERVER
			timetojoin = 0
#endif
			if(SSticker.round_start_time)
				if(world.time < SSticker.round_start_time + timetojoin)
					var/ttime = round((SSticker.round_start_time + timetojoin - world.time) / 10)
					var/list/choicez = list("Not yet.", "You cannot join yet.", "It won't work yet.", "Please be patient.", "Try again later.", "Late-joining is not yet possible.")
					to_chat(src, span_warning("[pick(choicez)] ([ttime])."))
					return TRUE

			var/plevel = 0
			if(client)
				plevel = client.patreonlevel()

			if(!IsPatreon(ckey))
				if(SSticker.queued_players.len || (relevant_cap && living_player_count() >= relevant_cap && !(ckey(key) in GLOB.admin_datums) && plevel < 1))
					to_chat(src, span_danger("[CONFIG_GET(string/hard_popcap_message)]"))

					var/queue_position = SSticker.queued_players.Find(src)
					if(queue_position == 1)
						to_chat(src, span_notice("Thou art next in line to join the game. You will be notified when a slot opens up."))
					else if(queue_position)
						to_chat(src, span_notice("Thou art [queue_position-1] players in front of you in the queue to join the game."))
					else
						SSticker.queued_players += src
						to_chat(src, span_notice("Thou have been added to the queue to join the game. Your position in queue is [SSticker.queued_players.len]."))
					return TRUE

			LateChoices()
			return TRUE
