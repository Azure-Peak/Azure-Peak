// === BASE TENT COMPONENT ===
/obj/structure/tent_component
    var/obj/item/tent_kit/parent_tent = null
    anchored = TRUE
    invisibility = 0

// === TENT KIT ITEM ===
/obj/item/tent_kit
    name = "Small Tent Kit"
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
    var/list/turf/roof_turfs = list()

    var/tent_width = 3
    var/tent_length = 4
    var/roof_width = 1
    var/roof_length = 4
    var/door_style = "both"
    var/setup_time = 10 SECONDS
    var/roof_covers_doors = FALSE

    var/setup_cooldown_end = 0
    var/cooldown_duration = 600

    // Repair & Damage vars
    var/repair_debt_cloth = 0
    var/repair_debt_silk = 0
    var/parts_destroyed_count = 0
    var/collapse_threshold = 1

/obj/item/tent_kit/proc/get_max_doors()
    return (door_style == "both") ? 2 : 1

/obj/item/tent_kit/proc/get_max_walls()
    var/list/ground_coords = get_wall_coordinates(null, NORTH)
    var/list/upper_coords = get_upper_wall_coordinates(null, NORTH)
    return ground_coords.len + upper_coords.len - get_max_doors()

/obj/item/tent_kit/Initialize(mapload)
    . = ..()
    create_tent_components()

/obj/item/tent_kit/proc/create_tent_components()
    var/max_walls = get_max_walls()
    var/max_doors = get_max_doors()
    for(var/i = 1 to max_walls)
        var/obj/structure/tent_wall/wall = new(src)
        wall.parent_tent = src
        tent_walls += wall
    for(var/i = 1 to max_doors)
        var/obj/structure/roguetent/door = new(src)
        door.parent_tent = src
        tent_doors += door

