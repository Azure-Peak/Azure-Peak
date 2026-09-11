/proc/telegraph_cardinal(dir)
	if(dir & NORTH)
		return NORTH
	if(dir & SOUTH)
		return SOUTH
	if(dir & EAST)
		return EAST
	if(dir & WEST)
		return WEST
	return NORTH

/proc/telegraph_rotate_offset(dx, dy, facing)
	switch(facing)
		if(SOUTH)
			return list(-dx, -dy)
		if(EAST)
			return list(dy, -dx)
		if(WEST)
			return list(-dy, dx)
	return list(dx, dy)

/proc/telegraph_path_blocked(turf/origin, turf/target)
	if(!origin || !target || origin == target)
		return null
	for(var/turf/step in getline(origin, target))
		if(step == origin)
			continue
		if(step == target)
			break
		if(step.density)
			return step
		for(var/obj/structure/S in step)
			if(S.density && !S.climbable)
				return step
	return null

/proc/telegraph_resolve_turfs(turf/origin, facing, list/offs, stop_at_dense = TRUE)
	var/list/wanted = list()
	if(!origin)
		return wanted
	for(var/list/off in offs)
		var/list/r = telegraph_rotate_offset(off[1], off[2], facing)
		var/turf/T = locate(origin.x + r[1], origin.y + r[2], origin.z)
		if(!T || T.density)
			continue
		if(stop_at_dense && telegraph_path_blocked(origin, T))
			continue
		wanted |= T
	return wanted

/proc/telegraph_apply(list/indicator, list/wanted, telegraph_type)
	var/list/missing = wanted.Copy()
	for(var/obj/effect/old in indicator.Copy())
		var/turf/ot = get_turf(old)
		if(!QDELETED(old) && (ot in missing))
			missing -= ot
		else
			indicator -= old
			qdel(old)
	for(var/turf/T in missing)
		indicator += new telegraph_type(T)

/proc/telegraph_draw(turf/origin, facing, list/indicator, list/offs, telegraph_type, stop_at_dense = TRUE)
	telegraph_apply(indicator, telegraph_resolve_turfs(origin, facing, offs, stop_at_dense), telegraph_type)

/proc/telegraph_clear(list/indicator)
	for(var/obj/effect/old in indicator)
		if(!QDELETED(old))
			qdel(old)
	indicator.Cut()
