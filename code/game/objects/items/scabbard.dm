/obj/item/rogueweapon/scabbard
	name = "scabbard"
	desc = ""

	icon = 'icons/obj/items/scabbard.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	icon_state = "scabbard"
	item_state = "scabbard"

	parrysound = "parrywood"
	attacked_sound = "parrywood"

	anvilrepair = /datum/skill/craft/blacksmithing

	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	possible_item_intents = list(SHIELD_BASH)
	sharpness = IS_BLUNT
	wlength = WLENGTH_SHORT
	resistance_flags = FLAMMABLE
	blade_dulling = DULLING_BASHCHOP
	w_class = WEIGHT_CLASS_BULKY
	alternate_worn_layer = UNDER_CLOAK_LAYER
	experimental_onhip = TRUE
	experimental_onback = TRUE
	can_parry = FALSE

	COOLDOWN_DECLARE(shield_bang)

	/// Weapon path and its children that are allowed
	var/obj/item/rogueweapon/valid_blade
	/// Specific weapons that are allowed. Bypasses valid_blade
	var/list/obj/item/rogueweapon/valid_blades
	/// Specific weapons that are not allowed. Bypassed valid_blade
	var/list/obj/item/rogueweapon/invalid_blades

	/// Stores weapon
	var/obj/item/rogueweapon/sheathed

	var/sheathe_time = 0.1 SECONDS
	var/sheathe_sound = 'sound/foley/equip/scabbard_holster.ogg'

/obj/item/rogueweapon/scabbard/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left click to sheath a weapon, or to draw a sheathed weapon. Will only draw if held in hand, belt, or back.")
	. += span_info("Right click to draw a sheathed weapon.")

/obj/item/rogueweapon/scabbard/attack_obj(obj/O, mob/living/user)
	return FALSE


/obj/item/rogueweapon/scabbard/attack_turf(turf/T, mob/living/user)
	to_chat(user, span_notice("I search for my sword..."))
	for(var/obj/item/rogueweapon/sword/sword in T.contents)
		if(eat_sword(user, sword))
			break

	..()


/obj/item/rogueweapon/scabbard/proc/weapon_check(mob/living/user, obj/A)
	if(sheathed)
		to_chat(user, span_warning("The sheath is occupied!"))
		return FALSE
	if(valid_blade && !istype(A, valid_blade))
		to_chat(user, span_warning("[A] won't fit in there."))
		return FALSE
	if(valid_blades)
		if(!(A.type in valid_blades))
			to_chat(user, span_warning("[A] won't fit in there."))
			return FALSE
	if(invalid_blades)
		if(A.type in invalid_blades)
			to_chat(user, span_warning("[A] won't fit in there."))
			return FALSE
	return TRUE


/obj/item/rogueweapon/scabbard/proc/eat_sword(mob/living/user, obj/A)
	if(!weapon_check(user, A))
		return FALSE
	if(obj_broken)
		user.visible_message(
			span_warning("[user] begins to force [A] into [src]!"),
			span_warningbig("I begin to force [A] into [src].")
		)
		if(!move_after(user, 2 SECONDS, target = user))
			return FALSE
		return FALSE
	if(!move_after(user, sheathe_time, target = user))
		return FALSE

	A.forceMove(src)
	sheathed = A
	update_icon(user)

	user.visible_message(
		span_notice("[user] sheathes [A] into [src]."),
		span_notice("I sheathe [A] into [src].")
	)

	playsound(src, sheathe_sound, 100, TRUE)
	return TRUE


/obj/item/rogueweapon/scabbard/proc/puke_sword(mob/living/user)
	if(!sheathed)
		return FALSE

	if(obj_broken)
		user.visible_message(
			span_warning("[user] begins to force [sheathed] out of [src]!"),
			span_warningbig("I begin to force [sheathed] out of [src].")
		)
		if(!move_after(user, 2 SECONDS, target = user))
			return FALSE
	if(!move_after(user, sheathe_time, target = user))
		return FALSE

	sheathed.forceMove(user.loc)
	sheathed.pickup(user)
	user.put_in_hands(sheathed)
	sheathed = null
	update_icon(user)

	user.visible_message(
		span_warning("[user] draws out of [src]!"),
		span_notice("I draw out of [src].")
	)
	return TRUE


