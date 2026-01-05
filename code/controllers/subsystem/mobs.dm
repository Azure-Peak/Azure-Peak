
SUBSYSTEM_DEF(mobs)
	name = "Mobs (Alive)"
	priority = FIRE_PRIORITY_MOBS
	flags = SS_KEEP_TIMING | SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/static/list/clients_by_zlevel[][]
	var/static/list/dead_players_by_zlevel[][] = list(list()) // Needs to support zlevel 1 here, MaxZChanged only happens when z2 is created and new_players can login before that.
	var/static/list/cubemonkeys = list()
	var/alive_mobs = 0


/datum/controller/subsystem/mobs/stat_entry()
	..("P:[GLOB.mob_living_list.len]")

/datum/controller/subsystem/mobs/proc/MaxZChanged()
	if (!islist(clients_by_zlevel))
		clients_by_zlevel = new /list(world.maxz,0)
		dead_players_by_zlevel = new /list(world.maxz,0)
	while (clients_by_zlevel.len < world.maxz)
		clients_by_zlevel.len++
		clients_by_zlevel[clients_by_zlevel.len] = list()
		dead_players_by_zlevel.len++
		dead_players_by_zlevel[dead_players_by_zlevel.len] = list()

/datum/controller/subsystem/mobs/proc/MaxZDec()
	if (!islist(clients_by_zlevel))
		clients_by_zlevel = new /list(world.maxz,0)
		dead_players_by_zlevel = new /list(world.maxz,0)
	while (clients_by_zlevel.len > world.maxz)
		clients_by_zlevel.len--
//		clients_by_zlevel[clients_by_zlevel.len] = list()
		dead_players_by_zlevel.len--
//		dead_players_by_zlevel[dead_players_by_zlevel.len] = list()


/datum/controller/subsystem/mobs/fire(resumed = 0)
	var/seconds = wait * 0.1
	if (!resumed)
		src.currentrun = GLOB.mob_living_list.Copy()
		alive_mobs = 0

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	while(currentrun.len)
		var/mob/living/L = currentrun[currentrun.len]
		currentrun.len--
		if(!L || QDELETED(L))
			GLOB.mob_living_list.Remove(L)
			continue
		if(L.stat != DEAD)
			L.Life(seconds, times_fired)
			alive_mobs++
		if (MC_TICK_CHECK)
			return

SUBSYSTEM_DEF(mobs_dead)
	name = "Mobs (Dead)"
	priority = FIRE_PRIORITY_MOBS_DEAD
	flags = SS_KEEP_TIMING | SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 6 SECONDS

	var/list/currentrun = list()
	var/dead_mobs = 0

/datum/controller/subsystem/mobs_dead/fire(resumed = 0)
	if (!resumed)
		src.currentrun = GLOB.mob_living_list.Copy()
		dead_mobs = 0
	
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while (currentrun.len)
		var/mob/living/L = currentrun[currentrun.len]
		currentrun.len--
		if(!L || QDELETED(L))
			GLOB.mob_living_list.Remove(L)
			continue
		if (L.stat == DEAD)
			L.DeadLife()
			dead_mobs++
		if (MC_TICK_CHECK)
			return
		
/datum/controller/subsystem/mobs_dead/stat_entry(msg)
	..("C:[dead_mobs]")
