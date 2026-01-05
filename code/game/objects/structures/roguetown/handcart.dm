/obj/structure/handcart
	name = "cart"
	desc = "A wooden cart that will help you carry many things."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "cart-empty"
	density = TRUE
	max_integrity = 600
	anchored = FALSE
	climbable = TRUE

	var/list/contained_items = list()

	var/current_capacity = 0
	var/maximum_capacity = 60 //arbitrary maximum amount of weight allowed in the cart before it says fuck off

	var/arbitrary_living_creature_weight = 10 // The arbitrary weight for any thing of a mob and living variety
	var/upgrade_level = 0 // This is the carts upgrade level, capacity increases with upgrade level
	var/obj/item/cart_upgrade/upgrade = null
	facepull = FALSE
	throw_range = 1

/obj/structure/handcart/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "Its current capacity is: ([current_capacity]/[maximum_capacity])"
		. += "It contains: [counting_english_list(contained_items)]"
	if(upgrade_level)
		. += span_notice("This cart has a <i>level [upgrade_level]</i> woodcutters wheelbrace installed.")

/obj/structure/handcart/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left clicking on the cart with an empty hand will let you take out a single item at a time.")
	. += span_info("Right clicking on the cart with an empty hand dumps all the contents out on the tile it's on.")
	. += span_info("Left clicking on the cart with an item in hand will attempt to put that item into the cart.")
	. += span_info("Middle clicking the cart will place all the items on the cart's turf, into the cart.")
	. += span_info("Click-dragging an item onto the cart will drag every item on that turf into the cart.")

/obj/structure/handcart/proc/manage_upgrade()
	switch(upgrade_level)
		if(1)
			maximum_capacity = 90
		if(2)
			maximum_capacity = 120
	update_icon()

/obj/structure/handcart/Initialize(mapload)
	if(mapload)		// if closed, any item at the crate's loc is put in the contents
		addtimer(CALLBACK(src, PROC_REF(take_contents)), 0)
	. = ..()
	update_icon()

/obj/structure/handcart/container_resist(mob/living/user)
	var/atom/L = drop_location()
	for(var/atom/movable/AM in contained_items)
		if(AM == user)
			AM.forceMove(L)
			remove_from(AM)
			update_icon()
			break

/obj/structure/handcart/dump_contents()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in src)
		AM.forceMove(L)
		remove_from(AM)
	contained_items = list()
	current_capacity = 0

/obj/structure/handcart/Destroy()
	dump_contents()
	return ..()

/obj/structure/handcart/MouseDrop_T(atom/movable/O, mob/living/user)
	if(!istype(O) || !isturf(O.loc) || istype(O, /atom/movable/screen))
		return
	if(!istype(user) || user.incapacitated())
		return
	if(!Adjacent(user) || !user.Adjacent(O))
		return
	if(user == O) //try to climb into or onto it
		if(!(user.mobility_flags & MOBILITY_STAND))
			if(!do_after(user, 20, target = src))
				return FALSE
			if(put_in(O))
				playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)
			return TRUE
		return ..()
	if(user.used_intent.type == INTENT_HELP || user.used_intent.type == /datum/intent/grab/move)
		user.changeNext_move(CLICK_CD_MELEE)
		var/play_sound = FALSE
		var/turf/item_turf = get_turf(O)
		for(var/obj/item/item_on_ground in item_turf)
			if(item_on_ground == src)
				continue
			if(!insertion_allowed(item_on_ground))
				continue
			put_in(item_on_ground)
			play_sound = TRUE
		if(play_sound)
			playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)

/obj/structure/handcart/should_click_on_mouse_up(var/atom/original_object)
	return original_object == src

/obj/structure/handcart/MiddleClick(mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	var/play_sound = FALSE
	var/turf/cart_turf = get_turf(src)
	for(var/obj/item/item_on_ground in cart_turf)
		if(item_on_ground == src)
			continue
		if(!insertion_allowed(item_on_ground))
			continue
		put_in(item_on_ground)
		play_sound = TRUE
	if(play_sound)
		playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)

/obj/structure/handcart/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return

	if(!length(contained_items))
		to_chat(user, span_warning("The cart is empty."))
		return

	var/alist/targets = alist()
	for(var/atom/movable/AM as anything in contained_items)
		targets[AM.name] = AM

	var/selected_name = tgui_input_list(user, "Which item would you like to take out of the cart?", name, targets)
	if(!selected_name)
		return

	var/atom/movable/AM = targets[selected_name]
	if(ismob(AM))
		AM.forceMove(user.loc)
	else
		user.put_in_hands(AM)
	remove_from(AM)
	recalculate_capacity()

	return TRUE

