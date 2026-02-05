/datum/job/roguetown/apothecary
	title = "Apothecary"
	flag = APOTHECARY
	department_flag = BURGHERS
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_races = ACCEPTED_RACES

	tutorial = "You are an accomplished physician, trained and practiced in the art of medicine. You answer to the Head Physician, who enables your practice. Woe betide the one who suffers your scalpel."

	outfit = /datum/outfit/job/roguetown/apothecary

	cmode_music = 'sound/music/combat_physician.ogg'

	display_order = JDO_APOTHECARY
	give_bank_account = TRUE

	min_pq = 0
	max_pq = null
	round_contrib_points = 5

	advclass_cat_rolls = list(CTAG_APOTH = 2)
	job_traits = list(TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT, TRAIT_NOSTINK, TRAIT_EMPATH)
	job_subclasses = list(
		/datum/advclass/apothecary
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/apothecary
	name = "Apothecary"
	tutorial = "You are an accomplished physician, trained and practiced in the art of medicine. You answer to the Head Physician, who enables your practice. Woe betide the one who suffers your scalpel."
	outfit = /datum/outfit/job/roguetown/apothecary/basic
	category_tags = list(CTAG_APOTH)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE, //enhances survival chances.
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_MASTER,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/apothecary/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/roguehood/black
	pants = /obj/item/clothing/under/roguetown/trou/apothecary
	shirt = /obj/item/clothing/suit/roguetown/shirt/apothshirt
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/black
	belt = /obj/item/storage/belt/rogue/leather/rope
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/storage/belt/rogue/surgery_bag/full/physician
	beltr = /obj/item/roguekey/physician
	id = /obj/item/scomstone/bad
	r_hand = /obj/item/rogueweapon/woodstaff/
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/natural/worms/leech/cheele = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/clothing/mask/rogue/physician = 1,
		/obj/item/storage/keyring = 1,
		/obj/item/roguekey/keeper = 1
	)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_MIDDLE_CLASS, H, "Savings.")
