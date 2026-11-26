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
		/datum/npc_loadout/armor/medium/decrepit,
		/datum/npc_loadout/kit/skeleton_amulet,
		/datum/npc_loadout/kit/skeleton_tabard,
		list( //50% chance of a decrepit helm w/coif
			/datum/npc_loadout/armor/medium/decrepit_helm = 1,
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
	threat_point = THREAT_HIGH
	statpack = /datum/npc_statpack/line/t1
	melee = SKILL_LEVEL_JOURNEYMAN
	brawl = SKILL_LEVEL_JOURNEYMAN
	survival = SKILL_LEVEL_APPRENTICE
	skills = list(/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN)
	loadouts = list(
		/datum/npc_loadout/armor/medium/decrepit_soldier,
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
	threat_point = THREAT_DANGEROUS
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
		/datum/npc_loadout/armor/heavy/decrepit,
		/datum/npc_loadout/kit/skeleton_dreadnought/khopesh,
		list(
			/datum/npc_loadout/armor/heavy/decrepit_cuirass = 60,
			/datum/npc_loadout/armor/heavy/decrepit_hauberk = 40,
		),
		/datum/npc_loadout/weapon/skeleton_khopesh,
	)

/datum/npc_archetype/skeleton/hard/withered
	name = "Skeleton Dreadnought (Withered)"
	statpack = /datum/npc_statpack/heavy/t2
	survival = SKILL_LEVEL_APPRENTICE //Tanky but falls over in water
	loadouts = list(
		/datum/npc_loadout/armor/heavy/decrepit/plated,
		/datum/npc_loadout/kit/skeleton_dreadnought/withered,
		list(
			/datum/npc_loadout/armor/heavy/decrepit_plate = 60,
			/datum/npc_loadout/armor/heavy/decrepit_hauberk = 40,
		),
		/datum/npc_loadout/weapon/skeleton_withered,
	)

/datum/npc_archetype/skeleton/archer
	name = "Skeleton Archer"
	threat_point = THREAT_HIGH
	statpack = /datum/npc_statpack/marksman/t0
	melee = SKILL_LEVEL_APPRENTICE
	brawl = SKILL_LEVEL_APPRENTICE
	survival = SKILL_LEVEL_APPRENTICE
	skills = list(/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN)
	ai_controller = /datum/ai_controller/human_npc/archer
	loadouts = list(
		/datum/npc_loadout/armor/medium/decrepit_archer,
		/datum/npc_loadout/kit/skeleton_amulet,
		/datum/npc_loadout/kit/skeleton_tabard,
		/datum/npc_loadout/weapon/skeleton_archer,
	)

// For Duke Manor & Zizo Manor - Ground based spread, so no pirate in pool!
/datum/npc_archetype/skeleton/mediumspread
	name = "Skeleton (Mixed)"
	threat_point = THREAT_HIGH
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
	threat_point = THREAT_MODERATE
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
	threat_point = THREAT_DEADLY
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
	patron = /datum/patron/inhumen/zizo
	melee = SKILL_LEVEL_MASTER
	brawl = SKILL_LEVEL_MASTER
	survival = SKILL_LEVEL_APPRENTICE
	skills = list(/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT)
	loadouts = list(
		/datum/npc_loadout/armor/heavy/decrepit/plated/guard,
		/datum/npc_loadout/armor/heavy/decrepit_plate,
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

//avantyne clad skeletons that will be used for adminbus + maybe a future dungeon, we'll see
//please, for the love of all that is (un?)holy, do not make this gear on luxplate skeles strippable, we do not need free ritual gear

/datum/npc_archetype/skeleton/zizo
	name = "Avantyne Skeleton Warrior"
	statpack = /datum/npc_statpack/line/t3 //on par w/ dwarf skeletons
	stat_modifiers = null
	patron = /datum/patron/inhumen/zizo
	melee = SKILL_LEVEL_EXPERT
	brawl = SKILL_LEVEL_EXPERT //needed so you can't tacklepin them
	survival = SKILL_LEVEL_APPRENTICE
	armor_training = ARMOR_CLASS_MEDIUM
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/zizo,
		/datum/npc_loadout/kit/zizo_skele_avantyne_flavor,
		/datum/npc_loadout/kit/skeleton_tabard,
		/datum/npc_loadout/weapon/zizo,
	)

/datum/npc_archetype/skeleton/zizo_heavy
	name = "Avantyne Skeleton Bulwark"
	statpack = /datum/npc_statpack/line/t3 //on par w/ dwarf skeletons
	stat_modifiers = null
	patron = /datum/patron/inhumen/zizo
	melee = SKILL_LEVEL_EXPERT
	brawl = SKILL_LEVEL_EXPERT //needed so you can't tacklepin them
	survival = SKILL_LEVEL_APPRENTICE
	armor_training = ARMOR_CLASS_HEAVY
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/zizo_heavy,
		/datum/npc_loadout/kit/zizo_skele_avantyne_flavor,
		/datum/npc_loadout/kit/skeleton_tabard,
		/datum/npc_loadout/weapon/zizo_heavy,
	)

