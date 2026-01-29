/datum/anvil_recipe/armor
	abstract_type = /datum/anvil_recipe/armor
	appro_skill = /datum/skill/craft/armorsmithing
	i_type = "Armor"

///////////////////////////////////////////////////////////
// Material parent classes - same skill level as weapons //
///////////////////////////////////////////////////////////

/datum/anvil_recipe/armor/aalloy
	abstract_type = /datum/anvil_recipe/armor/aalloy
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/armor/paalloy
	abstract_type = /datum/anvil_recipe/armor/paalloy
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/armor/copper
	abstract_type = /datum/anvil_recipe/armor/copper
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/armor/iron
	abstract_type = /datum/anvil_recipe/armor/iron
	craftdiff = SKILL_LEVEL_APPRENTICE

/datum/anvil_recipe/armor/steel
	abstract_type = /datum/anvil_recipe/armor/steel
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/armor/silver
	abstract_type = /datum/anvil_recipe/armor/silver
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/armor/holysteel
	abstract_type = /datum/anvil_recipe/armor/holysteel
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/armor/blessedsilver
	abstract_type = /datum/anvil_recipe/armor/blessedsilver
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/armor/blacksteel
	abstract_type = /datum/anvil_recipe/armor/blacksteel
	craftdiff = SKILL_LEVEL_MASTER

//For the sake of keeping the code modular with the introduction of new metals, each recipe has had it's main resource added to it's datum
//This way, we can avoid having to name things in strange ways and can simply have iron/cuirass, stee/cuirass, blacksteel/cuirass->
//-> and not messy names like ibreastplate and hplate

// SORTING ORDER: HEAD > FACE > NECK > CHEST > HANDS > LEGS > BOOTS

////////////
// COPPER //
////////////

/datum/anvil_recipe/armor/copper/cap
	name = "Lamellar Cap"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/clothing/head/roguetown/helmet/coppercap

/datum/anvil_recipe/armor/copper/mask
	name = "Mask, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/clothing/mask/rogue/facemask/copper

/datum/anvil_recipe/armor/copper/gorget
	name = "Neck Protector, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/clothing/neck/roguetown/gorget/copper

/datum/anvil_recipe/armor/copper/chest
	name = "Heart Protector, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper

/datum/anvil_recipe/armor/copper/bracers
	name = "Bracers, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/clothing/wrists/roguetown/bracers/copper

//////////////
// DECREPIT //
//////////////

/datum/anvil_recipe/armor/aalloy/barbute
	name = "Barbute, Decrepit (+1 Alloy)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/aalloy

/datum/anvil_recipe/armor/aalloy/savoyard
	name = "Helmet, Savoyard, Decrepit (+1 Alloy)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard/aalloy

/datum/anvil_recipe/armor/aalloy/mask
	name = "Mask, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/mask/rogue/facemask/aalloy

/datum/anvil_recipe/armor/aalloy/coif
	name = "Coif, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy

/datum/anvil_recipe/armor/aalloy/gorget
	name = "Gorget, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/neck/roguetown/gorget/aalloy

/datum/anvil_recipe/armor/aalloy/chainmail
	name = "Chainmail, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy

/datum/anvil_recipe/armor/aalloy/hauberk
	name = "Hauberk, Decrepit (+1 Alloy)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy
	additional_items = list(/obj/item/ingot/aalloy)

/datum/anvil_recipe/armor/aalloy/cuirass
	name = "Cuirass, Decrepit (+1 Alloy)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/aalloy

/datum/anvil_recipe/armor/aalloy/halfplate
	name = "Half-Plate, Decrepit (+2 Alloy, +1 Cured Leather)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy,/obj/item/ingot/aalloy,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/aalloy

/datum/anvil_recipe/armor/aalloy/bracers
	name = "Bracers, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/wrists/roguetown/bracers/aalloy

/datum/anvil_recipe/armor/aalloy/chaingaunts
	name = "Gauntlets, Chain, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/gloves/roguetown/chain/aalloy

/datum/anvil_recipe/armor/aalloy/plategaunts
	name = "Gauntlets, Plate, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/gloves/roguetown/plate/aalloy

/datum/anvil_recipe/armor/aalloy/chainkilt
	name = "Kilt, Chain, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy

/datum/anvil_recipe/armor/aalloy/platelegs
	name = "Chausses, Plated, Decrepit (+1 Alloy)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy)
	created_item = /obj/item/clothing/under/roguetown/platelegs/aalloy

/////////////
// ANCIENT //
/////////////

