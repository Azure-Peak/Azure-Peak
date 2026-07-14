/datum/anvil_recipe/armor
	abstract_type = /datum/anvil_recipe/armor
	appro_skill = /datum/skill/craft/armorsmithing
	i_type = "Armor"

// Material parent classes - same skill level as weapons
/datum/anvil_recipe/armor/aalloy
	abstract_type = /datum/anvil_recipe/armor/aalloy
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/armor/paalloy
	abstract_type = /datum/anvil_recipe/armor/paalloy
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/armor/copper
	abstract_type = /datum/anvil_recipe/armor/copper
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/armor/bronze
	abstract_type = /datum/anvil_recipe/armor/bronze
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/armor/iron
	abstract_type = /datum/anvil_recipe/armor/iron
	craftdiff = SKILL_LEVEL_APPRENTICE

/datum/anvil_recipe/armor/steel
	abstract_type = /datum/anvil_recipe/armor/steel
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/armor/decorated
	abstract_type = /datum/anvil_recipe/armor/decorated
	craftdiff = SKILL_LEVEL_EXPERT

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

/datum/anvil_recipe/armor/avantyne
	abstract_type = /datum/anvil_recipe/weapons/avantyne
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/armor/gold
	abstract_type = /datum/anvil_recipe/armor/gold
	craftdiff = SKILL_LEVEL_LEGENDARY

//For the sake of keeping the code modular with the introduction of new metals, each recipe has had it's main resource added to it's datum
//This way, we can avoid having to name things in strange ways and can simply have iron/cuirass, stee/cuirass, blacksteel/cuirass->
//-> and not messy names like ibreastplate and hplate


// COPPER

/datum/anvil_recipe/armor/copper/mask
	name = "Mask, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/clothing/mask/rogue/facemask/copper
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/copper/bracers
	name = "Bracers, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/clothing/wrists/roguetown/bracers/copper
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/copper/cap
	name = "Helmet, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/clothing/head/roguetown/helmet/coppercap
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/copper/scalemail
	name = "Lamellar, Copper (+1 Copper)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/scale/copper
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/copper/gorget
	name = "Neck Protector, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/clothing/neck/roguetown/gorget/copper
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/copper/boots
	name = "Lamellar Boots, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/clothing/shoes/roguetown/boots/maille/copper
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/copper/chest
	name = "Heart Protector, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper
	display_category = ITEM_CAT_ARMOR_CHESTPIECES


// DECREPIT/ANCIENT ALLOY

/datum/anvil_recipe/armor/aalloy/barbute
	name = "Barbute, Decrepit (+1 Alloy)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/aalloy
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/paalloy/barbute
	name = "Barbute, Ancient (+1 Purified Alloy)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/paalloy
	display_category = ITEM_CAT_ARMOR_HELMETS
	additional_items = list(/obj/item/ingot/purifiedaalloy)

/datum/anvil_recipe/armor/aalloy/savoyard
	name = "Savoyard, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard/aalloy
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/aalloy/bascinet
	name = "Bascinet, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/aalloy
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/paalloy/savoyard
	name = "Savoyard, Ancient (+1 Purified Alloy)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard/paalloy
	display_category = ITEM_CAT_ARMOR_HELMETS
	additional_items = list(/obj/item/ingot/purifiedaalloy)

/datum/anvil_recipe/armor/paalloy/bascinet
	name = "Bascinet, Ancient (+1 Purified Alloy)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/paalloy
	display_category = ITEM_CAT_ARMOR_HELMETS
	additional_items = list(/obj/item/ingot/purifiedaalloy)

/datum/anvil_recipe/armor/aalloy/mask
	name = "Mask, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/mask/rogue/facemask/aalloy
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/paalloy/mask
	name = "Mask, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/mask/rogue/facemask/steel/paalloy
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/aalloy/coif
	name = "Coif, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/paalloy/coif
	name = "Coif, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/aalloy/gorget
	name = "Gorget, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/neck/roguetown/gorget/aalloy
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/paalloy/gorget
	name = "Gorget, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/neck/roguetown/gorget/paalloy
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/aalloy/cuirass
	name = "Cuirass, Decrepit (+1 Alloy)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/aalloy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/paalloy/cuirass
	name = "Cuirass, Ancient (+1 Purified Alloy)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/paalloy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/aalloy/halfplate
	name = "Half-Plate, Decrepit (+2 Alloy, +1 Cured Leather)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy,/obj/item/ingot/aalloy,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/aalloy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/paalloy/halfplate
	name = "Half-Plate, Ancient (+2 Purified Alloy, +1 Cured Leather)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy,/obj/item/ingot/purifiedaalloy,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/paalloy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/aalloy/chainmail
	name = "Chainmail, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/paalloy/chainmail
	name = "Chainmail, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/aalloy/hauberk
	name = "Hauberk, Decrepit (+1 Alloy)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES
	additional_items = list(/obj/item/ingot/aalloy)

/datum/anvil_recipe/armor/paalloy/hauberk
	name = "Hauberk, Ancient (+1 Purified Alloy)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES
	additional_items = list(/obj/item/ingot/purifiedaalloy)

