SUBSYSTEM_DEF(rivers)
	name = "Rivers"
	flags = SS_KEEP_TIMING | SS_NO_INIT
	wait = 0.5 SECONDS
	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/rivers/stat_entry()
	..("ACTIVE RIVER TILES:[processing.len]")


/datum/controller/subsystem/rivers/fire(resumed = 0)
	if (!resumed || !src.currentrun.len)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/turf/thing = currentrun[currentrun.len]
		currentrun.len--
		if(!istype(thing, /turf/open/water/river))
			processing -= thing
			continue
		var/turf/open/water/river/river = thing
		if(!QDELETED(river))
			river.process_river()
		else
			processing -= river

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/rivers/Recover()
	if (istype(SSrivers.processing))
		processing = SSrivers.processing

/turf/open/water/river/Destroy()
	STOP_PROCESSING(SSrivers, src)
	..()
