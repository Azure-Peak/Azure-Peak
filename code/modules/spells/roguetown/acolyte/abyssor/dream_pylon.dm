/obj/structure/dream_pylon
	name = "painted pylon"
	desc = "A strange pulsing pylon that seems to be made out of thick, solidified swirls of abyssal paints."
	icon = 'icons/obj/structures/abyssor_pylon.dmi'
	icon_state = "pylon"
	anchored = TRUE
	density = TRUE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 500

	/// Tracks the active overlay object currently attached to the pylon
	var/obj/effect/pylon_overlay/active_overlay

/obj/structure/dream_pylon/Initialize(mapload)
	. = ..()
	set_pylon_overlay('icons/obj/structures/abyssor_pylon.dmi', "ball")

/obj/structure/dream_pylon/Destroy()
	if(active_overlay)
		qdel(active_overlay)
		active_overlay = null
	return ..()

/obj/structure/dream_pylon/proc/set_pylon_overlay(new_icon, new_icon_state)
	if(active_overlay)
		cut_overlay(active_overlay)
		qdel(active_overlay)
		active_overlay = null

	if(!new_icon || !new_icon_state)
		return

	var/obj/effect/pylon_overlay/O = new(src)
	O.icon = new_icon
	O.icon_state = new_icon_state
	active_overlay = O
	add_overlay(active_overlay)

/obj/effect/pylon_overlay
	name = "ball"
	desc = "oOOoOOooOOo I'm a spooky abyssal ball OooOoOooooo pondering my orb."
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_OBJ_LAYER
