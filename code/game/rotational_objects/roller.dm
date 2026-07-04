/obj/structure/roller
	name = "roller"
	desc = "A rotating roller that moves items in one direction. Can be powered by rotation from the sides."
	icon = 'icons/obj/roller.dmi'
	icon_state = "roller"
	density = FALSE
	anchored = TRUE
	layer = BELOW_OPEN_DOOR_LAYER
	rotation_structure = TRUE
	stress_use = 0
	initialize_dirs = CONN_DIR_LEFT | CONN_DIR_RIGHT //| CONN_DIR_FORWARD | CONN_DIR_FLIP

	var/operating = FALSE
	var/movedir

	var/list/connected_rollers = list()

/obj/structure/roller/Initialize(mapload)
	. = ..()
	movedir = dir

	var/static/list/loc_connections = list(
		COMSIG_ATOM_EXITED = PROC_REF(conveyable_exit),
		COMSIG_ATOM_ENTERED = PROC_REF(conveyable_enter),
		COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON = PROC_REF(conveyable_enter)
	)
	AddElement(/datum/element/connect_loc, loc_connections)

	return INITIALIZE_HINT_LATELOAD

/obj/structure/roller/LateInitialize()
	. = ..()
	movedir = dir
	set_connection_dir()
	find_rotation_network()
	build_roller_chain()

/obj/structure/roller/set_connection_dir()
	dpdir = turn(dir, 90) | turn(dir, -90) | movedir | REVERSE_DIR(movedir)

/obj/structure/roller/Destroy()
	for(var/obj/structure/roller/connected in connected_rollers)
		connected.connected_rollers -= src
	connected_rollers = list()

	return ..()

/obj/structure/roller/examine(mob/user)
	. = ..()
	. += span_notice("It moves items [dir2text(movedir)].")
	. += span_notice("Rotation can be connected from the [get_rotation_sides_text()] sides.")
	if(rotation_network)
		. += span_notice("RPM: [rotations_per_minute]")
		. += span_notice("Rollers don't consume stress from the network.")
	. += span_notice("Use a <b>wrench</b> to rotate it.")

/obj/structure/roller/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Powered rollers move loose items and mobs in their facing direction.")
	. += span_info("They accept rotation from their side connections and do not consume stress from the network.")
	. += span_info("They can be re-aimed to change which way they move items.")

/obj/structure/roller/proc/get_rotation_sides_text()
	var/list/sides = list()
	switch(dir)
		if(NORTH, SOUTH)
			sides = list("east", "west")
		if(EAST, WEST)
			sides = list("north", "south")
	return english_list(sides)

/obj/structure/roller/can_connect(obj/structure/connector)
	. = ..()
	if(!.)
		return FALSE

	var/connect_dir = get_dir(src, connector)

	// If connecting from front/back, only allow other aligned rollers
	if(connect_dir == movedir || connect_dir == REVERSE_DIR(movedir))
		if(!istype(connector, /obj/structure/roller))
			return FALSE
		var/obj/structure/roller/other_roller = connector
		if(other_roller.movedir != movedir && other_roller.movedir != REVERSE_DIR(movedir))
			return FALSE

	return TRUE

/obj/structure/roller/setDir(newdir)
	. = ..()
	movedir = newdir
	vand_update_appearance()

/obj/structure/roller/rotation_break()
	set_rotations_per_minute(0)

/obj/structure/roller/set_stress_use(new_stress, check_network)
	return TRUE

/obj/structure/roller/set_rotations_per_minute(rpm)
	if(rotations_per_minute == rpm)
		return FALSE
	rotations_per_minute = min(rpm, 32)
	operating = rotations_per_minute > 0
	if(!operating)
		for(var/atom/movable/movable in loc)
			stop_conveying(movable)

	vand_update_appearance()
	return TRUE

/obj/structure/roller/proc/build_roller_chain()
	var/turf/forward_turf = get_step(src, movedir)
	var/obj/structure/roller/forward_roller = locate(/obj/structure/roller) in forward_turf

	if(forward_roller && (forward_roller.movedir == movedir || forward_roller.movedir == REVERSE_DIR(movedir)))
		connected_rollers |= forward_roller
		forward_roller.connected_rollers |= src

/obj/structure/roller/proc/get_move_delay()
	// Higher RPM = faster movement (shorter delay)
	// At 16 RPM: 1 second, at 32 RPM: 0.5 seconds, at 64 RPM: 0.25 seconds
	var/clamprpm = clamp(rotations_per_minute,0,32) //limiting RPM down
	return max(1, (10 / (clamprpm / 16))) // Returns deciseconds

/obj/structure/roller/proc/conveyable_enter(datum/source, atom/movable/entering_atom)
	SIGNAL_HANDLER
	if(entering_atom.loc != loc) // If we are not on the same turf (order of operations memes) go to hell
		return

	if(!operating || !rotations_per_minute)
		stop_conveying(entering_atom)
		return

	start_conveying(entering_atom)

/obj/structure/roller/proc/start_conveying(atom/movable/moving)
    if(QDELETED(moving))
        return

    var/static/list/unconveyables = typecacheof(list(/obj/effect, /mob/dead))
    if(!istype(moving) || is_type_in_typecache(moving, unconveyables) || moving.anchored || moving == src)
        return

    SSmove_manager.stop_looping(moving, SSconveyors)

    moving.AddComponent(/datum/component/convey, movedir, get_move_delay())

/obj/structure/roller/proc/stop_conveying(atom/movable/thing)
	if(!ismovable(thing))
		return
	SSmove_manager.stop_looping(thing, SSconveyors)

/obj/structure/roller/proc/conveyable_exit(datum/source, atom/convayable, direction)
    SIGNAL_HANDLER
    if(!ismovable(convayable))
        return

    var/obj/structure/roller/next_roller = locate(/obj/structure/roller) in get_step(src, direction)
    var/chained_handoff = next_roller && next_roller.operating && \
                          (direction == movedir) && (next_roller.movedir == movedir)

    if(chained_handoff)
        return 

    if(convayable.z != z || !isturf(convayable.loc))
        stop_conveying(convayable)
        return

    stop_conveying(convayable)

/obj/structure/roller/wrench_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src, 50)
	rotate_roller(user)
	return TRUE

/obj/structure/roller/proc/rotate_roller(mob/user)
	setDir(turn(dir, 90))
	to_chat(user, span_notice("You rotate [src]."))
	connected_rollers = list()
	build_roller_chain()

/obj/structure/roller/vand_update_appearance()
	. = ..()
	if(operating && rotations_per_minute > 0)
		update_animation_effect()

/obj/structure/roller/update_animation_effect()
	if(!rotation_network || rotation_network.overstressed || !rotations_per_minute)
		animate(src, icon_state = "roller", time = 1)
		return
	var/clamprpm = clamp(rotations_per_minute,0,32) //limiting RPM down
	var/frame_time = 1 / ((clamprpm / 60) * 4)

	animate(src, icon_state = "roller1", time = frame_time, loop = -1)
	animate(icon_state = "roller2", time = frame_time)
	animate(icon_state = "roller3", time = frame_time)
	animate(icon_state = "roller4", time = frame_time)

/obj/structure/roller/attack_right(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	var/obj/item/held_item = user.get_active_held_item()
	if(held_item?.type != /obj/item/contraption/linker)
		return
	rotate_roller(user)
	return TRUE
