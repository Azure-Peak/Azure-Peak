SUBSYSTEM_DEF(migrants)
	name = "Migrants"
	wait = 2 SECONDS
	runlevels = RUNLEVEL_GAME
	var/wave_number = 1

	var/wave_wait_time = 3 MINUTES
	var/regular_roll_interval = 5 MINUTES
	var/special_roll_interval = 18 MINUTES
	var/faction_fail_cooldown = 20 MINUTES
	var/raid_fail_cooldown = 30 MINUTES
	var/ooc_ping_interval = 5 MINUTES
	var/last_ooc_ping = 0

	var/list/track_forming = list()
	var/list/track_arrival = list()
	var/list/track_next_roll = list()
	var/list/track_forced = list()
	var/list/wave_cooldown = list()

	var/list/spawned_waves = list()
	var/list/global_triumph_contributions = list()

/datum/controller/subsystem/migrants/Initialize()
	track_next_roll[MIGRANT_TRACK_REGULAR] = world.time + 2 MINUTES
	track_next_roll[MIGRANT_TRACK_SPECIAL] = world.time + special_roll_interval
	return ..()

/datum/controller/subsystem/migrants/fire(resumed)
	process_track(MIGRANT_TRACK_REGULAR, regular_roll_interval, FALSE)
	process_track(MIGRANT_TRACK_SPECIAL, special_roll_interval, TRUE)
	process_triumph_track()
	process_event_track()
	update_ui()

/datum/controller/subsystem/migrants/proc/process_event_track()
	if(!track_forming[MIGRANT_TRACK_EVENT])
		return
	if(world.time < track_arrival[MIGRANT_TRACK_EVENT])
		return
	resolve_forming_wave(MIGRANT_TRACK_EVENT)

/datum/controller/subsystem/migrants/proc/process_track(track, roll_interval, announce)
	var/forming = track_forming[track]
	if(forming)
		if(world.time < track_arrival[track])
			return
		resolve_forming_wave(track)
		track_next_roll[track] = world.time + roll_interval
		return
	if(world.time < track_next_roll[track])
		return
	var/wave_type = roll_wave(track)
	if(wave_type)
		begin_forming(track, wave_type)
		if(announce)
			announce_special_wave(wave_type)
	track_next_roll[track] = world.time + roll_interval

/datum/controller/subsystem/migrants/proc/process_triumph_track()
	var/forming = track_forming[MIGRANT_TRACK_TRIUMPH]
	if(forming)
		if(world.time < track_arrival[MIGRANT_TRACK_TRIUMPH])
			return
		resolve_forming_wave(MIGRANT_TRACK_TRIUMPH)
		return
	var/wave_type = get_maxed_wave()
	if(wave_type)
		begin_forming(MIGRANT_TRACK_TRIUMPH, wave_type)
		announce_special_wave(wave_type)

/datum/controller/subsystem/migrants/proc/is_forced_forming(wave_type)
	for(var/track in track_forced)
		if(track_forced[track] && track_forming[track] == wave_type)
			return TRUE
	return FALSE

/datum/controller/subsystem/migrants/proc/begin_forming(track, wave_type, forced = FALSE)
	track_forming[track] = wave_type
	track_arrival[track] = world.time + wave_wait_time
	track_forced[track] = forced
	log_game("Migrants: [track] track rolled wave: [wave_type][forced ? " (forced)" : ""]")

/datum/controller/subsystem/migrants/proc/resolve_forming_wave(track)
	var/wave_type = track_forming[track]
	var/forced = track_forced[track]
	track_forming[track] = null
	track_arrival[track] = 0
	track_forced[track] = FALSE
	var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
	var/success = try_spawn_wave(wave, forced)
	if(success)
		log_game("Migrants: Successfully spawned wave: [wave_type]")
		wave_number++
		return
	log_game("Migrants: FAILED to spawn wave: [wave_type]")
	message_admins("MIGRANTS: Wave '[wave.name]' failed to assemble on the [track] track.")
	wave_cooldown[wave_type] = world.time + get_fail_cooldown(wave)
	for(var/client/client as anything in get_wave_candidates(wave_type))
		to_chat(client, span_boldwarning("The wave you queued for, [wave.name], failed to gather enough people and scattered into the mist. You have left the queue."))
	if(track == MIGRANT_TRACK_TRIUMPH)
		refund_wave_contributions(wave)
	reset_wave_queue(wave_type)

