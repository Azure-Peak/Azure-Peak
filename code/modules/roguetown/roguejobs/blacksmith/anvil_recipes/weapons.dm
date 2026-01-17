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


// DECREPIT/ANCIENT ALLOY

/datum/anvil_recipe/weapons/aalloy/flail
	name = "Flail, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/flail/aflail

/datum/anvil_recipe/weapons/paalloy/flail/
	name = "Flail, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/flail/sflail/paflail

/datum/anvil_recipe/weapons/aalloy/dagger
	name = "Dagger, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/huntingknife/idagger/adagger


/datum/anvil_recipe/weapons/paalloy/dagger
	name = "Dagger, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger

/datum/anvil_recipe/weapons/aalloy/knuckles
	name = "Knuckles, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/knuckles/aknuckles

/datum/anvil_recipe/weapons/paalloy/knuckles
	name = "Knuckles, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/knuckles/paknuckles

/datum/anvil_recipe/weapons/aalloy/gladius
	name = "Gladius, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/sword/short/gladius/agladius


/datum/anvil_recipe/weapons/paalloy/gladius
	name = "Gladius, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/sword/short/gladius/pagladius

/datum/anvil_recipe/weapons/aalloy/shortsword
	name = "Shortsword, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/sword/short/ashort

/datum/anvil_recipe/weapons/paalloy/shortsword
	name = "Shortsword, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/sword/short/pashortsword

/datum/anvil_recipe/weapons/aalloy/khopesh
	name = "Khopesh, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/sword/sabre/alloy

/datum/anvil_recipe/weapons/paalloy/khopesh
	name = "Khopesh, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/sword/sabre/palloy

/datum/anvil_recipe/weapons/aalloy/handaxe
	name = "Axe, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/aaxe

/datum/anvil_recipe/weapons/paalloy/handaxe
	name = "Axe, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe

/datum/anvil_recipe/weapons/aalloy/mace
	name = "Mace, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/mace/alloy


/datum/anvil_recipe/weapons/paalloy/mace
	name = "Mace, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/mace/steel/palloy

/datum/anvil_recipe/weapons/aalloy/warhammer
	name = "Warhammer, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/mace/warhammer/alloy

/datum/anvil_recipe/weapons/paalloy/warhammer
	name = "Warhammer, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/paalloy

/datum/anvil_recipe/weapons/aalloy/tossblade
	name = "Tossblades, Decrepit (x4)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/aalloy
	createditem_num = 4

/datum/anvil_recipe/weapons/paalloy/tossblade
	name = "Tossblades, Ancient (x4)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel/palloy
	createditem_num = 4

/datum/anvil_recipe/weapons/aalloy/gsw
	name = "Greatsword, Decrepit (+2 Alloy)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/greatsword/aalloy
	additional_items = list(/obj/item/ingot/aalloy, /obj/item/ingot/aalloy)

/datum/anvil_recipe/weapons/paalloy/gsw
	name = "Greatsword, Ancient (+2 Purified Alloy)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/greatsword/paalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy, /obj/item/ingot/purifiedaalloy)

/datum/anvil_recipe/weapons/aalloy/bardiche
	name = "Bardiche, Decrepit (+1 log, +1 Alloy)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/halberd/bardiche/aalloy
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/paalloy/bardiche
	name = "Bardiche, Ancient (+1 log, +1 Purified Alloy)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/halberd/bardiche/paalloy
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/aalloy/grandmace
	name = "Grand Mace, Decrepit (+1 Alloy, +1 Small Log)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/aalloy

/datum/anvil_recipe/weapons/paalloy/grandmace
	name = "Grand Mace, Purified (+1 Purified Alloy, +1 Small Log)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel/paalloy

/datum/anvil_recipe/weapons/aalloy/spear
	name = "Spear, Decrepit(+1 Small Log)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/aalloy

/datum/anvil_recipe/weapons/paalloy/spear
	name = "Spear, Ancient (+1 Small Log)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/paalloy

/datum/anvil_recipe/weapons/aalloy/javelin
	name = "Javelin, Decrepit (+1 Small Log) (x2)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/aalloy
	createditem_num = 2

