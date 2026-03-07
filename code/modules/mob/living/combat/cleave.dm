/datum/cleave_pattern
	var/list/tile_offsets = list()
	/// Optional explicit offsets for diagonal directions (NE baseline). Rotated to other diagonals via 90° steps.
	/// If null, diagonal uses the standard rotation math on tile_offsets.
	var/list/diagonal_offsets
	/// Description shown in examine for diagonal behavior. Only shown if diagonal_offsets is set.
	var/diagonal_desc
	var/max_targets = 1
	var/respect_dir = TRUE
	/// If TRUE, offsets are relative to the user's turf instead of the target's turf.
	var/user_relative = FALSE
	var/desc = "Cleaves into nearby targets."

/datum/cleave_pattern/proc/get_facing_dir(mob/living/user, turf/origin)
	var/use_dir = user.dir
	// If already cardinal, use it directly
	if(!(use_dir & (use_dir - 1)))
		// Check if we should be diagonal based on origin position
		if(origin)
			var/turf/user_turf = get_turf(user)
			var/rel_x = origin.x - user_turf.x
			var/rel_y = origin.y - user_turf.y
			if(rel_x && rel_y)
				// Origin is diagonal from user — use diagonal dir
				var/dir_x = rel_x > 0 ? EAST : WEST
				var/dir_y = rel_y > 0 ? NORTH : SOUTH
				return dir_x | dir_y
		return use_dir
	// Already diagonal
	return use_dir

/// Rotates an offset (dx, dy) from north-facing baseline to the given direction.
/datum/cleave_pattern/proc/rotate_offset(dx, dy, dir)
	switch(dir)
		if(SOUTH)
			return list(-dx, -dy)
		if(WEST)
			return list(-dy, dx)
		if(EAST)
			return list(dy, -dx)
		if(NORTHEAST)
			return list(dx + dy, -dx + dy)
		if(NORTHWEST)
			return list(dx - dy, dx + dy)
		if(SOUTHEAST)
			return list(-dx + dy, -dx - dy)
		if(SOUTHWEST)
			return list(-dx - dy, dx - dy)
	// NORTH or default — identity
	return list(dx, dy)

/datum/cleave_pattern/proc/get_cleave_turfs(mob/living/user, turf/origin)
	var/list/turfs = list()
	if(!origin || !user)
		return turfs
	var/use_dir = get_facing_dir(user, origin)
	var/turf/base_turf = user_relative ? get_turf(user) : origin
	var/is_diagonal = use_dir & (use_dir - 1) // TRUE if diagonal
	// Use explicit diagonal offsets if available and facing diagonally
	var/list/offsets = (is_diagonal && diagonal_offsets) ? diagonal_offsets : tile_offsets
	// For diagonal_offsets, they're defined as NE baseline — rotate to the actual diagonal via 90° steps
	var/rotate_dir = use_dir
	if(is_diagonal && diagonal_offsets)
		switch(use_dir)
			if(NORTHEAST)
				rotate_dir = NORTH // identity — NE baseline needs no rotation
			if(NORTHWEST)
				rotate_dir = WEST
			if(SOUTHEAST)
				rotate_dir = EAST
			if(SOUTHWEST)
				rotate_dir = SOUTH
	for(var/list/offset in offsets)
		var/dx = offset[1]
		var/dy = offset[2]
		if(respect_dir)
			var/list/rotated = rotate_offset(dx, dy, rotate_dir)
			dx = rotated[1]
			dy = rotated[2]
		var/turf/T = locate(base_turf.x + dx, base_turf.y + dy, base_turf.z)
		if(T && isturf(T) && !T.density)
			turfs += T
	return turfs

/datum/cleave_pattern/proc/count_cleave_targets(mob/living/user, mob/living/primary, list/cleave_turfs)
	var/count = 0
	for(var/turf/T in cleave_turfs)
		for(var/mob/living/L in T)
			if(L == primary || L == user)
				continue
			count++
			if(max_targets && count >= max_targets)
				return count
	return count