/datum/controller/subsystem/migrants/proc/get_fail_cooldown(datum/migrant_wave/wave)
	return wave.is_raid ? raid_fail_cooldown : faction_fail_cooldown

/datum/controller/subsystem/migrants/proc/try_spawn_wave(datum/migrant_wave/wave, forced = FALSE)
	var/list/active_migrants
	active_migrants = get_wave_candidates(wave.type)
	active_migrants = shuffle(active_migrants)
	if(!length(active_migrants))
		return FALSE

	var/list/picked_migrants = list()
	var/list/assignments = assemble_role_wave(wave, active_migrants, picked_migrants)
	if(isnull(assignments))
		return FALSE

	var/turf/spawn_location = get_spawn_turf_for_job(wave.spawn_landmark)
	var/atom/fallback_location = spawn_location

	var/list/turfs = get_safe_turfs_around_location(spawn_location)
	for(var/i in 1 to turfs.len)
		var/turf/turf = turfs[i]
		if(assignments.len < i)
			break
		var/datum/migrant_assignment/assignment = assignments[i]
		assignment.spawn_location = turf

	for(var/datum/migrant_assignment/assignment as anything in assignments)
		if(!assignment.spawn_location)
			assignment.spawn_location = fallback_location

	var/greet_text = pick_greet_text(wave, assignments.len)

	for(var/client/client as anything in picked_migrants)
		client.prefs.migrant.post_spawn()

	for(var/datum/migrant_assignment/assignment as anything in assignments)
		spawn_migrant(wave, assignment, wave.spawn_on_location, greet_text)

	var/used_wave_type = wave.type
	if(wave.shared_wave_type)
		used_wave_type = wave.shared_wave_type
	if(!spawned_waves[used_wave_type])
		spawned_waves[used_wave_type] = 0
	spawned_waves[used_wave_type] += 1

	reset_wave_contributions(wave)
	message_admins("MIGRANTS: Spawned wave: [wave.name] (players: [assignments.len]) at [ADMIN_VERBOSEJMP(spawn_location)]")

	return TRUE

/datum/controller/subsystem/migrants/proc/pick_greet_text(datum/migrant_wave/wave, fill_count)
	if(!length(wave.greet_text_by_fill))
		return wave.greet_text
	var/best_key = null
	for(var/key in wave.greet_text_by_fill)
		var/threshold = text2num(key)
		if(threshold > fill_count)
			continue
		if(isnull(best_key) || threshold > text2num(best_key))
			best_key = key
	if(isnull(best_key))
		return wave.greet_text
	return wave.greet_text_by_fill[best_key]

/datum/controller/subsystem/migrants/proc/assemble_role_wave(datum/migrant_wave/wave, list/active_migrants, list/picked_migrants)
	var/list/required = list()
	for(var/role_type in wave.required_roles)
		for(var/i in 1 to wave.required_roles[role_type])
			required += new /datum/migrant_assignment(role_type)
	required = shuffle(required)

	for(var/datum/migrant_assignment/assignment as anything in required)
		fill_assignment(assignment, active_migrants, picked_migrants, wave.type, prefer = TRUE)
		if(!assignment.client)
			fill_assignment(assignment, active_migrants, picked_migrants, wave.type, prefer = FALSE)
		if(!assignment.client)
			return null

	var/list/optional = list()
	for(var/role_type in wave.optional_roles)
		for(var/i in 1 to wave.optional_roles[role_type])
			optional += new /datum/migrant_assignment(role_type)
	optional = shuffle(optional)

	for(var/datum/migrant_assignment/assignment as anything in optional)
		fill_assignment(assignment, active_migrants, picked_migrants, wave.type, prefer = TRUE)
	for(var/datum/migrant_assignment/assignment as anything in optional)
		if(assignment.client)
			continue
		fill_assignment(assignment, active_migrants, picked_migrants, wave.type, prefer = FALSE)

	var/list/filled_optional = list()
	for(var/datum/migrant_assignment/assignment as anything in optional)
		if(assignment.client)
			filled_optional += assignment

	if(length(filled_optional) < wave.min_optional_fills)
		return null

	return required + filled_optional

/datum/controller/subsystem/migrants/proc/fill_assignment(datum/migrant_assignment/assignment, list/active_migrants, list/picked_migrants, wave_type, prefer = TRUE)
	if(assignment.client || !length(active_migrants))
		return
	var/list/candidates
	if(prefer)
		candidates = get_priority_players(active_migrants, assignment.role_type, wave_type)
	else
		candidates = active_migrants
	for(var/client/client as anything in candidates)
		if(!can_be_role(client, assignment.role_type))
			continue
		assignment.client = client
		active_migrants -= client
		picked_migrants += client
		return

