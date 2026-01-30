/obj/item/cooking/pan
	name = "frypan"
	desc = "Two in one: Cook and smash heads."
	icon = 'modular/Neu_Food/icons/cookware/pan.dmi'
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
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

/obj/item/cooking/pan/examine(mob/user)
	. = ..()

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
