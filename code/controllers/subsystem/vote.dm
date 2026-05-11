#define LAST_STORYTELLER_VOTE_LOG_FILE "data/last_round/storyteller_vote.json"
#define DEFAULT_VOTE_PANEL_REFRESH_INTERVAL 2 SECONDS
#define STORYTELLER_VOTE_PANEL_REFRESH_INTERVAL 5 SECONDS

SUBSYSTEM_DEF(vote)
	name = "Vote"
	wait = 10

	flags = SS_KEEP_TIMING|SS_NO_INIT

	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/initiator = null
	var/started_time = null
	var/time_remaining = 0
	var/custom_vote_period = 0
	var/mode = null
	var/question = null
	var/vote_height = 400
	var/vote_width = 400
	var/panel_refresh_interval = DEFAULT_VOTE_PANEL_REFRESH_INTERVAL
	var/next_panel_refresh = 0
	var/list/choices = list()
	var/list/voted = list()
	var/list/voting = list()
	var/list/vote_selections = list()
	var/list/vote_powers = list()
	var/list/storyteller_vote_log = list()
	var/list/generated_actions = list()
	var/static/list/everyone_is_equal = list("custom")

/datum/controller/subsystem/vote/fire()	//called by master_controller
	if(mode)
		var/vote_period = custom_vote_period || CONFIG_GET(number/vote_period)
		time_remaining = round((started_time + vote_period - world.time)/10)

		if(time_remaining < 0)
			result()
			for(var/client/C in voting)
				C << browse(null, "window=vote;can_close=0;size=[vote_width]x[vote_height]")
			reset()
		else if(world.time >= next_panel_refresh)
			next_panel_refresh = world.time + panel_refresh_interval
			for(var/client/C in voting)
				show_vote(C)


/datum/controller/subsystem/vote/proc/show_vote(client/C)
	if(!C)
		return
	var/datum/browser/noclose/client_popup = new(C, "vote", "Voting Panel", nwidth = vote_width, nheight = vote_height)
	client_popup.set_window_options("can_close=0")
	client_popup.width = vote_width
	client_popup.height = vote_height
	client_popup.set_content(interface(C))
	client_popup.open(FALSE)


/datum/controller/subsystem/vote/proc/reset()
	initiator = null
	time_remaining = 0
	custom_vote_period = 0
	vote_width = initial(vote_width)
	vote_height = initial(vote_height)
	panel_refresh_interval = initial(panel_refresh_interval)
	next_panel_refresh = 0
	mode = null
	question = null
	choices.Cut()
	voted.Cut()
	voting.Cut()
	vote_selections.Cut()
	vote_powers.Cut()
	storyteller_vote_log.Cut()
	remove_action_buttons()

/datum/controller/subsystem/vote/proc/get_storyteller_vote_pool(storyteller_type)
	if(!ispath(storyteller_type, /datum/storyteller))
		return null
	switch(storyteller_type)
		if(/datum/storyteller/psydon)
			return "Psydon"
		if(/datum/storyteller/graggar, /datum/storyteller/matthios, /datum/storyteller/zizo, /datum/storyteller/baotha)
			return "Ascendants"
	return "The Ten"

/datum/controller/subsystem/vote/proc/get_storyteller_pool_totals()
	var/list/pool_totals = list()
	for(var/option in choices)
		var/storyteller_type = get_storyteller_choice_type(option)
		var/pool_name = get_storyteller_vote_pool(storyteller_type)
		if(!pool_name)
			continue
		pool_totals[pool_name] = (pool_totals[pool_name] || 0) + (choices[option] || 0)
	return pool_totals

/datum/controller/subsystem/vote/proc/get_storyteller_pool_winners()
	var/list/pool_totals = get_storyteller_pool_totals()
	var/greatest_votes = 0
	for(var/pool_name in pool_totals)
		var/pool_votes = pool_totals[pool_name] || 0
		if(pool_votes > greatest_votes)
			greatest_votes = pool_votes
	var/list/winning_pools = list()
	if(!greatest_votes)
		return winning_pools
	for(var/pool_name in pool_totals)
		if((pool_totals[pool_name] || 0) == greatest_votes)
			winning_pools += pool_name
	return winning_pools

