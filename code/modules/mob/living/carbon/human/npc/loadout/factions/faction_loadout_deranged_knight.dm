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
	stat_modifiers = list("intelligence" = 1, "willpower" = 1)
	patron = /datum/patron/inhumen/zizo
	armor_training = ARMOR_CLASS_MEDIUM
	body = /datum/npc_body/northern_commoner/soldier/deranged_knight
	ai_controller = /datum/ai_controller/human_npc
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/zizo,
		/datum/npc_loadout/kit/zizo_flavor,
		/datum/npc_loadout/weapon/zizo,
	)

/datum/npc_archetype/deranged_knight/zizo/mixed
	name = "Zizite Templar Mix"
	variants = list(
		/datum/npc_archetype/deranged_knight/zizo = 1, //not every zizite knight is a caster, sire.
		/datum/npc_archetype/deranged_knight/zizo/spitfire = 2,
		/datum/npc_archetype/deranged_knight/zizo/arcyne_bolt = 2,
		/datum/npc_archetype/deranged_knight/zizo/arc_bolt = 2,
	)

//** ZIZO. ZIZO. ZIZO. (Caster Subtypes) **//

/datum/npc_archetype/deranged_knight/zizo/spitfire
	name = "Zizite Templar Fyrespitter"
	statpack = /datum/npc_statpack/line/t4
	stat_modifiers = list("intelligence" = 1)
	patron = /datum/patron/inhumen/zizo
	armor_training = ARMOR_CLASS_MEDIUM
	body = /datum/npc_body/northern_commoner/soldier/deranged_knight
	ai_controller = /datum/ai_controller/human_npc/caster/melee
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/zizo,
		/datum/npc_loadout/kit/zizo_flavor,
		/datum/npc_loadout/weapon/zizo,
		/datum/npc_loadout/kit/zizo_cantrip_spitfire,
	)

/datum/npc_archetype/deranged_knight/zizo/arcyne_bolt
	name = "Zizite Templar Arcyne Bolter"
	statpack = /datum/npc_statpack/line/t4
	stat_modifiers = list("intelligence" = 1)
	patron = /datum/patron/inhumen/zizo
	armor_training = ARMOR_CLASS_MEDIUM
	body = /datum/npc_body/northern_commoner/soldier/deranged_knight
	ai_controller = /datum/ai_controller/human_npc/caster/melee
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/zizo,
		/datum/npc_loadout/kit/zizo_flavor,
		/datum/npc_loadout/weapon/zizo,
		/datum/npc_loadout/kit/zizo_cantrip_arcyne_bolt,
	)

/datum/npc_archetype/deranged_knight/zizo/arc_bolt
	name = "Zizite Templar Arc Bolter"
	statpack = /datum/npc_statpack/line/t4
	stat_modifiers = list("intelligence" = 1)
	patron = /datum/patron/inhumen/zizo
	armor_training = ARMOR_CLASS_MEDIUM
	body = /datum/npc_body/northern_commoner/soldier/deranged_knight
	ai_controller = /datum/ai_controller/human_npc/caster/melee
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/zizo,
		/datum/npc_loadout/kit/zizo_flavor,
		/datum/npc_loadout/weapon/zizo,
		/datum/npc_loadout/kit/zizo_cantrip_arc_bolt,
	)

//** ZIZO. ZIZO. ZIZO. (Heavy) **//

/datum/npc_archetype/deranged_knight/zizo_heavy
	name = "Zizite Champion"
	statpack = /datum/npc_statpack/heavy/t4
	stat_modifiers = list("intelligence" = 1, "willpower" = 1)
	patron = /datum/patron/inhumen/zizo
	armor_training = ARMOR_CLASS_HEAVY
	ai_controller = /datum/ai_controller/human_npc
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/zizo_heavy,
		/datum/npc_loadout/kit/zizo_flavor,
		/datum/npc_loadout/weapon/zizo_heavy,
	)

/datum/npc_archetype/deranged_knight/zizo_heavy/mixed
	name = "Zizite Champion Mix"
	variants = list(
		/datum/npc_archetype/deranged_knight/zizo_heavy = 1, //not every zizite knight is a caster, sire.
		/datum/npc_archetype/deranged_knight/zizo_heavy/spitfire = 2,
		/datum/npc_archetype/deranged_knight/zizo_heavy/arcyne_bolt = 2,
		/datum/npc_archetype/deranged_knight/zizo_heavy/arc_bolt = 2,
	)

