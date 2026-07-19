//LIGHT ARMOR//
/obj/item/clothing/suit/roguetown/armor/chainmail/light
	name = "haubyrnie"
	desc = "A sleeveless maille shirt, fashioned from dozens of interlinked steel rings. It's light enough to comfortably tuck underneath a \
	blouse, yet tough enough to thwart the razor-sharp edges of unwelcomed company. For the discerning nobleman."
	icon_state = "haubyrnie"
	max_integrity = ARMOR_INT_CHEST_LIGHT_STEEL
	armor_class = ARMOR_CLASS_LIGHT
	body_parts_covered = CHEST | VITALS
	flags_inv = HIDEBOOB //Let it hang, sire.
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE

/obj/item/clothing/suit/roguetown/armor/chainmail/light/ComponentInitialize()
	..()
	AddComponent(/datum/component/adjustable_clothing, CHEST, null, null, 'sound/foley/equip/equip_armor_chain.ogg', null, UPD_CHEST)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_ARCYNE)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_CIVILIZEDBARBARIAN)

/obj/item/clothing/suit/roguetown/armor/chainmail/light/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("RMB to adjust the haubyrnie's coverage; it can either cover the entire torso, or be tightened up to just cover the chest.")

/obj/item/clothing/suit/roguetown/armor/chainmail/light/iron
	name = "iron haubyrnie"
	desc = "A sleeveless maille shirt, fashioned from dozens of interlinked iron rings. It's light enough to comfortably tuck underneath a \
	blouse, yet tough enough to thwart the razor-sharp edges of unwelcomed company. For the discerning peasant."
	icon_state = "ihaubyrnie"
	max_integrity = ARMOR_INT_CHEST_LIGHT_IRON
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/suit/roguetown/armor/chainmail/light/bronze
	name = "bronze haubyrnie"
	desc = "A sleeveless maille shirt, fashioned from dozens of interlinked bronze rings. It's light enough to comfortably tuck underneath a \
	blouse, yet tough enough to thwart the razor-sharp edges of unwelcomed company. For the discerning traveler - ideally, from an antique land."
	icon_state = "bhaubyrnie"
	max_integrity = ARMOR_INT_CHEST_LIGHT_IRON - 30
	smeltresult = /obj/item/ingot/bronze
	armor = ARMOR_BRONZE

//MEDIUM ARMOR - HAUBERGEON//
/obj/item/clothing/suit/roguetown/armor/chainmail
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "haubergeon"
	desc = "A maille shirt fashioned from hundreds of interlinked steel rings. This blouse covers all the little nooks-and-crannies \
	that're neglected by a standard cuirass, and - when paired with a gambeson - offers superb protection from most worldly strikes."
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
	material_category = ARMOR_MAT_CHAINMAIL

/obj/item/clothing/suit/roguetown/armor/chainmail/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/suit/roguetown/armor/chainmail/iron
	icon_state = "ihaubergeon"
	name = "iron haubergeon"
	desc = "A maille shirt fashioned from hundreds of interlinked iron rings. The humble combination of a haubergeon and gambeson \
	is favored amongst Psydonia's levymen, alongside a sharpened spear and a cooled pint of ale."
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/suit/roguetown/armor/chainmail/bronze
	icon_state = "bhaubergeon"
	name = "bronze haubergeon"
	desc = "A maille shirt fashioned from hundreds of interlinked bronze rings. The value of flexible protection, especially in \
	the centuries before plate, made any form of chainmail a rather valuable commodity; enough-so that it was worth its own weight \
	in gold."
	max_integrity = ARMOR_INT_CHEST_MEDIUM_BRONZE
	smeltresult = /obj/item/ingot/bronze

/obj/item/clothing/suit/roguetown/armor/chainmail/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_CHAIN_STEP)

/obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	name = "decrepit haubergeon"
	desc = "Frayed bronze rings and rotting leather, woven together to form a short maille-atekon. There's a breach along the rings, \
	where the leather is wet with blackness: the aftermath of a mortal wound, delivered centuries ago."
	icon_state = "ancientchain"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_DECREPIT
	color = "#bb9696"
	chunkcolor = "#532e25"
	material_category = ARMOR_MAT_CHAINMAIL
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	name = "ancient haubergeon"
	desc = "Polished gilbranze rings and silk, woven together to form a short maille-atekon. The death of a million brought forth the \
	ascension of Zizo; and if a million more must perish to complete Her works, then let it be done."
	icon_state = "ancientchain"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/suit/roguetown/armor/chainmail/besilked
	name = "besilked haubergeon"
	desc = "A maille shirt fashioned from hundreds of interlinked steel rings; lighter than its compatriots, yet reinforced with the \
	presence of a besilked underjacket. Though fragile, it is a coveted article of nobility. When worn beneath a silk blouse, it can \
	thwart an unsuspecting assassin's blow."
	armor_class = ARMOR_CLASS_LIGHT

/obj/item/clothing/suit/roguetown/armor/chainmail/besilked/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/suit/roguetown/armor/chainmail/besilked/fencer
	name = "besilked haubergeon"
	max_integrity = ARMOR_INT_CHEST_LIGHT_STEEL //Matching the Fencer Cuirass.

//MEDIUM ARMOR - HAUBERK//
/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "hauberk"
	desc = "A maille-aketon of steel, sleeved to cover both the arms and legs. Before Psydonia was blessed with plate armor, these \
	robes of steel cloaked those who swore their oaths to both God and Kingdom, alike."
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	icon_state = "hauberk"
	item_state = "hauberk"
	armor = ARMOR_MAILLE
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	name = "iron hauberk"
	desc = "A maille-aketon of iron, sleeved to cover both the arms and legs. Amongst the levymen, these robes of iron - while heftier \
	than gambesons - are coveted when facing the monsters who claw-and-bite at nite."
	icon_state = "ihauberk"
	item_state = "ihauberk"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze
	name = "bronze hauberk"
	desc = "A maille-aketon of bronze, sleeved to cover both the arms and legs. In antiquity, such an armored garment was seen as second-to-none \
	in every facet; light enough to leave a well-trained warrior unfettered, yet still capable of turning away both arrow-and-blade."
	icon_state = "bhauberk"
	item_state = "bhauberk"
	smeltresult = /obj/item/ingot/bronze
	max_integrity = ARMOR_INT_CHEST_MEDIUM_BRONZE

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy
	name = "decrepit hauberk"
	desc = "Frayed bronze rings and rotting leather, woven together to form a sleeved maille-atekon. Once, the armored vestments of a \
	paladin: now, the withered veil of Zizo's undying legionnaires."
	icon_state = "ancienthauberk"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_DECREPIT
	color = "#bb9696"
	chunkcolor = "#532e25"
	material_category = ARMOR_MAT_CHAINMAIL
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy
	name = "ancient hauberk"
	desc = "Polished gilbranze rings and silk, woven together to form a sleeved maille-atekon. To bring the lyfeless back from decrepity, \
	to elevate them to heights once thought unsurmountable; that is the will of Zizo, made manifest."
	icon_state = "ancienthauberk"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/suit/roguetown/armor/chainmail/bikini
	name = "chainmail corslet"	// corslet, from the old French 'cors' or bodice, with the diminutive 'let', used to describe lightweight military armor since 1500. Chosen here to replace 'bikini', an extreme anachronism.
	desc = "For the daring, affording maille's protection with light weight."
	icon_state = "chainkini"
	item_state = "chainkini"
	body_parts_covered = CHEST|GROIN
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	armor_class = ARMOR_CLASS_LIGHT //placed in the medium category to keep it with its parent obj

