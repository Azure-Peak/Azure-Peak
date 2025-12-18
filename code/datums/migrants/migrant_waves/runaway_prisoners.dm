#define CTAG_RUNAWAY_PRISONER "runaway_prisoner"

/datum/migrant_wave/runaway_prisoners
	name = "Runaway Prisoners"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/runaway_prisoners
	downgrade_wave = /datum/migrant_wave/runaway_prisoners_down_one
	weight = 50
	roles = list(
		/datum/migrant_role/runaway_prisoner = 4
	)
	greet_text = "You've been rotting for years in a cell. Though you escaped, you have nothing - your body atrophied, your mind dulled. But one thing you kknow clearlyu - you are not going back." 

/datum/migrant_wave/runaway_prisoners_down_one
	name = "Runaway Prisoners"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/runaway_prisoners
	downgrade_wave = /datum/migrant_wave/runaway_prisoners_down_two
	roles = list(
		/datum/migrant_role/runaway_prisoner = 3
	)

/datum/migrant_wave/runaway_prisoners_down_two
	name = "Runaway Prisoners"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/runaway_prisoners
	downgrade_wave = /datum/migrant_wave/runaway_prisoners_down_three
	roles = list(
		/datum/migrant_role/runaway_prisoner = 3
	)

/datum/migrant_wave/runaway_prisoners_down_three
	name = "Runaway Prisoners"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/runaway_prisoners
	roles = list(
		/datum/migrant_role/runaway_prisoner = 2
	)

/datum/migrant_role/runaway_prisoner
	name = "Escaped Prisoner"
	grant_lit_torch = TRUE
	advclass_cat_rolls = list(CTAG_RUNAWAY_PRISONER = 20)

/datum/advclass/runaway_prisoner_commoner
	name = "Runaway Prisoner (commoner)"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/runaway_prisoner
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE)
	category_tags = list(CTAG_RUNAWAY_PRISONER)
	subclass_stats = list(
		STATKEY_LCK = 3,
		STATKEY_CON = -1,
		STATKEY_STR = -1,
		STATKEY_WIL = 2,
		STATKEY_PER = 3,
		STATKEY_INT = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_MASTER,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/advclass/runaway_prisoner_noble
	name = "Runaway Prisoner (Noble)"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/runaway_prisoner
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_NOBLE, TRAIT_SEEPRICES)
	category_tags = list(CTAG_RUNAWAY_PRISONER)
	subclass_stats = list(
		STATKEY_LCK = 3,
		STATKEY_CON = -1,
		STATKEY_STR = -1,
		STATKEY_WIL = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/advclass/runaway_prisoner_mage
	name = "Runaway Prisoner (Mage)"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/runaway_prisoner
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_ARCYNE_T3, TRAIT_ALCHEMY_EXPERT)
	category_tags = list(CTAG_RUNAWAY_PRISONER)
	subclass_spellpoints = 18
	subclass_stats = list(
		STATKEY_LCK = 3,
		STATKEY_CON = -1,
		STATKEY_STR = -1,
		STATKEY_WIL = 2,
		STATKEY_PER = 3,
		STATKEY_INT = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/runaway_prisoner/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/my_crime = input(H, "What is your crime?", "Crime") as text|null
	if (!my_crime)
		my_crime = "crimes against the Crown"
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, rand(100, 200), FALSE, my_crime, "The Justiciary of Azuria")
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/random

	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)

#undef CTAG_RUNAWAY_PRISONER
