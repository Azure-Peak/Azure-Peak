/obj/item/cooking/pan
	name = "frypan"
	desc = "Two in one: Cook and smash heads."
	icon = 'modular/Neu_Food/icons/cookware/pan.dmi'
	//lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	//righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = TRUE
	experimental_onhip = TRUE
	icon_state = "pan"
	wlength = WLENGTH_SHORT
	sharpness = IS_BLUNT
	//dropshrink = 0.8
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	can_parry = TRUE
	associated_skill = /datum/skill/craft/cooking // This make pan a "viable" weapon for cook with high hit / parry chance. Won't carry them alone ofc.
	swingsound = list('sound/combat/wooshes/blunt/shovel_swing.ogg','sound/combat/wooshes/blunt/shovel_swing2.ogg')
	drop_sound = 'sound/foley/dropsound/shovel_drop.ogg'
	force = 20
	throwforce = 15
	possible_item_intents = list(/datum/intent/mace/strike/pan)
	wdefense = 2
	grid_width = 32
	grid_height = 64
	anvilrepair = /datum/skill/craft/weaponsmithing
	obj_flags = CAN_BE_HIT

/obj/item/cooking/pan/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -9,"sy" = -9,"nx" = 12,"ny" = -9,"wx" = -7,"wy" = -9,"ex" = 6,"ey" = -9,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = -1,"wflip" = -1,"eflip" = 5)
			if("wielded")
				return list("shrink" = 0.5,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/cooking/pan/examine(mob/user)
	. = ..()
	. += span_info("Frying pans can be placed atop a hearth by left-clicking it. Left-click the placed frying pan with an ingredient to begin frying - so long as the hearth is lit.")
	. += span_info("Meats, cackleberries, and sliced vegetables are the ideal choices for frying. Other ingredients and recipes might require the gentle caress of an oven, instead.")

/datum/intent/mace/strike/pan
	hitsound = list('sound/combat/hits/blunt/frying_pan(1).ogg', 'sound/combat/hits/blunt/frying_pan(2).ogg', 'sound/combat/hits/blunt/frying_pan(3).ogg', 'sound/combat/hits/blunt/frying_pan(4).ogg')


/obj/item/cooking/pan/aalloy
	name = "decrepit pan"
	desc = "Frayed bronze, wrought into a handheld griddle. Just a little oil's more than enough to slicken the surprisingly-unmarred surface."
	icon_state = "apan"
	color = "#bb9696"
	sellprice = 25

/obj/item/cooking/pan/bronze
	name = "bronze pan"
	desc = "Psydonia's greatest mystery isn't the meaning of lyfe, but how these pans are able to perfectly fry a nite's meal without needing even a single drop of oil."
	icon_state = "bronzepan"
	throwforce = 30 //We both know why.
	sellprice = 15
	max_integrity = 200
