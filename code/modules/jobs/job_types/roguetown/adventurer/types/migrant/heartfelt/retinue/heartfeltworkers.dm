/datum/advclass/heartfelt/retinue/servant
	name = "Heartfelt Servant"		
	tutorial = "You are Servant of Heartfelt, a Servant of the prosperous borderlands. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be. \
	Travellers often warn of Heartfelt having fallen already, and words of secretive cultists isn't unheard of."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/servant
	maximum_possible_slots = 4
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	class_select_category = CLASS_CAT_HFT_WORKER
	traits_applied = list(TRAIT_CICERONE, TRAIT_KEENEARS, TRAIT_SLEUTH, TRAIT_HOMESTEAD_EXPERT, TRAIT_SEWING_EXPERT, TRAIT_HEARTFELT)

	subclass_stats = list(
		STATKEY_INT = 2,
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