/datum/anvil_recipe/armor/paalloy/barbute
	name = "Helmet, Barbute, Ancient (+1 Alloy)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/paalloy
	additional_items = list(/obj/item/ingot/aalloy)

/datum/anvil_recipe/armor/paalloy/savoyard
	name = "Helmet, Savoyard, Ancient (+1 Purified Alloy)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard/paalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy)

/datum/anvil_recipe/armor/paalloy/mask
	name = "Mask, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/mask/rogue/facemask/steel/paalloy

/datum/anvil_recipe/armor/paalloy/coif
	name = "Coif, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/paalloy

/datum/anvil_recipe/armor/paalloy/gorget
	name = "Gorget, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/neck/roguetown/gorget/paalloy

/datum/anvil_recipe/armor/paalloy/chainmail
	name = "Chainmail, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy

/datum/anvil_recipe/armor/paalloy/hauberk
	name = "Hauberk, Ancient (+1 Purified Alloy)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy)

/datum/anvil_recipe/armor/paalloy/cuirass
	name = "Cuirass, Ancient (+1 Purified Alloy)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/paalloy

/datum/anvil_recipe/armor/paalloy/halfplate
	name = "Half-Plate, Ancient (+2 Purified Alloy, +1 Cured Leather)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy,/obj/item/ingot/purifiedaalloy,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/paalloy

/datum/anvil_recipe/armor/paalloy/bracers
	name = "Bracers, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/wrists/roguetown/bracers/paalloy

/datum/anvil_recipe/armor/paalloy/chaingaunts
	name = "Gauntlets, Chain, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/gloves/roguetown/chain/paalloy

/datum/anvil_recipe/armor/paalloy/plategaunts
	name = "Gauntlets, Plate, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/gloves/roguetown/plate/paalloy

/datum/anvil_recipe/armor/paalloy/chainkilt
	name = "Kilt, Chain, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy

/datum/anvil_recipe/armor/paalloy/platelegs
	name = "Chausses, Plated, Ancient (+1 Purified Alloy)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy)
	created_item = /obj/item/clothing/under/roguetown/platelegs/paalloy

//////////
// IRON //
//////////

/datum/anvil_recipe/armor/iron/skullcap
	name = "Helmet, Skullcap, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/head/roguetown/helmet/skullcap

/datum/anvil_recipe/armor/iron/kettle
	name = "Helmet, Kettle, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/iron

/datum/anvil_recipe/armor/iron/sallet
	name = "Helmet, Sallet, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/iron

/datum/anvil_recipe/armor/iron/sallet/visor
	name = "Helmet, Sallet, Visored, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron

/datum/anvil_recipe/armor/iron/knightarmet
	name = "Helmet, Armet, Knight, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron

/datum/anvil_recipe/armor/iron/knighthelmet
	name = "Helmet, Knight, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/old/iron

/datum/anvil_recipe/armor/iron/bucket
	name = "Helmet, Bucket, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron

/datum/anvil_recipe/armor/iron/helmethorned
	name = "Helmet, Horned, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/head/roguetown/helmet/horned
	craftdiff = 2

/datum/anvil_recipe/armor/iron/mask
	name = "Mask, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/mask/rogue/facemask
	createditem_num = 1

/datum/anvil_recipe/armor/iron/wildguard
	name = "Wild Guard, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/mask/rogue/wildguard
	createditem_num = 1

/datum/anvil_recipe/armor/iron/chaincoif
	name = "Chain Coif, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/iron
	createditem_num = 1

/datum/anvil_recipe/armor/iron/gorget
	name = "Gorget, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/neck/roguetown/gorget
	createditem_num = 1

/datum/anvil_recipe/armor/iron/bevor
	name = "Bevor, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/neck/roguetown/bevor/iron

/datum/anvil_recipe/armor/iron/haubergeon
	name = "Haubergeon, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/iron

/datum/anvil_recipe/armor/iron/hauberk
	name = "Hauberk, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron

/datum/anvil_recipe/armor/iron/breastplate
	name = "Breastplate, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron

/datum/anvil_recipe/armor/iron/studded
	name = "Breastplate, Studded Leather (+ Leather Armor)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/leather)
	created_item = /obj/item/clothing/suit/roguetown/armor/leather/studded

/datum/anvil_recipe/armor/studdedbikini
	name = "Corslet, Studded Leather (+ Leather Corslet)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/leather)
	created_item = /obj/item/clothing/suit/roguetown/armor/leather/studded/bikini

