/obj/effect/quest_spawn
	name = "quest spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x"
	anchored = TRUE
	layer = MID_LANDMARK_LAYER
	invisibility = INVISIBILITY_OBSERVER
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	var/atom/movable/contained_atom
	var/datum/proximity_monitor/proximity_monitor
	var/revealing = FALSE

/obj/effect/quest_spawn/Initialize(mapload)
	. = ..()
	proximity_monitor = new(src, 7)

/obj/effect/quest_spawn/Destroy(force)
	QDEL_NULL(contained_atom)
	proximity_monitor = null
	. = ..()

/obj/effect/quest_spawn/HasProximity(mob/nearby)
	if(!contained_atom)
		return

	if(!istype(nearby))
		return

	var/datum/component/quest_object/quest_component = GetComponent(/datum/component/quest_object)
	if(!istype(quest_component))
		return

	var/datum/quest/quest = quest_component.quest_ref?.resolve()
	if(!istype(quest))
		return

	var/turf/our_turf = get_turf(src)
	var/turf/scroll_turf = get_turf(quest.quest_scroll_ref?.resolve())
	if(!our_turf || !scroll_turf)
		return

	// Matches blockade_defense's check_arrival() - get_dist alone lets a bearer one level up
	// or down trip the pod.
	if(our_turf.z != scroll_turf.z)
		return

	if(get_dist(our_turf, scroll_turf) > 7)
		return

	// Pop every spawner this quest owns at once so the whole encounter materializes together.
	quest.pop_all_spawners()

/obj/effect/quest_spawn/proc/reveal_contained()
	if(!contained_atom || revealing)
		return

	revealing = TRUE
	new /obj/effect/temp_visual/contract_phantom(get_turf(src), contained_atom)
	addtimer(CALLBACK(src, PROC_REF(finish_reveal)), QUEST_SPAWN_REVEAL_TIME)

/obj/effect/quest_spawn/proc/finish_reveal()
	if(!contained_atom)
		qdel(src)
		return

	var/image/I = image(icon = 'icons/effects/effects.dmi', loc = get_turf(src), icon_state = "mobwarning", layer = 18)
	I.layer = 18
	I.plane = 18
	I.alpha = 125
	I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	flick_overlay_view(I, 5 SECONDS)

	contained_atom.forceMove(get_turf(src))
	contained_atom = null

	playsound(loc, "plantcross", 100, FALSE, 3)

	qdel(src)

/obj/effect/quest_spawn/ex_act()
	return

/obj/effect/temp_visual/contract_phantom
	name = "approaching threat"
	desc = "Something is closing in..."
	anchored = TRUE
	randomdir = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	duration = QUEST_SPAWN_REVEAL_TIME

/obj/effect/temp_visual/contract_phantom/Initialize(mapload, atom/movable/previewed)
	. = ..()
	if(QDELETED(previewed))
		return INITIALIZE_HINT_QDEL

	appearance = previewed.appearance
	name = initial(name)
	desc = initial(desc)
	invisibility = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	color = "#777777"
	alpha = 0
	animate(src, alpha = 200, time = duration, easing = EASE_IN)