//** ZIZO. ZIZO. ZIZO. (Caster Subtypes) **//

/datum/npc_archetype/deranged_knight/zizo_heavy/spitfire
	name = "Zizite Champion Fyrespitter"
	statpack = /datum/npc_statpack/heavy/t4
	stat_modifiers = list("intelligence" = 1)
	patron = /datum/patron/inhumen/zizo
	armor_training = ARMOR_CLASS_HEAVY
	ai_controller = /datum/ai_controller/human_npc/caster/melee
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/zizo_heavy,
		/datum/npc_loadout/kit/zizo_flavor,
		/datum/npc_loadout/weapon/zizo_heavy,
		/datum/npc_loadout/kit/zizo_cantrip_spitfire,
	)

/datum/npc_archetype/deranged_knight/zizo_heavy/arcyne_bolt
	name = "Zizite Champion Arcyne Bolter"
	statpack = /datum/npc_statpack/heavy/t4
	stat_modifiers = list("intelligence" = 1)
	patron = /datum/patron/inhumen/zizo
	armor_training = ARMOR_CLASS_HEAVY
	ai_controller = /datum/ai_controller/human_npc/caster/melee
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/zizo_heavy,
		/datum/npc_loadout/kit/zizo_flavor,
		/datum/npc_loadout/weapon/zizo_heavy,
		/datum/npc_loadout/kit/zizo_cantrip_arcyne_bolt,
	)

/datum/npc_archetype/deranged_knight/zizo_heavy/arc_bolt
	name = "Zizite Champion Arc Bolter"
	statpack = /datum/npc_statpack/heavy/t4
	stat_modifiers = list("intelligence" = 1)
	patron = /datum/patron/inhumen/zizo
	armor_training = ARMOR_CLASS_HEAVY
	ai_controller = /datum/ai_controller/human_npc/caster/melee
	loadouts = list(
		/datum/npc_loadout/armor/luxplate/zizo_heavy,
		/datum/npc_loadout/kit/zizo_flavor,
		/datum/npc_loadout/weapon/zizo_heavy,
		/datum/npc_loadout/kit/zizo_cantrip_arc_bolt,
	)

//** GRAGGAR. GRAGGAR. GRAGGAR. **//
/datum/npc_archetype/deranged_knight/graggar
	name = "Graggarite Templar"
	statpack = /datum/npc_statpack/line/t4
	stat_modifiers = list("strength" = 2)
	patron = /datum/patron/inhumen/graggar
	armor_training = ARMOR_CLASS_MEDIUM
	traits = list(TRAIT_STRENGTH_UNCAPPED) ///GRAGGAR SHATTER MYNE BINDS
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
	traits = list(TRAIT_STRENGTH_UNCAPPED) ///GRAGGAR SHATTER MYNE BINDS
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

//** HEAD BOUNTIES **//

/datum/npc_body/northern_commoner/soldier/deranged_knight/get_head_sellprice()
	return HEAD_BOUNTY_BIG_GUY

//** CASTING **//

/datum/npc_loadout/kit/zizo_cantrip_spitfire
	traits = list(TRAIT_WARLOCK) //to use w/ weapon
	spells = list(/datum/action/cooldown/spell/projectile/spitfire)

/datum/npc_loadout/kit/zizo_cantrip_arcyne_bolt
	traits = list(TRAIT_WARLOCK) //to use w/ weapon
	spells = list(/datum/action/cooldown/spell/projectile/greater_arcyne_bolt)

/datum/npc_loadout/kit/zizo_cantrip_arc_bolt
	traits = list(TRAIT_WARLOCK) //to use w/ weapon
	spells = list(/datum/action/cooldown/spell/projectile/arc_bolt)

//** FLAVOR **//

/datum/npc_loadout/kit/zizo_flavor
	id = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen = 25,
		/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy = 25,
		/obj/item/clothing/neck/roguetown/psicross/inhumen/g = 1,
		/obj/item/clothing/neck/roguetown/psicross/inhumen/paalloy = 10,
		/obj/item/clothing/neck/roguetown/psicross/inhumen/bronze = 15,
		NPC_NOTHING = 30,
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
		NPC_NOTHING = 20,
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
		NPC_NOTHING = 20,
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
		NPC_NOTHING = 20,
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
	weapons = list(
		list(/obj/item/rogueweapon/spear/partizan/baotha),
	)
