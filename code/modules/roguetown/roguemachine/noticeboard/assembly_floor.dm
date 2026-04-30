/obj/structure/roguemachine/noticeboard/proc/open_assembly_tgui(mob/user)
	if(!ishuman(user))
		return
	var/datum/tgui/ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "CityAssembly")
		ui.open()

/obj/structure/roguemachine/noticeboard/proc/build_assembly_summary_html()
	var/list/lines = list()
	lines += "<h2>The City Assembly</h2>"
	lines += "<hr></center>"
	if(!SScity_assembly)
		lines += "<i>The Assembly has not yet convened.</i>"
		return lines.Join("")
	var/mob/alderman = SScity_assembly.resolve_get_alderman()
	lines += "<b>Alderman:</b> [alderman ? alderman.real_name : "(vacant)"]<br>"
	var/datum/assembly_warrant/W = SScity_assembly.current_warrant
	if(W)
		lines += "<b>Trade Warrant:</b> [W.trade_remaining]m / [W.trade_daily_cap]m per day<br>"
		lines += "<b>Defense Warrant:</b> [W.defense_remaining]p / [W.defense_daily_cap]p per day<br>"
	lines += "<b>Session:</b> #[SScity_assembly.session_counter] - next resolution at [build_next_resolution_label()]<br>"
	lines += "<hr>"
	lines += "<a href='?src=[REF(src)];open_assembly=1'><b>&#91; Enter the Assembly Floor &#93;</b></a>"
	lines += "<hr>"
	if(length(SScity_assembly.history))
		lines += "<h3>Previous Sessions</h3>"
		var/start = max(1, length(SScity_assembly.history) - 2)
		for(var/i in start to length(SScity_assembly.history))
			var/list/entry = SScity_assembly.history[i]
			lines += "<div style='margin-bottom:8px'><b>Session [entry["session"]]</b><br>"
			lines += SScity_assembly.build_summary_text(entry)
			lines += "</div><hr>"
	return lines.Join("")

/obj/structure/roguemachine/noticeboard/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/noticeboard/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CityAssembly")
		ui.open()

/obj/structure/roguemachine/noticeboard/ui_static_data(mob/user)
	return list(
		"trade_brackets" = ASSEMBLY_TRADE_BRACKETS,
		"defense_brackets" = ASSEMBLY_DEFENSE_BRACKETS,
		"poll_brackets" = ASSEMBLY_POLL_BRACKETS,
		"quorum_voters" = ASSEMBLY_QUORUM_VOTERS,
		"recall_threshold_pct" = ASSEMBLY_RECALL_THRESHOLD_PCT,
		"censure_threshold_pct" = ASSEMBLY_CENSURE_THRESHOLD_PCT,
		"nae_veto_pct" = ASSEMBLY_NAE_VETO_PCT,
	)

/obj/structure/roguemachine/noticeboard/ui_data(mob/user)
	var/list/data = list()
	data["day"] = GLOB.dayspassed
	data["session_number"] = SScity_assembly?.session_counter || 0
	data["next_resolution"] = build_next_resolution_label()
	data["next_resolution_seconds"] = build_next_resolution_seconds()

	var/mob/alderman = SScity_assembly?.resolve_get_alderman()
	data["current_alderman"] = alderman ? alderman.real_name : null
	data["is_alderman"] = SScity_assembly?.is_alderman(user) ? TRUE : FALSE
	data["is_censured"] = HAS_TRAIT(user, TRAIT_ALDERMAN_CENSURED) ? TRUE : FALSE
	data["is_outlaw"] = HAS_TRAIT(user, TRAIT_OUTLAW) ? TRUE : FALSE
	data["my_weight_doubled"] = SScity_assembly?.get_vote_weight(user) || 0

	var/datum/assembly_warrant/W = SScity_assembly?.current_warrant
	if(W)
		data["warrant"] = list(
			"trade_cap" = W.trade_daily_cap,
			"trade_remaining" = W.trade_remaining,
			"defense_cap" = W.defense_daily_cap,
			"defense_remaining" = W.defense_remaining,
		)
	else
		data["warrant"] = null

	var/datum/weakref/user_wr = WEAKREF(user)
	var/datum/assembly_session/S = SScity_assembly?.current_session
	var/list/my_votes = list()
	if(S)
		for(var/motion_id in S.ballots)
			var/list/entry = S.ballots[motion_id][user_wr]
			my_votes[motion_id] = entry ? entry["choice"] : null
	data["my_votes"] = my_votes
	data["voter_count"] = S ? S.count_distinct_voters() : 0
	data["quorate"] = (data["voter_count"] >= ASSEMBLY_QUORUM_VOTERS) ? TRUE : FALSE

	var/list/candidates = list()
	if(S)
		for(var/datum/weakref/wr in S.candidates)
			var/mob/cand = wr.resolve()
			if(!cand)
				continue
			var/cand_job = cand.job || "no station"
			var/list/pledge_entry = S.candidates[wr]
			candidates += list(list(
				"ref" = "[wr]",
				"name" = pledge_entry["name"],
				"job" = cand_job,
				"pledge" = pledge_entry["pledge"],
				"is_me" = (wr == user_wr) ? TRUE : FALSE,
				"is_alderman" = (alderman == cand) ? TRUE : FALSE,
			))
	data["candidates"] = candidates

	data["tallies"] = SScity_assembly?.preview_tallies() || list()

	var/list/history_trimmed = list()
	if(SScity_assembly)
		var/start = max(1, length(SScity_assembly.history) - 4)
		for(var/i in start to length(SScity_assembly.history))
			var/list/entry = SScity_assembly.history[i]
			history_trimmed += list(list(
				"session" = entry["session"],
				"day" = entry["day"],
				"text" = entry["rendered_text"] || SScity_assembly.build_summary_text(entry),
			))
	data["history"] = history_trimmed

	return data

