SUBSYSTEM_DEF(migrants)
	name = "Migrants"
	wait = 2 SECONDS
	runlevels = RUNLEVEL_GAME
	var/wave_number = 1
	var/current_wave = null
	var/time_until_next_wave = 2 MINUTES
	var/wave_timer = 0

	var/time_between_waves = 3 MINUTES
	var/time_between_fail_wave = 90 SECONDS
	var/wave_wait_time = 30 SECONDS

	var/list/spawned_waves = list()
	/// Track triumph contributions across all waves
	var/list/global_triumph_contributions = list()
	/// Track parent wave for downgrades
	var/current_parent_wave = null

/datum/controller/subsystem/migrants/Initialize()
	return ..()

/datum/controller/subsystem/migrants/fire(resumed)
	process_migrants(2 SECONDS)
	update_ui()

/datum/controller/subsystem/migrants/proc/set_current_wave(wave_type, time, parent_wave = -1)
	current_wave = wave_type
	wave_timer = time
	if(parent_wave != -1)
		current_parent_wave = parent_wave

/datum/controller/subsystem/migrants/proc/process_migrants(dt)
	if(current_wave)
		process_current_wave(dt)
	else
		process_next_wave(dt)

/datum/controller/subsystem/migrants/proc/process_current_wave(dt)
	wave_timer -= dt
	if(wave_timer > 0)
		return
	// Try and spawn wave
	var/success = try_spawn_wave()
	if(success)
		log_game("Migrants: Successfully spawned wave: [current_wave]")
	else
		log_game("Migrants: FAILED to spawn wave: [current_wave]")

	// Handle downgrade logic
	var/datum/migrant_wave/wave = MIGRANT_WAVE(current_wave)
	var/parent_wave = current_parent_wave

	// Unset some values, increment wave number if success
	if(success)
		wave_number++
		// Reset parent wave triumph if this was a downgrade that succeeded
		if(parent_wave)
			reset_wave_contributions(MIGRANT_WAVE(parent_wave))

	set_current_wave(null, 0)

	if(success)
		time_until_next_wave = time_between_waves
		current_parent_wave = null
	else
		if(wave.downgrade_wave)
			// Apply triumph weighting to downgrade decision
			var/datum/migrant_wave/downgrade_wave = MIGRANT_WAVE(wave.downgrade_wave)
			var/downgrade_weight = calculate_triumph_weight(downgrade_wave)
			// Use parent wave if this was already a downgrade, otherwise use current wave as parent
			var/new_parent = parent_wave ? parent_wave : current_wave
			set_current_wave(wave.downgrade_wave, wave_wait_time, new_parent)
			log_game("Migrants: Downgrading to [wave.downgrade_wave] (parent: [new_parent]) with triumph weight [downgrade_weight]")
		else
			current_parent_wave = null
			time_until_next_wave = time_between_fail_wave

/datum/controller/subsystem/migrants/proc/try_spawn_wave()
	var/datum/migrant_wave/wave = MIGRANT_WAVE(current_wave)
	/// Create initial assignment list
	var/list/assignments = list()
	/// Populate it
	for(var/role_type in wave.roles)
		var/amount = wave.roles[role_type]
		for(var/i in 1 to amount)
			assignments += new /datum/migrant_assignment(role_type)
	/// Shuffle assignments so role rolling is not consistent
	assignments = shuffle(assignments)

	var/list/active_migrants = get_active_migrants()
	active_migrants = shuffle(active_migrants)

	var/list/picked_migrants = list()

	if(!length(active_migrants))
		return FALSE
	/// Try to assign priority players to positions
	for(var/datum/migrant_assignment/assignment as anything in assignments)
		if(!length(active_migrants))
			break // Out of migrants, we're screwed and will fail
		if(assignment.client)
			continue
		var/list/priority = get_priority_players(active_migrants, assignment.role_type, current_wave)
		if(!length(priority))
			continue
		var/client/picked
		priority = shuffle(priority)
		for(var/client/client as anything in priority)
			if(!can_be_role(client, assignment.role_type))
				continue
			picked = client
			break
		if(!picked)
			continue

		active_migrants -= picked
		assignment.client = picked
		picked_migrants += picked

	/// Assign rest of the players to positions
	for(var/datum/migrant_assignment/assignment as anything in assignments)
		if(!length(active_migrants))
			break // Out of migrants, we're screwed and will fail
		if(assignment.client)
			continue

		var/client/picked
		for(var/client/client as anything in active_migrants)
			if(!can_be_role(client, assignment.role_type))
				continue
			picked = client
			break
		if(!picked)
			continue

		active_migrants -= picked
		assignment.client = picked
		picked_migrants += picked

	/// Find spawn points for the assignments
	var/turf/spawn_location = get_spawn_turf_for_job(wave.spawn_landmark)
	var/atom/fallback_location = spawn_location

	var/list/turfs = get_safe_turfs_around_location(spawn_location)
	for(var/i in 1 to turfs.len)
		var/turf/turf = turfs[i]
		if(assignments.len < i)
			break
		var/datum/migrant_assignment/assignment = assignments[i]
		assignment.spawn_location = turf

	/// See if anything went wrong and return FALSE if it did
	for(var/datum/migrant_assignment/assignment as anything in assignments)
		if(!assignment.client)
			return FALSE
		if(!assignment.spawn_location)
			assignment.spawn_location = fallback_location

	/// At this point everything is GOOD and SWELL, we want to spawn the wave

	/// Unset their pref so if they respawn they wont get yoinked into migrants immediately
	for(var/client/client as anything in picked_migrants)
		client.prefs.migrant.post_spawn()

	/// Spawn the migrants, hooray
	for(var/datum/migrant_assignment/assignment as anything in assignments)
		spawn_migrant(wave, assignment, wave.spawn_on_location)

	// Increment wave spawn counter
	var/used_wave_type = wave.type
	if(wave.shared_wave_type)
		used_wave_type = wave.shared_wave_type
	if(!spawned_waves[used_wave_type])
		spawned_waves[used_wave_type] = 0
	spawned_waves[used_wave_type] += 1

	reset_wave_contributions(wave)
	message_admins("MIGRANTS: Spawned wave: [wave.name] (players: [assignments.len]) at [ADMIN_VERBOSEJMP(spawn_location)]")

	unset_all_active_migrants()

	return TRUE