//HEAVY ARMOR//
/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy
	name = "plate-and-maille"
	desc = "A maille-aketon of steel, comfortably fitted beneath a matching cuirass. Best paired with a padded arming jacket \
	and a lovely goblet of wine, sourced straight from the Duke's private reserves."
	slot_flags = ITEM_SLOT_ARMOR
	icon_state = "cuirasshauberk"
	item_state = "cuirasshauberk"
	armor_class = ARMOR_CLASS_HEAVY // Prevents slot-stoackage by those who aren't already specialzed in wearing plate armor.
	max_integrity = ARMOR_INT_CHEST_PLATE_STEELLIGHT // To note, this is about 450 INT, or +150 over regular hauberk and -50 under regular plate.

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy
	name = "iron plate-and-maille"
	desc = "A maille-aketon of iron, snuggly fitted beneath a matching cuirass. Best paired with a gambeson and a mug of chilled \
	ale, or - as is the case with most levymen and adventurers - last nite's rags."
	slot_flags = ITEM_SLOT_ARMOR
	icon_state = "icuirasshauberk"
	item_state = "icuirasshauberk"
	armor_class = ARMOR_CLASS_HEAVY
	max_integrity = ARMOR_INT_CHEST_PLATE_IRONLIGHT // Roughly 325 INT. +150 over regular hauberk, and -50 under regular plate.

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy/heavy
	name = "decrepit plate-and-maille"
	desc = "Frayed bronze rings and rotting leather, woven together to form a sleeved maille-atekon; one that's been uncomfortably \
	tucked beneath a matching cuirass. Such are the last remains of those who've dared to march against the undying legions, be it \
	yils or centuries prior."
	icon_state = "ancientcuirasshauberk"
	item_state = "ancientcuirasshauberk"
	max_integrity = ARMOR_INT_CHEST_PLATE_DECREPITLIGHT // 200 INT.

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/heavy
	name = "ancient plate-and-maille"
	desc = "Polished gilbranze rings and silk, woven together to form a sleeved maille-atekon; one that's been uncomfortably tucked \
	beneath a matching cuirass. It eminates an unfamiliar sensation, rarely seen amongst rot-and-undeath - elegance. In the worlds to \
	come, do you suppose Her death knights would bare such a mantle?"
	icon_state = "ancientcuirasshauberk"
	item_state = "ancientcuirasshauberk"
	max_integrity = ARMOR_INT_CHEST_PLATE_STEELLIGHT

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted
	slot_flags = ITEM_SLOT_ARMOR
	armor_class = ARMOR_CLASS_HEAVY
	armor = ARMOR_PLATE
	name = "fluted plate-and-maille"
	desc = "A beautiful steel cuirass, decorated with fluting and worn atop thick chainmaille. While it falters against \
	arrows and bolts, these interlinked layers are superb at warding off the blows of swords and axes."
	icon_state = "ornatehauberk"
	item_state = "ornatehauberk"
	max_integrity = ARMOR_INT_CHEST_PLATE_STEELLIGHT

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate
	slot_flags = ITEM_SLOT_ARMOR
	armor_class = ARMOR_CLASS_HEAVY
	armor = ARMOR_PLATE
	name = "psydonic plate-and-maille"
	desc = "A beautiful steel cuirass, decorated with blessed silver fluting and worn atop thick chainmaille. While it falters against \
	arrows and bolts, these interlinked layers are superb at warding off the blows of inhumen claws and axes. </br>‎  </br>'..the \
	knowledge of evil, and the burden of carrying Psydonia's hope upon thine shoulders..'"
	icon_state = "ornatehauberk"
	item_state = "ornatehauberk"
	max_integrity = ARMOR_INT_CHEST_PLATE_PSYDON + 50
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("With more blessed silver and an armorsmith's hammer, this armor can be further upgraded.")
	. += span_info("If a character has the 'Maille Training' trait and has Psydon as their selected patron, they can comfortably wear Psydonic plate armor without suffering any downsides.")

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/decorated
	name = "decorated plate-and-maille"
	desc = "A maille-aketon of steel, comfortably fitted beneath a decorated cuirass. Best paired with a gilded dress shirt \
	and a tankard of Valmora Blue, chilled atop the rocks of a conquered fief."
	slot_flags = ITEM_SLOT_ARMOR
	icon_state = "gildedhauberk"
	item_state = "gildedhauberk"
	armor_class = ARMOR_CLASS_HEAVY
	max_integrity = ARMOR_INT_CHEST_PLATE_STEELLIGHT
	smeltresult = /obj/item/ingot/gold

