/datum/advclass/trader/cuisiner
	name = "Cuisiner"
	tutorial = "Whether a disciple of a culinary school, a storied royal chef, or a mercenary cook for hire, your trade is plied at the counter, \
	the cutting board, and the hearth."
	outfit = /datum/outfit/job/roguetown/adventurer/cuisiner
	traits_applied = list(TRAIT_GOODLOVER, TRAIT_HOMESTEAD_EXPERT)
	class_select_category = CLASS_CAT_TRADER
	category_tags = list(CTAG_TRADER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = 1
	)
	age_mod = /datum/class_age_mod/cuisiner
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/cuisiner/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Whether a disciple of a culinary school, a storied royal chef, or a mercenary cook for hire, your trade is plied at the counter, \
	the cutting board, and the hearth."))
	head = /obj/item/clothing/head/roguetown/chef
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	pants = /obj/item/clothing/under/roguetown/trou
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/backpack
	beltr = /obj/item/cooking/pan
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/clothing/mask/cigarette/rollie/nicotine/cheroot = 5,
		/obj/item/reagent_containers/peppermill = 1,
		/obj/item/reagent_containers/food/snacks/rogue/cheddar/aged = 1,
		/obj/item/reagent_containers/food/snacks/butter = 1,
		/obj/item/kitchen/rollingpin = 1,
		/obj/item/flint = 1,
		/obj/item/rogueweapon/huntingknife/chefknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/recipe_book/survival = 1,
		)
		// no ration wrappers by design
