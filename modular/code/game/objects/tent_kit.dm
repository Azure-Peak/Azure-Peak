/obj/item/tent_kit
	name = "tent kit"
	desc = "A compact kit containing everything needed to set up a weatherproof tent. The tent will be oriented based on the direction you're facing when assembling."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "tent_kit"
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 32
	grid_height = 96
	var/assembled = FALSE
	var/list/obj/structure/tent_wall/tent_walls = list()
	var/list/obj/structure/roguetent/tent_doors = list()
	var/list/turf/roof_tiles = list()
	var/tent_width = 3 //! Always 3 wide
	var/tent_length = 5 // Default length, can be adjusted for deluxes
	//repair vars
	var/repair_debt_cloth = 0
	var/repair_debt_silk = 0

/obj/item/tent_kit/Initialize()
	. = ..()
	create_tent_components()

/obj/item/tent_kit/proc/create_tent_components()
	// Calculate walls needed for tent shape (ground level + upper level)
	var/ground_walls = (tent_length + tent_width) * 2 - 4 - 2 // Perimeter minus corners minus 2 door spaces
	var/upper_walls = tent_length + tent_width - 3 // Upper level (smaller perimeter)
	var/max_walls = ground_walls + upper_walls
	var/max_doors = 2 // Only 2 doors total

	for(var/i = 1 to max_walls)
		var/obj/structure/tent_wall/wall = new(src)
		tent_walls += wall

	for(var/i = 1 to max_doors)
		var/obj/structure/roguetent/door = new(src)
		tent_doors += door

/obj/item/tent_kit/Destroy()
	for(var/obj/structure/tent_wall/wall in tent_walls)
		if(wall) qdel(wall)
	for(var/obj/structure/roguetent/door in tent_doors)
		if(door) qdel(door)
	tent_walls.Cut()
	tent_doors.Cut()
	roof_tiles.Cut()
	return ..()

/obj/item/tent_kit/proc/clean_components()
	for(var/i = tent_walls.len to 1 step -1)
		if(!tent_walls[i] || QDELETED(tent_walls[i]))
			tent_walls.Cut(i, i+1)

	for(var/i = tent_doors.len to 1 step -1)
		if(!tent_doors[i] || QDELETED(tent_doors[i]))
			tent_doors.Cut(i, i+1)

/obj/item/tent_kit/attack_self(mob/user)
	if(assembled)
		to_chat(user, span_warning("The tent is already assembled! Use it to disassemble."))
		return

	var/turf/setup_turf = get_turf(user)
	if(!setup_turf)
		return

	var/assembly_dir = user.dir
	if(!check_assembly_space(setup_turf, user, assembly_dir))
		return

	to_chat(user, span_notice("You begin assembling the tent facing [dir2text(assembly_dir)]..."))
	if(!do_after(user, 10 SECONDS, target = src))
		to_chat(user, span_warning("Your tent assembly was interrupted!"))
		return

	assemble_tent(setup_turf, user, assembly_dir)

/obj/item/tent_kit/proc/check_assembly_space(turf/center_turf, mob/user, assembly_dir)
	var/list/tent_coords = get_tent_coordinates(center_turf, assembly_dir)
	var/list/upper_coords = get_upper_tent_coordinates(center_turf, assembly_dir)

	// Check ground level space
	for(var/turf/check_turf in tent_coords)
		if(!check_turf || check_turf.density)
			to_chat(user, span_warning("There isn't enough clear ground space here!"))
			return FALSE

		for(var/obj/O in check_turf.contents)
			if(O.density)
				to_chat(user, span_warning("There are objects blocking the tent area!"))
				return FALSE

	// Check upper level space if possible
	var/can_build_above = TRUE
	for(var/turf/check_turf in tent_coords)
		var/turf/upper_turf = GET_TURF_ABOVE(check_turf)
		if(!upper_turf || !is_openspace(upper_turf))
			can_build_above = FALSE
			break

	if(can_build_above)
		for(var/turf/check_turf in upper_coords)
			if(!check_turf || check_turf.density)
				can_build_above = FALSE
				break
			for(var/obj/O in check_turf)
				if(O.density)
					can_build_above = FALSE
					break

	if(!can_build_above)
		to_chat(user, span_notice("No room above - tent will provide overhead protection via roof coverage."))

	return TRUE

