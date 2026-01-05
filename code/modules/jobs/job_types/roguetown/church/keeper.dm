/datum/job/roguetown/keeper
	title = "Keeper"
	tutorial = "Disfigured, shunned, or simply filled with purpose and dedication for Pestra. Some of you are horrifically mutated, disfigured, or diseased. No matter, even the pretty ones feel the toll as it leaves their strength atrophied. Someone has to harvest the holy blood required to purify lux and perpetuate Pestra's gift of medicine. Unfortunately, that's you. That's correct, I'm the one tasked with protecting the sacred Heart Beast of Pestra here. To study it and empower it so that Pestra's medicine may blossom even in the furthest reaches of Azure. Keep in mind you are NOT directly affiliated with the church of the see, the local bishop is not your boss. You answer to the sect of Pestra foremost."
	flag = KEEPER
	department_flag = CHURCHMEN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	allowed_races = ACCEPTED_RACES
	allowed_ages = ALL_AGES_LIST
	allowed_patrons = list(/datum/patron/divine/pestra)

	outfit = /datum/outfit/job/roguetown/keeper
	display_order = JDO_KEEPER
	give_bank_account = TRUE
	min_pq = 1
	max_pq = null
	round_contrib_points = 3

	job_traits = list(TRAIT_MEDICINE_EXPERT, TRAIT_HOMESTEAD_EXPERT,
						  TRAIT_ALCHEMY_EXPERT, TRAIT_SEWING_EXPERT,
						  TRAIT_SURVIVAL_EXPERT, TRAIT_NOSTINK,
						  TRAIT_GRABIMMUNE, TRAIT_STEELHEARTED)

	advclass_cat_rolls = list(CTAG_KEEPER = 2)
	job_subclasses = list(
		/datum/advclass/keeper
	)

/datum/advclass/keeper
	name = "Keeper"
	tutorial = "Disfigured, shunned, or simply filled with purpose and dedication for Pestra. Some of you are horrifically mutated, disfigured, or diseased. No matter, even the pretty ones feel the toll as it leaves their strength atrophied. Someone has to harvest the holy blood required to purify lux and perpetuate Pestra's gift of medicine. Unfortunately, that's you. That's correct, I'm the one tasked with protecting the sacred Heart Beast of Pestra here. To study it and empower it so that Pestra's medicine may blossom even in the furthest reaches of Azure. Keep in mind you are NOT directly affiliated with the church of the see, the local bishop is not your boss. You answer to the followers of Pestra foremost."
	outfit = /datum/outfit/job/roguetown/keeper/basic
	category_tags = list(CTAG_KEEPER)
	// No perception as to dissuade picking statpacks to negate the strength penalty.
	// Positive stat delta of 3. It's lower than a towner (5) & Acolyte (7), but you have outlier stats and master skills, so less stats for you.
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 5,
		STATKEY_CON = 3,
		STATKEY_STR = -5,
		STATKEY_PER = 2
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/butchering = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
	)
	adv_stat_ceiling = list(STAT_STRENGTH = 6)

/datum/outfit/job/roguetown/keeper/basic/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/psicross/pestra
	cloak = /obj/item/clothing/cloak/templar/pestran
	gloves = /obj/item/clothing/gloves/roguetown/leather
	head = /obj/item/clothing/head/roguetown/helmet/heavy/pestran
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
							 /obj/item/storage/belt/rogue/pouch/coins/mid = 1,
							 /obj/item/heart_canister = 2,
							 /obj/item/heart_blood_vial/filled = 2,
							 /obj/item/heart_blood_canister/filled = 1,
							 /obj/item/heart_blood_vial = 5,
							 /obj/item/heart_blood_canister = 1,
							 /obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 1,
							 /obj/item/roguekey/keeper = 1,
							 /obj/item/roguekey/keeper_inner = 1,
							 /obj/item/storage/keyring = 1)
	H.put_in_hands(new /obj/item/storage/belt/rogue/surgery_bag/full/physician(H))
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_MIDDLE_CLASS, H, "Church Funding.")
