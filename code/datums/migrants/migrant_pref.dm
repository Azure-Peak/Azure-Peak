/datum/migrant_pref
	var/datum/preferences/prefs
	/// Wave typepath the player is queued for, or null.
	var/queued_wave = null
	/// Role typepath within the queued wave the player wants, or null for any.
	var/queued_role = null
	var/viewer = FALSE

/datum/migrant_pref/New(datum/preferences/passed_prefs)
	. = ..()
	prefs = passed_prefs

/datum/migrant_pref/proc/queue_for(wave_type, role_type)
	var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
	if(!wave)
		return
	// Hidden waves are only queueable while an admin has them forced and forming.
	if(wave.hidden && !SSmigrants.is_forced_forming(wave_type))
		return
	if(role_type && !SSmigrants.can_fill_role(prefs.parent, role_type))
		to_chat(prefs.parent, span_warning("Your character can't be this role. (Wrong species, faith, age, or reputation.)"))
		return
	queued_wave = wave_type
	queued_role = role_type
	if(prefs.parent)
		var/datum/migrant_role/role = role_type ? MIGRANT_ROLE(role_type) : null
		to_chat(prefs.parent, span_nicegreen("You are queued for [wave.name][role ? " as the [role.name]" : ""]. This does not guarantee a slot."))

/datum/migrant_pref/proc/clear_queue(silent = FALSE)
	if(!queued_wave)
		return
	queued_wave = null
	queued_role = null
	if(!silent && prefs.parent)
		to_chat(prefs.parent, span_boldwarning("You are no longer in the migrant queue."))

/datum/migrant_pref/proc/post_spawn()
	clear_queue(silent = TRUE)
	hide_ui()

/datum/migrant_pref/ui_state(mob/user)
	return GLOB.always_state

/datum/migrant_pref/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MigrantPanel")
		ui.open()
	viewer = TRUE

/datum/migrant_pref/ui_close(mob/user)
	viewer = FALSE