/datum/anvil_recipe/armor/aalloy/bracers
	name = "Bracers, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/paalloy/bracers
	name = "Bracers, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/wrists/roguetown/bracers/paalloy
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/aalloy/chainsleeves
	name = "Chainsleeves, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/wrists/roguetown/bracers/aalloy/chain
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/paalloy/chainsleeves
	name = "Chainsleeves, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/wrists/roguetown/bracers/paalloy/chain
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/aalloy/sandals
	name = "Sandals, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/shoes/roguetown/sandals/aalloy
	display_category = ITEM_CAT_SMITHING_MISC

/datum/anvil_recipe/armor/paalloy/sandals
	name = "Sandals, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	display_category = ITEM_CAT_SMITHING_MISC

/datum/anvil_recipe/armor/aalloy/boots
	name = "Plated Boots, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/shoes/roguetown/boots/aalloy
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/paalloy/boots
	name = "Plated Boots, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/shoes/roguetown/boots/paalloy
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/aalloy/chaingaunts
	name = "Chain Gauntlets, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/gloves/roguetown/chain/aalloy
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/paalloy/chaingaunts
	name = "Chain Gauntlets, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/gloves/roguetown/chain/paalloy
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/aalloy/plategaunts
	name = "Plate Gauntlets, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/gloves/roguetown/plate/aalloy
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/paalloy/plategaunts
	name = "Plate Gauntlets, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/gloves/roguetown/plate/paalloy
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/aalloy/chainkilt
	name = "Chainkilt, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/paalloy/chainkilt
	name = "Chainkilt, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/aalloy/platelegs
	name = "Plated Chausses, Decrepit (+1 Alloy)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy)
	created_item = /obj/item/clothing/under/roguetown/platelegs/aalloy
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/paalloy/platelegs
	name = "Plated Chausses, Ancient (+1 Purified Alloy)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy)
	created_item = /obj/item/clothing/under/roguetown/platelegs/paalloy
	display_category = ITEM_CAT_ARMOR_LEGS

// BRONZE

/datum/anvil_recipe/armor/bronze/barbute
	name = "Barbute, Bronze (+1 Bronze, +1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bronze
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/bronze/murmillo
	name = "Murmillo-Style Helmet, Bronze (+1 Bronze, +1 Fur)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/fur)
	created_item = /obj/item/clothing/head/roguetown/helmet/bronzegladiator
	display_category = ITEM_CAT_ARMOR_HELMETS
	craftdiff = 2

/datum/anvil_recipe/armor/bronze/illyria
	name = "Bascinet, Bronze (+1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list( /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/bronze
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/bronze/protector
	name = "Heart Protector, Bronze (+1 Bronze, +1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/bronze/light
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/cuirass
	name = "Cuirass, Bronze (+1 Bronze, +1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/halfplate
	name = "Panoply Assembly, Halved, Bronze (+3 Bronze, +1 Cured Leather, +1 Fur)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/natural/hide/cured, /obj/item/natural/fur)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/bronze/alt
	display_category = ITEM_CAT_ARMOR_CHESTPIECES
	craftdiff = 2

/datum/anvil_recipe/armor/bronze/fullplate
	name = "Panoply Assembly, Full, Bronze (+3 Bronze, +1 Cured Leather, +1 Fur)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/natural/hide/cured, /obj/item/natural/fur)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES
	craftdiff = 3

/datum/anvil_recipe/armor/bronze/gorget
	name = "Neckguard, Bronze (+1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/neck/roguetown/gorget/bronze
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/bronze/bevor
	name = "Bevor, Bronze (+1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/neck/roguetown/bevor/bronze
	display_category = ITEM_CAT_ARMOR_NECK
	craftdiff = 2

/datum/anvil_recipe/armor/bronze/bracers
	name = "Bracers, Bronze (+1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/wrists/roguetown/bracers/bronze
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/bronze/greaves
	name = "Greaves, Bronze (+1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/bronze
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/bronze/skirt
	name = "Chainskirt, Bronze (+1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/bronze/mask
	name = "Mask, Bronze (+1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/mask/rogue/facemask/bronze
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/bronze/duelist
	name = "Duelist's Goggles"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/mask/rogue/spectacles/duelist/bronze
	display_category = ITEM_CAT_ARMOR_MASKS
	createditem_num = 2

/datum/anvil_recipe/armor/bronze/goggles
	name = "Bronze Goggles (+1 Glass)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/natural/glass)
	created_item = /obj/item/clothing/mask/rogue/spectacles/bronze
	display_category = ITEM_CAT_ARMOR_MASKS
	createditem_num = 2

/datum/anvil_recipe/armor/bronze/maskclassic
	name = "Mask, Ornate, Bronze (+1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/mask/rogue/facemask/bronze/classic
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/bronze/mask
	name = "Mask, Bronze (+1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/mask/rogue/facemask/bronze
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/bronze/chainmail
	name = "Haubergeon, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/hauberk
	name = "Hauberk, Bronze (+1 Bronze)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/lightchainmail
	name = "Haubyrine, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/light/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/maillebracers
	name = "Chainsleeves, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/wrists/roguetown/bracers/bronze/chain
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/bronze/maillegloves
	name = "Chain Gauntlets, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/gloves/roguetown/chain/bronze
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/bronze/maillecoif
	name = "Chain Coif, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/bronze
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/bronze/scalemail
	name = "Lamellar, Bronze (+1 Bronze, +1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/scale/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/mailleskirt
	name = "Chainmaille Skirt, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt/bronze
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/bronze/mailleboots
	name = "Maille Boots, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/shoes/roguetown/boots/maille/bronze
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/bronze/horseshoes
	name = "Horseshoes, Bronze (+1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/roguetown/horseshoes/bronze
	display_category = ITEM_CAT_SMITHING_MISC

