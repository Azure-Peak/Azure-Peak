/datum/job/roguetown/farmer
	title = "Soilson"
	flag = SOILSON
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 3
	spawn_positions = 5
	display_order = JDO_SOILSON
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'

	tutorial = "It is a simple life you live, your basic understanding of life is something many would be envious of if they knew just how perfect it was. You know a good day's work, the sweat on your brow is yours: Famines and plague may take their toll, but you know how to celebrate life well. Till the soil and produce fresh food for those around you, and maybe you'll be more than an unsung hero someday."


	f_title = "Soilbride"
	outfit = /datum/outfit/job/roguetown/farmer
	display_order = 24
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 3

	job_traits = list(TRAIT_SEEDKNOW, TRAIT_NOSTINK, TRAIT_LONGSTRIDER, TRAIT_HOMESTEAD_EXPERT)

	advclass_cat_rolls = list(CTAG_SOILBRIDE = 2)
	job_subclasses = list(
		/datum/advclass/soilson
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/soilson
	name = "Soilson"
	tutorial = "It is a simple life you live, your basic understanding of life is something many would be envious of if they knew just how perfect it was. You know a good day's work, the sweat on your brow is yours: Famines and plague may take their toll, but you know how to celebrate life well. Till the soil and produce fresh food for those around you, and maybe you'll be more than an unsung hero someday."
	outfit = /datum/outfit/job/roguetown/farmer/basic
	category_tags = list(CTAG_SOILBRIDE)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = 1
	)
	age_mod = /datum/class_age_mod/soilson
	subclass_skills = list(
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_MASTER,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE, //So they can actually even craft their makeshift weapons
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/farmer/basic/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/cap
	mask = /obj/item/clothing/head/roguetown/roguehood
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/storage/keyring/soilson
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/recipe_book/survival = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/flint = 1,
		)
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
		cloak = /obj/item/clothing/cloak/apron/brown
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/random
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
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

/obj/item/storage/roguebag/farmer_berries
	populate_contents = list(
		/obj/item/seeds/raspberry,
		/obj/item/seeds/raspberry,
		/obj/item/seeds/blackberry,
		/obj/item/seeds/blackberry,
		/obj/item/seeds/strawberry,
		/obj/item/seeds/strawberry,
	)

/obj/item/storage/roguebag/farmer_rocknut
	populate_contents = list(
		/obj/item/seeds/nut,
		/obj/item/seeds/nut,
		/obj/item/seeds/nut,
	)

/obj/item/storage/roguebag/farmer_fruits
	populate_contents = list(
		/obj/item/seeds/lemon,
		/obj/item/seeds/lemon,
		/obj/item/seeds/lime,
		/obj/item/seeds/lime,
		/obj/item/seeds/tangerine,
		/obj/item/seeds/tangerine,
		/obj/item/seeds/plum,
		/obj/item/seeds/plum,
	)

/obj/item/storage/roguebag/farmer_smokes
	populate_contents = list(
		/obj/item/seeds/swampweed,
		/obj/item/seeds/swampweed,
		/obj/item/seeds/pipeweed,
		/obj/item/seeds/pipeweed,
	)
