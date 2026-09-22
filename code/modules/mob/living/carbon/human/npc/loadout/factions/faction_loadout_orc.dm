//** ARCHETYPES **//

/datum/npc_archetype/orc
	abstract_type = /datum/npc_archetype/orc
	job = "Savage Orc"
	category = FACTION_ORCS
	faction_tag = "orcs"
	body = /datum/npc_body/orc
	patron = /datum/patron/inhumen/graggar
	athletics = SKILL_LEVEL_EXPERT
	survival = SKILL_LEVEL_APPRENTICE

/datum/npc_archetype/orc/savage
	name = "Savage Orc"
	statpack = /datum/npc_statpack/orc
	melee = SKILL_LEVEL_JOURNEYMAN
	brawl = SKILL_LEVEL_JOURNEYMAN
	crafting = SKILL_LEVEL_NOVICE //light labor skills for armor repairs and such, equipment is so-so, with good stats
	loadouts = list(
		/datum/npc_loadout/armor/light/hide,
		/datum/npc_loadout/kit/orc_flavor,
		/datum/npc_loadout/weapon/orc_axe_shield,
	)

/datum/npc_archetype/orc/savage/archer
	name = "Savage Orc Archer"
	threat_point = THREAT_HIGH
	statpack = /datum/npc_statpack/orc/archer
	skills = list(/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN)
	loadouts = list(
		/datum/npc_loadout/armor/light/hide,
		/datum/npc_loadout/kit/orc_flavor/archer,
		/datum/npc_loadout/weapon/orc_bow,
	)
	ai_controller = /datum/ai_controller/human_npc/archer

// Underarmored orc with incomplete protection, bone axe / spear, and slow speed
/datum/npc_archetype/orc/footsoldier
	name = "Orc Footsoldier"
	threat_point = THREAT_HIGH
	statpack = /datum/npc_statpack/orc/footsoldier
	melee = SKILL_LEVEL_APPRENTICE
	brawl = SKILL_LEVEL_APPRENTICE
	loadouts = list(
		/datum/npc_loadout/armor/light/hide/mixed,
		/datum/npc_loadout/kit/orc_fur_flavor/footsoldier,
		/datum/npc_loadout/weapon/orc_footsoldier,
	)

// Slightly armored orc with slight facial protection, incomplete chainmail and spear / sword
/datum/npc_archetype/orc/marauder
	name = "Orc Marauder"
	threat_point = THREAT_DANGEROUS
	statpack = /datum/npc_statpack/orc/marauder
	armor_training = ARMOR_CLASS_MEDIUM
	melee = SKILL_LEVEL_JOURNEYMAN
	brawl = SKILL_LEVEL_JOURNEYMAN
	skills = list(/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN)
	loadouts = list(
		/datum/npc_loadout/armor/medium/chainmail,
		/datum/npc_loadout/kit/orc_fur_flavor/marauder,
		/datum/npc_loadout/weapon/orc_marauder,
	)

// Lightly armored orc in light armor with no pain stun, and duel-wielder oriented weapons
/datum/npc_archetype/orc/berserker
	name = "Orc Berserker"
	threat_point = THREAT_DANGEROUS
	statpack = /datum/npc_statpack/orc/berserker
	traits = list(TRAIT_NOPAINSTUN, TRAIT_CRITICAL_RESISTANCE)
	brawl = SKILL_LEVEL_JOURNEYMAN
	skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN,
	)
	loadouts = list(
		/datum/npc_loadout/armor/light/hide/gambeson,
		/datum/npc_loadout/kit/orc_fur_flavor/berserker,
		/datum/npc_loadout/weapon/orc_berserker,
	)

// Heavily armored orc with complete iron protection, heavy armor, and a two hander. Is able to do special attacks.
/datum/npc_archetype/orc/warlord
	name = "Orc Warlord"
	threat_point = THREAT_DEADLY
	statpack = /datum/npc_statpack/orc/warlord
	armor_training = ARMOR_CLASS_HEAVY
	melee = SKILL_LEVEL_EXPERT
	brawl = SKILL_LEVEL_EXPERT
	loadouts = list(
		/datum/npc_loadout/armor/heavy/banded_iron,
		/datum/npc_loadout/kit/orc_fur_flavor/warlord,
		/datum/npc_loadout/weapon/orc_warlord,
	)

/datum/npc_archetype/orc/warlord/juggernaut
	name = "Orc Juggernaut"
	job = "Orc Juggernaut"
	threat_point = THREAT_ELITE
	body = /datum/npc_body/orc/juggernaut
	statpack = /datum/npc_statpack/orc/warlord/juggernaut
	traits = list(TRAIT_BADTRAINER)
	melee = SKILL_LEVEL_MASTER
	skills = list(/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER)
	loadouts = list(
		/datum/npc_loadout/armor/heavy/iron_chain/full_plate/iron_coif,
		/datum/npc_loadout/kit/orc_fur_flavor/warlord,
		/datum/npc_loadout/weapon/orc_warlord,
	)

//** BODY **//

/datum/npc_body/orc/juggernaut/get_head_sellprice()
	return HEAD_BOUNTY_BIG_GUY

//** STATS **//

/datum/npc_statpack/orc
	strength = 12
	speed = 8
	constitution = 8
	willpower = 8
	intelligence = 6

/datum/npc_statpack/orc/archer
	strength = 10
	constitution = 7
	willpower = 7
	perception = 6