/obj/item/rogueweapon/scabbard/MouseDrop(atom/over)
	..()
	var/mob/living/M = usr

	if(!Adjacent(M))
		return
	if(!M.incapacitated() && istype(over, /atom/movable/screen/inventory/hand))
		var/atom/movable/screen/inventory/hand/H = over
		if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
			add_fingerprint(usr)


/obj/item/rogueweapon/scabbard/attack_hand(mob/user)
	var/is_in_slot = TRUE
	if(ishuman(user))
		var/mob/living/carbon/human/human = user
		is_in_slot = (src in (list(human.backl, human.backr, human.beltl, human.beltr) + human.get_inactive_held_item()))
	if(sheathed && is_in_slot)
		return puke_sword(user)
	return ..()

/obj/item/rogueweapon/scabbard/attack_right(mob/user)
	if(sheathed)
		return puke_sword(user)
	return ..()

/obj/item/rogueweapon/scabbard/attackby(obj/item/I, mob/user, params)
	if(!sheathed)
		if(!eat_sword(user, I))
			return ..()


/obj/item/rogueweapon/scabbard/examine(mob/user)
	. = ..()

	if(sheathed)
		. += span_notice("The sheath is occupied by [sheathed]. Left-click to pull it out.")


/obj/item/rogueweapon/scabbard/update_icon(mob/living/user)
	if(sheathed)
		icon_state = "[initial(icon_state)]_[sheathed.sheathe_icon]"
	else
		icon_state = "[initial(icon_state)]"

	if(user)
		user.update_inv_hands()
		user.update_inv_belt()
		user.update_inv_back()

	getonmobprop(tag)


/obj/item/rogueweapon/scabbard/getonmobprop(tag)
	..()

	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.6,
					"sx" = -6,
					"sy" = -1,
					"nx" = 6,
					"ny" = -1,
					"wx" = 0,
					"wy" = -2,
					"ex" = 0,
					"ey" = -2,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 1,
					"sflip" = 0,
					"wflip" = 1,
					"eflip" = 0
				)
			if("onback")
				return list(
					"shrink" = 0.5,
					"sx" = 1,
					"sy" = 4,
					"nx" = 1,
					"ny" = 2,
					"wx" = 3,
					"wy" = 3,
					"ex" = 0,
					"ey" = 2,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0
				)
			if("onbelt")
				return list(
					"shrink" = 0.5,
					"sx" = -2,
					"sy" = -5,
					"nx" = 4,
					"ny" = -5,
					"wx" = 0,
					"wy" = -5,
					"ex" = 2,
					"ey" = -5,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = -90,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 1
				)


/*
	DAGGER SHEATHS
*/


/obj/item/rogueweapon/scabbard/sheath
	name = "dagger sheath"
	desc = "A slingable sheath made of leather, meant to host surprises in smaller sizes. </br>By middle-clicking the sheath while it's unoccupied, I can strip off the coverings and turn it into a light weapon strap."
	sewrepair = TRUE

	icon_state = "sheath"
	item_state = "sheath"

	valid_blade = /obj/item/rogueweapon/huntingknife
	w_class = WEIGHT_CLASS_SMALL

	grid_width = 32
	grid_height = 64

	force = 3
	max_integrity = 500
	sellprice = 2

	invalid_blades = list(
		/obj/item/rogueweapon/huntingknife/idagger/silver/stake
	)

/obj/item/rogueweapon/scabbard/sheath/weapon_check(mob/living/user, obj/item/A)
	. = ..()
	if(.)
		if(!istype(A, /obj/item/rogueweapon))
			return
		var/obj/item/rogueweapon/sheathing = A
		if(!sheathing.sheathe_icon)
			return FALSE

