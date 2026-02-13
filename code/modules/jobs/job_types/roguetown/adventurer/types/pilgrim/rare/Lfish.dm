//human master fisher

/datum/advclass/fishermaster
	name = "Master Fisher"
	tutorial = "You are a Master Fisher, you cast your rod with might, and are able to pull fish larger than Eoras Bosom."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/fishermaster
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)

	maximum_possible_slots = 1
	pickprob = 5
	
	category_tags = list(CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_PER = 2,
		STATKEY_SPD = 2
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_MASTER,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/fishermaster/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.pronouns == HE_HIM || H.pronouns == THEY_THEM || H.pronouns == IT_ITS_M)
		pants = /obj/item/clothing/under/roguetown/trou
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		neck = /obj/item/storage/belt/rogue/pouch/coins/mid
		head = /obj/item/clothing/head/roguetown/fisherhat
		backr = /obj/item/storage/backpack/rogue/satchel
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
		belt = /obj/item/storage/belt/rogue/leather
		backl = /obj/item/fishingrod
		beltr = /obj/item/cooking/pan
		mouth = /obj/item/rogueweapon/huntingknife
		beltl = /obj/item/flint
		backpack_contents = list(
							/obj/item/natural/worms = 2,
							/obj/item/rogueweapon/shovel/small=1,
							/obj/item/flashlight/flare/torch = 1,
							)
	else
		pants = /obj/item/clothing/under/roguetown/trou
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
		neck = /obj/item/storage/belt/rogue/pouch/coins/mid
		head = /obj/item/clothing/head/roguetown/fisherhat
		backr = /obj/item/storage/backpack/rogue/satchel
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
		belt = /obj/item/storage/belt/rogue/leather/rope
		beltr = /obj/item/fishingrod
		beltl = /obj/item/rogueweapon/huntingknife
		backpack_contents = list(
			/obj/item/natural/worms = 2,
			/obj/item/rogueweapon/shovel/small=1,
			/obj/item/rogueweapon/scabbard/sheath = 1
			)