/datum/anvil_recipe/armor/iron/lbrigandine
	name = "Brigandine, Lightweight, Iron (+1 Cloth)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	i_type = "Armor"

/datum/anvil_recipe/armor/iron/wardenbrig
	name = "Brigandine, Lightweight, Forester's (+1 Forester's Armor, +1 Iron, +1 Essence of Wilderness)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/leather/studded/warden, /obj/item/ingot/iron, /obj/item/natural/cured/essence)
	created_item = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden/upgraded
	i_type = "Armor"

/datum/anvil_recipe/armor/iron/halfplate
	name = "Half-Plate, Iron (+2 Iron, +1 Cured Leather)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/iron

/datum/anvil_recipe/armor/iron/fullplate
	name = "Full-Plate, Iron (+3 Iron, +1 Cured Leather)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/iron

/datum/anvil_recipe/armor/iron/jackchain
	name = "Bracers, Jack Chain, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/wrists/roguetown/bracers/jackchain

/datum/anvil_recipe/armor/iron/splintarms
	name = "Bracers, Splinted (+1 leather bracers)" //you modify the bracers to have splints and cover the arm way more
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/clothing/wrists/roguetown/bracers/leather)
	created_item = /obj/item/clothing/wrists/roguetown/splintarms/iron

/datum/anvil_recipe/armor/iron/bracers
	name = "Bracers, Plate, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/wrists/roguetown/bracers/iron
	createditem_num = 1

/datum/anvil_recipe/armor/iron/chainglove
	name = "Gauntlets, Chain, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/gloves/roguetown/chain/iron

/datum/anvil_recipe/armor/iron/plategauntlets
	name = "Gauntlets, Plate, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/gloves/roguetown/plate/iron

/datum/anvil_recipe/armor/iron/chainleg
	name = "Chausses, Chain, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/under/roguetown/chainlegs/iron

/datum/anvil_recipe/armor/iron/chainleg/kilt
	name = "Kilt, Chain, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt

/datum/anvil_recipe/armor/iron/splintlegs
	name = "Chausses, Splinted (+1 leather pants)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/clothing/under/roguetown/trou/leather)//basically you just add a lot of iron bits to the pants
	created_item = /obj/item/clothing/under/roguetown/splintlegs/iron

/datum/anvil_recipe/armor/iron/platelegs
	name = "Chausses, Plate, Iron (+1 Bar)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/under/roguetown/platelegs/iron

/datum/anvil_recipe/armor/iron/boot
	name = "Boots, Plated, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	createditem_num = 1

//This can stay here as is I guess??
/datum/anvil_recipe/armor/helmetgoblin
	name = "Goblin Helmet (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/goblin
	craftdiff = 2

/datum/anvil_recipe/armor/plategoblin
	name = "Goblin Mail (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/goblin
	craftdiff = 2

/datum/anvil_recipe/armor/iron/horseshoes
	name = "Horseshoes, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/shoes/roguetown/horseshoes

///////////
// STEEL //
///////////

/datum/anvil_recipe/armor/steel/helmetnasal
	name = "Helmet, Nasal, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/head/roguetown/helmet

/datum/anvil_recipe/armor/steel/helmetbuc
	name = "Helmet, Bucket, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket

/datum/anvil_recipe/armor/steel/helmetwinged
	name = "Helmet, Winged, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/head/roguetown/helmet/winged

/datum/anvil_recipe/armor/steel/helmetkettle
	name = "Helmet, Kettle, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle

/datum/anvil_recipe/armor/steel/widehelmetkettle
	name = "Helmet, Kettle, Wide, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/wide

/datum/anvil_recipe/armor/steel/slittedkettle
	name = "Helmet, Kettle, Slitted, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle

/datum/anvil_recipe/armor/steel/helmetsall
	name = "Helmet, Sallet, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet

/datum/anvil_recipe/armor/steel/helmetsallv
	name = "Helmet, Sallet, Visored, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored

/datum/anvil_recipe/armor/steel/bascinet
	name = "Helmet, Bascinet, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet

/datum/anvil_recipe/armor/steel/helmetpig
	name = "Helmet, Bascinet, Pigface, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface

/datum/anvil_recipe/armor/steel/helmethounskull
	name = "Helmet, Bascinet, Hounskull, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull

/datum/anvil_recipe/armor/steel/etruscanbascinet
	name = "Helmet, Bascinet, Klappvisier, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan

/datum/anvil_recipe/armor/steel/helmetarmet
	name = "Helmet, Armet, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet

