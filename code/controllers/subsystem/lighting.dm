#define LIGHTING_INITIAL_FIRE_DELAY 2

SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = 0
	init_order = INIT_ORDER_LIGHTING
	flags = SS_TICKER
	priority = FIRE_PRIORITY_DEFAULT
	var/static/list/sources_queue = list()
	var/static/list/corners_queue = list()
	var/static/list/objects_queue = list()
	processing_flag = PROCESSING_LIGHTING

/datum/controller/subsystem/lighting/stat_entry()
	return ..("L:[length(sources_queue)]|C:[length(corners_queue)]|O:[length(objects_queue)]")

/datum/controller/subsystem/lighting/Initialize(timeofday)
	if(!initialized)
		if(CONFIG_GET(flag/starlight))
			for(var/I in GLOB.sortedAreas)
				var/area/A = I
				if(A.dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
					A.luminosity = 0

		create_all_lighting_objects()
		initialized = TRUE

	can_fire = FALSE
	addtimer(CALLBACK(src, PROC_REF(enable_lighting)), LIGHTING_INITIAL_FIRE_DELAY)

	return ..()

/datum/controller/subsystem/lighting/proc/enable_lighting()
	can_fire = TRUE

/datum/controller/subsystem/lighting/fire(resumed, init_tick_checks)
	MC_SPLIT_TICK_INIT(3)

	if(!init_tick_checks)
		MC_SPLIT_TICK

	while(length(sources_queue))
		var/datum/light_source/L = sources_queue[1]
		sources_queue.Cut(1, 2)

		if(!L || QDELETED(L))
			continue

		L.update_corners()
		L.needs_update = LIGHTING_NO_UPDATE

		if(init_tick_checks)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			break

	if(!init_tick_checks)
		MC_SPLIT_TICK

	while(length(corners_queue))
		var/datum/lighting_corner/C = corners_queue[1]
		corners_queue.Cut(1, 2)

		if(!C || QDELETED(C))
			continue

		C.update_objects()
		C.needs_update = FALSE

		if(init_tick_checks)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			break

	if(!init_tick_checks)
		MC_SPLIT_TICK

	while(length(objects_queue))
		var/atom/movable/lighting_object/O = objects_queue[1]
		objects_queue.Cut(1, 2)

		if(!O || QDELETED(O))
			continue

		O.update()
		O.needs_update = FALSE

		if(init_tick_checks)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			break

/datum/controller/subsystem/lighting/Recover()
	if(SSlighting)
		initialized = SSlighting.initialized

	..()

#undef LIGHTING_INITIAL_FIRE_DELAY
