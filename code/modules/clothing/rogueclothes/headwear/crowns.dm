
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

////////////////////////
// Triumph Exclusive! //
////////////////////////

//Purchasable via Triumphs. Blacklisted from the Stockpile and fitted with a reduced saleprice.
/obj/item/clothing/head/roguetown/circlet/triumph
	name = "ornate golden circlet"
	desc = "An opulent crown, and the mantle of lesser nobility. It has been meticulously polished to turn even the slightest glimmer into a blinding glare."
	sellprice = 33

////////////
// Carved //
////////////

/obj/item/clothing/head/roguetown/circlet/carvedgem
	name = "generic carved gem circlet"
	desc = "You shouldn't see this."
	smeltresult = null
	salvage_result = null

/obj/item/clothing/head/roguetown/circlet/carvedgem/jade
	name = "jade circlet"
	desc = "An ornate circlet carved out of jade."
	icon_state = "circlet_jade"
	sellprice = 65

/obj/item/clothing/head/roguetown/circlet/carvedgem/amber
	name = "amber circlet"
	desc = "An ornate circlet carved out of amber."
	icon_state = "circlet_amber"
	sellprice = 65

/obj/item/clothing/head/roguetown/circlet/carvedgem/shell
	name = "shell circlet"
	desc = "An ornate circlet carved out of shell."
	icon_state = "circlet_shell"
	sellprice = 25

/obj/item/clothing/head/roguetown/circlet/carvedgem/rose
	name = "rosestone circlet"
	desc = "An ornate circlet carved out of rosestone."
	icon_state = "circlet_rose"
	sellprice = 30

/obj/item/clothing/head/roguetown/circlet/carvedgem/turq
	name = "cerulite circlet"
	desc = "An ornate circlet carved out of cerulite."
	icon_state = "circlet_turq"
	sellprice = 90

/obj/item/clothing/head/roguetown/circlet/carvedgem/onyxa
	name = "onyxa circlet"
	desc = "An ornate circlet carved out of onyxa."
	icon_state = "circlet_onyxa"
	sellprice = 45

/obj/item/clothing/head/roguetown/circlet/carvedgem/coral
	name = "heartstone circlet"
	desc = "An ornate circlet carved out of heartstone."
	icon_state = "circlet_coral"
	sellprice = 75

/obj/item/clothing/head/roguetown/circlet/carvedgem/opal
	name = "opal circlet"
	desc = "An ornate circlet carved out of opal."
	icon_state = "circlet_opal"
	sellprice = 95
	alternate_worn_layer = 8.9 //On top of helmet


