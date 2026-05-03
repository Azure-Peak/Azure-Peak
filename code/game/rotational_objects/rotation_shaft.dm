/datum/looping_sound/cog_loop
	mid_sounds = 'sound/items/hogcrank1.ogg'
	mid_length = 0.5 SECONDS
	volume = 30
	extra_range = -2

/datum/looping_sound/cog_loop/heavy
	mid_sounds = 'sound/items/hogcrank2.ogg'
	mid_length = 1 SECONDS
	volume = 30
	extra_range = -2

/obj/structure/rotation_piece
	name = "shaft"
	icon = 'icons/roguetown/misc/shafts_cogs.dmi'
	icon_state = "shaft"
	layer = ABOVE_MOB_LAYER
	rotation_structure = TRUE
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_FLIP
	var/in_stack = 1

/obj/structure/rotation_piece/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/simple_rotation, ROTATION_REQUIRE_WRENCH|ROTATION_IGNORE_ANCHORED)
	vand_update_appearance(UPDATE_NAME)

/obj/structure/rotation_piece/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Carries rotation straight through its front and back connection points.")
	. += span_info("Place it adjacent to other rotational parts to join the same network.")
	. += span_info("Left-click it with a loose matching part item to add that item to this pile. Middle-click it with an engineering wrench to disassemble it.")

/obj/structure/rotation_piece/vand_update_name()
	. = ..()
	if(in_stack > 1)
		name = "pile of [initial(name)]s x [in_stack]"
	else
		name = initial(name)

/obj/structure/rotation_piece/start_deconstruct(mob/living/user, obj/item/rotation_contraption/type)
	user.visible_message(span_notice("[user] starts to disassemble [src]."), span_notice("You start to disassemble [src]."))
	if(!do_after(user, 2.5 SECONDS  - (user?.get_skill_level(/datum/skill/craft/engineering)  * 2), src))
		return
	var/obj/item/rotation_contraption/contraption = new type(get_turf(src))
	if(in_stack > 1)
		contraption.in_stack += in_stack - 1
		contraption.vand_update_appearance(UPDATE_NAME)
	qdel(src)

/obj/structure/rotation_piece/cog
	name = "cogwheel"
	icon_state = "1"
	cog_size = COG_SMALL
	stress_use = 3
	var/datum/looping_sound/soundloop

/obj/structure/rotation_piece/cog/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Meshes with adjacent cogwheels to transfer rotation sideways.")
	. += span_info("Different cog sizes change the output RPM when they mesh together.")

/obj/structure/rotation_piece/cog/Initialize()
	soundloop = new /datum/looping_sound/cog_loop(src, FALSE)
	. = ..()

/obj/structure/rotation_piece/cog/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/structure/rotation_piece/cog/large
	name = "large cogwheel"
	icon_state = "l1"
	cog_size = COG_LARGE
	stress_use = 6


/obj/structure/rotation_piece/cog/large/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Large cogwheels use more stress but alter RPM more strongly when meshed with smaller cogs.")

/obj/structure/rotation_piece/cog/large/Initialize()
	. = ..()
	soundloop = new /datum/looping_sound/cog_loop/heavy(src, FALSE)
	var/matrix/skew = matrix()
	skew.Scale(1.5, 1.5)
	transform = skew

/obj/structure/rotation_piece/cog/can_connect(obj/structure/connector)
	if(connector.rotation_direction && rotation_direction && (connector.rotation_direction != rotation_direction))
		if(!istype(connector, /obj/structure/rotation_piece/cog))
			if(connector.rotations_per_minute && rotations_per_minute)
				return FALSE
	return TRUE

/obj/structure/rotation_piece/cog/find_rotation_network()
	for(var/direction in GLOB.cardinals)
		var/turf/step_back = get_step(src, direction)
		for(var/obj/structure/structure in step_back?.contents)
			if(QDELETED(structure.rotation_network))
				continue
			if(!(direction & dpdir)) // not in dpdir, check for cog structures
				if(!istype(structure, /obj/structure/rotation_piece/cog))
					continue
				if(structure.dir != dir && structure.dir != REVERSE_DIR(dir)) // cogs not oriented in same direction
					continue
			else if(!(REVERSE_DIR(direction) & structure.dpdir))
				continue

			if(rotation_network)
				if(!structure.try_network_merge(src))
					rotation_break()
			else
				if(!structure.try_connect(src))
					rotation_break()

	if(!rotation_network)
		rotation_network = new
		rotation_network.add_connection(src)
		last_stress_added = 0
		set_stress_use(stress_use)

