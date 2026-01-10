
SUBSYSTEM_DEF(soundloopers)
	name = "soundloopers"
	wait = 1
	flags = SS_NO_INIT
	priority = FIRE_PRIORITY_DEFAULT
	var/list/processing = list()
	var/list/currentrun = list()
	var/client_ticker = 0

/datum/controller/subsystem/soundloopers/fire(resumed = 0)
	if (!resumed || !currentrun.len)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/current = src.currentrun
	var/check_clients = FALSE
	client_ticker++

	if(client_ticker>=5) //this is dumb but necessary- clients update every half tick but sounds themselves need to be updated regularly
		client_ticker = 0
		check_clients = TRUE
	else
		check_clients = FALSE

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

		if(check_clients && thing.persistent_loop)
			for(var/client/C in GLOB.clients)
				if(C.mob) //Not in the lobby
					C.update_sounds()

		if (MC_TICK_CHECK)
			return

/client/proc/update_sounds()

	//First we need to periodically scan if we moved into range of an already-playing sound
	for(var/datum/looping_sound/PS in GLOB.persistent_sound_loops)
		if(PS in played_loops) //Make sure it's not already on the list
			continue

		var/atom/PS_parent = PS.parent.resolve()
		if(!PS_parent)
			continue

		var/turf/parent_turf = get_turf(PS_parent)
		var/turf/mob_turf = get_turf(mob)
		if(get_dist(get_turf(mob),parent_turf) > world.view + PS.extra_range) //Too far away. get_dist shouldn't be too awful for repeated calcs
			continue

		if(abs(mob_turf.z - parent_turf.z) > 2) //for some reason get_dist not checking this properly
			continue

		//otherwise add it to the client loops and off we go from there
		var/sound/our_sound = PS.cursound
		if(!istype(our_sound)) //somehow it doesn't have a correct sound
			our_sound = sound(our_sound)
		if(!our_sound)
			continue //something fucked up and the loop has no cursound, wups. this should basically never happen

		var/use_override = (mob && (PS_parent == mob || (PS_parent in mob.contents)))
		mob.playsound_local(PS_parent, PS.cursound, PS.volume, PS.vary, PS.frequency, PS.falloff, null, FALSE, our_sound, repeat = PS, override = use_override)

	//Now we check how far away etc we are
	for(var/datum/looping_sound/loop in played_loops)
		if (!loop)
			played_loops -= loop
			continue

		var/atom/loop_parent = loop.parent?.resolve()
		if(!loop_parent)
			continue

		if(mob && loop_parent == mob) //the sound's coming from inside the house!
			continue

		var/max_distance = world.view + loop.extra_range
		var/turf/source_turf = get_turf(loop_parent)
		var/distance_between = get_dist(mob, loop_parent)

		if(isturf(loop_parent))
			source_turf = loop_parent
		if(!source_turf) //somehow
			continue

		var/list/found_loop = played_loops[loop]
		var/sound/found_sound = found_loop["SOUND"]

		if(!found_loop || !istype(found_sound)) //somethin fucky goin on. lets ignore it
			played_loops -= loop
			continue

		if(distance_between > max_distance || mob.IsSleeping()) // || !mob in hearers(max_distance,source_turf))
			//We are too far away, turn it off, or suppress it if its a persistent tune like music boxes
			if(loop.persistent_loop)
				found_loop["MUTESTATUS"] = TRUE
				found_loop["VOL"] = 0
				mob.mute_sound(found_sound)
			else
				played_loops -= loop
				loop.thingshearing -= WEAKREF(mob)
				mob.stop_sound_channel(found_sound.channel)

		else if(distance_between <= max_distance)
			// We are close enough to hear, update position
			// Always update when camera has moved to keep projection matrix current
			var/prev_pixel_x = found_loop["PIXEL_X"]
			var/prev_pixel_y = found_loop["PIXEL_Y"]
			if(pixel_x != prev_pixel_x || pixel_y != prev_pixel_y)
				// Re-calculate position with projection matrices
				// playsound_local should handle distance falloff, z-level sound, camera compensation, master volume, etc.
				var/use_override = found_loop["OVERRIDE"] ? TRUE : FALSE

				mob.playsound_local(loop_parent, loop.cursound, loop.volume, loop.vary, loop.frequency, loop.falloff, found_sound.channel, FALSE, found_sound, repeat = loop, override = use_override)
				found_loop["PIXEL_X"] = pixel_x
				found_loop["PIXEL_Y"] = pixel_y

				if(loop.persistent_loop && found_loop["MUTESTATUS"] == TRUE) //It was out of range and now back in range, reset it
					found_loop["MUTESTATUS"] = FALSE
					mob.unmute_sound(found_sound)
