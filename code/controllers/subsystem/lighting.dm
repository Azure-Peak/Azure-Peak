#define LIGHTING_INITIAL_FIRE_DELAY 1

SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = 0
	init_order = INIT_ORDER_LIGHTING
	flags = SS_TICKER
	priority = FIRE_PRIORITY_DEFAULT
	var/static/list/sources_queue = list() // List of lighting sources queued for update.
	var/static/list/corners_queue = list() // List of lighting corners queued for update.
	var/static/list/objects_queue = list() // List of lighting objects queued for update.
	processing_flag = PROCESSING_LIGHTING

/datum/controller/subsystem/lighting/stat_entry()
	..("L:[length(sources_queue)]|C:[length(corners_queue)]|O:[length(objects_queue)]")


/datum/controller/subsystem/lighting/Initialize(timeofday)
	if(!initialized)
		if (CONFIG_GET(flag/starlight))
			for(var/I in GLOB.sortedAreas)
				var/area/A = I
				if (A.dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
					A.luminosity = 0

		create_all_lighting_objects()
		initialized = TRUE

	addtimer(CALLBACK(src, PROC_REF(deferred_initial_fire)), LIGHTING_INITIAL_FIRE_DELAY)

	return ..()

/datum/controller/subsystem/lighting/proc/deferred_initial_fire()
	fire(FALSE, TRUE)

/datum/controller/subsystem/lighting/fire(resumed, init_tick_checks)
	if(!sources_queue.len && !corners_queue.len && !objects_queue.len)
		return

	MC_SPLIT_TICK_INIT(3)
	if(!init_tick_checks)
		MC_SPLIT_TICK

	var/list/queue

	queue = sources_queue
	while(queue.len)
		var/datum/light_source/L = queue[1]
		queue.Cut(1, 2)
		L.update_corners()
		L.needs_update = LIGHTING_NO_UPDATE
		if(init_tick_checks)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			break

	if(!init_tick_checks)
		MC_SPLIT_TICK

	queue = corners_queue
	while(queue.len)
		var/datum/lighting_corner/C = queue[1]
		queue.Cut(1, 2)
		C.update_objects()
		C.needs_update = FALSE
		if(init_tick_checks)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			break

	if(!init_tick_checks)
		MC_SPLIT_TICK

	queue = objects_queue
	while(queue.len)
		var/atom/movable/lighting_object/O = queue[1]
		queue.Cut(1, 2)
		if(QDELETED(O))
			continue
		O.update()
		O.needs_update = FALSE
		if(init_tick_checks)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			break

/datum/controller/subsystem/lighting/Recover()
	initialized = SSlighting.initialized
	..()

#undef LIGHTING_INITIAL_FIRE_DELAY
