/// Looping grind sound played while the autogrinder is actively working.
/datum/looping_sound/autogrinder_work
	mid_sounds = 'sound/items/stonestone.ogg'
	mid_length = 8
	volume = 40
	extra_range = -1

/**
 * Autogrinder
 *
 * A rotational-powered version of the millstone. Instead of a cook grinding one item at a
 * time by hand, the autogrinder pulls grindable items (anything with a `mill_result`) out of
 * an attached hopper and turns them into their milled product automatically, so long as it is
 * running and fed by a powered rotational network with enough RPM.
 */
/obj/structure/autogrinder
	name = "autogrinder"
	desc = "A stout millstone lashed into a rotational drivetrain, grinding whatever it is fed without a miller's hand."
	icon = 'icons/obj/autogrinder.dmi'
	icon_state = "mill_off"
	anchored = TRUE
	density = TRUE
	max_integrity = 400

	// Rotational power
	rotation_structure = TRUE
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_LEFT | CONN_DIR_RIGHT | CONN_DIR_FLIP

	/// Type of hopper chest spawned beside the grinder to hold the raw material.
	var/hopper_type = /obj/structure/closet/crate/chest/autogrinder
	/// The attached hopper chest.
	var/obj/structure/closet/crate/chest/autogrinder/hopper

	/// Whether the operator has switched the machine on.
	var/working = FALSE
	/// The item currently being ground down; cleared each time a grind completes.
	var/obj/item/current_item
	/// Accumulated grind progress toward `needed_progress`.
	var/progress = 0
	/// Progress required to finish grinding one item.
	var/needed_progress = 100
	/// Minimum RPM required for the stone to bite into material at all.
	var/rotations_required = 8

	/// Whether the "hopper is empty of grindables" alert has already fired.
	var/empty_alert = FALSE

	var/datum/looping_sound/autogrinder_work/soundloop
	debris = list(/obj/item/roguegear = 2, /obj/item/natural/wood/plank = 2, /obj/item/natural/stone = 2)

/obj/structure/autogrinder/Initialize()
	. = ..()
	var/turf/hopper_turf = get_step(src, EAST)
	hopper = new hopper_type(hopper_turf)
	hopper.parent = src
	soundloop = new(src, FALSE)
	START_PROCESSING(SSobj, src)

/obj/structure/autogrinder/Destroy()
	STOP_PROCESSING(SSobj, src)
	current_item = null
	QDEL_NULL(soundloop)
	QDEL_NULL(hopper)
	return ..()

/obj/structure/autogrinder/examine(mob/user)
	. = ..()
	. += span_notice(working ? "It is switched <b>on</b>." : "It is switched <b>off</b>.")
	if(has_power_flow())
		. += span_notice("RPM: [rotations_per_minute]")
	else
		. += span_warning("It is not drawing any rotational power.")

/obj/structure/autogrinder/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click it with an empty hand to switch it on or off; non-skilled engineers will rarely catch their hand under the stone.")
	. += span_info("It grinds anything millable from its attached hopper and only works while connected to a powered rotational network with enough RPM.")
	. += span_info("Drop grain or other grindables onto the attached hopper's tile and switch the grinder on; it feeds itself.")
	. += span_info("Ground product is dropped onto the grinder's own tile.")

/obj/structure/autogrinder/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	toggle_machine(user)

/obj/structure/autogrinder/process()
	if(!working)
		return
	if(!hopper)
		update_working_visuals()
		return
	if(!has_power_flow() || rotations_per_minute < rotations_required)
		update_working_visuals()
		return

	if(!current_item || QDELETED(current_item) || !in_grind_pool(current_item) || !current_item.mill_result)
		current_item = find_grindable()
		progress = 0

	if(!current_item)
		update_working_visuals()
		notify_empty()
		return
	empty_alert = FALSE

	progress += 8 * (rotations_per_minute / 16)
	update_working_visuals()
	if(progress >= needed_progress)
		grind_current()

/**
 * The container the grinder pulls material from.
 *
 * The hopper is a permanently open feed bin, so it always feeds straight off the tile it sits on —
 * drop grist onto it like a real hopper and the stone takes it.
 */
/obj/structure/autogrinder/proc/grind_pool()
	if(!hopper)
		return null
	return get_turf(hopper)

/// Whether the given item is currently sitting in the grinder's active material pool.
/obj/structure/autogrinder/proc/in_grind_pool(obj/item/candidate)
	if(QDELETED(candidate))
		return FALSE
	var/atom/pool = grind_pool()
	return pool && candidate.loc == pool

/// Returns the first grindable item in the active material pool, or null if there are none.
/obj/structure/autogrinder/proc/find_grindable()
	var/atom/pool = grind_pool()
	if(!pool)
		return null
	for(var/obj/item/candidate in pool)
		if(candidate.mill_result)
			return candidate
	return null

/// Whether the machine currently has grindable material queued up in the hopper.
/obj/structure/autogrinder/proc/has_grindable()
	return !!find_grindable()

/// Consumes the current item and drops its milled result onto the grinder's own tile.
/obj/structure/autogrinder/proc/grind_current()
	if(!current_item || QDELETED(current_item))
		current_item = null
		progress = 0
		return
	var/obj/item/ground = current_item
	new ground.mill_result(get_turf(src))
	qdel(ground)
	current_item = null
	progress = 0
	playsound(src, 'sound/foley/stone_scrape.ogg', 80, TRUE, -1)
	update_working_visuals()
	if(!has_grindable())
		notify_empty()