/datum/anvil_recipe/armor/steel/helmetknightarmet//This won't confuse anyone I promise
	name = "Helmet, Armet, Knight, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight

/datum/anvil_recipe/armor/steel/helmetknight
	name = "Helmet, Knight, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/old

/datum/anvil_recipe/armor/steel/savoyard
	name = "Helmet, Savoyard, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard

/datum/anvil_recipe/armor/steel/bogman
	name = "Helmet, Savoyard, Bogman, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard/bogman

/datum/anvil_recipe/armor/steel/barredhelm
	name = "Helmet, Savoyard, Barred, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff

/datum/anvil_recipe/armor/steel/frogmouth
	name = "Helmet, Froggemund, Steel (+2 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth

/datum/anvil_recipe/armor/steel/mask
	name = "Mask, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/mask/rogue/facemask/steel
	createditem_num = 1

/datum/anvil_recipe/armor/steel/chaincoif
	name = "Chain Coif, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/neck/roguetown/chaincoif
	createditem_num = 1

/datum/anvil_recipe/armor/steel/fullchaincoif
	name = "Chain Coif, Full, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/full

/datum/anvil_recipe/armor/steel/chainmantle
	name = "Chain Mantle, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	createditem_num = 1

/datum/anvil_recipe/armor/steel/bevor
	name = "Bevor, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/neck/roguetown/bevor

/datum/anvil_recipe/armor/steel/sgorget
	name = "Gorget, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/neck/roguetown/gorget/steel

/datum/anvil_recipe/armor/iron/cursed_collar
	name = "Cursed Collar"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	created_item = /obj/item/clothing/neck/roguetown/gorget/cursed_collar

/datum/anvil_recipe/armor/steel/haubergeon
	name = "Haubergeon, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail

/datum/anvil_recipe/armor/steel/hauberk
	name = "Hauberk, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk

/datum/anvil_recipe/armor/steel/steel/brigandine
	name = "Brigandine, Full, Steel (+1 Steel, +2 Cloth)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/cloth, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine

/datum/anvil_recipe/armor/steel/coatplates
	name = "Coat Of Plates, Steel (+1 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates

/datum/anvil_recipe/armor/steel/scalemail
	name = "Scalemail, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/scale

/datum/anvil_recipe/armor/steel/cuirass
	name = "Cuirass, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass

/datum/anvil_recipe/armor/steel/lightcuirass
	name = "Cuirass, Fencing, Steel (+1 Steel, +1 Fencing Jacket)" //needs cooperation with a tailor to make
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel, /obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer

/datum/anvil_recipe/armor/steel/cuirass/fluted
	name = "Cuirass, Fluted, Steel (+1 Steel, +1 Iron)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted

/datum/anvil_recipe/armor/steel/halfplate
	name = "Half-Plate, Steel (+2 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate

/datum/anvil_recipe/armor/steel/halfplate/fluted
	name = "Half-Plate, Fluted, Steel (+2 Steel, +1 Iron, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/fluted

/datum/anvil_recipe/armor/steel/fullplate
	name = "Full-Plate, Steel (+3 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full

/datum/anvil_recipe/armor/steel/fullplate/fluted
	name = "Full-Plate, Fluted, Steel (+3 Steel, +1 Iron, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted

/datum/anvil_recipe/armor/steel/chainkini
	name = "Corslet, Chainmail, Steel (+1 Cloth)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/bikini

/datum/anvil_recipe/armor/steel/platebikini
	name = "Corslet, Half-Plate, Steel (+1 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/bikini

/datum/anvil_recipe/armor/steel/fullplatebikini
	name = "Corslet, Full-Plate, Steel (+2 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/bikini

/datum/anvil_recipe/armor/steel/splintarms
	name = "Bracers, Brigandine (+1 Leather Bracers)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/clothing/wrists/roguetown/bracers/leather)
	created_item = /obj/item/clothing/wrists/roguetown/splintarms

/datum/anvil_recipe/armor/steel/platebracer
	name = "Bracers, Plate, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/wrists/roguetown/bracers
	createditem_num = 1

/datum/anvil_recipe/armor/steel/chainglove
	name = "Gauntlets, Chain, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/gloves/roguetown/chain

/datum/anvil_recipe/armor/steel/plateglove
	name = "Gauntlets, Plate, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/gloves/roguetown/plate
	createditem_num = 1

/datum/anvil_recipe/armor/steel/belt
	name = "Belt, Plated, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/storage/belt/rogue/leather/steel