/datum/controller/subsystem/vote/proc/get_storyteller_winning_choices(list/winning_pools)
	var/list/winners = list()
	if(!length(winning_pools))
		return winners
	var/greatest_votes = 0
	for(var/option in choices)
		var/storyteller_type = get_storyteller_choice_type(option)
		var/pool_name = get_storyteller_vote_pool(storyteller_type)
		if(!(pool_name in winning_pools))
			continue
		var/option_votes = choices[option] || 0
		if(option_votes > greatest_votes)
			greatest_votes = option_votes
			winners = list(option)
		else if(option_votes == greatest_votes && option_votes > 0)
			winners += option
	return winners

/datum/controller/subsystem/vote/proc/get_storyteller_pool_theme(pool_name)
	var/list/theme = list(
		"border" = "#5a5670",
		"background" = "rgba(34,31,45,0.82)",
		"title" = "#d8d2ff",
		"meta" = "#bcb4e9",
		"summary" = "#b8b1d8",
		"entry" = "rgba(255,255,255,0.03)",
		"link" = "#d8d2ff",
		"selection_color" = "#ffdc7a",
	)
	switch(pool_name)
		if("Psydon")
			theme["border"] = "#7f878d"
			theme["background"] = "#8e9499"
			theme["title"] = "#1f2428"
			theme["meta"] = "#3f474d"
			theme["summary"] = "#4d565c"
			theme["entry"] = "rgba(255,255,255,0.12)"
			theme["link"] = "#d7fffb"
			theme["selection_color"] = "#1f2428"
		if("Ascendants")
			theme["border"] = "#a43c3c"
			theme["background"] = "#581414"
			theme["title"] = "#ffd6d6"
			theme["meta"] = "#f0aaaa"
			theme["summary"] = "#e2a2a2"
			theme["entry"] = "rgba(255,214,214,0.08)"
			theme["link"] = "#ffd6d6"
			theme["selection_color"] = "#ffd6d6"
		if("The Ten")
			theme["border"] = "#2b8c87"
			theme["background"] = "#10464a"
			theme["title"] = "#d7fffb"
			theme["meta"] = "#98ddd8"
			theme["summary"] = "#8ed0cb"
			theme["entry"] = "rgba(215,255,251,0.08)"
			theme["link"] = "#d7fffb"
			theme["selection_color"] = "#d7fffb"
	return theme

/datum/controller/subsystem/vote/proc/render_storyteller_pool(list/choice_indices, pool_name, can_vote, selected_option)
	if(!length(choice_indices))
		return ""
	var/list/pool_totals = get_storyteller_pool_totals()
	var/pool_votes = pool_totals[pool_name] || 0
	var/list/theme = get_storyteller_pool_theme(pool_name)
	var/dat = "<div style='border:1px solid [theme["border"]];border-radius:8px;padding:7px 8px;background:[theme["background"]];min-height:100%;box-sizing:border-box;'>"
	dat += "<div style='font-size:0.96rem;font-weight:bold;margin-bottom:6px;color:[theme["title"]];'>[pool_name] <span style='float:right;font-size:0.78rem;color:[theme["meta"]];'>[pool_votes] votepwr</span></div>"
	dat += "<div style='display:grid;grid-template-columns:repeat(2, minmax(0, 1fr));gap:6px;'>"
	for(var/index in choice_indices)
		var/option_index = text2num(index)
		var/choice_text = choices[option_index]
		var/storyteller_type = get_storyteller_choice_type(choice_text)
		var/votes = choices[choice_text] || 0
		var/is_selected = (selected_option == choice_text)
		var/selected_color = theme["selection_color"]
		var/selected_text = is_selected ? " <span style='color:[selected_color];font-size:0.76rem;font-weight:bold;'>(current)</span>" : ""
		var/entry = "<div style='padding:5px 6px;border-radius:6px;background:[theme["entry"]];min-width:0;'>"
		var/details_link = "<a href='?src=[REF(SSgamemode)];storyboy_details=[storyteller_type]' style='display:inline-block;margin-left:4px;color:[theme["meta"]];font-size:0.75rem;text-decoration:none;'>(?)</a>"
		if(can_vote)
			entry += "<div><a href='?src=[REF(src)];vote=[option_index]' style='font-size:0.9rem;color:[theme["link"]];font-weight:bold;'>[choice_text]</a>[details_link][selected_text]</div><div style='color:[theme["meta"]];font-size:0.76rem;'>[votes] votepwr</div>"
		else
			entry += "<div><span style='font-size:0.9rem;font-weight:bold;'>[choice_text]</span>[details_link][selected_text]</div><div style='color:[theme["meta"]];font-size:0.76rem;'>[votes] votepwr</div>"
		entry += "</div>"
		dat += entry
	dat += "</div></div>"
	return dat