/datum/anvil_recipe/weapons/paalloy/javelin
	name = "Javelin, Ancient (+1 Small Log) (x2)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel/paalloy
	createditem_num = 2


// COPPER

/datum/anvil_recipe/weapons/copper/caxe
	name = "Hatchet, Copper (+1 Copper)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe/copper

/datum/anvil_recipe/weapons/copper/cbludgeon
	name = "Budgeon, Copper (+1 Stick)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/cudgel/copper

/datum/anvil_recipe/weapons/copper/cdagger
	name = "Knife, Copper (x2)"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/rogueweapon/huntingknife/copper
	createditem_num = 2

/datum/anvil_recipe/weapons/copper/cmesser
	name = "Messer, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/rogueweapon/sword/short/messer/copper

/datum/anvil_recipe/weapons/copper/cspears
	name = "Spear, Copper (+1 Small Log) (x2)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/stone/copper
	createditem_num = 2

/datum/anvil_recipe/weapons/copper/crhomphaia
	name = "Rhomphaia, Copper (+1 Copper)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/rogueweapon/sword/long/rhomphaia/copper

// BRONZE

/datum/anvil_recipe/weapons/bronze/katar
	name = "Katar, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/katar/bronze

/datum/anvil_recipe/weapons/bronze/bronzeknuckle
	name = "Knuckledusters, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/knuckles/bronzeknuckles

/datum/anvil_recipe/weapons/bronze/gladius
	name = "Gladius, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/sword/short/gladius

/datum/anvil_recipe/weapons/bronze/sword
	name = "Sword, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/sword/bronze

/datum/anvil_recipe/weapons/bronze/axe
	name = "Axe, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/bronze

/datum/anvil_recipe/weapons/bronze/mace
	name = "Mace, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/mace/bronze

/datum/anvil_recipe/weapons/bronze/dagger
	name = "Dagger, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/huntingknife/bronze

/datum/anvil_recipe/weapons/bronze/whip
	name = "Whip, Bronze-Tipped (+3 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/whip/bronze

/datum/anvil_recipe/weapons/bronze/spear
	name = "Spear, Bronze (+1 Bronze, +1 Small Log)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/bronze

/datum/anvil_recipe/weapons/bronze/trident
	name = "Trident, Bronze (+1 Steel, +1 Iron, +1 Small Log)"
	req_bar = /obj/item/ingot/bronze
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/trident

// IRON

/datum/anvil_recipe/weapons/iron/sword
	name = "Arming Sword, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/iron

/datum/anvil_recipe/weapons/iron/swordshort
	name = "Shortsword, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/short/iron

/datum/anvil_recipe/weapons/iron/messer
	name = "Messer, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/short/messer/iron

/datum/anvil_recipe/weapons/iron/dagger
	name = "Dagger, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife/idagger
	createditem_num = 1

/datum/anvil_recipe/weapons/iron/flail
	name = "Flail, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/flail

/datum/anvil_recipe/weapons/iron/huntknife
	name = "Hunting Knife, Iron"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife
	createditem_num = 1

/datum/anvil_recipe/weapons/steel/greatsword
	name = "Greatsword, Iron (+2 Iron)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_sword
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/greatsword/iron

/datum/anvil_recipe/weapons/iron/claymore
	name = "Claymore, Iron (+2 Iron)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_sword
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/greatsword/zwei

/datum/anvil_recipe/weapons/iron/axe
	name = "Axe, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_axe
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut

/datum/anvil_recipe/weapons/iron/greataxe
	name = "Greataxe, Iron (+1 Iron, +1 Small Log)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_axe
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe

/datum/anvil_recipe/weapons/iron/cudgel
	name = "Cudgel, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/cudgel

/datum/anvil_recipe/weapons/iron/mace
	name = "Mace, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace

/datum/anvil_recipe/weapons/iron/warhammer
	name = "Warhammer, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/warhammer
	i_type = "Weapons"

/datum/anvil_recipe/weapons/iron/spear
	name = "Spear, Iron (+1 Small Log)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear

/datum/anvil_recipe/weapons/iron/bardiche
	name = "Bardiche, Iron (+1 Iron, +1 Small Log)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd/bardiche