/datum/anvil_recipe/armor/steel/belt/tasset
	name = "Belt, Tasseted, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/storage/belt/rogue/leather/steel/tasset

/datum/anvil_recipe/armor/steel/splintlegs
	name = "Chausses, Brigandine (+1 leather pants)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/clothing/under/roguetown/trou/leather)//basically you just add a lot of iron bits to the pants
	created_item = /obj/item/clothing/under/roguetown/splintlegs

/datum/anvil_recipe/armor/steel/chainleg
	name = "Chausses, Chain, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/under/roguetown/chainlegs

/datum/anvil_recipe/armor/steel/platelegs
	name = "Chausses, Plated, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/under/roguetown/platelegs

/datum/anvil_recipe/armor/steel/chainlegs/kilt
	name = "Kilt, Chain, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt

/datum/anvil_recipe/armor/steel/brayette
	name = "Brayette, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/under/roguetown/brayette

/datum/anvil_recipe/armor/steel/chainskirt
	name = "Skirt, Chain, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/under/roguetown/chainlegs/skirt

/datum/anvil_recipe/armor/steel/plateskirt
	name = "Skirt, Plate, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/under/roguetown/platelegs/skirt

/datum/anvil_recipe/armor/steel/plateboot
	name = "Boots, Plated, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor
	createditem_num = 1

/datum/anvil_recipe/armor/steel/horseshoes
	name = "Horseshoes, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	created_item = /obj/item/clothing/shoes/roguetown/horseshoes/steel

//////////////////
// STEEL - HOLY //
//////////////////

/datum/anvil_recipe/armor/holysteel/astratahelmtemplar
	name = "Helmet, Templar, Astrata (+1 Holy Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/astratan

/datum/anvil_recipe/armor/holysteel/malumhelmtemplar
	name = "Helmet, Templar, Malum (+1 Holy Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/malum

/datum/anvil_recipe/armor/holysteel/necrahelmtemplar
	name = "Helmet, Templar, Necra (+1 Holy Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/necran

/datum/anvil_recipe/armor/holysteel/pestrahelmtemplar
	name = "Helmet, Templar, Pestra (+1 Holy Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/pestran

/datum/anvil_recipe/armor/holysteel/eorahelmtemplar
	name = "Helmet, Templar, Eora (+1 Holy Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/eoran

/datum/anvil_recipe/armor/holysteel/astratahelm
	name = "Helmet, Astrata (+1 Holy Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm

/datum/anvil_recipe/armor/holysteel/abyssorhelm
	name = "Helmet, Abyssor (+1 Holy Steel,+1 Cured Leather)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm

/datum/anvil_recipe/armor/holysteel/necrahelm
	name = "Helmet, Necra (+1 Holy Steel,+1 Cured Leather)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm

/datum/anvil_recipe/armor/holysteel/nochelm
	name = "Helmet, Noc (+1 Holy Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm

/datum/anvil_recipe/armor/holysteel/dendorhelm
	name = "Helmet, Dendor (+1 Holy Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm

/datum/anvil_recipe/armor/holysteel/ravoxhelm
	name = "Helmet, Ravox (+1 Holy Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm

/datum/anvil_recipe/armor/holysteel/xylixhelm
	name = "Helmet, Xylix (+1 Holy Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm

/datum/anvil_recipe/armor/holysteel/eorahelm
	name = "Helmet, Eora (+1 Holy Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/eoran

////////////
// SILVER //
////////////

/datum/anvil_recipe/armor/silver/belt
	name = "Belt, Plated, Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/storage/belt/rogue/leather/plaquesilver

/datum/anvil_recipe/armor/silver/horseshoes
	name = "Horseshoes, Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/clothing/shoes/roguetown/horseshoes/silver


//////////////////////
// SILVER - BLESSED //
//////////////////////

/datum/anvil_recipe/armor/blessedsilver/armetpsy
	name = "Helmet, Armet, Psydonic"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm

/datum/anvil_recipe/armor/blessedsilver/helmsallpsy
	name = "Helmet, Sallet, Psydonic (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psysallet

/datum/anvil_recipe/armor/blessedsilver/helmbucketpsy
	name = "Helmet, Bucket, Psydonic (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psybucket

/datum/anvil_recipe/armor/blessedsilver/helmetabso
	name = "Helmet, Conical, Psydonic (+2 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/absolver

/datum/anvil_recipe/armor/blessedsilver/psychestplate
	name = "Chestplate, Psydonic (+1 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/psydon

