//** ARCHETYPES **//

/datum/npc_archetype/mad_touched
	abstract_type = /datum/npc_archetype/mad_touched
	job = "Mad-touched Treasure Hunter"
	category = FACTION_MADMEN
	faction_tag = "treasure_hunters"
	// The mask does not let them feel the arm giving out, so they swing harder and longer than the grid assumes.
	stat_modifiers = list("strength" = 2, "speed" = 2, "constitution" = 2)
	melee = SKILL_LEVEL_APPRENTICE
	brawl = SKILL_LEVEL_JOURNEYMAN
	survival = SKILL_LEVEL_APPRENTICE
	skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
	)

/datum/npc_archetype/mad_touched/hunter
	name = "Mad-touched Treasure Hunter"
	threat_point = THREAT_ELITE
	statpack = /datum/npc_statpack/light/t4
	loadouts = list(
		/datum/npc_loadout/armor/medium/mad_touched,
		/datum/npc_loadout/kit/mad_touched,
		list(
			/datum/npc_loadout/weapon/mad_touched_khopesh = 45,
			/datum/npc_loadout/weapon/mad_touched_greatsword = 33,
			/datum/npc_loadout/weapon/mad_touched_buckler = 22,
		),
	)

/datum/npc_archetype/mad_touched/marksman
	name = "Mad-touched Marksman"
	job = "Mad-touched Marksman"
	threat_point = THREAT_ELITE
	statpack = /datum/npc_statpack/marksman/t3
	skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
	)
	ai_controller = /datum/ai_controller/human_npc/archer
	loadouts = list(
		/datum/npc_loadout/armor/medium/mad_touched,
		/datum/npc_loadout/kit/mad_touched,
		/datum/npc_loadout/kit/mad_touched/marksman,
		list(
			/datum/npc_loadout/weapon/mad_touched_khopesh = 45,
			/datum/npc_loadout/weapon/mad_touched_greatsword = 33,
			/datum/npc_loadout/weapon/mad_touched_buckler = 22,
		),
		/datum/npc_loadout/weapon/mad_touched_bow,
	)

//** ARMOR **//

/datum/npc_loadout/armor/medium/mad_touched
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy
	pants = /obj/item/clothing/under/roguetown/platelegs/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron/banded
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	shirt = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson = 80,
		/obj/item/clothing/suit/roguetown/armor/gambeson/light = 20,
	)

//** FLAVOR **//

/datum/npc_loadout/kit/mad_touched
	mask = /obj/item/clothing/mask/rogue/facemask/steel/paalloy/mad_touched
	cloak = /obj/item/clothing/cloak/wickercloak
	belt = /obj/item/storage/belt/rogue/leather
	head = list(
		/obj/item/clothing/head/roguetown/menacing/mad_touched_treasure_hunter = 50,
		/obj/item/clothing/head/roguetown/menacing/bandit/mad_touched_treasure_hunter = 50, //IS THIS TRVE?!
	)
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy = 10, //ZIZO. ZIZO. ZIZO.
		/obj/item/clothing/neck/roguetown/psicross/aalloy = 10,
		/obj/item/clothing/neck/roguetown/psicross/noc/aalloy = 10,
		/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios = 10,
		NPC_NOTHING = 60,
	)
	beltl = list(
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 33,
		NPC_NOTHING = 67,
	)

// The cursed mask is a closed face, so the marksman keeps the open sack hood instead.
/datum/npc_loadout/kit/mad_touched/marksman
	clear_slots = list("mask", "neck")
	armor = /obj/item/clothing/suit/roguetown/shirt/rags
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather

//** WEAPONS **//

/datum/npc_loadout/weapon/mad_touched_khopesh
	traits = list(TRAIT_DUALWIELDER) //Making them an absolute menace again
	r_hand = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
	l_hand = /obj/item/rogueweapon/sword/sabre/bronzekhopesh

/datum/npc_loadout/weapon/mad_touched_greatsword
	r_hand = /obj/item/rogueweapon/greatsword/paalloy

/datum/npc_loadout/weapon/mad_touched_buckler
	r_hand = /obj/item/rogueweapon/shield/buckler
	l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger

/datum/npc_loadout/weapon/mad_touched_bow
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/quiver/randomfill/highwayman
