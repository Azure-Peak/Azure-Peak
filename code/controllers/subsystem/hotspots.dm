SUBSYSTEM_DEF(hotspots)
	name = "Fire Hotspots"
	priority = FIRE_PRIORITY_HOTSPOTS
	flags = SS_NO_INIT|SS_BACKGROUND
	wait = 1 SECONDS
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	var/list/hotspots = list()
	var/list/currentrun = list()

/datum/controller/subsystem/hotspots/stat_entry()
	return ..("P:[hotspots.len]")

/datum/controller/subsystem/hotspots/fire(resumed = 0)
	if (!resumed)
		src.currentrun = hotspots.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/obj/effect/hotspot/H = currentrun[currentrun.len]
		currentrun.len--
		if (!QDELETED(H))
			H.process()
		if(MC_TICK_CHECK)
			return
