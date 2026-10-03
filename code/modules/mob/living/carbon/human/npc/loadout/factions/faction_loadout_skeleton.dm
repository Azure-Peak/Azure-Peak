//** ARCHETYPES **//

/datum/npc_archetype/skeleton
	abstract_type = /datum/npc_archetype/skeleton
	stat_modifiers = list("constitution" = -2, "willpower" = 2, "intelligence" = -6)
	category = FACTION_UNDEAD
	faction_tag = "undead"

/datum/npc_archetype/skeleton/supereasy
	name = "Skeleton"
	threat_point = THREAT_LOW
	statpack = /datum/npc_statpack/line/t0
	melee = SKILL_LEVEL_NOVICE
	brawl = SKILL_LEVEL_NOVICE
	survival = SKILL_LEVEL_NOVICE
	skills = list(/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE)
	loadouts = list(
		/datum/npc_loadout/kit/skeleton_amulet,
		/datum/npc_loadout/kit/skeleton_scavenged,
		list(
			/datum/npc_loadout/kit/skeleton_rags = 1,
			/datum/npc_loadout/kit/skeleton_workervest = 1,
		),
		/datum/npc_loadout/weapon/skeleton_scavenged,
	)

/datum/npc_archetype/skeleton/easy
	name = "Skeleton Footsoldier"
	threat_point = THREAT_MODERATE
	statpack = /datum/npc_statpack/line/t0
	melee = SKILL_LEVEL_APPRENTICE
	brawl = SKILL_LEVEL_APPRENTICE
	survival = SKILL_LEVEL_APPRENTICE
	loadouts = list(
		/datum/npc_loadout/armor/medium/aalloy,
		/datum/npc_loadout/kit/skeleton_amulet,
		/datum/npc_loadout/kit/skeleton_tabard,
		list( //50% chance of a decrepit helm w/coif
			/datum/npc_loadout/armor/medium/aalloy_helm = 1,
			NPC_NOTHING = 1,
		),
		/datum/npc_loadout/weapon/skeleton_footsoldier,
	)

/datum/npc_archetype/skeleton/pirate
	abstract_type = /datum/npc_archetype/skeleton/pirate
	threat_point = THREAT_MODERATE
	melee = SKILL_LEVEL_APPRENTICE
	brawl = SKILL_LEVEL_APPRENTICE
	survival = SKILL_LEVEL_APPRENTICE
	skills = list(/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT) //YARR

/datum/npc_archetype/skeleton/pirate/mixed
	name = "Skeleton Pirate"
	variants = list(
		/datum/npc_archetype/skeleton/pirate/knives = 1,
		/datum/npc_archetype/skeleton/pirate/sabre = 1,
	)

/datum/npc_archetype/skeleton/pirate/knives
	name = "Skeleton Pirate (Knives)"
	statpack = /datum/npc_statpack/line/t0
	loadouts = list(
		/datum/npc_loadout/kit/skeleton_pirate,
		/datum/npc_loadout/weapon/skeleton_pirate_knives,
	)

/datum/npc_archetype/skeleton/pirate/sabre
	name = "Skeleton Pirate (Sabre)"
	statpack = /datum/npc_statpack/line/t0
	loadouts = list(
		/datum/npc_loadout/kit/skeleton_pirate,
		/datum/npc_loadout/weapon/skeleton_pirate_sabre,
	)

/datum/npc_archetype/skeleton/medium
	name = "Skeleton Soldier"
	threat_point = THREAT_LOW
	statpack = /datum/npc_statpack/line/t1
	melee = SKILL_LEVEL_JOURNEYMAN
	brawl = SKILL_LEVEL_JOURNEYMAN
	survival = SKILL_LEVEL_APPRENTICE
	skills = list(/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN)
	loadouts = list(
		/datum/npc_loadout/armor/medium/aalloy_soldier,
		/datum/npc_loadout/kit/skeleton_amulet,
		/datum/npc_loadout/kit/skeleton_tabard/soldier,
		list( //20% chance to have overpowered levels of aurafarming
			/datum/npc_loadout/kit/skeleton_hijab = 1,
			NPC_NOTHING = 4,
		),
		list(
			/datum/npc_loadout/weapon/skeleton_soldier_sandals = 3,
			/datum/npc_loadout/weapon/skeleton_soldier_boots = 2,
		),
	)