// IRON
/datum/anvil_recipe/armor/iron/lightchainmail
	name = "Haubyrine, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/light/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/haubergeon
	name = "Haubergeon, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/hauberk
	name = "Hauberk, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/scalemail
	name = "Lamellar, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/scale/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/coatofplates
	name = "Coat of Plates, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine/heavy/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/knightarmetgreatplume
	name = "Helmet, Greatplumed Armet, Knight, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron/greatplume
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/headcage
	name = "Headcage, Iron (+2 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/headcage
	display_category = ITEM_CAT_ARMOR_HELMETS
	craftdiff = 2

/datum/anvil_recipe/armor/iron/mask
	name = "Mask, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/mask/rogue/facemask
	display_category = ITEM_CAT_ARMOR_MASKS
	createditem_num = 1

/datum/anvil_recipe/armor/iron/maskmaille
	name = "Maille Mask, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/mask/rogue/mailleiron
	display_category = ITEM_CAT_ARMOR_MASKS
	createditem_num = 1

/datum/anvil_recipe/armor/iron/maskmaillefluted
	name = "Maille Mask, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/mask/rogue/flutedmailleiron
	display_category = ITEM_CAT_ARMOR_MASKS
	createditem_num = 1


/datum/anvil_recipe/armor/iron/goggles
	name = "Goggles, Iron (+1 Glass)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/glass)
	created_item = /obj/item/clothing/mask/rogue/spectacles/iron
	display_category = ITEM_CAT_ARMOR_MASKS
	createditem_num = 2

/datum/anvil_recipe/armor/iron/duelist
	name = "Duelist Goggles, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/mask/rogue/spectacles/duelist
	display_category = ITEM_CAT_ARMOR_MASKS
	createditem_num = 2

/datum/anvil_recipe/armor/iron/chaincoif
	name = "Chain Coif, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/iron
	display_category = ITEM_CAT_ARMOR_NECK
	createditem_num = 1

/datum/anvil_recipe/armor/iron/fullchaincoif
	name = "Full Chain Coif, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/iron/full
	display_category = ITEM_CAT_ARMOR_NECK
	createditem_num = 1

/datum/anvil_recipe/armor/iron/gorget
	name = "Gorget, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/neck/roguetown/gorget
	display_category = ITEM_CAT_ARMOR_NECK
	createditem_num = 1

/datum/anvil_recipe/armor/iron/bevor
	name = "Bevor, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/neck/roguetown/bevor/iron
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/iron/aventail
	name = "Aventail, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/neck/roguetown/gorget/aventail/iron
	display_category = ITEM_CAT_ARMOR_NECK
	createditem_num = 1

/datum/anvil_recipe/armor/iron/breastplate
	name = "Breastplate, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/lbrigandine
	name = "Light Brigandine, Iron (+1 Cloth)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	display_category = ITEM_CAT_ARMOR_CHESTPIECES
	i_type = "Armor"

/datum/anvil_recipe/armor/iron/halfplate
	name = "Half-Plate, Iron (+2 Iron, +1 Cured Leather)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/bandedarmor
	name = "Banded Armor, Iron (+1 Metal Scrap Kit, +2 Fur, +2 Cured Leather)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/repair_kit/metal/bad, /obj/item/natural/fur, /obj/item/natural/fur, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/iron/banded
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/fullplate
	name = "Full-Plate, Iron (+3 Iron, +1 Cured Leather)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/breastplate_legacy
	name = "Valorian Breastplate, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/legacy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/halfplate_legacy
	name = "Valorian Half-Plate, Iron (+2 Iron, +1 Cured Leather)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/iron/legacy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/fullplate_legacy
	name = "Valorian Full-Plate, Iron (+3 Iron, +1 Cured Leather)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/iron/legacy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/chainglove
	name = "Chain Gauntlets, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/gloves/roguetown/chain/iron
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/iron/plategauntlets
	name = "Plate Gauntlets, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/gloves/roguetown/plate/iron
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/iron/bandedgauntlets
	name = "Banded Gauntlets, Iron (+2 Fur, + 1 Leather Gloves)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/fur, /obj/item/natural/fur, /obj/item/clothing/gloves/roguetown/leather)
	created_item = /obj/item/clothing/gloves/roguetown/plate/iron/banded
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/iron/chainleg
	name = "Chain Chausses, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/under/roguetown/chainlegs/iron
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/iron/chainhose
	name = "Chain Hoses, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/under/roguetown/chainlegs/iron/hose
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/iron/chainleg/kilt
	name = "Chain Kilt, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/iron/splintlegs
	name = "Splinted Chausses (+1 leather pants)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/clothing/under/roguetown/trou/leather)//basically you just add a lot of iron bits to the pants
	created_item = /obj/item/clothing/under/roguetown/splintlegs
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/iron/platelegs
	name = "Plate Chausses, Iron (+1 Bar)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/under/roguetown/platelegs/iron
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/iron/mask
	name = "Mask, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/mask/rogue/facemask
	display_category = ITEM_CAT_ARMOR_MASKS
	createditem_num = 1

