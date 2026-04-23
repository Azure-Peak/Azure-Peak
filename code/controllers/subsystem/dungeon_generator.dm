#define STAGE_EXPANSION 1
#define STAGE_CLEANUP 2

SUBSYSTEM_DEF(dungeon_generator)
	name = "Dungeon Generator"
	init_order = 15
	runlevels = RUNLEVEL_GAME | RUNLEVEL_INIT | RUNLEVEL_LOBBY | RUNLEVEL_SETUP
	wait = 1.5 SECONDS 

	var/list/parent_types = list()
	var/list/templates_by_category = list() 
	var/list/markers = list() 
	var/list/failed_markers = list() 
	var/list/placed_count = list()

	var/generation_stage = STAGE_EXPANSION
	var/repetition_penalty = 2

	var/target_z = 0
	var/setup_done = FALSE
	var/loot_pool_finalized = FALSE
	var/last_placement_time = 0
	/// Quiet period (deciseconds) after the last placement before we consider generation done.
	var/finalize_quiet_period = 30 SECONDS

	var/prot_min_x = 0; var/prot_max_x = 0; var/prot_min_y = 0; var/prot_max_y = 0

/datum/controller/subsystem/dungeon_generator/Initialize(start_timeofday)
	var/list/dungeon_templates = list()
	for(var/path in subtypesof(/datum/map_template/dungeon))
		var/datum/map_template/dungeon/path_type = path
		if(initial(path_type.abstract_type) == path || ispath(path, /datum/map_template/dungeon/entry))
			continue 

		var/datum/map_template/dungeon/T = new path
		if(!T || !T.mappath) continue

		parent_types[path] = initial(path_type.type_weight) || 10
		dungeon_templates += T

	
	templates_by_category[/datum/map_template/dungeon] = dungeon_templates

	addtimer(CALLBACK(src, .proc/find_initial_map_data), 50) 
	return ..()

/datum/controller/subsystem/dungeon_generator/proc/find_initial_map_data()
	var/list/found_points = list()
	for(var/obj/effect/dungeon_directional_helper/H in world)
		if(!target_z)
			target_z = H.z
		if(H.z == target_z)
			found_points += H

	if(!length(found_points)) return

	if(SSmapping.z_list.len < target_z + 1)
		SSmapping.add_new_zlevel("Dungeon Upper Layer", list(ZTRAIT_AWAY = TRUE))

	if(length(found_points) >= 4)
		var/obj/F = found_points[1]
		prot_min_x = F.x; prot_max_x = F.x; prot_min_y = F.y; prot_max_y = F.y
		for(var/i in 1 to 4)
			var/obj/O = found_points[i]
			prot_min_x = min(prot_min_x, O.x); prot_max_x = max(prot_max_x, O.x)
			prot_min_y = min(prot_min_y, O.y); prot_max_y = max(prot_max_y, O.y)
	
	markers |= found_points
	setup_done = TRUE
	last_placement_time = world.time

/datum/controller/subsystem/dungeon_generator/fire(resumed)
	if(!setup_done) return

	if(!loot_pool_finalized && (world.time - last_placement_time) >= finalize_quiet_period)
		loot_pool_finalized = TRUE
		process_deferred_loot_pool("tomb_of_alotheos")

	if(!length(markers) && !length(failed_markers))
		return

	if(generation_stage == STAGE_EXPANSION)
		if(length(markers))
			process_markers(10)
		else
			generation_stage = STAGE_CLEANUP
	else if(generation_stage == STAGE_CLEANUP)
		if(length(failed_markers))
			process_failed_markers(10)
		else
			generation_stage = STAGE_EXPANSION

/datum/controller/subsystem/dungeon_generator/proc/process_markers(limit)
	var/processed = 0
	while(length(markers) && processed < limit)
		var/idx = rand(1, length(markers))
		var/obj/effect/dungeon_directional_helper/helper = markers[idx]
		markers.Cut(idx, idx + 1)
		
		if(helper && !QDELETED(helper))
			if(!try_grow_at_marker(helper))
				failed_markers |= helper
		processed++

/datum/controller/subsystem/dungeon_generator/proc/try_grow_at_marker(obj/effect/dungeon_directional_helper/helper)
	var/turf/origin = get_turf(helper)
	var/direction = helper.dir
	var/turf/start_step = get_step(origin, direction)
	if(!start_step) return FALSE

	if(start_step.density && !is_strictly_void(start_step))
		if(!is_protected(start_step.x, start_step.y) && prob(40))
			return try_bridge_gap(helper, start_step)
		return FALSE

	var/list/area_dims = scan_free_area(start_step, direction)
	var/max_dist = area_dims["h"]
	if(max_dist < 4) return FALSE 

	var/opp_dir = reverse_direction(direction)
	
	
	var/list/all_templates = templates_by_category[/datum/map_template/dungeon]
	var/list/checking_list = shuffle(all_templates.Copy())
	
	for(var/datum/map_template/dungeon/T in checking_list)
		if(T.width > (max_dist * 2) || T.height > (max_dist * 2)) continue
		var/offset = T.get_dir_offset(opp_dir)
		if(offset == null) continue

		var/spawn_x = start_step.x; var/spawn_y = start_step.y
		if(direction == NORTH) spawn_x -= offset
		else if(direction == SOUTH) { spawn_x -= offset; spawn_y -= (T.height - 1); }
		else if(direction == EAST) spawn_y -= offset
		else if(direction == WEST) { spawn_x -= (T.width - 1); spawn_y -= offset; }

		var/turf/placement = locate(spawn_x, spawn_y, target_z)
		if(can_place(T, placement))
			if(T.load(placement))
				on_template_placed(T, placement)
				qdel(helper)
				return TRUE
		CHECK_TICK
	return FALSE