/datum/controller/subsystem/vote/proc/render_storyteller_choices(can_vote, client/C)
	var/list/pool_order = list("Psydon", "Ascendants", "The Ten")
	var/list/pooled_indices = list()
	var/selected_option = null
	if(C)
		selected_option = vote_selections[C.ckey]
	for(var/pool_name in pool_order)
		pooled_indices[pool_name] = list()

	for(var/i = 1, i <= choices.len, i++)
		var/choice_text = choices[i]
		var/storyteller_type = get_storyteller_choice_type(choice_text)
		var/pool_name = get_storyteller_vote_pool(storyteller_type)
		if(!pool_name)
			continue
		var/list/pool_choices = pooled_indices[pool_name]
		pool_choices += "[i]"

	var/dat = "<div style='margin-top:8px;display:grid;grid-template-columns:repeat(2, minmax(0, 1fr));gap:10px;align-items:start;'>"
	for(var/pool_name in pool_order)
		var/list/pool_choices = pooled_indices[pool_name]
		if(!length(pool_choices))
			continue
		dat += render_storyteller_pool(pool_choices, pool_name, can_vote, selected_option)
	dat += "</div>"
	return dat

/datum/controller/subsystem/vote/proc/get_result()
	if(mode == "storyteller")
		var/list/winning_pools = get_storyteller_pool_winners()
		return get_storyteller_winning_choices(winning_pools)

	//get the highest number of votes
	var/greatest_votes = 0
	var/total_votes = 0
	for(var/option in choices)
		var/votes = choices[option]
		total_votes += votes
		if(votes > greatest_votes)
			greatest_votes = votes
	//default-vote for everyone who didn't vote
	if(!CONFIG_GET(flag/default_no_vote) && choices.len)
		var/list/non_voters = GLOB.directory.Copy()
		non_voters -= voted
		for (var/non_voter_ckey in non_voters)
			var/client/C = non_voters[non_voter_ckey]
			if (!C || C.is_afk())
				non_voters -= non_voter_ckey
		if(non_voters.len > 0)
			if(mode == "restart")
				choices["Continue Playing"] += non_voters.len
				if(choices["Continue Playing"] >= greatest_votes)
					greatest_votes = choices["Continue Playing"]
			else if(mode == "gamemode")
				if(GLOB.master_mode in choices)
					choices[GLOB.master_mode] += non_voters.len
					if(choices[GLOB.master_mode] >= greatest_votes)
						greatest_votes = choices[GLOB.master_mode]
			else if(mode == "map")
				for (var/non_voter_ckey in non_voters)
					var/client/C = non_voters[non_voter_ckey]
					if(C.prefs.preferred_map)
						var/preferred_map = C.prefs.preferred_map
						choices[preferred_map] += 1
						greatest_votes = max(greatest_votes, choices[preferred_map])
					else if(global.config.defaultmap)
						var/default_map = global.config.defaultmap.map_name
						choices[default_map] += 1
						greatest_votes = max(greatest_votes, choices[default_map])
	//get all options with that many votes and return them in a list
	. = list()
	if(greatest_votes)
		for(var/option in choices)
			if(choices[option] == greatest_votes)
				. += option
	return .