/datum/anvil_recipe/armor/iron/wildguard
	name = "Wild Guard, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/mask/rogue/wildguard
	display_category = ITEM_CAT_ARMOR_MASKS
	createditem_num = 1

/datum/anvil_recipe/armor/iron/splintarms
	name = "Splinted Bracers (+1 leather bracers)" //you modify the bracers to have splints and cover the arm way more
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/clothing/wrists/roguetown/bracers/leather)
	created_item = /obj/item/clothing/wrists/roguetown/bracers/splint
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/iron/bracers
	name = "Plate Bracers, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/wrists/roguetown/bracers/iron
	display_category = ITEM_CAT_ARMOR_BRACERS
	createditem_num = 1

/datum/anvil_recipe/armor/iron/chainsleeves
	name = "Chainsleeves, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/wrists/roguetown/bracers/iron/chain
	display_category = ITEM_CAT_ARMOR_BRACERS
	createditem_num = 1

/datum/anvil_recipe/armor/iron/jackchain
	name = "Jack Chain, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/iron/plateboot
	name = "Plated Boots, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	display_category = ITEM_CAT_ARMOR_BOOTS
	createditem_num = 1

/datum/anvil_recipe/armor/iron/mailleboot
	name = "Maille Boots, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/shoes/roguetown/boots/maille/iron
	display_category = ITEM_CAT_ARMOR_BOOTS
	createditem_num = 1

/datum/anvil_recipe/armor/iron/bascinet
	name = "Bascinet, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/skullcap
	name = "Skullcap, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/roguetown/helmet/skullcap
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/kettle
	name = "Kettle Helmet, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/sallet
	name = "Sallet, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/belt
	name = "Plated Belt, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/storage/belt/rogue/leather/iron
	display_category = ITEM_CAT_ARMOR_BELTS

/datum/anvil_recipe/armor/iron/belt/tasset
	name = "Tasseted Plate Belt, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/storage/belt/rogue/leather/iron/tasset
	display_category = ITEM_CAT_ARMOR_BELTS

/datum/anvil_recipe/armor/iron/todd
	name = "Banded Helmet, Iron (+1 Metal Scrap Kit, +2 Bones)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/repair_kit/metal/bad, /obj/item/natural/bone, /obj/item/natural/bone)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/iron/banded
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/sallet/visor
	name = "Sallet, Visored, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/kettle_legacy
	name = "Valorian Kettle Helmet, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/iron/legacy
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/sallet_legacy
	name = "Valorian Sallet, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/iron/legacy
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/sallet/visor_legacy
	name = "Valorian Sallet, Visored, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron/legacy
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/knightarmet
	name = "Knight's Armet, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/knighthelmet
	name = "Knight's Helmet, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/old/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/aventailbascinet
	name = "Bascinet, Aventailed, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/iron/aventail
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/heavyaventailbascinet
	name = "Visored Bascinet, Aventailed, Iron (+2 Iron, +1 Cured Leather)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/aventail/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/bucket
	name = "Iron Bucket Helmet (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/helmethorned
	name = "Horned Helmet, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/roguetown/helmet/horned
	display_category = ITEM_CAT_ARMOR_HELMETS
	craftdiff = 2

/datum/anvil_recipe/armor/helmetgoblin
	name = "Goblin Helmet (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/goblin
	display_category = ITEM_CAT_ARMOR_HELMETS
	craftdiff = 2

/datum/anvil_recipe/armor/plategoblin
	name = "Goblin Maille (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/goblin
	display_category = ITEM_CAT_ARMOR_CHESTPIECES
	craftdiff = 2

/datum/anvil_recipe/armor/iron/helmetnasal
	name = "Nasal Helmet, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/roguetown/helmet/nasal/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/helmetwinged
	name = "Winged Helmet, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/roguetown/helmet/winged/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/helmetbuc
	name = "Bucket Helmet, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/helmetpig
	name = "Bascinet, Pigface, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/helmethounskull
	name = "Bascinet, Hounskull, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/helmetroundface
	name = "Bascinet, Roundface, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/etruscanbascinet
	name = "Bascinet, Klappvisier, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/helmetarmet
	name = "Armet, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/slittedkettle
	name = "Slitted Kettle, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/savoyard
	name = "Savoyard Helmet, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/bogman
	name = "Bogman Helmet, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard/bogman/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/barredhelm
	name = "Barred Helmet, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/beakhelm
	name = "Beak Helmet, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/beakhelm/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/helmetbarbute
	name = "Barbute, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/helmetbarbutevisor
	name = "Barbute, Visored, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/helmetbuc
	name = "Bucket Helmet, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/horseshoes
	name = "Horseshoes, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/shoes/roguetown/horseshoes
	display_category = ITEM_CAT_SMITHING_MISC

