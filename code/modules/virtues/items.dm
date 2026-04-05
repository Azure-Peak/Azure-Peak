/datum/virtue/items/arsonist
	name = "Arsonist"
	desc = "I like to watch the world burn, and I've stowed away two powerful firebombs to help me achieve that fact. Every day I can take one bomb from any HERMES."
	custom_text = "Guaranteed Journeyman for Trapmaking."
	added_skills = list(list(/datum/skill/craft/alchemy, 1, 6), list(/datum/skill/craft/traps, 3, 3))
	added_traits = list(TRAIT_ALCHEMY_EXPERT, TRAIT_EXPLOSIVE_SUPPLY) // Kaboom
	added_stashed_items = list("Firebomb #1" = /obj/item/bomb,
								"Firebomb #2" = /obj/item/bomb,
								"Flint" = /obj/item/flint
	)
