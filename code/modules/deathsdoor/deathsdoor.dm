GLOBAL_LIST_INIT(deaths_door_entries,list())
GLOBAL_VAR(deaths_door_exit)//turf at necra's shrine on each map

/obj/structure/deaths_door_shrine
	name = "A Way Out"
	desc = "An end to the calm cold of the precipice, spirits without paid passage flock around it, gaining fleeting glances of Psydonia. Necrans who can peer through graves may be able to make sense of the twisting mists through them." 
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "doorway"
	opacity = FALSE
	density = TRUE
	max_integrity = 0

/obj/structure/deaths_door_shrine/attack_hand(mob/living/user)
	to_chat(user, span_notice("You reach for the glowing portal..."))
	if(!do_after(user, 4 SECONDS, src))
		return

	if(user.mob_biotypes & MOB_UNDEAD)
		user.visible_message(span_danger("The Undermaiden churns the undead!"))
		explosion(get_turf(user), light_impact_range = 1, flame_range = 1, smoke = FALSE)
		return

	exit_deaths_door(user, user)

/obj/structure/deaths_door_shrine/MouseDrop_T(atom/movable/O, mob/living/user)
	if(!istype(O, /mob/living))
		return
	var/mob/living/target = O

	if(target.mob_biotypes & MOB_UNDEAD)
		target.visible_message(span_danger("The Undermaiden churns the undead!"))
		explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
		return

	if(user.incapacitated())
		return
	if(!Adjacent(user) || !user.Adjacent(target))
		return
	if(!do_after_mob(user, target, 4 SECONDS))
		return

	exit_deaths_door(user, target)

	user.visible_message(
		span_notice("[user] guides [target] through Necra's shrine.")
	)

/obj/structure/deaths_door_shrine/proc/exit_deaths_door(mob/living/user, mob/living/target = null)
	var/list/dests = list()

	// Acolytes can choose exits
	if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/necras_sight))
		var/list/sight_dests = get_necras_sight_entries(user)
		if(length(sight_dests))
			for(var/turf/T in sight_dests)
				dests[T] = sight_dests[T]

	// Always allow shrine exit
	if(GLOB.deaths_door_exit)
		dests[GLOB.deaths_door_exit] = "Necra's Shrine"
	// Warn Necra followers without sight
	if(!user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/necras_sight))
		if(user.patron == /datum/patron/divine/necra)
			to_chat(user, span_warning("Necra's paths blur before you. You lack the sight to choose."))

	if(!length(dests))
		message_admins("Death's Door Shrine: No exit destinations! Inform a mapper!")	//You're missing /obj/effect/landmark/deaths_door/exit from the map
		return

	var/turf/T = prompt_deaths_door_exit(user, dests)
	if(!T)
		return
	target.forceMove(T)
	playsound(get_turf(target), 'sound/misc/portalenter.ogg', 50, TRUE, -2, ignore_walls = TRUE)
	target.visible_message(span_danger("[user] emerges from a thick deathly cold mist that clings to their form!"))

/proc/prompt_deaths_door_exit(mob/living/user, list/dests)
	if(!length(dests))
		return null

	if(length(dests) == 1)
		return dests[1]

	// Build display list: label -> turf
	var/list/named = list()
	for(var/turf/T as anything in dests)
		var/label = dests[T]
		if(!label)
			label = "[get_area(T)]"
		named[label] = T

	var/choice = input(user, "Choose a path from Death's Edge:", "Necra's Way") \
		as null|anything in named
	if(!choice)
		return null

	return named[choice]

/proc/get_necras_sight_entries(mob/living/user)
	var/list/targets = list()
	var/obj/effect/proc_holder/spell/invoked/necras_sight/spell = \
		locate(/obj/effect/proc_holder/spell/invoked/necras_sight) in user.mind?.spell_list
	if(!spell)
		return targets

	for(var/obj/O in spell.marked_objects.Copy())
		// prune deleted objects
		if(!O || QDELETED(O))
			spell.marked_objects -= O
			continue

		if(!isturf(O.loc))
			spell.marked_objects -= O
			continue
		var/turf/T = O.loc
		var/label = spell.marked_objects[O]

		// Fallback safety
		if(!label || !length(label))
			label = O.name

		targets[T] = label

	return targets

/obj/structure/deaths_door_portal
	name = "death's door"
	desc = "A misty passageway, vague shapes move beyond the veil, lit by what might be a blue lighthouse. There is no coming back if you step in here. Undead beware, you are not welcome in Necra's Precipice." 
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "underworldportal"
	anchored = TRUE
	density = FALSE
	var/turf/destination