// This combines the khopesh and withered dreadknight
/datum/npc_archetype/skeleton/hard
	abstract_type = /datum/npc_archetype/skeleton/hard
	threat_point = THREAT_TOUGH
	traits = list(TRAIT_NORUN) //I think the AI respects this, should stop them leaping or w/e which can cause them to lose their weapons.
	melee = SKILL_LEVEL_EXPERT
	brawl = SKILL_LEVEL_EXPERT
	skills = list(/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT)

/datum/npc_archetype/skeleton/hard/mixed
	name = "Skeleton Dreadnought"
	variants = list(
		/datum/npc_archetype/skeleton/hard/khopesh = 1,
		/datum/npc_archetype/skeleton/hard/withered = 1,
	)

/datum/npc_archetype/skeleton/hard/khopesh
	name = "Skeleton Dreadnought (Khopesh)"
	statpack = /datum/npc_statpack/light/t2
	survival = SKILL_LEVEL_EXPERT //Needed at expert else we lose our duel blades by falling over in water cause heavy
	loadouts = list(
		/datum/npc_loadout/armor/heavy/aalloy,
		/datum/npc_loadout/kit/skeleton_dreadnought/khopesh,
		list(
			/datum/npc_loadout/armor/heavy/aalloy_cuirass = 60,
			/datum/npc_loadout/armor/heavy/aalloy_hauberk = 40,
		),
		/datum/npc_loadout/weapon/skeleton_khopesh,
	)

/datum/npc_archetype/skeleton/hard/withered
	name = "Skeleton Dreadnought (Withered)"
	statpack = /datum/npc_statpack/heavy/t2
	survival = SKILL_LEVEL_APPRENTICE //Tanky but falls over in water
	loadouts = list(
		/datum/npc_loadout/armor/heavy/aalloy/plated,
		/datum/npc_loadout/kit/skeleton_dreadnought/withered,
		list(
			/datum/npc_loadout/armor/heavy/aalloy_plate = 60,
			/datum/npc_loadout/armor/heavy/aalloy_hauberk = 40,
		),
		/datum/npc_loadout/weapon/skeleton_withered,
	)

/datum/npc_archetype/skeleton/archer
	name = "Skeleton Archer"
	threat_point = THREAT_LOW
	statpack = /datum/npc_statpack/marksman/t0
	melee = SKILL_LEVEL_APPRENTICE
	brawl = SKILL_LEVEL_APPRENTICE
	survival = SKILL_LEVEL_APPRENTICE
	skills = list(/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN)
	ai_controller = /datum/ai_controller/human_npc/archer
	loadouts = list(
		/datum/npc_loadout/armor/medium/aalloy_archer,
		/datum/npc_loadout/kit/skeleton_amulet,
		/datum/npc_loadout/kit/skeleton_tabard,
		/datum/npc_loadout/weapon/skeleton_archer,
	)

// For Duke Manor & Zizo Manor - Ground based spread, so no pirate in pool!
/datum/npc_archetype/skeleton/mediumspread
	name = "Skeleton (Mixed)"
	threat_point = THREAT_MODERATE
	variants = list(
		/datum/npc_archetype/skeleton/supereasy = 1,
		/datum/npc_archetype/skeleton/easy = 1,
		/datum/npc_archetype/skeleton/medium = 1,
		/datum/npc_archetype/skeleton/hard/mixed = 1,
		/datum/npc_archetype/skeleton/archer = 1,
	)

// For underdark lich-miniboss + contracts - different spread
/datum/npc_archetype/skeleton/mediumspread/lich
	name = "Lich Skeleton (Mixed)"
	variants = list(
		/datum/npc_archetype/skeleton/supereasy = 1,
		/datum/npc_archetype/skeleton/easy = 1,
		/datum/npc_archetype/skeleton/medium = 1,
		/datum/npc_archetype/skeleton/hard/mixed = 1,
	)