/// Renders a grid display for a set of offsets. target_pos and user_pos are (x,y) lists for T and U markers.
/datum/cleave_pattern/proc/render_grid(list/offsets, list/target_pos, list/user_pos)
	var/list/all_points = list(list(target_pos[1], target_pos[2]))
	for(var/list/offset in offsets)
		all_points += list(list(offset[1], offset[2]))
	var/min_x = min(target_pos[1], user_pos[1])
	var/max_x = max(target_pos[1], user_pos[1])
	var/min_y = min(target_pos[2], user_pos[2])
	var/max_y = max(target_pos[2], user_pos[2])
	for(var/list/p in all_points)
		min_x = min(min_x, p[1])
		max_x = max(max_x, p[1])
		min_y = min(min_y, p[2])
		max_y = max(max_y, p[2])
	var/list/rows = list()
	for(var/y = max_y, y >= min_y, y--)
		var/row = ""
		for(var/x = min_x, x <= max_x, x++)
			var/found = FALSE
			if(x == target_pos[1] && y == target_pos[2])
				row += "<font color='#fa4'>T</font>"
				found = TRUE
			else if(x == user_pos[1] && y == user_pos[2])
				row += "<font color='#4af'>U</font>"
				found = TRUE
			if(!found)
				for(var/list/p in all_points)
					if(p[1] == x && p[2] == y)
						row += "<font color='#f44'>X</font>"
						found = TRUE
						break
			if(!found)
				row += "<font color='#888'>O</font>"
		rows += row
	return rows.Join("\n")

/datum/cleave_pattern/proc/get_pattern_display()
	var/result
	if(user_relative)
		// User-relative: user at (0,0), target at (0,1) facing north
		result = render_grid(tile_offsets, list(0, 1), list(0, 0))
	else
		// Target-relative: target at (0,0), user at (0,-1) facing north
		result = render_grid(tile_offsets, list(0, 0), list(0, -1))
	if(diagonal_offsets)
		result += "\n<font color='#aaa'>Diagonal:</font>\n"
		if(user_relative)
			// Offsets relative to user at (0,0), target at (1,1)
			result += render_grid(diagonal_offsets, list(1, 1), list(0, 0))
		else
			// Offsets relative to target at (0,0), user at (-1,-1)
			result += render_grid(diagonal_offsets, list(0, 0), list(-1, -1))
	return result

/datum/cleave_pattern/proc/show_cleave_visuals(mob/living/user, turf/origin)
	var/resolved_dir = get_facing_dir(user, origin)
	var/list/turfs = get_cleave_turfs(user, origin)
	if(!(origin in turfs))
		turfs += origin
	for(var/turf/T in turfs)
		new /obj/effect/temp_visual/dir_setting/cleave_visual(T, resolved_dir)

/obj/effect/temp_visual/dir_setting/cleave_visual
	layer = HUD_LAYER
	plane = ABOVE_LIGHTING_PLANE
	icon = 'icons/effects/effects.dmi'
	icon_state = "cut"
	duration = 5

// ---- Predefined Patterns ----

/datum/cleave_pattern/adjacent
	tile_offsets = list(list(-1, 0), list(1, 0))
	max_targets = 1
	desc = "Cleaves into an adjacent target."

/datum/cleave_pattern/forward_cleave
	tile_offsets = list(list(0, 1))
	max_targets = 1
	desc = "Cleaves forward into a second target."

/datum/cleave_pattern/wide_sweep
	tile_offsets = list(list(-1, 0), list(1, 0), list(0, -1), list(0, 1))
	max_targets = 2
	desc = "Sweeps wide, cleaving up to two nearby targets."

/datum/cleave_pattern/horizontal_sweep
	tile_offsets = list(list(-1, 0), list(0, 0), list(1, 0))
	// NE baseline: target tile + two adjacent tiles on user's side
	diagonal_offsets = list(list(-1, 0), list(0, 0), list(0, -1))
	diagonal_desc = "Fans out in an L shape when diagonally swept."
	max_targets = 2
	desc = "Sweeps horizontally, cleaving up to two additional targets."

/datum/cleave_pattern/frontal_arc
	tile_offsets = list(list(-1, 0), list(1, 0), list(-1, 1), list(0, 1), list(1, 1))
	// NE baseline: arc wrapping from upper-left around to lower-right
	diagonal_offsets = list(list(-1, 1), list(0, 1), list(1, 0), list(1, -1))
	diagonal_desc = "Fans out in an L shape when diagonally swept."
	user_relative = TRUE
	max_targets = 4 // Anti Dorpel pattern.
	desc = "Sweeps in a massive arc, hitting up to four targets to the sides and ahead."

/datum/cleave_pattern/lance
	tile_offsets = list(list(0, 1), list(0, 2))
	max_targets = 1
	desc = "Lances forward, skewering a target three tiles ahead and anyone behind them."
