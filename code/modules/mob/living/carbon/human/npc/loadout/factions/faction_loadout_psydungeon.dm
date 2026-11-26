//** ARCHETYPES **//

/datum/npc_archetype/psy_vault_guard
	name = "Psydonite Tomb Monk"
	job = "Psydonite Tomb Monk"
	category = FACTION_PSY_VAULT_GUARD
	faction_tag = "psy_vault_guard"
	statpack = /datum/npc_statpack/line/t3 //fallback
	patron = /datum/patron/old_god //PSYDON WILL ENDVRE
	armor_training = ARMOR_CLASS_MEDIUM //all of them can use maile
	melee = SKILL_LEVEL_JOURNEYMAN
	magic = SKILL_LEVEL_JOURNEYMAN
	brawl = SKILL_LEVEL_EXPERT
	survival = SKILL_LEVEL_JOURNEYMAN

//** BEGIN CLASS VARIENT ARCHETYPES **//

/datum/npc_archetype/psy_vault_guard/guardian
	name = "Psydonite Tomb Gaurdian"
	job = "Psydonite Tomb Gaurdian"
	threat_point = THREAT_TOUGH
	statpack = /datum/npc_statpack/line/t3
	melee = SKILL_LEVEL_EXPERT //'LETS FRAG', 'JUST THIS ONCE'
	traits = list(TRAIT_PSYDONITE, TRAIT_CRITICAL_RESISTANCE, TRAIT_BIGGUY) //devotee + critical resistance monster
	loadouts = list(
		/datum/npc_loadout/weapon/psy_vault_guard_melee_weapon,
		/datum/npc_loadout/kit/psy_vault_guard_flavor,
		/datum/npc_loadout/armor/medium/psy_vault_guard
	)
	ai_controller = /datum/ai_controller/human_npc

//Few and far between, most of the monks rely on blades or magic. These ones just exist to catch you off-guard if your armor breaks from a distance.
/datum/npc_archetype/psy_vault_guard/archer
	name = "Psydonite Tomb Archer"
	job = "Psydonite Tomb Archer"
	statpack = /datum/npc_statpack/marksman/t3
	//weaker up close, b.c they get master in bows otherwise to kill you.
	traits = list(TRAIT_PSYDONITE) //devotee + archer so no crit resist
	skills = list(/datum/skill/combat/bows = SKILL_LEVEL_MASTER)
	loadouts = list(
		/datum/npc_loadout/weapon/psy_vault_guard_ranged_weapon,
		/datum/npc_loadout/kit/psy_vault_guard_flavor,
		/datum/npc_loadout/armor/medium/psy_vault_lighter //squishier if you limb-aim
	)
	ai_controller = /datum/ai_controller/human_npc/archer

//Entryway Mages

/datum/npc_archetype/psy_vault_guard/magemonk
	name = "Psydonite Tomb Magemonk"
	job = "Psydonite Tomb Magemonk"
	statpack = /datum/npc_statpack/caster/t3
	traits = list(TRAIT_PSYDONITE, TRAIT_WARLOCK) //devotee + mage so no crit resist
	//journeyman tradeoff for weapon + cantrip + decent light armor + can cast w/out penalty
	loadouts = list(
		/datum/npc_loadout/kit/psy_vault_guard_magemonk_flavor,
		/datum/npc_loadout/kit/psytomb_mage_lesser,
		/datum/npc_loadout/armor/medium/psy_vault_mage, //squishier if you limb-aim - naledi themed
	)
	ai_controller = /datum/ai_controller/human_npc/caster/melee

/datum/npc_archetype/psy_vault_guard/magemonk_entry
	name = "Psydonite Tomb Sentinal"
	job = "Psydonite Tomb Sentinal"
	statpack = /datum/npc_statpack/caster/t2 //get up close and they're dead-meat
	traits = list(TRAIT_PSYDONITE, TRAIT_WARLOCK) //devotee + mage so no crit resist
	//journeyman tradeoff for weapon + cantrip + decent light armor + can cast w/out penalty
	loadouts = list(
		/datum/npc_loadout/kit/psy_vault_guard_flavor,
		/datum/npc_loadout/kit/psytomb_mage_lesser_entry,
		/datum/npc_loadout/armor/medium/psy_vault_lighter, //squishier if you limb-aim - otavan themed
	)
	ai_controller = /datum/ai_controller/human_npc/caster/melee

//** FULL CASTERS **//

/datum/npc_archetype/psy_vault_guard/caster
	name = "Psydonite Tomb Magos"
	job = "Psydonite Tomb Magos"
	statpack = /datum/npc_statpack/caster/t4 //final boss to the dungeon, expect a hell of a fight.
	magic = SKILL_LEVEL_EXPERT
	//keep in mind, journeyman melee IS intended, this is a maile-armored mage NPC. VERY STRONG.
	traits = list(TRAIT_PSYDONITE)

/datum/npc_archetype/psy_vault_guard/caster/mixed
	variants = list(
		/datum/npc_archetype/psy_vault_guard/caster/telomancer = 1,
		/datum/npc_archetype/psy_vault_guard/caster/cryomancer = 1,
		/datum/npc_archetype/psy_vault_guard/caster/fulgurmancer = 1,
	)

//** CASTER SUBTYPES **//

/datum/npc_archetype/psy_vault_guard/caster/telomancer
	name = "Psydonite Tomb Telomancer"
	job = "Psydonite Tomb Telomancer"
	loadouts = list(
		/datum/npc_loadout/kit/psy_vault_guard_caster_flavor,
		/datum/npc_loadout/armor/medium/psy_vault_mage, //squishier if you limb-aim - naledi themed
		/datum/npc_loadout/kit/telomancer_psymonk,
	)
	ai_controller = /datum/ai_controller/human_npc/caster

