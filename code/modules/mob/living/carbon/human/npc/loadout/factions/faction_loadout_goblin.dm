//** ARCHETYPES **//

/datum/npc_archetype/goblin
	abstract_type = /datum/npc_archetype/goblin
	job = "Goblin"
	category = FACTION_ORCS
	faction_tag = "goblins"
	statpack = /datum/npc_statpack/line/t0
	stat_modifiers = list("speed" = -2, "perception" = -2, "intelligence" = -3)
	melee = SKILL_LEVEL_APPRENTICE
	brawl = SKILL_LEVEL_APPRENTICE
	survival = SKILL_LEVEL_APPRENTICE

/datum/npc_archetype/goblin/warrior
	name = "Goblin"
	loadouts = list(
		list(
			/datum/npc_loadout/kit/goblin_spear = 20,
			/datum/npc_loadout/kit/goblin_axe = 20,
			/datum/npc_loadout/kit/goblin_club = 20,
			/datum/npc_loadout/kit/goblin_armed = 15,
			/datum/npc_loadout/kit/goblin_knives = 5,
			/datum/npc_loadout/kit/goblin_heavy = 20,
		),
	)

/datum/npc_archetype/goblin/warrior/moon
	stat_modifiers = list("perception" = -2, "intelligence" = 1)

/datum/npc_archetype/goblin/warrior/hell
	stat_modifiers = list("perception" = -2, "intelligence" = -3, "constitution" = 2)

/datum/npc_archetype/goblin/archer
	name = "Goblin Archer"
	statpack = /datum/npc_statpack/marksman/t0
	skills = list(/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE)
	loadouts = list(/datum/npc_loadout/kit/goblin_bow)
	ai_controller = /datum/ai_controller/human_npc/archer

/datum/npc_archetype/goblin/archer/moon
	stat_modifiers = list("perception" = -2, "intelligence" = 1)

/datum/npc_archetype/goblin/archer/hell
	stat_modifiers = list("perception" = -2, "intelligence" = -3, "constitution" = 2)

/datum/npc_archetype/goblin/slinger
	name = "Goblin Slinger"
	statpack = /datum/npc_statpack/marksman/t0
	skills = list(/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE)
	loadouts = list(/datum/npc_loadout/kit/goblin_sling)
	ai_controller = /datum/ai_controller/human_npc/archer

/datum/npc_archetype/goblin/slinger/moon
	stat_modifiers = list("perception" = -2, "intelligence" = 1)

/datum/npc_archetype/goblin/slinger/hell
	stat_modifiers = list("perception" = -2, "intelligence" = -3, "constitution" = 2)

/datum/npc_archetype/goblin/bomber
	name = "Goblin Pyromancer"
	job = "Goblin Pyromancer"
	loadouts = list(/datum/npc_loadout/kit/goblin_bombs)

/datum/npc_archetype/goblin/bomber/moon
	stat_modifiers = list("perception" = -2, "intelligence" = 1)

/datum/npc_archetype/goblin/bomber/hell
	stat_modifiers = list("perception" = -2, "intelligence" = -3, "constitution" = 2)

/datum/npc_archetype/goblin/siege
	name = "Goblin"
	loadouts = list(/datum/npc_loadout/kit/goblin_heavy)

//** GEAR **//

/datum/npc_loadout/kit/goblin_spear
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
	r_hand = /obj/item/rogueweapon/spear/stone

/datum/npc_loadout/kit/goblin_axe
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
	r_hand = /obj/item/rogueweapon/stoneaxe

/datum/npc_loadout/kit/goblin_club
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
	r_hand = /obj/item/rogueweapon/mace/woodclub
	head = list(
		/obj/item/clothing/head/roguetown/helmet/leather/goblin = 10,
		NPC_NOTHING = 90,
	)

/datum/npc_loadout/kit/goblin_armed
	armor = /obj/item/clothing/suit/roguetown/armor/leather/goblin
	head = list(
		/obj/item/clothing/head/roguetown/helmet/leather/goblin = 80,
		NPC_NOTHING = 20,
	)
	weapons = list(
		list(/obj/item/rogueweapon/sword/iron, /obj/item/rogueweapon/shield/wood, 30),
		list(/obj/item/rogueweapon/mace/spiked, /obj/item/rogueweapon/shield/wood, 30),
	)

