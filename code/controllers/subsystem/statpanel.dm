SUBSYSTEM_DEF(statpanels)
	name = "Stat Panels"
	wait = 4
	priority = FIRE_PRIORITY_STATPANEL
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	flags = SS_NO_INIT
	var/list/currentrun = list()
	var/list/global_data
	var/list/mc_data

	///how many subsystem fires between most tab updates
	var/default_wait = 10
	///how many subsystem fires between updates of the status tab
	var/status_wait = 2
	///how many subsystem fires between updates of the MC tab
	var/mc_wait = 5
	///how many full runs this subsystem has completed. used for variable rate refreshes.
	var/num_fires = 0

/datum/controller/subsystem/statpanels/fire(resumed = FALSE)
	if (!resumed)
		num_fires++
		var/datum/map_config/cached = SSmapping.next_map_config

		if(isnull(SSmapping.config))
			global_data = list("Loading")
		else
			global_data = list("Map: [SSmapping.config.map_name]")

		// if(SSmapping.config?.mapping_url)
		// 	global_data += list(list("same_line", " | (View in Browser)", "action=openWebMap"))

		if(cached)
			global_data += "Next Map: [cached.map_name]"


		var/true_round_time = "[ROUND_TIME()]"
		if(SSticker.HasRoundStarted())
			true_round_time = "[DisplayTimeText(world.time - SSticker.round_start_time, 1)]"
		global_data += list(
			"Round ID: [GLOB.rogue_round_id ? GLOB.rogue_round_id : "NULL"]",
			"Server Time: [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss", world.timezone)]",
			"Round Time: [true_round_time]",
			"In-Character Time: [station_time_timestamp()]",
			"Time of Day: [GLOB.tod]",
			"Time Dilation: [round(SStime_track.time_dilation_current,1)]% AVG:([round(SStime_track.time_dilation_avg_fast,1)]%, [round(SStime_track.time_dilation_avg,1)]%, [round(SStime_track.time_dilation_avg_slow,1)]%)",
		)

		if(SSgamemode.roundvoteend)
			var/ticker_time = world.time - SSticker.round_start_time
			var/time_left = SSgamemode.round_ends_at - ticker_time
			global_data += "Round End: [DisplayTimeText(time_left, 1)]"

		if(SSticker.ready_for_reboot)
			global_data += "Reboot: DELAYED"

		src.currentrun = GLOB.clients.Copy()
		mc_data = null

	var/list/currentrun = src.currentrun
	while(length(currentrun))
		var/client/target = currentrun[length(currentrun)]
		currentrun.len--

		if(!target.stat_panel.is_ready())
			continue

		if(target.stat_tab == "Status" && num_fires % status_wait == 0)
			set_status_tab(target)

		if(!target.holder)
			target.stat_panel.send_message("remove_admin_tabs")
		else
			if(!("MC" in target.panel_tabs) || !("Tickets" in target.panel_tabs))
				target.stat_panel.send_message("add_admin_tabs", target.holder.href_token)

			if(target.stat_tab == "MC" && ((num_fires % mc_wait == 0)))
				set_MC_tab(target)

			if(target.stat_tab == "Tickets" && num_fires % default_wait == 0)
				set_tickets_tab(target)

			if(!length(GLOB.sdql2_queries) && ("SDQL2" in target.panel_tabs))
				target.stat_panel.send_message("remove_sdql2")

			else if(length(GLOB.sdql2_queries) && (target.stat_tab == "SDQL2" || !("SDQL2" in target.panel_tabs)) && num_fires % default_wait == 0)
				set_SDQL2_tab(target)

		if(target.mob)
			var/mob/target_mob = target.mob

			// Handle the action panels of the stat panel

			var/update_actions = FALSE
			// // We're on a spell tab, update the tab so we can see cooldowns progressing and such
			// if(target.stat_tab in target.spell_tabs)
			// 	update_actions = TRUE
			// // We're not on a spell tab per se, but we have cooldown actions, and we've yet to
			// // set up our spell tabs at all
			// if(!length(target.spell_tabs) && locate(/datum/action/cooldown) in target_mob.actions)
			// 	update_actions = TRUE

			if(update_actions && num_fires % default_wait == 0)
				set_action_tabs(target, target_mob)

		if(MC_TICK_CHECK)
			return

