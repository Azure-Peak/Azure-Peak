/datum/advclass/potter
	name = "Potter"
	tutorial = "You are a skilled artisan in the manipulation of ceramics, \
	and their fashioning into a multitude of different objects and valuables, including glass."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/potter
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)

	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN, // Potters are fairly active, having to source their own clay.
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN, // They mostly work with their bare hands...?
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, // Something about wrestling clay into shape?
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE, // They probably have some insight in carpentry and masonry.
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE, // They probably have some insight in carpentry and masonry.
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/ceramics = SKILL_LEVEL_MASTER,
	)

/datum/outfit/job/roguetown/adventurer/potter/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/hatfur
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/hatblu

	cloak = /obj/item/clothing/cloak/apron/blacksmith
	pants = /obj/item/clothing/under/roguetown/trou
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/rogueweapon/blowrod
	beltr = /obj/item/rogueweapon/tongs   // Necessary for removing hot glass panes from furnaces.
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/shovel  // For getting clay

	backpack_contents = list(
		/obj/item/natural/clay = 3,
		/obj/item/natural/clay/glassbatch = 1,
		/obj/item/rogueore/coal = 1,
		/obj/item/roguegear = 1,
		/obj/item/dye_brush = 1,
		/obj/item/recipe_book/ceramics = 1)
	// Clay and glassBatch are raw materials
	// Coal so he can build an ore furnace for glass blowing
	// Coggers so he can build a potter's wheel.
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/digclay)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_CLASS, H, "Savings.")
