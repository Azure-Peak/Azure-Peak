//** ARCHETYPES **//

/datum/npc_archetype/highwayman
	name = "Highwayman"
	job = "Highwayman"
	category = FACTION_BANDITS
	faction_tag = "bandits"
	threat_point = THREAT_HIGH
	body = /datum/npc_body/northern_commoner/soldier/highwayman
	statpack = /datum/npc_statpack/line/t1
	armor_training = ARMOR_CLASS_MEDIUM
	melee = SKILL_LEVEL_APPRENTICE
	brawl = SKILL_LEVEL_APPRENTICE
	survival = SKILL_LEVEL_APPRENTICE
	loadouts = list(
		/datum/npc_loadout/armor/medium/bandit_line,
		/datum/npc_loadout/kit/bandit_flavor,
		/datum/npc_loadout/weapon/bandit_melee,
		list(NPC_NOTHING = 70, /datum/npc_loadout/kit/bandit_bulwark = 30),
	)

/datum/npc_archetype/highwayman/mount_reaver
	name = "Mount Reaver"
	job = "Mount Reaver"
	threat_point = THREAT_TOUGH
	statpack = /datum/npc_statpack/line/t2
	melee = SKILL_LEVEL_JOURNEYMAN
	brawl = SKILL_LEVEL_JOURNEYMAN
	skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	)
	loadouts = list(
		/datum/npc_loadout/armor/light/leather/iron_bracers,
		/datum/npc_loadout/kit/bandit_flavor/mount_reaver,
		/datum/npc_loadout/weapon/bandit_melee,
	)

/datum/npc_archetype/highwayman/archer
	name = "Highwayman Archer"
	job = "Highwayman Archer"
	statpack = /datum/npc_statpack/marksman/t1
	skills = list(/datum/skill/combat/bows = SKILL_LEVEL_EXPERT)
	loadouts = list(
		/datum/npc_loadout/kit/bandit_flavor,
		/datum/npc_loadout/armor/light/bandit/archer,
		/datum/npc_loadout/weapon/bandit_bow,
	)
	ai_controller = /datum/ai_controller/human_npc/archer

/datum/npc_archetype/highwayman/light
	name = "Highwayman Cutpurse"
	job = "Highwayman Cutpurse"
	statpack = /datum/npc_statpack/light/t1
	armor_training = ARMOR_CLASS_LIGHT
	melee = SKILL_LEVEL_JOURNEYMAN
	skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
	)
	loadouts = list(
		/datum/npc_loadout/kit/bandit_flavor,
		/datum/npc_loadout/armor/light/bandit,
		/datum/npc_loadout/weapon/bandit_swift,
	)

/datum/npc_archetype/highwayman/crossbowman
	name = "Highwayman Crossbowman"
	job = "Highwayman Crossbowman"
	statpack = /datum/npc_statpack/line/t1
	skills = list(/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT)
	loadouts = list(
		/datum/npc_loadout/kit/bandit_flavor,
		/datum/npc_loadout/armor/medium/bandit_line/crossbowman,
		/datum/npc_loadout/weapon/bandit_crossbow,
	)
	ai_controller = /datum/ai_controller/human_npc/archer

/datum/npc_archetype/highwayman/bulwark
	name = "Highwayman Bulwark"
	job = "Highwayman Bulwark"
	threat_point = THREAT_TOUGH
	loadouts = list(
		/datum/npc_loadout/armor/medium/bandit_line,
		/datum/npc_loadout/kit/bandit_flavor,
		/datum/npc_loadout/weapon/bandit_melee,
		/datum/npc_loadout/kit/bandit_bulwark/tough,
	)

/datum/npc_archetype/highwayman/road_knight
	name = "Road Knight"
	job = "Road Knight"
	threat_point = THREAT_DEADLY
	statpack = /datum/npc_statpack/line/t3
	armor_training = ARMOR_CLASS_HEAVY
	traits = list(TRAIT_BADTRAINER)
	brawl = SKILL_LEVEL_JOURNEYMAN
	skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
	)
	loadouts = list(
		/datum/npc_loadout/kit/bandit_flavor/road_knight,
		/datum/npc_loadout/armor/heavy/iron_chain/iron_plate,
		/datum/npc_loadout/weapon/road_knight,
	)