/obj/structure/handcart/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/cart_upgrade))
		var/obj/item/cart_upgrade/item = I
		if(item.ulevel == 1)
			if(upgrade_level != 0)
				to_chat(user, span_warning("This wheelbrace is obsolete."))
				return
			else
				upgrade = item
				upgrade_level = item.ulevel
				qdel(item)
				manage_upgrade()
				playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)
		if(item.ulevel == 2)
			if(upgrade_level != 1)
				to_chat(user, span_warning("The cart needs a normal wheelbrace before this one can be used!"))
				return
			else
				upgrade = item
				upgrade_level = item.ulevel
				qdel(item)
				manage_upgrade()
				playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)
	if(!user.cmode)
		if(!insertion_allowed(I))
			return
		if(put_in(I, user))
			playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)
		return
	..()

/obj/structure/handcart/proc/put_in(atom/movable/O, mob/user)
	var/atom_weight = get_atom_weight(O)
	if(current_capacity + atom_weight > maximum_capacity)
		to_chat(user, span_warning("The cart cannot hold any more weight!"))
		return FALSE

	if(user && !user.transferItemToLoc(O, src))
		return FALSE

	RegisterSignal(O, COMSIG_QDELETING, PROC_REF(remove_from_signal))

	O.forceMove(src)
	current_capacity += atom_weight
	contained_items += O
	update_icon()
	return TRUE

/obj/structure/handcart/proc/remove_from_signal(atom/movable/O)
	SIGNAL_HANDLER
	remove_from(O)

/obj/structure/handcart/proc/remove_from(atom/movable/O, mob/user)
	if(!(O in contained_items))
		return FALSE

	UnregisterSignal(O, COMSIG_QDELETING)

	if(user)
		O.forceMove(user.loc)
	contained_items -= O
	current_capacity = max(current_capacity - get_atom_weight(O), 0)
	update_icon()
	return TRUE

/obj/structure/handcart/proc/get_atom_weight(var/atom/movable/atom)
	var/weight = 0
	if(isitem(atom))
		var/obj/item/I = atom
		weight = I.w_class
	if(isliving(atom))
		weight = arbitrary_living_creature_weight
	return weight

/obj/structure/handcart/proc/recalculate_capacity()
	current_capacity = 0
	for(var/atom/movable/AM in contained_items)
		current_capacity += get_atom_weight(AM)

/obj/structure/handcart/proc/take_contents()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in L)
		if(AM != src && put_in(AM)) // limit reached
			break

/obj/structure/handcart/update_icon()
	. = ..()
	cut_overlays()
	if(upgrade_level)
		if(upgrade_level == 1)
			add_overlay("ov_upgrade")
		if(upgrade_level == 2)
			add_overlay("ov_upgrade2")
	if(length(contained_items))
		icon_state = "cart-full"
	else
		icon_state = "cart-empty"

/obj/structure/handcart/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(length(contained_items))
		dump_contents()
		visible_message(span_info("[user] dumps out \the [src]!"))
		playsound(loc, 'sound/foley/cartdump.ogg', 100, FALSE, -1)
	update_icon()

/obj/structure/handcart/proc/insertion_allowed(atom/movable/AM)
	if(ismob(AM))
		if(!isliving(AM)) //let's not put ghosts or camera mobs inside closets...
			return FALSE
		var/mob/living/L = AM
		if(L.anchored || (L.buckled && L.buckled != src) || L.incorporeal_move || L.has_buckled_mobs())
			return FALSE
		if(L.mob_size > MOB_SIZE_TINY) // Tiny mobs are treated as items.
			if(L.cmode && L.stat != DEAD)
				return FALSE
		L.stop_pulling()

	else if(isobj(AM))
		if((AM.density) || AM.anchored || AM.has_buckled_mobs())
			return FALSE
		else
			if(isitem(AM))
				var/obj/item/I = AM
				if(HAS_TRAIT(I, TRAIT_NODROP) || I.item_flags & ABSTRACT)
					return FALSE
	else // not a mob or object
		return FALSE

	return TRUE

/obj/structure/handcart/Move(atom/newloc, direct, glide_size_override)
	. = ..()
	if (. && pulledby && dir != pulledby.dir)
		setDir(pulledby.dir)

/obj/structure/handcart/get_crafting_contents()
	return contained_items

/obj/item/cart_upgrade
	name = "Example upgrade cog"
	desc = "Example upgrade."
	icon_state = "upgrade"
	icon = 'icons/roguetown/misc/structure.dmi'
	var/ulevel = 0
	grid_width = 64
	grid_height = 32

/obj/item/cart_upgrade/level_1
	name = "woodcutters wheelbrace"
	desc = "A wheelbrace, skillfully cut by a woodworker that can increase the carry capacity of a wooden cart."
	icon_state = "upgrade"
	ulevel = 1

/obj/item/cart_upgrade/level_2
	name = "reinforced woodcutters wheelbrace"
	desc = "A wheelbrace, expertly crafted by a woodworker that can further increase the carry capacity of a wooden cart. The first upgrade is required for this one to function."
	icon_state = "upgrade2"
	ulevel = 2
