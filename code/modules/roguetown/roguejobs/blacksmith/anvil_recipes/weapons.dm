/datum/anvil_recipe/weapons
	abstract_type = /datum/anvil_recipe/weapons
	appro_skill = /datum/skill/craft/weaponsmithing  // inheritance yay !!
	i_type = "Weapons"

/datum/anvil_recipe/weapons/aalloy
	abstract_type = /datum/anvil_recipe/weapons/aalloy
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/weapons/paalloy
	abstract_type = /datum/anvil_recipe/weapons/paalloy
	craftdiff = SKILL_LEVEL_JOURNEYMAN // Steel equivalence

/datum/anvil_recipe/weapons/copper
	abstract_type = /datum/anvil_recipe/weapons/copper
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/weapons/bronze
	abstract_type = /datum/anvil_recipe/weapons/bronze
	craftdiff = SKILL_LEVEL_NOVICE //Situationally better than iron, but far more limited in terms of recipes and availability. 

/datum/anvil_recipe/weapons/iron
	abstract_type = /datum/anvil_recipe/weapons/iron
	craftdiff = SKILL_LEVEL_APPRENTICE

/datum/anvil_recipe/weapons/steel
	abstract_type = /datum/anvil_recipe/weapons/steel
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/weapons/decorated
	abstract_type = /datum/anvil_recipe/weapons/decorated
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/weapons/silver
	abstract_type = /datum/anvil_recipe/weapons/
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/weapons/psy
	abstract_type = /datum/anvil_recipe/weapons/psy
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/weapons/holysteel
	abstract_type = /datum/anvil_recipe/weapons/holysteel
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/weapons/blacksteel
	abstract_type = /datum/anvil_recipe/weapons/blacksteel
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/weapons/avantyne
	abstract_type = /datum/anvil_recipe/weapons/avantyne
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/weapons/gold
	abstract_type = /datum/anvil_recipe/weapons/gold
	craftdiff = SKILL_LEVEL_LEGENDARY

// DECREPIT/ANCIENT ALLOY

/datum/anvil_recipe/weapons/aalloy/flail
	name = "Flail, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/flail/aflail
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/paalloy/flail/
	name = "Flail, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/flail/sflail/paflail
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/aalloy/dagger
	name = "Dagger, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/huntingknife/idagger/adagger
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/paalloy/dagger
	name = "Dagger, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/aalloy/knuckles
	name = "Knuckles, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/gloves/roguetown/knuckles/decrepit
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/paalloy/knuckles
	name = "Knuckles, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/gloves/roguetown/knuckles/ancient
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/aalloy/gladius
	name = "Gladius, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/sword/short/gladius/agladius
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/paalloy/gladius
	name = "Gladius, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/sword/short/gladius/pagladius
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/aalloy/shortsword
	name = "Shortsword, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/sword/short/ashort
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/paalloy/shortsword
	name = "Shortsword, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/sword/short/pashortsword
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/aalloy/khopesh
	name = "Khopesh, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/sword/sabre/alloy
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/paalloy/khopesh
	name = "Khopesh, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/sword/sabre/palloy
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/aalloy/handaxe
	name = "Axe, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/aaxe
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/paalloy/handaxe
	name = "Axe, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/aalloy/mace
	name = "Mace, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/mace/alloy
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/paalloy/mace
	name = "Mace, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/mace/steel/palloy
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/aalloy/warhammer
	name = "Warhammer, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/mace/warhammer/alloy
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/paalloy/warhammer
	name = "Warhammer, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/paalloy
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/aalloy/tossblade
	name = "Tossblades, Decrepit (x4)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/aalloy
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	createditem_num = 4

/datum/anvil_recipe/weapons/paalloy/tossblade
	name = "Tossblades, Ancient (x4)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel/palloy
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	createditem_num = 4

/datum/anvil_recipe/weapons/aalloy/gsw
	name = "Greatsword, Decrepit (+2 Alloy)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/greatsword/aalloy
	display_category = ITEM_CAT_WEAPONS_SWORDS
	additional_items = list(/obj/item/ingot/aalloy, /obj/item/ingot/aalloy)

/datum/anvil_recipe/weapons/paalloy/gsw
	name = "Greatsword, Ancient (+2 Purified Alloy)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/greatsword/paalloy
	display_category = ITEM_CAT_WEAPONS_SWORDS
	additional_items = list(/obj/item/ingot/purifiedaalloy, /obj/item/ingot/purifiedaalloy)