/datum/migrant_pref/ui_data(mob/user)
	var/client/client = prefs.parent
	var/list/data = list()
	data["server_time"] = world.time
	data["wave_number"] = SSmigrants.wave_number
	data["player_triumph"] = client ? SStriumphs.get_triumphs(client.ckey) : 0
	data["active_migrants"] = SSmigrants.get_active_migrant_amount()
	data["round_time"] = world.time - SSticker.round_start_time
	data["queued_wave"] = queued_wave ? "[queued_wave]" : null
	data["queued_role"] = queued_role ? "[queued_role]" : null

	var/list/forming = list()
	for(var/track in list(MIGRANT_TRACK_REGULAR, MIGRANT_TRACK_SPECIAL, MIGRANT_TRACK_TRIUMPH, MIGRANT_TRACK_EVENT))
		var/wave_type = SSmigrants.track_forming[track]
		if(!wave_type)
			continue
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		var/is_forced = SSmigrants.track_forced[track]
		// Hidden waves stay out of the panel unless an admin forced them (then they're shown + queueable).
		if(wave.hidden && !is_forced)
			continue
		forming += list(list(
			"track" = track,
			"ref" = "[wave_type]",
			"name" = wave.name,
			"arrival_at" = SSmigrants.track_arrival[track],
			"queued" = (queued_wave == wave_type),
			"min_optional_fills" = wave.min_optional_fills,
			"roles" = build_role_data(wave),
		))
	data["forming"] = forming
	data["next_regular_at"] = SSmigrants.track_next_roll[MIGRANT_TRACK_REGULAR]
	data["next_special_at"] = SSmigrants.track_next_roll[MIGRANT_TRACK_SPECIAL]

	var/list/track_total_weight = list()
	for(var/wave_type in GLOB.migrant_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		if(wave.hidden || !wave.can_roll || wave.is_raid)
			continue
		if(wave.triumph_only) // doesn't compete in the natural roll, so keep it out of the odds math
			continue
		track_total_weight[wave.track] += SSmigrants.calculate_triumph_weight(wave)

	var/list/waves = list()
	for(var/wave_type in GLOB.migrant_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		if(wave.hidden || !wave.can_roll || wave.is_raid)
			continue
		var/maxed = FALSE
		if(!isnull(wave.max_spawns))
			var/used_wave_type = wave.shared_wave_type ? wave.shared_wave_type : wave.type
			if(SSmigrants.spawned_waves[used_wave_type] && SSmigrants.spawned_waves[used_wave_type] >= wave.max_spawns)
				maxed = TRUE
		var/locked_until = 0
		if(wave.min_round_time && (world.time - SSticker.round_start_time) < wave.min_round_time)
			locked_until = SSticker.round_start_time + wave.min_round_time
		var/total = track_total_weight[wave.track]
		var/roll_chance = (total && !wave.triumph_only) ? round((SSmigrants.calculate_triumph_weight(wave) / total) * 100, 0.1) : 0
		waves += list(list(
			"ref" = "[wave_type]",
			"name" = wave.name,
			"track" = wave.track,
			"weight" = wave.weight,
			"roll_chance" = roll_chance,
			"triumph_total" = wave.triumph_total,
			"triumph_threshold" = wave.triumph_threshold,
			"my_contribution" = client ? (wave.triumph_contributions[client.ckey] || 0) : 0,
			"maxed" = maxed,
			"locked_until" = locked_until,
			"queued" = (queued_wave == wave_type),
			"min_optional_fills" = wave.min_optional_fills,
			"roles" = build_role_data(wave),
		))
	data["waves"] = waves
	return data

/datum/migrant_pref/proc/build_role_data(datum/migrant_wave/wave)
	var/list/rows = list()
	for(var/role_type in wave.required_roles)
		rows += list(build_role_entry(role_type, wave.required_roles[role_type], "required"))
	for(var/role_type in wave.optional_roles)
		rows += list(build_role_entry(role_type, wave.optional_roles[role_type], "optional"))
	return rows

/datum/migrant_pref/proc/build_role_entry(role_type, amount, kind)
	var/datum/migrant_role/role = MIGRANT_ROLE(role_type)
	var/list/pool = SSmigrants.get_role_pool(role_type)
	var/enumerate = length(pool) && length(pool) <= MIGRANT_ROLE_OPTION_LIMIT
	var/list/options = list()
	var/playable_count = 0
	for(var/datum/advclass/advclass as anything in pool)
		var/reason = advclass.prefs_lock_reason(prefs)
		if(isnull(reason))
			playable_count++
		if(enumerate)
			options += list(list(
				"name" = advclass.name,
				"playable" = isnull(reason),
				"reason" = reason,
			))
	var/can_be = SSmigrants.can_be_role(prefs.parent, role_type)
	if(length(pool) && !playable_count)
		can_be = FALSE
	return list(
		"ref" = "[role_type]",
		"name" = role.name,
		"amount" = amount,
		"kind" = kind,
		"stars" = SSmigrants.get_stars_on_role(role_type),
		"queued" = (queued_role == role_type),
		"can_be" = can_be,
		"desc" = role.greet_text,
		"options" = options,
		"option_count" = length(pool),
		"playable_count" = playable_count,
	)

/datum/migrant_pref/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("queue_role")
			var/wave_type = text2path(params["wave"])
			var/role_type = text2path(params["role"])
			if(!wave_type)
				return TRUE
			if(queued_wave == wave_type && queued_role == role_type)
				clear_queue()
			else
				queue_for(wave_type, role_type)
			return TRUE
		if("clear_queue")
			clear_queue()
			return TRUE
		if("buy_wave")
			var/wave_type = text2path(params["wave"])
			if(wave_type)
				handle_triumph_contribution(wave_type)
			return TRUE

/datum/migrant_pref/proc/handle_triumph_contribution(wave_type)
	var/client/client = prefs.parent
	if(!client)
		return
	var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
	if(!wave || wave.hidden || !wave.can_roll || wave.is_raid)
		return
	var/current_triumph = SStriumphs.get_triumphs(client.ckey)
	if(current_triumph <= 0)
		to_chat(client, span_warning("You don't have any triumph to contribute!"))
		return
	var/player_contribution = wave.triumph_contributions[client.ckey] ? wave.triumph_contributions[client.ckey] : 0
	var/max_contribute = min(current_triumph, 100)
	var/amount = tgui_input_number(client, "Contribute triumph to '[wave.name]'?\n\nYour triumph: [current_triumph]\nYour contribution: [player_contribution]\nWave total: [wave.triumph_total]/[wave.triumph_threshold]", "Triumph Contribution", max_value = max_contribute, min_value = 1)
	if(!amount || amount <= 0 || amount > max_contribute)
		return
	SSmigrants.contribute_triumph_to_wave(client, wave_type, amount)

/datum/migrant_pref/proc/show_ui()
	var/client/client = prefs.parent
	if(!client)
		return
	ui_interact(client.mob)

/datum/migrant_pref/proc/hide_ui()
	var/client/client = prefs.parent
	if(!client)
		return
	SStgui.close_uis(src)
	viewer = FALSE
