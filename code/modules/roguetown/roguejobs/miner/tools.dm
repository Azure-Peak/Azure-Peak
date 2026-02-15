/obj/item/rogueweapon/pick
	force = 17
	force_wielded = 21
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	name = "iron pick"
	desc = "This tool is essential to mine in the dark depths."
	icon_state = "pick"
	icon = 'icons/roguetown/weapons/tools.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.8
	wlength = WLENGTH_NORMAL
	max_integrity = 400
	slot_flags = ITEM_SLOT_HIP
	toolspeed = 1
	associated_skill = /datum/skill/labor/mining
	smeltresult = /obj/item/ingot/iron
	grid_width = 64
	grid_height = 64

/obj/item/rogueweapon/pick/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -11,"sy" = -8,"nx" = 12,"ny" = -8,"wx" = -5,"wy" = -8,"ex" = 6,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -4,"nx" = -5,"ny" = -4,"wx" = -5,"wy" = -3,"ex" = 7,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -45,"sturn" = 45,"wturn" = -45,"eturn" = 45,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/pick/steel
	name = "steel pick"
	desc = "With a reinforced handle and sturdy shaft, this is a superior tool for delving in the darkness."
	force = 21
	force_wielded = 28
	icon_state = "steelpick"
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 600
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/pick/bronze
	name = "dolabra"
	desc = "A so-called 'legionnaire's tool'; antiquated, but nevertheless beloved by many for its verastility. It offers an answer for labors both above-and-below, courtesy of its bronze axhead-and-picktip."
	force = 20
	force_wielded = 25
	icon_state = "bronzepick"
	possible_item_intents = list(/datum/intent/pick/bad, /datum/intent/axe/cut, /datum/intent/mace/strike, /datum/intent/till)
	gripped_intents = list(/datum/intent/pick, /datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/mace/strike)
	max_integrity = 500
	max_blade_int = 225
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/pick/blacksteel
	name = "blacksteel pick"
	desc = "Glimmering with silvered blackness, this is a pretigious tool for miners delving into the darkness."
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick/good)
	force = 25
	force_wielded = 32
	icon_state = "blacksteelpick1"
	item_state = "blacksteelpick1"
	max_integrity = 800
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/pick/stone
	name = "stone pick"
	desc = "Stone versus sharp stone, who wins?"
	force = 12
	force_wielded = 17
	icon_state = "stonepick"
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 250
	smeltresult = null

/obj/item/rogueweapon/pick/aalloy
	name = "decrepit pick"
	desc = "A chisel of wrought bronze, which once labored to gather the ores necessary for an ancient alloy; such was lost in the aftermath of Her ascension."
	force = 12
	force_wielded = 17
	icon_state = "apick"
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 150
	smeltresult = /obj/item/ingot/aaslag
	color = "#bb9696"
	sellprice = 15

/obj/item/rogueweapon/pick/paalloy
	name = "ancient pick"
	desc = "A chisel of polished gilbranze, unfettered in its pursuit of piercing the pebbled paunch of Psydonia. Don't dig too deep, now."
	force = 18
	force_wielded = 23
	icon_state = "apick"
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 550
	smeltresult = /obj/item/ingot/aaslag
	sellprice = 15

/obj/item/rogueweapon/pick/copper
	name = "copper pick"
	desc = "A copper pick, slightly better than a stone pick."
	force = 15
	force_wielded = 19
	icon_state = "cpick"
	max_integrity = 325
	smeltresult = /obj/item/ingot/copper