/datum/anvil_recipe/weapons/iron/lucerne
	name = "Lucerne, Iron (+1 Iron, +1 Small Log)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/eaglebeak/lucerne

/datum/anvil_recipe/weapons/iron/polemace
	name = "Goedendag, Iron (+1 Small Log)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden

/datum/anvil_recipe/weapons/iron/tossblade
	name = "Tossblades, Iron (x4)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife
	createditem_num = 4

/datum/anvil_recipe/weapons/iron/javelin
	name = "Javelin, Iron (+1 Small Log) (x2)"
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin
	createditem_num = 2

/datum/anvil_recipe/weapons/iron/maul
	name = "Maul (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/mace/maul
	craftdiff = 4

/// STEEL WEAPONS
/datum/anvil_recipe/weapons/steel/dagger
	name = "Dagger, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel
	createditem_num = 1

/datum/anvil_recipe/weapons/steel/daggerparrying
	name = "Parrying Dagger, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_knife
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying

/datum/anvil_recipe/weapons/steel/katar
	name = "Katar, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/katar

/datum/anvil_recipe/weapons/steel/punchdagger
	name = "Punch Dagger"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/katar/punchdagger

/datum/anvil_recipe/weapons/steel/steelknuckle
	name = "Knuckles, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/knuckles

/datum/anvil_recipe/weapons/steel/hurlbat
	name = "Hurlbat"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_axe
	created_item = /obj/item/rogueweapon/stoneaxe/hurlbat

/datum/anvil_recipe/weapons/steel/rapier
	name = "Rapier, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/rapier

/datum/anvil_recipe/weapons/steel/cutlass
	name = "Cutlass, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/cutlass

/datum/anvil_recipe/weapons/steel/swordshort
	name = "Shortsword, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short

/datum/anvil_recipe/weapons/steel/falchion
	name = "Falchion, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short/falchion

/datum/anvil_recipe/weapons/steel/messer
	name = "Messer, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short/messer

/datum/anvil_recipe/weapons/steel/sword
	name = "Arming Sword, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword

/datum/anvil_recipe/weapons/steel/saber
	name = "Sabre, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/sabre

/datum/anvil_recipe/weapons/steel/flail
	name = "Flail, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/flail/sflail

/datum/anvil_recipe/weapons/steel/longsword
	name = "Longsword, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long

/datum/anvil_recipe/weapons/steel/trainingsword
	name = "Training Sword, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/training
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/kriegmesser
	name = "Kriegmesser, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser

/datum/anvil_recipe/weapons/steel/battleaxe
	name = "Battle Axe, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/stoneaxe/battle

/datum/anvil_recipe/weapons/steel/combatknife
	name = "Combat Knife, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_knife
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/combat

/datum/anvil_recipe/weapons/steel/mace
	name = "Mace, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/steel

/datum/anvil_recipe/weapons/steel/swarhammer
	name = "Warhammer, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/warhammer/steel
	i_type = "Weapons"

/datum/anvil_recipe/weapons/steel/greatsword
	name = "Greatsword, Steel (+2 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/greatsword

/datum/anvil_recipe/weapons/steel/flamb
	name = "Flamberge, Steel (+2 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge

/datum/anvil_recipe/weapons/steel/estoc
	name = "Estoc, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/estoc

/datum/anvil_recipe/weapons/steel/axe
	name = "Axe, Steel (+1 Stick)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel

/datum/anvil_recipe/weapons/steel/greataxe
	name = "Greataxe, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/steel

/datum/anvil_recipe/weapons/steel/greataxe/knight
	name = "Poleaxe, Steel (+1 Steel, +1 Small Log, +1 Cloth)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small, /obj/item/natural/cloth)
	created_item = /obj/item/rogueweapon/greataxe/steel/knight

/datum/anvil_recipe/weapons/steel/greataxe/doublehead
	name = "Double-Headed Greataxe, Steel (+2 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/steel/doublehead

/datum/anvil_recipe/weapons/steel/billhook
	name = "Billhook, Steel (+1 Small Log)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/billhook

/datum/anvil_recipe/weapons/steel/halberd
	name = "Halberd, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd

/datum/anvil_recipe/weapons/steel/eaglebeak
	name = "Eagle's Beak (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/eaglebeak

