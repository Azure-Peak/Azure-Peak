/datum/job/roguetown/physician
	title = "Head Physician"
	flag = PHYSICIAN
	department_flag = BURGHERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_PHYSICIAN
	tutorial = "You are a master physician and the current head of the clinic. \
		Oversee your clinic and the apothecaries under you. \
		As a member of the upper class, expect to treat nobility. You have access to accommodate this."
	outfit = /datum/outfit/job/roguetown/physician
	whitelist_req = TRUE
	advclass_cat_rolls = list(CTAG_COURTPHYS = 2)

	give_bank_account = TRUE
	min_pq = 3 //Please don't kill the duke by operating on strong intent. Play apothecary until you're deserving of the great white beak of doom
	max_pq = null
	round_contrib_points = 5

	cmode_music = 'sound/music/combat_physician.ogg'

	job_traits = list(TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT, TRAIT_NOSTINK, TRAIT_EMPATH)
	job_subclasses = list(
		/datum/advclass/physician
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/physician
	name = "Head Physician"
	tutorial = "You are a master physician and the current head of the clinic. \
		Oversee your clinic and the apothecaries under you. \
		As a member of the upper class, expect to treat nobility. You have access to accommodate this."
	outfit = /datum/outfit/job/roguetown/physician/basic
	category_tags = list(CTAG_COURTPHYS)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_WIL = 1,
		STATKEY_LCK = 1,
		STATKEY_SPD = 1,
		STATKEY_STR = -1,
		STATKEY_CON = -1,
	)
	age_mod = /datum/class_age_mod/court_physician
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN, //to properly wield a caneblade
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_LEGENDARY,
	)

/datum/outfit/job/roguetown/physician
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/physician
	name = "Physician"
	jobtype = /datum/job/roguetown/physician

/datum/outfit/job/roguetown/physician/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	mask = /obj/item/clothing/mask/rogue/courtphysician
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid //coin to hire mercenaries or adventurers with
	wrists = /obj/item/storage/keyring/physician
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/surgery_bag/full/physician
	beltr = /obj/item/rogueweapon/scabbard/sheath/courtphysician
	id = /obj/item/scomstone/bad
	r_hand = /obj/item/rogueweapon/sword/rapier/courtphysician
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 2,
		/obj/item/natural/worms/leech/cheele = 1, //little buddy
		/obj/item/reagent_containers/glass/bottle/waterskin = 1,
		/obj/item/recipe_book/alchemy = 1,)
	if(H.pronouns == SHE_HER)
		head = /obj/item/clothing/head/roguetown/courtphysician/female
		armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/courtphysician/female
		shirt = /obj/item/clothing/suit/roguetown/shirt/courtphysician/female
		gloves = /obj/item/clothing/gloves/roguetown/courtphysician/female
		pants = /obj/item/clothing/under/roguetown/skirt/courtphysician
		shoes = /obj/item/clothing/shoes/courtphysician/female
	else
		head = /obj/item/clothing/head/roguetown/courtphysician
		armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/courtphysician
		shirt = /obj/item/clothing/suit/roguetown/shirt/courtphysician
		gloves = /obj/item/clothing/gloves/roguetown/courtphysician
		pants = /obj/item/clothing/under/roguetown/trou/leather/courtphysician
		shoes = /obj/item/clothing/shoes/courtphysician
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Savings.")