/obj/item/rogueweapon/scabbard/sheath/getonmobprop(tag)
	..()

	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.5,
					"sx" = -6,
					"sy" = -1,
					"nx" = 6,
					"ny" = -1,
					"wx" = 0,
					"wy" = -2,
					"ex" = 0,
					"ey" = -2,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 1,
					"sflip" = 1,
					"wflip" = 1,
					"eflip" = 0
				)
			if("onback")
				return list(
					"shrink" = 0.4,
					"sx" = -3,
					"sy" = -1,
					"nx" = 0,
					"ny" = 0,
					"wx" = -4,
					"wy" = 0,
					"ex" = 2,
					"ey" = 1,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 0,
					"sturn" = 10,
					"wturn" = 32,
					"eturn" = -23,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 0
				)
			if("onbelt")
				return list(
					"shrink" = 0.5,
					"sx" = -2,
					"sy" = -5,
					"nx" = 4,
					"ny" = -5,
					"wx" = 0,
					"wy" = -5,
					"ex" = 2,
					"ey" = -5,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 1
				)

/obj/item/rogueweapon/scabbard/sheath/MiddleClick(mob/user)
	if(sheathed)
		to_chat(user, span_notice("There's something inside!"))
		return
	to_chat(user, span_notice("I start to strip the sheath down..."))
	if(do_after(user, 5 SECONDS, src))
		var/obj/item/S = new /obj/item/rogueweapon/scabbard/sheath/strap
		qdel(src)
		user.put_in_hands(S)
		return TRUE

/obj/item/rogueweapon/scabbard/sheath/strap
	name = "dagger strap"
	desc = "Something smaller and less secure than a typical sheath. Good if you like to show off."
	icon_state = "beltstrapl"
	item_state = "beltstrapl"

/obj/item/rogueweapon/scabbard/sheath/strap/update_icon(mob/living/user)
	if(sheathed)
		icon = sheathed.icon
		icon_state = sheathed.icon_state
		experimental_onback = TRUE
		experimental_onhip = TRUE
	else
		icon = initial(icon)
		icon_state = initial(icon_state)
		experimental_onback = FALSE
		experimental_onhip = FALSE
	if(user)
		user.update_inv_hands()
		user.update_inv_back()
		user.update_inv_belt()

	getonmobprop(tag)

/obj/item/rogueweapon/scabbard/sheath/getonmobprop(tag)
	..()

	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.4,
					"sx" = -10,
					"sy" = -0,
					"nx" = 11,
					"ny" = 0,
					"wx" = -4,
					"wy" = 0,
					"ex" = 2,
					"ey" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 0
				)
			if("onback")
				return list(
					"shrink" = 0.3,
					"sx" = -2,
					"sy" = -5,
					"nx" = 4,
					"ny" = -5,
					"wx" = 0,
					"wy" = -5,
					"ex" = 2,
					"ey" = -5,
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
					"eflip" = 0
				)
			if("onbelt")
				return list(
					"shrink" = 0.3,
					"sx" = -2,
					"sy" = -5,
					"nx" = 4,
					"ny" = -5,
					"wx" = 0,
					"wy" = -5,
					"ex" = 2,
					"ey" = -5,
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
					"eflip" = 0
				)

/*
	GREATWEAPON STRAPS
*/


/obj/item/rogueweapon/scabbard/gwstrap
	name = "greatweapon strap"
	desc = ""

	icon_state = "gws0"
	item_state = "gwstrap"
	icon = 'icons/obj/items/gwstrap.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64

	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = NONE
	experimental_onback = FALSE
	bigboy = TRUE
	sewrepair = TRUE

	equip_delay_self = 5 SECONDS
	unequip_delay_self = 5 SECONDS
	strip_delay = 2 SECONDS
	sheathe_time = 2 SECONDS

	max_integrity = 0
	sellprice = 15