/// Fires a one-shot alert (once) when the grinder runs dry of material.
/obj/structure/autogrinder/proc/notify_empty()
	if(empty_alert)
		return
	empty_alert = TRUE
	playsound(src, 'sound/items/steamrelease.ogg', 100, FALSE)

/obj/structure/autogrinder/proc/has_power_flow()
	return rotation_network && !rotation_network.overstressed && rotations_per_minute

/// Whether the grinder is switched on and actually being driven fast enough by the network.
/// Governs the "running" look of both the stone and the hopper gears, regardless of material.
/obj/structure/autogrinder/proc/is_spinning()
	return working && has_power_flow() && rotations_per_minute >= rotations_required

/// Whether the stone should currently look and sound like it is grinding.
/obj/structure/autogrinder/proc/show_working()
	if(!working || !has_power_flow() || rotations_per_minute < rotations_required)
		return FALSE
	if(!hopper)
		return FALSE
	return has_grindable()

/obj/structure/autogrinder/proc/stop_work()
	working = FALSE
	current_item = null
	progress = 0
	update_working_visuals()

/// Switches the stone (and, through it, the hopper gears) between the idle and running animations.
/obj/structure/autogrinder/proc/update_working_visuals()
	update_soundloop()
	icon_state = is_spinning() ? "mill_on" : "mill_off"
	if(hopper && !QDELETED(hopper))
		hopper.update_gear_anim()

/obj/structure/autogrinder/proc/update_soundloop()
	if(!soundloop)
		return
	if(show_working())
		if(soundloop.stopped)
			soundloop.start()
		return
	if(!soundloop.stopped)
		soundloop.stop()

/obj/structure/autogrinder/set_rotations_per_minute(speed)
	. = ..()
	if(!.)
		return
	if(!speed && working)
		stop_work()
	set_stress_use(64 * (speed / 8))

/obj/structure/autogrinder/rotation_break()
	if(working)
		stop_work()
	return ..()

/// Returns the body zone of the hand the user is currently acting with.
/obj/structure/autogrinder/proc/active_hand_zone(mob/living/user)
	if(user?.active_hand_index == 1)
		return BODY_ZONE_L_ARM
	return BODY_ZONE_R_ARM

/// Empty-hand toggle. Turning the running stone off by hand risks injury for the unskilled.
/obj/structure/autogrinder/proc/toggle_machine(mob/living/user)
	if(!istype(user) || !user.Adjacent(src))
		return
	if(!working)
		if(!has_power_flow())
			to_chat(user, span_warning("[src] has no rotational power to draw on."))
			return

	var/was_working = working
	var/engineering_skill = user.get_skill_level(/datum/skill/craft/engineering)
	user.visible_message(span_notice("[user] starts to [was_working ? "shut down" : "start up"] [src]."), span_notice("You start to [was_working ? "shut down" : "start up"] [src]."))
	if(!do_after(user, 1.2 SECONDS, src))
		return

	if(was_working && engineering_skill < 3 && prob(10))
		user.visible_message(span_danger("[user] gets a hand caught under [src]'s stone!"), span_danger("You get your hand caught under [src]'s grinding stone!"))
		user.apply_damage(max(2, round((4 * max(1, rotations_per_minute / 8)) / max(1, engineering_skill), 1)), BRUTE, active_hand_zone(user))
		playsound(src, 'sound/foley/stone_scrape.ogg', 100, FALSE)
		return

	if(working)
		stop_work()
		to_chat(user, span_notice("You shut down [src]."))
	else
		working = TRUE
		update_working_visuals()
		to_chat(user, span_notice("You start up [src]."))

/*
 * The hopper that feeds the autogrinder. A permanently open, lidless feed bin: grist dropped onto
 * its tile is pulled straight into the grinder. Two iron gears turn inside whenever the machine runs.
 */
/obj/structure/closet/crate/chest/autogrinder
	name = "autogrinder hopper"
	desc = "A lidless material hopper that feeds an autogrinder its grist. Iron gears churn within."
	icon = 'icons/obj/autogrinder.dmi'
	icon_state = "open_off"
	base_icon_state = "open_off"
	keylock = FALSE
	locked = FALSE
	anchored = TRUE
	anchorable = FALSE
	var/obj/structure/autogrinder/parent

/obj/structure/closet/crate/chest/autogrinder/Initialize(mapload)
	. = ..()
	open()   // it has no lid; it stays open for good

/obj/structure/closet/crate/chest/autogrinder/CanAStarPass(ID, dir, caller)
	return TRUE

/obj/structure/closet/crate/chest/autogrinder/CanPass(atom/movable/mover, turf/target)
	return TRUE

/obj/structure/closet/crate/chest/autogrinder/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("A lidless feed bin — drop grain or other grindables onto its tile and the autogrinder pulls them in.")

/// The hopper has no lid, so it can never be closed.
/obj/structure/closet/crate/chest/autogrinder/close(mob/living/user)
	if(user)
		to_chat(user, span_warning("[src] has no lid to close."))
	return FALSE

/obj/structure/closet/crate/chest/autogrinder/update_icon()
	cut_overlays()
	update_gear_anim()

/// The gears turn only while the parent grinder is powered and switched on.
/obj/structure/closet/crate/chest/autogrinder/proc/update_gear_anim()
	layer = BELOW_OBJ_LAYER
	icon_state = (parent && parent.is_spinning()) ? "open_on" : "open_off"

/obj/structure/closet/crate/chest/autogrinder/Destroy()
	parent = null
	return ..()