/obj/structure/rotation_piece/cog/return_surrounding_rotation(datum/rotation_network/network)
	var/list/surrounding = list()

	for(var/direction in GLOB.cardinals)
		var/turf/step_back = get_step(src, direction)
		for(var/obj/structure/structure in step_back?.contents)
			if(!(direction & dpdir)) // not in dpdir, check for cog structures
				if(!istype(structure, /obj/structure/rotation_piece/cog))
					continue
			else if(!(REVERSE_DIR(direction) & structure.dpdir))
				continue
			if(!(structure in network.connected))
				continue
			surrounding |= structure
	return surrounding

/obj/structure/rotation_piece/cog/proc/update_soundloop()
	if(!soundloop)
		return
	if(!has_active_rotation())
		if(!soundloop.stopped)
			soundloop.stop()
		return
	if(soundloop.stopped)
		soundloop.start()

/obj/structure/rotation_piece/cog/proc/has_active_rotation()
	return rotation_network && !rotation_network?.overstressed && rotations_per_minute && rotation_network?.total_stress

/obj/structure/rotation_piece/cog/update_animation_effect()
	update_soundloop()
	if(!has_active_rotation())
		animate(src, icon_state = "1", time = 1)
		return
	var/frame_stage = 1 / ((rotations_per_minute / 60) * 4)
	if(rotation_direction == WEST)
		animate(src, icon_state = "1", time = frame_stage, loop=-1)
		animate(icon_state = "2", time = frame_stage)
		animate(icon_state = "3", time = frame_stage)
		animate(icon_state = "4", time = frame_stage)
	else
		animate(src, icon_state = "4", time = frame_stage, loop=-1)
		animate(icon_state = "3", time = frame_stage)
		animate(icon_state = "2", time = frame_stage)
		animate(icon_state = "1", time = frame_stage)

/obj/structure/rotation_piece/cog/find_and_propagate(list/checked, first = FALSE)
	if(!length(checked))
		checked = list()
	checked |= src

	for(var/direction in GLOB.cardinals)
		var/turf/step_back = get_step(src, direction)
		if(!step_back)
			continue
		for(var/obj/structure/structure in step_back.contents)
			if(structure in checked)
				continue
			if(!(direction & dpdir))  // not in dpdir, check for cog structures
				if(!istype(structure, /obj/structure/rotation_piece/cog))
					continue
			else if(!(REVERSE_DIR(direction) & structure.dpdir))
				continue
			if(!(structure in rotation_network.connected))
				continue
			propagate_rotation_change(structure, checked, TRUE)
	if(first && rotation_network)
		rotation_network.update_animation_effect()

/obj/structure/rotation_piece/cog/propagate_rotation_change(obj/structure/connector, list/checked, first = FALSE)
	if(!length(checked))
		checked = list()
	checked |= src

	var/direction = get_dir(src, connector)
	if(direction != dir && direction != REVERSE_DIR(dir))
		if(istype(connector, /obj/structure/rotation_piece/cog))
			connector.rotation_direction = REVERSE_DIR(rotation_direction)
			connector.set_rotations_per_minute(get_speed_mod(connector))
	else
		if(connector.stress_generator && connector.rotation_direction && rotation_direction && (connector.rotation_direction != rotation_direction))
			rotation_break()
			return
		connector.rotation_direction = rotation_direction
		if(!connector.stress_generator)
			connector.set_rotations_per_minute(rotations_per_minute)

	connector.find_and_propagate(checked, FALSE)
	if(first)
		rotation_network.update_animation_effect()

/obj/structure/rotation_piece/cog/proc/get_speed_mod(obj/structure/connector)
	var/obj/structure/rotation_piece/cog = connector
	var/cog_ratio = cog_size / cog.cog_size
	return rotations_per_minute * cog_ratio

/obj/structure/rotation_piece/cog/large/update_animation_effect()
	update_soundloop()
	if(!has_active_rotation())
		animate(src, icon_state = "l1", time = 1)
		return
	var/frame_stage = 1 / ((rotations_per_minute / 60) * 4)
	if(rotation_direction == WEST)
		animate(src, icon_state = "l1", time = frame_stage, loop=-1)
		animate(icon_state = "l2", time = frame_stage)
		animate(icon_state = "l3", time = frame_stage)
		animate(icon_state = "l4", time = frame_stage)
	else
		animate(src, icon_state = "l4", time = frame_stage, loop=-1)
		animate(icon_state = "l3", time = frame_stage)
		animate(icon_state = "l2", time = frame_stage)
		animate(icon_state = "l1", time = frame_stage)
