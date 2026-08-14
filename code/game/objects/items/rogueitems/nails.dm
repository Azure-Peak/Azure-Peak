/////////////
//  Nails  //
////////////

/obj/item/construction/nail
	name = "nail"
	desc = "A sturdy rivet, poundable into wood to form a bond stronger than the love of a kingdom's arranged marriage."
	icon = 'icons/roguetown/items/crafting.dmi'
	icon_state = "nails1"
	grid_width = 32
	grid_height = 32
	attacked_sound = 'sound/foley/coinphy (1).ogg'
	drop_sound = 'sound/foley/coinphy (1).ogg'
	possible_item_intents = list(/datum/intent/use)
	force = 1
	throwforce = 0
	dropshrink = 0.8
	obj_flags = null
	resistance_flags = FIRE_PROOF
	slot_flags = null
	max_integrity = 20
	w_class = WEIGHT_CLASS_TINY
	sellprice = 0
	slot_flags = ITEM_SLOT_MOUTH

