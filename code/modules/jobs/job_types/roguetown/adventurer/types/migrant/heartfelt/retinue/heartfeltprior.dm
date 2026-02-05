
/datum/advclass/heartfelt/retinue/prior
	name = "Heartfeltian Priest"
	tutorial = "The Priest of Heartfelt, you were destined for ascension within the Church. \
	. Still guided by the blessings of Astrata, you journey to the Peak, determined to offer what aid and solace you can."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/heartfelt/prior
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	class_select_category = CLASS_CAT_HFT_COURT

// HIGH COURT - /ONE SLOT/ Roles that were previously in the Court, but moved here.

	traits_applied = list(TRAIT_CHOSEN, TRAIT_RITUALIST, TRAIT_SOUL_EXAMINE, TRAIT_GRAVEROBBER, TRAIT_HOMESTEAD_EXPERT, TRAIT_MEDICINE_EXPERT, TRAIT_HEARTFELT)

	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 1,
		STATKEY_STR = -1,
		STATKEY_CON = -1,
	)

	subclass_skills = list(
	/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
	/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
	/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
	/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
	)



/datum/outfit/job/roguetown/heartfelt/prior/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/psicross/astrata
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/storage/belt/rogue/pouch/coins/veryrich
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/priest
	cloak = /obj/item/clothing/cloak/chasuble
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/needle/pestra = 1,
		/obj/item/ritechalk = 1,
	)

	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.