/datum/controller/subsystem/vote/proc/announce_result()
	var/list/winners = get_result()
	var/text
	if(winners.len > 0)
		if(question)
			text += "<b>[question]</b>"
		else
			text += "<b>[capitalize(mode)] Vote</b>"
		for(var/i=1,i<=choices.len,i++)
			var/votes = choices[choices[i]]
			if(!votes)
				votes = 0
			text += "\n<b>[choices[i]]:</b> [votes]"
		if(mode == "storyteller")
			var/list/pool_totals = get_storyteller_pool_totals()
			if(pool_totals.len)
				text += "\n<hr><b>Pool Totals</b>"
				for(var/pool_name in pool_totals)
					text += "\n<b>[pool_name]:</b> [pool_totals[pool_name]]"
		if(mode != "custom")
			if(winners.len > 1)
				if(mode == "storyteller")
					text += "\n<b>Vote Tied Between:</b>"
				else
					text = "\n<b>Vote Tied Between:</b>"
				for(var/option in winners)
					text += "\n\t[option]"
				if(mode == "endround")
					winners = list("End Round")
			. = pick(winners)
			text += "\n<b>Vote Result: [.]</b>"
		else
			text += "\n<b>Did not vote:</b> [GLOB.clients.len-voted.len]"
	else
		if(mode == "endround")
			. = "End Round"
			text += "\n<b>Vote Result: [.]</b>"
		else
			text += "<b>Vote Result: Inconclusive - No Votes!</b>"
	log_vote(text)
	remove_action_buttons()
	to_chat(world, "\n<font color='purple'>[text]</font>")
	return .

/datum/controller/subsystem/vote/proc/result()
	. = announce_result()
	var/restart = 0
	if(.)
		switch(mode)
			if("restart")
				if(. == "Restart Round")
					restart = 1
			if("gamemode")
				if(GLOB.master_mode != .)
					SSticker.save_mode(.)
					if(SSticker.HasRoundStarted())
						restart = 1
					else
						GLOB.master_mode = .
			if("map")
				SSmapping.changemap(global.config.maplist[.])
				SSmapping.map_voted = TRUE
			if("endround")
				if(. == "Continue Playing")
					log_game("LOG VOTE: CONTINUE PLAYING AT [REALTIMEOFDAY]")
					GLOB.round_timer = world.time + ROUND_EXTENSION_TIME
				else
					log_game("LOG VOTE: ELSE  [REALTIMEOFDAY]")
					log_game("LOG VOTE: ROUNDVOTEEND [REALTIMEOFDAY]")
					to_chat(world, "\n<font color='purple'>[ROUND_END_TIME_VERBAL]</font>")
					SSgamemode.roundvoteend = TRUE
					SSgamemode.round_ends_at = world.time + ROUND_END_TIME
			if("storyteller")
				save_storyteller_vote_log(., "completed")
				SSgamemode.storyteller_vote_result(.)
	else if(mode == "storyteller")
		// No winner (inconclusive / no votes cast). Still run the result hook so
		// selected_storyteller gets the Astrata fallback instead of whichever
		// storyteller pick_most_influential() happened to seed at init.
		save_storyteller_vote_log(null, "completed")
		SSgamemode.storyteller_vote_result(null)

	if(restart)
		var/active_admins = 0
		for(var/client/C in GLOB.admins)
			if(!C.is_afk() && check_rights_for(C, R_SERVER))
				active_admins = 1
				break
		if(!active_admins)
			SSticker.Reboot("Restart vote successful.", "restart vote")
		else
			to_chat(world, "<span style='boldannounce'>Notice:Restart vote will not restart the server automatically because there are active gamemasters on.</span>")
			message_admins("A restart vote has passed, but there are active admins on with +server, so it has been canceled. If you wish, you may restart the server.")

	return .

/datum/controller/subsystem/vote/proc/can_client_vote(client/C)
	return !isnull(C)

