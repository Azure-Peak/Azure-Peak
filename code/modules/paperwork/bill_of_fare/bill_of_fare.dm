/obj/item/bill_of_fare
	name = "bill of fare"
	desc = "A sheet of parchment for listing a tavern's menu. It is used to display the food and drink available for purchase."
	gender = NEUTER
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "paper"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_range = 1
	throw_speed = 1
	resistance_flags = FLAMMABLE
	max_integrity = 30
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound = 'sound/blank.ogg'
	dropshrink = 0.5

/obj/item/bill_of_fare/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/bill_of_fare)

/obj/item/bill_of_fare/update_icon_state()
	var/datum/component/bill_of_fare/menu = GetComponent(/datum/component/bill_of_fare)
	icon_state = menu?.has_writing() ? "paperwrite" : "paper"
	return ..()
