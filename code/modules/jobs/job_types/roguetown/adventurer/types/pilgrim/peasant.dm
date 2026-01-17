/datum/advclass/peasant
	name = "Farmer"
	tutorial = "As a Peasant, you are a skilled farmer, able to grow a variety of crops \
	Join the local Soilsmen at their farm, or make your own little orchard."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/peasant
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = -1
	)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/peasant/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/rope
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/trou
	head = /obj/item/clothing/head/roguetown/cap
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	mouth = /obj/item/rogueweapon/huntingknife
	beltr = /obj/item/flint
	if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		pants = null
	backpack_contents = list(
						/obj/item/seeds/wheat=1,
						/obj/item/seeds/apple=1,
						/obj/item/ash=1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/recipe_book/survival = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1
						)
	beltl = /obj/item/rogueweapon/sickle
	backr = /obj/item/rogueweapon/hoe
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_WORKING_CLASS, H, "Savings.")
	if(H.mind)
		var/seeds = list(
			"Berry seeds" = /obj/item/storage/roguebag/farmer_berries,
			"Rocknut seeds" = /obj/item/storage/roguebag/farmer_rocknut,
			"Exotic fruit seeds" = /obj/item/storage/roguebag/farmer_fruits,
			"Some extra smokes" = /obj/item/storage/roguebag/farmer_smokes,
		)
		var/seedbag_names = list()
		for (var/name in seeds)
			seedbag_names += name
		for (var/i = 1 to 2)
			var/seed_choice = input(H, "Choose your starting seed packs", "Select") as anything in seedbag_names
			if (i == 1)
				l_hand = seeds[seed_choice]
			else
				r_hand = seeds[seed_choice]
		H.set_blindness(0)
