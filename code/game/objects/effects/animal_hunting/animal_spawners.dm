/obj/effect/landmark/hunting_spawner
	// For mappers, do not map this in anywhere, map in hunting trails themselves if you really want static trails for some reason.
	// Otherwise, the flora spawners should be taking care of these.
	name = "hunting trail spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE

/obj/effect/landmark/hunting_spawner/Initialize(mapload)
	. = ..()
	SShunting.active_spawners += src

/obj/effect/landmark/hunting_spawner/Destroy()
	SShunting.active_spawners -= src
	return ..()

/obj/effect/landmark/hunting_spawner/proc/respawn_trail()
	new /obj/effect/hunting_track(src.loc)
	qdel(src)