/datum/controller/subsystem/vote/proc/get_vote_power(mob/voter)
	var/vote_power = 1
	if(ishuman(voter))
		var/mob/living/carbon/H = voter
		if(H.stat != DEAD)
			vote_power += 3
		if(H.job)
			var/list/list_of_powerful = list("Grand Duke", "Bishop")
			if(H.job in list_of_powerful)
				vote_power += 5
			else
				if(H.mind)
					for(var/datum/antagonist/D in H.mind.antag_datums)
						if(D.increase_votepwr)
							vote_power += 3
	if(mode in everyone_is_equal)
		vote_power = 1
	return vote_power

/datum/controller/subsystem/vote/proc/get_storyteller_choice_name(choice_text)
	if(!choice_text)
		return null
	if(ispath(choice_text, /datum/storyteller))
		var/datum/storyteller/storyboy = SSgamemode.storytellers[choice_text]
		return storyboy?.name
	for(var/storyteller_type in SSgamemode.storytellers)
		var/datum/storyteller/storyboy = SSgamemode.storytellers[storyteller_type]
		if(findtext(choice_text, storyboy.name))
			return storyboy.name
	return strip_html("[choice_text]")

/datum/controller/subsystem/vote/proc/get_storyteller_choice_type(choice_text)
	if(!choice_text)
		return null
	if(ispath(choice_text, /datum/storyteller))
		return choice_text
	for(var/storyteller_type in SSgamemode.storytellers)
		var/datum/storyteller/storyboy = SSgamemode.storytellers[storyteller_type]
		if(findtext(choice_text, storyboy.name))
			return storyboy.type
	return null

/datum/controller/subsystem/vote/proc/load_storyteller_vote_log()
	var/json_file = file(LAST_STORYTELLER_VOTE_LOG_FILE)
	if(!fexists(json_file))
		return FALSE
	var/list/file_data = safe_json_decode(file2text(json_file))
	if(!islist(file_data))
		return FALSE
	var/list/file_votes = file_data["votes"]
	if(!islist(file_votes))
		return FALSE
	voted.Cut()
	vote_selections.Cut()
	vote_powers.Cut()
	storyteller_vote_log.Cut()
	for(var/voter_ckey in file_votes)
		var/list/vote_data = file_votes[voter_ckey]
		if(!islist(vote_data))
			continue
		var/choice_name = vote_data["choice"]
		var/vote_power = vote_data["vote_power"]
		if(!(choice_name in choices))
			continue
		voted += voter_ckey
		vote_selections[voter_ckey] = choice_name
		vote_powers[voter_ckey] = vote_power
		storyteller_vote_log[voter_ckey] = list(
			"choice" = choice_name,
			"vote_power" = vote_power,
		)
	return TRUE

/datum/controller/subsystem/vote/proc/save_storyteller_vote_log(winning_choice = null, state = "active")
	var/json_file = file(LAST_STORYTELLER_VOTE_LOG_FILE)
	var/list/file_data = list()
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	else
		file_data = safe_json_decode(file2text(json_file))
	if(!islist(file_data))
		file_data = list()
	file_data["state"] = state
	var/winner_name = get_storyteller_choice_name(winning_choice)
	var/winner_type = get_storyteller_choice_type(winning_choice)
	if(winner_name)
		file_data["winner"] = winner_name
	else
		file_data -= "winner"
	if(winner_type)
		file_data["storyteller_vote"] = "[winner_type]"
	var/list/votes = list()
	for(var/voter_ckey in storyteller_vote_log)
		var/list/vote_data = storyteller_vote_log[voter_ckey]
		if(!islist(vote_data))
			continue
		votes[voter_ckey] = list(
			"choice" = vote_data["choice"],
			"vote_power" = vote_data["vote_power"],
		)
	file_data["votes"] = votes
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/vote/proc/remove_vote_for_ckey(voter_ckey)
	if(!(voter_ckey in voted))
		return FALSE
	var/selected_option = vote_selections[voter_ckey]
	var/vote_power = vote_powers[voter_ckey] || 0
	if(selected_option && (selected_option in choices))
		choices[selected_option] = max(0, choices[selected_option] - vote_power)
	voted -= voter_ckey
	vote_selections -= voter_ckey
	vote_powers -= voter_ckey
	storyteller_vote_log -= voter_ckey
	if(mode == "storyteller")
		save_storyteller_vote_log(null, "active")
	return TRUE