// --------- STEEL RECIPES -----------
/datum/anvil_recipe/armor/steel/lightchainmail
	name = "Haubyrine, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/light
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/haubergeon
	name = "Haubergeon, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/chainkini
	name = "Chainmail Corslet, Steel (+1 Cloth)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/bikini
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/hauberk
	name = "Hauberk, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/halfplate
	name = "Half-Plate, Steel (+2 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/halfplate_legacy
	name = "Valorian Half-Plate, Steel (+2 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/legacy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/halfplate/fluted
	name = "Fluted Half-Plate, Steel (+3 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/fluted
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/fullplate
	name = "Full-Plate, Steel (+3 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/fullplate_legacy
	name = "Valorian Full-Plate, Steel (+3 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/legacy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/fullplate_fluted
	name = "Fluted Full-Plate, Steel (+4 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/fullplate/fluted_legacy
	name = "Valorian Fluted Full-Plate, Steel (+4 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/legacy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/platebikini
	name = "Half-Plate Corslet, Steel (+1 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/bikini
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/fullplatebikini
	name = "Full-Plate Corslet, Steel (+2 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/bikini
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/coatplates
	name = "Coat Of Plates, Steel (+1 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine/heavy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/steel/brigandine
	name = "Brigandine, Steel (+1 Steel, +2 Cloth)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/cloth, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/chaincoif
	name = "Chain Coif, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/neck/roguetown/chaincoif
	display_category = ITEM_CAT_ARMOR_NECK
	createditem_num = 1

/datum/anvil_recipe/armor/steel/chainmantle
	name = "Chain Mantle, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	display_category = ITEM_CAT_ARMOR_NECK
	createditem_num = 1

/datum/anvil_recipe/armor/steel/fullchaincoif
	name = "Full Chain Coif, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/full
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/steel/chainglove
	name = "Chain Gauntlets, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/gloves/roguetown/chain
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/steel/plateglove
	name = "Plate Gauntlets, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/gloves/roguetown/plate
	display_category = ITEM_CAT_ARMOR_GLOVES
	createditem_num = 1

/datum/anvil_recipe/armor/steel/chainleg
	name = "Chain Chausses, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/under/roguetown/chainlegs
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/chainhose
	name = "Chain Hoses, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/under/roguetown/chainlegs/hose
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/chainlegs/kilt
	name = "Chain Kilt, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/brayette
	name = "Brayette, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/under/roguetown/brayette
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/chainskirt
	name = "Chain Skirt, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/under/roguetown/chainlegs/skirt
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/plateskirt
	name = "Plate Tassets, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/under/roguetown/platelegs/skirt
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/platelegs
	name = "Plated Chausses, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/under/roguetown/platelegs
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/cuirass
	name = "Cuirass, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/fencingcuirass
	name = "Fencing Cuirass, Steel (+1 Steel, +1 Fencing Jacket)" //needs cooperation with a tailor to make
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/fencinghaubergeon
	name = "Fencing Haubergeon, Steel (+1 Steel, +1 Besilked Jacket)" //needs cooperation with a tailor to make
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/clothing/suit/roguetown/armor/gambeson/lord/heavy/silkjacket) //Quick patchwork to prevent loadouteers from gaming the system.
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/besilked/fencer
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/cuirass/legacy
	name = "Valorian Cuirass, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/legacy
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/cuirass/fluted
	name = "Fluted Cuirass, Steel (+1 Steel, +1 Iron)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/scalemail
	name = "Scalemail, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/scale
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/platebracer
	name = "Plate Bracers, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/wrists/roguetown/bracers
	display_category = ITEM_CAT_ARMOR_BRACERS
	createditem_num = 1

/datum/anvil_recipe/armor/steel/chainsleeves
	name = "Chainsleeves, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/wrists/roguetown/bracers/chain
	display_category = ITEM_CAT_ARMOR_BRACERS
	createditem_num = 1

/datum/anvil_recipe/armor/steel/helmetnasal
	name = "Nasal Helmet, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/roguetown/helmet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetwinged
	name = "Winged Helmet, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/roguetown/helmet/winged
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetkettle
	name = "Kettle Helmet, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/widehelmetkettle
	name = "Wide Kettle Helmet, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/wide
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetkettle_legacy
	name = "Valorian Kettle Helmet, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/legacy
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetsall_legacy
	name = "Valorian Sallet, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/legacy
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetsallv_legacy
	name = "Valorian Sallet, Visored, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored/legacy
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/bevor
	name = "Bevor, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/neck/roguetown/bevor
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/steel/sgorget
	name = "Gorget, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/neck/roguetown/gorget/steel
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/steel/saventail
	name = "Aventail, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/neck/roguetown/gorget/aventail
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/iron/cursed_collar
	name = "Cursed Collar"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/neck/roguetown/gorget/cursed_collar
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/steel/skullcaps
	name = "Skullcap, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/roguetown/helmet/skullcap/steel
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetsall
	name = "Sallet, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetsallv
	name = "Sallet, Visored, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetbuc
	name = "Bucket Helmet, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/bascinet
	name = "Bascinet, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/aventailbascinet
	name = "Bascinet, Aventailed, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/aventail
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/heavyaventailbascinet
	name = "Visored Bascinet, Aventailed, Steel (+2 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/aventail
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetpig
	name = "Bascinet, Pigface, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmethounskull
	name = "Bascinet, Hounskull, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetroundface
	name = "Bascinet, Roundface, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/etruscanbascinet
	name = "Bascinet, Klappvisier, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetknightarmet//This won't confuse anyone I promise
	name = "Knight's Armet, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetknight
	name = "Knight's Helmet, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/old
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetarmet
	name = "Armet, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/slittedkettle
	name = "Slitted Kettle, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/savoyard
	name = "Savoyard Helmet, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/bogman
	name = "Bogman Helmet, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard/bogman
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/barredhelm
	name = "Barred Helmet, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/beakhelm
	name = "Beak Helmet, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/beakhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/mailleboot
	name = "Maille Boots, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/shoes/roguetown/boots/maille
	display_category = ITEM_CAT_ARMOR_BOOTS
	createditem_num = 1