/datum/anvil_recipe/armor/blessedsilver/psycuirass
	name = "Cuirass, Psydonic (+2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/psyhalfplate
	name = "Half-Plate, Psydonic (+Psydonic Cuirass, +1 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/psyfullplate
	name = "Full-Plate, Psydonic, Half-Plate Base (+Psydonic Half-Plate, +1 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/psyfullplatealt
	name = "Full-Plate, Psydonic, Hauberk Base (+Psydonic Hauberk, +2 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, /obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate

////////////////////////////////
// SILVER - BLESSED - BULLION //
////////////////////////////////

/datum/anvil_recipe/armor/blessedsilver/armetpsy/inq
	name = "Helmet, Armet, Psydonic"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm

/datum/anvil_recipe/armor/blessedsilver/helmsallpsy/inq
	name = "Helmet, Sallet, Psydonic (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psysallet

/datum/anvil_recipe/armor/blessedsilver/helmbucketpsy/inq
	name = "Helmet, Bucket, Psydonic (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psybucket

/datum/anvil_recipe/armor/blessedsilver/helmetabso/inq
	name = "Helmet, Conical, Psydonic (+2 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	additional_items = list(/obj/item/ingot/silverblessed/bullion, /obj/item/ingot/silverblessed/bullion)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/absolver

/datum/anvil_recipe/armor/blessedsilver/psychestplate/inq
	name = "Chestplate, Psydonic (+1 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/psydon

/datum/anvil_recipe/armor/blessedsilver/psycuirass/inq
	name = "Cuirass, Psydonic (+2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/psyhalfplate/inq
	name = "Half-Plate, Psydonic (+Psydonic Cuirass, +1 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate, /obj/item/ingot/silverblessed/bullion, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/psyfullplate/inq
	name = "Full-Plate, Psydonic (+Psydonic Half-Plate, +1 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate, /obj/item/ingot/silverblessed/bullion, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/psyfullplatealt/inq
	name = "Full-Plate, Psydonic, Hauberked (+Psydonic Hauberk, +2 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, /obj/item/ingot/silverblessed/bullion, /obj/item/ingot/silverblessed/bullion, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate

//////////
// GOLD //
//////////

/datum/anvil_recipe/armor/gold/belt
	name = "Belt, Plated, Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/storage/belt/rogue/leather/plaquegold

/datum/anvil_recipe/armor/gold/mask
	name = "Mask, Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/mask/rogue/facemask/goldmask

/datum/anvil_recipe/armor/gold/horseshoes
	name = "Horseshoes, Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/shoes/roguetown/horseshoes/gold

////////////////
// BLACKSTEEL //
////////////////

/datum/anvil_recipe/armor/blacksteel/modern/armet
	name = "Armet, Blacksteel (+1 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet

/datum/anvil_recipe/armor/blacksteel/cuirass
	name = "Cuirass, Blacksteel (+1 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/blacksteel

/datum/anvil_recipe/armor/blacksteel/halfplatechest
	name = "Half-Plate, Blacksteel (+2 Blacksteel, +1 Cured Hide)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/blacksteel
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/modern/platechest
	name = "Full-Plate, Blacksteel (+3 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel/modern
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/modern/plategloves
	name = "Gauntlets, Plate, Blacksteel"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/gloves/roguetown/blacksteel/modern/plategloves

/datum/anvil_recipe/armor/blacksteel/modern/platelegs
	name = "Chausses, Plate, Blacksteel (+1 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern

/datum/anvil_recipe/armor/blacksteel/modern/plateboots
	name = "Boots, Plate, Blacksteel"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/shoes/roguetown/boots/blacksteel/modern/plateboots

//////////////////////////
// BLACKSTEEL - ANCIENT //
//////////////////////////

/datum/anvil_recipe/armor/blacksteel/bucket
	name = "Helmet, Bucket, Blacksteel, Ancient (+1 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/roguetown/helmet/blacksteel/bucket

/datum/anvil_recipe/armor/blacksteel/platechest
	name = "Full-Plate, Blacksteel, Ancient (+3 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel

/datum/anvil_recipe/armor/blacksteel/plategloves
	name = "Gauntlets, Plate, Blacksteel, Ancient"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/gloves/roguetown/blacksteel/plategloves

/datum/anvil_recipe/armor/blacksteel/platelegs
	name = "Chausses, Plate, Blacksteel, Ancient(+1 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/under/roguetown/platelegs/blacksteel

/datum/anvil_recipe/armor/blacksteel/plateboots
	name = "Boots, Plate, Blacksteel, Ancient"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/shoes/roguetown/boots/blacksteel/plateboots
