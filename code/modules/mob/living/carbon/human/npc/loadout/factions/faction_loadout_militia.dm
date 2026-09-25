//** ARCHETYPES **//

/datum/npc_archetype/militia
	name = "Militia"
	job = "Militia"
	category = FACTION_STATION
	body = /datum/npc_body/northern_commoner/soldier/militia
	statpack = /datum/npc_statpack/rabble
	armor_training = ARMOR_CLASS_MEDIUM
	melee = SKILL_LEVEL_APPRENTICE
	brawl = SKILL_LEVEL_APPRENTICE
	survival = SKILL_LEVEL_JOURNEYMAN
	loadouts = list(
		/datum/npc_loadout/armor/light/gambeson/helmeted,
		/datum/npc_loadout/kit/militia_flavor,
		/datum/npc_loadout/weapon/militia_melee,
	)

/datum/npc_archetype/militia/deserter
	name = "Militia Deserter"
	category = FACTION_BANDITS
	faction_tag = "bandits"
	threat_point = THREAT_MODERATE
	body = /datum/npc_body/northern_commoner/soldier/militia/deserter

//** BODY **//

/datum/npc_body/northern_commoner/soldier/militia
	aggro_lines_file = "strings/rt/highwaymanaggrolines.txt"
	death_line_chance = 25

/datum/npc_body/northern_commoner/soldier/militia/deserter/get_head_sellprice()
	return HEAD_BOUNTY_GOBLIN

//** FLAVOR **//

/datum/npc_loadout/kit/militia_flavor
	cloak = /obj/item/clothing/cloak/tabard/stabard/guard
	pants = list(
		/obj/item/clothing/under/roguetown/trou/leather,
		/obj/item/clothing/under/roguetown/trou,
	)
	belt = list(
		/obj/item/storage/belt/rogue/leather = 90,
		/obj/item/storage/belt/rogue/leather/knifebelt/iron = 10,
	)
	neck = list(
		/obj/item/clothing/neck/roguetown/leather = 19,
		/obj/item/clothing/neck/roguetown/coif/heavypadding = 19,
		/obj/item/storage/belt/rogue/pouch/bombs = 2,
	)
	gloves = list(
		/obj/item/clothing/gloves/roguetown/fingerless_leather = 65,
		/obj/item/clothing/gloves/roguetown/angle = 35,
	)

//** WEAPONS **//

/datum/npc_loadout/weapon/militia_melee
	weapons = list(
		list(/obj/item/rogueweapon/woodstaff/militia),
		list(/obj/item/rogueweapon/greataxe/militia),
		list(/obj/item/rogueweapon/spear/militia),
		list(/obj/item/rogueweapon/spear, /obj/item/rogueweapon/shield/wood),
		list(/obj/item/rogueweapon/scythe),
		list(/obj/item/rogueweapon/pick/militia),
		list(/obj/item/rogueweapon/sword/falchion/militia),
		list(/obj/item/rogueweapon/mace/cudgel),
		list(/obj/item/rogueweapon/mace/goden),
		list(/obj/item/rogueweapon/stoneaxe/woodcut, /obj/item/rogueweapon/shield/wood),
		list(/obj/item/rogueweapon/flail/peasantwarflail),
		list(/obj/item/rogueweapon/huntingknife/idagger, /obj/item/rogueweapon/shield/wood),
	)
