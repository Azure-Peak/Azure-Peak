/datum/advclass/czwarteki/Servant
	name = "Czwarteki Servant"
	tutorial = "You're one of the Lord's most trusted and loyal servants, taken along with them and their posse in their travels to Azuria. Your only goals are to ensure that the Lord and their Heir are comfortable and taken care of."
	outfit = /datum/outfit/job/roguetown/czwarteki/servant
	traits_applied = list(TRAIT_SLEUTH, TRAIT_KEENEARS, TRAIT_CICERONE, TRAIT_HOMESTEAD_EXPERT)
	category_tags = list(CTAG_CZWAR_SERVANT)

	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/czwarteki/servant/pre_equip(mob/living/carbon/human/H)
	..()
	backl = /obj/item/storage/backpack/rogue/satchel/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/huntingknife
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 2,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 2,
		/obj/item/reagent_containers/food/snacks/rogue/crackerscooked = 2,
		/obj/item/reagent_containers/glass/bottle/waterskin = 1,
		/obj/item/reagent_containers/glass/cup/silver = 2,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/avarrice = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/avarmead = 1,
		/obj/item/flint = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/cooking/pan = 1,
		/obj/item/needle = 1,
	)