//caster skeletons

/datum/npc_archetype/skeleton/caster
	abstract_type = /datum/npc_archetype/skeleton/caster
	statpack = /datum/npc_statpack/caster/t2 //decent but not high-end
	stat_modifiers = null
	ai_controller = /datum/ai_controller/human_npc/caster
	patron = /datum/patron/inhumen/zizo
	magic = SKILL_LEVEL_JOURNEYMAN
	melee = SKILL_LEVEL_JOURNEYMAN
	brawl = SKILL_LEVEL_APPRENTICE //intended to be weak vs tackles

/datum/npc_archetype/skeleton/caster/mixed
	name = "Skeleton Mage"
	variants = list(
		/datum/npc_archetype/skeleton/caster/fulgarmancer = 1,
		/datum/npc_archetype/skeleton/caster/geomancer = 1,
		/datum/npc_archetype/skeleton/caster/telomancer = 1,
		/datum/npc_archetype/skeleton/caster/ferramancer = 1,
		/datum/npc_archetype/skeleton/caster/cryomancer = 1,
		/datum/npc_archetype/skeleton/caster/pyromancer = 1,
	)

/datum/npc_archetype/skeleton/caster/fulgarmancer
	name = "Skeleton Fulgarmancer"
	loadouts = list(
		/datum/npc_loadout/armor/light/skeleton_caster,
		/datum/npc_loadout/kit/skeleton_amulet,
		/datum/npc_loadout/kit/caster_skele_fulgurmancer,
		/datum/npc_loadout/kit/skeleton_tabard,
	)

/datum/npc_archetype/skeleton/caster/geomancer
	name = "Skeleton Geomancer"
	loadouts = list(
		/datum/npc_loadout/armor/light/skeleton_caster,
		/datum/npc_loadout/kit/skeleton_amulet,
		/datum/npc_loadout/kit/caster_skele_geomancer,
		/datum/npc_loadout/kit/skeleton_tabard,
	)

/datum/npc_archetype/skeleton/caster/telomancer
	name = "Skeleton Telomancer"
	loadouts = list(
		/datum/npc_loadout/armor/light/skeleton_caster,
		/datum/npc_loadout/kit/skeleton_amulet,
		/datum/npc_loadout/kit/caster_skele_telomancer,
		/datum/npc_loadout/kit/skeleton_tabard,
	)

/datum/npc_archetype/skeleton/caster/ferramancer
	name = "Skeleton Ferramancer"
	loadouts = list(
		/datum/npc_loadout/armor/light/skeleton_caster,
		/datum/npc_loadout/kit/skeleton_amulet,
		/datum/npc_loadout/kit/caster_skele_ferramancer,
		/datum/npc_loadout/kit/skeleton_tabard,
	)

/datum/npc_archetype/skeleton/caster/cryomancer
	name = "Skeleton Cryomancer"
	loadouts = list(
		/datum/npc_loadout/armor/light/skeleton_caster,
		/datum/npc_loadout/kit/skeleton_amulet,
		/datum/npc_loadout/kit/caster_skele_cryomancer,
		/datum/npc_loadout/kit/skeleton_tabard,
	)

