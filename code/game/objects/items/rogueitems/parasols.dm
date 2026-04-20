/obj/item/rogueweapon/mace/parasol
	force = 6
	force_wielded = 6
	name = "paper parasol"
	desc = "A delicate instrument intended to shield one's delicate head from the rain and sun."
	icon = 'icons/roguetown/items/parasols32.dmi'
	icon_state = "parasol1"
	wbalance = WBALANCE_SWIFT
	wdefense = 1
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = null
	smeltresult = /obj/item/ash
	anvilrepair = /datum/skill/craft/sewing
	max_integrity = 150 // The working man's parasol
	minstr = 1
	resistance_flags = FLAMMABLE
	slot_flags = null
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 64

	var/active_item = FALSE

/obj/item/rogueweapon/mace/parasol/Initialize()
	. = ..()
	icon_state = "parasol[rand(1,6)]"

/obj/item/rogueweapon/mace/parasol/pickup(mob/living/user, slot)
	. = ..()
	active_item = TRUE
	ADD_TRAIT(user, TRAIT_WEATHER_PROTECTED, "[type]")

/obj/item/rogueweapon/mace/parasol/dropped(mob/living/user)
	. = ..()
	if(!active_item)
		return
	active_item = FALSE
	REMOVE_TRAIT(user, TRAIT_WEATHER_PROTECTED, "[type]")

/obj/item/rogueweapon/mace/parasol/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8,"sx" = -6,"sy" = 8,"nx" = 6,"ny" = 9,"wx" = 0,"wy" = 7,"ex" = -1,"ey" = 9,"northabove" = 1,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/mace/parasol/noble
	name = "fine parasol"
	desc = "A delicate instrument intended to shield one's delicate head from the rain and sun. This one is a beautiful luxurious white and gold, with fringes."
	icon = 'icons/roguetown/items/parasols64.dmi'
	icon_state = "parasol1"
	max_integrity = 75 // Fashion over function
	sellprice = 45 // Takes master sewing and silk to create
	inhand_x_dimension = 64
	inhand_y_dimension = 64

/obj/item/rogueweapon/mace/parasol/noble/Initialize()
	. = ..()
	icon_state = "parasol[rand(1,2)]"

/obj/item/rogueweapon/mace/parasol/noble/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 8,"nx" = 6,"ny" = 9,"wx" = 0,"wy" = 7,"ex" = -1,"ey" = 9,"northabove" = 1,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
