/obj/item/rotation_contraption
	name = ""
	desc = ""

	w_class =  WEIGHT_CLASS_SMALL
	grid_height = 32
	grid_width = 32

	var/obj/structure/placed_type
	var/in_stack = 1
	var/can_stack = TRUE
	var/place_behavior
	var/resize_factor = 0.95

/obj/item/rotation_contraption/proc/can_stack_with_item(obj/item/rotation_contraption/other)
	if(!can_stack || !istype(other) || other == src)
		return FALSE
	return type == other.type && placed_type == other.placed_type

/obj/item/rotation_contraption/proc/apply_transform()
	var/matrix/resize = matrix()
	resize.Scale(0.5, 0.5)
	resize.Turn(45)
	transform = resize
	if(resize_factor)
		transform = transform.Scale(resize_factor, resize_factor)

/obj/item/rotation_contraption/Initialize()
	. = ..()
	if(placed_type)
		set_type(placed_type)
	if(can_stack)
		for(var/obj/item/rotation_contraption/contraption in loc)
			if(QDELETED(contraption))
				continue
			if(!can_stack_with_item(contraption))
				continue

			in_stack += contraption.in_stack
			qdel(contraption)
	vand_update_appearance(UPDATE_NAME)

/obj/item/rotation_contraption/afterpickup(mob/user)
	. = ..()
	apply_transform()

/obj/item/rotation_contraption/afterdrop(mob/user)
	. = ..()
	apply_transform()

/obj/item/rotation_contraption/proc/set_type(obj/structure/parent_type)
	icon = initial(parent_type.icon)
	icon_state = initial(parent_type.icon_state)
	apply_transform()
	name = initial(parent_type.name) + " item"
	desc = initial(parent_type.desc)
	placed_type = parent_type

/obj/item/rotation_contraption/attack_turf(turf/T, mob/living/user)
	. = ..()
	if(!istype(T))
		return
	var/obj/structure/rotation_piece/stack_target
	for(var/obj/structure/structure in T.contents)
		if(ispath(placed_type, /obj/structure/rotation_piece) && structure.type == placed_type)
			stack_target = structure
			continue

		if(structure.rotation_structure)
			return

		if(structure.accepts_water_input && !ispath(placed_type, /obj/structure/rotation_piece))
			return

		if(istype(structure, placed_type))
			return

	visible_message("[user] starts placing down [src].", "You start to place [src].")
	if(!do_after(user, 1.2 SECONDS - user?.get_skill_level(/datum/skill/craft/engineering), T))
		return
	if(QDELETED(stack_target) && ispath(placed_type, /obj/structure/rotation_piece))
		stack_target = locate(placed_type) in T
	if(stack_target && stack_target.type == placed_type)
		stack_target.in_stack++
		stack_target.vand_update_appearance(UPDATE_NAME)
	else
		var/obj/structure/structure = new placed_type(T)
		if(place_behavior == PLACE_TOWARDS_USER)
			if(get_turf(user) == T)
				structure.setDir(REVERSE_DIR(user.dir))
			else
				structure.setDir(get_cardinal_dir(T, user))
		else
			if(get_turf(user) == T)
				structure.setDir(user.dir)
			else
				structure.setDir(get_cardinal_dir(user, T))

	in_stack--
	if(in_stack <= 0)
		qdel(src)
	else
		vand_update_appearance(UPDATE_NAME)

/obj/item/rotation_contraption/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click an open turf to place this mechanical part into the world.")
	. += span_info("Left-click a loose matching part item with this to collect both into one pile.")
	. += span_info("Placing it onto an existing placed part of the exact same type adds it to that pile instead of making a separate object.")

/obj/item/rotation_contraption/vand_update_name()
	. = ..()
	if(in_stack > 1)
		name = "pile of [initial(placed_type.name)]s x [in_stack]"
	else
		name = initial(placed_type.name) + " item"

/obj/item/rotation_contraption/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	var/obj/item/rotation_contraption/other = I
	if(!can_stack_with_item(other))
		return

	other.in_stack += in_stack
	visible_message("[user] collects [src].")
	qdel(src)
	other.vand_update_appearance(UPDATE_NAME)

/obj/item/rotation_contraption/MouseDrop_T(atom/dropping, mob/user)
	if(can_stack_with_item(dropping))
		return
	return ..()

/obj/item/rotation_contraption/cog
	placed_type = /obj/structure/rotation_piece/cog

/obj/item/rotation_contraption/cog/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Cogwheels mesh with adjacent cogwheels to pass rotation sideways.")

/obj/item/rotation_contraption/shaft
	placed_type = /obj/structure/rotation_piece

/obj/item/rotation_contraption/shaft/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Shafts carry rotation straight through from one end to the other.")

/obj/item/rotation_contraption/large_cog
	placed_type = /obj/structure/rotation_piece/cog/large

/obj/item/rotation_contraption/large_cog/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Large cogwheels change RPM more strongly when meshed with smaller cogs, but they use more stress.")

/obj/item/rotation_contraption/horizontal
	placed_type = /obj/structure/gearbox

/obj/item/rotation_contraption/horizontal/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Gearboxes redirect rotation across horizontal directions on the same z-level.")

/obj/item/rotation_contraption/vertical
	placed_type = /obj/structure/vertical_gearbox

/obj/item/rotation_contraption/vertical/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Vertical gearboxes pass rotation up and down between levels.")

/obj/item/rotation_contraption/waterwheel
	placed_type = /obj/structure/waterwheel

/obj/item/rotation_contraption/waterwheel/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Waterwheels must be placed in flowing river water and turned across the current to generate power.")

	grid_height = 96
	grid_width = 96


/obj/item/rotation_contraption/debug_source
	placed_type = /obj/structure/debug_rotation_source
	can_stack = FALSE

/obj/item/rotation_contraption/debug_source/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Immediately outputs 32 RPM into a rotational network.")


/obj/item/rotation_contraption/minecart_rail
	placed_type = /obj/structure/minecart_rail

/obj/item/rotation_contraption/minecart_rail/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Place this to build minecart track. Powered straight rails can push carts when linked into a rotational network.")

	grid_height = 64
	grid_width = 32

/obj/item/rotation_contraption/minecart_rail/railbreak
	placed_type = /obj/structure/minecart_rail/railbreak

/obj/item/rotation_contraption/minecart_rail/railbreak/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Place this to build a brake rail. When powered, it stops passing minecarts until disabled.")

	grid_height = 64
	grid_width = 32

/obj/item/rotation_contraption/roller
	placed_type = /obj/structure/roller

/obj/item/rotation_contraption/roller/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Rollers move loose items and mobs in their facing direction while powered.")

	grid_height = 32
	grid_width = 32
