//HAUBERGEON//
/obj/item/clothing/suit/roguetown/armor/chainmail
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "haubergeon"
	desc = "A maille shirt fashioned from hundreds of interlinked steel rings. This blouse covers all the little nooks-and-crannies that're neglected by a standard cuirass, and - when paired with a gambeson - offers superb protection from most worldly strikes."
	body_parts_covered = COVERAGE_ALL_BUT_HANDLEGS
	icon_state = "haubergeon"
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	blocksound = CHAINHIT
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_MEDIUM

/obj/item/clothing/suit/roguetown/armor/chainmail/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/suit/roguetown/armor/chainmail/iron
	icon_state = "ihaubergeon"
	name = "iron haubergeon"
	desc = "A maille shirt fashioned from hundreds of interlinked iron rings. The humble combination of a haubergeon and gambeson is favored amongst Psydonia's levymen, alongside a sharpened spear and a cooled pint of ale."
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/suit/roguetown/armor/chainmail/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_CHAIN_STEP)

/obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	name = "decrepit haubergeon"
	desc = "Frayed bronze rings and rotting leather, woven together to form a short maille-atekon. There's a breach along the rings, where the leather is wet with blackness: the aftermath of a mortal wound, delivered centuries ago."
	icon_state = "ancientchain"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_DECREPIT
	color = "#bb9696"
	chunkcolor = "#532e25"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	prevent_crits = PREVENT_CRITS_NONE

/obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	name = "ancient haubergeon"
	desc = "Polished gilbranze rings and silk, woven together to form a short maille-atekon. The death of a million brought forth the ascension of Zizo; and if a million more must perish to complete Her works, then let it be done."
	icon_state = "ancientchain"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/suit/roguetown/armor/chainmail/light
	name = "besilked haubergeon"
	desc = "A maille shirt fashioned from hundreds of interlinked steel rings; lighter than its compatriots, yet reinforced with the presence of a besilked underjacket. Though fragile, it is a coveted article of nobility. When worn beneath a silk blouse, it can thwart an unsuspecting assassin's blow."
	armor_class = ARMOR_CLASS_LIGHT //Why the hell didn't I just do this in the first place? This makes a lot more sense, in hindsight.

/obj/item/clothing/suit/roguetown/armor/chainmail/light/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/suit/roguetown/armor/chainmail/light/fencer
	name = "besilked haubergeon"
	max_integrity = ARMOR_INT_CHEST_LIGHT_STEEL //Matching the Fencer Cuirass.

//HAUBERK//

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "hauberk"
	desc = "A maille-aketon of steel, sleeved to cover both the arms and legs. Before Psydonia was blessed with plate armor, these robes of steel cloaked those who swore their oaths to both God and Kingdom, alike."
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	icon_state = "hauberk"
	item_state = "hauberk"
	armor = ARMOR_MAILLE
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	name = "iron hauberk"
	desc = "A maille-aketon of iron, sleeved to cover both the arms and legs. Amongst the levymen, these robes of iron - while heftier than gambesons - are coveted when facing the monsters who claw-and-bite at nite."
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
	chunkcolor = "#532e25"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	prevent_crits = PREVENT_CRITS_NONE

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy
	name = "ancient hauberk"
	desc = "Polished gilbranze rings and silk, woven together to form a sleeved maille-atekon. To bring the lyfeless back from decrepity, to elevate them to heights once thought unsurmountable; that is the will of Zizo, made manifest."
	icon_state = "ancienthauberk"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/suit/roguetown/armor/chainmail/bikini
	name = "chainmail corslet"	// corslet, from the old French 'cors' or bodice, with the diminutive 'let', used to describe lightweight military armor since 1500. Chosen here to replace 'bikini', an extreme anachronism.
	desc = "For the daring, affording maille's protection with light weight."
	icon_state = "chainkini"
	item_state = "chainkini"
	allowed_sex = list(MALE, FEMALE)
	allowed_race = CLOTHED_RACES_TYPES
	body_parts_covered = CHEST|GROIN
	armor_class = ARMOR_CLASS_LIGHT //placed in the medium category to keep it with its parent obj


