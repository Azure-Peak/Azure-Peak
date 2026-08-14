/obj/effect/waterfall
	name = "waterfall"
	icon = 'icons/effects/waterfall.dmi'
	icon_state = "waterfall_temp"
	pixel_y = 32
	var/datum/reagent/water_reagent = /datum/reagent/water

/obj/effect/waterfall/Initialize(mapload)
	. = ..()
	var/turf/open = get_turf(src)
	if(istransparentturf(open))
		return
	color = initial(water_reagent.color)
	var/obj/particle_emitter/effect = MakeParticleEmitter(/particles/mist/waterfall)
	effect.layer = 5
	effect.alpha = 175

/obj/effect/waterfall/acid
	water_reagent = /datum/reagent/rogueacid

/particles/mist
	name = "mist"
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state = list("steam_1" = 1, "steam_2" = 1, "steam_3" = 1)
	count = 500
	spawning = 4
	lifespan = 5 SECONDS
	fade = 1 SECONDS
	fadein = 1 SECONDS
	velocity = generator("box", list(-0.5, -0.25, 0), list(0.5, 0.25, 0), NORMAL_RAND)
	position = generator("box", list(-20, -16), list(20, -2), UNIFORM_RAND)
	friction = 0.2
	grow = 0.0015

/particles/mist/waterfall
	count = 75
	lifespan =  generator("num", 2 SECONDS, 3 SECONDS)
	position = generator("box", list(-20, 4), list(20, 10), UNIFORM_RAND)
