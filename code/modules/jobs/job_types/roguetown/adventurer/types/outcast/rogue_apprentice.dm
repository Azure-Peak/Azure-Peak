// an exiled mage, towner-witch with no zadform, aka worse than even apprenticemage; if this becomes a problem... sigh
/datum/advclass/outcast/rogue_apprentice
	name = "Rogue Apprentice"
	tutorial = "The commonfolk feared your magic; the cowards at the Academy were unwilling to sanction your arts. Without their support, there was naught to stop the Crown treating you as a petty criminal and exiling you. Once your studies bear fruit, however, you'll show them all... you can bide your time until then." // wretch!roguemage was edgy as fuck n it's important to preserve that
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/outcast/rogue_apprentice
	category_tags = list(CTAG_OUTCAST)
	traits_applied = list(TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list( // towner witch but 2 less statweight
		STATKEY_INT = 3,
		STATKEY_SPD = 1,
		STATKEY_LCK = 1
	)
	age_mod = /datum/class_age_mod/witch

	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN, // identical to old magick witch
		/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)
	maximum_possible_slots = 1 // Didn't want to add mages to this at all. Outcast is supposed to be grounded n mundane.

/datum/outfit/job/roguetown/outcast/rogue_apprentice/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/witchhat
	mask = /obj/item/clothing/head/roguetown/roguehood/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/phys
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/storage/magebag/starter
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
	if(H.mind)
		H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 1, "minor" = 1, "utilities" = 5, "ward" = TRUE))
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = choose_implement(H, "lesser")
	backpack_contents = list(
						/obj/item/rogueweapon/spellbook = 1,
						/obj/item/reagent_containers/glass/mortar = 1,
						/obj/item/pestle = 1,
						/obj/item/candle/yellow = 2,
						/obj/item/chalk = 1,
						/obj/item/folding_alchcauldron_stored = 1, // mobile workstation since they don't get a home
						/obj/item/folding_alchstation_stored = 1,
						)

	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/armor/corset
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		pants = /obj/item/clothing/under/roguetown/skirt/red
	outcast_select_bounty(H)

