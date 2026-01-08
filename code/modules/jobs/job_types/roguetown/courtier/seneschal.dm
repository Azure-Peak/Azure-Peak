/datum/job/roguetown/seneschal // really need to re-name all these when the codebase isn't a fork and search will update for the peasants...
	title = "Seneschal"
	flag = SENESCHAL
	department_flag = COURTIERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES

	tutorial = "Servitude unto death; that is your motto. You are the manor's major-domo, commanding over the house servants and seeing to the administrative affairs, day to day of the estate. This role has style options for chief butlers and head maids."
	outfit = /datum/outfit/job/roguetown/seneschal
	advclass_cat_rolls = list(CTAG_SENESCHAL = 20)
	display_order = JDO_SENESCHAL
	give_bank_account = TRUE
	min_pq = 3
	max_pq = null
	round_contrib_points = 3
	job_subclasses = list(
		/datum/advclass/seneschal/seneschal,
		/datum/advclass/seneschal/headmaid,
		/datum/advclass/seneschal/chiefbutler
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/seneschal
	traits_applied = list(TRAIT_CICERONE, TRAIT_HOMESTEAD_EXPERT, TRAIT_SEWING_EXPERT, TRAIT_ROYALSERVANT) // They have Expert Sewing
	category_tags = list(CTAG_SENESCHAL)

/datum/advclass/seneschal/seneschal
	name = "Seneschal"
	tutorial = "While still expected to fill in for the duties of the household servantry as needed, you have styled yourself as a figure beyond them."
	outfit = /datum/outfit/job/roguetown/seneschal/seneschal
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 1, // Usual leadership carrot.
		STATKEY_SPD = 1
	)
	age_mod = /datum/class_age_mod/seneschal
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/seneschal
	has_loadout = TRUE

/datum/outfit/job/roguetown/seneschal/seneschal/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/under/roguetown/tights
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/scomstone/bad
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/silkcoat
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_MIDDLE_CLASS, H, "Savings.")

/datum/advclass/seneschal/headmaid
	name = "Head Maid"
	tutorial = "Whether you were promoted from one or just like the frills, you stylize yourself as a head maid. Your duties and talents remain the same, though."
	outfit = /datum/outfit/job/roguetown/seneschal/headmaid
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 1, // Usual leadership carrot.
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/seneschal/headmaid/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/maidhead
	armor = /obj/item/clothing/suit/roguetown/shirt/dress/maid
	cloak = /obj/item/clothing/cloak/apron/waist/maid
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/sash/maid
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/scomstone/bad
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_MIDDLE_CLASS, H, "Savings.")

/datum/advclass/seneschal/chiefbutler
	name = "Chief Butler"
	tutorial = "You are the ruling class of butler and your ability to clear your throat and murmur 'I say' is without peer. Your duties and talents as seneschal remain the same, though."
	outfit = /datum/outfit/job/roguetown/seneschal/chiefbutler
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 1, // Usual leadership carrot.
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/seneschal/chiefbutler/pre_equip(mob/living/carbon/human/H)
	..() // They need a monocle.
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/black
	id = /obj/item/scomstone/bad
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_MIDDLE_CLASS, H, "Savings.")