/datum/anvil_recipe/armor/steel/plateboot
	name = "Plated Boots, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor
	display_category = ITEM_CAT_ARMOR_BOOTS
	createditem_num = 1

/datum/anvil_recipe/armor/steel/mask
	name = "Mask, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/mask/rogue/facemask/steel
	display_category = ITEM_CAT_ARMOR_MASKS
	createditem_num = 1

/datum/anvil_recipe/armor/steel/goggles
	name = "Goggles, Steel (+1 Glass)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/natural/glass)
	created_item = /obj/item/clothing/mask/rogue/spectacles/steel
	display_category = ITEM_CAT_ARMOR_MASKS
	createditem_num = 2

/datum/anvil_recipe/armor/steel/duelist
	name = "Duelist Goggles, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/mask/rogue/spectacles/duelist/steel
	display_category = ITEM_CAT_ARMOR_MASKS
	createditem_num = 2

/datum/anvil_recipe/armor/steel/maillemask
	name = "Maille Mask, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/mask/rogue/maillesteel
	display_category = ITEM_CAT_ARMOR_MASKS
	createditem_num = 1

/datum/anvil_recipe/armor/steel/maillemask
	name = "Fluted Maille Mask, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/mask/rogue/flutedsteelmaille
	display_category = ITEM_CAT_ARMOR_MASKS
	createditem_num = 1

/datum/anvil_recipe/armor/steel/frogmouth
	name = "Froggemund Helmet, Steel (+2 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetbucalt
	name = "Sugarloaf Helmet, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetbarbute
	name = "Barbute, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/barbute
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetbarbutevisor
	name = "Barbute, Visored, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetbarbutedunk
	name = "Barbute, Great, Steel (+1 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/great
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetbuc
	name = "Bucket Helmet, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetknightarmetgreatplume
	name = "Knight's Greatplumed Armet, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/frogmouthgreatplume
	name = "Froggemund Helmet With Greatplume, Steel (+2 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth/greatplume
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/belt
	name = "Plated Belt, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/storage/belt/rogue/leather/steel
	display_category = ITEM_CAT_ARMOR_BELTS

/datum/anvil_recipe/armor/steel/belt/tasset
	name = "Tasseted Plate Belt, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/storage/belt/rogue/leather/steel/tasset
	display_category = ITEM_CAT_ARMOR_BELTS

/datum/anvil_recipe/armor/steel/splintarms
	name = "Brigandine Bracers (+1 Leather Bracers)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/clothing/wrists/roguetown/bracers/leather)
	created_item = /obj/item/clothing/wrists/roguetown/bracers/brigandine
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/steel/splintlegs
	name = "Brigandine Chausses (+1 leather pants)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/clothing/under/roguetown/trou/leather)//basically you just add a lot of iron bits to the pants
	created_item = /obj/item/clothing/under/roguetown/brigandinelegs
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/horseshoes
	name = "Horseshoes, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/shoes/roguetown/horseshoes/steel
	display_category = ITEM_CAT_SMITHING_MISC

/datum/anvil_recipe/armor/steel/barding
	name = "Saiga Barding, Chainmail (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/barding/chain
	display_category = ITEM_CAT_ARMOR_BARDING

/datum/anvil_recipe/armor/steel/barding/fogbeast
	name = "Fogbeast Barding, Chainmail (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/barding/fogbeast/chain
	display_category = ITEM_CAT_ARMOR_BARDING

/datum/anvil_recipe/armor/steel/refitkit_slimmedsteel
	name = "Refitter's Kit, Slimmed Plate Armor, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/enchantingkit/craftable_armorkit_slimmedsteel
	display_category = ITEM_CAT_SMITHING_MISC
	craftdiff = SKILL_LEVEL_EXPERT

// HOLY STEEL

/datum/anvil_recipe/armor/holysteel/astratahelmtemplar
	name = "Astratan Templar's Helmet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Astrata)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/astrata)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/astratan
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/malumhelmtemplar
	name = "Malumite Templar's Helmet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Malum)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/malum)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/malum
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/necrahelmtemplar
	name = "Necran Templar's Helmet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Necra)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/necra)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/necran
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/pestrahelmtemplar
	name = "Pestran Templar's Helmet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Pestra)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/pestra)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/pestran
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/eorahelmtemplar
	name = "Eoran Templar's Helmet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Eora)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/eora)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/eoran
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/astratahelm
	name = "Astratan Helmet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Astrata)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/astrata)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/abyssorhelm
	name = "Abyssorite Helmet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Abyssor)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/abyssor)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/necrahelm
	name = "Necran Helmet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Necra)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/necra)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/nochelm
	name = "Noccian Helmet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Noc)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/noc)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/dendorhelm
	name = "Dendorite Helmet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Dendor)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/dendor)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/ravoxhelm
	name = "Ravoxian Helmet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Ravox)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/ravox)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/xylixhelm
	name = "Xylixian Helmet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Xylix)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/xylix)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/eorahelm
	name = "Eoran Helmet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Eora)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/eora)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/eoran
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/undividedtemplar_sallet
	name = "Undivided Templar's Sallet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Ten)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/undivided)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/undivided
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/undividedtemplar_bucket
	name = "Undivided Templar's Bucket Helmet (+1 Holy Steel, +1 Cured Leather, +1 Amulet of Ten)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured, /obj/item/clothing/neck/roguetown/psicross/undivided)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/undivided_alt
	display_category = ITEM_CAT_ARMOR_HELMETS

