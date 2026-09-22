//** ARCHETYPES **//

/datum/npc_archetype/highwayman
	name = "Highwayman"
	job = "Highwayman"
	category = FACTION_BANDITS
	faction_tag = "bandits"
	threat_point = THREAT_HIGH
	body = /datum/npc_body/northern_commoner/soldier/highwayman
	statpack = /datum/npc_statpack/soldier
	armor_training = ARMOR_CLASS_MEDIUM
	melee = SKILL_LEVEL_APPRENTICE
	brawl = SKILL_LEVEL_APPRENTICE
	survival = SKILL_LEVEL_APPRENTICE
	loadouts = list(
		/datum/npc_loadout/armor/light/leather,
		/datum/npc_loadout/kit/bandit_flavor,
		/datum/npc_loadout/weapon/bandit_melee,
	)

/datum/npc_archetype/highwayman/mount_reaver
	name = "Mount Reaver"
	job = "Mount Reaver"
	threat_point = THREAT_TOUGH
	statpack = /datum/npc_statpack/veteran
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
	statpack = /datum/npc_statpack/soldier/marksman
	skills = list(/datum/skill/combat/bows = SKILL_LEVEL_EXPERT)
	loadouts = list(
		/datum/npc_loadout/armor/light/leather,
		/datum/npc_loadout/kit/bandit_flavor,
		/datum/npc_loadout/kit/archer_clothing,
		/datum/npc_loadout/weapon/bandit_bow,
	)
	ai_controller = /datum/ai_controller/human_npc/archer

/datum/npc_archetype/highwayman/crossbowman
	name = "Highwayman Crossbowman"
	job = "Highwayman Crossbowman"
	statpack = /datum/npc_statpack/soldier/marksman
	skills = list(/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT)
	loadouts = list(
		/datum/npc_loadout/armor/light/leather,
		/datum/npc_loadout/kit/bandit_flavor,
		/datum/npc_loadout/kit/archer_clothing,
		/datum/npc_loadout/weapon/bandit_crossbow,
	)
	ai_controller = /datum/ai_controller/human_npc/archer

/datum/npc_archetype/highwayman/road_knight
	name = "Road Knight"
	job = "Road Knight"
	threat_point = THREAT_DEADLY
	statpack = /datum/npc_statpack/champion
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
	statpack = /datum/npc_statpack/champion/marksman
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
	shirt = list(
		/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant,
		/obj/item/clothing/suit/roguetown/armor/gambeson/light,
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
		/obj/item/clothing/head/roguetown/helmet/leather = 1,
		/obj/item/clothing/head/roguetown/helmet/leather/volfhelm = 1,
		/obj/item/clothing/head/roguetown/helmet/tricorn = 1,
		/obj/item/clothing/head/roguetown/armingcap = 1,
		/obj/item/clothing/head/roguetown/menacing/bandit = 1,
		NPC_NOTHING = 5,
	)

/datum/npc_loadout/kit/bandit_flavor/mount_reaver
	mask = /obj/item/clothing/mask/rogue/ragmask/black
	belt = list(
		/obj/item/storage/belt/rogue/leather/rope = 77,
		/obj/item/storage/belt/rogue/leather/knifebelt/iron = 23,
	)

/datum/npc_loadout/kit/bandit_flavor/road_knight
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown

/datum/npc_loadout/kit/bandit_flavor/sharpshooter
	cloak = /obj/item/clothing/cloak/raincloak/green

//** WEAPONS **//

/datum/npc_loadout/weapon/bandit_melee
	weapons = list(
		list(/obj/item/rogueweapon/sword/short/iron, /obj/item/rogueweapon/shield/wood, 45),
		list(/obj/item/rogueweapon/mace/cudgel, /obj/item/rogueweapon/shield/wood, 25),
		list(/obj/item/rogueweapon/sword/falchion/militia, /obj/item/rogueweapon/shield/wood, 20),
		list(/obj/item/rogueweapon/pick/militia, /obj/item/rogueweapon/shield/buckler/palloy, 35),
		list(/obj/item/rogueweapon/greataxe/militia),
		list(/obj/item/rogueweapon/woodstaff/militia),
		list(/obj/item/rogueweapon/huntingknife/idagger, /obj/item/rogueweapon/shield/buckler/palloy, 65),
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
