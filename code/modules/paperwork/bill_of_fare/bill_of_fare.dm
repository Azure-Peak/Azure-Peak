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
	icon_state = bill_of_fare_icon_state(src)
	return ..()

/obj/item/bill_of_fare/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Use it in hand to read it. Click it with a feather or thorn to write on it.")
	. += span_info("Click a wall while standing directly in front of it to pin it there.")
	. += bill_of_fare_mechanics_examine()

/obj/item/bill_of_fare/pre_attack(atom/A, mob/living/user, params)
	if(!user.cmode && isclosedturf(A))
		try_pin(A, user)
		return TRUE
	return ..()

/obj/item/bill_of_fare/proc/try_pin(turf/closed/wall, mob/living/user)
	var/turf/standing = user.loc
	if(!isturf(standing))
		return
	var/pin_dir = get_dir(standing, wall)
	if(!(pin_dir in GLOB.cardinals))
		to_chat(user, span_warning("I can't pin it from here."))
		return
	for(var/obj/structure/fluff/walldeco/bill_of_fare/other in standing)
		if(other.dir == pin_dir)
			to_chat(user, span_warning("Something is already pinned there."))
			return
	var/datum/component/bill_of_fare/menu = GetComponent(/datum/component/bill_of_fare)
	if(!menu)
		return
	var/obj/structure/fluff/walldeco/bill_of_fare/pinned = new(standing)
	if(!user.transferItemToLoc(src, pinned))
		qdel(pinned)
		return
	pinned.attach(src, menu, pin_dir)
	playsound(standing, 'sound/foley/dropsound/paper_drop.ogg', 50, TRUE)
	to_chat(user, span_notice("I pin [src] to the wall."))

/obj/structure/fluff/walldeco/bill_of_fare
	name = "bill of fare"
	desc = "A bill of fare, pinned to a wall."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "paper"
	layer = BELOW_MOB_LAYER
	max_integrity = 20
	resistance_flags = FLAMMABLE
	var/obj/item/bill_of_fare/sheet

/obj/structure/fluff/walldeco/bill_of_fare/Destroy()
	QDEL_NULL(sheet)
	return ..()

/obj/structure/fluff/walldeco/bill_of_fare/proc/attach(obj/item/bill_of_fare/new_sheet, datum/component/bill_of_fare/menu, pin_dir)
	sheet = new_sheet
	dir = pin_dir
	set_wall_offset(pin_dir)
	TakeComponent(menu)
	update_icon()

/obj/structure/fluff/walldeco/bill_of_fare/update_icon_state()
	icon_state = bill_of_fare_icon_state(src)
	return ..()

/obj/structure/fluff/walldeco/bill_of_fare/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Click it to read it. Click it with a feather or thorn to write on it.")
	. += span_info("Right click it to take it down.")
	. += bill_of_fare_mechanics_examine()

/obj/structure/fluff/walldeco/bill_of_fare/attack_right(mob/user, params)
	if(!sheet)
		return FALSE
	add_fingerprint(user)
	var/datum/component/bill_of_fare/menu = GetComponent(/datum/component/bill_of_fare)
	var/obj/item/bill_of_fare/taken = sheet
	sheet = null
	if(menu)
		taken.TakeComponent(menu)
	taken.update_icon()
	user.put_in_hands(taken)
	to_chat(user, span_notice("I take down [taken]."))
	qdel(src)
	return TRUE
