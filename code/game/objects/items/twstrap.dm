/obj/item/twstrap
	name = "bandolier"
	desc = ""
	icon_state = "twstrap0"
	item_state = "twstrap"
	icon = 'icons/obj/items/twstrap.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_ARMOR
	resistance_flags = FIRE_PROOF
	equip_delay_self = 5 SECONDS
	unequip_delay_self = 5 SECONDS
	max_integrity = 0
	sellprice = 15
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	alternate_worn_layer = UNDER_CLOAK_LAYER
	strip_delay = 20
	var/max_storage = 10
	var/list/tweps = list()
	sewrepair = TRUE

/obj/item/twstrap/attackby(obj/A, mob/living/carbon/user, params)
	if(istype(A, /obj/item/throwing_star) || istype(A, /obj/item/rogueweapon/huntingknife))
		if(tweps.len < max_storage)
			user.transferItemToLoc(A, tweps)
			tweps += A
			update_icon()
		else
			to_chat(loc, span_warning("Full!"))
		return
	..()

/obj/item/twstrap/MiddleClick(mob/living/user)
	if(!length(tweps))
		return
	var/alist/targets = alist()
	for(var/atom/movable/AM as anything in tweps)
		targets[AM.name] = AM
	var/selected_name = tgui_input_list(user, "WHAT DO YOU GET OUT?", name, targets)
	if(!selected_name)
		return
	var/atom/movable/AM = targets[selected_name]
	tweps -= AM
	user.put_in_hands(AM)
	update_icon()
	return TRUE

/obj/item/twstrap/attack_turf(turf/T, mob/living/user)
	if(tweps.len >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))

	for(var/obj/item/knife in T.contents)
		if(istype(knife, /obj/item/throwing_star) || istype(knife, /obj/item/rogueweapon/huntingknife))
			if(do_after(user, 5))
				if(!eatknife(knife))
					break

/obj/item/twstrap/proc/eatknife(obj/A)
	if(istype(A, /obj/item/throwing_star) || istype(A, /obj/item/rogueweapon/huntingknife))
		if(tweps.len < max_storage)
			A.forceMove(src)
			tweps += A
			update_icon()
			return TRUE
		else
			return FALSE

/obj/item/twstrap/attack_self(mob/living/user)
	..()

	if (!tweps.len)
		return
	to_chat(user, span_warning("I begin to take out the ammunition from [src], one by one..."))
	for(var/obj/item/knife in tweps)
		if(istype(knife, /obj/item/throwing_star) || istype(knife, /obj/item/rogueweapon/huntingknife))
			if(!do_after(user, 0.5 SECONDS))
				return
			knife.forceMove(user.loc)
			tweps -= knife

	update_icon()

/obj/item/twstrap/attack_right(mob/user)
	if(tweps.len)
		if(user.get_skill_level(/datum/skill/combat/knives)<2)
			if(do_after(user, 20, target = user)) //Limits those not skilled in knives from using it properly
				to_chat(user, span_notice("You fumble to draw a throwing weapon..."))
				var/obj/O = tweps[tweps.len]
				tweps -= O
				user.put_in_hands(O)
				update_icon()
		else
			var/obj/O = tweps[tweps.len]
			tweps -= O
			user.put_in_hands(O)
			update_icon()
		return TRUE

/obj/item/twstrap/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "Its current capacity is: ([tweps.len]/[max_storage])"
		. += "It contains: [counting_english_list(tweps)]"

/obj/item/twstrap/update_icon()
	switch(tweps.len)
		if(1)
			icon_state = "[item_state]1"
		if(2)
			icon_state = "[item_state]1"
		if(3)
			icon_state = "[item_state]2"
		if(4)
			icon_state = "[item_state]2"
		if(5)
			icon_state = "[item_state]3"
		if(6)
			icon_state = "[item_state]3"
		if(7)
			icon_state = "[item_state]4"
		if(8)
			icon_state = "[item_state]4"
		if(9)
			icon_state = "[item_state]5"
		if(10)
			icon_state = "[item_state]5"
		else
			icon_state = "[item_state]0"

/obj/item/twstrap/Initialize()
	. = ..()

/obj/item/twstrap/bombstrap
	name = "grenadier bandolier"
	desc = ""
	icon_state = "bombstrap0"
	item_state = "bombstrap"
	strip_delay = 20
	max_storage = 10
	var/list/fill_list = list() //use for custome fill that

/obj/item/twstrap/bombstrap/attackby(obj/A, mob/living/carbon/user, params)
	if(istype(A, /obj/item/bomb) || istype(A, /obj/item/tntstick) || istype(A, /obj/item/impact_grenade))
		if(tweps.len < max_storage)
			user.transferItemToLoc(A, tweps)
			tweps += A
			update_icon()
		else
			to_chat(loc, span_warning("Full!"))
		return
	..()

/obj/item/twstrap/bombstrap/attack_turf(turf/T, mob/living/user)
	if(tweps.len >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/bomb in T.contents)
		if(istype(bomb, /obj/item/bomb) || istype(bomb, /obj/item/tntstick) || istype(bomb, /obj/item/impact_grenade))
			if(do_after(user, 5))
				if(!eatbomb(bomb))
					break

/obj/item/twstrap/bombstrap/proc/eatbomb(obj/A)
	if(istype(A, /obj/item/bomb) || istype(A, /obj/item/tntstick) || istype(A, /obj/item/impact_grenade))
		if(tweps.len < max_storage)
			A.forceMove(src)
			tweps += A
			update_icon()
			return TRUE
		else
			return FALSE

/obj/item/twstrap/bombstrap/attack_self(mob/living/user)
	..()

	if (!tweps.len)
		return
	to_chat(user, span_warning("I begin to take out the ammunition from [src], one by one..."))
	for(var/obj/item/bomb in tweps)
		if(istype(bomb, /obj/item/bomb) || istype(bomb, /obj/item/tntstick) || istype(bomb, /obj/item/impact_grenade))
			if(!do_after(user, 0.5 SECONDS))
				return
			bomb.forceMove(user.loc)
			tweps -= bomb

	update_icon()

/obj/item/twstrap/bombstrap/attack_right(mob/user)
	if(tweps.len)
		if(HAS_TRAIT(user, TRAIT_EXPLOSIVE_SUPPLY)) //virtue and bomber roles
			var/obj/O = tweps[tweps.len]
			tweps -= O
			user.put_in_hands(O)
			update_icon()
		else
			if(do_after(user, 20, target = user))
				to_chat(user, span_notice("You fumble to draw a throwing weapon..."))
				var/obj/O = tweps[tweps.len]
				tweps -= O
				user.put_in_hands(O)
				update_icon()
		return TRUE

/obj/item/twstrap/bombstrap/bomb_and_fire/Initialize()
	..()
	fill_list = list(/obj/item/bomb,
	/obj/item/bomb,
	/obj/item/bomb,
	/obj/item/bomb,
	/obj/item/tntstick,
	/obj/item/tntstick,
	/obj/item/impact_grenade/explosion,
	/obj/item/impact_grenade/explosion,
	/obj/item/impact_grenade/smoke/fire_gas,
	/obj/item/impact_grenade/smoke/fire_gas,
	)
	for(var/i in 1 to max_storage)
		var/pickitem = pick(fill_list)
		fill_list -= pickitem

		var/obj/item/I = new pickitem(src)
		I.forceMove(src)
		tweps += I
	update_icon()

/obj/item/twstrap/bombstrap/firebomb/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/bomb/I = new(src)
		I.forceMove(src)
		tweps += I
	update_icon()
