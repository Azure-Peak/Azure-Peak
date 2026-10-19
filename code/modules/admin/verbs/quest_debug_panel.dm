GLOBAL_DATUM_INIT(quest_debug_panel, /datum/quest_debug_panel, new)

// Blockade Defense requires a blockade and GM quests require custom variables, this make sure quest debug panel cannot issue them
GLOBAL_LIST_INIT(quest_debug_unissuable_types, list(
	QUEST_BLOCKADE_DEFENSE,
	QUEST_GM_KILL,
	QUEST_GM_RECOVERY,
))

/client/proc/cmd_admin_quest_debug_panel()
	set category = "Debug"
	set name = "Quest Debug Panel"
	set desc = "Issue, inspect and complete contracts for testing purpose."

	if(!check_rights(R_ADMIN|R_DEBUG))
		return
	GLOB.quest_debug_panel.ui_interact(usr)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Quest Debug Panel")

/datum/quest_debug_panel

/datum/quest_debug_panel/ui_state(mob/user)
	if(user.client && check_rights_for(user.client, R_ADMIN|R_DEBUG))
		return GLOB.always_state
	return GLOB.never_state

/datum/quest_debug_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "QuestDebugPanel", "Quest Debug Panel")
		ui.open()

/datum/quest_debug_panel/ui_static_data(mob/user)
	var/list/types = list()
	for(var/qtype in GLOB.quest_prototypes)
		if(!can_debug_issue(qtype))
			continue
		types += qtype
	var/list/regions = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		regions += TR.region_name
	var/list/towner_types = list()
	for(var/qtype in get_towner_prototypes())
		towner_types += qtype
	var/list/tiers = list()
	for(var/tier in GLOB.towner_posting_tiers)
		tiers += tier
	return list(
		"quest_types" = types,
		"towner_types" = towner_types,
		"regions" = regions,
		"towner_tiers" = tiers,
		"hoard_type" = QUEST_HOARD_RECOVERY,
	)

/datum/quest_debug_panel/ui_data(mob/user)
	var/list/quests = list()
	var/list/seen = list()
	for(var/datum/quest/Q as anything in SSquestpool.pool | get_scroll_quests())
		if(seen[Q] || QDELETED(Q))
			continue
		seen[Q] = TRUE
		quests += list(quest_row(Q))
	return list(
		"debug_mode" = SSquestpool.debug_mode,
		"quests" = quests,
	)

/datum/quest_debug_panel/proc/quest_row(datum/quest/Q)
	var/datum/quest/kill/KQ = istype(Q, /datum/quest/kill) ? Q : null
	var/status = "unclaimed"
	if(Q.complete)
		status = "complete"
	else if(KQ?.failed)
		status = "failed"
	else if(Q in SSquestpool.pool)
		status = "pool"
	else if(Q.quest_receiver_reference)
		status = "active"
	var/timer_label
	var/timer_seconds = 0
	var/timer_id
	if(istype(Q, /datum/quest/kill/blockade_defense))
		var/datum/quest/kill/blockade_defense/BQ = Q
		if(BQ.armed)
			timer_label = "Awaiting arrival"
		else if(BQ.intermission_timer_id)
			timer_label = "Intermission before wave [BQ.current_wave + 1]"
			timer_id = BQ.intermission_timer_id
		else if(BQ.wave_timer_id)
			timer_label = "Wave [BQ.current_wave] timeout"
			timer_id = BQ.wave_timer_id
	else if(KQ?.hunt_timer_id)
		timer_label = "Hunt timeout"
		timer_id = KQ.hunt_timer_id
	if(timer_id)
		timer_seconds = round(max(timeleft(timer_id), 0) / 10)
	return list(
		"ref" = REF(Q),
		"type" = Q.quest_type,
		"title" = Q.title || Q.get_title(),
		"region" = Q.region,
		"holder" = Q.quest_receiver_name,
		"giver" = Q.quest_giver_name,
		"status" = status,
		"progress" = "[Q.progress_current]/[Q.progress_required]",
		"live_targets" = length(get_live_targets(Q)),
		"timer_label" = timer_label,
		"timer_seconds" = timer_seconds,
		"is_kill" = !!KQ,
	)

/datum/quest_debug_panel/proc/get_live_targets(datum/quest/Q)
	. = list()
	for(var/datum/weakref/W in Q.tracked_atoms)
		var/mob/living/L = W.resolve()
		if(!istype(L) || QDELETED(L) || L.stat == DEAD)
			continue
		. += L

/datum/quest_debug_panel/proc/get_jump_turf(datum/quest/Q)
	var/turf/T = Q.get_target_location()
	if(T)
		return T
	for(var/datum/weakref/W in Q.tracked_atoms)
		var/atom/A = W.resolve()
		if(A && !QDELETED(A))
			return get_turf(A)
	if(istype(Q, /datum/quest/kill/blockade_defense))
		var/datum/quest/kill/blockade_defense/BQ = Q
		var/obj/effect/landmark/quest_spawner/wave_landmark = BQ.wave_landmark_ref?.resolve()
		if(wave_landmark)
			return get_turf(wave_landmark)
	var/obj/effect/landmark/quest_spawner/landmark = Q.pending_landmark_ref?.resolve()
	return landmark ? get_turf(landmark) : null

