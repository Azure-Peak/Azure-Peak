/datum/component/hag_enchanted_item
	/// How many points an item is worth. The more powerful, the more points.
	var/power_points = 1

/datum/component/hag_enchanted_item/Initialize(points = 1)
	if(!isobj(parent))
		return COMPONENT_INCOMPATIBLE
	src.power_points = points

	RegisterSignal(parent, COMSIG_OBJ_HANDED_OVER, PROC_REF(on_handed_over))

/datum/component/hag_enchanted_item/proc/on_handed_over(datum/source, mob/living/receiver, mob/living/offerer)
	SIGNAL_HANDLER

	// Check if the person giving the item is actually a Hag (has the tracker)
	var/datum/component/hag_curio_tracker/HCT = offerer.GetComponent(/datum/component/hag_curio_tracker)
	if(!HCT)
		return

	// Register the item boon via the Hag's tracker
	HCT.receive_enchanted_item(receiver, power_points)

	// We're redundant now
	qdel(src)

/obj/item/hag_test_item
	icon = 'icons/roguetown/items/natural.dmi'
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	icon_state = "pelt_rous"

/obj/item/hag_test_item/Initialize()
	src.AddComponent(/datum/component/hag_enchanted_item)
	. = ..()