/datum/controller/subsystem/vote/proc/submit_vote(vote)
	// Voting where vote power is equal for all
	if(mode)
		if(!can_client_vote(usr.client))
			return FALSE
		if(vote && 1<=vote && vote<=choices.len)
			var/selected_option = choices[vote]
			if(vote_selections[usr.ckey] == selected_option)
				return vote
			if(usr.ckey in voted)
				remove_vote_for_ckey(usr.ckey)
			voted += usr.ckey
			var/vote_power = get_vote_power(usr)
			var/choice_name = selected_option
			if(mode == "storyteller")
				choice_name = get_storyteller_choice_name(selected_option)
			vote_selections[usr.ckey] = selected_option
			vote_powers[usr.ckey] = vote_power
			if(mode == "storyteller")
				storyteller_vote_log[usr.ckey] = list(
					"choice" = choice_name,
					"vote_power" = vote_power,
				)
				save_storyteller_vote_log(null, "active")
			choices[selected_option] += vote_power //check this
			return vote
	return FALSE

/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, initiator_key, vote_period)
	var/sound/vote_alert = new()
	vote_alert.file = null
	vote_alert.priority = 250
	vote_alert.channel = CHANNEL_ADMIN
	vote_alert.frequency = 1
	vote_alert.wait = 1
	vote_alert.repeat = 0
	vote_alert.status = SOUND_STREAM
	vote_alert.volume = 100

	if(!mode)
		if(started_time && initiator_key)
			var/next_allowed_time = (started_time + CONFIG_GET(number/vote_delay))
			if(mode)
				to_chat(usr, span_warning("There is already a vote in progress! please wait for it to finish."))
				return FALSE

			var/admin = FALSE
			var/ckey = ckey(initiator_key)
			if(GLOB.admin_datums[ckey])
				admin = TRUE

			if(next_allowed_time > world.time && !admin)
				to_chat(usr, span_warning("A vote was initiated recently, you must wait [DisplayTimeText(next_allowed_time-world.time)] before a new vote can be started!"))
				return FALSE

		reset()
		switch(vote_type)
			if("restart")
				choices.Add("Restart Round","Continue Playing")
			if("gamemode")
				choices.Add(config.votable_modes)	
			if("map")
				for(var/map in global.config.maplist)
					var/datum/map_config/VM = config.maplist[map]
					if(!VM.votable)
						continue
					var/player_count = GLOB.clients.len
					if(VM.config_max_users > 0 && player_count >= VM.config_max_users)
						continue
					if(VM.config_min_users > 0 && player_count <= VM.config_min_users)
						continue
					choices.Add(VM.map_name)
			if("custom")
				question = stripped_input(usr,"What is the vote for?")
				if(!question)
					return FALSE
				for(var/i=1,i<=10,i++)
					var/option = capitalize(stripped_input(usr,"Please enter an option or hit cancel to finish"))
					if(!option || mode || !usr.client)
						break
					choices.Add(option)
			if("endround")
				initiator_key = pick("Psydon", "Zizo")
				choices.Add("Continue Playing","End Round")
				vote_alert.file = 'sound/roundend/roundend-vote-sound.ogg'
			if("storyteller")
				choices.Add(SSgamemode.storyteller_vote_choices())
				vote_width = 900
				vote_height = 600 // Give more room for storyteller
				panel_refresh_interval = STORYTELLER_VOTE_PANEL_REFRESH_INTERVAL
			else
				return FALSE
		message_admins(span_danger("Admin [key_name_admin(usr)] start a vote of [vote_type]!"))
		log_admin("Admin [key_name_admin(usr)] start a vote of [vote_type]!")
		mode = vote_type
		initiator = initiator_key
		started_time = world.time
		var/text = "[capitalize(mode)] vote started by [initiator]."
		if(mode == "storyteller")
			text = initiator
		if(mode == "custom")
			text += "\n[question]"
		log_vote(text)
		var/vp
		if(vote_period)
			vp = vote_period
			custom_vote_period = vote_period
		else
			vp = CONFIG_GET(number/vote_period)
		if(vote_alert.file)
			for(var/mob/M in GLOB.player_list)
				SEND_SOUND(M, vote_alert)
		if(mode == "storyteller")
			save_storyteller_vote_log(null, "active")
		to_chat(world, "\n<font color='purple'><b>[text]</b>\nClick <a href='?src=[REF(src)]'>here</a> to place your vote.\nYou have [DisplayTimeText(vp)] to vote.</font>")
		for(var/client/C in GLOB.clients)
			if(!isliving(C.mob))
				show_vote(C)
		next_panel_refresh = world.time + panel_refresh_interval
		time_remaining = round(vp/10)
		return TRUE
	return FALSE

