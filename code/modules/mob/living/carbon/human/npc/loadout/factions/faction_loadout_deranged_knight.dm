//** ARCHETYPES **//

/datum/npc_archetype/deranged_knight
	abstract_type = /datum/npc_archetype/deranged_knight
	job = "Ascendant Knight"
	category = FACTION_MADMEN
	faction_tag = "FACTION_DUNDEAD"
	// Tough and mostly admin-exclusive minibosses
	traits = list(TRAIT_STEELHEARTED)
	melee = SKILL_LEVEL_EXPERT
	magic = SKILL_LEVEL_EXPERT
	brawl = SKILL_LEVEL_EXPERT
	survival = SKILL_LEVEL_APPRENTICE
	athletics = SKILL_LEVEL_EXPERT

//** ZIZO. ZIZO. ZIZO. **//
/datum/npc_archetype/deranged_knight/zizo
	name = "Zizite Templar"
	statpack = /datum/npc_statpack/line/t4
	stat_modifiers = list("intelligence" = 1)
	patron = /datum/patron/inhumen/zizo
	armor_training = ARMOR_CLASS_MEDIUM
	ai_controller = /datum/ai_controller/human_npc/caster/melee
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/zizo,
		/datum/npc_loadout/kit/zizo_flavor,
		/datum/npc_loadout/weapon/zizo,
		/datum/npc_loadout/kit/zizo_cantrip,
	)

/datum/npc_archetype/deranged_knight/zizo_heavy
	name = "Zizite Champion"
	statpack = /datum/npc_statpack/heavy/t4
	stat_modifiers = list("intelligence" = 1)
	patron = /datum/patron/inhumen/zizo
	armor_training = ARMOR_CLASS_HEAVY
	ai_controller = /datum/ai_controller/human_npc/caster/melee
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/zizo_heavy,
		/datum/npc_loadout/kit/zizo_flavor,
		/datum/npc_loadout/weapon/zizo_heavy,
		/datum/npc_loadout/kit/zizo_cantrip,
	)

//** GRAGGAR. GRAGGAR. GRAGGAR. **//
/datum/npc_archetype/deranged_knight/graggar
	name = "Graggarite Templar"
	statpack = /datum/npc_statpack/line/t4
	stat_modifiers = list("strength" = 2)
	patron = /datum/patron/inhumen/graggar
	armor_training = ARMOR_CLASS_MEDIUM
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/graggar,
		/datum/npc_loadout/kit/graggar_flavor,
		/datum/npc_loadout/weapon/graggar,
	)

/datum/npc_archetype/deranged_knight/graggar_heavy
	name = "Graggarite Champion"
	statpack = /datum/npc_statpack/heavy/t4
	stat_modifiers = list("strength" = 2)
	patron = /datum/patron/inhumen/graggar
	armor_training = ARMOR_CLASS_HEAVY
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/graggar_heavy,
		/datum/npc_loadout/kit/graggar_flavor,
		/datum/npc_loadout/weapon/graggar_heavy,
	)

//** MATTHIOS IS THIS TRVE? **//
/datum/npc_archetype/deranged_knight/matthios_heavy
	name = "Matthiosian Champion"
	statpack = /datum/npc_statpack/heavy/t4
	stat_modifiers = list("willpower" = 2)
	patron = /datum/patron/inhumen/matthios
	armor_training = ARMOR_CLASS_HEAVY
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/matthios_heavy,
		/datum/npc_loadout/kit/matthios_flavor,
		/datum/npc_loadout/weapon/matthios_heavy,
	)

//** BAOTHA, YOU ARE EVEEERYTHING! **//
/datum/npc_archetype/deranged_knight/baotha
	name = "Baothan Champion"
	statpack = /datum/npc_statpack/light/t4
	stat_modifiers = list("speed" = 2)
	patron = /datum/patron/inhumen/baotha
	armor_training = ARMOR_CLASS_LIGHT
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/baotha,
		/datum/npc_loadout/kit/baotha_flavor,
		/datum/npc_loadout/weapon/baotha,
	)

//** CASTING **//

/datum/npc_loadout/kit/zizo_cantrip
	traits = list(TRAIT_WARLOCK) //to use w/ weapon
	spells = list(/datum/action/cooldown/spell/projectile/greater_arcyne_bolt, /datum/action/cooldown/spell/projectile/spitfire, /datum/action/cooldown/spell/projectile/arc_bolt, /datum/action/cooldown/spell/projectile/arcyne_lance)

//** FLAVOR **//

/datum/npc_loadout/kit/zizo_flavor
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen = 25,
		/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy = 25,
		/obj/item/clothing/neck/roguetown/psicross/inhumen/g = 1,
		/obj/item/clothing/neck/roguetown/psicross/inhumen/paalloy = 10,
		/obj/item/clothing/neck/roguetown/psicross/inhumen/bronze = 15,
		NPC_NOTHING = 60,
	)
	belt = list(
		/obj/item/storage/belt/rogue/leather/steel/tasset,
		/obj/item/storage/belt/rogue/leather,
		/obj/item/storage/belt/rogue/leather/black,
	)

/datum/npc_loadout/kit/graggar_flavor
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar = 25,
		/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/g = 1,
		/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/bronze = 16,
		NPC_NOTHING = 40,
	)
	belt = list(
		/obj/item/storage/belt/rogue/leather/steel/tasset,
		/obj/item/storage/belt/rogue/leather,
		/obj/item/storage/belt/rogue/leather/black,
	)

/datum/npc_loadout/kit/matthios_flavor
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios = 30,
		/obj/item/clothing/neck/roguetown/psicross/astrata/g/triumph = 15, //is this TRVE?
		/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/g = 1,
		NPC_NOTHING = 40,
	)
	belt = list(
		/obj/item/storage/belt/rogue/leather/plaquegold,
		/obj/item/storage/belt/rogue/leather/plaquegold/noble,
		/obj/item/storage/belt/rogue/leather,
		/obj/item/storage/belt/rogue/leather/black,
	)

/datum/npc_loadout/kit/baotha_flavor
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen/baotha = 30,
		/obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/g = 1,
		NPC_NOTHING = 40,
	)
	belt = list(
		/obj/item/storage/belt/rogue/leather/plaquegold,
		/obj/item/storage/belt/rogue/leather/plaquegold/noble,
		/obj/item/storage/belt/rogue/leather,
		/obj/item/storage/belt/rogue/leather/black,
	)

//** WEAPONS **//

/datum/npc_loadout/weapon/zizo
	weapons = list(
		list(/obj/item/rogueweapon/sword/zizo, /obj/item/rogueweapon/shield/tower/metal/zizo, 100),
	)

/datum/npc_loadout/weapon/zizo_heavy
	weapons = list(
		list(/obj/item/rogueweapon/sword/long/zizo),
	)

/datum/npc_loadout/weapon/graggar
	weapons = list(
		list(/obj/item/rogueweapon/greataxe/steel/doublehead/graggar),
	)

/datum/npc_loadout/weapon/graggar_heavy
	weapons = list(
		list(/obj/item/rogueweapon/stoneaxe/woodcut/steel/graggar, /obj/item/rogueweapon/shield/iron/graggar, 100),
	)

/datum/npc_loadout/weapon/matthios_heavy
	weapons = list(
		list(/obj/item/rogueweapon/flail/peasantwarflail/matthios),
	)

/datum/npc_loadout/weapon/baotha
	traits = list(TRAIT_DODGEEXPERT)
	weapons = list(
		list(/obj/item/rogueweapon/spear/partizan/baotha),
	)