/obj/structure/deaths_door_portal/Initialize(mapload, mob/living/_caster)
	. = ..()
	var/list/dests = GLOB.deaths_door_entries
	if(!length(dests))
		message_admins("Death's Door Portal: No entry destinations! Inform a mapper!")	//You're missing any landmarks that are subtypes of /obj/effect/landmark/deaths_door/entry in deaths precipice
		return

	destination = pick(dests)
	addtimer(CALLBACK(src, PROC_REF(expire)), 15 SECONDS)

/obj/structure/deaths_door_portal/proc/expire()
	if(QDELETED(src))
		return
	visible_message(span_notice("The glowing portal closes shut!"))
	playsound(get_turf(src), 'sound/misc/deadbell.ogg', 50, TRUE, -2)
	qdel(src)

/obj/structure/deaths_door_portal/attack_hand(mob/living/user)
	playsound(get_turf(src), 'sound/misc/carriage2.ogg', 50, TRUE, -2, ignore_walls = TRUE)
	to_chat(user, span_notice("You reach for the glowing portal..."))
	if(!do_after(user, 4 SECONDS, src))
		return
	if(user.mob_biotypes & MOB_UNDEAD)
		to_chat(user, span_danger("The Undermaiden churns the undead!"))
		explosion(get_turf(user), light_impact_range = 1, flame_range = 1, smoke = FALSE)
		return
	enter_portal(user)

/obj/structure/deaths_door_portal/MouseDrop_T(atom/movable/O, mob/living/user)
	if(!istype(O, /mob/living))
		return
	var/mob/living/M = O

	if(user.incapacitated())
		return
	if(!Adjacent(user) || !user.Adjacent(M))
		return
	playsound(get_turf(src), 'sound/misc/carriage2.ogg', 50, TRUE, -2, ignore_walls = TRUE)
	if(!do_after_mob(user, M, 4 SECONDS))
		return

	if(M.mob_biotypes & MOB_UNDEAD)
		to_chat(user, span_danger("The Undermaiden churns the undead!"))
		explosion(get_turf(M), light_impact_range = 1, flame_range = 1, smoke = FALSE)
		return

	enter_portal(M, user)

	user.visible_message(
		span_warning("[user] drags [M] into Death's Door!")
	)

/obj/structure/deaths_door_portal/proc/enter_portal(mob/living/target, mob/living/forcer)
	if(!destination)
		return
	playsound(get_turf(src), 'sound/misc/portalenter.ogg', 50, TRUE, -2, ignore_walls = TRUE)
	target.forceMove(destination)

GLOBAL_VAR_INIT(underworld_strands, 0)
/obj/effect/landmark/underworldstrands
	var/spawn_timer

/obj/effect/landmark/underworldstrands/Initialize()
	. = ..()
	start_timer()

/obj/effect/landmark/underworldstrands/Destroy()
	if(spawn_timer)
		deltimer(spawn_timer)
	return ..()

/obj/effect/landmark/underworldstrands/proc/start_timer()
	if(spawn_timer)
		deltimer(spawn_timer)

	spawn_timer = addtimer(CALLBACK(src, PROC_REF(try_spawn)), 40 MINUTES, TIMER_STOPPABLE)

/obj/effect/landmark/underworldstrands/proc/try_spawn()
	spawn_timer = null
	var/turf/T = get_turf(src)
	if(!T)
		start_timer()
		return

	new /obj/item/soulthread/deathsdoor(T)
	start_timer()

/obj/item/soulthread/deathsdoor
	name = "shimmering lux-thread"
	desc = "Eerie glowing thread, cometh from the grave"


/mob/living/proc/extract_from_deaths_edge()//for total exhaustion in death's precipice
	// Already unconscious? Don't loop
	if(stat >= UNCONSCIOUS)
		return
	src.apply_status_effect(/datum/status_effect/debuff/devitalised)
	src.SetSleeping(20 SECONDS)
	var/turf/T = get_adventurer_latejoin_turf()
	if(!T)
		return

	visible_message(
		span_danger("[src] collapses as Necra's grasp tightens."),
		span_cult("Your body is sapped entirely of energy, slumping to the ground the desperate spirits attempt to steal your body, draining your essence. The Ferryman casts you out before they completely rip you from your vessel!")
	)

	src.forceMove(T)

/mob/living/proc/get_adventurer_latejoin_turf()
	var/list/candidates = list()

	for(var/obj/effect/landmark/start/adventurerlate/L in GLOB.landmarks_list)
		if(L.loc && isturf(L.loc))
			candidates += L.loc

	if(!length(candidates))
		return null

	return pick(candidates)

/obj/structure/waywardspirit
	name = "A Wayward Soul"
	desc = "Lost in the deathly tranquility, never to return."
	icon = 'icons/roguetown/underworld/enigma_husks.dmi'
	icon_state = "hollow"
	opacity = FALSE
	density = FALSE
	max_integrity = 0
