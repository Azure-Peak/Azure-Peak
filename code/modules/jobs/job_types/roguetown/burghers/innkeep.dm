/datum/job/roguetown/innkeeper
	title = "Innkeeper"
	flag = INNKEEPER
	department_flag = BURGHERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES

	tutorial = "Adventurers and warriors alike have two exit plans; the early grave or even earlier retirement. As the proud owner of this fine establishment, you took the latter: The Azurian Pint, tavern, inn, and bathhouse! You even have an assortment of staff to help you, and plenty of business from the famished townsfolk looking to eat, weary travelers looking to rest, and characters of dubious repute seeking their own sort of success. Your bladework has gotten a little rusty, and the church across the street gives you the odd evil eye for the extra 'delights' of the bathhouse--but, well...you can't win 'em all!"

	outfit = /datum/outfit/job/roguetown/innkeeper
	display_order = JDO_INNKEEPER
	give_bank_account = TRUE
	min_pq = -4
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/cmode/towner/combat_retired.ogg'

	job_traits = list(TRAIT_MEDIUMARMOR, TRAIT_TAVERN_FIGHTER, TRAIT_EMPATH, TRAIT_DODGEEXPERT, TRAIT_CICERONE, TRAIT_HOMESTEAD_EXPERT)

	advclass_cat_rolls = list(CTAG_INNKEEPER = 2)
	job_subclasses = list(
		/datum/advclass/innkeeper
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/innkeeper
	name = "Innkeeper"
	tutorial = "Adventurers and warriors alike have two exit plans; the early grave or even earlier retirement. As the proud owner of this fine establishment, you took the latter: The Azurian Pint, tavern, inn, and bathhouse! You even have an assortment of staff to help you, and plenty of business from the famished townsfolk looking to eat, weary travelers looking to rest, and characters of dubious repute seeking their own sort of success. Your bladework has gotten a little rusty, and the church across the street gives you the odd evil eye for the extra 'delights' of the bathhouse--but, well...you can't win 'em all!"
	outfit = /datum/outfit/job/roguetown/innkeeper/basic
	category_tags = list(CTAG_INNKEEPER)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)
	age_mod = /datum/class_age_mod/innkeeper
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE, //apprentice to do some basic repairs around the inn if need be
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/innkeeper/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltr = /obj/item/storage/keyring/innkeep
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress
		cloak = /obj/item/clothing/cloak/apron/waist
	else if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	backpack_contents = list(
		/obj/item/recipe_book/survival,
		/obj/item/bottle_kit
	)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_CLASS, H, "Savings.")