/datum/anvil_recipe/weapons/steel/grandmace
	name = "Grand Mace, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel

/datum/anvil_recipe/weapons/steel/partizan
	name = "Partizan, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/partizan

/datum/anvil_recipe/weapons/steel/naginata
	name = "Naginata, Steel (+1 Big Log)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/grown/log/tree/) //looong spear
	created_item = /obj/item/rogueweapon/spear/naginata

/datum/anvil_recipe/weapons/steel/boarspear
	name = "Boar Spear, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/boar

/datum/anvil_recipe/weapons/steel/lance
	name = "Lance, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/lance

/datum/anvil_recipe/weapons/steel/tossblade
	name = "Tossblade, Steel (x4)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel
	createditem_num = 4

/datum/anvil_recipe/weapons/steel/javelin
	name = "Javelin, Steel (+1 Small Log) (x2)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel
	createditem_num = 2

/datum/anvil_recipe/weapons/steel/fishspear
	name = "Fishing Spear, Steel (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/fishspear

/datum/anvil_recipe/weapons/steel/rhomphaia
	name = "Rhomphaia, Steel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/rhomphaia

/datum/anvil_recipe/weapons/steel/falx
	name = "Falx, Steel"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/falx

/datum/anvil_recipe/weapons/steel/maul
	name = "Grand Maul (+2 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/maul/grand

// GOLD

/datum/anvil_recipe/weapons/decorated/sword
	name = "Sword, Decorated (+1 Steel Sword)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/sword)
	created_item = /obj/item/rogueweapon/sword/decorated

/datum/anvil_recipe/weapons/decorated/saber
	name = "Sabre, Decorated (+1 Steel Sabre)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/sword/sabre)
	created_item = /obj/item/rogueweapon/sword/sabre/dec

/datum/anvil_recipe/weapons/decorated/rapier
	name = "Rapier, Decorated (+1 Steel Rapier)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/sword/rapier)
	created_item = /obj/item/rogueweapon/sword/rapier/dec

/datum/anvil_recipe/weapons/decorated/longsword
	name = "Longsword, Decorated (+1 Steel Longsword)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/sword/long)
	created_item = /obj/item/rogueweapon/sword/long/dec


// SILVER

/datum/anvil_recipe/weapons/silver/elfsaber
	name = "Sabre, Elvish (+1 Gold)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/rogueweapon/sword/sabre/elf

/datum/anvil_recipe/weapons/silver/elfdagger
	name = "Dagger, Elvish"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish

/datum/anvil_recipe/weapons/silver/dagger
	name = "Dagger, Silver (+1 Silver)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver

/datum/anvil_recipe/weapons/silver/shortsword
	name = "Shortsword, Silver (+1 Silver)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/short/silver

/datum/anvil_recipe/weapons/silver/sword
	name = "Arming Sword, Silver (+2 Silver)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/silver

/datum/anvil_recipe/weapons/silver/rapier
	name = "Rapier, Silver (+2 Silver)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/rapier/silver

/datum/anvil_recipe/weapons/silver/longsword
	name = "Longsword, Silver (+3 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/silver

/datum/anvil_recipe/weapons/silver/broadsword
	name = "Broadsword, Silver (+3 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser/silver

/datum/anvil_recipe/weapons/silver/greatsword
	name = "Greatsword, Silver (+4 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greatsword/silver

/datum/anvil_recipe/weapons/silver/waraxe
	name = "War Axe, Silver (+2 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/silver

/datum/anvil_recipe/weapons/silver/poleaxe
	name = "Poleaxe, Silver (+3 Silver, +2 Small Logs)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/silver

/datum/anvil_recipe/weapons/silver/mace
	name = "Mace, Silver (+2 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/steel/silver

/datum/anvil_recipe/weapons/silver/warhammer
	name = "Warhammer, Silver (+2 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/silver

/datum/anvil_recipe/weapons/silver/quarterstaff
	name = "Quarterstaff, Silver (+1 Silver, +3 Small Logs)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/woodstaff/quarterstaff/silver

/datum/anvil_recipe/weapons/silver/spear
	name = "Spear, Silver (+1 Silver, +3 Small Logs)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/silver

