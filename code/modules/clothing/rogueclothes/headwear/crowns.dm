/obj/item/clothing/head/roguetown/crown/fakecrown
	name = "fake crown"
	desc = "You shouldn't be seeing this."
	icon_state = "serpcrown"
	no_loot_taint = TRUE

/obj/item/clothing/head/roguetown/crown/surplus
	name = "crown"
	icon_state = "serpcrowno"
	sellprice = 100
	allowed_race = list(/datum/species/goblinp)
	no_loot_taint = TRUE

/obj/item/clothing/head/roguetown/crown/sparrowcrown
	name = "champion's circlet"
	desc = ""
	icon_state = "sparrowcrown"
	//dropshrink = 0
	dynamic_hair_suffix = null
	resistance_flags = FIRE_PROOF | ACID_PROOF
	sellprice = 50
	anvilrepair = /datum/skill/craft/armorsmithing
	no_loot_taint = TRUE

/obj/item/clothing/head/roguetown/nyle
	name = "jewel of nyle"
	icon_state = "nile"
	body_parts_covered = null
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = null
	sellprice = 100
	resistance_flags = FIRE_PROOF
	anvilrepair = /datum/skill/craft/armorsmithing
	no_loot_taint = TRUE

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
	no_loot_taint = TRUE

/obj/item/clothing/head/roguetown/circlet/carvedgem
	name = "generic carved gem circlet"
	desc = "You shouldn't see this."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	smeltresult = null
	salvage_result = null
	sellprice = 0

/obj/item/clothing/head/roguetown/circlet/carvedgem/jade
	name = "jade circlet"
	desc = "An ornate circlet carved out of jade."
	icon_state = "circlet_jade"

/obj/item/clothing/head/roguetown/circlet/carvedgem/amber
	name = "amber circlet"
	desc = "An ornate circlet carved out of amber."
	icon_state = "circlet_amber"

/obj/item/clothing/head/roguetown/circlet/carvedgem/shell
	name = "shell circlet"
	desc = "An ornate circlet carved out of shell."
	icon_state = "circlet_shell"

/obj/item/clothing/head/roguetown/circlet/carvedgem/rose
	name = "rosestone circlet"
	desc = "An ornate circlet carved out of rosestone."
	icon_state = "circlet_rose"

/obj/item/clothing/head/roguetown/circlet/carvedgem/turq
	name = "cerulite circlet"
	desc = "An ornate circlet carved out of cerulite."
	icon_state = "circlet_turq"

/obj/item/clothing/head/roguetown/circlet/carvedgem/onyxa
	name = "onyxa circlet"
	desc = "An ornate circlet carved out of onyxa."
	icon_state = "circlet_onyxa"

/obj/item/clothing/head/roguetown/circlet/carvedgem/coral
	name = "heartstone circlet"
	desc = "An ornate circlet carved out of heartstone."
	icon_state = "circlet_coral"

/obj/item/clothing/head/roguetown/circlet/carvedgem/porcelain
	name = "porcelain circlet"
	desc = "An ornate circlet made out of porcelain."
	icon_state = "circlet_porcelain"

/obj/item/clothing/head/roguetown/circlet/carvedgem/opal
	name = "opal circlet"
	desc = "An ornate circlet carved out of opal."
	icon_state = "circlet_opal"
	alternate_worn_layer = 8.9 //On top of helmet