/*
 * send_message for the stat panel can be sent 1 of 4 things:
 * 1- A string entry, to show up as plain text.
 * 2- An empty string (""), which will translate to a new line, to for a break between lines.
 * 3- a list, in which the first entry is plain text, the second entry is highlighted text, and the third entry is a link
 * that clicking the second entry will take you to.
 * 4- a list with "same_line" as the first entry, which will automatically put it on the line above it,
 * with the second/third entry matching #3 (text & url), allowing you to have 2 clickable links on one line.
 */
/datum/controller/subsystem/statpanels/proc/set_status_tab(client/target)
	if(!global_data)//statbrowser hasnt fired yet and we were called from immediate_send_stat_data()
		return
	target.stat_panel.send_message("update_stat", list(
		"global_data" = global_data,
		"ping_str" = "Ping: [round(target.lastping, 1)]ms (Average: [round(target.avgping, 1)]ms)",
		"other_str" = target.mob?.get_status_tab_items(),
	))

/datum/controller/subsystem/statpanels/proc/set_MC_tab(client/target)
	var/turf/eye_turf = get_turf(target.eye)
	var/coord_entry = COORD(eye_turf)
	if(!mc_data)
		generate_mc_data()
	target.stat_panel.send_message("update_mc", list("mc_data" = mc_data, "coord_entry" = coord_entry))

/datum/controller/subsystem/statpanels/proc/set_tickets_tab(client/target)
	return

/datum/controller/subsystem/statpanels/proc/set_SDQL2_tab(client/target)
	return

/// Set up the various action tabs.
/datum/controller/subsystem/statpanels/proc/set_action_tabs(client/target, mob/target_mob)
	// var/list/actions = target_mob.get_actions_for_statpanel()
	// target.spell_tabs.Cut()

	// for(var/action_data in actions)
	// 	target.spell_tabs |= action_data[1]

	// target.stat_panel.send_message("update_spells", list(spell_tabs = target.spell_tabs, actions = actions))

/datum/controller/subsystem/statpanels/proc/generate_mc_data()
	mc_data = list()
	for(var/line in SSstatpanel.mc_info_text)
		mc_data += list(list("", "[line]", ""))
	mc_data += list(list("", "Globals:", "Edit", text_ref(GLOB)))
	mc_data += list(list("", "[config]:", "Edit", text_ref(config)))
	mc_data += list(list("", "Master Controller:", "Edit", text_ref(Master)))
	mc_data += list(list("", "Failsafe Controller:", "Edit", text_ref(Failsafe)))
	mc_data += list(list("", "", ""))
	for(var/entry in SSstatpanel.mc_cache)
		var/datum/controller/subsystem/sub_system = entry["subsystem"]
		mc_data += list(list("", "[entry["title"]]", "[entry["msg"]]", text_ref(sub_system)))

///immediately update the active statpanel tab of the target client
/datum/controller/subsystem/statpanels/proc/immediate_send_stat_data(client/target)
	if(!target.stat_panel.is_ready())
		return FALSE

	if(target.stat_tab == "Status")
		set_status_tab(target)
		return TRUE

	var/mob/target_mob = target.mob

	// Handle actions

	var/update_actions = FALSE
	if(update_actions)
		set_action_tabs(target, target_mob)
		return TRUE

	if(!target.holder)
		return FALSE

	if(target.stat_tab == "MC")
		set_MC_tab(target)
		return TRUE

	if(target.stat_tab == "Tickets")
		set_tickets_tab(target)
		return TRUE

	if(!length(GLOB.sdql2_queries) && ("SDQL2" in target.panel_tabs))
		target.stat_panel.send_message("remove_sdql2")

	else if(length(GLOB.sdql2_queries) && target.stat_tab == "SDQL2")
		set_SDQL2_tab(target)

/// Stat panel window declaration
/client/var/datum/tgui_window/stat/stat_panel

/datum/tgui_window/stat/initialize(strict_mode, fancy, assets, inline_html, inline_js, inline_css)
	. = ..()
	send_message("build_topbar") // This is the best way of doing it... don't @ me