/datum/anvil_recipe/weapons/silver/morningstar
	name = "Morningstar, Silver (+3 Silver, +1 Chain)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/rope/chain)
	created_item = /obj/item/rogueweapon/flail/sflail/silver

/datum/anvil_recipe/weapons/silver/whip
	name = "Whip, Silver (+1 Leather Whip)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/rogueweapon/whip)
	created_item = /obj/item/rogueweapon/whip/silver

/datum/anvil_recipe/weapons/silver/tossblade
	name = "Tossblades, Silver (+1 Silver)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/silver
	createditem_num = 4

/datum/anvil_recipe/weapons/silver/javelin
	name = "Javelins, Silver (+1 Silver, Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/silver
	createditem_num = 2


// SHIELDS

/datum/anvil_recipe/weapons/steel/kiteshield
	name = "Kite Shield (+1 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal

/datum/anvil_recipe/weapons/alloy/shield
	name = "Shield, Decrepit (+1 Alloy, +1 Cured Leather)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/alloy

/datum/anvil_recipe/weapons/alloy/shield
	name = "Shield, Ancient (+1 Purified Alloy, +1 Cured Leather)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/palloy

/datum/anvil_recipe/weapons/iron/towershield
	name = "Tower Shield (+1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/shield/tower

/datum/anvil_recipe/weapons/steel/buckler
	name = "Buckler (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/shield/buckler

/datum/anvil_recipe/weapons/iron/roundshield
	name = "Shield, Iron (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/shield/iron

// CROSSBOW

/datum/anvil_recipe/weapons/steel/xbow
	name = "Crossbow (+1 Small Log, +1 Fiber)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/natural/fibers)
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow

/datum/anvil_recipe/weapons/iron/bolts
	name = "Crossbow Bolts (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/aalloy/bolts
	name = "Bolts, Decrepit (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/aalloy
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/paalloy/bolts
	name = "Bolts, Ancient (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/paalloy
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/iron/bluntbolts
	name = "Bolts, Blunt (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/blunt
	createditem_num = 10
	i_type = "Ammo"

// BOW

/datum/anvil_recipe/weapons/iron/arrows
	name = "Broadhead Arrows, Iron (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/iron
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/aalloy/arrows
	name = "Broadhead Arrows, Decrepit (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/iron/aalloy
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/steel/arrows
	name = "Bodkin Arrows, Steel (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/steel
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/paalloy/arrows
	name = "Bodkin Arrows, Ancient (+2 Stick) (x10)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/steel/paalloy
	createditem_num = 10
	i_type = "Ammo"


// SLING

/datum/anvil_recipe/weapons/iron/slingbullets
	name = "Sling Bullets, Iron (x10)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/bronze/slingbullets
	name = "Sling Bullets, Bronze (x10)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/aalloy/slingbullets
	name = "Sling Bullets, Decrepit (x10)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/aalloy
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/paalloy/slingbullets
	name = "Sling Bullets, Ancient (x10)"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/paalloy
	createditem_num = 10
	i_type = "Ammo"


// UNIQUE

/datum/anvil_recipe/valuables/iron/execution
	name = "Executioner's Sword (+2 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/sword/long/exe
	i_type = "Weapons"


// BLACKSTEEL


/datum/anvil_recipe/weapons/blacksteel/arming
	name = "Blacksteel Arming Sword"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/rogueweapon/sword/blacksteel

/datum/anvil_recipe/weapons/blacksteel/flamberge
	name = "Blacksteel Flamberge (+1 Blacksteel, +1 Rontz)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/ruby)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel

/datum/anvil_recipe/weapons/blacksteel/decsword
	name = "Blacksteel Sword, Decorated (+1 Steel Sword)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/rogueweapon/sword)
	created_item = /obj/item/rogueweapon/sword/decorated/blacksteel
	craftdiff = 5

//Church Weapons forged from Holy Steel

// HOLY STEEL

/datum/anvil_recipe/weapons/holysteel/church_longsword
	name = "Longsword, Templaric"
	req_bar = /obj/item/ingot/steelholy
	created_item = /obj/item/rogueweapon/sword/long/church
	i_type = "Weapons"

