PROCESSING_SUBSYSTEM_DEF(idlenpcpool)
	name = "Idling NPC Pool"
	flags = SS_POST_FIRE_TIMING|SS_BACKGROUND|SS_NO_INIT
	priority = FIRE_PRIORITY_IDLE_NPC
	wait = 6 SECONDS
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/static/list/idle_mobs_by_zlevel[][]

/datum/controller/subsystem/processing/idlenpcpool/stat_entry()
	var/list/idlelist = GLOB.simple_animals[AI_IDLE]
	var/list/zlist = GLOB.simple_animals[AI_Z_OFF]
	..("IdleNPCS:[idlelist.len]|Z:[zlist.len]")

/datum/controller/subsystem/processing/idlenpcpool/proc/MaxZChanged()
	if (!islist(idle_mobs_by_zlevel))
		idle_mobs_by_zlevel = new /list(world.maxz,0)
	while (SSidlenpcpool.idle_mobs_by_zlevel.len < world.maxz)
		SSidlenpcpool.idle_mobs_by_zlevel.len++
		SSidlenpcpool.idle_mobs_by_zlevel[idle_mobs_by_zlevel.len] = list()

/datum/controller/subsystem/processing/idlenpcpool/proc/MaxZdec()
	if (!islist(idle_mobs_by_zlevel))
		idle_mobs_by_zlevel = new /list(world.maxz,0)
	while (SSidlenpcpool.idle_mobs_by_zlevel.len > world.maxz)
		SSidlenpcpool.idle_mobs_by_zlevel.len--