/obj/item/tent_kit/proc/get_tent_coordinates(turf/center_turf, assembly_dir)
	var/list/coords = list()
	var/width_offset = round((tent_width - 1) / 2)
	var/length_offset = round((tent_length - 1) / 2)

	switch(assembly_dir)
		if(NORTH, SOUTH)
			// Tent runs north-south (length), east-west (width)
			for(var/x = -width_offset to width_offset)
				for(var/y = -length_offset to length_offset)
					var/turf/T = locate(center_turf.x + x, center_turf.y + y, center_turf.z)
					if(T) coords += T
		if(EAST, WEST)
			// Tent runs east-west (length), north-south (width)
			for(var/x = -length_offset to length_offset)
				for(var/y = -width_offset to width_offset)
					var/turf/T = locate(center_turf.x + x, center_turf.y + y, center_turf.z)
					if(T) coords += T

	return coords

/obj/item/tent_kit/proc/get_upper_tent_coordinates(turf/center_turf, assembly_dir)
	var/list/coords = list()
	var/width_offset = round((tent_width - 1) / 2)
	var/length_offset = round((tent_length - 1) / 2)

	switch(assembly_dir)
		if(NORTH, SOUTH)
			// Upper level is the middle strip but extended to cover doors at the ends
			for(var/x = -(width_offset-1) to (width_offset-1)) // Middle strip width
				for(var/y = -length_offset to length_offset) // Full length to cover doors
					var/turf/T = locate(center_turf.x + x, center_turf.y + y, center_turf.z)
					if(T)
						var/turf/upper_T = GET_TURF_ABOVE(T)
						if(upper_T) coords += upper_T
		if(EAST, WEST)
			// Upper level is the middle strip but extended to cover doors at the ends
			for(var/x = -length_offset to length_offset) // Full length to cover doors
				for(var/y = -(width_offset-1) to (width_offset-1)) // Middle strip width
					var/turf/T = locate(center_turf.x + x, center_turf.y + y, center_turf.z)
					if(T)
						var/turf/upper_T = GET_TURF_ABOVE(T)
						if(upper_T) coords += upper_T

	return coords

/obj/item/tent_kit/proc/get_wall_coordinates(turf/center_turf, assembly_dir)
	var/list/coords = list()
	var/list/door_coords = get_door_coordinates(center_turf, assembly_dir)
	var/width_offset = round((tent_width - 1) / 2)
	var/length_offset = round((tent_length - 1) / 2)

	switch(assembly_dir)
		if(NORTH, SOUTH)
			// Ground level walls - full perimeter except door positions
			for(var/x = -width_offset to width_offset)
				for(var/y = -length_offset to length_offset)
					// Only perimeter walls
					if(x == -width_offset || x == width_offset || y == -length_offset || y == length_offset)
						var/turf/T = locate(center_turf.x + x, center_turf.y + y, center_turf.z)
						if(T && !(T in door_coords)) // Skip door positions
							coords += T
		if(EAST, WEST)
			// Ground level walls - full perimeter except door positions
			for(var/x = -length_offset to length_offset)
				for(var/y = -width_offset to width_offset)
					// Only perimeter walls
					if(x == -length_offset || x == length_offset || y == -width_offset || y == width_offset)
						var/turf/T = locate(center_turf.x + x, center_turf.y + y, center_turf.z)
						if(T && !(T in door_coords)) // Skip door positions
							coords += T

	return coords

/obj/item/tent_kit/proc/get_upper_wall_coordinates(turf/center_turf, assembly_dir)
	var/list/coords = list()
	var/width_offset = round((tent_width - 1) / 2)
	var/length_offset = round((tent_length - 1) / 2)

	switch(assembly_dir)
		if(NORTH, SOUTH)
			// Upper level walls - perimeter of middle strip (includes above doors)
			for(var/x = -(width_offset-1) to (width_offset-1))
				for(var/y = -length_offset to length_offset)
					// Only perimeter of middle strip area
					if(x == -(width_offset-1) || x == (width_offset-1) || y == -length_offset || y == length_offset)
						var/turf/T = locate(center_turf.x + x, center_turf.y + y, center_turf.z)
						if(T)
							var/turf/upper_T = GET_TURF_ABOVE(T)
							if(upper_T) coords += upper_T
		if(EAST, WEST)
			// Upper level walls - perimeter of middle strip (includes above doors)
			for(var/x = -length_offset to length_offset)
				for(var/y = -(width_offset-1) to (width_offset-1))
					// Only perimeter of middle strip area
					if(x == -length_offset || x == length_offset || y == -(width_offset-1) || y == (width_offset-1))
						var/turf/T = locate(center_turf.x + x, center_turf.y + y, center_turf.z)
						if(T)
							var/turf/upper_T = GET_TURF_ABOVE(T)
							if(upper_T) coords += upper_T

	return coords