/datum/npc_statpack/orc/footsoldier
	strength = 11
	constitution = 7
	willpower = 6
	intelligence = 4 // Very dumb

/datum/npc_statpack/orc/marauder
	constitution = 9
	intelligence = 4

/datum/npc_statpack/orc/berserker
	strength = 13
	speed = 10 // Fast, for an orc
	constitution = 11
	willpower = 10
	intelligence = 1 // Minmax department

/datum/npc_statpack/orc/warlord
	strength = 14
	constitution = 9
	willpower = 11
	intelligence = 8 //Minimal req to do special attacks.

/datum/npc_statpack/orc/warlord/juggernaut
	strength = 16
	constitution = 13
	willpower = 13

//** FLAVOR **//

/datum/npc_loadout/kit/orc_flavor
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	shoes = /obj/item/clothing/shoes/roguetown/gladiator

/datum/npc_loadout/kit/orc_flavor/archer
	clear_slots = list("head", "mask", "neck")
	armor = /obj/item/clothing/suit/roguetown/shirt/rags

/datum/npc_loadout/kit/orc_fur_flavor
	abstract_type = /datum/npc_loadout/kit/orc_fur_flavor
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/barbarian //Cosmetic + Holding repair kits for looting mostly.
	cloak = list(
		/obj/item/clothing/cloak/raincloak/furcloak/brown,
		/obj/item/clothing/cloak/raincloak/furcloak/black,
		/obj/item/clothing/cloak/raincloak/furcloak, //White
		/obj/item/clothing/cloak/volfmantle,
	)

/datum/npc_loadout/kit/orc_fur_flavor/footsoldier
	beltl = list(
		/obj/item/repair_kit/bad = 8, //So you can get repair kits easier from looting them
		NPC_NOTHING = 92,
	)
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar = 10, //SHATTER MY BINDS
		NPC_NOTHING = 90,
	)
	pants = /obj/item/clothing/under/roguetown/loincloth
	shoes = /obj/item/clothing/shoes/roguetown/gladiator

/datum/npc_loadout/kit/orc_fur_flavor/marauder
	beltl = list(
		/obj/item/repair_kit/bad = 10, //So you can get repair kits easier from looting them
		NPC_NOTHING = 90,
	)
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar = 10, //SHATTER MY BINDS
		NPC_NOTHING = 90,
	)

/datum/npc_loadout/kit/orc_fur_flavor/berserker
	beltl = list(
		/obj/item/repair_kit/bad = 15, //So you can get repair kits easier from looting them
		NPC_NOTHING = 85,
	)
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar = 20, //SHATTER MY BINDS
		NPC_NOTHING = 80,
	)

/datum/npc_loadout/kit/orc_fur_flavor/warlord
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/black //Cosmetic + Holding repair kits for looting mostly.
	beltl = list(
		/obj/item/repair_kit/bad = 50, //So you can get repair kits easier from looting them
		NPC_NOTHING = 50,
	)
	beltr = list(
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 66, //Small heal to loot since they do a lot of damage
		NPC_NOTHING = 34,
	)
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar = 60, //SHATTER MY BINDS
		NPC_NOTHING = 40,
	)

//** WEAPONS **//

/datum/npc_loadout/weapon/orc_axe_shield
	r_hand = /obj/item/rogueweapon/stoneaxe/boneaxe
	l_hand = /obj/item/rogueweapon/shield/wood

/datum/npc_loadout/weapon/orc_bow
	r_hand = /obj/item/rogueweapon/stoneaxe/boneaxe
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/quiver/npc

/datum/npc_loadout/weapon/orc_footsoldier
	weapons = list(
		list(/obj/item/rogueweapon/stoneaxe/boneaxe),
		list(/obj/item/rogueweapon/spear/bonespear, /obj/item/rogueweapon/shield/wood), // Help preserve integrity
		list(/obj/item/rogueweapon/mace/cudgel/copper),
	)

/datum/npc_loadout/weapon/orc_marauder
	weapons = list(
		list(/obj/item/rogueweapon/spear),
		list(/obj/item/rogueweapon/sword/short/falchion, /obj/item/rogueweapon/shield/wood), // Help preserve integrity
		list(/obj/item/rogueweapon/mace), // Threat to parry-er
		list(/obj/item/rogueweapon/greataxe),
		list(/obj/item/rogueweapon/pick/militia),
	)

/datum/npc_loadout/weapon/orc_berserker
	traits = list(TRAIT_DUALWIELDER)
	weapons = list(
		list(/obj/item/rogueweapon/huntingknife/idagger, /obj/item/rogueweapon/huntingknife/idagger),
		list(/obj/item/rogueweapon/stoneaxe/handaxe, /obj/item/rogueweapon/stoneaxe/handaxe),
		list(/obj/item/rogueweapon/sword/sabre/bronzekhopesh, /obj/item/rogueweapon/sword/sabre/bronzekhopesh),
	)

/datum/npc_loadout/weapon/orc_warlord
	weapons = list(
		list(/obj/item/rogueweapon/halberd/bardiche),
		list(/obj/item/rogueweapon/halberd),
		list(/obj/item/rogueweapon/greataxe),
		list(/obj/item/rogueweapon/eaglebeak/lucerne),
		list(/obj/item/rogueweapon/mace/goden),
		list(/obj/item/rogueweapon/greatsword/iron),
	)
