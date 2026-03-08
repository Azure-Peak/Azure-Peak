
SUBSYSTEM_DEF(soundloopers)
	name = "Soundloopers"
	wait = 1
	flags = SS_NO_INIT
	priority = FIRE_PRIORITY_DEFAULT
	var/list/processing = list()
	var/list/currentrun = list()
	/// clients needing sound update on movement/sleep/death
	var/list/dirty_clients = list()
	/// dirty clients copied to this during `fire()` for clearing, after marking
	var/list/currentdirtyrun = list()
	/// for MC tracking
	/*
	L: active processing loop count.
	P: persistent loop count.
	D: pending/current dirty queue sizes.
	MQ: total dirty-mark requests in the current minute.
	UQ: unique clients enqueued in the current minute.
	NC: nearby-client candidates scanned by source invalidation.
	LD: loop-dirty calls in the current minute.
	UP: actual update_sounds() runs in the current minute.	
	SK: queued updates skipped because the client/mob no longer needed work.
	*/
	var/profile_window_started = 0
	var/profile_mark_requests = 0
	var/profile_unique_dirty_clients = 0
	var/profile_nearby_candidates = 0
	var/profile_loop_dirty_calls = 0
	var/profile_updates_run = 0
	var/profile_updates_skipped = 0

/datum/controller/subsystem/soundloopers/proc/reset_profile_window()
	profile_window_started = world.time
	profile_mark_requests = 0
	profile_unique_dirty_clients = 0
	profile_nearby_candidates = 0
	profile_loop_dirty_calls = 0
	profile_updates_run = 0
	profile_updates_skipped = 0

/datum/controller/subsystem/soundloopers/stat_entry()
	if(!profile_window_started || world.time >= profile_window_started + 1 MINUTES)
		reset_profile_window()
	..("L:[processing.len] P:[GLOB.persistent_sound_loops.len] D:[dirty_clients.len]/[currentdirtyrun.len] MQ:[profile_mark_requests] UQ:[profile_unique_dirty_clients] NC:[profile_nearby_candidates] LD:[profile_loop_dirty_calls] UP:[profile_updates_run] SK:[profile_updates_skipped]")

/datum/controller/subsystem/soundloopers/fire(resumed = 0)
	if(!profile_window_started || world.time >= profile_window_started + 1 MINUTES)
		reset_profile_window()

	if (!resumed || !currentrun.len)
		currentrun = processing.Copy()
	if (!resumed || !currentdirtyrun.len)
		currentdirtyrun = dirty_clients.Copy()
		dirty_clients.Cut()

	//cache for sanic speed (lists are references anyways)
	var/list/current = currentrun
	var/list/current_dirty = currentdirtyrun

	while (current.len)
		var/datum/looping_sound/thing = current[current.len]
		current.len--
		if (!thing || !istype(thing) || QDELETED(thing))
			processing -= thing
			if (MC_TICK_CHECK)
				return
			continue

		if(world.time > thing.starttime + thing.mid_length) //Make sure we don't try to trigger it while a loop is playing
			if(thing.sound_loop()) //returns 1 if it fails for some reason
				continue

		if (MC_TICK_CHECK)
			return

	while(current_dirty.len)
		var/client/C = current_dirty[current_dirty.len]
		current_dirty.len--
		if(!C?.mob)
			profile_updates_skipped++
			continue
		if(!C.played_loops.len && !GLOB.persistent_sound_loops.len)
			profile_updates_skipped++
			continue
		profile_updates_run++
		C.update_sounds()
		if (MC_TICK_CHECK)
			return

// did this after a back and forth with AI for keeping clients/mobs clean and dirty and looping them.

// marks a client for sound update
/datum/controller/subsystem/soundloopers/proc/mark_client_dirty(client/C)
	if(!C?.mob)
		return
	profile_mark_requests++
	if(!(C in dirty_clients))
		profile_unique_dirty_clients++
	dirty_clients |= C

