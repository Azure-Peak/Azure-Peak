/datum/job/roguetown/churchling
	title = "Churchling"
	flag = CHURCHLING
	department_flag = YOUNGFOLK
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_races = RACES_ALL_KINDS
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)

	tutorial = "Your family were zealots. They scolded you with a studded belt and prayed like sinners every waking hour of the day they weren't toiling in the fields. You escaped them by becoming a churchling--and a guaranteed education isn't so bad."

	outfit = /datum/outfit/job/roguetown/churchling
	display_order = JDO_CHURCHLING
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	advclass_cat_rolls = list(CTAG_CHURCHLING = 2)
	job_subclasses = list(
		/datum/advclass/churchling
	)
	job_traits = list(TRAIT_HOMESTEAD_EXPERT)

/datum/advclass/churchling
	name = "Churchling"
	tutorial = "Your family were zealots. They scolded you with a studded belt and prayed like sinners every waking hour of the day they weren't toiling in the fields. You escaped them by becoming a churchling--and a guaranteed education isn't so bad."
	outfit = /datum/outfit/job/roguetown/churchling/basic
	cmode_music = 'sound/music/combat_holy.ogg'
	category_tags = list(CTAG_CHURCHLING)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/churchling/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	neck = /obj/item/clothing/neck/roguetown/psicross
	if(should_wear_femme_clothes(H))
		head = /obj/item/clothing/head/roguetown/armingcap
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/robe
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights
	belt = /obj/item/storage/belt/rogue/leather/rope
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	beltl = /obj/item/storage/keyring/churchie

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)	//Capped to T1 miracles.
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_CLASS, H, "Church Funding.")
