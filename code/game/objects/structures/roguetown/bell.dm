/obj/structure/boatbell
	name = "bell"
	desc = "This is the doomspeller of Azure Peak."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "bell"
	density = FALSE
	max_integrity = 0
	anchored = TRUE
	var/last_ring
	var/datum/looping_sound/boatloop/soundloop

/obj/structure/boatbell/Initialize()
	soundloop = new(src, FALSE)
	soundloop.start()
	. = ..()

/obj/structure/boatbell/attack_hand(mob/user)
	if(world.time < last_ring + 50)
		return
	user.visible_message(span_info("[user] rings the bell."))
	playsound(src, 'sound/misc/boatbell.ogg', 100, extrarange = 5)
	last_ring = world.time

/obj/structure/boatbell/fluff/attack_hand(mob/user)
	if(world.time < last_ring + 50)
		return
	user.visible_message(span_info("[user] rings the bell."))
	playsound(src, 'sound/misc/boatbell.ogg', 100, extrarange = 5)
	last_ring = world.time
