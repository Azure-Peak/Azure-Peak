/obj/item/storage/bag
	slot_flags = ITEM_SLOT_BELT

/*
 * Trays - Agouri
 *///wip
/obj/item/storage/bag/tray
	name = "tray"
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "tray"
	desc = "A servant's most treasured helper, able to hold several platters of food, cutlery, bottles and cups. Don't trip!"
	force = 5
	throwforce = 10
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_BULKY
	flags_1 = CONDUCT_1
	component_type = /datum/component/storage/concrete/tray
	var/tray_display_dummies = list()

/obj/item/storage/bag/tray/check_spill()
	return

/obj/item/storage/bag/tray/psy
	name = "tray"
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "tray_psy"
	desc = ""

/obj/item/storage/bag/tray/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/bag/tray/Moved()
	. = ..()
	update_icon()

/obj/item/storage/bag/tray/attack(mob/living/M, mob/living/user)
	..()
	// Drop all the things. All of them.
	var/list/obj/item/oldContents = contents.Copy()
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_QUICK_EMPTY)

	// Make each item scatter a bit
	for (var/obj/item/I in oldContents)
		if (I)
			do_scatter(I)

	if(prob(50))
		playsound(M, 'sound/blank.ogg', 50, TRUE)
	else
		playsound(M, 'sound/blank.ogg', 50, TRUE)

	if(ishuman(M) || ismonkey(M))
		if(prob(10))
			M.Paralyze(40)
	update_icon()

/obj/item/storage/bag/tray/proc/do_scatter(obj/item/I)
	if (I)
		for (var/i in 1 to rand(1, 2))
			var/xOffset = rand(-16, 16)  // Adjust the range as needed
			var/yOffset = rand(-16, 16)  // Adjust the range as needed

			I.x = xOffset
			I.y = yOffset


			sleep(rand(2, 4))

/obj/item/storage/bag/tray/update_icon()
	// i cannot express how much i hate this stupid codebase sometimes. this is WRETCHED but it works
	for(var/obj/dummy in tray_display_dummies)
		qdel(dummy)
	tray_display_dummies = list()
	vis_contents = list()
	
	if (contents.len > 0)
		for(var/obj/item/thing_in_tray in contents)
			var/obj/dummy = new()
			dummy.appearance = thing_in_tray.appearance
			dummy.underlays = null
			dummy.vis_contents = thing_in_tray.vis_contents
			dummy.pixel_x = rand(-8, 8)
			dummy.pixel_y = rand(-8, 8)
			dummy.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
			
			tray_display_dummies += dummy
			vis_contents += dummy


/obj/item/storage/bag/tray/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	update_icon()

/obj/item/storage/bag/tray/Exited(atom/movable/gone, direction)
	. = ..()
	update_icon()

/obj/item/storage/meatbag
	name = "game satchel"
	desc = "A cloth and leather satchel for storing the fruit of one's hunt."
	icon_state = "gamesatchel"
	icon = 'icons/roguetown/clothing/storage.dmi'
	slot_flags = ITEM_SLOT_BACK_L|ITEM_SLOT_BACK_R|ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = NONE
	max_integrity = 300
	component_type = /datum/component/storage/concrete/grid/meatsack

/obj/item/storage/meatbag/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(things.len)
		var/obj/item/I = pick(things)
		STR.remove_from_storage(I, get_turf(user))
		user.put_in_hands(I)

/obj/item/storage/meatbag/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,
							"sx" = -4,
							"sy" = -7,
							"nx" = 6,
							"ny" = -6,
							"wx" = -2,
							"wy" = -7,
							"ex" = -1,
							"ey" = -7,
							"northabove" = 0,
							"southabove" = 1,
							"eastabove" = 1,
							"westabove" = 0,
							"nturn" = 0,
							"sturn" = 0,
							"wturn" = 0,
							"eturn" = 0,
							"nflip" = 0,
							"sflip" = 0,
							"wflip" = 0,
							"eflip" = 8)
