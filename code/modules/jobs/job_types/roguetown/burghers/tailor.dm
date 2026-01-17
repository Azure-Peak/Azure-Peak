/datum/job/roguetown/tailor
	title = "Tailor"
	flag = TAILOR
	department_flag = BURGHERS
	faction = "Station"
	tutorial = "You have worked sleepless nights on honing your craft. From sacks, to tapestry and luxurious clothing, there is little you cannot sew into existence. Use your storefront to turn even the ugliest peasant into a proper gentleman; who knows, even the nobility may pay you a visit."
	total_positions = 1
	spawn_positions = 1
	display_order = 6
	min_pq = 0
	selection_color = JCOLOR_BURGHER
	allowed_races = ACCEPTED_RACES
	display_order = JDO_TAILOR
	job_traits = list(TRAIT_SEWING_EXPERT)
	outfit = /datum/outfit/job/roguetown/tailor
	give_bank_account = TRUE
	min_pq = 0
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/cmode/towner/combat_towner3.ogg'
	advclass_cat_rolls = list(CTAG_TAILOR = 2)
	job_subclasses = list(
		/datum/advclass/tailor
	)

/datum/advclass/tailor
	name = "Tailor"
	tutorial = "You have worked sleepless nights on honing your craft. From sacks, to tapestry and luxurious clothing, there is little you cannot sew into existence. Use your storefront to turn even the ugliest peasant into a proper gentleman; who knows, even the nobility may pay you a visit."
	outfit = /datum/outfit/job/roguetown/tailor/basic
	category_tags = list(CTAG_TAILOR)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = 1,
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/tailor/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights
	belt = /obj/item/storage/belt/rogue/leather/cloth
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/rogueweapon/huntingknife/scissors/steel
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/needle,
		/obj/item/storage/keyring/tailor,
		/obj/item/dye_brush,
		/obj/item/recipe_book/sewing,
		/obj/item/recipe_book/leatherworking
		)
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fittedclothing)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/takeapprentice)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_MIDDLE_CLASS, H, "Savings.")