/datum/npc_archetype/skeleton/caster/pyromancer
	name = "Skeleton Pyromancer"
	loadouts = list(
		/datum/npc_loadout/armor/light/skeleton_caster,
		/datum/npc_loadout/kit/skeleton_amulet,
		/datum/npc_loadout/kit/caster_skele_pyromancer,
		/datum/npc_loadout/kit/skeleton_tabard,
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
		/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient/decrepit = 1, //ZIZO. ZIZO. ZIZO.
		/obj/item/clothing/neck/roguetown/psicross/ancient/decrepit = 1,
		/obj/item/clothing/neck/roguetown/psicross/noc/ancient/decrepit = 1,
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
		/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/shoddy = 40,
	)
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
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
		/obj/item/storage/belt/rogue/pouch/coins/psila = 10,
		NPC_NOTHING = 90,
	)

/datum/npc_loadout/kit/skeleton_hijab
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich
	wrists = /obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit/chain

/datum/npc_loadout/kit/skeleton_pirate
	head = /obj/item/clothing/head/roguetown/helmet/tricorn
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient/decrepit
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	shoes = /obj/item/clothing/shoes/roguetown/sandals/ancient/decrepit
	gloves = /obj/item/clothing/gloves/roguetown/knuckles/ancient/decrepit
	wrists = list(
		/obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit/chain = 20, //DO WHAT YOU WANT BECAUSE A PIRATE IS FREE
		/obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit = 80,
	)
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient/decrepit = 5, //ZIZO. ZIZO. ZIZO.
		/obj/item/clothing/neck/roguetown/psicross/ancient/decrepit = 5,
		/obj/item/clothing/neck/roguetown/psicross/noc/ancient/decrepit = 5,
		/obj/item/clothing/neck/roguetown/psicross/abyssor = 15,
		NPC_NOTHING = 70,
	)

/datum/npc_loadout/kit/skeleton_dreadnought
	abstract_type = /datum/npc_loadout/kit/skeleton_dreadnought
	beltr = list(
		/obj/item/storage/belt/rogue/pouch/coins/psila = 15,
		NPC_NOTHING = 85,
	)

/datum/npc_loadout/kit/skeleton_dreadnought/khopesh
	cloak = /obj/item/clothing/cloak/tabard/toga/lich
	mask = /obj/item/clothing/mask/rogue/facemask/ancient/decrepit
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = list(
		/obj/item/repair_kit/bad = 20,
		NPC_NOTHING = 80,
	)
	id = list( //Cultist look so, no Psydon choice
		/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient/decrepit,
		/obj/item/clothing/neck/roguetown/psicross/noc/ancient/decrepit,
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
		NPC_NOTHING = 30,
	)
	shirt = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/light = 40,
		/obj/item/clothing/suit/roguetown/armor/gambeson = 10,
	)
	pants = list(
		/obj/item/clothing/under/roguetown/tights/vagrant = 12,
		/obj/item/clothing/under/roguetown/chainlegs/iron = 3,
		/obj/item/clothing/under/roguetown/trou/leather = 15,
		NPC_NOTHING = 5,
	)
	head = list(
		/obj/item/clothing/head/roguetown/helmet/skullcap = 20, //old sovl
		/obj/item/clothing/head/roguetown/helmet/skullcap/old = 1, //old SOVL (rare b.c its a triumph thing otherwise)
		/obj/item/clothing/head/roguetown/helmet/kettle/iron = 8,
		/obj/item/clothing/head/roguetown/helmet/leather = 15,
		/obj/item/clothing/head/roguetown/helmet/heavy/guard/bogman/iron = 3,
		/obj/item/clothing/head/roguetown/roguehood/bogman = 8, //no colored varients, these were who didn't defect
		NPC_NOTHING = 10,
	)
	neck = list(
		/obj/item/clothing/neck/roguetown/coif = 25,
		/obj/item/clothing/neck/roguetown/chaincoif/iron = 1,
	)
	mask = list(
		/obj/item/clothing/mask/rogue/facemask = 1,
		/obj/item/clothing/mask/rogue/ragmask/black = 3,
		/obj/item/clothing/mask/rogue/ragmask/red = 3,
		NPC_NOTHING = 10,
	)
	cloak = list(
		/obj/item/clothing/cloak/tabard/stabard/bog = 1,
		NPC_NOTHING = 1,
	)
	gloves = list(
		/obj/item/clothing/gloves/roguetown/fingerless_leather = 3,
		/obj/item/clothing/gloves/roguetown/leather = 3,
		/obj/item/clothing/gloves/roguetown/chain/iron = 1,
	)
	shoes = list(
		/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/shoddy = 1,
		/obj/item/clothing/shoes/roguetown/boots/leather = 3,
	)
	belt = list(
		/obj/item/storage/belt/rogue/leather = 1,
		/obj/item/storage/belt/rogue/leather/cloth = 2,
		/obj/item/storage/belt/rogue/leather/rope = 2,
		NPC_NOTHING = 3,
	)