/obj/item/tent_kit/Destroy()
    if(assembled)
        // Clean up roof state without do_after or forceMove
        for(var/obj/structure/tent_wall/wall in tent_walls)
            UnregisterSignal(wall, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
        for(var/obj/structure/roguetent/door in tent_doors)
            UnregisterSignal(door, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
        for(var/turf/T in roof_tiles)
            T.pseudo_roof = FALSE
        for(var/turf/RT in roof_turfs)
            RT.ChangeTurf(/turf/open/transparent/openspace, flags = CHANGETURF_INHERIT_AIR)
        roof_turfs.Cut()
        roof_tiles.Cut()
    for(var/obj/structure/tent_wall/wall in tent_walls)
        if(wall) qdel(wall)
    for(var/obj/structure/roguetent/door in tent_doors)
        if(door) qdel(door)
    tent_walls.Cut()
    tent_doors.Cut()
    return ..()

/obj/item/tent_kit/proc/clean_components()
    for(var/i = tent_walls.len to 1 step -1)
        if(!tent_walls[i] || QDELETED(tent_walls[i]))
            tent_walls.Cut(i, i+1)
    for(var/i = tent_doors.len to 1 step -1)
        if(!tent_doors[i] || QDELETED(tent_doors[i]))
            tent_doors.Cut(i, i+1)

/obj/item/tent_kit/attack_self(mob/user)
    if(assembled) return
    if(world.time < setup_cooldown_end)
        var/remaining = round((setup_cooldown_end - world.time) / 10)
        to_chat(user, span_warning("This tent was recently packed up. You must wait [remaining] second\s before setting it up again."))
        return
    var/turf/setup_turf = get_turf(user)
    if(!setup_turf) return
    var/assembly_dir = user.dir

    if(!check_assembly_space(setup_turf, user, assembly_dir)) return

    to_chat(user, span_notice("You begin assembling the [name]..."))
    if(!do_after(user, setup_time, target = src))
        return
    if(!check_assembly_space(setup_turf, user, assembly_dir)) return
    assemble_tent(setup_turf, user, assembly_dir)

/obj/item/tent_kit/proc/check_assembly_space(turf/center_turf, mob/user, assembly_dir)
    var/list/wall_coords = get_wall_coordinates(center_turf, assembly_dir)
    var/list/door_coords = get_door_coordinates(center_turf, assembly_dir)
    var/list/perimeter = wall_coords + door_coords

    for(var/turf/check_turf in perimeter)
        if(!check_turf || check_turf.density)
            to_chat(user, span_warning("There is a wall or floor blocking where the tent walls should go!"))
            return FALSE
        for(var/obj/O in check_turf.contents)
            if(O.density)
                to_chat(user, span_warning("[O] is blocking the tent perimeter!"))
                return FALSE

    // Upper level is checked per-tile during assembly, just inform the user
    var/any_blocked = FALSE
    var/list/upper_coords = get_upper_floor_coordinates(center_turf, assembly_dir)
    for(var/turf/check_turf in upper_coords)
        if(!check_turf || !is_openspace(check_turf))
            any_blocked = TRUE
            break

    if(any_blocked)
        to_chat(user, span_notice("Some overhead space is blocked - the tent roof will be built where possible."))
    return TRUE

/obj/item/tent_kit/proc/get_wall_coordinates(turf/center_turf, assembly_dir)
    var/list/coords = list()
    var/list/door_coords = (center_turf) ? get_door_coordinates(center_turf, assembly_dir) : list()
    var/x_start = -round((tent_width - 1) / 2)
    var/x_end = round(tent_width / 2)
    var/y_start = -round((tent_length - 1) / 2)
    var/y_end = round(tent_length / 2)

    for(var/x = x_start to x_end)
        for(var/y = y_start to y_end)
            if(x == x_start || x == x_end || y == y_start || y == y_end)
                if(tent_width >= 5 && tent_length >= 5)
                    if((x == x_start || x == x_end) && (y == y_start || y == y_end))
                        continue

                if(!center_turf)
                    coords += null
                    continue

                var/turf/T
                if(assembly_dir in list(NORTH, SOUTH))
                    T = locate(center_turf.x + x, center_turf.y + y, center_turf.z)
                else
                    T = locate(center_turf.x + y, center_turf.y + x, center_turf.z)

                if(T && !(T in door_coords)) coords += T
    return coords

/obj/item/tent_kit/proc/get_upper_wall_coordinates(turf/center_turf, assembly_dir)
    var/list/coords = list()
    var/rx_start = -round((roof_width - 1) / 2)
    var/rx_end = round(roof_width / 2)
    var/ry_start = -round((roof_length - 1) / 2)
    var/ry_end = round(roof_length / 2)

    for(var/x = rx_start to rx_end)
        for(var/y = ry_start to ry_end)
            if(x == rx_start || x == rx_end || y == ry_start || y == ry_end)
                if(!center_turf)
                    coords += null
                    continue
                var/turf/T
                if(assembly_dir in list(NORTH, SOUTH))
                    T = locate(center_turf.x + x, center_turf.y + y, center_turf.z)
                else
                    T = locate(center_turf.x + y, center_turf.y + x, center_turf.z)
                var/turf/upper_T = GET_TURF_ABOVE(T)
                if(upper_T) coords += upper_T
    return coords

/obj/item/tent_kit/proc/get_upper_floor_coordinates(turf/center_turf, assembly_dir)
    var/list/coords = list()
    var/list/wall_coords = get_wall_coordinates(center_turf, assembly_dir)

    for(var/turf/wall_turf in wall_coords)
        var/turf/upper_turf = GET_TURF_ABOVE(wall_turf)
        if(upper_turf)
            coords += upper_turf

    if(roof_covers_doors)
        var/list/door_coords = get_door_coordinates(center_turf, assembly_dir)
        for(var/turf/door_turf in door_coords)
            var/turf/upper_turf = GET_TURF_ABOVE(door_turf)
            if(upper_turf)
                coords += upper_turf

    return coords

/obj/item/tent_kit/proc/get_wall_dir(turf/center_turf, turf/wall_turf)
	var/dx = wall_turf.x - center_turf.x
	var/dy = wall_turf.y - center_turf.y
	if(abs(dx) >= abs(dy))
		return (dx > 0) ? EAST : WEST
	return (dy > 0) ? NORTH : SOUTH

/obj/item/tent_kit/proc/get_tent_coordinates(turf/center_turf, assembly_dir)
    var/list/coords = list()
    var/x_start = -round((tent_width - 1) / 2)
    var/x_end = round(tent_width / 2)
    var/y_start = -round((tent_length - 1) / 2)
    var/y_end = round(tent_length / 2)

    for(var/x = x_start to x_end)
        for(var/y = y_start to y_end)
            var/turf/T
            if(assembly_dir in list(NORTH, SOUTH))
                T = locate(center_turf.x + x, center_turf.y + y, center_turf.z)
            else
                T = locate(center_turf.x + y, center_turf.y + x, center_turf.z)
            if(T) coords += T
    return coords

/obj/item/tent_kit/proc/get_door_coordinates(turf/center_turf, assembly_dir)
    var/list/coords = list()
    var/y_start = -round((tent_length - 1) / 2)
    var/y_end = round(tent_length / 2)

    switch(assembly_dir)
        if(NORTH)
            coords += locate(center_turf.x, center_turf.y + y_end, center_turf.z)
            if(door_style == "both") coords += locate(center_turf.x, center_turf.y + y_start, center_turf.z)
        if(SOUTH)
            coords += locate(center_turf.x, center_turf.y + y_start, center_turf.z)
            if(door_style == "both") coords += locate(center_turf.x, center_turf.y + y_end, center_turf.z)
        if(EAST)
            coords += locate(center_turf.x + y_end, center_turf.y, center_turf.z)
            if(door_style == "both") coords += locate(center_turf.x + y_start, center_turf.y, center_turf.z)
        if(WEST)
            coords += locate(center_turf.x + y_start, center_turf.y, center_turf.z)
            if(door_style == "both") coords += locate(center_turf.x + y_end, center_turf.y, center_turf.z)
    return coords

/obj/item/tent_kit/proc/assemble_tent(turf/center_turf, mob/user, assembly_dir)
    clean_components()
    parts_destroyed_count = 0

    if(repair_debt_cloth > 0 || repair_debt_silk > 0)
        to_chat(user, span_warning("This kit is too damaged! Repair it with cloth and silk first."))
        return

    var/list/door_coords = get_door_coordinates(center_turf, assembly_dir)
    var/list/wall_coords = get_wall_coordinates(center_turf, assembly_dir)
    var/list/roof_floor_coords = get_upper_floor_coordinates(center_turf, assembly_dir)
    var/list/upper_wall_coords = get_upper_wall_coordinates(center_turf, assembly_dir)

    var/list/available_walls = tent_walls.Copy()
    var/list/available_doors = tent_doors.Copy()

    // --- WALLS ---
    for(var/turf/wall_turf in wall_coords)
        if(!available_walls.len) break
        var/obj/structure/tent_wall/wall = available_walls[1]
        available_walls.Cut(1, 2)
        wall.forceMove(wall_turf)
        wall.dir = get_wall_dir(center_turf, wall_turf)
        wall.invisibility = 0
        wall.alpha = 255
        RegisterSignal(wall, COMSIG_PARENT_QDELETING, PROC_REF(part_destroyed))
        RegisterSignal(wall, COMSIG_MOVABLE_MOVED, PROC_REF(part_moved))

    // --- ROOF TILES (The Flooring) ---
    for(var/turf/roof_floor_turf in roof_floor_coords)
        if(!is_openspace(roof_floor_turf)) continue

        var/turf/new_roof_turf = roof_floor_turf.ChangeTurf(/turf/open/floor/rogue/twig, flags = CHANGETURF_INHERIT_AIR)
        roof_turfs += new_roof_turf

    // --- ROOF WALLS (only where openspace exists above) ---
    for(var/turf/upper_wall_turf in upper_wall_coords)
        if(!available_walls.len) break
        if(!is_openspace(upper_wall_turf)) continue

        var/obj/structure/tent_wall/wall = available_walls[1]
        available_walls.Cut(1, 2)
        wall.forceMove(upper_wall_turf)
        wall.dir = get_wall_dir(center_turf, upper_wall_turf)
        wall.name = "Tent Roof Wall"
        wall.invisibility = 0
        wall.alpha = 255
        RegisterSignal(wall, COMSIG_PARENT_QDELETING, PROC_REF(part_destroyed))
        RegisterSignal(wall, COMSIG_MOVABLE_MOVED, PROC_REF(part_moved))

    // --- DOORS ---
    for(var/turf/door_turf in door_coords)
        if(!available_doors.len) break
        var/obj/structure/roguetent/door = available_doors[1]
        available_doors.Cut(1, 2)
        door.forceMove(door_turf)
        door.invisibility = 0
        door.alpha = 255
        door.density = TRUE
        door.update_icon()
        RegisterSignal(door, COMSIG_PARENT_QDELETING, PROC_REF(part_destroyed))
        RegisterSignal(door, COMSIG_MOVABLE_MOVED, PROC_REF(part_moved))

    var/built_above = (roof_turfs.len > 0)
    visible_message(span_notice("[user] assembles [src] into a [built_above ? "full tent structure" : "ground-level shelter"]."))

    // --- REASSESS STACKS (after all components placed, before pseudo_roof) ---
    for(var/turf/T in wall_coords + door_coords)
        T.reassess_stack()
    for(var/turf/T in upper_wall_coords)
        if(T) T.reassess_stack()

    // --- INTERNAL ROOF LOGIC (must be after reassess_stack to avoid reset) ---
    var/list/internal_coords = get_tent_coordinates(center_turf, assembly_dir)
    for(var/turf/T in internal_coords)
        T.pseudo_roof = TRUE
        roof_tiles += T

    assembled = TRUE
    forceMove(center_turf)
    anchored = TRUE
    invisibility = INVISIBILITY_MAXIMUM
    mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/item/tent_kit/proc/disassemble_tent(mob/user, instant = FALSE)
    if(!assembled) return

    if(user && !instant)
        to_chat(user, span_notice("You begin packing away the [name]..."))
        if(!do_after(user, 8 SECONDS, target = src)) return

    if(user)
        visible_message(span_notice("[user] disassembles the tent and packs it away."))

    for(var/obj/structure/tent_wall/wall in tent_walls)
        var/turf/old_turf = get_turf(wall)
        UnregisterSignal(wall, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
        wall.forceMove(src)
        wall.name = initial(wall.name)
        wall.desc = initial(wall.desc)
        wall.alpha = initial(wall.alpha)
        if(wall.damaged)
            wall.damaged = FALSE
            wall.opacity = initial(wall.opacity)
        old_turf?.reassess_stack()
    for(var/obj/structure/roguetent/door in tent_doors)
        var/turf/old_turf = get_turf(door)
        UnregisterSignal(door, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
        door.forceMove(src)
        old_turf?.reassess_stack()
    for(var/turf/T in roof_tiles)
        T.pseudo_roof = FALSE
        T.reassess_stack()

    // CLEANUP ROOF TURFS: Revert twig floors back to openspace
    for(var/turf/RT in roof_turfs)
        RT.ChangeTurf(/turf/open/transparent/openspace, flags = CHANGETURF_INHERIT_AIR)
    roof_turfs.Cut()
    roof_tiles.Cut()

    parts_destroyed_count = 0
    assembled = FALSE
    anchored = FALSE
    invisibility = initial(invisibility)
    mouse_opacity = initial(mouse_opacity)
    if(user) forceMove(get_turf(user))
    setup_cooldown_end = world.time + cooldown_duration

/obj/item/tent_kit/proc/part_destroyed(obj/source)
    UnregisterSignal(source, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
    parts_destroyed_count++

    if(istype(source, /obj/structure/tent_wall))
        tent_walls -= source
        repair_debt_cloth += 2
        repair_debt_silk += 1
    else
        tent_doors -= source
        repair_debt_cloth += 2

    if(parts_destroyed_count >= collapse_threshold)
        visible_message(span_warning("The [name] collapses from damage!"))
        disassemble_tent(null, TRUE)
    else
        visible_message(span_danger("A support on the [name] was destroyed! It's leaning heavily..."))

/obj/item/tent_kit/proc/part_moved(obj/source, atom/old_loc)
    if(source && source.loc != src)
        visible_message(span_warning("A tent component has been moved! The tent automatically packs itself up."))
        disassemble_tent(null, TRUE)

// === TENT WALL ===
/obj/structure/tent_wall
    parent_type = /obj/structure/tent_component // Inherits from base
    name = "Tent Wall"
    desc = "A sturdy fabric wall. Shift-click from the inside to pack the tent."
    icon = 'icons/turf/roguewall.dmi'
    icon_state = "tent"
    density = TRUE
    opacity = TRUE
    max_integrity = 300
    blade_dulling = DULLING_BASHCHOP
    attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
    destroy_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
    weatherproof = TRUE
    var/damaged = FALSE

/obj/structure/tent_wall/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
    . = ..()
    if(obj_integrity < max_integrity * 0.75 && !damaged)
        damaged = TRUE
        opacity = FALSE

/obj/structure/tent_wall/ShiftClick(mob/user)
    if(!parent_tent || !parent_tent.assembled) return ..()

    var/turf/T = get_turf(user)
    if(!T || !T.pseudo_roof)
        to_chat(user, span_warning("You can only dismantle the tent from the inside!"))
        return TRUE

    if(get_dist(user, src) > 1)
        to_chat(user, span_warning("You are too far away!"))
        return TRUE

    var/confirm = alert(user, "Are you sure you want to pack up the [parent_tent.name]?", "Dismantle", "Yes", "No")
    if(confirm == "Yes" && get_dist(user, src) <= 1)
        parent_tent.disassemble_tent(user)
    return TRUE

// === GER KIT ===
/obj/item/tent_kit/ger
    name = "Ger Kit"
    desc = "A large circular tent kit bundled together. Very durable and often used by nomadic travellers of the steppes."
    icon_state = "tent_kit"
    tent_width = 5
    tent_length = 5
    roof_width = 3
    roof_length = 3
    door_style = "front"
    setup_time = 20 SECONDS
    collapse_threshold = 3
    roof_covers_doors = TRUE

// === YURT KIT ===
/obj/item/tent_kit/yurt
    name = "Yurt Kit"
    desc = "A very large circular tent kit bundled together. Spacious and durable, and often used by nomadic families of the steppes."
    icon_state = "tent_kit"
    tent_width = 7
    tent_length = 7
    roof_width = 5
    roof_length = 5
    door_style = "front"
    setup_time = 30 SECONDS
    collapse_threshold = 5
    roof_covers_doors = TRUE
    cooldown_duration = 1200

// === CRAFTING ===
/datum/crafting_recipe/roguetown/sewing/tentkit
    name = "Small Tent Kit"
    category = "Misc"
    tools = list(/obj/item/needle)
    result = list(/obj/item/tent_kit)
    reqs = list(/obj/item/natural/cloth = 10, /obj/item/natural/fibers = 6, /obj/item/natural/silk = 6, /obj/item/grown/log/tree/stick = 10)
    craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/gerkit
    name = "Ger Kit"
    category = "Misc"
    tools = list(/obj/item/needle)
    result = list(/obj/item/tent_kit/ger)
    reqs = list(/obj/item/natural/cloth = 15, /obj/item/natural/fibers = 6, /obj/item/natural/silk = 6, /obj/item/grown/log/tree/stick = 15)
    craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/yurtkit
    name = "Yurt Kit"
    category = "Misc"
    tools = list(/obj/item/needle)
    result = list(/obj/item/tent_kit/yurt)
    reqs = list(/obj/item/natural/cloth = 20, /obj/item/natural/fibers = 12, /obj/item/natural/silk = 12, /obj/item/grown/log/tree/stick = 20)
    craftdiff = 5

// === HELPERS ===
/obj/structure/roguetent
	parent_type = /obj/structure/tent_component

/proc/is_openspace(atom/A)
	if(!A) return FALSE
	var/turf/T = get_turf(A)
	return istype(T, /turf/open/transparent/openspace)

/obj/structure/roguetent/ShiftClick(mob/user)
	if(!parent_tent || !parent_tent.assembled) return ..()

	var/turf/T = get_turf(user)
	if(!T || !T.pseudo_roof)
		to_chat(user, span_warning("You can only dismantle the tent from the inside!"))
		return TRUE

	if(get_dist(user, src) > 1)
		to_chat(user, span_warning("You are too far away!"))
		return TRUE

	var/confirm = alert(user, "Are you sure you want to pack up the [parent_tent.name]?", "Dismantle", "Yes", "No")
	if(confirm == "Yes" && get_dist(user, src) <= 1)
		parent_tent.disassemble_tent(user)
	return TRUE

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
    var/max_walls = get_max_walls()
    var/max_doors = get_max_doors()
    while(tent_walls.len < max_walls)
        var/obj/structure/tent_wall/wall = new(src)
        wall.parent_tent = src
        tent_walls += wall
    while(tent_doors.len < max_doors)
        var/obj/structure/roguetent/door = new(src)
        door.parent_tent = src
        tent_doors += door
    to_chat(user, span_notice("The tent has been fully restored and is ready for assembly."))

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
