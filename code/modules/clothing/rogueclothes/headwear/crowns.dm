
/obj/item/clothing/head/roguetown/crown/fakecrown
	name = "fake crown"
	desc = "You shouldn't be seeing this."
	icon_state = "serpcrown"

/obj/item/clothing/head/roguetown/crown/surplus
	name = "crown"
	icon_state = "serpcrowno"
	sellprice = 100
	allowed_race = list(/datum/species/goblinp)

/obj/item/clothing/head/roguetown/crown/sparrowcrown
	name = "champion's circlet"
	desc = ""
	icon_state = "sparrowcrown"
	//dropshrink = 0
	dynamic_hair_suffix = null
	resistance_flags = FIRE_PROOF | ACID_PROOF
	sellprice = 50
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/head/roguetown/nyle
	name = "jewel of nyle"
	icon_state = "nile"
	body_parts_covered = null
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = null
	sellprice = 100
	resistance_flags = FIRE_PROOF
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/head/roguetown/nyle/consortcrown
	name = "gem-encrusted crown"
	icon_state = "consortcrown"
	item_state = "consortcrown"
	sellprice = 100

/obj/item/clothing/head/roguetown/circlet
	name = "golden circlet"
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	icon_state = "circlet"
	item_state = "circlet"
	sellprice = 50
	alternate_worn_layer = 8.9 //On top of helmet

////////////////////////
// Triumph Exclusive! //
////////////////////////

//Purchasable via Triumphs. Blacklisted from the Stockpile and fitted with a reduced saleprice.
/obj/item/clothing/head/roguetown/circlet/triumph
	name = "ornate golden circlet"
	desc = "An opulent crown, and the mantle of lesser nobility. It has been meticulously polished to turn even the slightest glimmer into a blinding glare."
	sellprice = 33