// SILVER

/datum/anvil_recipe/armor/silver/belt
	name = "Plated Belt, Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/storage/belt/rogue/leather/plaquesilver
	display_category = ITEM_CAT_ARMOR_BELTS

/datum/anvil_recipe/armor/silver/horseshoes
	name = "Horseshoes, Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/clothing/shoes/roguetown/horseshoes/silver
	display_category = ITEM_CAT_SMITHING_MISC


// BLESSED SILVER

/datum/anvil_recipe/armor/blessedsilver/psychestplate
	name = "Psydonic Chestplate (+1 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/psydon
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/psycuirass
	name = "Psydonic Cuirass (+2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/armetpsy
	name = "Psydonic Armet"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/greatplumearmetpsy
	name = "Psydonic Greatplumed Armet"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/psy/greatplume
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/helmsallpsy
	name = "Psydonic Sallet"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psysallet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/helmbucketpsy
	name = "Psydonic Bucket Helm"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psybucket
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/helmetabso
	name = "Psydonian Conical Greathelm (+2 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/absolver/unblessed
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/psyhalfplate
	name = "Psydonic Half-Plate (+ Psydonic Cuirass, +1 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/psyfullplate
	name = "Psydonic Full-Plate (+ Psydonic Half-Plate, +1 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/psyfullplatealt
	name = "Psydonic Full-Plate, Hauberked (+ Psydonic Plate-And-Maille, +2 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, /obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/// BLESSED SILVER, BULLION VARIANTS - FALLBACK
/datum/anvil_recipe/armor/blessedsilver/psychestplate/inq
	name = "Psydonic Chestplate (+1 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/psydon
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/psycuirass/inq
	name = "Psydonic Cuirass (+2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/armetpsy/inq
	name = "Psydonic Armet"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/greatplumearmetpsy/inq
	name = "Psydonic Greatplumed Armet"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/psy/greatplume
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/helmsallpsy/inq
	name = "Psydonic Sallet"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psysallet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/helmbucketpsy/inq
	name = "Psydonic Bucket Helm"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psybucket
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/helmetabso/inq
	name = "Psydonian Conical Greathelm (+2 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	additional_items = list(/obj/item/ingot/silverblessed/bullion, /obj/item/ingot/silverblessed/bullion)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/absolver/unblessed
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/psyhalfplate/inq
	name = "Psydonic Half-Plate (+ Psydonic Cuirass, +1 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate, /obj/item/ingot/silverblessed/bullion, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/psyfullplate/inq
	name = "Psydonic Full-Plate (+ Psydonic Half-Plate, +1 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate, /obj/item/ingot/silverblessed/bullion, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/psyfullplatealt/inq
	name = "Psydonic Full-Plate, Hauberked (+ Psydonic Plate-And-Maille, +2 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, /obj/item/ingot/silverblessed/bullion, /obj/item/ingot/silverblessed/bullion, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

// DECORATED

/datum/anvil_recipe/armor/decorated/belt
	name = "Plated Belt, Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/storage/belt/rogue/leather/plaquegold
	display_category = ITEM_CAT_ARMOR_BELTS

/datum/anvil_recipe/armor/decorated/mask
	name = "Mask, Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/mask/rogue/facemask/goldmask
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/decorated/maskc
	name = "Crestless Mask, Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/mask/rogue/facemask/goldmaskc
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/decorated/horseshoes
	name = "Horseshoes, Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/shoes/roguetown/horseshoes/gold
	display_category = ITEM_CAT_SMITHING_MISC

/datum/anvil_recipe/armor/decorated/helmetbuc
	name = "Bucket Helmet, Decorated (+1 Bucket Helm)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/head/roguetown/helmet/heavy/bucket)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gold
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/decorated/helmetbucalt
	name = "Sugarloaf Helmet, Decorated (+1 Sugarloaf Helm)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader/gold
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/decorated/gilded_chestplate
	name = "Chestplate, Decorated (+1 Steel Cuirass, +1 Steel, +2 Silk)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer, /obj/item/ingot/steel, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/decorated
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decorated/gilded_cuirass
	name = "Cuirass, Decorated (+1 Steel Cuirass, +1 Steel)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/decorated
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decorated/gilded_halfplate
	name = "Halfplate, Decorated (+1 Steel Halfplate, +1 Steel)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/fluted, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/fluted/decorated
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decorated/gilded_fullplate
	name = "Plate Armor, Decorated (+1 Steel Plate Armor, +1 Steel)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/full/fluted, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/decorated
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decorated/gilded_chestplatefluted
	name = "Fluted Chestplate, Decorated (+1 Fencer's Cuirass)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/decorated
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decorated/gilded_cuirassfluted
	name = "Fluted Cuirass, Decorated (+1 Fluted Cuirass)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/decorated
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decorated/gilded_halfplatefluted
	name = "Fluted Halfplate, Decorated (+1 Fluted Halfplate)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/fluted)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/fluted/decorated
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decorated/gilded_fullplatefluted
	name = "Fluted Plate Armor, Decorated (+1 Fluted Plate Armor)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/full/fluted)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/decorated
	display_category = ITEM_CAT_ARMOR_CHESTPIECES