/datum/quest_debug_panel/proc/skip_timer(datum/quest/Q)
	if(istype(Q, /datum/quest/kill/blockade_defense))
		var/datum/quest/kill/blockade_defense/BQ = Q
		if(BQ.armed)
			BQ.armed = FALSE
			BQ.spawn_wave(1)
			return "admin started wave 1"
		if(BQ.intermission_timer_id)
			var/next_wave = BQ.current_wave + 1
			BQ.clear_wave_timers()
			BQ.end_intermission(next_wave)
			return "admin ended a contract intermission (wave [next_wave])"
		if(BQ.wave_timer_id)
			var/wave = BQ.current_wave
			BQ.clear_wave_timers()
			BQ.on_wave_timeout(wave)
			return "admin fired wave [wave] timeout"
		return null
	if(istype(Q, /datum/quest/kill))
		var/datum/quest/kill/KQ = Q
		if(!KQ.hunt_timer_id)
			return null
		deltimer(KQ.hunt_timer_id)
		KQ.on_hunt_timeout()
		return "admin fired hunt timeout"
	return null

/datum/quest_debug_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("toggle_debug_mode")
			SSquestpool.debug_mode = !SSquestpool.debug_mode
			admin_log_fiscal("turned quest debug mode [SSquestpool.debug_mode ? "ON" : "OFF"]", "Quest Debug Mode")
			return TRUE
		if("issue")
			issue_contract(usr, params)
			return TRUE

	var/datum/quest/Q = locate(params["ref"])
	if(!istype(Q) || QDELETED(Q))
		return TRUE
	var/label = "[Q.quest_type] ([Q.title || Q.get_title()])"
	switch(action)
		if("jump")
			var/turf/T = get_jump_turf(Q)
			if(!T)
				to_chat(usr, span_warning("That contract has nothing to jump to."))
				return TRUE
			usr.forceMove(T)
			admin_log_fiscal("admin jumped to contract [label]", "Quest Debug Jump")
		if("slay")
			var/list/targets = get_live_targets(Q)
			if(!length(targets))
				to_chat(usr, span_warning("No live targets."))
				return TRUE
			for(var/mob/living/L as anything in targets)
				L.death()
			admin_log_fiscal("admin killed [length(targets)] target(s) of contract [label]", "Quest Debug Slay")
		if("skip_timer")
			var/result = skip_timer(Q)
			if(!result)
				to_chat(usr, span_warning("That contract has no timer running."))
				return TRUE
			admin_log_fiscal("[result] for contract [label]", "Quest Debug Skip Timer")
		if("complete")
			if(Q.complete)
				return TRUE
			Q.force_complete()
			admin_log_fiscal("admin force completed contract [label]", "Quest Debug Complete")
	return TRUE

/datum/quest_debug_panel/proc/can_debug_issue(qtype)
	return GLOB.quest_prototypes[qtype] && !(qtype in GLOB.quest_debug_unissuable_types)

/datum/quest_debug_panel/proc/issue_contract(mob/user, list/params)
	var/qtype = params["type"]
	if(!can_debug_issue(qtype))
		return
	var/datum/threat_region/TR = params["region"] ? SSregionthreat.get_region(params["region"]) : null
	var/in_hand = !!params["in_hand"]
	var/mob/living/carbon/human/H = user
	if((in_hand || get_towner_prototype(qtype) || qtype == QUEST_HOARD_RECOVERY) && !istype(H))
		to_chat(user, span_warning("You need to be in a human body to receive that contract."))
		return
	var/datum/quest/Q
	if(get_towner_prototype(qtype))
		var/tier = params["tier"]
		if(!(tier in GLOB.towner_posting_tiers))
			tier = TOWNER_POSTING_TIER_MEDIUM
		Q = SSquestpool.issue_towner_quest(qtype, H, tier, in_hand)
	else if(qtype == QUEST_HOARD_RECOVERY)
		if(!TR)
			to_chat(user, span_warning("Pick a region for a Hoard Recovery."))
			return
		Q = SSquestpool.issue_hoard_recovery_request(TR, H, TRUE)
	else
		Q = SSquestpool.issue_player_quest(qtype, QUEST_SOURCE_POOL, TR, null, in_hand, in_hand ? H : null)
	if(!Q)
		to_chat(user, span_warning("No landmark could take a [qtype] contract[TR ? " in [TR.region_name]" : ""]."))
		return
	admin_log_fiscal("admin-issued a [qtype] contract ([Q.region || "any region"], [in_hand ? "in hand" : "to the ledger"])", "Quest Debug Issue")
