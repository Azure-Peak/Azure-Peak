/obj/effect/particle_effect/expl_particles
	name = "fire"
	icon_state = "explosion_particle"
	opacity = 0
	anchored = TRUE

/obj/effect/particle_effect/expl_particles/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/particle_effect/expl_particles/LateInitialize()
	var/direct = pick(GLOB.alldirs)
	var/steps_amt = pick(1;25,2;50,3,4;200)

	for(var/j in 1 to min(steps_amt, 5))
		step(src, direct)

	QDEL_IN(src, 6 SECONDS)

/datum/effect_system/expl_particles
	number = 5

/datum/effect_system/expl_particles/start()
	for(var/i in 1 to number)
		new /obj/effect/particle_effect/expl_particles(location)

/obj/effect/explosion
	name = "fire"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "explosion"
	opacity = 1
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -32
	pixel_y = -32

/obj/effect/explosion/Initialize()
	. = ..()
	QDEL_IN(src, 1.2 SECONDS)

/datum/effect_system/explosion

/datum/effect_system/explosion/set_up(loca)
	if(isturf(loca))
		location = loca
	else
		location = get_turf(loca)

/datum/effect_system/explosion/start()
	new/obj/effect/explosion( location )
	var/datum/effect_system/expl_particles/P = new/datum/effect_system/expl_particles()
	P.set_up(10, 0, location)
	P.start()

/datum/effect_system/explosion/smoke

/datum/effect_system/explosion/smoke/proc/create_smoke()
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(2, location)
	S.start()
/datum/effect_system/explosion/smoke/start()
	..()
	addtimer(CALLBACK(src, PROC_REF(create_smoke)), 5)