/datum/anvil_recipe/weapons/aalloy/bardiche
	name = "Bardiche, Decrepit (+1 Alloy, +1 Small Log)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/halberd/bardiche/aalloy
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	additional_items = list(/obj/item/ingot/aalloy, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/paalloy/bardiche
	name = "Bardiche, Ancient (+1 Purified Alloy, +1 Small Log)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/halberd/bardiche/paalloy
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	additional_items = list(/obj/item/ingot/purifiedaalloy, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/aalloy/grandmace
	name = "Grand Mace, Decrepit (+1 Alloy, +1 Small Log)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/aalloy
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/paalloy/grandmace
	name = "Grand Mace, Purified (+1 Purified Alloy, +1 Small Log)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel/paalloy
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/aalloy/spear
	name = "Spear, Decrepit (+1 Small Log)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/aalloy
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/paalloy/spear
	name = "Spear, Ancient (+1 Small Log)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/paalloy
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/aalloy/javelin
	name = "Javelin, Decrepit (+1 Small Log) (x2)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/aalloy
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 2

/datum/anvil_recipe/weapons/paalloy/javelin
	name = "Javelin, Ancient (+1 Small Log) (x2)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel/paalloy
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 2

/datum/anvil_recipe/weapons/aalloy/flamberge
	name = "Flamberge, Decrepit (+2 Alloy, +1 Small Log, +1 Cured Leather)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy, /obj/item/ingot/aalloy, /obj/item/grown/log/tree/small, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge/aalloy
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/paalloy/flamberge
	name = "Flamberge, Purified (+2 Purified Alloy, +1 Small Log, +1 Cured Leather)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy, /obj/item/ingot/purifiedaalloy, /obj/item/grown/log/tree/small, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge/paalloy
	display_category = ITEM_CAT_WEAPONS_SWORDS

// COPPER

/datum/anvil_recipe/weapons/copper/caxe
	name = "Hatchet, Copper (+1 Copper)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe/copper
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/copper/cbludgeon
	name = "Budgeon, Copper (+1 Stick)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/cudgel/copper
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/copper/cdagger
	name = "Knife, Copper (x2)"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/rogueweapon/huntingknife/copper
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	createditem_num = 2

/datum/anvil_recipe/weapons/copper/cmesser
	name = "Messer, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/rogueweapon/sword/short/messer/copper
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/copper/cspears
	name = "Spear, Copper (+1 Small Log) (x2)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/stone/copper
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	createditem_num = 2

/datum/anvil_recipe/weapons/copper/crhomphaia
	name = "Rhomphaia, Copper (+1 Copper)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/rogueweapon/sword/long/rhomphaia/copper
	display_category = ITEM_CAT_WEAPONS_SWORDS

// BRONZE

/datum/anvil_recipe/weapons/bronze/katar
	name = "Katar, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/katar/bronze
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/axegauntlet
	name = "Axegauntlet, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/katar/bronze/gladiator
	display_category = ITEM_CAT_WEAPONS_SWORDS
	craftdiff = 2

/datum/anvil_recipe/weapons/bronze/bronzeknuckle
	name = "Knuckledusters, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/gloves/roguetown/knuckles/bronze
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/bronze/gladius
	name = "Gladius, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/sword/short/gladius
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/sword
	name = "Arming Sword, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/sword/bronze
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/sabre
	name = "Khopesh, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/axe
	name = "Axe, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/bronze
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/bronze/mace
	name = "Mace, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/mace/bronze
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/bronze/dagger
	name = "Knife, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/huntingknife/bronze
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/bronze/combatknife
	name = "Combat Knife, Bronze (+1 Bronze)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/huntingknife/combat/bronze
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/bronze/falchion
	name = "Falchion, Bronze (+1 Bronze)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/sword/falchion/militia/bronze
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/messer
	name = "Messer, Bronze (+1 Bronze)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/sword/short/messer/bronze
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/battleaxe
	name = "War Axe, Bronze (+1 Bronze)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/bronzebattleaxe
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/bronze/battlemace
	name = "Warclub, Bronze (+1 Bronze)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/mace/warhammer/bronze
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/bronze/whip
	name = "Whip, Bronze-Tipped (+1 Leather Whip)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/rogueweapon/whip)
	created_item = /obj/item/rogueweapon/whip/bronze
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/bronze/broadsword
	name = "Broadsword, Bronze (+1 Bronze, +1 Small Log)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/broadsword/bronze
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/greatkhopesh
	name = "Greatkhopesh, Bronze (+1 Bronze, +1 Small Log)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/greatkhopesh
	display_category = ITEM_CAT_WEAPONS_SWORDS
	craftdiff = 2

/datum/anvil_recipe/weapons/bronze/spear
	name = "Spear, Bronze (+1 Bronze, +1 Small Log)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/bronze
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/bronze/spearwinged
	name = "Winged Spear, Bronze (+1 Bronze, +1 Small Log)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/bronze/winged
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	craftdiff = 2

/datum/anvil_recipe/weapons/bronze/greataxe
	name = "Greataxe, Bronze (+1 Bronze, +1 Small Log)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/bronze
	display_category = ITEM_CAT_WEAPONS_AXES
	craftdiff = 2

/datum/anvil_recipe/weapons/bronze/javelin
	name = "Javelin, Bronze (+1 Small Log) (x2)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item =  /obj/item/ammo_casing/caseless/rogue/javelin/bronze
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 2

/datum/anvil_recipe/weapons/bronze/trident
	name = "Trident, Bronze (+2 Bronze, +1 Small Log)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/trident
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	craftdiff = 2

// IRON

/datum/anvil_recipe/weapons/iron/sword
	name = "Arming Sword, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/sword/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/sabre
	name = "Sabre, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/sword/saber/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/swordshort
	name = "Shortsword, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/sword/short/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/swordbanded
	name = "Sword, Banded Iron (+1 Scrap Metal Kit)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/repair_kit/metal/bad)
	created_item = /obj/item/rogueweapon/sword/short/iron/banded
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/messer
	name = "Messer, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/sword/short/messer/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/dagger
	name = "Dagger, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/huntingknife/idagger
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	createditem_num = 1

/datum/anvil_recipe/weapons/iron/combatknife
	name = "Combat Knife, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/huntingknife/combat/iron
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	createditem_num = 1

/datum/anvil_recipe/weapons/iron/flail
	name = "Flail, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/flail
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/iron/flailalt
	name = "Flail, Studded, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/flail/alt
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/iron/huntknife
	name = "Hunting Knife, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/huntingknife
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	createditem_num = 1

/datum/anvil_recipe/weapons/iron/broadsword
	name = "Broadsword, Iron (+1 Iron, 1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/broadsword
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/greatflail
	name = "Greatflail, Iron (+1 Iron, +1 Chain, +1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/rope/chain, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/flail/peasantwarflail/iron
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/iron/greatsword
	name = "Greatsword, Iron (+2 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/greatsword/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/claymore
	name = "Claymore, Iron (+4 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/greatsword/zwei
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/axe
	name = "Axe, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/iron/hatchet
	name = "Hatchet, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/iron/axelegacy
	name = "Woodcutting Handaxe, Iron (+1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/woodcutter
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/iron/greataxe
	name = "Greataxe, Iron (+1 Iron, +1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/iron/cudgel
	name = "Cudgel, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/cudgel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/iron/mace
	name = "Mace, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/iron/warhammer
	name = "Warhammer, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/warhammer
	display_category = ITEM_CAT_WEAPONS_MACES
	i_type = "Weapons"

/datum/anvil_recipe/weapons/iron/spear
	name = "Spear, Iron (+1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/iron/spear_trainer
	name = "Spear Trainer, Iron (+1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/trainer
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/iron/dory
	name = "Dory, Iron (+1 Iron, +1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/spellblade
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/iron/bardiche
	name = "Bardiche, Iron (+1 Iron, +1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd/bardiche
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/iron/lucerne
	name = "Lucerne, Iron (+1 Iron, +1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/eaglebeak/lucerne
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/iron/polemace
	name = "Goedendag, Iron (+1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/iron/tossblade
	name = "Tossblades, Iron (x4)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	createditem_num = 4

/datum/anvil_recipe/weapons/iron/javelin
	name = "Javelin, Iron (+1 Small Log) (x2)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 2

/datum/anvil_recipe/weapons/iron/maul
	name = "Maul (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/mace/maul
	display_category = ITEM_CAT_WEAPONS_MACES
	craftdiff = 4

/// STEEL WEAPONS
/datum/anvil_recipe/weapons/steel/dagger
	name = "Dagger, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	createditem_num = 1

/datum/anvil_recipe/weapons/steel/dagger_trainer
	name = "Dagger Trainer, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/trainer
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	createditem_num = 1

/datum/anvil_recipe/weapons/steel/daggerparrying
	name = "Parrying Dagger, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/daggerrondel
	name = "Rondel Dagger, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/katar
	name = "Katar, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/katar
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/punchdagger
	name = "Punch Dagger"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/katar/punchdagger
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/steelknuckle
	name = "Knuckles, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/gloves/roguetown/knuckles
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/steel/hurlbat
	name = "Hurlbat"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/stoneaxe/hurlbat
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/rapier
	name = "Rapier, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/rapier
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/cutlass
	name = "Cutlass, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/cutlass
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/swordshort
	name = "Shortsword, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/short
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/falchion
	name = "Falchion, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/short/falchion
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/messer
	name = "Messer, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/short/messer
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/messeralt
	name = "Hunting Sword, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/short/messer/alt
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/sword
	name = "Arming Sword, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/saber
	name = "Sabre, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/sabre
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/flail
	name = "Flail, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/flail/sflail
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/steel/longsword
	name = "Longsword, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/broadsword
	name = "Broadsword, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/broadsword/steel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/trainingsword
	name = "Training Sword, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/training
	display_category = ITEM_CAT_WEAPONS_SWORDS
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/kriegmesser
	name = "Kriegmesser, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/battleaxe
	name = "Battle Axe, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/stoneaxe/battle
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/combatknife
	name = "Combat Knife, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/huntingknife/combat
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/combatknifemesser
	name = "Combat Knife, Messer, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/combat/messser
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/mace
	name = "Mace, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/steel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/steel/swarhammer
	name = "Warhammer, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/warhammer/steel
	display_category = ITEM_CAT_WEAPONS_MACES
	i_type = "Weapons"

/datum/anvil_recipe/weapons/steel/sflangedmace
	name = "Flanged Mace, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/cudgel/flanged
	display_category = ITEM_CAT_WEAPONS_MACES
	i_type = "Weapons"

/datum/anvil_recipe/weapons/steel/greatsword
	name = "Greatsword, Steel (+2 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/greatsword
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/flamb
	name = "Flamberge, Steel (+3 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/estoc
	name = "Estoc, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/estoc
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/aplongsword
	name = "Stecher, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/ap
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/axe
	name = "Axe, Steel (+1 Stick)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/greataxe
	name = "Greataxe, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/steel
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/greataxe/knight
	name = "Poleaxe, Steel (+1 Steel, +1 Small Log, +1 Cloth)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small, /obj/item/natural/cloth)
	created_item = /obj/item/rogueweapon/greataxe/steel/knight
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/greataxe/doublehead
	name = "Double-Headed Greataxe, Steel (+2 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/steel/doublehead
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/billhook
	name = "Billhook, Steel (+1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/billhook
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/halberd
	name = "Halberd, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/eaglebeak
	name = "Eagle's Beak (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/eaglebeak
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/grandmace
	name = "Grand Mace, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/steel/partizan
	name = "Partizan, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/partizan
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/naginata
	name = "Naginata, Steel (+1 Big Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/) //looong spear
	created_item = /obj/item/rogueweapon/spear/naginata
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/boarspear
	name = "Boar Spear, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/boar
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/lance
	name = "Lance, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/lance
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/tossblade
	name = "Tossblade, Steel (x4)"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	createditem_num = 4

/datum/anvil_recipe/weapons/steel/javelin
	name = "Javelin, Steel (+1 Small Log) (x2)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 2

/datum/anvil_recipe/weapons/steel/fishspear
	name = "Fishing Spear, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/fishspear
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/rhomphaia
	name = "Rhomphaia, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/rhomphaia
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/falx
	name = "Falx, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/falx
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/maul
	name = "Grand Maul (+2 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/maul/grand
	display_category = ITEM_CAT_WEAPONS_MACES

// DECORATED

/datum/anvil_recipe/weapons/decorated/sword
	name = "Sword, Decorated (+1 Steel Sword)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/sword)
	created_item = /obj/item/rogueweapon/sword/decorated
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decorated/saber
	name = "Sabre, Decorated (+1 Steel Sabre)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/sword/sabre)
	created_item = /obj/item/rogueweapon/sword/sabre/dec
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decorated/rapier
	name = "Rapier, Decorated (+1 Steel Rapier)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/sword/rapier)
	created_item = /obj/item/rogueweapon/sword/rapier/dec
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decorated/dagger
	name = "Dagger, Decorated (+1 Steel Dagger)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/huntingknife/idagger/steel)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/decorated
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/decorated/longsword
	name = "Longsword, Decorated (+1 Steel Longsword)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/sword/long)
	created_item = /obj/item/rogueweapon/sword/long/dec
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decorated/gladius
	name = "Gladius, Decorated (+1 Bronze Gladius)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/sword/short/gladius)
	created_item = /obj/item/rogueweapon/sword/short/gladius/decorated
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decorated/warclub
	name = "Warclub, Decorated (+1 Bronze Warclub)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/mace/warhammer/bronze)
	created_item = /obj/item/rogueweapon/mace/warhammer/bronze/decorated
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/decorated/axe
	name = "Axe, Decorated (+1 Steel Axe)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/stoneaxe/woodcut/steel)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/decorated
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/decorated/swordsil
	name = "Elegant Axesword, Silvered (+1 Silver Sword)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/sword/silver)
	created_item = /obj/item/rogueweapon/sword/silver/decorated
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decorated/macesil
	name = "Elegant Mace, Silvered (+1 Silver Mace)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/mace/steel/silver)
	created_item = /obj/item/rogueweapon/mace/steel/silver/decorated
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/decorated/elfsaber
	name = "Elegant Sabre, Elvish (+3 Silver)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/sabre/elf
	display_category = ITEM_CAT_WEAPONS_SWORDS
	craftdiff = 5 //Combination of Decorated- and Silver-tier methods, alongside being stronger than either.

/datum/anvil_recipe/weapons/decorated/elfdagger
	name = "Elegant Dagger, Elvish (+2 Silver)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	craftdiff = 5 //Ditto.

/datum/anvil_recipe/weapons/decorated/scabbard
	name = "Scabbard, Gold-Decorated (+1 Sword's Scabbard)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/scabbard/sword)
	created_item = /obj/item/rogueweapon/scabbard/sword/royal
	display_category = ITEM_CAT_SMITHING_MISC
	craftdiff = 5

/datum/anvil_recipe/weapons/decorated/sheath
	name = "Sheath, Gold-Decorated (+1 Dagger's Sheath)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/scabbard/sheath)
	created_item = /obj/item/rogueweapon/scabbard/sheath/royal
	display_category = ITEM_CAT_SMITHING_MISC
	craftdiff = 5

// SILVER

/datum/anvil_recipe/weapons/silver/dagger
	name = "Dagger, Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/silver/dagger
	name = "Hunting Knife, Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/rogueweapon/huntingknife/combat/silver
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/silver/shortsword
	name = "Shortsword, Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/rogueweapon/sword/short/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/stake
	name = "Stake, Silver-Tipped (+1 Sharpened Stake)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/rogueweapon/huntingknife/idagger/stake)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/stake
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	craftdiff = 5

/datum/anvil_recipe/weapons/silver/katar
	name = "Katar, Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/rogueweapon/katar/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/sword
	name = "Arming Sword, Silver (+1 Silver)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/rapier
	name = "Rapier, Silver (+1 Silver)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/rapier/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/claws
	name = "Handclaws, Silver (+1 Silver, +1 Cured Leather)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/handclaw/gronn/silver
	display_category = ITEM_CAT_SMITHING_MISC

/datum/anvil_recipe/weapons/silver/scabbard
	name = "Scabbard, Silver-Decorated (+1 Sword's Scabbard)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/rogueweapon/scabbard/sword)
	created_item = /obj/item/rogueweapon/scabbard/sword/noble
	display_category = ITEM_CAT_SMITHING_MISC

/datum/anvil_recipe/weapons/silver/sheath
	name = "Sheath, Silver-Decorated (+1 Dagger's Sheath)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/rogueweapon/scabbard/sheath)
	created_item = /obj/item/rogueweapon/scabbard/sheath/noble
	display_category = ITEM_CAT_SMITHING_MISC

/datum/anvil_recipe/weapons/silver/longsword
	name = "Longsword, Silver (+2 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/broadsword
	name = "Broadsword, Silver (+2 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/greatsword
	name = "Greatsword, Silver (+3 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greatsword/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/waraxe
	name = "War Axe, Silver (+1 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/silver
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/silver/poleaxe
	name = "Poleaxe, Silver (+2 Silver, +2 Small Logs)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/silver
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/silver/mace
	name = "Mace, Silver (+2 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/steel/silver
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/silver/flangedmace
	name = "Flanged Mace, Silver  (+1 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/cudgel/flanged/silver
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/silver/warhammer
	name = "Warhammer, Silver (+2 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/silver
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/silver/quarterstaff
	name = "Quarterstaff, Silver (+3 Small Logs)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/woodstaff/quarterstaff/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/spear
	name = "Spear, Silver (+3 Small Logs)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/silver
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/silver/morningstar
	name = "Morningstar, Silver (+3 Silver, +1 Chain)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/rope/chain)
	created_item = /obj/item/rogueweapon/flail/sflail/silver
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/silver/whip
	name = "Whip, Silver (+1 Leather Whip)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/rogueweapon/whip)
	created_item = /obj/item/rogueweapon/whip/silver
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/silver/tossblade
	name = "Tossblades, Silver (+1 Silver)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/silver
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	createditem_num = 4

/datum/anvil_recipe/weapons/silver/javelin
	name = "Javelins, Silver (+1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/silver
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 2

/datum/anvil_recipe/weapons/silver/tomahawk
	name = "Tomahawk, Silver (+1 Small Log)"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe/silver
	additional_items = list(/obj/item/grown/log/tree/small)
	i_type = "Weapons"
	display_category = ITEM_CAT_WEAPONS_AXES


/datum/anvil_recipe/weapons/silver/exec
	name = "Executioners Sword, Silver (+2 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/exe/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/halberd
	name = "Halberd, Silver (+2 Silver, +2 Small Logs)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd/silver
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/silver/knuckledusters
	name = "Knuckledusters, Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/rogueweapon/knuckledusters/silver
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/silver/scythe
	name = "Scythe, Silver (+1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/scythe/silver

// SHIELDS

/datum/anvil_recipe/weapons/steel/kiteshield
	name = "Kite Shield (+1 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/aalloy/shield
	name = "Shield, Decrepit (+1 Alloy, +1 Cured Leather)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/alloy
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/palloy/shield
	name = "Shield, Ancient (+1 Purified Alloy, +1 Cured Leather)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/palloy
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/paalloy/greatshield
	name = "Greatshield, Ancient (+2 Purified Alloy, +1 Cured Leather)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/bronze/great/paalloy
	craftdiff = 2

/datum/anvil_recipe/weapons/alloy/greatshield
	name = "Greatshield, Decrepit (+2 Alloy, +1 Cured Leather)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/bronze/great/aalloy
	craftdiff = 2

/datum/anvil_recipe/weapons/paalloy/hoplonshield
	name = "Hoplon Shield, Ancient (+1 Purified Alloy, +1 Cured Leather)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/bronze/paalloy

/datum/anvil_recipe/weapons/aalloy/hoplonshield
	name = "Hoplon Shield, Decrepit (+1 Alloy, +1 Cured Leather)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/bronze/aalloy

/datum/anvil_recipe/weapons/iron/towershield
	name = "Tower Shield (+1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/shield/tower
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/steel/buckler
	name = "Buckler (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/shield/buckler
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/iron/roundshield
	name = "Shield, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/shield/iron
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/bronze/bronzeshield
	name = "Shield, Bronze (+1 Bronze, +1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/bronze
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/bronze/bronzegreatshield
	name = "Greatshield, Bronze (+2 Bronze, +1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/bronze/great
	display_category = ITEM_CAT_WEAPONS_SHIELDS
	craftdiff = 2

// CROSSBOW

/datum/anvil_recipe/weapons/steel/xbow
	name = "Crossbow (+1 Small Log, +1 Fiber)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/natural/fibers)
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	display_category = ITEM_CAT_SMITHING_MISC

/datum/anvil_recipe/weapons/iron/bolts
	name = "Crossbow Bolts (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/iron/bolts/light
	name = "Light Slurbow Bolts (+1 Stick) (x10)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/light
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/bronze/bolts
	name = "Hastequilled Bolts, Bronze (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/bronze
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/aalloy/bolts
	name = "Bolts, Decrepit (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/aalloy
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/paalloy/bolts
	name = "Bolts, Ancient (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/paalloy
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/iron/bluntbolts
	name = "Bolts, Blunt (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/blunt
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/aalloy/heavybolts
	name = "Siegebolts, Decrepit (+1 Alloy, 2 Small Logs) (x4)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/heavy_bolt/aalloy
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 4
	i_type = "Ammo"

/datum/anvil_recipe/weapons/paalloy/heavybolts
	name = "Siegebolts, Ancient (+1 Purified Alloy, 2 Small Logs) (x4)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/heavy_bolt/paalloy
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 4
	i_type = "Ammo"

/datum/anvil_recipe/weapons/steel/heavybolts
	name = "Siegebolts, Steel (+1 Steel, 2 Small Logs) (x2)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/heavy_bolt
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 2
	i_type = "Ammo"

/datum/anvil_recipe/weapons/iron/heavybolts
	name = "Siegebolts, Blunt (+1 Iron, 2 Small Logs) (x2)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/heavy_bolt/blunt
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 2
	i_type = "Ammo"

/datum/anvil_recipe/weapons/bronze/heavybolts
	name = "Hastequilled Siegebolts, Bronze (+1 Bronze, +2 Small Logs) (x2)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/heavy_bolt/bronze
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 2
	i_type = "Ammo"

// BOW

/datum/anvil_recipe/weapons/iron/arrows
	name = "Broadhead Arrows, Iron (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/iron
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/aalloy/arrows
	name = "Broadhead Arrows, Decrepit (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/iron/aalloy
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/steel/arrows
	name = "Bodkin Arrows, Steel (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/steel
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/paalloy/arrows
	name = "Bodkin Arrows, Ancient (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/steel/paalloy
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/bronze/arrows
	name = "Hastequilled Arrows, Bronze (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/bronze
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "Ammo"

// SLING

/datum/anvil_recipe/weapons/iron/slingbullets
	name = "Sling Bullets, Iron (x20)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 20
	i_type = "Ammo"

/datum/anvil_recipe/weapons/bronze/slingbullets
	name = "Sling Bullets, Bronze (x20)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 20
	i_type = "Ammo"

/datum/anvil_recipe/weapons/aalloy/slingbullets
	name = "Sling Bullets, Decrepit (x10)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/aalloy
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/paalloy/slingbullets
	name = "Sling Bullets, Ancient (x10)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/paalloy
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/steel/slingbullets
	name = "Steel Scattershot (x20)"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 20
	i_type = "Ammo"

// UNIQUE

/datum/anvil_recipe/valuables/deprivedsword
	name = "Sword, Imperfect (+1 Small Log, +2 Glimmering Slag)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/aaslag, /obj/item/ingot/aaslag, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/broken
	display_category = ITEM_CAT_WEAPONS_SWORDS
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/valuables/deprivedshortsword
	name = "Shortsword, Imperfect (+1 Stick, +2 Glimmering Slag)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/aaslag, /obj/item/ingot/aaslag, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/sword/short/broken
	display_category = ITEM_CAT_WEAPONS_SWORDS
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/valuables/iron/execution
	name = "Executioner's Sword (+2 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/sword/long/exe
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

/datum/anvil_recipe/valuables/iron/rawheapofiron
	name = "Heap of Raw Iron (+4 Iron Ore)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/rogueore/iron, /obj/item/rogueore/iron, /obj/item/rogueore/iron, /obj/item/rogueore/iron)
	created_item = /obj/item/ingot/component/heapofrawiron
	display_category = ITEM_CAT_COMPONENTS
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	craftdiff = SKILL_LEVEL_MASTER
	bypass_dupe_test = TRUE

/datum/anvil_recipe/valuables/iron/berserkswordgrip
	name = "Grip of the Berserker's Sword (+1 Executioner Sword, +2 Small Logs, +2 Cured Leather)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/rogueweapon/sword/long/exe, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/ingot/component/berserkswordgrip
	display_category = ITEM_CAT_COMPONENTS
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	craftdiff = SKILL_LEVEL_MASTER
	bypass_dupe_test = TRUE

/datum/anvil_recipe/valuables/iron/berserkswordblade
	name = "Blade of the Berserker's Sword (+4 Iron Ingots, +1 Heap of Raw Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/component/heapofrawiron)
	created_item = /obj/item/ingot/component/berserkswordblade
	display_category = ITEM_CAT_COMPONENTS
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	craftdiff = SKILL_LEVEL_MASTER
	bypass_dupe_test = TRUE

/datum/anvil_recipe/valuables/iron/berserksword
	name = "Berserker's Sword (+1 B. Sword's Blade)"
	req_bar = /obj/item/ingot/component/berserkswordgrip
	additional_items = list(/obj/item/ingot/component/berserkswordblade)
	created_item = /obj/item/rogueweapon/sword/long/exe/berserk
	display_category = ITEM_CAT_WEAPONS_SWORDS
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/valuables/iron/berserkswordalt
	name = "Berserker's Sword (+1 B. Sword's Grip)"
	req_bar = /obj/item/ingot/component/berserkswordblade
	additional_items = list(/obj/item/ingot/component/berserkswordgrip)
	created_item = /obj/item/rogueweapon/sword/long/exe/berserk
	display_category = ITEM_CAT_WEAPONS_SWORDS
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/weapons/lithmyc/mace
	name = "Lithmyc Mace (+ Blueprint)"
	req_bar = /obj/item/ingot/lithmyc
	additional_items = list(/obj/item/blueprint/mace_mushroom)
	created_item = /obj/item/rogueweapon/mace/mushroom
	display_category = ITEM_CAT_WEAPONS_MACES
	i_type = "Weapons"
	craftdiff = SKILL_LEVEL_LEGENDARY

// HOLY STEEL

/datum/anvil_recipe/weapons/holysteel/church_longsword
	name = "Longsword, Templaric"
	req_bar = /obj/item/ingot/steelholy
	created_item = /obj/item/rogueweapon/sword/long/church
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/holysteel/church_spear
	name = "Spear, Templaric (+1 Holy Steel)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/spear/holysee
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/holysteel/decasword
	name = "Longsword, Decablessed (+1 Holy Steel)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/sword/long/undivided
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/holysteel/decashield
	name = "Shield, Decablessed (+1 Holy Steel)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/shield/tower/holysee
	display_category = ITEM_CAT_WEAPONS_SHIELDS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/holysteel/malum_sword
	name = "Malumite Flamberge (+2 Holy Steel)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge/malum
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

// BLESSED SILVER

/datum/anvil_recipe/weapons/psy/axe
	name = "Psydonic War Axe (+1 Blessed Silver, +1 Stick)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/stoneaxe/battle/psyaxe
	display_category = ITEM_CAT_WEAPONS_AXES
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/stick)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/mace
	name = "Psydonic Mace (+1 Blessed Silver, +1 Stick)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/mace/goden/psymace
	display_category = ITEM_CAT_WEAPONS_MACES
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/stick)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/spear
	name = "Psydonic Spear (+1 Blessed Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/spear/psyspear
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/dagger
	name = "Psydonic Dagger"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/shortsword
	name = "Psydonic Shortsword"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/sword/short/psy
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/katar
	name = "Psydonic Katar"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/katar/psydon
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/knuckles
	name = "Psydonic Knuckledusters"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/knuckledusters/psy
	display_category = ITEM_CAT_WEAPONS_MACES
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/armingsword
	name = "Psydonic Arming Sword"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/sword/psy
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/cudgelmace
	name = "Psydonic Handmace (+1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/mace/cudgel/psyclassic
	display_category = ITEM_CAT_WEAPONS_MACES
	additional_items = list(/obj/item/grown/log/tree/small)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/halberd
	name = "Psydonic Halberd (+2 Blessed Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/halberd/psyhalberd
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/gsword
	name = "Psydonic Greatsword (+2 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/greatsword/psygsword
	display_category = ITEM_CAT_WEAPONS_SWORDS
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/sword
	name = "Psydonic Longsword (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/sword/long/psysword
	display_category = ITEM_CAT_WEAPONS_SWORDS
	additional_items = list(/obj/item/ingot/silverblessed)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/whip
	name = "Psydonic Whip (+1 Leather Whip)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/whip/psywhip_lesser
	display_category = ITEM_CAT_WEAPONS_FLAILS
	additional_items = list(/obj/item/rogueweapon/whip)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/broadsword
	name = "Psydonic Broadsword (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser/psy
	additional_items = list(/obj/item/ingot/silverblessed)
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/exesword
	name = "Psydonic Executioner Sword (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/sword/long/exe/psy
	additional_items = list(/obj/item/ingot/silverblessed)
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/heavydagger
	name = "Psydonic Misericorde"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger/heavy
	i_type = "Weapons"
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/psy/tomahawk
	name = "Psydonic Tomahawk (+1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe/psy
	additional_items = list(/obj/item/grown/log/tree/small)
	i_type = "Weapons"
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/psy/maul
	name = "Psydonic Maul (+2 Blessed Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/mace/maul/grand/psy
	display_category = ITEM_CAT_WEAPONS_MACES
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/rapier
	name = "Psydonic Rapier (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/sword/rapier/psy
	additional_items = list(/obj/item/ingot/silverblessed)
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

