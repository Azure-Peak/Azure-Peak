/turf/open/floor/rogue/shroud/hag
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	slowdown = 3

/turf/closed/wall/shroud/hag
	max_integrity = 10000000
	damage_deflection = 99999999
	blade_dulling = DULLING_FLOOR

/obj/effect/hag_teleport_marker
	name = "root network start"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"
	anchored = TRUE
	layer = MID_LANDMARK_LAYER
	invisibility = INVISIBILITY_ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/effect/hag_teleport_marker/ex_act()
	return

INITIALIZE_IMMEDIATE(/obj/effect/hag_teleport_marker)

/obj/effect/hag_teleport_marker/Initialize(mapload)
	. = ..()
	GLOB.hag_root_landmarks += src

/obj/effect/hag_teleport_marker/Destroy()
	GLOB.hag_root_landmarks -= src
	return ..()

/datum/status_effect/hag_root_tether
	id = "root_tether"
	duration = 120 SECONDS 
	alert_type = /atom/movable/screen/alert/status_effect/hag_root_tether
	/// The tree we're trying to get to.
	var/obj/structure/roguemachine/mossmother/target_tree
	/// If we stay too long in the roots, we go back here.
	var/turf/origin_point

/datum/status_effect/hag_root_tether/on_apply()
	. = ..()
	if(!origin_point)
		origin_point = get_turf(owner)

/datum/status_effect/hag_root_tether/on_remove()
	var/area/A = get_area(owner)
	// If time runs out and they are still in the maze area
	if(istype(A, /area/rogue/indoors/shelter/bog_hag/root_maze))
		to_chat(owner, span_userdanger("The roots start dragging you back out from whence you came!"))
		owner.forceMove(origin_point)
		// Let's not leave any valuables there hmm?
		clean_root_maze(origin_point)
	return ..()

/datum/status_effect/hag_root_tether/on_creation(mob/living/new_owner, new_tree, new_taget)
	src.target_tree = new_tree
	src.origin_point = new_taget
	return ..()

/atom/movable/screen/alert/status_effect/hag_root_tether
	name = "Rooted!"
	desc = "Find the exit at the center of the maze or be sent back!"
	icon_state = "buff"

/obj/structure/roguemachine/mazeroot
	name = "The Mazeroot"
	desc = "A massive knot of roots that serves as the nexus of the bog. Touching it will finalize your journey through the root paths."
	icon = 'icons/roguetown/items/hag/hag_tree.dmi'
	icon_state = "mossmother"
	density = TRUE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.1
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	pixel_y = -30
	pixel_x = -27

/obj/structure/roguemachine/mazeroot/attack_hand(mob/living/user)
	if(!user || !user.Adjacent(src))
		return
	var/datum/status_effect/hag_root_tether/T = user.has_status_effect(/datum/status_effect/hag_root_tether)
	var/obj/structure/roguemachine/mossmother/final_dest
	if(T && T.target_tree)
		// Intended journey
		final_dest = T.target_tree
	else
		// Failsafe for people who might end up here due to shenanigans!
		var/list/possible_exits = list()
		for(var/obj/structure/roguemachine/mossmother/M in GLOB.hag_trees)
			var/area/A = get_area(M)
			// Don't eject in hag hut
			if(!istype(A, /area/rogue/indoors/shelter/bog_hag))
				possible_exits += M
		if(possible_exits.len)
			final_dest = pick(possible_exits)
		else
			to_chat(user, span_warning("The Heartroot is silent. There are no surface roots to reach... (Maybe ahelp?)"))
			return

	if(!do_after(user, 1 SECONDS, target = src))
		return

	var/turf/exit_turf = get_step(final_dest, SOUTH)
	if(!exit_turf || exit_turf.is_blocked_turf())
		exit_turf = get_turf(final_dest)
	// Passenger Logic
	var/mob/living/passenger = user.pulling
	if(passenger && (!istype(passenger) || get_dist(src, passenger) > 2))
		passenger = null 
	to_chat(user, span_boldnotice("The Heartroot pulses, recognizing your path. You are guided to [get_area(final_dest)]."))
	user.forceMove(exit_turf)
	if(passenger)
		passenger.forceMove(exit_turf)
		to_chat(passenger, span_userdanger("You are hauled out of the muddy darkness along with [user]!"))
		passenger.remove_status_effect(/datum/status_effect/hag_root_tether)

	// clean up last to avoid snapping people back.
	user.remove_status_effect(/datum/status_effect/hag_root_tether)
	clean_root_maze(exit_turf)

	return TRUE

/proc/clean_root_maze(turf/target_turf)
	var/area/maze_area = GLOB.areas_by_type[/area/rogue/indoors/shelter/bog_hag/root_maze]
	if(!maze_area || !target_turf)
		return
	var/list/items_to_return = list()
	for(var/turf/T in maze_area)
		for(var/obj/item/I in T)
			if(!I.anchored)
				items_to_return += I
	for(var/obj/item/I in items_to_return)
		I.forceMove(target_turf)
