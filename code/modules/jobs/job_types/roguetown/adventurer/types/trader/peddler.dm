/datum/advclass/trader/peddler
	name = "Peddler"
	tutorial = "You make your coin peddling in spices and performing back-alley 'medical' procedures. Hope your patient didn't need that kidney."
	outfit = /datum/outfit/job/roguetown/adventurer/peddler
	class_select_category = CLASS_CAT_TRADER
	category_tags = list(CTAG_TRADER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	traits_applied = list(TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/peddler/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You make your coin peddling in spices and performing back-alley 'medical' procedures. Hope your patient didn't need that kidney."))
	head = /obj/item/clothing/head/roguetown/roguehood
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/storage/belt/rogue/surgery_bag/full
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/reagent_containers/powder/spice = 2,
		/obj/item/reagent_containers/powder/ozium = 1,
		/obj/item/reagent_containers/powder/moondust = 2,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