/// BLESSED SILVER, BULLION VARIANTS - FALLBACK

/datum/anvil_recipe/weapons/psy/axe/inq
	name = "Psydonic War Axe (+1 Blessed Silver, +1 Stick)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/stoneaxe/battle/psyaxe
	display_category = ITEM_CAT_WEAPONS_AXES
	additional_items = list(/obj/item/ingot/silverblessed/bullion, /obj/item/grown/log/tree/stick)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/mace/inq
	name = "Psydonic Mace (+1 Blessed Silver, +1 Stick)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/mace/goden/psymace
	display_category = ITEM_CAT_WEAPONS_MACES
	additional_items = list(/obj/item/ingot/silverblessed/bullion, /obj/item/grown/log/tree/stick)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/cudgelmace/inq
	name = "Psydonic Handmace (+1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/mace/cudgel/psyclassic
	display_category = ITEM_CAT_WEAPONS_MACES
	additional_items = list(/obj/item/grown/log/tree/small)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/spear/inq
	name = "Psydonic Spear (+1 Blessed Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/spear/psyspear
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	additional_items = list(/obj/item/ingot/silverblessed/bullion, /obj/item/grown/log/tree/small)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/dagger/inq
	name = "Psydonic Dagger"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/shortsword/inq
	name = "Psydonic Shortsword"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/sword/short/psy
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/katar/inq
	name = "Psydonic Katar"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/katar/psydon
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/knuckles/inq
	name = "Psydonic Knuckledusters"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/clothing/gloves/roguetown/knuckles/psydon
	display_category = ITEM_CAT_WEAPONS_MACES
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/armingsword/inq
	name = "Psydonic Arming Sword"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/sword/psy
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/halberd/inq
	name = "Psydonic Halberd (+2 Blessed Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/halberd/psyhalberd
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	additional_items = list(/obj/item/ingot/silverblessed/bullion, /obj/item/ingot/silverblessed/bullion, /obj/item/grown/log/tree/small)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/maul/inq
	name = "Psydonic Maul (+2 Blessed Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/mace/maul/grand/psy
	display_category = ITEM_CAT_WEAPONS_MACES
	additional_items = list(/obj/item/ingot/silverblessed/bullion, /obj/item/ingot/silverblessed/bullion, /obj/item/grown/log/tree/small)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/gsword/inq
	name = "Psydonic Greatsword (+2 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/greatsword/psygsword
	display_category = ITEM_CAT_WEAPONS_SWORDS
	additional_items = list(/obj/item/ingot/silverblessed/bullion, /obj/item/ingot/silverblessed/bullion)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/sword/inq
	name = "Psydonic Longsword (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/sword/long/psysword
	display_category = ITEM_CAT_WEAPONS_SWORDS
	additional_items = list(/obj/item/ingot/silverblessed/bullion)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/whip/inq
	name = "Psydonic Whip (+3 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/whip/psywhip_lesser
	display_category = ITEM_CAT_WEAPONS_FLAILS
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/broadsword/inq
	name = "Psydonic Broadsword (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser/psy
	additional_items = list(/obj/item/ingot/silverblessed/bullion)
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/exesword/inq
	name = "Psydonic Executioner Sword (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/sword/long/exe/psy
	additional_items = list(/obj/item/ingot/silverblessed/bullion)
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/heavydagger/inq
	name = "Psydonic Misericorde"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger/heavy
	i_type = "Weapons"
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/psy/tomahawk/inq
	name = "Psydonic Tomahawk (+1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe/psy
	additional_items = list(/obj/item/grown/log/tree/small)
	i_type = "Weapons"
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/psy/rapier/inq
	name = "Psydonic Rapier (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/sword/rapier/psy
	additional_items = list(/obj/item/ingot/silverblessed/bullion)
	display_category = ITEM_CAT_WEAPONS_SWORDS
	i_type = "Weapons"

