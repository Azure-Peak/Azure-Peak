/datum/advclass/trader/maid
	name = "Wandering Maid"
	tutorial = "A surviving servant of a destroyed dynasty, an exile, or a spy, one way or another, your skills will help you serve. The rest is to find your master."
	outfit = /datum/outfit/job/roguetown/adventurer/maid
	allowed_sexes = list(MALE, FEMALE)
	category_tags = list(CTAG_TRADER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	class_select_category = CLASS_CAT_TRADER
	allowed_races = RACES_ALL_KINDS
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_KEENEARS)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_SPD = 2
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE
	)

/datum/outfit/job/roguetown/adventurer/maid/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("A surviving servant of a destroyed dynasty, an exile, or a spy, one way or another, your skills will help you serve. The rest is to find your master."))
	
	head = /obj/item/clothing/head/roguetown/maidhead
	armor = /obj/item/clothing/suit/roguetown/shirt/dress/maid
	cloak = /obj/item/clothing/cloak/apron/waist/maid
	belt = /obj/item/storage/belt/rogue/leather/sash/maid
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/recipe_book/survival = 1)
