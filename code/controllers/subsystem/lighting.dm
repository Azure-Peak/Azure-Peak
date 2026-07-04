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

	var/list/queue = sources_queue
	// anything added while processing gets deferred to the next tick
	var/current_index = 0
	while(current_index < length(queue))
		current_index += 1
		var/datum/light_source/L = queue[current_index]

		L.update_corners()
		// update_corners() can qdel(L) in certain conditions, and we don't count
		// those for the cut because they're already removed from the queue
		if(!QDELING(L))
			L.needs_update = LIGHTING_NO_UPDATE
		else
			current_index -= 1

		if(init_tick_checks)
			if(!TICK_CHECK)
				continue
			queue.Cut(1, current_index + 1)
			current_index = 0
			stoplag()
		else if(MC_TICK_CHECK)
			break
	if(current_index)
		queue.Cut(1, current_index + 1)
		current_index = 0

	if(!init_tick_checks)
		MC_SPLIT_TICK

	queue = corners_queue
	while(current_index < length(queue))
		current_index += 1
		var/datum/lighting_corner/C = queue[current_index]

		C.update_objects()
		C.needs_update = FALSE //update_objects() can call qdel if the corner is storing no data
		if(QDELING(C))
			current_index -= 1

		if(init_tick_checks)
			if(!TICK_CHECK)
				continue
			queue.Cut(1, current_index + 1)
			current_index = 0
			stoplag()
		else if(MC_TICK_CHECK)
			break
	if(current_index)
		queue.Cut(1, current_index + 1)
		current_index = 0

	if(!init_tick_checks)
		MC_SPLIT_TICK

	queue = objects_queue
	while(current_index < length(queue))
		current_index += 1
		var/atom/movable/lighting_object/O = queue[current_index]

		if(QDELETED(O))
			continue

		// these can't delete themselves in update(), so nothing here is removed from the queue mid-loop
		O.update()
		O.needs_update = FALSE

		if(init_tick_checks)
			if(!TICK_CHECK)
				continue
			queue.Cut(1, current_index + 1)
			current_index = 0
			stoplag()
		else if(MC_TICK_CHECK)
			break
	if(current_index)
		queue.Cut(1, current_index + 1)
		current_index = 0

	if(!init_tick_checks)
		MC_SPLIT_TICK

/datum/controller/subsystem/lighting/Recover()
	if(SSlighting)
		initialized = SSlighting.initialized

	..()

#undef LIGHTING_INITIAL_FIRE_DELAY