// BLACKSTEEL

/datum/anvil_recipe/weapons/blacksteel/arming
	name = "Blacksteel Arming Sword (+1 Silk)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/blacksteel/decsword
	name = "Blacksteel Arming Sword, Decorated (+1 Steel Arming Sword, +1 Gold, +1 Silk)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/rogueweapon/sword, /obj/item/ingot/gold, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/blacksteel/decorated
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/blacksteel/flamberge
	name = "Blacksteel Flamberge (+1 Blacksteel, +1 Rontz, +1 Silk)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/ruby, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

// AVANTYNE

/datum/anvil_recipe/weapons/avantyne/dagger
	name = "Dagger, Avantyne"
	req_bar = /obj/item/ingot/avantyne
	created_item = /obj/item/rogueweapon/huntingknife/idagger/avantyne
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/avantyne/sword
	name = "Arming Sword, Avantyne"
	req_bar = /obj/item/ingot/avantyne
	created_item = /obj/item/rogueweapon/sword/avantyne
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/avantyne/longsword
	name = "Longsword, Avantyne (+1 A. Wafer)"
	req_bar = /obj/item/ingot/avantyne
	additional_items = list(/obj/item/ingot/avantyne)
	created_item = /obj/item/rogueweapon/sword/long/avantyne
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/avantyne/rapier
	name = "Rapier, Avantyne (+1 A. Wafer)"
	req_bar = /obj/item/ingot/avantyne
	additional_items = list(/obj/item/ingot/avantyne)
	created_item = /obj/item/rogueweapon/sword/rapier/avantyne

