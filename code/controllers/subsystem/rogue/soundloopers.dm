
SUBSYSTEM_DEF(soundloopers)
	name = "soundloopers"
	wait = 1
	flags = SS_NO_INIT
	priority = FIRE_PRIORITY_DEFAULT
	var/list/processing = list()
	var/list/currentrun = list()
	var/client_ticker = 0

/datum/controller/subsystem/soundloopers/fire(resumed = 0)
	MC_SPLIT_TICK_INIT(2)
	MC_SPLIT_TICK
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
				break
			continue

		if(world.time > thing.starttime + thing.mid_length) //Make sure we don't try to trigger it while a loop is playing
			if(thing.sound_loop()) //returns 1 if it fails for some reason
				continue

		if(check_clients && thing.persistent_loop)
			var/turf/parent_turf = get_turf(thing.parent)
			for(var/mob/M in get_hearers_in_range(world.view + thing.extra_range, parent_turf, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS))
				M.client?.update_persistent_sound_loop(thing)

		if (MC_TICK_CHECK)
			break

	MC_SPLIT_TICK

	if(check_clients)
		for(var/client/C in GLOB.clients)
			if(!C.mob)
				continue // no lobby
			C.update_sounds()
			if (MC_TICK_CHECK)
				break

/client/proc/update_persistent_sound_loop(datum/looping_sound/PS)
	if(PS in played_loops) //Make sure it's not already on the list
		return

	if((istype(PS, /datum/looping_sound/instrument) || istype(PS, /datum/looping_sound/musloop) || istype(PS, /datum/looping_sound/dmusloop)) && !(prefs?.toggles & SOUND_INSTRUMENTS))
		return

	if(!PS.parent)
		return

	var/turf/parent_turf = get_turf(PS.parent)
	var/turf/mob_turf = get_turf(mob)
	if(get_dist(get_turf(mob),parent_turf) > world.view + PS.extra_range) //Too far away. get_dist shouldn't be too awful for repeated calcs
		return

	if(mob_turf.z - parent_turf.z > 2 || mob_turf.z - parent_turf.z < -2) //for some reason get_dist not checking this properly
		return

	//otherwise add it to the client loops and off we go from there
	var/sound/our_sound = PS.cursound
	if(!istype(our_sound)) //somehow it doesn't have a correct sound
		our_sound = sound(our_sound)
	if(!our_sound)
		return //something fucked up and the loop has no cursound, wups. this should basically never happen

	mob.playsound_local(parent_turf, PS.cursound, PS.volume, PS.vary, PS.frequency, PS.falloff, PS.channel, FALSE, our_sound, repeat = PS)

/client/proc/update_sounds()
	if(!length(played_loops)) //nothing playing
		return

	var/turf/mob_turf = get_turf(mob)

	//Now we check how far away etc we are
	for(var/datum/looping_sound/loop in played_loops)
		if (!loop)
			played_loops -= loop
			continue
		
		if((istype(loop, /datum/looping_sound/instrument) || istype(loop, /datum/looping_sound/musloop) || istype(loop, /datum/looping_sound/dmusloop)) && !(prefs?.toggles & SOUND_INSTRUMENTS))
			var/list/muted_loop = played_loops[loop]
			var/sound/muted_sound = muted_loop?["SOUND"]
			if(loop.persistent_loop)
				muted_loop["MUTESTATUS"] = TRUE
				muted_loop["VOL"] = 0
				if(muted_sound)
					mob.mute_sound(muted_sound)
			else
				played_loops -= loop
				loop.thingshearing -= WEAKREF(mob)
				if(muted_sound)
					mob.stop_sound_channel(muted_sound.channel)
			continue

		var/atom/loop_parent = loop.parent
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
					played_loops -= loop
					loop.thingshearing -= WEAKREF(mob)
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
				var/turf/T = mob_turf //cached at proc start
				var/dx = source_turf.x - T.x
				if(dx <= 1 && dx >= -1)
					found_sound.x = 0
				else
					found_sound.x = dx
				var/dz = source_turf.y - T.y
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
				mob.update_sound_volume(played_loops[loop]["SOUND"], new_volume)

