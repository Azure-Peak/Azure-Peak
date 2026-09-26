//** ARCHETYPES **//

/datum/npc_archetype/drow
	abstract_type = /datum/npc_archetype/drow
	job = "Drow Raider"
	category = FACTION_DROW
	faction_tag = "underdark"
	// Elven quickness, and hardier than the light role assumes since they raid rather than skirmish.
	stat_modifiers = list("speed" = 1, "constitution" = 2)
	melee = SKILL_LEVEL_EXPERT
	brawl = SKILL_LEVEL_EXPERT
	survival = SKILL_LEVEL_APPRENTICE

/datum/npc_archetype/drow/raider
	name = "Drow Raider"
	statpack = /datum/npc_statpack/light/t2
	loadouts = list(
		/datum/npc_loadout/armor/light/drow,
		/datum/npc_loadout/kit/drow_flavor,
		/datum/npc_loadout/weapon/drow_melee,
	)

/datum/npc_archetype/drow/archer
	name = "Drow Raider"
	statpack = /datum/npc_statpack/marksman/t2
	skills = list(/datum/skill/combat/bows = SKILL_LEVEL_EXPERT)
	loadouts = list(
		/datum/npc_loadout/armor/light/drow,
		/datum/npc_loadout/kit/drow_flavor/archer,
		/datum/npc_loadout/weapon/drow_bow,
	)
	ai_controller = /datum/ai_controller/human_npc/archer

/datum/npc_archetype/drow/scourge
	name = "Drow Scourge"
	job = "Drow Scourge"
	statpack = /datum/npc_statpack/light/t4
	traits = list(TRAIT_BADTRAINER)
	skills = list(/datum/skill/combat/whipsflails = SKILL_LEVEL_MASTER)
	loadouts = list(
		/datum/npc_loadout/armor/light/drow,
		/datum/npc_loadout/kit/drow_flavor/scourge,
		/datum/npc_loadout/weapon/drow_scourge,
	)

//** ARMOR **//

/datum/npc_loadout/armor/light/drow
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest/drowraider
	shirt = /obj/item/clothing/suit/roguetown/shirt/shadowshirt/elflock/drowraider
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/drowraider
	gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced

//** FLAVOR **//

/datum/npc_loadout/kit/drow_flavor
	cloak = list(
		/obj/item/clothing/cloak/raincloak/mortus = 13,
		/obj/item/clothing/cloak/half/rider/red = 13,
		/obj/item/clothing/cloak/half = 14,
		NPC_NOTHING = 60,
	)
	mask = list(
		/obj/item/clothing/mask/rogue/facemask = 40,
		/obj/item/clothing/mask/rogue/shepherd/shadowmask/delf = 40,
		/obj/item/clothing/mask/rogue/xylixmask = 20,
	)
	neck = list(
		/obj/item/clothing/neck/roguetown/coif/heavypadding = 34,
		/obj/item/clothing/neck/roguetown/leather = 33,
		/obj/item/clothing/neck/roguetown/gorget = 33,
	)
	head = list(
		/obj/item/clothing/head/roguetown/helmet/kettle/iron = 66,
		/obj/item/clothing/head/roguetown/helmet/leather/volfhelm = 34,
	)

/datum/npc_loadout/kit/drow_flavor/archer
	mask = /obj/item/clothing/mask/rogue/facemask
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	head = /obj/item/clothing/head/roguetown/helmet/leather

/datum/npc_loadout/kit/drow_flavor/scourge
	mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask/delf
	neck = /obj/item/clothing/neck/roguetown/gorget
	head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/maille/iron

//** WEAPONS **//

/datum/npc_loadout/weapon/drow_melee
	traits = list(TRAIT_DUALWIELDER)
	weapons = list(
		list(/obj/item/rogueweapon/whip),
		list(/obj/item/rogueweapon/sword/falx/stalker, /obj/item/rogueweapon/sword/falx/stalker, 100),
		list(/obj/item/rogueweapon/huntingknife/idagger/steel/stalker, /obj/item/rogueweapon/huntingknife/idagger/steel/stalker, 100),
	)

/datum/npc_loadout/weapon/drow_bow
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/stalker
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backl = /obj/item/quiver/npc

/datum/npc_loadout/weapon/drow_scourge
	r_hand = /obj/item/rogueweapon/whip/spiderwhip