/datum/anvil_recipe/weapons/holysteel/church_spear
	name = "Spear, Templaric (+1 Holy Steel)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/spear/holysee
	i_type = "Weapons"

/datum/anvil_recipe/weapons/holysteel/decasword
	name = "Longsword, Decablessed (+1 Holy Steel)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/sword/long/undivided
	i_type = "Weapons"

/datum/anvil_recipe/weapons/holysteel/decashield
	name = "Shield, Decablessed (+1 Holy Steel)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/shield/tower/holysee
	i_type = "Weapons"

/datum/anvil_recipe/weapons/holysteel/malum_sword
	name = "Malumite Flamberge (+2 Holy Steel)"
	req_bar = /obj/item/ingot/steelholy
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge/malum
	i_type = "Weapons"

// BLESSED SILVER

/datum/anvil_recipe/weapons/psy/axe
	name = "Psydonic War Axe (+1 Blessed Silver, +1 Stick)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/stoneaxe/battle/psyaxe
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/stick)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/mace
	name = "Psydonic Mace (+1 Blessed Silver, +1 Stick)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/mace/goden/psymace
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/stick)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/spear
	name = "Psydonic Spear (+1 Blessed Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/spear/psyspear
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/dagger
	name = "Psydonic Dagger"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/shortsword
	name = "Psydonic Shortsword"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/sword/short/psy
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/katar
	name = "Psydonic Katar"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/katar/psydon
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/knuckles
	name = "Psydonic Knuckledusters"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/knuckles/psydon
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/cudgel
	name = "Psydonic Handmace"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/mace/cudgel/psy
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/halberd
	name = "Psydonic Halberd (+2 Blessed Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/halberd/psyhalberd
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/gsword
	name = "Psydonic Greatsword (+2 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/greatsword/psygsword
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/sword
	name = "Psydonic Longsword (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/sword/long/psysword
	additional_items = list(/obj/item/ingot/silverblessed)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/whip
	name = "Psydonic Whip (+3 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/rogueweapon/whip/psywhip_lesser
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	i_type = "Weapons"

/// BLESSED SILVER, BULLION VARIANTS - FALLBACK

/datum/anvil_recipe/weapons/psy/axe/inq
	name = "Psydonic War Axe (+1 Blessed Silver, +1 Stick)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/stoneaxe/battle/psyaxe
	additional_items = list(/obj/item/ingot/silverblessed/bullion, /obj/item/grown/log/tree/stick)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/mace/inq
	name = "Psydonic Mace (+1 Blessed Silver, +1 Stick)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/mace/goden/psymace
	additional_items = list(/obj/item/ingot/silverblessed/bullion, /obj/item/grown/log/tree/stick)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/spear/inq
	name = "Psydonic Spear (+1 Blessed Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/spear/psyspear
	additional_items = list(/obj/item/ingot/silverblessed/bullion, /obj/item/grown/log/tree/small)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/dagger/inq
	name = "Psydonic Dagger"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/shortsword/inq
	name = "Psydonic Shortsword"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/sword/short/psy
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/katar/inq
	name = "Psydonic Katar"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/katar/psydon
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/knuckles/inq
	name = "Psydonic Knuckles"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/knuckles/psydon
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/cudgel/inq
	name = "Psydonic Handmace"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/mace/cudgel/psy
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/halberd/inq
	name = "Psydonic Halberd (+2 Blessed Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/halberd/psyhalberd
	additional_items = list(/obj/item/ingot/silverblessed/bullion, /obj/item/ingot/silverblessed/bullion, /obj/item/grown/log/tree/small)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/gsword/inq
	name = "Psydonic Greatsword (+2 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/greatsword/psygsword
	additional_items = list(/obj/item/ingot/silverblessed/bullion, /obj/item/ingot/silverblessed/bullion)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/sword/inq
	name = "Psydonic Longsword (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/sword/long/psysword
	additional_items = list(/obj/item/ingot/silverblessed/bullion)
	i_type = "Weapons"

/datum/anvil_recipe/weapons/psy/whip/inq
	name = "Psydonic Whip (+3 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/rogueweapon/whip/psywhip_lesser
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	i_type = "Weapons"
