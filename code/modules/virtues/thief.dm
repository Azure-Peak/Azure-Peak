/datum/virtue/thief/drug_runner
	name = "Dust Runner"
	desc = "I run dust for the Thieves' Guild, and an associate has left a delivery in my stash nearby for me to pick up; they will also supply me via HERMES daily. I can spot others in the Guild, and Matthiosites and Bathhouse workers recognize me for it."
	added_traits = list(TRAIT_DUSTRUNNER, TRAIT_DRUG_SUPPLY)
	added_languages = list(/datum/language/thievescant)
	added_skills = list(list(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, SKILL_LEVEL_JOURNEYMAN))
	added_stashed_items = list("Satchel #1" = /obj/item/storage/backpack/rogue/satchel/mule,
							"Satchel #2" = /obj/item/storage/backpack/rogue/satchel/mule,
							"Dagger" = /obj/item/rogueweapon/huntingknife/idagger
	)