/datum/controller/subsystem/dungeon_generator/proc/try_bridge_gap(obj/effect/dungeon_directional_helper/helper, turf/target_turf)
	if(!target_turf || !istype(target_turf, /turf/closed/wall/mineral/rogue)) return FALSE
	target_turf.ChangeTurf(/turf/open/floor/rogue/hexstone, null, CHANGETURF_INHERIT_AIR | CHANGETURF_IGNORE_AIR)
	qdel(helper)
	return TRUE

/datum/controller/subsystem/dungeon_generator/proc/scan_free_area(turf/start_T, dir)
	var/depth = 0
	for(var/i in 1 to 30)
		var/turf/T = get_step_dist(start_T, dir, i)
		if(!T || !is_strictly_void(T) || is_protected(T.x, T.y)) break
		depth = i
	return list("h" = depth) 

/datum/controller/subsystem/dungeon_generator/proc/get_step_dist(turf/start, dir, dist)
	var/tx = start.x; var/ty = start.y
	switch(dir)
		if(NORTH) ty += dist
		if(SOUTH) ty -= dist
		if(EAST) tx += dist
		if(WEST) tx -= dist
	return locate(tx, ty, target_z)

/datum/controller/subsystem/dungeon_generator/proc/can_place(datum/map_template/dungeon/T, turf/start_T)
	if(!start_T) return FALSE
	var/ex = start_T.x + T.width - 1
	var/ey = start_T.y + T.height - 1
	if(ex > world.maxx || ey > world.maxy || start_T.x < 1 || start_T.y < 1) return FALSE

	for(var/z_off in 0 to 1)
		var/cz = target_z + z_off
		if(cz > world.maxz) return FALSE
		for(var/turf/test in block(locate(start_T.x, start_T.y, cz), locate(ex, ey, cz)))
			if(z_off == 0)
				if(!is_strictly_void(test) || is_protected(test.x, test.y)) return FALSE
			else
				if(test.density && !is_strictly_void(test)) return FALSE
			for(var/obj/O in test)
				if(istype(O, /obj/effect/dungeon_directional_helper)) continue
				if(O.density) return FALSE
	return TRUE

/datum/controller/subsystem/dungeon_generator/proc/is_protected(x, y)
	return (x > prot_min_x && x < prot_max_x && y > prot_min_y && y < prot_max_y)

/datum/controller/subsystem/dungeon_generator/proc/is_strictly_void(turf/T)
	if(!T) return FALSE
	return (istype(T, /turf/closed/dungeon_void) || istype(T, /turf/closed/mineral/rogue/bedrock))

/datum/controller/subsystem/dungeon_generator/proc/on_template_placed(datum/map_template/dungeon/T, turf/placement)
	placed_count[T.type]++
	last_placement_time = world.time

/datum/controller/subsystem/dungeon_generator/proc/reverse_direction(dir)
	switch(dir)
		if(NORTH) return SOUTH
		if(SOUTH) return NORTH
		if(EAST)  return WEST
		if(WEST)  return EAST
	return dir

/datum/map_template/dungeon/proc/get_dir_offset(dir)
	switch(dir)
		if(NORTH) return north_offset
		if(SOUTH) return south_offset
		if(EAST) return east_offset
		if(WEST) return west_offset
	return null

/datum/controller/subsystem/dungeon_generator/proc/process_failed_markers(limit)
	var/processed = 0
	while(length(failed_markers) && processed < limit)
		var/obj/effect/dungeon_directional_helper/helper = failed_markers[1]
		failed_markers.Cut(1, 2)
		if(helper && !QDELETED(helper))
			try_spawn_filler(helper.dir, get_turf(helper))
			qdel(helper)
		processed++

/datum/controller/subsystem/dungeon_generator/proc/try_spawn_filler(direction, turf/target_turf)
	var/opp_dir = reverse_direction(direction)
	
	
	var/list/all_templates = templates_by_category[/datum/map_template/dungeon]
	var/list/checking_list = shuffle(all_templates.Copy())
	
	for(var/datum/map_template/dungeon/T in checking_list)
		if(T.width > 6 || T.height > 6) continue 
		var/offset = T.get_dir_offset(opp_dir)
		if(offset == null) continue
		var/spawn_x = target_turf.x; var/spawn_y = target_turf.y
		if(direction == NORTH) spawn_x -= offset
		else if(direction == SOUTH) { spawn_x -= offset; spawn_y -= (T.height - 1); }
		else if(direction == EAST) spawn_y -= offset
		else if(direction == WEST) { spawn_x -= (T.width - 1); spawn_y -= offset; }

		var/turf/start_turf = locate(spawn_x, spawn_y, target_z)
		if(can_place(T, start_turf))
			if(T.load(start_turf))
				on_template_placed(T, start_turf)
				return TRUE
	return FALSE

#undef STAGE_EXPANSION
#undef STAGE_CLEANUP
