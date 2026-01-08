/datum/job/roguetown/clerk
	title = "Clerk"
	flag = CLERK
	department_flag = BURGHERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	is_quest_giver = TRUE

	tutorial = "Clerk, tax-collector, blessed fool. You help the Steward with anything they need and perform their tasks when they are unavailable. Although you aren't a noble, it's not the worst position. The caveat? If money is misplaced or goes missing, a noble could probably weasel out of the stockades as punishment. You? Eh...well, Etrusca is lovely this time of year."

	outfit = /datum/outfit/job/roguetown/clerk
	display_order = JDO_CLERK
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	advclass_cat_rolls = list(CTAG_CLERK = 2)

	job_traits = list(TRAIT_SEEPRICES)
	job_subclasses = list(
		/datum/advclass/clerk
	)


/datum/advclass/clerk
	name = "Clerk"
	tutorial = "Clerk, tax-collector, blessed fool. You help the Steward with anything they need and perform their tasks when they are unavailable. Although you aren't a noble, it's not the worst position. The caveat? If money is misplaced or goes missing, a noble could probably weasel out of the stockades as punishment. You? Eh...well, Etrusca is lovely this time of year."
	subclass_stats = list(
		STATKEY_LCK = 2,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
	)
	category_tags = list(CTAG_CLERK)
	outfit = /datum/outfit/job/roguetown/clerk/basic

/datum/outfit/job/roguetown/clerk/basic/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)

	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/green
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/cloak/tabard/knight
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt

	pants = /obj/item/clothing/under/roguetown/tights
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/storage/keyring/steward //serously doubt this is gonna be an issue, but if it is, i'll change it
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_MIDDLE_CLASS, H, "Savings.")
