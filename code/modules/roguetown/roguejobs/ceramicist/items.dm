
//Not clay but part of pottery/glassblowing.
/obj/item/rogueweapon/blowrod
	force = 10
	possible_item_intents = list(/datum/intent/mace/strike)
	name = "blowing rod"
	desc = "A blowing rod for shaping glass."
	icon_state = "blowJobRod" // sorry not sorry
	icon = 'icons/roguetown/weapons/tools.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.8
	wlength = WLENGTH_SHORT
	slot_flags = ITEM_SLOT_HIP
	associated_skill = null
	smeltresult = /obj/item/ingot/iron