// for Lich Dungeon
/datum/npc_archetype/skeleton/hardspread
	name = "Skeleton Dreadnought (Mixed)"
	threat_point = THREAT_TOUGH
	variants = list(
		/datum/npc_archetype/skeleton/hard/mixed = 2,
		/datum/npc_archetype/skeleton/medium = 1,
		/datum/npc_archetype/skeleton/pirate/mixed = 1,
		/datum/npc_archetype/skeleton/archer = 1,
	)

/datum/npc_archetype/skeleton/bogguard
	name = "Bog Skeleton"
	threat_point = THREAT_MODERATE
	statpack = /datum/npc_statpack/line/t1
	armor_training = ARMOR_CLASS_MEDIUM
	melee = SKILL_LEVEL_APPRENTICE
	loadouts = list(
		/datum/npc_loadout/kit/bog_skeleton,
		/datum/npc_loadout/weapon/bog_skeleton,
	)

/datum/npc_archetype/skeleton/bogguard/archer
	name = "Bog Skeleton Archer"
	threat_point = THREAT_LOW
	statpack = /datum/npc_statpack/marksman/t1
	skills = list(/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN)
	ai_controller = /datum/ai_controller/human_npc/archer
	loadouts = list(
		/datum/npc_loadout/kit/bog_skeleton,
		/datum/npc_loadout/kit/bog_skeleton_archer,
		/datum/npc_loadout/weapon/bog_skeleton,
		/datum/npc_loadout/weapon/bog_skeleton_archer,
	)

/datum/npc_archetype/skeleton/bogguard/master
	name = "Bog Skeleton Master"
	statpack = /datum/npc_statpack/line/t3
	armor_training = ARMOR_CLASS_HEAVY
	melee = SKILL_LEVEL_JOURNEYMAN
	brawl = SKILL_LEVEL_APPRENTICE
	athletics = SKILL_LEVEL_EXPERT
	loadouts = list(
		/datum/npc_loadout/kit/bog_skeleton,
		/datum/npc_loadout/kit/bog_skeleton_master,
		/datum/npc_loadout/weapon/bog_skeleton_master,
	)

/datum/npc_archetype/skeleton/fallenduke
	name = "The Fallen 'Duke'"
	threat_point = THREAT_ELITE
	stat_modifiers = null
	statpack = /datum/npc_statpack/skeleton/fallenduke
	melee = SKILL_LEVEL_MASTER
	brawl = SKILL_LEVEL_MASTER
	survival = SKILL_LEVEL_APPRENTICE
	skills = list(/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT)
	loadouts = list(
		/datum/npc_loadout/armor/heavy/aalloy/plated/guard,
		/datum/npc_loadout/armor/heavy/aalloy_plate,
		/datum/npc_loadout/kit/fallen_duke,
		/datum/npc_loadout/weapon/fallen_duke,
	)

/datum/npc_archetype/skeleton/lich
	name = "Lich Knight"
	threat_point = THREAT_ELITE
	stat_modifiers = null
	statpack = /datum/npc_statpack/skeleton/lich
	patron = /datum/patron/inhumen/zizo
	melee = SKILL_LEVEL_JOURNEYMAN
	brawl = SKILL_LEVEL_APPRENTICE
	athletics = SKILL_LEVEL_EXPERT
	crafting = SKILL_LEVEL_NOVICE
	skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)
	loadouts = list(
		/datum/npc_loadout/armor/heavy/black_knight,
		/datum/npc_loadout/weapon/lich_knight,
	)

//Unique skilled NPC summons exclusive to necromancers, these guys are a menace to fight.
/datum/npc_archetype/skeleton/summon
	name = "Summoned Skeleton"
	statpack = /datum/npc_statpack/line/t1
	armor_training = ARMOR_CLASS_MEDIUM
	traits = list(TRAIT_NOZIZORECRUIT) //Ask the necromancer for a gravemark
	melee = SKILL_LEVEL_JOURNEYMAN //Good parrying, still will crumble to numbers. Intended so lone advs/garrison can't just solo through a necromancer's summons with ease.
	loadouts = list(
		/datum/npc_loadout/armor/medium/iron_chain,
		/datum/npc_loadout/kit/skeleton_summon,
		/datum/npc_loadout/weapon/skeleton_summon,
	)