/obj/item/tent_kit/proc/get_door_coordinates(turf/center_turf, assembly_dir)
	var/list/coords = list()
	var/length_offset = round((tent_length - 1) / 2)

	switch(assembly_dir)
		if(NORTH)
			// Just 2 doors - one at each end, in the center of the width
			var/turf/door1 = locate(center_turf.x, center_turf.y + length_offset, center_turf.z) // North end center
			var/turf/door2 = locate(center_turf.x, center_turf.y - length_offset, center_turf.z) // South end center
			if(door1) coords += door1
			if(door2) coords += door2
		if(SOUTH)
			// Just 2 doors - one at each end, in the center of the width
			var/turf/door1 = locate(center_turf.x, center_turf.y - length_offset, center_turf.z) // South end center (flipped)
			var/turf/door2 = locate(center_turf.x, center_turf.y + length_offset, center_turf.z) // North end center (flipped)
			if(door1) coords += door1
			if(door2) coords += door2
		if(EAST)
			// Just 2 doors - one at each end, in the center of the width
			var/turf/door1 = locate(center_turf.x + length_offset, center_turf.y, center_turf.z) // East end center
			var/turf/door2 = locate(center_turf.x - length_offset, center_turf.y, center_turf.z) // West end center
			if(door1) coords += door1
			if(door2) coords += door2
		if(WEST)
			// Just 2 doors - one at each end, in the center of the width
			var/turf/door1 = locate(center_turf.x - length_offset, center_turf.y, center_turf.z) // West end center (flipped)
			var/turf/door2 = locate(center_turf.x + length_offset, center_turf.y, center_turf.z) // East end center (flipped)
			if(door1) coords += door1
			if(door2) coords += door2

	return coords