/// Real-world seconds until the next Assembly resolution. Before Session 1 fires, this is
/// the countdown to the scheduled first-session timer; after, it's time until the next
/// in-game dawn (when day-tick resolutions fire).
/obj/structure/roguemachine/noticeboard/proc/build_next_resolution_seconds()
	if(!SScity_assembly)
		return 0
	// Pre-first-session: use the first-session timer anchor if it's armed.
	if(SScity_assembly.first_session_resolve_at > world.time)
		return round((SScity_assembly.first_session_resolve_at - world.time) / 10)
	// Otherwise countdown to the next dawn (when day-tick resolutions fire).
	if(!SSnightshift || !SSticker)
		return 0
	var/current_station_time = station_time()
	var/dawn_at = SSnightshift.nightshift_dawn_start
	var/game_ds_until_dawn
	if(current_station_time < dawn_at)
		game_ds_until_dawn = dawn_at - current_station_time
	else
		// Already past today's dawn; next dawn is tomorrow.
		game_ds_until_dawn = (864000 - current_station_time) + dawn_at
	var/rate = SSticker.station_time_rate_multiplier || 1
	if(rate <= 0)
		rate = 1
	return round((game_ds_until_dawn / rate) / 10)

/obj/structure/roguemachine/noticeboard/proc/build_next_resolution_label()
	if(SScity_assembly?.first_session_resolve_at > world.time)
		return "the first session (~[ASSEMBLY_FIRST_SESSION_MINUTES]m post roundstart)"
	return "the next dawn"

/obj/structure/roguemachine/noticeboard/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(!usr.canUseTopic(src, BE_CLOSE))
		return TRUE
	if(!SScity_assembly)
		return TRUE
	switch(action)
		if("cast_vote")
			var/motion_id = params["motion"]
			var/choice = params["choice"]
			if(!motion_id || isnull(choice))
				return TRUE
			SScity_assembly.cast_vote(usr, motion_id, choice)
			return TRUE
		if("retract_vote")
			var/motion_id = params["motion"]
			if(!motion_id)
				return TRUE
			SScity_assembly.retract_vote(usr, motion_id)
			return TRUE
		if("declare_candidacy")
			var/pledge = params["pledge"] || ""
			SScity_assembly.declare_candidacy(usr, pledge)
			return TRUE
		if("withdraw_candidacy")
			SScity_assembly.withdraw_candidacy(usr)
			return TRUE
		if("resign_alderman")
			if(SScity_assembly.is_alderman(usr) && ishuman(usr))
				// Snapshot identity BEFORE demotion - once demoted the alderman_ref is cleared
				// and there's no mob to attribute the announcement to.
				var/mob/living/carbon/human/resigner = usr
				var/resign_name = resigner.real_name
				var/resign_job = resigner.job
				SScity_assembly.demote_alderman("resigned voluntarily")
				SScity_assembly.notify_alderman_lost_ref(resign_name, resign_job, "resigned")
			return TRUE
		if("alderman_trade")
			// Alderman acts from the Commons' own board, not the Stewardry's locked Nerve Master.
			// Bypasses the physical-access problem (the Stewardry is locked against them) without
			// bypassing the warrant cap (the Steward machine's own gate still enforces it).
			if(!SScity_assembly.is_alderman(usr))
				to_chat(usr, span_warning("Only the sitting Alderman may open the trade writ."))
				return TRUE
			if(!SScity_assembly.current_warrant || SScity_assembly.current_warrant.trade_remaining <= 0)
				to_chat(usr, span_warning("The Commons have set no trade warrant for you, or its coin is spent for the day."))
				return TRUE
			if(!SStreasury.steward_machine)
				to_chat(usr, span_warning("The Nerve Master is not present in the Realm."))
				return TRUE
			SStreasury.steward_machine.open_trade_tgui(usr)
			return TRUE