/datum/npc_loadout/kit/bog_skeleton_archer
	clear_slots = list("head", "mask", "neck")
	armor = /obj/item/clothing/suit/roguetown/shirt/rags

/datum/npc_loadout/kit/bog_skeleton_master
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	cloak = /obj/item/clothing/cloak/tabard/stabard/bog
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	belt = /obj/item/storage/belt/rogue/leather

/datum/npc_loadout/kit/fallen_duke
	traits = list(TRAIT_NOBLE) //Its a duke, sire. Sovl (also its only 1 NPC, it won't affect Astrata's score that badly)
	cloak = /obj/item/clothing/cloak/lordcloak
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/rogueweapon/scabbard/sword/royal
	backl = /obj/item/storage/backpack/rogue/satchel/short/black
	backpack_contents = list(
		/obj/item/clothing/head/roguetown/crown/fakecrown = 1,
		/obj/item/storage/belt/rogue/pouch/coins/psila/rich = 1, //funny
		/obj/item/roguegem/diamond = 1,
	)
	beltl = list(
		/obj/item/repair_kit/bad = 20,
		NPC_NOTHING = 80,
	)

/datum/npc_loadout/kit/zizo_skele_avantyne_flavor
	belt = list(
		/obj/item/storage/belt/rogue/leather = 1,
		/obj/item/storage/belt/rogue/leather/black = 1,
	)
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient/decrepit = 1, //ZIZO. ZIZO. ZIZO.
		NPC_NOTHING = 5,
	)

//** WEAPONS **//

/datum/npc_loadout/weapon/skeleton_scavenged
	weapons = list(
		list(/obj/item/rogueweapon/stoneaxe/woodcut/ancient/decrepit),
		list(/obj/item/rogueweapon/sword/short/ancient/decrepit),
		list(/obj/item/rogueweapon/spear/ancient/decrepit),
		list(/obj/item/rogueweapon/mace/ancient/decrepit),
		list(/obj/item/rogueweapon/mace/woodclub),
	)

/datum/npc_loadout/weapon/skeleton_footsoldier
	weapons = list(
		list(/obj/item/rogueweapon/stoneaxe/woodcut/ancient/decrepit),
		list(/obj/item/rogueweapon/sword/short/ancient/decrepit),
		list(/obj/item/rogueweapon/spear/ancient/decrepit),
		list(/obj/item/rogueweapon/mace/ancient/decrepit),
	)

/datum/npc_loadout/weapon/skeleton_pirate_knives
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/ancient/decrepit
	l_hand = /obj/item/rogueweapon/huntingknife/idagger/ancient/decrepit
	traits = list(TRAIT_DUALWIELDER) //Rapid knives build

/datum/npc_loadout/weapon/skeleton_pirate_sabre
	r_hand = /obj/item/rogueweapon/sword/sabre/ancient/decrepit //Its the closet thing to an ancient cutlass, matie