/obj/item/tent_kit/proc/assemble_tent(turf/center_turf, mob/user, assembly_dir)
	clean_components()

	if(repair_debt_cloth > 0 || repair_debt_silk > 0)
		to_chat(user, span_warning("This tent needs materials before it can be assembled again."))
		return

	var/turf/above_turf = GET_TURF_ABOVE(center_turf)
	var/can_build_above = (above_turf && is_openspace(above_turf))

	// Check if we can actually build the full tent shape above
	if(can_build_above)
		var/list/upper_coords = get_upper_tent_coordinates(center_turf, assembly_dir)
		for(var/turf/check_turf in upper_coords)
			if(!check_turf || check_turf.density)
				can_build_above = FALSE
				break
			for(var/obj/O in check_turf)
				if(O.density)
					can_build_above = FALSE
					break

	visible_message(span_notice("[user] assembles [src] into a [can_build_above ? "full tent structure" : "ground-level shelter"]."))

	var/list/door_coords = get_door_coordinates(center_turf, assembly_dir)
	var/list/wall_coords = get_wall_coordinates(center_turf, assembly_dir)
	var/list/upper_wall_coords = list()

	if(can_build_above)
		upper_wall_coords = get_upper_wall_coordinates(center_turf, assembly_dir)

	var/list/available_walls = tent_walls.Copy()
	var/list/available_doors = tent_doors.Copy()

	var/required_walls = wall_coords.len + (can_build_above ? upper_wall_coords.len : 0)
	var/required_doors = door_coords.len

	if(available_walls.len < required_walls || available_doors.len < required_doors)
		to_chat(user, span_warning("This tent kit is missing components and can't be assembled."))
		return

	roof_tiles.Cut()

	if(can_build_above)
		// Deploy ground level walls (skip door positions)
		for(var/turf/wall_turf in wall_coords)
			var/obj/structure/tent_wall/wall = available_walls[1]
			available_walls.Cut(1, 2)
			wall.forceMove(wall_turf)
			RegisterSignal(wall, COMSIG_PARENT_QDELETING, PROC_REF(part_destroyed))
			RegisterSignal(wall, COMSIG_MOVABLE_MOVED, PROC_REF(part_moved))

		// Deploy upper level walls for tent shape
		for(var/turf/upper_wall_turf in upper_wall_coords)
			var/obj/structure/tent_wall/wall = available_walls[1]
			available_walls.Cut(1, 2)
			wall.forceMove(upper_wall_turf)
			wall.name = "tent roof wall"
			wall.desc = "The sloped roof section of the tent, providing overhead protection."
			RegisterSignal(wall, COMSIG_PARENT_QDELETING, PROC_REF(part_destroyed))
			RegisterSignal(wall, COMSIG_MOVABLE_MOVED, PROC_REF(part_moved))

		// Set pseudo_roof for just the middle strip (matches upper coordinates)
		var/list/roof_coords = get_upper_tent_coordinates(center_turf, assembly_dir)
		for(var/turf/roof_turf in roof_coords)
			if(roof_turf)
				roof_turf.pseudo_roof = TRUE
				roof_tiles += roof_turf

		// Deploy tent doors
		for(var/turf/door_turf in door_coords)
			var/obj/structure/roguetent/door = available_doors[1]
			available_doors.Cut(1, 2)
			door.forceMove(door_turf)
			RegisterSignal(door, COMSIG_PARENT_QDELETING, PROC_REF(part_destroyed))
			RegisterSignal(door, COMSIG_MOVABLE_MOVED, PROC_REF(part_moved))
	else
		// Ground level only - use pseudo_roof for protection on middle strip only
		var/list/roof_coords = get_upper_tent_coordinates(center_turf, assembly_dir)
		for(var/turf/upper_turf in roof_coords)
			var/turf/ground_turf = GET_TURF_BELOW(upper_turf)
			if(ground_turf)
				ground_turf.pseudo_roof = TRUE
				roof_tiles += ground_turf

		// Deploy doors for ambiance
		for(var/turf/door_turf in door_coords)
			var/obj/structure/roguetent/door = available_doors[1]
			available_doors.Cut(1, 2)
			door.forceMove(door_turf)
			door.desc += " This tent provides overhead protection from the elements."
			RegisterSignal(door, COMSIG_PARENT_QDELETING, PROC_REF(part_destroyed))
			RegisterSignal(door, COMSIG_MOVABLE_MOVED, PROC_REF(part_moved))

	for(var/turf/turf in wall_coords + door_coords + upper_wall_coords)
		turf?.reassess_stack()

	assembled = TRUE
	forceMove(center_turf)
	anchored = TRUE
	name = "assembled tent kit ([tent_width]x[tent_length])"
	desc = "An assembled [tent_width]x[tent_length] tent kit facing [dir2text(assembly_dir)]. Use it to disassemble the tent and pack it back up."