// BLACKSTEEL

/datum/anvil_recipe/armor/blacksteel/cuirass
	name = "Cuirass, Blacksteel (+1 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/blacksteel
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blacksteel/modern/platechest
	name = "Full-Plate, Blacksteel (+3 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel/modern
	display_category = ITEM_CAT_ARMOR_CHESTPIECES
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/modern/halfplatechest
	name = "Half-Plate, Blacksteel (+2 Blacksteel, +1 Cured Hide)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel/modern
	display_category = ITEM_CAT_ARMOR_CHESTPIECES
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/modern/plategloves
	name = "Plate Gauntlets, Blacksteel"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/gloves/roguetown/plate/blacksteel/modern
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/blacksteel/modern/platelegs
	name = "Plate Chausses, Blacksteel (+1 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/blacksteel/modern/armet
	name = "Armet, Blacksteel (+1 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/roguetown/helmet/blacksteel/modern
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blacksteel/modern/bracers
	name = "Bracers, Blacksteel"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/wrists/roguetown/bracers/blacksteel/modern
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/blacksteel/modern/neckguard
	name = "Neckguard, Blacksteel"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/neck/roguetown/bevor/blacksteel/modern
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/blacksteel/modern/plateboots
	name = "Plate Boots, Blacksteel"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/blacksteel/modern
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/blacksteel/modern/sugarloaf
	name = "Sugarloaf Helmet, Blacksteel (+1 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader/blacksteel
	display_category = ITEM_CAT_ARMOR_HELMETS

// BLACKSTEEL, ANCIENT

/datum/anvil_recipe/armor/blacksteel/platechest
	name = "Ancient Blacksteel Plate Armor (+3 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blacksteel/halfplatechest
	name = "Ancient Blacksteel Half Plate Armor (+2 Blacksteel, +1 Cured Hide)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blacksteel/platelegs
	name = "Ancient Blacksteel Plate Chausses (+1 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/under/roguetown/platelegs/blacksteel
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/blacksteel/bucket
	name = "Ancient Blacksteel Bucket Helmet (+1 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/roguetown/helmet/blacksteel
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blacksteel/plategloves
	name = "Ancient Blacksteel Plate Gauntlets"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/gloves/roguetown/plate/blacksteel
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/blacksteel/plateboots
	name = "Ancient Blacksteel Plate Boots"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/blacksteel
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/blacksteel/bracers
	name = "Ancient Blacksteel Bracers"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/wrists/roguetown/bracers/blacksteel
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/blacksteel/neckguard
	name = "Ancient Blacksteel Neckguard"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/neck/roguetown/bevor/blacksteel
	display_category = ITEM_CAT_ARMOR_NECK

// AVANTYNE

/datum/anvil_recipe/armor/avantyne/helmet
	name = "Veil, Avantyne (+1 A. Wafer)"
	req_bar = /obj/item/ingot/avantyne
	additional_items = list(/obj/item/ingot/avantyne)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/avantyne
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/avantyne/maille
	name = "Maille, Avantyne (+3 A. Wafer, +1 Cured Leather)"
	req_bar = /obj/item/ingot/avantyne
	additional_items = list(/obj/item/ingot/avantyne, /obj/item/ingot/avantyne, /obj/item/ingot/avantyne, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/fluted/avantyne
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/avantyne/faulds
	name = "Fauldcoat, Avantyne (+1 A. Wafer)"
	req_bar = /obj/item/ingot/avantyne
	additional_items = list(/obj/item/ingot/avantyne)
	created_item = /obj/item/clothing/under/roguetown/platelegs/avantyne
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/avantyne/gloves
	name = "Gloves, Avantyne"
	req_bar = /obj/item/ingot/avantyne
	created_item = /obj/item/clothing/gloves/roguetown/plate/avantyne
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/avantyne/boots
	name = "Sabatons, Avantyne"
	req_bar = /obj/item/ingot/avantyne
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/avantyne
	display_category = ITEM_CAT_ARMOR_BOOTS

// GOLD

/datum/anvil_recipe/armor/gold/armet
	name = "Golden Knight's Armet (+1 Gold, +2 Silk)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/gold
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/gold/armetcrown
	name = "Golden Knight's Armet, Royal (+1 Gold, +2 Silk, +1 Dorpel)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/roguegem/diamond)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/gold/king
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/gold/helmet
	name = "Golden Barbute (+1 Gold, +2 Silk)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff/gold
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/gold/helmetcrown
	name = "Golden Barbute, Royal (+1 Gold, +2 Silk, +1 Dorpel)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/roguegem/diamond)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff/gold/king
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/gold/gorget
	name = "Golden Gorget (+1 Gold, +2 Silk)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/neck/roguetown/gorget/gold
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/gold/cuirass
	name = "Golden Cuirass (+2 Gold, +2 Silk)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/gold
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/gold/cuirasshero
	name = "Golden Cuirass, Heroic (+2 Gold, +2 Silk, +1 Tallow)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/reagent_containers/food/snacks/tallow)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/gold/heroic
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/gold/bracers
	name = "Golden Bracers (+1 Gold, +2 Silk)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/wrists/roguetown/bracers/gold
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/gold/greaves
	name = "Golden Greaves (+1 Gold, +2 Silk)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/gold
	display_category = ITEM_CAT_ARMOR_BOOTS