///////// CRAFTING DATUMS FOR MAILLED CUIRASS /////////

/datum/crafting_recipe/roguetown/survival/mailledhauberk
	name = "layer a steel cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass = 1,
	            /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	craftdiff = 0 //Straight-forward. Note that this is a copy of Draganfrukt's helmet-and-hat combination system, which also has the slight caveat..
	req_table = TRUE //..of resetting the durability of both items, when crafted and uncrafted. This check helps to reduce a lot of potential cheese, but should be tweaked later.
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/survival/ironmailledhauberk
	name = "layer a iron cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = 1,
	            /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = 1)
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

/datum/crafting_recipe/roguetown/survival/flutedmailledhauberk
	name = "layer a fluted cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted = 1,
	            /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	craftdiff = 0 //Note that its Decrepit-tier variant is intended to largely be used by mobs and not players; hence, the lack of a crafting recipe.
	req_table = TRUE //If someone wants to add that in post, hwoever, I don't mind. You can easily do so by copy-pasting the format, here.
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/survival/ornatemailledhauberk
	name = "layer a psydonic cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate = 1,
	            /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	craftdiff = 0 //Note that its Decrepit-tier variant is intended to largely be used by mobs and not players; hence, the lack of a crafting recipe.
	req_table = TRUE //If someone wants to add that in post, hwoever, I don't mind. You can easily do so by copy-pasting the format, here.
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/survival/decoratedmailledhauberk
	name = "layer a decorated cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/decorated)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/decorated = 1,
	            /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	craftdiff = 0 //Note that its Decrepit-tier variant is intended to largely be used by mobs and not players; hence, the lack of a crafting recipe.
	req_table = TRUE //If someone wants to add that in post, hwoever, I don't mind. You can easily do so by copy-pasting the format, here.
	bypass_dupe_test = TRUE

//

//UNIQUE ARMOR//

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/matthios
	name = "gilded hauberk"
	desc = "All that glimmers is gold; yet only shining stars shalt break the mold.."
	icon_state = "matthioshauberk"
	item_state = "matthioshauberk"
	smeltresult = /obj/item/ingot/component/matthios
	unenchantable = TRUE

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/matthios/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_FREEMAN, "ARMOR")
	/*add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = "#fff385", "alpha" = 120, "size" = 1)) //IS THIS TRVE?
*/ // Combine with #ffc960 to make an easier, do-it-yourself version of Gilded items without the need for exotic sprites.

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_ARMOR)

//

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo
	name = "avantyne hauberk"
	desc = "The rings crackle softly with avantynic power, yet this lighter weave can still be taken off without being lost to the rite."
	icon_state = "zizohauberk"
	item_state = "zizohauberk"
	chunkcolor = "#363030"
	material_category = ARMOR_MAT_CHAINMAIL
	smeltresult = /obj/item/ingot/component/zizo
	unenchantable = TRUE

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "ARMOR")
	/*add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = "#5f1515", "alpha" = 120, "size" = 1)) //Cursed look.
*/ // Combine with #c1b18d to make an easier, do-it-yourself version of Avantyne items without the need for exotic sprites.

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo/heavy
	name = "fused avantyne hauberk"
	desc = "The rings crackle softly with avantynic power, yet its fused firmly lyke a second skin. There is no going back, there is only forward in her name."

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo/heavy/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo/heavy/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

//

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/graggar
	name = "vicious hauberk"
	desc = "The blessing of a Martyr is nothing, when put before the Sinistar's rage."
	icon_state = "graggarhauberk"
	item_state = "graggarhauberk"
	smeltresult = /obj/item/ingot/component/graggar
	unenchantable = TRUE

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/graggar/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "ARMOR", "RENDERED ASUNDER")
	/*add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = "#1a146e", "alpha" = 120, "size" = 1)) //Cursed look.
*/ // Combine with #ddc0a7 to make an easier, do-it-yourself version of Vicious items without the need for exotic sprites.

//