/obj/item/tent_kit/proc/disassemble_tent(mob/user, instant = FALSE)
	if(!assembled)
		return

	if(user && !instant)
		to_chat(user, span_notice("You begin disassembling the tent..."))
		if(!do_after(user, 8 SECONDS, target = src))
			to_chat(user, span_warning("Your tent disassembly was interrupted!"))
			return

	if(user)
		visible_message(span_notice("[user] disassembles the tent and packs it away."))
	else
		visible_message(span_notice("The tent packs itself away."))

	// Pack up all deployed walls
	for(var/obj/structure/tent_wall/wall in tent_walls)
		var/turf/old_turf = get_turf(wall)
		if(wall && wall.loc != src)
			UnregisterSignal(wall, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
			wall.forceMove(src)
			wall.name = initial(wall.name)
			wall.desc = initial(wall.desc)
		old_turf?.reassess_stack()

	// Pack up all deployed doors
	for(var/obj/structure/roguetent/door in tent_doors)
		var/turf/old_turf = get_turf(door)
		if(door && door.loc != src)
			UnregisterSignal(door, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
			door.forceMove(src)
			door.desc = initial(door.desc)
		old_turf?.reassess_stack()

	// Clear pseudo_roof from tracked turfs only
	for(var/turf/T in roof_tiles)
		if(T && T.pseudo_roof)
			T.pseudo_roof = FALSE
		T?.reassess_stack()
	roof_tiles.Cut()

	assembled = FALSE
	anchored = FALSE
	name = initial(name)
	desc = initial(desc)

/obj/item/tent_kit/attack_hand(mob/living/user)
	if(!assembled)
		return ..()
	disassemble_tent(user, FALSE)
	return TRUE

/obj/item/tent_kit/proc/part_destroyed(obj/source)

	if(!source)
		return

	if(istype(source, /obj/structure/tent_wall))
		repair_debt_cloth += 2
		repair_debt_silk += 1

	if(istype(source, /obj/structure/roguetent))
		repair_debt_cloth += 2

	visible_message(span_warning("A tent component was destroyed! The tent collapses and requires repairs."))

	disassemble_tent(null, TRUE)
	clean_components()

/obj/item/tent_kit/proc/part_moved(obj/source, atom/old_loc)
	// If a tent part was moved away from its position, pack up
	if(source && source.loc != src)
		visible_message(span_warning("A tent component has been moved! The tent automatically packs itself up."))
		disassemble_tent(null, TRUE)

/obj/item/tent_kit/examine(mob/user)
	. = ..()
	if(assembled)
		. += span_notice("This tent kit is currently assembled as a [tent_width]x[tent_length] tent.")
	else
		. += span_notice("This tent kit is packed and ready for assembly.")
	if(repair_debt_cloth > 0 || repair_debt_silk > 0)
		. += span_warning("The tent requires [repair_debt_cloth] cloth and [repair_debt_silk] silk to be fully functional.")

	// Show condition of tent components
	var/total_walls = 0
	var/damaged_walls = 0
	for(var/obj/structure/tent_wall/wall in tent_walls)
		total_walls++
		if(wall && wall.obj_integrity < wall.max_integrity)
			damaged_walls++

	var/total_doors = 0
	var/damaged_doors = 0
	for(var/obj/structure/roguetent/door in tent_doors)
		total_doors++
		if(door && door.obj_integrity < door.max_integrity)
			damaged_doors++

	if(damaged_walls > 0)
		. += span_warning("[damaged_walls] of [total_walls] tent walls are damaged.")
	else
		. += span_notice("All [total_walls] tent walls are in good condition.")

	if(damaged_doors > 0)
		. += span_warning("[damaged_doors] of [total_doors] tent doors are damaged.")
	else
		. += span_notice("All [total_doors] tent doors are in good condition.")

/obj/structure/tent_wall
	name = "tent wall"
	desc = "Made from durable fabric and wooden branches. Provides excellent protection from weather."
	icon = 'icons/turf/roguewall.dmi'
	icon_state = "tent"
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	max_integrity = 300
	blade_dulling = DULLING_BASHCHOP
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	destroy_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	weatherproof = TRUE
	var/damaged = FALSE

/obj/structure/tent_wall/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	. = ..()
	if(obj_integrity < max_integrity * 0.75)
		damaged = TRUE
		opacity = FALSE

/obj/item/tent_kit/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/natural/cloth) && repair_debt_cloth > 0)
		repair_debt_cloth--
		qdel(W)
		to_chat(user, span_notice("You reinforce part of the tent with cloth. ([repair_debt_cloth] remaining)"))

		check_repair_completion(user)
		return TRUE

	if(istype(W, /obj/item/natural/silk) && repair_debt_silk > 0)
		repair_debt_silk--
		qdel(W)
		to_chat(user, span_notice("You reinforce the tent roof with silk. ([repair_debt_silk] remaining)"))

		check_repair_completion(user)
		return TRUE

	return ..()

/obj/item/tent_kit/proc/check_repair_completion(mob/user)

	if(repair_debt_cloth > 0 || repair_debt_silk > 0)
		return

	clean_components()

	var/ground_walls = (tent_length + tent_width) * 2 - 4 - 2
	var/upper_walls = tent_length + tent_width - 3
	var/max_walls = ground_walls + upper_walls
	var/max_doors = 2

	while(tent_walls.len < max_walls)
		tent_walls += new /obj/structure/tent_wall(src)

	while(tent_doors.len < max_doors)
		tent_doors += new /obj/structure/roguetent(src)

	to_chat(user, span_notice("The tent has been fully restored and is ready for assembly."))

/proc/is_openspace(atom/A)
	if(!A)
		return FALSE
	var/turf/T = get_turf(A)
	if(!T)
		return FALSE
	return istype(T, /turf/open/transparent/openspace)

// ===>>> Crafting
/datum/crafting_recipe/roguetown/sewing/tentkit
	name = "Tent Kit"
	category = "Misc"
	result = list(/obj/item/tent_kit)
	reqs = list(/obj/item/natural/cloth = 16,
				/obj/item/natural/fibers = 4,
				/obj/item/natural/silk = 6)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 200