// marks clients nearby for sound updates, too
/datum/controller/subsystem/soundloopers/proc/mark_nearby_clients_dirty(atom/source)
	var/turf/source_turf = get_turf(source)
	if(!source_turf)
		return

	var/min_z = max(1, source_turf.z - 2)
	var/max_z = min(world.maxz, source_turf.z + 2)
	for(var/z_level in min_z to max_z)
		for(var/mob/M as anything in SSmobs.clients_by_zlevel[z_level])
			if(M?.client)
				profile_nearby_candidates++
				mark_client_dirty(M.client)

// marks a soundloop as outdated if it moves/changes
/datum/controller/subsystem/soundloopers/proc/mark_loop_dirty(datum/looping_sound/loop)
	if(!loop?.persistent_loop)
		return
	profile_loop_dirty_calls++

	var/atom/loop_parent = loop.parent?.resolve()
	if(loop_parent)
		mark_nearby_clients_dirty(loop_parent)

	for(var/datum/weakref/listener_ref in loop.thingshearing)
		var/mob/M = listener_ref.resolve()
		if(M?.client)
			mark_client_dirty(M.client)

/client
	var/datum/weakref/soundloop_tracked_mob
	var/soundloop_waiting_for_revive = FALSE

// handle mobs when sleeping or dead or revived (don't want soundloops processing during down stages)
/client/proc/clear_soundloop_tracking(wait_for_revive = FALSE)
	var/mob/tracked_mob = soundloop_tracked_mob?.resolve()
	if(tracked_mob)
		UnregisterSignal(tracked_mob, COMSIG_MOVABLE_MOVED)
		if(isliving(tracked_mob))
			UnregisterSignal(tracked_mob, list(COMSIG_LIVING_STATUS_SLEEP, COMSIG_LIVING_DEATH))
			if(!wait_for_revive)
				UnregisterSignal(tracked_mob, COMSIG_LIVING_REVIVE)
	soundloop_waiting_for_revive = wait_for_revive
	if(!wait_for_revive)
		soundloop_tracked_mob = null

// re-init loops to client/mob after stat changes
/client/proc/refresh_soundloop_tracking()
	clear_soundloop_tracking()
	if(!mob)
		return

	RegisterSignal(mob, COMSIG_MOVABLE_MOVED, PROC_REF(handle_soundloop_mob_moved))
	if(isliving(mob))
		RegisterSignal(mob, COMSIG_LIVING_STATUS_SLEEP, PROC_REF(handle_soundloop_sleep_changed))
		RegisterSignal(mob, COMSIG_LIVING_DEATH, PROC_REF(handle_soundloop_mob_death))
		RegisterSignal(mob, COMSIG_LIVING_REVIVE, PROC_REF(handle_soundloop_mob_revive))
	soundloop_tracked_mob = WEAKREF(mob)
	soundloop_waiting_for_revive = FALSE
	SSsoundloopers.mark_client_dirty(src)

