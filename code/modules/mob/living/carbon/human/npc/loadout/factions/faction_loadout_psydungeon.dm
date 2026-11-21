//** ARCHETYPES **//

/datum/npc_archetype/psy_vault_guard
	name = "Psydonite Tomb Monk"
	job = "Psydonite Tomb Monk"
	category = FACTION_PSY_VAULT_GUARD
	faction_tag = "psy_vault_guard"
	body = /datum/npc_body/psyvault
	statpack = /datum/npc_statpack/line/t1
	armor_training = ARMOR_CLASS_MEDIUM //all of them can use maile
	melee = SKILL_LEVEL_APPRENTICE
	magic = SKILL_LEVEL_JOURNEYMAN
	brawl = SKILL_LEVEL_EXPERT
	survival = SKILL_LEVEL_JOURNEYMAN

/datum/npc_archetype/psy_vault_guard/guardian
	name = "Psydonite Tomb Gaurdian"
	job = "Psydonite Tomb Gaurdian"
	threat_point = THREAT_TOUGH
	statpack = /datum/npc_statpack/line/t3
	melee = SKILL_LEVEL_EXPERT //'LETS FRAG', 'JUST THIS ONCE'
	skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER, //you ain't tackling this big guy, sire.
	)
	loadouts = list(
		/datum/npc_loadout/weapon/psy_vault_guard_melee_weapon,
		/datum/npc_loadout/kit/psy_vault_guard_flavor,
		/datum/npc_loadout/weapon/bandit_melee,
	)

/datum/npc_archetype/psy_vault_guard/archer
	name = "Psydonite Tomb Archer"
	job = "Psydonite Tomb Archer"
	statpack = /datum/npc_statpack/marksman/t3
	skills = list(/datum/skill/combat/bows = SKILL_LEVEL_MASTER) //parry this you filthy casual
	loadouts = list(
		/datum/npc_loadout/weapon/psy_vault_guard_ranged_weapon,
		/datum/npc_loadout/kit/psy_vault_guard_flavor,
		/datum/npc_loadout/weapon/bandit_bow,
	)
	ai_controller = /datum/ai_controller/human_npc/archer

/datum/npc_loadout/kit/psy_vault_guard_flavor
	belt = list(
		/obj/item/storage/belt/rogue/leather/rope/upgraded/dark = 60,
		/obj/item/storage/belt/rogue/leather/sash = 30,
		/obj/item/storage/belt/rogue/leather/tossbelt/blade/black/steel = 10, //because I am evil
	)
	beltr = list(
		/obj/item/storage/belt/rogue/pouch/food = 15,
		/obj/item/storage/belt/rogue/pouch/medicine = 15,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 20,
		/obj/item/reagent_containers/glass/bottle/waterskin = 10,
		/obj/item/rope/chain = 30,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 20,
	)
	beltl = list(
		/obj/item/clothing/neck/roguetown/psicross = 40,
		/obj/item/book/rogue/bibble/psy = 40,
		/obj/item/clothing/neck/roguetown/psicross/silver = 20,
	)
	id = list(
		/obj/item/clothing/neck/roguetown/psicross = 40,
		/obj/item/clothing/ring/silver/cleric = 40,
		/obj/item/clothing/neck/roguetown/psicross/silver = 20,
	)
	cloak = list(
		/obj/item/clothing/cloak/absolutionistrobe/black = 15,
		/obj/item/clothing/cloak/tabard/psydontabard/black = 40,
		NPC_NOTHING = 45,
	)

//** WEAPONS **//

/datum/npc_loadout/weapon/psy_vault_guard_melee_weapon
	weapons = list(
		list(/obj/item/rogueweapon/sword/short/messer, /obj/item/rogueweapon/shield/tower/metal, 100),
		list(/obj/item/rogueweapon/sword/long/oldpsysword, /obj/item/rogueweapon/shield/tower/metal, 50),
		list(/obj/item/rogueweapon/eaglebeak),
		list(/obj/item/rogueweapon/greatsword/grenz/flamberge),
		list(/obj/item/rogueweapon/greataxe/steel),
		list(/obj/item/rogueweapon/mace/goden/steel),
	)

/datum/npc_loadout/weapon/psy_vault_guard_ranged_weapon
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/quiver/randomfill/highwayman
