//** ARCHETYPES **//

/datum/npc_archetype/dwarfskeleton
	abstract_type = /datum/npc_archetype/dwarfskeleton
	job = "Dwarf Skeleton"
	category = FACTION_DUNDEAD
	faction_tag = "undead"
	stat_modifiers = list("constitution" = -2, "willpower" = 2, "intelligence" = -6)

/datum/npc_archetype/dwarfskeleton/warrior
	name = "Dwarf Skeleton"
	threat_point = THREAT_ELITE
	statpack = /datum/npc_statpack/line/t3
	melee = SKILL_LEVEL_JOURNEYMAN
	brawl = SKILL_LEVEL_JOURNEYMAN
	survival = SKILL_LEVEL_APPRENTICE
	loadouts = list(
		/datum/npc_loadout/kit/dwarf_skeleton,
		/datum/npc_loadout/weapon/dwarf_skeleton,
	)

/datum/npc_archetype/dwarfskeleton/knight
	name = "Dwarf Skeleton Knight"
	threat_point = THREAT_ELITE
	statpack = /datum/npc_statpack/heavy/t4
	melee = SKILL_LEVEL_EXPERT
	brawl = SKILL_LEVEL_EXPERT
	survival = SKILL_LEVEL_APPRENTICE
	loadouts = list(
		/datum/npc_loadout/kit/dwarf_skeleton/knight,
		/datum/npc_loadout/weapon/dwarf_skeleton/knight,
	)

//** GEAR **//

/datum/npc_loadout/kit/dwarf_skeleton
	cloak = list(
		/obj/item/clothing/cloak/raincloak/furcloak/black = 50,
		/obj/item/clothing/cloak/raincloak/mortus = 50,
	)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/copper
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper
	shirt = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson = 54,
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = 40,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 6,
	)
	pants = list(
		/obj/item/clothing/under/roguetown/chainlegs/iron = 60,
		/obj/item/clothing/under/roguetown/heavy_leather_pants = 40,
	)
	head = list(
		/obj/item/clothing/head/roguetown/helmet = 50,
		/obj/item/clothing/head/roguetown/helmet/horned = 50,
	)
	neck = /obj/item/clothing/neck/roguetown/gorget
	mask = list(
		/obj/item/clothing/mask/rogue/facemask = 60,
		/obj/item/clothing/mask/rogue/facemask/copper = 36,
		/obj/item/clothing/mask/rogue/facemask/steel = 4,
	)
	shoes = list(
		/obj/item/clothing/shoes/roguetown/boots/maille/copper = 60,
		/obj/item/clothing/shoes/roguetown/boots/maille/bronze = 40,
	)
	gloves = list(
		/obj/item/clothing/gloves/roguetown/chain/iron = 90,
		/obj/item/clothing/gloves/roguetown/knuckles/bronze = 10,
	)

/datum/npc_loadout/kit/dwarf_skeleton/knight
	cloak = /obj/item/clothing/cloak/tabard/stabard/dungeon
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/platelegs
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	gloves = /obj/item/clothing/gloves/roguetown/plate
	belt = /obj/item/storage/belt/rogue/leather

//** WEAPONS **//

/datum/npc_loadout/weapon/dwarf_skeleton
	weapons = list(
		list(/obj/item/rogueweapon/spear/bronze),
		list(/obj/item/rogueweapon/sword/short/gladius, /obj/item/rogueweapon/shield/wood, 100),
	)

/datum/npc_loadout/weapon/dwarf_skeleton/knight
	weapons = list(
		list(/obj/item/rogueweapon/greataxe),
	)