//** STATS **//















/datum/npc_statpack/skeleton/fallenduke
	strength = 15
	speed = 12
	constitution = 15
	willpower = 13
	intelligence = 5

/datum/npc_statpack/skeleton/lich
	strength = 20
	speed = 10
	constitution = 20
	willpower = 20
	perception = 20
	intelligence = 1


//** FLAVOR **//

/datum/npc_loadout/kit/skeleton_amulet
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy = 1, //ZIZO. ZIZO. ZIZO.
		/obj/item/clothing/neck/roguetown/psicross/aalloy = 1,
		/obj/item/clothing/neck/roguetown/psicross/noc/aalloy = 1,
		NPC_NOTHING = 27,
	)

/datum/npc_loadout/kit/skeleton_scavenged
	cloak = list(
		/obj/item/clothing/cloak/raincloak/brown = 10,
		NPC_NOTHING = 90,
	)
	pants = list(
		/obj/item/clothing/under/roguetown/tights/random,
		/obj/item/clothing/under/roguetown/loincloth/brown,
	)
	shoes = list(
		/obj/item/clothing/shoes/roguetown/simpleshoes = 60,
		NPC_NOTHING = 40,
	)
	head = list(
		/obj/item/clothing/head/roguetown/cap = 1,
		/obj/item/clothing/head/roguetown/roguehood = 1,
		/obj/item/clothing/head/roguetown/fisherhat = 1,
		/obj/item/clothing/head/roguetown/knitcap = 1,
		NPC_NOTHING = 6,
	)

/datum/npc_loadout/kit/skeleton_rags
	shirt = /obj/item/clothing/suit/roguetown/shirt/rags

/datum/npc_loadout/kit/skeleton_workervest
	armor = /obj/item/clothing/suit/roguetown/armor/workervest

/datum/npc_loadout/kit/skeleton_tabard
	cloak = list(
		/obj/item/clothing/cloak/tabard/toga/lich,
		/obj/item/clothing/cloak/half/lich,
		/obj/item/clothing/cloak/tabard/toga/lich/alt,
	)

/datum/npc_loadout/kit/skeleton_tabard/soldier
	cloak = list(
		/obj/item/clothing/cloak/tabard/toga/lich,
		/obj/item/clothing/cloak/tabard/toga/lich/alt,
		/obj/item/clothing/cloak/tabard/stabard/surcoat/lich, // Ooo Spooky Old Dead MAA
	)
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = list(
		/obj/item/repair_kit/bad = 15,
		NPC_NOTHING = 85,
	)
	beltr = list(
		/obj/item/storage/belt/rogue/pouch/coins/aalloy = 10,
		NPC_NOTHING = 90,
	)

/datum/npc_loadout/kit/skeleton_hijab
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy/chain

/datum/npc_loadout/kit/skeleton_pirate
	head = /obj/item/clothing/head/roguetown/helmet/tricorn
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	shoes = /obj/item/clothing/shoes/roguetown/sandals/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/knuckles/decrepit
	wrists = list(
		/obj/item/clothing/wrists/roguetown/bracers/aalloy/chain = 20, //DO WHAT YOU WANT BECAUSE A PIRATE IS FREE
		/obj/item/clothing/wrists/roguetown/bracers/aalloy = 80,
	)
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy = 5, //ZIZO. ZIZO. ZIZO.
		/obj/item/clothing/neck/roguetown/psicross/aalloy = 5,
		/obj/item/clothing/neck/roguetown/psicross/noc/aalloy = 5,
		/obj/item/clothing/neck/roguetown/psicross/abyssor = 15,
		NPC_NOTHING = 70,
	)

/datum/npc_loadout/kit/skeleton_dreadnought
	abstract_type = /datum/npc_loadout/kit/skeleton_dreadnought
	beltr = list(
		/obj/item/storage/belt/rogue/pouch/coins/aalloy = 15,
		NPC_NOTHING = 85,
	)

