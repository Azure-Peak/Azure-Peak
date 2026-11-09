/datum/npc_loadout/kit/caster
	clear_slots = list("head", "armor", "cloak", "l_hand", "r_hand")
	skills = list(/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN)
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	cloak = list(
		/obj/item/clothing/suit/roguetown/shirt/robe/black = 60,
		/obj/item/clothing/suit/roguetown/shirt/robe/white = 40,
	)
	head = list(
		/obj/item/clothing/head/roguetown/roguehood/black = 70,
		NPC_NOTHING = 30,
	)
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	r_hand = /obj/item/rogueweapon/woodstaff/implement

/datum/npc_loadout/kit/caster/fulgurmancer
	magic_aspects = list(
		/datum/magic_aspect/fulgurmancy,
		/datum/magic_aspect/autowardry = /datum/action/cooldown/spell/conjure_arcyne_ward/dragonhide,
	)
	cloak = list(
		/obj/item/clothing/suit/roguetown/shirt/robe/mageblue = 50,
		/obj/item/clothing/suit/roguetown/shirt/robe/mageyellow = 50,
	)
	head = list(
		/obj/item/clothing/head/roguetown/roguehood/mageblue = 50,
		/obj/item/clothing/head/roguetown/roguehood/black = 30,
		NPC_NOTHING = 20,
	)

/datum/npc_loadout/kit/caster/geomancer
	magic_aspects = list(
		/datum/magic_aspect/geomancy,
		/datum/magic_aspect/autowardry = /datum/action/cooldown/spell/conjure_arcyne_ward/crystalhide,
	)
	cloak = list(
		/obj/item/clothing/suit/roguetown/shirt/robe/magegreen = 60,
		/obj/item/clothing/suit/roguetown/shirt/robe/black = 40,
	)
	head = list(
		/obj/item/clothing/head/roguetown/roguehood/darkgreen = 50,
		/obj/item/clothing/head/roguetown/roguehood/black = 30,
		NPC_NOTHING = 20,
	)

/datum/npc_loadout/kit/caster/telomancer
	magic_aspects = list(
		/datum/magic_aspect/telomancy,
		/datum/magic_aspect/autowardry = /datum/action/cooldown/spell/conjure_arcyne_ward/crystalhide,
	)
	cloak = list(
		/obj/item/clothing/suit/roguetown/shirt/robe/courtmage = 50,
		/obj/item/clothing/suit/roguetown/shirt/robe/white = 50,
	)
	head = list(
		/obj/item/clothing/head/roguetown/roguehood/white = 40,
		/obj/item/clothing/head/roguetown/roguehood/black = 40,
		NPC_NOTHING = 20,
	)

/datum/npc_loadout/kit/caster/ferramancer
	magic_aspects = list(
		/datum/magic_aspect/ferramancy,
		/datum/magic_aspect/aegiscraft,
	)
	r_hand = null
	armor = list(
		/obj/item/clothing/suit/roguetown/armor/leather/studded = 60,
		/obj/item/clothing/suit/roguetown/armor/leather = 40,
	)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	cloak = list(
		/obj/item/clothing/suit/roguetown/shirt/robe/black = 60,
		/obj/item/clothing/suit/roguetown/shirt/robe/courtmage = 40,
	)
	head = list(
		/obj/item/clothing/head/roguetown/roguehood/black = 60,
		NPC_NOTHING = 40,
	)

/datum/npc_loadout/kit/caster/cryomancer
	magic_aspects = list(
		/datum/magic_aspect/cryomancy,
		/datum/magic_aspect/autowardry = /datum/action/cooldown/spell/conjure_arcyne_ward/crystalhide,
	)
	cloak = list(
		/obj/item/clothing/suit/roguetown/shirt/robe/white = 50,
		/obj/item/clothing/suit/roguetown/shirt/robe/mageblue = 50,
	)
	head = list(
		/obj/item/clothing/head/roguetown/roguehood/white = 40,
		/obj/item/clothing/head/roguetown/roguehood/mageblue = 40,
		NPC_NOTHING = 20,
	)

/datum/npc_loadout/kit/caster/pyromancer
	magic_aspects = list(
		/datum/magic_aspect/pyromancy,
		/datum/magic_aspect/autowardry = /datum/action/cooldown/spell/conjure_arcyne_ward/dragonhide,
	)
	cloak = list(
		/obj/item/clothing/suit/roguetown/shirt/robe/mageorange = 60,
		/obj/item/clothing/suit/roguetown/shirt/robe/black = 40,
	)
	head = list(
		/obj/item/clothing/head/roguetown/roguehood/red = 50,
		/obj/item/clothing/head/roguetown/roguehood/black = 35,
		NPC_NOTHING = 15,
	)

/datum/npc_loadout/kit/caster_magister
	skills = list(
		/datum/skill/combat/arcyne = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
	)
	r_hand = /obj/item/rogueweapon/woodstaff/implement/greater
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	neck = /obj/item/clothing/neck/roguetown/coif