/datum/controller/subsystem/migrants/proc/get_influenceable_waves()
	var/list/waves = list()
	for(var/wave_type in GLOB.migrant_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		if(!wave.can_roll)
			continue
		if(!wave.can_roll())
			continue
		if(!isnull(wave.max_spawns))
			var/used_wave_type = wave.type
			if(wave.shared_wave_type)
				used_wave_type = wave.shared_wave_type
			if(spawned_waves[used_wave_type] && spawned_waves[used_wave_type] >= wave.max_spawns)
				continue
		waves += wave_type
	return waves

/datum/controller/subsystem/migrants/proc/get_status_line()
	var/list/parts = list()
	for(var/track in list(MIGRANT_TRACK_REGULAR, MIGRANT_TRACK_SPECIAL, MIGRANT_TRACK_TRIUMPH, MIGRANT_TRACK_EVENT))
		var/forming = track_forming[track]
		if(forming)
			var/datum/migrant_wave/wave = MIGRANT_WAVE(forming)
			parts += "[track]: [wave.name] [(track_arrival[track] - world.time) / (1 SECONDS)]s"
		else if(track_next_roll[track])
			parts += "[track]: [(track_next_roll[track] - world.time) / (1 SECONDS)]s"
		else
			parts += "[track]: idle"
	return "Migrants ([get_active_migrant_amount()] queued): [parts.Join(" | ")]"

/datum/controller/subsystem/migrants/proc/get_safe_turfs_around_location(atom/location)
	var/list/turfs = list()
	var/turf/turfloc = get_turf(location)
	for(var/turf/turf as anything in RANGE_TURFS(2, turfloc))
		if(!isfloorturf(turf))
			continue
		if(islava(turf))
			continue
		if(is_blocked_turf(turf))
			continue
		turfs += turf
	turfs = shuffle(turfs)
	return turfs

/datum/controller/subsystem/migrants/proc/spawn_migrant(datum/migrant_wave/wave, datum/migrant_assignment/assignment, spawn_on_location, greet_text)
	var/rank = "Migrant"
	var/mob/dead/new_player/newplayer = assignment.client.mob

	SSjob.AssignRole(newplayer, rank, TRUE)

	var/mob/living/character = newplayer.create_character(TRUE)	//creates the human and transfers vars and mind

	character.islatejoin = TRUE
	SSjob.EquipRank(character, rank, TRUE)

	var/datum/migrant_role/role = MIGRANT_ROLE(assignment.role_type)
	character.migrant_type = assignment.role_type


	/// copy pasta from AttemptLateSpawn(rank) further on TODO put it in a proc and use in both places

	/// Fade effect
	var/atom/movable/screen/splash/Spl = new(character.client, TRUE)
	Spl.Fade(TRUE)

	var/mob/living/carbon/human/humanc
	if(ishuman(character))
		humanc = character	//Let's retypecast the var to be human,

	SSticker.minds += character.mind
	GLOB.joined_player_list += character.ckey
	update_scaling_slots()
	if(character.client)
		character.client.update_ooc_verb_visibility()

	if(humanc)
		var/fakekey = character.ckey
		if(character.ckey in GLOB.anonymize)
			fakekey = get_fake_key(character.ckey)
		GLOB.character_list[character.mobid] = "[fakekey] was [character.real_name] ([rank])<BR>"
		GLOB.character_ckey_list[character.real_name] = character.ckey
		var/mob_name = character.real_name
		var/mob_rank = rank
		if(character.mind.special_role == "Court Agent")
			mob_rank = "Adventurer"
		GLOB.actors_list[character.mobid] = list("name" = mob_name, "rank" = mob_rank)
		log_character("[character.ckey] ([fakekey]) - [character.real_name] - [rank]")
	if(GLOB.respawncounts[character.ckey])
		var/AN = GLOB.respawncounts[character.ckey]
		AN++
		GLOB.respawncounts[character.ckey] = AN
	else
		GLOB.respawncounts[character.ckey] = 1

	/// And back to non copy pasta code
	if(spawn_on_location)
		character.forceMove(assignment.spawn_location)

	to_chat(character, span_alertsyndie("I am a [role.name]!"))
	var/wave_greet = isnull(greet_text) ? wave.greet_text : greet_text
	if(wave_greet)
		to_chat(character, span_notice("[wave_greet]"))
	if(role.greet_text)
		to_chat(character, span_notice("[role.greet_text]"))

	if(role.outfit)
		var/datum/outfit/outfit = new role.outfit()
		outfit.equip(character)

	if(role.antag_datum)
		character.mind.add_antag_datum(role.antag_datum)

	// Adding antag datums can move your character to places, so here's a bandaid
	if(spawn_on_location)
		character.forceMove(assignment.spawn_location)

	if(role.grant_lit_torch)
		grant_lit_torch(character)

	role.after_spawn(character)

	if(role.advclass_cat_rolls)
		SSrole_class_handler.setup_class_handler(character, role.advclass_cat_rolls)
	else
		// Apply a special if we're not applying an adv class, otherwise let the adv class apply it afterwards
		try_apply_character_post_equipment(character, character.client)

/datum/controller/subsystem/migrants/proc/get_priority_players(list/players, role_type, wave_type)
	var/list/weighted = list()
	for(var/client/client as anything in players)
		if(client.prefs.migrant.queued_role != role_type)
			continue
		weighted[client] = get_triumph_selection_bonus(client, wave_type)

	var/list/priority = list()
	var/list/unpledged = list()
	for(var/client/client in weighted)
		if(weighted[client] <= 0)
			unpledged += client

	while(length(weighted) > length(unpledged))
		var/client/highest = null
		var/highest_priority = 0
		for(var/client/client in weighted)
			if(weighted[client] > highest_priority)
				highest_priority = weighted[client]
				highest = client
		if(!highest)
			break
		priority += highest
		weighted -= highest

	priority += shuffle(unpledged)
	return priority

/datum/controller/subsystem/migrants/proc/can_be_role(client/player, role_type)
	var/datum/migrant_role/role = MIGRANT_ROLE(role_type)
	if(!player)
		return FALSE
	if(!player.prefs)
		return FALSE
	var/datum/preferences/prefs = player.prefs
	if(role.forbidden_races && (prefs.pref_species.type in role.forbidden_races))
		return FALSE
	if(role.allowed_sexes && !(prefs.gender in role.allowed_sexes))
		return FALSE
	if(role.allowed_ages && !(prefs.age in role.allowed_ages))
		return FALSE
	return TRUE

/datum/controller/subsystem/migrants/proc/wave_eligible(datum/migrant_wave/wave)
	if(!wave.can_roll)
		return FALSE
	if(!wave.can_roll())
		return FALSE
	var/active_migrants = get_active_migrant_amount()
	var/active_players = get_round_active_players()
	if(wave.min_round_time && (world.time - SSticker.round_start_time) < wave.min_round_time)
		return FALSE
	if(!isnull(wave.min_active) && active_migrants < wave.min_active)
		return FALSE
	if(!isnull(wave.max_active) && active_migrants > wave.max_active)
		return FALSE
	if(!isnull(wave.min_pop) && active_players < wave.min_pop)
		return FALSE
	if(!isnull(wave.max_pop) && active_players > wave.max_pop)
		return FALSE
	if(!isnull(wave.max_spawns))
		var/used_wave_type = wave.shared_wave_type ? wave.shared_wave_type : wave.type
		if(spawned_waves[used_wave_type] && spawned_waves[used_wave_type] >= wave.max_spawns)
			return FALSE
	return TRUE

/datum/controller/subsystem/migrants/proc/roll_wave(track)
	var/list/available_weighted_waves = list()
	for(var/wave_type in GLOB.migrant_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		if(wave.track != track)
			continue
		if(!wave_eligible(wave))
			continue
		if(wave_cooldown[wave_type] && world.time < wave_cooldown[wave_type])
			continue
		available_weighted_waves[wave_type] = calculate_triumph_weight(wave)

	if(!length(available_weighted_waves))
		return null
	return pickweight(available_weighted_waves)

/datum/controller/subsystem/migrants/proc/get_maxed_wave()
	var/chosen_wave = null
	var/highest_triumph = 0
	for(var/wave_type in GLOB.migrant_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		if(wave.triumph_total < wave.triumph_threshold)
			continue
		if(!wave_eligible(wave))
			continue
		if(wave.triumph_total > highest_triumph)
			highest_triumph = wave.triumph_total
			chosen_wave = wave_type
	return chosen_wave

/datum/controller/subsystem/migrants/proc/calculate_triumph_weight(datum/migrant_wave/wave)
	var/base_weight = wave.weight
	var/triumph_bonus = wave.triumph_total

	var/triumph_multiplier = 6
	var/final_weight = base_weight + (triumph_bonus * triumph_multiplier)

	return max(final_weight, 1)


/datum/controller/subsystem/migrants/proc/contribute_triumph_to_wave(client/player, wave_type, amount)
	if(!player || !player.ckey)
		return FALSE

	var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
	if(!wave)
		return FALSE

	var/current_triumph = SStriumphs.get_triumphs(player.ckey)
	if(current_triumph < amount)
		to_chat(player, span_warning("You don't have enough triumph! You have [current_triumph], need [amount]."))
		return FALSE

	player.adjust_triumphs(-amount, TRUE, "Wave influence: [wave.name]")

	if(!wave.triumph_contributions[player.ckey])
		wave.triumph_contributions[player.ckey] = 0
	wave.triumph_contributions[player.ckey] += amount
	wave.triumph_total += amount

	if(!global_triumph_contributions[player.ckey])
		global_triumph_contributions[player.ckey] = list()
	if(!global_triumph_contributions[player.ckey][wave_type])
		global_triumph_contributions[player.ckey][wave_type] = 0
	global_triumph_contributions[player.ckey][wave_type] += amount

	to_chat(player, span_notice("You've contributed [amount] triumph to '[wave.name]'. Total: [wave.triumph_total]/[wave.triumph_threshold]"))

	if(wave.triumph_total >= wave.triumph_threshold)
		message_admins("TRIUMPH: Wave '[wave.name]' has reached its triumph threshold ([wave.triumph_total]/[wave.triumph_threshold]) and will be prioritized!")
		log_game("TRIUMPH: Wave '[wave.name]' reached triumph threshold via player contributions")

	return TRUE

/datum/controller/subsystem/migrants/proc/get_triumph_selection_bonus(client/player, wave_type)
	if(!player?.ckey)
		return 0

	if(!global_triumph_contributions[player.ckey])
		return 0

	if(!global_triumph_contributions[player.ckey][wave_type])
		return 0

	return global_triumph_contributions[player.ckey][wave_type]

/datum/controller/subsystem/migrants/proc/reset_wave_contributions(datum/migrant_wave/wave)
	if(!wave.reset_contributions_on_spawn)
		return

	wave.triumph_contributions.Cut()
	wave.triumph_total = 0

	for(var/ckey in global_triumph_contributions)
		if(global_triumph_contributions[ckey][wave.type])
			global_triumph_contributions[ckey] -= wave.type

/datum/controller/subsystem/migrants/proc/refund_wave_contributions(datum/migrant_wave/wave)
	for(var/ckey in wave.triumph_contributions)
		var/amount = wave.triumph_contributions[ckey]
		if(amount <= 0)
			continue
		SStriumphs.triumph_adjust(amount, ckey)
		var/client/client = GLOB.directory[ckey]
		if(client)
			to_chat(client, span_nicegreen("[wave.name] failed to arrive - your [amount] pledged triumph has been refunded."))
	wave.triumph_contributions.Cut()
	wave.triumph_total = 0
	for(var/ckey in global_triumph_contributions)
		if(global_triumph_contributions[ckey][wave.type])
			global_triumph_contributions[ckey] -= wave.type

/datum/controller/subsystem/migrants/proc/announce_special_wave(wave_type)
	var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
	if(wave.hidden)
		return
	if(last_ooc_ping && (world.time - last_ooc_ping) < ooc_ping_interval)
		return
	last_ooc_ping = world.time

	var/list/needs = list()
	for(var/role_type in wave.required_roles)
		var/datum/migrant_role/role = MIGRANT_ROLE(role_type)
		needs += "[wave.required_roles[role_type]] [role.name]"
	var/list/slots = list()
	for(var/role_type in wave.optional_roles)
		var/datum/migrant_role/role = MIGRANT_ROLE(role_type)
		slots += "[wave.optional_roles[role_type]] [role.name]"

	var/line = "<b>A wave is forming: [wave.name]</b>"
	if(length(needs))
		line += "<br>Needs: [needs.Join(", ")]."
	if(length(slots))
		line += "<br>Slots open for [slots.Join(", ")]."
	line += "<br><a href='?src=[REF(src)];open_panel=1'>Click to join.</a> [wave_wait_time / (1 SECONDS)]s remaining."
	for(var/mob/dead/new_player/lobby_nerd in GLOB.player_list)
		if(!lobby_nerd.client)
			continue
		to_chat(lobby_nerd, "\n<font color='purple'>[line]</font>")

/datum/controller/subsystem/migrants/Topic(href, list/href_list)
	. = ..()
	if(href_list["open_panel"])
		var/mob/user = usr
		if(user?.client?.prefs?.migrant)
			user.client.prefs.migrant.show_ui()

/datum/controller/subsystem/migrants/proc/update_ui()
	for(var/client/client as anything in get_all_migrants())
		var/datum/migrant_pref/pref = client.prefs.migrant
		var/datum/tgui/ui = SStgui.get_open_ui(client.mob, pref)
		if(ui)
			ui.send_update()

/datum/controller/subsystem/migrants/proc/get_active_migrant_amount()
	var/list/migrants = get_active_migrants()
	if(migrants)
		return migrants.len
	return 0

/datum/controller/subsystem/migrants/proc/get_stars_on_role(role_type)
	var/stars = 0
	for(var/client/client as anything in get_active_migrants())
		if(client.prefs.migrant.queued_role == role_type)
			stars++
	return stars

/datum/controller/subsystem/migrants/proc/get_wave_candidates(wave_type)
	var/list/candidates = list()
	for(var/client/client as anything in get_active_migrants())
		if(client.prefs.migrant.queued_wave == wave_type)
			candidates += client
	return candidates

/datum/controller/subsystem/migrants/proc/reset_wave_queue(wave_type)
	for(var/client/client as anything in get_wave_candidates(wave_type))
		client.prefs.migrant.clear_queue(silent = TRUE)

/datum/controller/subsystem/migrants/proc/get_round_active_players()
	var/active = 0
	for(var/mob/player_mob as anything in GLOB.player_list)
		if(!player_mob.client)
			continue
		if(player_mob.stat == DEAD) //If not alive
			continue
		if(player_mob.client.is_afk()) //If afk
			continue
		if(!ishuman(player_mob))
			continue
		active++
	return active

/datum/controller/subsystem/migrants/proc/get_active_migrants()
	var/list/migrants = list()
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(!player.client)
			continue
		if(!player.client.prefs)
			continue
		if(!player.client.prefs.migrant.queued_wave)
			continue
		migrants += player.client
	return migrants

/datum/controller/subsystem/migrants/proc/get_all_migrants()
	var/list/migrants = list()
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(!player.client)
			continue
		if(!player.client.prefs)
			continue
		if(!player.client.prefs.migrant?.viewer)
			continue
		migrants += player.client
	return migrants

/client/proc/admin_force_next_migrant_wave()
	set category = "Server"
	set name = "Force Migrant Wave"
	if(!holder)
		return
	. = TRUE
	var/mob/user = usr
	message_admins("Admin [key_name_admin(user)] is forcing the next migrant wave.")
	var/picked_wave_type = input(user, "Choose migrant wave to force:", "Migrants")  as null|anything in GLOB.migrant_waves
	if(!picked_wave_type)
		return
	message_admins("Admin [key_name_admin(user)] forced next migrant wave: [picked_wave_type]")
	log_game("Admin [key_name_admin(user)] forced next migrant wave: [picked_wave_type]")
	var/datum/migrant_wave/wave = MIGRANT_WAVE(picked_wave_type)
	SSmigrants.begin_forming(wave.track, picked_wave_type, forced = TRUE)

/proc/get_spawn_turf_for_job(jobname)
	var/list/landmarks = list()
	for(var/obj/effect/landmark/start/sloc as anything in GLOB.start_landmarks_list)
		if(!(jobname in sloc.jobspawn_override))
			continue
		landmarks += sloc
	if(!length(landmarks))
		return null
	landmarks = shuffle(landmarks)
	return get_turf(pick(landmarks))

/proc/hugboxify_for_class_selection(mob/living/carbon/human/character)
	character.set_advsetup(TRUE)
	character.invisibility = INVISIBILITY_MAXIMUM
	character.become_blind("advsetup")

	/*if(GLOB.adventurer_hugbox_duration)
		///FOR SOME silly FUCKING REASON THIS REFUSED TO WORK WITHOUT A FUCKING TIMER IT JUST FUCKED SHIT UP
		addtimer(CALLBACK(character, TYPE_PROC_REF(/mob/living/carbon/human, adv_hugboxing_start)), 1)*/

/proc/grant_lit_torch(mob/living/carbon/human/character)
	var/obj/item/flashlight/flare/torch/torch = new()
	torch.spark_act()
	character.put_in_hands(torch, forced = TRUE)
