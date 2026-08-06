/datum/advclass/arcanist
	name = "Arcanist" // this is basically so you're not called a witch, really. same shit as witch, but one more bonus minor cos you don't become a bird
	tutorial = "You are a towner with a gift for the Arcyne. Perhaps you are a retired Magos, a student still learning its mysteries, or simply someone who has taken to the arcane arts in your own way. Whatever your origins, you possess a talent for magic uncommon among the commonfolk, and enough knowledge to put it to use."
	outfit = /datum/outfit/job/roguetown/adventurer/arcanist
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	traits_applied = list(TRAIT_ARCYNE, TRAIT_HOMESTEAD_EXPERT)
	townie_contract_gate_exempt = TRUE
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 2, "utilities" = 6, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN,
	)
	maximum_possible_slots = 20 // Should not fill, just a hack to make it shows what types of towners are in round

/datum/outfit/job/roguetown/adventurer/arcanist/pre_equip(mob/living/carbon/human/H)
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights/random
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	beltr = /obj/item/storage/keyring/apprentice
	backl = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/gladiator
	backpack_contents = list(
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
		)
	if(H.mind)
		backr = choose_implement(H, "lesser")
		SStreasury.grant_savings(ECONOMIC_LOWER_MIDDLE_CLASS, H)