//HEAVY ARMOR//

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy
	name = "mailled hauberk"
	desc = "A maille-aketon of steel, comfortably fitted beneath a matching cuirass. Best paired with a padded arming jacket and a lovely goblet of wine, sourced straight from the Duke's private reserves."
	slot_flags = ITEM_SLOT_ARMOR
	icon_state = "cuirasshauberk"
	item_state = "cuirasshauberk"
	armor_class = ARMOR_CLASS_HEAVY // Prevents slot-stoackage by those who aren't already specialzed in wearing plate armor.
	max_integrity = ARMOR_INT_CHEST_PLATE_STEELLIGHT // To note, this is about 450 INT, or +150 over regular hauberk and -50 under regular plate.

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy
	name = "iron mailled hauberk"
	desc = "A maille-aketon of iron, snuggly fitted beneath a matching cuirass. Best paired with a gambeson and a mug of chilled ale, or - as is the case with most levymen and adventurers - last nite's rags."
	slot_flags = ITEM_SLOT_ARMOR
	icon_state = "icuirasshauberk"
	item_state = "icuirasshauberk"
	armor_class = ARMOR_CLASS_HEAVY
	max_integrity = ARMOR_INT_CHEST_PLATE_IRONLIGHT // Roughly 325 INT. +150 over regular hauberk, and -50 under regular plate.

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy/heavy
	name = "decrepit hauberk"
	desc = "Frayed bronze rings and rotting leather, woven together to form a sleeved maille-atekon; one that's been uncomfortably tucked beneath a matching cuirass. Such are the last remains of those who've dared to march against the undying legions, be it yils or centuries prior."
	icon_state = "ancientcuirasshauberk"
	item_state = "ancientcuirasshauberk"
	max_integrity = ARMOR_INT_CHEST_PLATE_DECREPITLIGHT // 200 INT.

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/heavy
	name = "ancient hauberk"
	desc = "Polished gilbranze rings and silk, woven together to form a sleeved maille-atekon; one that's been uncomfortably tucked beneath a matching cuirass. It eminates an unfamiliar sensation, rarely seen amongst rot-and-undeath - elegance. In the worlds to come, do you suppose Her death knights would bare such a mantle?"
	icon_state = "ancientcuirasshauberk"
	item_state = "ancientcuirasshauberk"
	max_integrity = ARMOR_INT_CHEST_PLATE_STEELLIGHT

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate
	slot_flags = ITEM_SLOT_ARMOR
	armor_class = ARMOR_CLASS_HEAVY
	armor = ARMOR_CUIRASS
	name = "psydonic hauberk"
	desc = "A beautiful steel cuirass, decorated with blessed silver fluting and worn atop thick chainmaille. While it falters against arrows and bolts, these interlinked layers are superb at warding off the blows of inhumen claws and axes. </br>‎  </br>'..the knowledge of evil, and the burden of carrying Psydonia's hope upon thine shoulders..'"
	icon_state = "ornatehauberk"
	item_state = "ornatehauberk"
	max_integrity = ARMOR_INT_CHEST_PLATE_PSYDON
	smeltresult = /obj/item/ingot/silverblessed

///////// CRAFTING DATUMS FOR MAILLED HAUBERK /////////

/datum/crafting_recipe/roguetown/survival/mailledhauberk
	name = "layer a steel cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass = 1,
	            /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	craftdiff = 0 //Straight-forward. Note that this is a copy of Draganfrukt's helmet-and-hat combination system, which also has the slight caveat..
	req_table = TRUE //..of resetting the durability of both items, when crafted and uncrafted. This check helps to reduce a lot of potential cheese, but should be tweaked later.
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/survival/mailledhauberk/off
	name = "take steel cuirass off the hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass = 1, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy = 1)
	craftdiff = 0
	req_table = TRUE
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/survival/ironmailledhauberk
	name = "layer a iron cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = 1,
	            /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = 1)
	craftdiff = 0
	req_table = TRUE
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/survival/ironmailledhauberk/off
	name = "take iron cuirass off the hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = 1, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy = 1)
	craftdiff = 0
	req_table = TRUE
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/survival/ancientmailledhauberk
	name = "layer an ancient cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/heavy)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/paalloy = 1,
	            /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy = 1)
	craftdiff = 0 //Note that its Decrepit-tier variant is intended to largely be used by mobs and not players; hence, the lack of a crafting recipe.
	req_table = TRUE //If someone wants to add that in post, hwoever, I don't mind. You can easily do so by copy-pasting the format, here.
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/survival/ancientmailledhauberk/off
	name = "take ancient cuirass off the hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/paalloy = 1, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/heavy = 1)
	craftdiff = 0
	req_table = TRUE
	bypass_dupe_test = TRUE

//

//UNIQUE ARMOR//

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/matthios
	name = "gilded hauberk"
	desc = "All that glimmers is gold; yet only shining stars shalt break the mold.."
	color = "#ffc960"

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/matthios/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_COMMIE, "ARMOR")

//

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo
	name = "avantyne hauberk"
	desc = "The rings crackle with unkempt magicka, yearning to enamor the enlightened with avantynic might."
	color = "#c1b18d"
	chunkcolor = "#363030"

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "ARMOR")

//

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/graggar
	name = "vicious hauberk"
	desc = "The blessing of a Martyr is nothing, when put before the Sinistar's rage."
	color = "#ddc0a7"

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/graggar/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "ARMOR", "RENDERED ASUNDER")