// Helper for sending an active vote to someone who has just logged in 
/datum/controller/subsystem/vote/proc/send_vote(client/C)
	if(!mode || !C)
		return
	var/text = "[capitalize(mode)] vote started by [initiator]."
	if(mode == "custom")
		text += "\n[question]"
	var/remaining_time = time_remaining * 10
	to_chat(C, "\n<font color='purple'><b>[text]</b>\nClick <a href='?src=[REF(src)]'>here</a> to place your vote.\nYou have [DisplayTimeText(remaining_time)] to vote.</font>")
	if(!isliving(C.mob))
		show_vote(C)

/datum/controller/subsystem/vote/proc/interface(client/C)
	if(!C)
		return
	var/admin = 0
	var/trialmin = 0
	if(C.holder)
		admin = 1
		if(check_rights_for(C, R_ADMIN))
			trialmin = 1
	voting |= C

	if(mode)
		if(question)
			. += "<h2>Vote: '[question]'</h2>"
		else
			. += "<h2>Vote: [capitalize(mode)]</h2>"
		. += "Time Left: [time_remaining] s<hr>"
		var/can_vote = can_client_vote(C)
		if(mode == "storyteller")
			if(!length(storyteller_vote_log))
				load_storyteller_vote_log()
			var/pool_text = "Check the (?) for a description of each storyteller. Roundstart hard antags require [HARD_ANTAG_MIN_POP] active pop. Successful votes remove the storyteller pool."
			. += "<div style='color:#992414;font-size:0.9rem;margin-bottom:6px;'>[pool_text]</div>"
			. += render_storyteller_choices(can_vote, C)
		else
			. += "<ul>"
			var/selected_option = vote_selections[C.ckey]
			for(var/i=1,i<=choices.len,i++)
				var/choice_text = choices[i]
				var/votes = choices[choice_text]
				if(!votes)
					votes = 0
				var/selected_text = selected_option == choice_text ? " <b>(current vote)</b>" : ""
				if(can_vote)
					. += "<li><a href='?src=[REF(src)];vote=[i]'>[choice_text]</a>[selected_text] ([votes] votepwr)</li>"
				else
					. += "<li>[choice_text][selected_text] ([votes] votepwr)</li>"
			. += "</ul>"
		. += "<hr>"
		if(admin)
			. += "(<a href='?src=[REF(src)];vote=cancel'>Cancel Vote</a>) "
	else
		. += "<h2>Start a vote:</h2><hr><ul><li>"
		//restart
		var/avr = CONFIG_GET(flag/allow_vote_restart)
		if(trialmin || avr)
			. += "<a href='?src=[REF(src)];vote=restart'>Restart</a>"
		else
			. += "<font color='grey'>Restart (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='?src=[REF(src)];vote=toggle_restart'>[avr ? "Allowed" : "Disallowed"]</a>)"
		. += "</li><li>"
		//gamemode
		var/avm = CONFIG_GET(flag/allow_vote_mode)
		if(trialmin || avm)
			. += "<a href='?src=[REF(src)];vote=gamemode'>GameMode</a>"
		else
			. += "<font color='grey'>GameMode (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='?src=[REF(src)];vote=toggle_gamemode'>[avm ? "Allowed" : "Disallowed"]</a>)"

		. += "</li>"
		//map
		var/avmap = CONFIG_GET(flag/allow_vote_map)
		if(trialmin || avmap)
			. += "<a href='?src=[REF(src)];vote=map'>Map</a>"
		else
			. += "<font color='grey'>Map (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='?src=[REF(src)];vote=toggle_map'>[avmap ? "Allowed" : "Disallowed"]</a>)"

		. += "</li>"
		//custom
		if(trialmin)
			. += "<li><a href='?src=[REF(src)];vote=custom'>Custom</a></li>"
		. += "</ul><hr>"
	. += "<a href='?src=[REF(src)];vote=close' style='position:absolute;top:8px;right:18px;padding:3px 8px;border:1px solid #6e2b33;border-radius:999px;background:rgba(18,12,14,0.96);color:#e06b75;font-size:0.8rem;font-weight:bold;text-decoration:none;line-height:1.2;'>Close</a>"
	return .


