/datum/advclass/trader/doomsayer
	name = "Doomsayer"
	tutorial = "THE WORLD IS ENDING!!! At least, that's what you want your clients to believe. You'll offer them a safe place in the new world, of course - built by yours truly."
	outfit = /datum/outfit/job/roguetown/adventurer/doomsayer
	category_tags = list(CTAG_TRADER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	class_select_category = CLASS_CAT_TRADER
	traits_applied = list(TRAIT_PSYCHOSIS, TRAIT_HOMESTEAD_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 1,
		STATKEY_STR = 1,
		STATKEY_CON = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/doomsayer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("THE WORLD IS ENDING!!! At least, that's what you want your clients to believe. You'll offer them a safe place in the new world, of course - built by yours truly."))
	head = /obj/item/clothing/head/roguetown/roguehood/black
	mask = /obj/item/clothing/mask/rogue/skullmask
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/half
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut
	backpack_contents = list(
		/obj/item/clothing/neck/roguetown/psicross/silver = 3,
		/obj/item/clothing/neck/roguetown/psicross = 2,
		/obj/item/clothing/neck/roguetown/psicross/wood = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