/datum/npc_loadout/kit/goblin_knives
	armor = /obj/item/clothing/suit/roguetown/armor/leather/goblin
	traits = list(TRAIT_DUALWIELDER)
	r_hand = /obj/item/rogueweapon/huntingknife/stoneknife
	l_hand = /obj/item/rogueweapon/huntingknife/stoneknife
	head = list(
		/obj/item/clothing/head/roguetown/helmet/leather/goblin = 80,
		NPC_NOTHING = 20,
	)

/datum/npc_loadout/kit/goblin_heavy
	armor = list(
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/goblin = 30,
		/obj/item/clothing/suit/roguetown/armor/leather/goblin = 70,
	)
	head = list(
		/obj/item/clothing/head/roguetown/helmet/goblin = 80,
		/obj/item/clothing/head/roguetown/helmet/leather/goblin = 20,
	)
	weapons = list(
		list(/obj/item/rogueweapon/sword/iron),
		list(/obj/item/rogueweapon/mace/spiked),
		list(/obj/item/rogueweapon/flail, /obj/item/rogueweapon/shield/wood, 100),
	)

/datum/npc_loadout/kit/goblin_bow
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
	r_hand = /obj/item/rogueweapon/huntingknife/stoneknife
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/quiver/npc/stone

/datum/npc_loadout/kit/goblin_sling
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
	r_hand = /obj/item/rogueweapon/huntingknife/stoneknife
	wrists = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
	neck = /obj/item/quiver/sling/npc

/datum/npc_loadout/kit/goblin_bombs
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
	r_hand = /obj/item/rogueweapon/huntingknife/stoneknife
	neck = /obj/item/storage/belt/rogue/pouch/bombs

//** HOBGOBLIN **//

/datum/npc_archetype/hobgoblin
	name = "Hoblin"
	job = "Hoblin"
	category = FACTION_ORCS
	faction_tag = "goblins"
	statpack = /datum/npc_statpack/heavy/t1
	// No additional speed penalty
	stat_modifiers = list("perception" = -2, "intelligence" = -3)
	melee = SKILL_LEVEL_JOURNEYMAN
	brawl = SKILL_LEVEL_JOURNEYMAN
	survival = SKILL_LEVEL_JOURNEYMAN
	loadouts = list(
		list(
			/datum/npc_loadout/kit/hoblin_leather = 50,
			/datum/npc_loadout/kit/hoblin_shield = 20,
			/datum/npc_loadout/kit/hoblin_daggers = 10,
			/datum/npc_loadout/kit/hoblin_knuckles = 10,
			/datum/npc_loadout/kit/hoblin_greatsword = 10,
		),
	)

/datum/npc_loadout/kit/hoblin_leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
	head = list(
		/obj/item/clothing/head/roguetown/helmet/leather/hobgoblin = 35,
		/obj/item/clothing/head/roguetown/helmet/hobgoblin = 10,
		NPC_NOTHING = 55,
	)
	weapons = list(
		list(/obj/item/rogueweapon/spear),
		list(/obj/item/rogueweapon/stoneaxe/handaxe),
		list(/obj/item/rogueweapon/mace),
		list(/obj/item/rogueweapon/sword/short/messer/iron),
		list(/obj/item/rogueweapon/mace/warhammer),
	)

/datum/npc_loadout/kit/hoblin_shield
	head = list(
		/obj/item/clothing/head/roguetown/helmet/hobgoblin = 60,
		/obj/item/clothing/head/roguetown/helmet/leather/hobgoblin = 40,
	)
	armor = list(
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin = 60,
		/obj/item/clothing/suit/roguetown/armor/leather/hobgoblin = 40,
	)
	weapons = list(
		list(/obj/item/rogueweapon/sword/short/iron, /obj/item/rogueweapon/shield/heater, 100),
		list(/obj/item/rogueweapon/spear, /obj/item/rogueweapon/shield/heater, 100),
	)

/datum/npc_loadout/kit/hoblin_daggers
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
	r_hand = /obj/item/rogueweapon/huntingknife/idagger
	l_hand = /obj/item/rogueweapon/huntingknife/idagger

/datum/npc_loadout/kit/hoblin_knuckles
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin
	gloves = /obj/item/clothing/gloves/roguetown/knuckles/bronze

/datum/npc_loadout/kit/hoblin_greatsword
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin
	head = /obj/item/clothing/head/roguetown/helmet/hobgoblin
	r_hand = /obj/item/rogueweapon/greatsword/iron