/client/proc/handle_soundloop_mob_moved(datum/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	SSsoundloopers.mark_client_dirty(src)

/client/proc/handle_soundloop_sleep_changed(datum/source, amount, updating = TRUE, ignore_canstun = FALSE)
	SIGNAL_HANDLER
	SSsoundloopers.mark_client_dirty(src)

/client/proc/handle_soundloop_mob_death(datum/source, gibbed)
	SIGNAL_HANDLER
	if(source == mob)
		clear_soundloop_tracking(TRUE)

/client/proc/handle_soundloop_mob_revive(datum/source, full_heal, admin_revive)
	SIGNAL_HANDLER
	if(source == mob && soundloop_waiting_for_revive)
		refresh_soundloop_tracking()

// micro-opt of caching refs
/client/proc/update_sounds()
	if(!mob)
		return

	var/list/client_played_loops = played_loops
	var/turf/mob_turf = get_turf(mob)
	if(!mob_turf)
		return

	var/datum/weakref/mob_ref = WEAKREF(mob)

	//First we need to periodically scan if we moved into range of an already-playing sound
	for(var/datum/looping_sound/PS in GLOB.persistent_sound_loops)
		if(PS in client_played_loops) //Make sure it's not already on the list
			continue

		var/atom/PS_parent = PS.parent.resolve()
		if(!PS_parent)
			continue

		var/turf/parent_turf = get_turf(PS_parent)
		if(get_dist(mob_turf, parent_turf) > world.view + PS.extra_range) //Too far away. get_dist shouldn't be too awful for repeated calcs
			continue

		if(mob_turf.z - parent_turf.z > 2 || mob_turf.z - parent_turf.z < -2) //for some reason get_dist not checking this properly
			continue

		//otherwise add it to the client loops and off we go from there
		var/sound/our_sound = PS.cursound
		if(!istype(our_sound)) //somehow it doesn't have a correct sound
			our_sound = sound(our_sound)
		if(!our_sound)
			continue //something fucked up and the loop has no cursound, wups. this should basically never happen

		mob.playsound_local(parent_turf, PS.cursound, PS.volume, PS.vary, PS.frequency, PS.falloff, PS.channel, FALSE, our_sound, repeat = PS)

	//Now we check how far away etc we are
	for(var/datum/looping_sound/loop in client_played_loops)
		if (!loop)
			client_played_loops -= loop
			continue
		
		var/atom/loop_parent = loop.parent?.resolve()
		if(!loop_parent)
			continue

		if(mob && loop_parent == mob) //the sound's coming from inside the house!
			continue

		var/max_distance = world.view + loop.extra_range
		var/turf/source_turf = get_turf(loop_parent)

		if(isturf(loop_parent))
			source_turf = loop_parent
		if(!source_turf) //somehow
			continue

		var/distance_between = get_dist(mob_turf, source_turf)

		var/list/found_loop = client_played_loops[loop]
		var/sound/found_sound = found_loop["SOUND"]

		if(!found_loop || !istype(found_sound)) //somethin fucky goin on. lets ignore it
			client_played_loops -= loop
			continue

		if(distance_between > max_distance || mob.IsSleeping()) // || !mob in hearers(max_distance,source_turf))
			//We are too far away, turn it off, or suppress it if its a persistent tune like music boxes
			if(loop.persistent_loop)
				found_loop["MUTESTATUS"] = TRUE
				found_loop["VOL"] = 0
				mob.mute_sound(found_sound)
			else
				client_played_loops -= loop
				loop.thingshearing -= mob_ref
				mob.stop_sound_channel(found_sound.channel)

		else if(distance_between <= max_distance)
			//We are close enough to hear, check if volume should be changed

			var/new_volume = loop.volume
			var/old_volume = found_loop["VOL"]

			new_volume -= (distance_between * (0.1 * new_volume)) //reduce volume by 10% per tile

			if(new_volume > 100)
				new_volume = 100 //could just min() this but whatever. we old skool

			if(new_volume <= 0) //Too quiet to hear despite being in range
				if(loop.persistent_loop) //Copy pasting instead of making a new proc? egads you monster
					found_loop["MUTESTATUS"] = TRUE
					found_loop["VOL"] = 0
					mob.mute_sound(found_sound)
				else
					client_played_loops -= loop
					loop.thingshearing -= mob_ref
					mob.stop_sound_channel(found_sound.channel)
				continue

			//Some hacks for z-levels- this should be get_turf_above and _below
			//those would require us building a block of turfs though, ehhhh
			if(source_turf.z == mob.z + 1 || source_turf.z == mob.z - 1)
				new_volume = new_volume / 2
			else if (source_turf.z == mob.z + 2 || source_turf.z == mob.z - 2)
				new_volume = new_volume / 4

			new_volume = new_volume * (prefs.mastervol * 0.01) //Modify it at the end by the player's volume setting

			if(old_volume != new_volume)
				var/dx = source_turf.x - mob_turf.x
				if(dx <= 1 && dx >= -1)
					found_sound.x = 0
				else
					found_sound.x = dx
				var/dz = source_turf.y - mob_turf.y
				if(dz <= 1 && dz >= -1)
					found_sound.z = 0
				else
					found_sound.z = dz
//				var/dy = source_turf.z - T.z
//				found_sound.y = dy

				if(loop.persistent_loop && found_loop["MUTESTATUS"] == TRUE) //It was out of range and now back in range, reset it
					found_loop["MUTESTATUS"] = FALSE
					mob.unmute_sound(found_sound)
				found_loop["VOL"] = new_volume
				mob.update_sound_volume(found_sound, new_volume)

