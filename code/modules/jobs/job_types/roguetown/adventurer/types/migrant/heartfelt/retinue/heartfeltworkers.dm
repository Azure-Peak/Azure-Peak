/datum/advclass/heartfelt/retinue/servant
	name = "Heartfeltian Servant"		
	tutorial = "You are Servant of Heartfelt, Serant of a once-prosperous barony now in ruin. \
	Guided by the Magos, you journey to the Peak, seeking aid to restore your domain to its former glory, or perhaps claim a new throne."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/servant
	maximum_possible_slots = 4
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	class_select_category = CLASS_CAT_HFT_WORKER
	traits_applied = list(TRAIT_CICERONE, TRAIT_KEENEARS, TRAIT_SLEUTH, TRAIT_HOMESTEAD_EXPERT, TRAIT_SEWING_EXPERT)

	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/ceramics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

// HIGH COURT - /ONE SLOT/ Roles that were previously in the Court, but moved here.

/datum/outfit/job/roguetown/heartfelt/retinue/servant/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/under/roguetown/trou
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/cooking/pan
	beltr = /obj/item/rogueweapon/huntingknife
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
	/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 2,
	/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 2,
	/obj/item/reagent_containers/food/snacks/rogue/crackerscooked = 2,
	/obj/item/reagent_containers/glass/bottle/waterskin = 1,
	/obj/item/reagent_containers/glass/cup/silver = 2,
	/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
	/obj/item/flint = 1,
	/obj/item/rogueweapon/scabbard/sheath = 1,
	)

