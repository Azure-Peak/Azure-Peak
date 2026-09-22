//** ARCHETYPES **//

/datum/npc_archetype/bog_deserter
	abstract_type = /datum/npc_archetype/bog_deserter
	job = "Bog Deserter"
	category = FACTION_BANDITS
	faction_tag = "bandits"
	threat_point = THREAT_DANGEROUS
	body = /datum/npc_body/northern_commoner/soldier/bog_deserter
	armor_training = ARMOR_CLASS_HEAVY
	traits = list(TRAIT_STEELHEARTED)
	melee = SKILL_LEVEL_EXPERT
	brawl = SKILL_LEVEL_EXPERT
	athletics = SKILL_LEVEL_JOURNEYMAN

/datum/npc_archetype/bog_deserter/mixed
	name = "Bog Deserter"
	variants = list(
		/datum/npc_archetype/bog_deserter/melee = 7,
		/datum/npc_archetype/bog_deserter/bowman = 3,
	)

/datum/npc_archetype/bog_deserter/melee
	name = "Bog Deserter (Melee)"
	statpack = /datum/npc_statpack/bog_deserter
	loadouts = list(
		/datum/npc_loadout/armor/medium/iron_hauberk,
		/datum/npc_loadout/kit/deserter_flavor,
		/datum/npc_loadout/weapon/deserter_melee,
		list(
			/datum/npc_loadout/kit/throwing_knives = 1,
			NPC_NOTHING = 3,
		),
	)

/datum/npc_archetype/bog_deserter/bowman
	name = "Bog Deserter (Bow)"
	statpack = /datum/npc_statpack/bog_deserter/bowman
	skills = list(/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN)
	loadouts = list(
		/datum/npc_loadout/armor/light/leather,
		/datum/npc_loadout/kit/deserter_flavor,
		/datum/npc_loadout/kit/archer_clothing,
		/datum/npc_loadout/weapon/deserter_bow,
	)
	ai_controller = /datum/ai_controller/human_npc/archer

/datum/npc_archetype/bog_deserter/tosser
	name = "Bog Deserter (Tosser)"
	statpack = /datum/npc_statpack/bog_deserter
	loadouts = list(
		/datum/npc_loadout/armor/medium/iron_hauberk,
		/datum/npc_loadout/kit/deserter_flavor,
		/datum/npc_loadout/kit/throwing_knives,
		/datum/npc_loadout/weapon/deserter_melee,
	)
	ai_controller = /datum/ai_controller/human_npc/archer

/datum/npc_archetype/bog_deserter/tosser/better_gear
	name = "Bog Deserter (Tosser, Better Gear)"
	statpack = /datum/npc_statpack/bog_deserter/better_gear
	loadouts = list(
		/datum/npc_loadout/armor/heavy/iron_chain/mixed_plate,
		/datum/npc_loadout/kit/deserter_flavor,
		/datum/npc_loadout/kit/throwing_knives,
		/datum/npc_loadout/weapon/deserter_melee_hard,
	)

/datum/npc_archetype/bog_deserter/better_gear
	name = "Bog Deserter (Better Gear)"
	statpack = /datum/npc_statpack/bog_deserter/better_gear
	loadouts = list(
		/datum/npc_loadout/armor/heavy/iron_chain/mixed_plate,
		/datum/npc_loadout/kit/deserter_flavor,
		/datum/npc_loadout/weapon/deserter_melee_hard,
		list(
			/datum/npc_loadout/kit/throwing_knives = 1,
			NPC_NOTHING = 1,
		),
	)

/datum/npc_archetype/bog_deserter/better_gear/marshal
	name = "Bog Marshal"
	job = "Bog Marshal"
	threat_point = THREAT_ELITE
	body = /datum/npc_body/northern_commoner/soldier/bog_deserter/marshal
	statpack = /datum/npc_statpack/bog_deserter/better_gear/marshal
	traits = list(TRAIT_STEELHEARTED, TRAIT_BADTRAINER)
	loadouts = list(
		/datum/npc_loadout/armor/heavy/iron_chain/full_plate,
		/datum/npc_loadout/kit/deserter_flavor,
		/datum/npc_loadout/weapon/deserter_melee_hard,
		list(
			/datum/npc_loadout/kit/throwing_knives = 1,
			NPC_NOTHING = 1,
		),
	)

