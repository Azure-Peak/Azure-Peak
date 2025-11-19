/obj/item/clothing/under/roguetown/chainlegs
	name = "steel chain chausses"
	desc = "Chain leggings composed of interlinked metal rings."
	gender = PLURAL
	icon_state = "chain_legs"
	item_state = "chain_legs"
	sewrepair = FALSE
	armor = ARMOR_MAILLE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	blocksound = CHAINHIT
	max_integrity = ARMOR_INT_LEG_STEEL_CHAIN
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	resistance_flags = FIRE_PROOF
	armor_class = ARMOR_CLASS_MEDIUM

/obj/item/clothing/under/roguetown/chainlegs/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle)

/obj/item/clothing/under/roguetown/splintlegs
	name = "brigandine chausses"
	desc = "Splint mail and brigandine chausses, designed to protect the legs while still providing almost complete free range of movement."
	icon_state = "splintlegs"
	item_state = "splintlegs"
	max_integrity = ARMOR_INT_LEG_BRIGANDINE
	armor = ARMOR_LEATHER_STUDDED
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	blocksound = SOFTHIT
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	armor_class = ARMOR_CLASS_LIGHT//Steel version of splint leggings
	w_class = WEIGHT_CLASS_NORMAL
	//resistance_flags = FIRE_PROOF // these ones should be burning since is cloth + metal
	sewrepair = FALSE
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/under/roguetown/splintlegs/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_COAT_STEP)

/obj/item/clothing/under/roguetown/splintlegs/iron
	name = "splinted leggings"
	desc = "A pair of leather pants backed with iron splints, offering superior protection while remaining lightweight."
	icon_state = "ironsplintlegs"
	item_state = "ironsplintlegs"
	max_integrity = ARMOR_INT_LEG_IRON_CHAIN
	armor = ARMOR_LEATHER_STUDDED
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	blocksound = SOFTHIT
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	armor_class = ARMOR_CLASS_LIGHT//splint leggings
	w_class = WEIGHT_CLASS_NORMAL
	//resistance_flags = FIRE_PROOF // these ones should be burning since is cloth + metal
	sewrepair = FALSE
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/under/roguetown/brayette
	name = "brayette"
	desc = "Maille groin protection ideal for answering Dendor's call without removing your plate armor."
	gender = PLURAL
	icon_state = "chain_bootyshorts"
	item_state = "chain_bootyshorts"
	sewrepair = FALSE
	armor = ARMOR_MAILLE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	body_parts_covered = GROIN
	blocksound = CHAINHIT
	max_integrity = ARMOR_INT_LEG_STEEL_CHAIN
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	resistance_flags = FIRE_PROOF
	armor_class = ARMOR_CLASS_LIGHT

/obj/item/clothing/under/roguetown/chainlegs/iron
	name = "iron chain chausses"
	icon_state = "ichain_legs"
	max_integrity = ARMOR_INT_LEG_IRON_CHAIN
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/under/roguetown/chainlegs/skirt
	name = "steel chain skirt"
	desc = "A knee-length maille skirt, warding cuts against the thighs without slowing the feet."
	icon_state = "chain_skirt"
	item_state = "chain_skirt"
	body_parts_covered = GROIN
	armor_class = ARMOR_CLASS_LIGHT

/obj/item/clothing/under/roguetown/chainlegs/kilt
	name = "steel chain kilt"
	desc = "Interlinked metal rings that drape down all the way to the ankles."
	icon_state = "chainkilt"
	item_state = "chainkilt"
	sleevetype = "chainkilt"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	alternate_worn_layer = (SHIRT_LAYER)

/obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	name = "decrepit chain kilt"
	desc = "Frayed bronze rings, linked together with bindings of rotting leather to form a waist's drape. The maille jingles with every step, singing the hymn to a cadence once savored by marching legionnaires."
	icon_state = "achainkilt"
	sleevetype = "achainkilt"
	max_integrity = ARMOR_INT_LEG_DECREPIT_CHAIN
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy
	name = "ancient chain kilt"
	desc = "Polished gilbranze rings, linked together with bindings of silk to form a waist's vestment. These undying legionnaires once marched for Vheslyn, and again for Zizo; but now, they are utterly beholden to the whims of their resurrector."
	icon_state = "achainkilt"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/under/roguetown/chainlegs/iron/kilt
	name = "iron chain kilt"
	desc = "Interlinked metal rings that drape down all the way to the ankles."
	icon_state = "ichainkilt"
	item_state = "ichainkilt"
	sleevetype = "ichainkilt"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	alternate_worn_layer = (SHIRT_LAYER)

/obj/item/clothing/under/roguetown/chainlegs/captain
	name = "captain's chausses"
	desc = "Cuisses made of plated steel, offering additional protection against blunt force. These are specially fitted for the captain."
	icon_state = "capplateleg"
	item_state = "capplateleg"
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