/datum/anvil_recipe/weapons/avantyne/billhook
	name = "Billhook, Avantyne (+1 Small Log)"
	req_bar = /obj/item/ingot/avantyne
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/billhook/avantyne

/datum/anvil_recipe/weapons/avantyne/greatsword
	name = "Greatsword, Avantyne (+2 A. Wafer)"
	req_bar = /obj/item/ingot/avantyne
	additional_items = list(/obj/item/ingot/avantyne, /obj/item/ingot/avantyne)
	created_item = /obj/item/rogueweapon/greatsword/avantyne
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/avantyne/shield
	name = "Shield, Avantyne (+1 A. Wafer, +1 Cured Leather)"
	req_bar = /obj/item/ingot/avantyne
	additional_items = list(/obj/item/ingot/avantyne, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/avantyne
	display_category = ITEM_CAT_WEAPONS_SHIELDS

// GOLD

/datum/anvil_recipe/weapons/gold/arming
	name = "Golden Arming Sword (+2 Gold, +2 Silk)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/gold
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/gold/mace
	name = "Golden Mace (+2 Gold, +2 Silk)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/mace/gold
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/gold/shield
	name = "Golden Shield (+3 Gold, +1 Fur)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/fur)
	created_item = /obj/item/rogueweapon/shield/tower/metal/gold
	display_category = ITEM_CAT_WEAPONS_SHIELDS