/datum/npc_archetype/highwayman/sharpshooter
	name = "Highwayman Sharpshooter"
	job = "Highwayman Sharpshooter"
	threat_point = THREAT_DEADLY
	statpack = /datum/npc_statpack/marksman/t3
	armor_training = ARMOR_CLASS_HEAVY
	traits = list(TRAIT_BADTRAINER)
	skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
	)
	loadouts = list(
		/datum/npc_loadout/kit/bandit_flavor/sharpshooter,
		/datum/npc_loadout/armor/heavy/iron_chain/cuirass,
		/datum/npc_loadout/weapon/sharpshooter_bow,
	)
	ai_controller = /datum/ai_controller/human_npc/archer

//** BODY **//

/datum/npc_body/northern_commoner/soldier/highwayman
	aggro_lines_file = "strings/rt/highwaymanaggrolines.txt"

/datum/npc_body/northern_commoner/soldier/highwayman/get_head_sellprice()
	return HEAD_BOUNTY_HIGHWAYMAN

//** FLAVOR **//

/datum/npc_loadout/kit/bandit_flavor
	shoes = list(
		/obj/item/clothing/shoes/roguetown/boots/leather,
		/obj/item/clothing/shoes/roguetown/boots,
	)
	belt = list(
		/obj/item/storage/belt/rogue/leather/rope = 90,
		/obj/item/storage/belt/rogue/leather/knifebelt/iron = 10,
	)
	neck = list(
		/obj/item/clothing/neck/roguetown/coif = 49,
		/obj/item/clothing/neck/roguetown/leather = 49,
		/obj/item/storage/belt/rogue/pouch/bombs = 2,
	)
	cloak = list(
		/obj/item/clothing/cloak/raincloak/furcloak/brown = 3,
		/obj/item/clothing/cloak/raincloak/red = 3,
		/obj/item/clothing/cloak/raincloak/green = 3,
		/obj/item/clothing/cloak/raincloak/blue = 3,
		/obj/item/clothing/cloak/raincloak/brown = 3,
		NPC_NOTHING = 35,
	)
	mask = list(
		/obj/item/clothing/mask/rogue/ragmask/red = 1,
		/obj/item/clothing/mask/rogue/ragmask/black = 1,
		/obj/item/clothing/mask/rogue/skullmask = 1,
		NPC_NOTHING = 3,
	)
	head = list(
		/obj/item/clothing/head/roguetown/helmet/leather = 20,
		/obj/item/clothing/head/roguetown/helmet/leather/volfhelm = 15,
		/obj/item/clothing/head/roguetown/helmet/kettle/iron = 15,
		/obj/item/clothing/head/roguetown/helmet/skullcap = 15,
		/obj/item/clothing/head/roguetown/helmet/sallet/iron = 10,
		/obj/item/clothing/head/roguetown/menacing/bandit = 5,
		/obj/item/clothing/head/roguetown/armingcap = 5,
		NPC_NOTHING = 15,
	)

/datum/npc_loadout/kit/bandit_flavor/mount_reaver
	mask = /obj/item/clothing/mask/rogue/ragmask/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = list(
		/obj/item/storage/belt/rogue/leather/rope = 77,
		/obj/item/storage/belt/rogue/leather/knifebelt/iron = 23,
	)