/datum/npc_loadout/weapon/skeleton_soldier_sandals
	shoes = /obj/item/clothing/shoes/roguetown/sandals/ancient/decrepit //Legionnarie look
	weapons = list(
		list(/obj/item/rogueweapon/stoneaxe/woodcut/ancient/decrepit, /obj/item/rogueweapon/shield/tower/ancient/decrepit, 20),
		list(/obj/item/rogueweapon/sword/short/gladius/ancient/decrepit, /obj/item/rogueweapon/shield/bronze/ancient/decrepit, 45), // ave
		list(/obj/item/rogueweapon/flail/ancient/decrepit, /obj/item/rogueweapon/shield/bronze/ancient/decrepit, 65),
	)

/datum/npc_loadout/weapon/skeleton_soldier_boots
	shoes = /obj/item/clothing/shoes/roguetown/boots/ancient/decrepit //Bulwark look
	weapons = list(
		list(/obj/item/rogueweapon/mace/warhammer/ancient/decrepit, /obj/item/rogueweapon/shield/tower/ancient/decrepit, 40), //Nastier for MAA skele
		list(/obj/item/rogueweapon/halberd/bardiche/ancient/decrepit),
	)

/datum/npc_loadout/weapon/skeleton_khopesh
	r_hand = /obj/item/rogueweapon/sword/sabre/ancient/decrepit
	l_hand = /obj/item/rogueweapon/sword/sabre/ancient/decrepit
	traits = list(TRAIT_DUALWIELDER) //Parity slightly with deadlier dreadknight + swift on heavy armor no longer being cracked

/datum/npc_loadout/weapon/skeleton_withered
	weapons = list(
		list(/obj/item/rogueweapon/greatsword/ancient/decrepit),
		list(/obj/item/rogueweapon/mace/goden/ancient/decrepit),
		list(/obj/item/rogueweapon/greatsword/grenz/flamberge/ancient/decrepit),
		list(/obj/item/rogueweapon/flail/ancient/decrepit, /obj/item/rogueweapon/shield/bronze/great/ancient/decrepit), //THE WALL, THE WALL, THE WALL
	)

/datum/npc_loadout/weapon/skeleton_archer
	r_hand = /obj/item/rogueweapon/mace/ancient/decrepit
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
	l_hand = /obj/item/rogueweapon/shield/tower/ancient/decrepit

/datum/npc_loadout/weapon/lich_knight
	weapons = list(
		list(/obj/item/rogueweapon/eaglebeak/lucerne),
		list(/obj/item/rogueweapon/greatsword/zwei),
	)

//casters

/datum/npc_loadout/kit/caster_skele_fulgurmancer
	magic_aspects = list(
		/datum/magic_aspect/fulgurmancy,
	)
	r_hand = /obj/item/rogueweapon/woodstaff/implement/amethyst

/datum/npc_loadout/kit/caster_skele_geomancer
	magic_aspects = list(
		/datum/magic_aspect/geomancy,
	)
	r_hand = /obj/item/rogueweapon/woodstaff/implement/amethyst

/datum/npc_loadout/kit/caster_skele_telomancer
	magic_aspects = list(
		/datum/magic_aspect/telomancy,
	)
	r_hand = /obj/item/rogueweapon/woodstaff/implement/amethyst

/datum/npc_loadout/kit/caster_skele_ferramancer
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded //otherwise they'll die too fast
	magic_aspects = list(
		/datum/magic_aspect/ferramancy,
		/datum/magic_aspect/aegiscraft,
	)
	r_hand = null

/datum/npc_loadout/kit/caster_skele_cryomancer
	magic_aspects = list(
		/datum/magic_aspect/cryomancy,
	)
	r_hand = /obj/item/rogueweapon/woodstaff/implement/amethyst

/datum/npc_loadout/kit/caster_skele_pyromancer
	magic_aspects = list(
		/datum/magic_aspect/pyromancy,
	)
	r_hand = /obj/item/rogueweapon/woodstaff/implement/amethyst
