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
		var/turf/open/water/river/thing = currentrun[currentrun.len]
		currentrun.len--
		if(!QDELETED(thing))
			thing.process_river()
		else
			processing -= thing
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/rivers/Recover()
	if (istype(SSrivers.processing))
		processing = SSrivers.processing