/datum/controller/subsystem/vote/Topic(href,href_list[],hsrc)
	if(!usr || !usr.client)
		return	//not necessary but meh...just in-case somebody does something stupid

	var/trialmin = 0
	if(usr.client.holder)
		if(check_rights_for(usr.client, R_ADMIN))
			trialmin = 1

	switch(href_list["vote"])
		if("close")
			voting -= usr.client
			usr << browse(null, "window=vote")
			return
		if("cancel")
			if(usr.client.holder)
				if(!mode)
					return
				if(alert(usr, "Are you sure you want to cancel this [mode] vote?", "Cancel Vote", "Yes", "No") != "Yes")
					return
				if(!mode)
					return
				if(mode == "storyteller")
					save_storyteller_vote_log(null, "cancelled")
				if(mode == "endround")
					GLOB.round_timer = world.time + ROUND_EXTENSION_TIME // admin cancels an endround, defaults to same as continue playing
				log_admin("[key_name(usr)] canceled the [mode] vote.")
				message_admins("[key_name_admin(usr)] canceled the [mode] vote.")
				reset()

		if("toggle_restart")
			if(usr.client.holder && trialmin)
				CONFIG_SET(flag/allow_vote_restart, !CONFIG_GET(flag/allow_vote_restart))
		if("toggle_gamemode")
			if(usr.client.holder && trialmin)
				CONFIG_SET(flag/allow_vote_mode, !CONFIG_GET(flag/allow_vote_mode))
		if("toggle_map")
			if(usr.client.holder && trialmin)
				CONFIG_SET(flag/allow_vote_map, !CONFIG_GET(flag/allow_vote_map))
		if("restart")
			if(CONFIG_GET(flag/allow_vote_restart) || usr.client.holder)
				initiate_vote("restart",usr.key)
		if("gamemode")
			if(CONFIG_GET(flag/allow_vote_mode) || usr.client.holder)
				initiate_vote("gamemode",usr.key)
		if("map")
			if(CONFIG_GET(flag/allow_vote_map) || usr.client.holder)
				initiate_vote("map",usr.key)
		if("custom")
			if(usr.client.holder)
				initiate_vote("custom",usr.key)
		else
			submit_vote(round(text2num(href_list["vote"])))
	usr.vote()

/datum/controller/subsystem/vote/proc/remove_action_buttons()
	for(var/v in generated_actions)
		var/datum/action/vote/V = v
		if(!QDELETED(V))
			V.remove_from_client()
			V.Remove(V.owner)
	generated_actions = list()

/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"
	SSvote.show_vote(client)

/datum/action/vote
	name = "Vote!"
	button_icon_state = "vote"

/datum/action/vote/Trigger()
	if(owner)
		owner.vote()
		remove_from_client()
		Remove(owner)

/datum/action/vote/IsAvailable()
	return TRUE

/datum/action/vote/proc/remove_from_client()
	if(!owner)
		return
	if(owner.client)
		owner.client.player_details.player_actions -= src
	else if(owner.ckey)
		var/datum/player_details/P = GLOB.player_details[owner.ckey]
		if(P)
			P.player_actions -= src

#undef LAST_STORYTELLER_VOTE_LOG_FILE
#undef DEFAULT_VOTE_PANEL_REFRESH_INTERVAL
#undef STORYTELLER_VOTE_PANEL_REFRESH_INTERVAL