/datum/controller/subsystem/migrants/proc/get_influenceable_waves()
	var/list/waves = list()
	for(var/wave_type in GLOB.migrant_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		if(!wave.can_roll)
			continue
		// Only show waves that haven't hit max spawns
		if(!isnull(wave.max_spawns))
			var/used_wave_type = wave.type
			if(wave.shared_wave_type)
				used_wave_type = wave.shared_wave_type
			if(spawned_waves[used_wave_type] && spawned_waves[used_wave_type] >= wave.max_spawns)
				continue
		waves += wave_type
	return waves

/datum/controller/subsystem/migrants/proc/get_status_line()
	var/string = ""
	if(current_wave)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(current_wave)
		var/parent_info = ""
		if(current_parent_wave)
			var/datum/migrant_wave/parent = MIGRANT_WAVE(current_parent_wave)
			parent_info = " (downgrade from [parent.name])"
		string = "[wave.name][parent_info] ([get_active_migrant_amount()]/[wave.get_roles_amount()]) - [wave_timer / (1 SECONDS)]s"
	else
		string = "Mist - [time_until_next_wave / (1 SECONDS)]s"
	return "Migrants: [string]"

/datum/controller/subsystem/migrants/proc/unset_all_active_migrants()
	var/list/active_migrants = get_active_migrants()
	if(active_migrants)
		for(var/client/client as anything in active_migrants)
			client.prefs.migrant.set_active(FALSE)

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

/datum/controller/subsystem/migrants/proc/spawn_migrant(datum/migrant_wave/wave, datum/migrant_assignment/assignment, spawn_on_location)
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
	update_wretch_slots()
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
	to_chat(character, span_notice(wave.greet_text))
	to_chat(character, span_notice(role.greet_text))

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
	var/list/priority = list()
	var/list/triumph_weighted = list()

	for(var/client/client as anything in players)
		var/base_priority = 0
		var/triumph_bonus = 0
		//Standard role preference priority
		if(role_type in client.prefs.migrant.role_preferences)
			base_priority = 1
			triumph_bonus = get_triumph_selection_bonus(client, wave_type) //Only gains the Triumph Bonus if they want that role.

		var/final_priority = base_priority + triumph_bonus

		if(final_priority > 0)
			triumph_weighted[client] = final_priority

	//Check if all triumph_weighted values are equal
	var/all_equal = TRUE
	var/first_val = -1

	if(length(triumph_weighted))
		first_val = triumph_weighted[1]
		for(var/client/client in triumph_weighted)
			// Check if anything is not equal to the first value in the list
			if(triumph_weighted[client] != first_val)
				all_equal = FALSE
				break

	//Convert weighted list to prioritized list
	while(length(triumph_weighted))
		var/client/highest = null
		var/highest_priority = 0

		for(var/client/client in triumph_weighted)
			if(triumph_weighted[client] > highest_priority)
				highest_priority = triumph_weighted[client]
				highest = client

		if(highest)
			priority += highest
			triumph_weighted -= highest

	//Shuffle only if all have equal priority
	if(all_equal)
		priority = shuffle(priority)

	return priority

/datum/controller/subsystem/migrants/proc/can_be_role(client/player, role_type)
	var/datum/migrant_role/role = MIGRANT_ROLE(role_type)
	if(!player)
		return FALSE
	if(!player.prefs)
		return FALSE
	var/datum/preferences/prefs = player.prefs
	if(role.allowed_races && !(prefs.pref_species.type in role.allowed_races))
		return FALSE
	if(role.allowed_sexes && !(prefs.gender in role.allowed_sexes))
		return FALSE
	if(role.allowed_ages && !(prefs.age in role.allowed_ages))
		return FALSE
	return TRUE

/datum/controller/subsystem/migrants/proc/process_next_wave(dt)
	time_until_next_wave -= dt
	if(time_until_next_wave > 0)
		return
	var/wave_type = roll_wave()
	if(wave_type)
		log_game("Migrants: Rolled wave: [wave_type]")
		set_current_wave(wave_type, wave_wait_time, wave_type)

	time_until_next_wave = time_between_fail_wave

/datum/controller/subsystem/migrants/proc/roll_wave()
	var/list/available_weighted_waves = list()
	var/active_migrants = get_active_migrant_amount()
	var/active_players = get_round_active_players()

	// Check for auto-triggered waves first
	var/auto_wave = check_triumph_threshold_waves()
	if(auto_wave)
		return auto_wave

	// Build available waves with triumph-modified weights
	for(var/wave_type in GLOB.migrant_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		if(!wave.can_roll)
			continue
		if(!isnull(wave.min_active) && active_migrants < wave.min_active)
			continue
		if(!isnull(wave.max_active) && active_migrants > wave.max_active)
			continue
		if(!isnull(wave.min_pop) && active_players < wave.min_pop)
			continue
		if(!isnull(wave.max_pop) && active_players > wave.max_pop)
			continue
		if(!isnull(wave.max_spawns))
			var/used_wave_type = wave.type
			if(wave.shared_wave_type)
				used_wave_type = wave.shared_wave_type
			if(spawned_waves[used_wave_type] && spawned_waves[used_wave_type] >= wave.max_spawns)
				continue

		// Calculate triumph-modified weight
		var/final_weight = calculate_triumph_weight(wave)
		available_weighted_waves[wave_type] = final_weight

	if(!length(available_weighted_waves))
		return null
	return pickweight(available_weighted_waves)


/datum/controller/subsystem/migrants/proc/check_triumph_threshold_waves()
	// Find waves that have hit their triumph threshold
	var/list/threshold_waves = list()

	for(var/wave_type in GLOB.migrant_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		if(!wave.can_roll)
			continue
		if(wave.triumph_total >= wave.triumph_threshold)
			// Still need to check population/active requirements
			var/active_migrants = get_active_migrant_amount()
			var/active_players = get_round_active_players()

			if(!isnull(wave.min_active) && active_migrants < wave.min_active)
				continue
			if(!isnull(wave.max_active) && active_migrants > wave.max_active)
				continue
			if(!isnull(wave.min_pop) && active_players < wave.min_pop)
				continue
			if(!isnull(wave.max_pop) && active_players > wave.max_pop)
				continue
			if(!isnull(wave.max_spawns))
				var/used_wave_type = wave.type
				if(wave.shared_wave_type)
					used_wave_type = wave.shared_wave_type
				if(spawned_waves[used_wave_type] && spawned_waves[used_wave_type] >= wave.max_spawns)
					continue

			threshold_waves[wave_type] = wave.triumph_total

	if(!length(threshold_waves))
		return null

	// Return the wave with highest triumph investment if multiple hit threshold
	var/chosen_wave = null
	var/highest_triumph = 0
	for(var/wave_type in threshold_waves)
		if(threshold_waves[wave_type] > highest_triumph)
			highest_triumph = threshold_waves[wave_type]
			chosen_wave = wave_type

	return chosen_wave

/datum/controller/subsystem/migrants/proc/calculate_triumph_weight(datum/migrant_wave/wave)
	var/base_weight = wave.weight
	var/triumph_bonus = wave.triumph_total

	// Triumph provides a linear bonus to weight (configurable multiplier)
	var/triumph_multiplier = 2 // Each triumph point adds 2x weight
	var/final_weight = base_weight + (triumph_bonus * triumph_multiplier)

	return max(final_weight, 1) // Ensure minimum weight of 1


/datum/controller/subsystem/migrants/proc/contribute_triumph_to_wave(client/player, wave_type, amount)
	if(!player || !player.ckey)
		return FALSE

	var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
	if(!wave)
		return FALSE

	// Check if player has enough triumph
	var/current_triumph = SStriumphs.get_triumphs(player.ckey)
	if(current_triumph < amount)
		to_chat(player, span_warning("You don't have enough triumph! You have [current_triumph], need [amount]."))
		return FALSE

	// Deduct triumph from player
	player.adjust_triumphs(-amount, TRUE, "Wave influence: [wave.name]")

	// Add to wave contributions
	if(!wave.triumph_contributions[player.ckey])
		wave.triumph_contributions[player.ckey] = 0
	wave.triumph_contributions[player.ckey] += amount
	wave.triumph_total += amount

	// Track globally for selection chances
	if(!global_triumph_contributions[player.ckey])
		global_triumph_contributions[player.ckey] = list()
	if(!global_triumph_contributions[player.ckey][wave_type])
		global_triumph_contributions[player.ckey][wave_type] = 0
	global_triumph_contributions[player.ckey][wave_type] += amount

	to_chat(player, span_notice("You've contributed [amount] triumph to '[wave.name]'. Total: [wave.triumph_total]/[wave.triumph_threshold]"))

	// Announce if threshold reached
	if(wave.triumph_total >= wave.triumph_threshold)
		message_admins("TRIUMPH: Wave '[wave.name]' has reached its triumph threshold ([wave.triumph_total]/[wave.triumph_threshold]) and will be prioritized!")
		log_game("TRIUMPH: Wave '[wave.name]' reached triumph threshold via player contributions")

	return TRUE

/datum/controller/subsystem/migrants/proc/get_triumph_selection_bonus(client/player, wave_type)
	if(current_parent_wave)
		wave_type = current_parent_wave
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

	// Clear contributions for this wave
	wave.triumph_contributions.Cut()
	wave.triumph_total = 0

	// Clear from global tracking
	for(var/ckey in global_triumph_contributions)
		if(global_triumph_contributions[ckey][wave.type])
			global_triumph_contributions[ckey] -= wave.type

/datum/controller/subsystem/migrants/proc/update_ui()
	for(var/client/client as anything in get_all_migrants())
		client.prefs.migrant.show_ui()

/datum/controller/subsystem/migrants/proc/get_active_migrant_amount()
	var/list/migrants = get_active_migrants()
	if(migrants)
		return migrants.len
	return 0

/datum/controller/subsystem/migrants/proc/get_stars_on_role(role_type)
	var/stars = 0
	var/list/active_migrants = get_active_migrants()
	if(active_migrants)
		for(var/client/client as anything in active_migrants)
			if(!(role_type in client.prefs.migrant.role_preferences))
				continue
			stars++
	return stars

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

/// Returns a list of all newplayer clients with active migrant pref
/datum/controller/subsystem/migrants/proc/get_active_migrants()
	var/list/migrants = list()
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(!player.client)
			continue
		if(!player.client.prefs)
			continue
		if(!player.client.prefs.migrant.active)
			continue
		migrants += player.client
	return migrants

/// Returns a list of all newplayer clients
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
	set category = "-Server-"
	set name = "Force Migrant Wave"
	if(!holder)
		return
	. = TRUE
	var/mob/user = usr
	message_admins("Admin [key_name_admin(user)] is forcing the next migrant wave.")
	var/picked_wave_type = input(user, "Choose migrant wave to force:", "Migrants")  as null|anything in GLOB.migrant_waves
	if(!picked_wave_type)
		return
	message_admins("Admin [key_name_admin(user)] forced next migrant wave: [picked_wave_type] (Arrival: 1 Minute)")
	log_game("Admin [key_name_admin(user)] forced next migrant wave: [picked_wave_type] (Arrival: 1 Minute)")
	SSmigrants.set_current_wave(picked_wave_type, (1 MINUTES))

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
	character.advsetup = 1
	character.invisibility = INVISIBILITY_MAXIMUM
	character.become_blind("advsetup")

	/*if(GLOB.adventurer_hugbox_duration)
		///FOR SOME silly FUCKING REASON THIS REFUSED TO WORK WITHOUT A FUCKING TIMER IT JUST FUCKED SHIT UP
		addtimer(CALLBACK(character, TYPE_PROC_REF(/mob/living/carbon/human, adv_hugboxing_start)), 1)*/

/proc/grant_lit_torch(mob/living/carbon/human/character)
	var/obj/item/flashlight/flare/torch/torch = new()
	torch.spark_act()
	character.put_in_hands(torch, forced = TRUE)