/datum/npc_archetype/psy_vault_guard/caster/cryomancer
	name = "Psydonite Tomb Cryomancer"
	job = "Psydonite Tomb Cryomancer"
	loadouts = list(
		/datum/npc_loadout/kit/psy_vault_guard_caster_flavor,
		/datum/npc_loadout/armor/medium/psy_vault_mage, //squishier if you limb-aim - naledi themed
		/datum/npc_loadout/kit/cryomancer_psymonk,
	)
	ai_controller = /datum/ai_controller/human_npc/caster

/datum/npc_archetype/psy_vault_guard/caster/fulgurmancer
	name = "Psydonite Tomb Fulgurmancer"
	job = "Psydonite Tomb Fulgurmancer"
	loadouts = list(
		/datum/npc_loadout/kit/psy_vault_guard_caster_flavor,
		/datum/npc_loadout/armor/medium/psy_vault_mage, //squishier if you limb-aim - naledi themed
		/datum/npc_loadout/kit/fulgurmancer_psymonk,
	)
	ai_controller = /datum/ai_controller/human_npc/caster

//** CASTER STUFF **//
/datum/npc_loadout/kit/telomancer_psymonk
	magic_aspects = list(
		/datum/magic_aspect/telomancy,
	)
	spells = list(/datum/action/cooldown/spell/blink/shadowstep) //unique addition of shadowstep on TOP of their mage skillset
	r_hand = /obj/item/rogueweapon/woodstaff/implement/grand/naledi

/datum/npc_loadout/kit/cryomancer_psymonk
	magic_aspects = list(
		/datum/magic_aspect/telomancy,
	)
	spells = list(/datum/action/cooldown/spell/blink/shadowstep) //unique addition of shadowstep on TOP of their mage skillset
	r_hand = /obj/item/rogueweapon/woodstaff/implement/grand/naledi

/datum/npc_loadout/kit/fulgurmancer_psymonk
	magic_aspects = list(
		/datum/magic_aspect/telomancy,
	)
	spells = list(/datum/action/cooldown/spell/blink/shadowstep) //unique addition of shadowstep on TOP of their mage skillset
	r_hand = /obj/item/rogueweapon/woodstaff/implement/grand/naledi

//** FLAVOR **//

/datum/npc_loadout/kit/psy_vault_guard_flavor
	belt = list(
		/obj/item/storage/belt/rogue/leather/rope/upgraded/dark = 1,
		/obj/item/storage/belt/rogue/leather/sash = 2,
	)
	beltr = list(
		/obj/item/storage/belt/rogue/pouch/food = 15,
		/obj/item/storage/belt/rogue/pouch/medicine = 15,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 20,
		/obj/item/reagent_containers/glass/bottle/waterskin = 10,
		/obj/item/rope/chain = 30,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 20,
		NPC_NOTHING = 25,
	)
	beltl = list(
		/obj/item/clothing/neck/roguetown/psicross = 40,
		/obj/item/book/rogue/bibble/psy = 40,
		/obj/item/clothing/neck/roguetown/psicross/silver = 20,
	)
	id = list(
		/obj/item/clothing/neck/roguetown/psicross = 40,
		/obj/item/clothing/ring/silver/cleric = 20,
		/obj/item/clothing/neck/roguetown/psicross/silver = 10,
		NPC_NOTHING = 30,
	)
	cloak = list(
		/obj/item/clothing/cloak/absolutionistrobe/black = 10,
		/obj/item/clothing/cloak/tabard/psydontabard/black = 40,
		NPC_NOTHING = 25,
	)

/datum/npc_loadout/kit/psy_vault_guard_caster_flavor
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded/dark
	beltr = list(
		/obj/item/storage/belt/rogue/pouch/food = 15,
		/obj/item/storage/belt/rogue/pouch/medicine = 15,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 20,
		/obj/item/reagent_containers/glass/bottle/waterskin = 10,
		/obj/item/rope/chain = 30,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 20,
	)
	beltl = /obj/item/clothing/neck/roguetown/psicross/g
	id = /obj/item/clothing/neck/roguetown/psicross/naledi
	cloak = list(
		/obj/item/clothing/cloak/hierophant = 2,
		/obj/item/clothing/suit/roguetown/shirt/robe/pointfex = 1,
	)

/datum/npc_loadout/kit/psy_vault_guard_magemonk_flavor
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded/dark
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
		/obj/item/clothing/neck/roguetown/psicross/g = 20,
	)
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/g = 30,
		/obj/item/clothing/neck/roguetown/psicross/naledi = 40,
		NPC_NOTHING = 30,
	)
	cloak = list(
		/obj/item/clothing/cloak/tabard/psydontabard/black = 1,
		NPC_NOTHING = 15,
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

/datum/npc_loadout/kit/psytomb_mage_lesser
	spells = list(/datum/action/cooldown/spell/projectile/arc_bolt, /datum/action/cooldown/spell/blink/shadowstep) //unique lbolt into shadowstep skillset, w/ quarterstaff melee
	weapons = list(
		list(/obj/item/rogueweapon/woodstaff/quarterstaff/steel),
	)

/datum/npc_loadout/kit/psytomb_mage_lesser_entry
	spells = list(/datum/action/cooldown/spell/projectile/lightning_bolt) //no shadowstep so they don't teleport, focuses on stronger lbolts
	weapons = list(
		list(/obj/item/rogueweapon/woodstaff/quarterstaff/iron), //weaker
	)
