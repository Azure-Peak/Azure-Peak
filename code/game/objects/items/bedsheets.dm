/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "bedsheet"
	desc = ""
	icon_state = "sheetwhite"
	item_state = "sheetwhite"
	layer = MOB_LAYER
	throwforce = 0
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	dying_key = DYE_REGISTRY_BEDSHEET

	dog_fashion = /datum/dog_fashion/head/ghost
	var/list/dream_messages = list("white")
	var/datum/weakref/signal_sleeper //this is our goldylocks

/obj/item/bedsheet/Initialize()
	. = ..()
	AddElement(/datum/element/bed_tuckable, 0, 0, 0)

/obj/item/bedsheet/attack(mob/living/user)
	if(!user.CanReach(src))		//No telekenetic grabbing.
		return
	if(!user.resting)
		return
	if(!user.dropItemToGround(src))
		return
	coverup(user)
	add_fingerprint(user)

/obj/item/bedsheet/rmb_self(mob/living/user)
	setDir(turn(dir,180))
	update_icon()
	to_chat(user, span_notice("I flip [src]."))

/obj/item/bedsheet/proc/coverup(mob/living/sleeper)
	layer = ABOVE_MOB_LAYER
	plane = -2
	pixel_x = 0
	pixel_y = 0
	visible_message(span_notice("[sleeper] covers with [src]."))
	var/angle = sleeper.lying_prev
	dir = angle2dir(angle)

	signal_sleeper = WEAKREF(sleeper)
	RegisterSignal(src, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
	RegisterSignal(sleeper, COMSIG_MOVABLE_MOVED, PROC_REF(smooth_sheets))
	RegisterSignal(sleeper, COMSIG_LIVING_SET_RESTING, PROC_REF(smooth_sheets))
	RegisterSignal(sleeper, COMSIG_PARENT_QDELETING, PROC_REF(smooth_sheets))

/obj/item/bedsheet/proc/smooth_sheets(mob/living/sleeper)
	SIGNAL_HANDLER

	UnregisterSignal(src, COMSIG_ITEM_PICKUP)
	UnregisterSignal(sleeper, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(sleeper, COMSIG_LIVING_SET_RESTING)
	UnregisterSignal(sleeper, COMSIG_PARENT_QDELETING)
	to_chat(sleeper, span_notice("I smooth [src] out beneath you."))
	layer = initial(layer)
	plane = initial(plane)
	signal_sleeper = null

// We need to do this in case someone picks up a bedsheet while a mob is covered up
// otherwise the bedsheet will disappear while in our hands if the sleeper signals get activated by moving
/obj/item/bedsheet/proc/on_pickup(datum/source, mob/grabber)
	SIGNAL_HANDLER

	var/mob/living/sleeper = signal_sleeper?.resolve()

	UnregisterSignal(src, COMSIG_ITEM_PICKUP)
	UnregisterSignal(sleeper, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(sleeper, COMSIG_LIVING_SET_RESTING)
	UnregisterSignal(sleeper, COMSIG_PARENT_QDELETING)
	signal_sleeper = null

/obj/item/bedsheet/rogue
	desc = "May be hidden under whenever unable, or unwilling, to face the world."

/obj/item/bedsheet/rogue/cloth
	icon = 'icons/roguetown/misc/beds.dmi'
	icon_state = "cloth_bedsheet"
	item_state = "cloth_bedsheet"

/obj/item/bedsheet/rogue/pelt
	icon = 'icons/roguetown/misc/beds.dmi'
	icon_state = "pelt_bedsheet"
	item_state = "pelt_bedsheet"

/obj/item/bedsheet/rogue/wool
	icon = 'icons/roguetown/misc/beds.dmi'
	icon_state = "wool_bedsheet"
	item_state = "wool_bedsheet"

/obj/item/bedsheet/rogue/double_pelt
	icon = 'icons/roguetown/misc/beds.dmi'
	icon_state = "double_pelt_bedsheet"
	item_state = "double_pelt_bedsheet"

/obj/item/bedsheet/rogue/fabric
	icon = 'icons/roguetown/misc/beds.dmi'
	icon_state = "fabric_bedsheet"
	item_state = "fabric_bedsheet"

/obj/item/bedsheet/rogue/fabric_double
	icon = 'icons/roguetown/misc/beds.dmi'
	icon_state = "double_fabric_bedsheet"
	item_state = "double_fabric_bedsheet"

/obj/item/bedsheet/random
	icon_state = "random_bedsheet"
	name = "random bedsheet"