/obj/item/rogueweapon/scabbard/gwstrap/weapon_check(mob/living/user, obj/item/A)
	. = ..()
	if(.)
		if(sheathed)
			return FALSE
		if(istype(A, /obj/item/rogueweapon))
			if(A.w_class >= WEIGHT_CLASS_BULKY)
				return TRUE
		if(!istype(A, /obj/item/clothing/neck/roguetown/psicross)) //snowflake that bypasses the valid_blades that i made. i will commit seppuku eventually
			return FALSE

/obj/item/rogueweapon/scabbard/gwstrap/update_icon(mob/living/user)
	if(sheathed)
		worn_x_dimension = 64
		worn_y_dimension = 64
		icon = sheathed.icon
		icon_state = sheathed.icon_state
		experimental_onback = TRUE
	else
		icon = initial(icon)
		icon_state = initial(icon_state)
		worn_x_dimension = initial(worn_x_dimension)
		worn_y_dimension = initial(worn_y_dimension)
		experimental_onback = FALSE

	if(user)
		user.update_inv_back()

	getonmobprop(tag)

/obj/item/rogueweapon/scabbard/gwstrap/getonmobprop(tag)
	..()
	if(!sheathed)
		return
	if(istype(sheathed, /obj/item/rogueweapon/estoc) || istype(sheathed, /obj/item/rogueweapon/greatsword))
		switch(tag)
			if("onback")
				return list(
					"shrink" = 0.6,
					"sx" = -1,
					"sy" = 2,
					"nx" = 0,
					"ny" = 2,
					"wx" = 2,
					"wy" = 1,
					"ex" = 0,
					"ey" = 1,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 70,
					"eturn" = 15,
					"nflip" = 1,
					"sflip" = 1,
					"wflip" = 1,
					"eflip" = 1,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0
				)
	else
		switch(tag)
			if("onback")
				return list(
					"shrink" = 0.7,
					"sx" = 1,
					"sy" = -1,
					"nx" = 1,
					"ny" = -1,
					"wx" = 4,
					"wy" = -1,
					"ex" = -1,
					"ey" = -1,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0
				)


/*
	GENERIC SCABBARDS
*/


/obj/item/rogueweapon/scabbard/sword
	name = "simple scabbard"
	desc = "The natural evolution to the advent of longblades. </br>By middle-clicking the scabbard while it's unoccupied, I can strip off the coverings and turn it into a weapon strap."

	icon_state = "scabbard"
	item_state = "scabbard"

	sewrepair = TRUE

	valid_blade = /obj/item/rogueweapon/sword
	invalid_blades = list(
		/obj/item/rogueweapon/sword/long/exe,
		/obj/item/rogueweapon/sword/long/martyr
	)

	force = 7
	max_integrity = 750
	sellprice = 3

/obj/item/rogueweapon/scabbard/sheath/weapon_check(mob/living/user, obj/item/A)
	. = ..()
	if(.)
		if(!istype(A, /obj/item/rogueweapon))
			return
		var/obj/item/rogueweapon/sheathing = A
		if(!sheathing.sheathe_icon)
			return FALSE

/obj/item/rogueweapon/scabbard/sword/MiddleClick(mob/user)
	if(sheathed)
		to_chat(user, span_notice("There's something inside!"))
		return
	to_chat(user, span_notice("I start to strip the scabbard down..."))
	if(do_after(user, 5 SECONDS, src))
		var/obj/item/S = new /obj/item/rogueweapon/scabbard/sword/strap
		qdel(src)
		user.put_in_hands(S)
		return TRUE

/obj/item/rogueweapon/scabbard/sword/strap
	name = "simple strap"
	desc = "The natural devolution of the evolution to the advent of longblades."
	icon_state = "beltstrapr"
	item_state = "beltstrapr"
	force = 3

/obj/item/rogueweapon/scabbard/sword/strap/update_icon(mob/living/user)
	if(sheathed)
		if(sheathed.bigboy)
			bigboy = TRUE
		icon = sheathed.icon
		icon_state = sheathed.icon_state
		experimental_onback = TRUE
		experimental_onhip = TRUE
	else
		icon = initial(icon)
		icon_state = initial(icon_state)
		experimental_onback = FALSE
		experimental_onhip = FALSE
		bigboy = FALSE
	if(user)
		user.update_inv_hands()
		user.update_inv_back()
		user.update_inv_belt()

	getonmobprop(tag)

