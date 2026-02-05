
/datum/advclass/heartfelt/retinue/physician
	name = "Heartfeltian Physician"
	tutorial = "You are the Physician of Heartfelt, celebrated for your steady hands and healing wisdom. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/physician
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	class_select_category = CLASS_CAT_HFT_COURT

	traits_applied = list(TRAIT_HEARTFELT, TRAIT_NOSTINK, TRAIT_EMPATH)

	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_WIL = 1,
		STATKEY_LCK = 1,
		STATKEY_SPD = 2,
	)

	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_LEGENDARY,
	)
// HIGH COURT - /ONE SLOT/ Roles that were previously in the Court, but moved here.

/datum/outfit/job/roguetown/heartfelt/retinue/physician/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	neck = /obj/item/clothing/neck/roguetown/psicross/pestra
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/surgery_bag/full/physician
	beltr = /obj/item/rogueweapon/huntingknife
	id = /obj/item/scomstone/bad
	r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/steel
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew = 2,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		/obj/item/natural/worms/leech/cheele = 1, //little buddy
		/obj/item/reagent_containers/glass/bottle/waterskin = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/bedroll = 1,
	)
	if(H.pronouns == SHE_HER)
		head = /obj/item/clothing/head/roguetown/courtphysician/female
		armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/courtphysician/female
		shirt = /obj/item/clothing/suit/roguetown/shirt/courtphysician/female
		gloves = /obj/item/clothing/gloves/roguetown/courtphysician/female
		pants = /obj/item/clothing/under/roguetown/skirt/courtphysician
		shoes = /obj/item/clothing/shoes/courtphysician/female/
	else
		head = /obj/item/clothing/head/roguetown/courtphysician
		armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/courtphysician
		shirt = /obj/item/clothing/suit/roguetown/shirt/courtphysician
		gloves = /obj/item/clothing/gloves/roguetown/courtphysician
		pants = /obj/item/clothing/under/roguetown/trou/leather/courtphysician
		shoes = /obj/item/clothing/shoes/courtphysician

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		backpack_contents += /obj/item/clothing/mask/rogue/physician
	if(H.age == AGE_OLD)
		H.change_stat("speed", -1)
		H.change_stat("intelligence", 2)
		H.change_stat("perception", 1)