/datum/npc_loadout/kit/skeleton_dreadnought/khopesh
	cloak = /obj/item/clothing/cloak/tabard/toga/lich
	mask = /obj/item/clothing/mask/rogue/facemask/aalloy
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = list(
		/obj/item/repair_kit/bad = 20,
		NPC_NOTHING = 80,
	)
	id = list( //Cultist look so, no Psydon choice
		/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy,
		/obj/item/clothing/neck/roguetown/psicross/noc/aalloy,
	)

/datum/npc_loadout/kit/skeleton_dreadnought/withered
	cloak = list(
		/obj/item/clothing/cloak/tabard/toga/lich,
		/obj/item/clothing/cloak/tabard/toga/lich/alt,
		/obj/item/clothing/cloak/tabard/blkknight, // SOVL
	)
	belt = /obj/item/storage/belt/rogue/leather
	beltl = list(
		/obj/item/repair_kit/metal/bad = 15,
		/obj/item/repair_kit/bad = 17,
		NPC_NOTHING = 68,
	)

/datum/npc_loadout/kit/bog_skeleton
	wrists = list(
		/obj/item/clothing/wrists/roguetown/bracers/leather = 1,
		NPC_NOTHING = 1,
	)
	armor = list(
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron = 10,
		NPC_NOTHING = 90,
	)
	shirt = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/light = 340,
		/obj/item/clothing/suit/roguetown/armor/gambeson = 51,
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = 9,
		NPC_NOTHING = 400,
	)
	pants = list(
		/obj/item/clothing/under/roguetown/tights/vagrant = 12,
		/obj/item/clothing/under/roguetown/chainlegs/iron = 3,
		/obj/item/clothing/under/roguetown/heavy_leather_pants = 1,
		NPC_NOTHING = 16,
	)
	head = list(
		/obj/item/clothing/neck/roguetown/coif = 35,
		/obj/item/clothing/head/roguetown/helmet/kettle/iron = 15,
		NPC_NOTHING = 50,
	)
	neck = list(
		/obj/item/clothing/neck/roguetown/chaincoif/iron = 1,
		NPC_NOTHING = 1,
	)
	cloak = list(
		/obj/item/clothing/cloak/tabard/stabard/bog = 1,
		NPC_NOTHING = 1,
	)

/datum/npc_loadout/kit/bog_skeleton_archer
	clear_slots = list("head", "mask", "neck")
	armor = /obj/item/clothing/suit/roguetown/shirt/rags

/datum/npc_loadout/kit/bog_skeleton_master
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull
	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	cloak = /obj/item/clothing/cloak/tabard/stabard/bog
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather

/datum/npc_loadout/kit/skeleton_summon
	shirt = list(
		/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant = 50,
		/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l = 50,
	)
	cloak = list( //Random Cloaks, akin to regular-ish necro skeletons.
		/obj/item/clothing/cloak/tabard/stabard/surcoat/necro,
		/obj/item/clothing/cloak/tabard/necro,
		/obj/item/clothing/cloak/half/lich,
	)

/datum/npc_loadout/kit/fallen_duke
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel/short/black
	backpack_contents = list(
		/obj/item/clothing/head/roguetown/crown/fakecrown = 1,
		/obj/item/roguegem/diamond = 1,
	)
	mask = list(
		/obj/item/clothing/mask/rogue/facemask/aalloy = 25,
		NPC_NOTHING = 75,
	)
	beltl = list(
		/obj/item/repair_kit/bad = 20,
		NPC_NOTHING = 80,
	)
	beltr = list(
		/obj/item/storage/belt/rogue/pouch/coins/aalloy = 15,
		NPC_NOTHING = 85,
	)

//** WEAPONS **//

/datum/npc_loadout/weapon/skeleton_scavenged
	weapons = list(
		list(/obj/item/rogueweapon/stoneaxe/woodcut/aaxe),
		list(/obj/item/rogueweapon/sword/short/ashort),
		list(/obj/item/rogueweapon/spear/aalloy),
		list(/obj/item/rogueweapon/mace/alloy),
		list(/obj/item/rogueweapon/mace/woodclub),
	)

