/obj/structure/fluff/canopy
	name = "Canopy"
	desc = "A canopy of striped fabric over a modest stall! A common sight in market towns, \
	under which all manners of goods may be sold."
	icon = 'icons/obj/decor.dmi'
	icon_state = "canopy"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	blade_dulling = DULLING_BASH
	resistance_flags = FLAMMABLE
	max_integrity = 20
	integrity_failure = 0.33
	dir = SOUTH
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/obj/structure/fluff/canopy/green
	icon_state = "canopyg"

/obj/structure/fluff/canopy/booth
	icon_state = "canopyr-booth"

/obj/structure/fluff/canopy/booth/Initialize()
	. = ..()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/fluff/canopy/booth/booth02
	icon_state = "canopyr-booth-2"

/obj/structure/fluff/canopy/booth/booth_green
	icon_state = "canopyg-booth"

/obj/structure/fluff/canopy/booth/booth_green02
	icon_state = "canopyg-booth-2"

/obj/structure/fluff/canopy/booth/CanPass(atom/movable/mover, turf/target)
	if(get_dir(loc, mover) == dir)
		return 0
	return !density

/obj/structure/fluff/canopy/booth/CanAStarPass(ID, to_dir, caller)
	if(to_dir == dir)
		return FALSE // don't even bother climbing over it
	return ..()

/obj/structure/fluff/canopy/booth/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(get_dir(leaving.loc, new_location) == dir)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/fluff/canopy/MouseDrop(mob/over)
	. = ..()

///Crafting

/datum/crafting_recipe/roguetown/structure/display_booth01
	name = "display booth"
	result = list(/obj/structure/fluff/canopy, /obj/structure/table/wood/crafted)
	reqs = list(/obj/item/grown/log/tree/small = 2,
				/obj/item/natural/cloth = 2)
	verbage_simple = "construct"
	verbage = "constructs"

/datum/crafting_recipe/roguetown/structure/display_booth02
	name = "display booth green"
	result = list(/obj/structure/fluff/canopy/green, /obj/structure/table/wood/crafted)
	reqs = list(/obj/item/grown/log/tree/small = 2,
				/obj/item/natural/cloth = 2)
	verbage_simple = "construct"
	verbage = "constructs"


/datum/crafting_recipe/roguetown/structure/booth
	name = "market booth"
	result = list(/obj/structure/fluff/canopy/booth)
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/cloth = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/booth02
	name = "market booth"
	result = list(/obj/structure/fluff/canopy/booth/booth02)
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/cloth = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/booth_green
	name = "green market booth"
	result = list(/obj/structure/fluff/canopy/booth/booth_green)
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/cloth = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/booth_green_02
	name = "green market booth02"
	result = list(/obj/structure/fluff/canopy/booth/booth_green02)
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/cloth = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 0

/obj/structure/fluff/canopy/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr) && (in_range(src, usr) || usr.contents.Find(src)))
		if(!ishuman(usr))
			return
		visible_message(span_notice("[usr] tears down [src]."))
		if(do_after(usr, 30, target = src))
			playsound(src,'sound/foley/dropsound/cloth_drop.ogg', 100, FALSE)
			new /obj/item/grown/log/tree/small  (get_turf(src))
			new /obj/item/natural/cloth (get_turf(src))
			qdel(src)