/obj/item/rogueweapon/scabbard/sword/strap/getonmobprop(tag)
	..()

	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.5,
					"sx" = -14,
					"sy" = -8,
					"nx" = 15,
					"ny" = -7,
					"wx" = -10,
					"wy" = -5,
					"ex" = 7,
					"ey" = -6,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = -13,
					"sturn" = 110,
					"wturn" = -60,
					"eturn" = -30,
					"nflip" = 1,
					"sflip" = 1,
					"wflip" = 8,
					"eflip" = 1
				)
			if("onback")
				return list(
					"shrink" = 0.5,
					"sx" = -1,
					"sy" = 2,
					"nx" = 0,
					"ny" = 2,
					"wx" = 2,
					"wy" = 1,
					"ex" = 0,
					"ey" = 1,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 70,
					"eturn" = 15,
					"nflip" = 1,
					"sflip" = 1,
					"wflip" = 1,
					"eflip" = 1,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0
				)
			if("onbelt")
				return list(
					"shrink" = 0.4,
					"sx" = -4,
					"sy" = -6,
					"nx" = 5,
					"ny" = -6,
					"wx" = 0,
					"wy" = -6,
					"ex" = -1,
					"ey" = -6,
					"nturn" = 100,
					"sturn" = 156,
					"wturn" = 90,
					"eturn" = 180,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0
				)

/*
	KAZENGUN
*/


/obj/item/rogueweapon/scabbard/sword/kazengun
	name = "simple kazengun scabbard"
	desc = "A piece of steel lined with wood. Great for batting away blows."
	icon_state = "kazscab"
	item_state = "kazscab"

	valid_blade = /obj/item/rogueweapon/sword/sabre/mulyeog
	associated_skill = /datum/skill/combat/shields
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK)
	can_parry = TRUE
	wdefense = 8

	max_integrity = 0

/obj/item/rogueweapon/scabbard/sword/kazengun/noparry
	name = "ceremonial kazengun scabbard"
	desc = "A simple wooden scabbard, trimmed with bronze. Unlike its steel cousins, this one cannot parry."

	valid_blade = /obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo
	can_parry = FALSE


/obj/item/rogueweapon/scabbard/sword/kazengun/steel
	name = "hwang scabbard"
	desc = "A cloud-patterned scabbard with a cloth sash. Used for blocking."
	icon_state = "kazscab_steel"
	item_state = "kazscab_steel"
	valid_blade = /obj/item/rogueweapon/sword/sabre/mulyeog/rumahench


/obj/item/rogueweapon/scabbard/sword/kazengun/gold
	name = "gold-stained Xinyi scabbard"
	desc = "An ornate, wooden scabbard with a sash. Great for parrying."
	icon_state = "kazscab_gold"
	item_state = "kazscab_gold"
	valid_blade = /obj/item/rogueweapon/sword/sabre/mulyeog/rumacaptain
	sellprice = 10

/obj/item/rogueweapon/scabbard/sword/kazengun/kodachi
	name = "plain lacquer scabbard"
	desc = "A plain lacquered scabbard with simple steel hardware. A plain dark cloth serves to hang it from a belt."
	icon_state = "kazscabyuruku"
	item_state = "kazscabyuruku"
	valid_blade = /obj/item/rogueweapon/sword/short/kazengun
	wdefense = 4

/obj/item/rogueweapon/scabbard/sheath/kazengun
	name = "plain lacquer sheath"
	desc = "A simple lacquered sheath, for shorter eastern-styled blades."
	icon_state = "kazscabdagger"
	item_state = "kazscabdagger"
	valid_blade = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
	associated_skill = /datum/skill/combat/shields
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK)
	can_parry = TRUE
	wdefense = 3

	max_integrity = 0
