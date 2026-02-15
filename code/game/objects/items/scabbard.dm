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
	var/list/obj/item/rogueweapon/valid_blades = list()
	/// Specific weapons that are not allowed. Bypassed valid_blade
	var/list/obj/item/rogueweapon/invalid_blades = list()

	/// Stores weapon
	var/obj/item/rogueweapon/sheathed

	var/sheathe_time = 0.1 SECONDS
	var/sheathe_sound = 'sound/foley/equip/scabbard_holster.ogg'

/obj/item/rogueweapon/scabbard/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left click to sheath a weapon, or to draw a sheathed weapon. Will only draw if held in hand, belt, or back.")
	. += span_info("Right click to draw a sheathed weapon.")
	. += span_info("Middle click to transform it into a strap, which allows for a weapon to be openly carried without any delays to drawing or sheathing.")
	. += span_info("Straps cannot be transformed back into scabbards or sheaths.")

/obj/item/rogueweapon/scabbard/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/holster, (valid_blade ? valid_blade : null), (length(valid_blades) ? valid_blades : null), (length(invalid_blades) ? invalid_blades : null))

/obj/item/rogueweapon/scabbard/attack_obj(obj/O, mob/living/user)
	return FALSE

/obj/item/rogueweapon/scabbard/MouseDrop(atom/over)
	..()
	var/mob/living/M = usr

	if(!Adjacent(M))
		return
	if(!M.incapacitated() && istype(over, /atom/movable/screen/inventory/hand))
		var/atom/movable/screen/inventory/hand/H = over
		if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
			add_fingerprint(usr)

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


//////////////////////
//	DAGGER SHEATHS  //
//////////////////////

/obj/item/rogueweapon/scabbard/sheath
	name = "dagger sheath"
	desc = "A slingable sheath made of leather, meant to host surprises in smaller sizes."
	sewrepair = TRUE

	icon_state = "sheath"
	item_state = "sheath"

	valid_blade = /obj/item/rogueweapon/huntingknife
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK|ITEM_SLOT_WRISTS //An intended design, albeit rather late-in-timing. Sacrifice arm protection for more versatile storage.

	grid_width = 32
	grid_height = 64

	force = 3
	max_integrity = 500
	sellprice = 2

	invalid_blades = list(
		/obj/item/rogueweapon/huntingknife/idagger/stake,
		/obj/item/rogueweapon/huntingknife/idagger/silver/stake)

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

/obj/item/rogueweapon/scabbard/sheath/noble
	name = "silver-decorated knife sheath"
	desc = "A dagger's noble sheath, enamored with elaborate silver decorations. Oft-flaunted upon the faulds of a knight, it dangles and sways whenever its steely reserve is drawn."
	icon_state = "nsheath"
	associated_skill = /datum/skill/combat/shields
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK)
	can_parry = TRUE
	wdefense = 2
	max_integrity = 50
	sellprice = 50
	resistance_flags = null

/obj/item/rogueweapon/scabbard/sheath/royal
	name = "gold-decorated knife sheath"
	desc = "A dagger's royal sheath, enamored with exquisite golden decorations. The hand that draws will spell the fate of many; be it for the kingdom or the world."
	icon_state = "rsheath"
	associated_skill = /datum/skill/combat/shields
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK)
	can_parry = TRUE
	wdefense = 4
	sellprice = 100
	resistance_flags = null

///////////////////////
//	SWORD SCABBARDS  //
///////////////////////

/obj/item/rogueweapon/scabbard/sword
	name = "simple scabbard"
	desc = "The natural evolution to the advent of longblades."

	icon_state = "scabbard"
	item_state = "scabbard"

	sewrepair = TRUE

	valid_blade = /obj/item/rogueweapon/sword
	invalid_blades = list(
		/obj/item/rogueweapon/sword/long/exe,
		/obj/item/rogueweapon/sword/long/martyr,
		/obj/item/rogueweapon/sword/long/exe/berserk
	)

	force = 7
	max_integrity = 750
	sellprice = 3

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

/obj/item/rogueweapon/scabbard/sword/strap/ComponentInitialize()
	AddComponent(/datum/component/holster/simplestrap, (valid_blade ? valid_blade : null), (length(valid_blades) ? valid_blades : null), (length(invalid_blades) ? invalid_blades : null))
	

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

