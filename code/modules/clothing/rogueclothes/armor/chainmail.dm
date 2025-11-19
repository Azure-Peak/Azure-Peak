//LIGHT ARMOR//
/obj/item/clothing/suit/roguetown/armor/chainmail
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "haubergeon"
	desc = "A steel maille shirt. Arrows and small daggers go right through the gaps in this."
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	icon_state = "haubergeon"
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	blocksound = CHAINHIT
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_LIGHT //Experimental change; leave unlisted for now? Offers a weight-class advantage over the otherwise-superior hauberk. We'll see how it goes.

/obj/item/clothing/suit/roguetown/armor/chainmail/iron
	icon_state = "ihaubergeon"
	name = "iron haubergeon"
	desc = "A chain vest made of heavy iron rings. Better than nothing."
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/suit/roguetown/armor/chainmail/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle)

/obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	name = "decrepit haubergeon"
	desc = "Frayed bronze rings and rotting leather, woven together to form a short maille-atekon. There's a breach along the rings, where the leather is wet with blackness: the aftermath of a mortal wound, delivered centuries ago."
	icon_state = "ancientchain"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_DECREPIT
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	name = "ancient haubergeon"
	desc = "Polished gilbranze rings and silk, woven together to form a short maille-atekon. The death of a million brought forth the ascension of Zizo; and if a million more must perish to complete Her works, then let it be done."
	icon_state = "ancientchain"
	smeltresult = /obj/item/ingot/aaslag

//MEDIUM ARMOR//

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "hauberk"
	desc = "A longer steel maille that protects the legs, still doesn't protect against arrows though."
	body_parts_covered = COVERAGE_FULL
	icon_state = "hauberk"
	item_state = "hauberk"
	armor = ARMOR_MAILLE
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	name = "iron hauberk"
	desc = "A longer iron maille that protects the legs, still doesn't protect against arrows though."
	icon_state = "ihauberk"
	item_state = "ihauberk"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy
	name = "decrepit hauberk"
	desc = "Frayed bronze rings and rotting leather, woven together to form a sleeved maille-atekon. Once, the armored vestments of a paladin: now, the withered veil of Zizo's undying legionnaires."
	icon_state = "ancienthauberk"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_DECREPIT
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy
	name = "ancient hauberk"
	desc = "Polished gilbranze rings and silk, woven together to form a sleeved maille-atekon. To bring the lyfeless back from decrepity, to elevate them to heights once thought unsurmountable; that is the will of Zizo, made manifest."
	icon_state = "ancienthauberk"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate
	slot_flags = ITEM_SLOT_ARMOR
	armor_class = ARMOR_CLASS_HEAVY
	armor = ARMOR_CUIRASS
	name = "psydonic hauberk"
	desc = "A beautiful steel cuirass, decorated with blessed silver fluting and worn atop thick chainmaille. While it falters against arrows and bolts, these interlinked layers are superb at warding off the blows of inhumen claws and axes. </br>'..the knowledge of evil, and the burden of carrying Psydonia's hope upon thine shoulders..' </br>... </br>With some blessed silver and a blacksmith's assistance, I can turn this hauberk into a set of full-plate armor."
	icon_state = "ornatehauberk"
	item_state = "ornatehauberk"
	max_integrity = ARMOR_INT_CHEST_PLATE_PSYDON
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/clothing/suit/roguetown/armor/chainmail/bikini
	name = "chainmail corslet"	// corslet, from the old French 'cors' or bodice, with the diminutive 'let', used to describe lightweight military armor since 1500. Chosen here to replace 'bikini', an extreme anachronism.
	desc = "For the daring, affording maille's protection with light weight."
	icon_state = "chainkini"
	item_state = "chainkini"
	allowed_sex = list(MALE, FEMALE)
	allowed_race = CLOTHED_RACES_TYPES
	body_parts_covered = CHEST|GROIN
	armor_class = ARMOR_CLASS_LIGHT //placed in the medium category to keep it with its parent obj