// Applied last so it overwrites bandit_flavor's head and neck rolls.
/datum/npc_loadout/kit/bandit_bulwark
	statpack = /datum/npc_statpack/heavy/t1
	clear_slots = list("l_hand", "r_hand")
	skills = list(/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN)
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	armor = list(
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = 60,
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron = 40,
	)
	head = list(
		/obj/item/clothing/head/roguetown/helmet/sallet/visored/iron = 40,
		/obj/item/clothing/head/roguetown/helmet/bascinet/iron/aventail = 35,
		/obj/item/clothing/head/roguetown/helmet/heavy/knight/iron = 25,
	)
	neck = list(
		/obj/item/clothing/neck/roguetown/chaincoif/iron = 50,
		/obj/item/clothing/neck/roguetown/coif/heavypadding = 30,
		/obj/item/clothing/neck/roguetown/bevor/iron = 20,
	)
	pants = list(
		/obj/item/clothing/under/roguetown/chainlegs/iron/kilt = 45,
		/obj/item/clothing/under/roguetown/splintlegs = 30,
		/obj/item/clothing/under/roguetown/heavy_leather_pants = 25,
	)
	mask = list(
		/obj/item/clothing/mask/rogue/facemask = 35,
		/obj/item/clothing/mask/rogue/ragmask/black = 30,
		/obj/item/clothing/mask/rogue/skullmask = 20,
		NPC_NOTHING = 15,
	)
	weapons = list(
		list(/obj/item/rogueweapon/mace, /obj/item/rogueweapon/shield/tower, 90),
		list(/obj/item/rogueweapon/mace/warhammer, /obj/item/rogueweapon/shield/tower, 85),
		list(/obj/item/rogueweapon/mace/cudgel, /obj/item/rogueweapon/shield/tower, 90),
		list(/obj/item/rogueweapon/flail, /obj/item/rogueweapon/shield/wood, 80),
	)

// The dedicated bulwark is priced a tier above the sprinkle the base highwayman rolls.
/datum/npc_loadout/kit/bandit_bulwark/tough
	statpack = /datum/npc_statpack/heavy/t2

/datum/npc_loadout/kit/bandit_flavor/road_knight
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown

/datum/npc_loadout/kit/bandit_flavor/sharpshooter
	cloak = /obj/item/clothing/cloak/raincloak/green

//** WEAPONS **//

/datum/npc_loadout/weapon/bandit_melee
	weapons = list(
		list(/obj/item/rogueweapon/sword/short/iron, /obj/item/rogueweapon/shield/wood, 45),
		list(/obj/item/rogueweapon/sword/short, /obj/item/rogueweapon/shield/wood, 45),
		list(/obj/item/rogueweapon/mace/cudgel, /obj/item/rogueweapon/shield/wood, 25),
		list(/obj/item/rogueweapon/sword/falchion/militia, /obj/item/rogueweapon/shield/wood, 20),
		list(/obj/item/rogueweapon/pick/militia, /obj/item/rogueweapon/shield/buckler, 35),
		list(/obj/item/rogueweapon/greataxe/militia),
		list(/obj/item/rogueweapon/woodstaff/militia),
		list(/obj/item/rogueweapon/huntingknife/idagger, /obj/item/rogueweapon/shield/buckler, 65),
	)

/datum/npc_loadout/weapon/bandit_swift
	weapons = list(
		list(/obj/item/rogueweapon/huntingknife/idagger, /obj/item/rogueweapon/huntingknife/idagger, 60),
		list(/obj/item/rogueweapon/sword/sabre/iron, /obj/item/rogueweapon/huntingknife/idagger, 45),
		list(/obj/item/rogueweapon/sword/short/iron, /obj/item/rogueweapon/shield/buckler, 50),
		list(/obj/item/rogueweapon/sword/short/iron, /obj/item/rogueweapon/huntingknife/idagger, 55),
	)

/datum/npc_loadout/weapon/bandit_bow
	r_hand = /obj/item/rogueweapon/sword/short/iron
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/quiver/randomfill/highwayman

/datum/npc_loadout/weapon/bandit_crossbow
	r_hand = /obj/item/rogueweapon/huntingknife/idagger
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/iron
	backl = /obj/item/quiver/bolt/npc

/datum/npc_loadout/weapon/road_knight
	r_hand = /obj/item/rogueweapon/sword/iron
	l_hand = /obj/item/rogueweapon/shield/heater

/datum/npc_loadout/weapon/sharpshooter_bow
	beltr = /obj/item/rogueweapon/sword/short/iron
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/quiver/randomfill/reaver