/obj/item/rogueweapon/scabbard/sword/noble
	name = "silver-decorated scabbard"
	desc = "A sword's noble scabbard, enamored with elaborate silver decorations. It carries an aristocrat's sword upon a silver platter, and - just like an actual platter - can suffice at riposting an errant blow."
	icon_state = "nscabbard"
	associated_skill = /datum/skill/combat/shields
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK)
	can_parry = TRUE
	wdefense = 4
	max_integrity = 75
	sellprice = 50
	resistance_flags = null

/obj/item/rogueweapon/scabbard/sword/royal
	name = "gold-decorated scabbard"
	desc = "A sword's royal scabbard, enamored with exquisite golden decorations. It pampers a champion's sword in a veil of gilded silk, reluctant to let go."
	icon_state = "rscabbard"
	associated_skill = /datum/skill/combat/shields
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK)
	can_parry = TRUE
	wdefense = 6
	max_integrity = 150
	sellprice = 100
	resistance_flags = null

//

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

/obj/item/rogueweapon/scabbard/sheath/courtphysician
	name = "fancy cane"
	desc = "A decorated cane bearing the visage of a vulture."
	icon_state = "doccanesheath"
	item_state = "doccanesheath"
	valid_blade = /obj/item/rogueweapon/sword/rapier/courtphysician
	sellprice = 45

/obj/item/rogueweapon/scabbard/sheath/courtphysician/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.5,
					"sx" = -6,
					"sy" = -6,
					"nx" = 6,
					"ny" = -5,
					"wx" = -1,
					"wy" = -5,
					"ex" = -1,
					"ey" = -5,
					"nturn" = -45,
					"sturn" = -45,
					"wturn" = -45,
					"eturn" = -45,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = FALSE,
					"southabove" = TRUE,
					"eastabove" = TRUE,
					"westabove" = FALSE
				)
			if("wielded")
				return list(
					"shrink" = 0.5,
					"sx" = 0,
					"sy" = 0,
					"nx" = 0,
					"ny" = 0,
					"wx" = -3,
					"wy" = 0,
					"ex" = 3,
					"ey" = 0,
					"nturn" = -90,
					"sturn" = 0,
					"wturn" = -90,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = FALSE,
					"southabove" = TRUE,
					"eastabove" = TRUE,
					"westabove" = TRUE
				)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/scabbard/sheath/courtphysician/hand
	name = "velvet sister"
	desc = "Sleek, fashionable and deadly. Traits shared by both staff and the one holding it. Never let yourself be outdone, never rely on merely one trick.\
	The rontz embedded in the handle serves as focus for arcyne arts."
	icon = 'icons/roguetown/weapons/special/hand32.dmi'
	icon_state = "staffsheath"
	item_state = "staffsheath"
	valid_blade = /obj/item/rogueweapon/sword/rapier/hand
	sellprice = 100
	cast_time_reduction = null //The component alters this. 

/obj/item/rogueweapon/scabbard/sheath/courtphysician/hand/ComponentInitialize()
	AddComponent(/datum/component/holster/handstaff, valid_blade, null, null, sheathe_time)
	

///////////////////////
//	GREATWEP. STRAPS //
///////////////////////

/obj/item/rogueweapon/scabbard/gwstrap
	name = "greatweapon strap"
	desc = "A buckled sling that can support the weight of weapons too weighty for one's belt. Be mindful, as it takes a couple seconds to properly unfasten-and-refasten the latches."

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

/obj/item/rogueweapon/scabbard/gwstrap/ComponentInitialize()
	AddComponent(/datum/component/holster/gwstrap, FALSE, FALSE, FALSE, sheathe_time)

/obj/item/rogueweapon/scabbard/gwstrap/getonmobprop(tag)
	..()
	var/datum/component/holster/HC = GetComponent(/datum/component/holster)
	if(!HC?.sheathed)
		return
	if(istype(HC.sheathed, /obj/item/rogueweapon/estoc) || istype(HC.sheathed, /obj/item/rogueweapon/greatsword))
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
