PROCESSING_SUBSYSTEM_DEF(tracks)
	name = "Tracks"
	priority = FIRE_PRIORITY_TRACKS
	wait = 100
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	// Object pooling
	var/list/track_pool
	var/list/structure_track_pool
	var/list/thievescant_pool
	var/pool_max_size 
	var/tracks_recycled
	var/tracks_created

/datum/controller/subsystem/processing/tracks/Initialize()
	track_pool = list()
	structure_track_pool = list()
	thievescant_pool = list()

	pool_max_size = 1000
	tracks_recycled = 0
	tracks_created = 0 

/datum/controller/subsystem/processing/tracks/stat_entry()
	if(processing)
		..("P:[processing.len] | Pool:[track_pool.len+structure_track_pool.len+thievescant_pool.len] | R:[tracks_recycled] | N:[tracks_created]")

/datum/controller/subsystem/processing/tracks/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()

	var/list/currentrun = src.currentrun

	while(length(currentrun))
		var/obj/effect/track/T = currentrun[currentrun.len]
		currentrun.len--

		if (!T || QDELETED(T))
			processing -= T
			if (MC_TICK_CHECK)
				return
			continue

		if(world.time >= T.expiry_time)
			recycle_track(T)
			processing -= T

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/processing/tracks/proc/add_track(obj/effect/track/T)
	if(T && !QDELETED(T))
		processing |= T

/datum/controller/subsystem/processing/tracks/proc/remove_track(obj/effect/track/T)
	processing -= T

/datum/controller/subsystem/processing/tracks/proc/get_track(track_type = /obj/effect/track, turf/location)
	var/list/pool
	switch(track_type)
		if(/obj/effect/track/structure)
			pool = structure_track_pool
		if(/obj/effect/track/thievescant)
			pool = thievescant_pool
		else
			pool = track_pool

	var/obj/effect/track/T
	if(length(pool))
		T = pool[pool.len]
		pool.len--
		T.moveToNullspace()
		T.forceMove(location)
		tracks_recycled++
	else
		T = new track_type(location)
		tracks_created++

	return T

/datum/controller/subsystem/processing/tracks/proc/recycle_track(obj/effect/track/T)
	if(!T || QDELETED(T))
		return

	var/list/pool

	switch(T.type)
		if(/obj/effect/track/structure)
			pool = structure_track_pool
		if(/obj/effect/track/thievescant)
			pool = thievescant_pool
		else
			pool = track_pool

	if(length(pool) >= pool_max_size)
		qdel(T)
		return

	T.soft_reset()
	T.moveToNullspace()
	pool += T
