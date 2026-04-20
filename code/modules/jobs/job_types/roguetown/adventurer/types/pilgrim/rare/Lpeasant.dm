/datum/advclass/farmermaster
	name = "Master Farmer"
	tutorial = "A master farmer, a story simlar to the likes of Goliath and David, \
	You, a simple peasent, through sheer determination have conquered nature \
	and made it bow before your green thumb."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/farmermaster
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)

	maximum_possible_slots = 1
	pickprob = 5
	category_tags = list(CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_LCK = 4,
		STATKEY_STR = 2,
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	
/datum/outfit/job/roguetown/adventurer/farmermaster/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/rope
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/trou
	head = /obj/item/clothing/head/roguetown/strawhat
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	mouth = /obj/item/clothing/mask/cigarette/pipe/westman
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		pants = null
	backpack_contents = list(
						/obj/item/seeds/wheat=1,
						/obj/item/seeds/apple=1,
						/obj/item/ash=1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/huntingknife = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1
						)
	beltl = /obj/item/rogueweapon/sickle
	beltr = /obj/item/flint
	backr = /obj/item/rogueweapon/hoe
