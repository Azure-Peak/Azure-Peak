/datum/job/roguetown/servant
	title = "Servant"
//	f_title = "Maid"
	flag = SERVANT
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 6
	spawn_positions = 6

	allowed_races = ACCEPTED_RACES
	allowed_ages = ALL_AGES_LIST

	tutorial = "Granted a life of comfortable servitude in the Duke's manor, you follow the Seneschal's commands and spend your day performing necessary but menial tasks. This role offers an aesthetic choice between labor-servant, maid, and butler."

	outfit = /datum/outfit/job/roguetown/servant
	advclass_cat_rolls = list(CTAG_SERVANT = 20)
	job_traits = list(TRAIT_HOMESTEAD_EXPERT)
	display_order = JDO_SERVANT
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	advjob_examine = TRUE
	cmode_music = 'sound/music/cmode/towner/combat_towner.ogg'
	job_subclasses = list(
		/datum/advclass/servant/servant,
		/datum/advclass/servant/maid,
		/datum/advclass/servant/butler
	)

/datum/advclass/servant
	traits_applied = list(TRAIT_CICERONE, TRAIT_ROYALSERVANT)
	age_mod = /datum/class_age_mod/servant

/datum/advclass/servant/servant
	name = "Servant"
	tutorial = "You are a humdrum servant, dressed the part; lowly and best out of sight. It's practical, however."
	outfit = /datum/outfit/job/roguetown/servant/servant
	category_tags = list(CTAG_SERVANT)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/servant/servant/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/under/roguetown/trou
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_WORKING_CLASS, H, "Savings.")

/datum/advclass/servant/maid
	name = "Maid"
	tutorial = "Not one really mentions how hard it is to do yardwork in a dress and stockings, but at least you still look really good."
	outfit = /datum/outfit/job/roguetown/servant/maid
	category_tags = list(CTAG_SERVANT)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/servant/maid/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/maidhead
	armor = /obj/item/clothing/suit/roguetown/shirt/dress/maid
	cloak = /obj/item/clothing/cloak/apron/waist/maid
	belt = /obj/item/storage/belt/rogue/leather/sash/maid
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_WORKING_CLASS, H, "Savings.")

/datum/advclass/servant/butler
	name = "Butler"
	tutorial = "An impeccable appearance is your core being. You still dig through the mud, though, you just do the laundry more."
	outfit = /datum/outfit/job/roguetown/servant/butler
	category_tags = list(CTAG_SERVANT)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/servant/butler/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/black
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_WORKING_CLASS, H, "Savings.")
