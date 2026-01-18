/datum/job/roguetown/tapster
	title = "Tapster"
	f_title = "Tapster"
	flag = TAPSTER
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 4
	spawn_positions = 4

	allowed_races = ACCEPTED_RACES
	tutorial = "You have a simple role at the Azurian Pint; please. You wait tables and help guests, clean the rooms, grow and brew more drink, and assist in the kitchens as need be. Bring a smile to the masses--and those cheapsake townsfolk and adventures might just give you an extra coin...assuming you've not already pilfered their pouch while they're in a drunken stupor off your latest brew."

	outfit = /datum/outfit/job/roguetown/tapster
	display_order = JDO_TAPSTER
	give_bank_account = 10
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/towner/combat_towner.ogg'

	job_traits = list(TRAIT_CICERONE, TRAIT_HOMESTEAD_EXPERT)

	advclass_cat_rolls = list(CTAG_TAPSTER = 2)
	job_subclasses = list(
		/datum/advclass/tapster
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/tapster
	name = "Tapster"
	tutorial = "You have a simple role at the Azurian Pint; please. You wait tables and help guests, clean the rooms, grow and brew more drink, and assist in the kitchens as need be. Bring a smile to the masses--and those cheapsake townsfolk and adventures might just give you an extra coin...assuming you've not already pilfered their pouch while they're in a drunken stupor off your latest brew."
	outfit = /datum/outfit/job/roguetown/tapster/basic
	category_tags = list(CTAG_TAPSTER)
	// 5 points weighted
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)
	age_mod = /datum/class_age_mod/tapster
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/tapster
	has_loadout = TRUE

/datum/outfit/job/roguetown/tapster/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/roguekey/tavern
	backr = /obj/item/storage/backpack/rogue/satchel
	cloak = /obj/item/clothing/cloak/apron/waist
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
		pants = /obj/item/clothing/under/roguetown/tights/black
	else if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	backpack_contents = list(
		/obj/item/bottle_kit
	)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")