/datum/npc_loadout/weapon/skeleton_footsoldier
	weapons = list(
		list(/obj/item/rogueweapon/stoneaxe/woodcut/aaxe),
		list(/obj/item/rogueweapon/sword/short/ashort),
		list(/obj/item/rogueweapon/spear/aalloy),
		list(/obj/item/rogueweapon/mace/alloy),
	)

/datum/npc_loadout/weapon/skeleton_pirate_knives
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/adagger
	l_hand = /obj/item/rogueweapon/huntingknife/idagger/adagger
	traits = list(TRAIT_DUALWIELDER) //Rapid knives build

/datum/npc_loadout/weapon/skeleton_pirate_sabre
	r_hand = /obj/item/rogueweapon/sword/sabre/alloy //Its the closet thing to an ancient cutlass, matie

/datum/npc_loadout/weapon/skeleton_soldier_sandals
	shoes = /obj/item/clothing/shoes/roguetown/sandals/aalloy //Legionnarie look
	weapons = list(
		list(/obj/item/rogueweapon/stoneaxe/woodcut/aaxe, /obj/item/rogueweapon/shield/tower/metal/alloy, 20),
		list(/obj/item/rogueweapon/sword/short/gladius/agladius, /obj/item/rogueweapon/shield/bronze/aalloy, 45), // ave
		list(/obj/item/rogueweapon/flail/aflail, /obj/item/rogueweapon/shield/bronze/aalloy, 65),
	)

/datum/npc_loadout/weapon/skeleton_soldier_boots
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy //Bulwark look
	weapons = list(
		list(/obj/item/rogueweapon/mace/warhammer/alloy, /obj/item/rogueweapon/shield/tower/metal/alloy, 40), //Nastier for MAA skele
		list(/obj/item/rogueweapon/halberd/bardiche/aalloy),
	)

/datum/npc_loadout/weapon/skeleton_khopesh
	r_hand = /obj/item/rogueweapon/sword/sabre/alloy
	l_hand = /obj/item/rogueweapon/sword/sabre/alloy
	traits = list(TRAIT_DUALWIELDER) //Parity slightly with deadlier dreadknight + swift on heavy armor no longer being cracked

/datum/npc_loadout/weapon/skeleton_withered
	weapons = list(
		list(/obj/item/rogueweapon/greatsword/aalloy),
		list(/obj/item/rogueweapon/mace/goden/aalloy),
		list(/obj/item/rogueweapon/greatsword/grenz/flamberge/aalloy),
		list(/obj/item/rogueweapon/flail/aflail, /obj/item/rogueweapon/shield/bronze/great/aalloy), //THE WALL, THE WALL, THE WALL
	)

/datum/npc_loadout/weapon/skeleton_archer
	r_hand = /obj/item/rogueweapon/mace/alloy
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backl = /obj/item/quiver/randomfill/skeleton

/datum/npc_loadout/weapon/bog_skeleton
	weapons = list(
		list(/obj/item/rogueweapon/sword/iron),
		list(/obj/item/rogueweapon/spear),
		list(/obj/item/rogueweapon/mace),
	)

/datum/npc_loadout/weapon/bog_skeleton_archer
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backl = /obj/item/quiver/randomfill/skeleton

/datum/npc_loadout/weapon/bog_skeleton_master
	r_hand = /obj/item/rogueweapon/halberd

/datum/npc_loadout/weapon/fallen_duke
	r_hand = /obj/item/rogueweapon/sword/rapier/lord
	l_hand = /obj/item/rogueweapon/shield/tower/metal/alloy

/datum/npc_loadout/weapon/lich_knight
	weapons = list(
		list(/obj/item/rogueweapon/eaglebeak/lucerne),
		list(/obj/item/rogueweapon/greatsword/zwei),
	)

/datum/npc_loadout/weapon/skeleton_summon
	weapons = list( //Random Weaponry choices - Slightly larger pool than bog guards.
		list(/obj/item/rogueweapon/sword/iron),
		list(/obj/item/rogueweapon/spear),
		list(/obj/item/rogueweapon/mace),
		list(/obj/item/rogueweapon/stoneaxe/woodcut),
	)
