/datum/job/roguetown/shophand
	title = "Shophand"
	flag = SHOPHAND
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	is_quest_giver = TRUE

	tutorial = "You work the largest store in the Peaks by grace of the Merchant who has shackled you to this drudgery. The work of stocking shelves and taking inventory for your employer is mind-numbing and repetitive--but at least you have a roof over your head and comfortable surroundings. With time, perhaps you will one day be more than a glorified servant."

	outfit = /datum/outfit/job/roguetown/shophand
	display_order = JDO_SHOPHAND
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/towner/combat_towner.ogg'

	job_traits = list(TRAIT_SEEPRICES)

	advclass_cat_rolls = list(CTAG_SHOPHAND = 2)
	job_subclasses = list(
		/datum/advclass/shophand
	)

/datum/advclass/shophand
	name = "Shophand"
	tutorial = "You work the largest store in the Peaks by grace of the Merchant who has shackled you to this drudgery. \
	The work of stocking shelves and taking inventory for your employer is mind-numbing and repetitive--but at least you have a roof over your head and comfortable surroundings. \
	With time, perhaps you will one day be more than a glorified servant."
	outfit = /datum/outfit/job/roguetown/shophand/basic
	category_tags = list(CTAG_SHOPHAND)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_INT = 1,
		STATKEY_LCK = 1
	)
	subclass_skills = list(
		//worse skills than a normal peasant, generally, with random bad combat skill
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/shophand/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	if(should_wear_femme_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/blue
		shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
		belt = /obj/item/storage/belt/rogue/leather
		beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
		beltl = /obj/item/storage/keyring/merchant
		backr = /obj/item/storage/backpack/rogue/satchel
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
		belt = /obj/item/storage/belt/rogue/leather
		beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
		beltl = /obj/item/storage/keyring/merchant
		backr = /obj/item/storage/backpack/rogue/satchel
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)
	if(prob(33))
		H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
	else if(prob(33))
		H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	else //the legendary shopARM
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
		H.change_stat(STATKEY_STR, 1)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_MIDDLE_CLASS, H, "Savings.")