/datum/npc_archetype/bog_deserter/archer
	name = "Bog Marksman"
	job = "Bog Marksman"
	statpack = /datum/npc_statpack/bog_deserter/archer
	skills = list(/datum/skill/combat/bows = SKILL_LEVEL_EXPERT)
	loadouts = list(
		/datum/npc_loadout/armor/light/leather,
		/datum/npc_loadout/kit/deserter_flavor,
		/datum/npc_loadout/kit/archer_clothing,
		/datum/npc_loadout/weapon/deserter_bow,
	)
	ai_controller = /datum/ai_controller/human_npc/archer

/datum/npc_archetype/bog_deserter/crossbowman
	name = "Bog Crossbowman"
	job = "Bog Crossbowman"
	statpack = /datum/npc_statpack/bog_deserter/crossbowman
	skills = list(/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT)
	loadouts = list(
		/datum/npc_loadout/armor/light/leather,
		/datum/npc_loadout/kit/deserter_flavor,
		/datum/npc_loadout/kit/archer_clothing,
		/datum/npc_loadout/weapon/deserter_crossbow,
	)
	ai_controller = /datum/ai_controller/human_npc/archer

//** BODY **//

/datum/npc_body/northern_commoner/soldier/bog_deserter
	aggro_lines_file = "strings/rt/highwaymanaggrolines.txt"
	death_line_chance = 25

/datum/npc_body/northern_commoner/soldier/bog_deserter/get_head_sellprice()
	return HEAD_BOUNTY_DESERTER

/datum/npc_body/northern_commoner/soldier/bog_deserter/marshal/get_head_sellprice()
	return HEAD_BOUNTY_BIG_GUY

//** STATS **//

/datum/npc_statpack/bog_deserter
	strength = list(12, 14)
	speed = 11
	constitution = 8
	willpower = 8
	perception = 11
	intelligence = 10

/datum/npc_statpack/bog_deserter/bowman
	strength = list(10, 12)

/datum/npc_statpack/bog_deserter/archer
	strength = list(10, 12)
	constitution = 7
	willpower = 7

/datum/npc_statpack/bog_deserter/crossbowman
	constitution = 7
	willpower = 7

/datum/npc_statpack/bog_deserter/better_gear
	constitution = 10
	willpower = 10

/datum/npc_statpack/bog_deserter/better_gear/marshal
	strength = 15
	constitution = 12
	willpower = 12

//** FLAVOR **//

/datum/npc_loadout/kit/deserter_flavor
	belt = /obj/item/storage/belt/rogue/leather
	cloak = list(
		/obj/item/clothing/cloak/tabard/stabard/bog,
		/obj/item/clothing/cloak/tabard/stabard/dungeon,
		/obj/item/clothing/suit/roguetown/armor/longcoat/brown,
	)
	beltl = list(
		/obj/item/storage/belt/rogue/pouch/food,
		/obj/item/storage/belt/rogue/pouch/medicine,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/storage/belt/rogue/pouch/coins/mid,
		/obj/item/reagent_containers/glass/bottle/waterskin,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot,
		/obj/item/rogueweapon/scabbard/sheath,
	)
	beltr = list(
		/obj/item/storage/belt/rogue/pouch/food,
		/obj/item/storage/belt/rogue/pouch/medicine,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/storage/belt/rogue/pouch/coins/mid,
		/obj/item/reagent_containers/glass/bottle/waterskin,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot,
		/obj/item/rogueweapon/scabbard/sword,
	)

//** WEAPONS **//

/datum/npc_loadout/weapon/deserter_melee
	weapons = list(
		list(/obj/item/rogueweapon/sword/iron, /obj/item/rogueweapon/shield/heater),
		list(/obj/item/rogueweapon/spear),
		list(/obj/item/rogueweapon/stoneaxe/woodcut),
	)

/datum/npc_loadout/weapon/deserter_melee_hard
	weapons = list(
		list(/obj/item/rogueweapon/sword/iron, /obj/item/rogueweapon/shield/heater),
		list(/obj/item/rogueweapon/mace/warhammer, /obj/item/rogueweapon/shield/heater),
		list(/obj/item/rogueweapon/stoneaxe/woodcut),
		list(/obj/item/rogueweapon/flail, /obj/item/rogueweapon/shield/heater),
	)

/datum/npc_loadout/weapon/deserter_bow
	r_hand = /obj/item/rogueweapon/sword/iron
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/quiver/npc

/datum/npc_loadout/weapon/deserter_crossbow
	r_hand = /obj/item/rogueweapon/sword/iron
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/iron
	backl = /obj/item/quiver/bolt/npc
