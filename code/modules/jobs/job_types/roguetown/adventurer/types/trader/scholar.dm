/datum/advclass/trader/scholar
	name = "Scholar"
	tutorial = "You are a scholar traveling the world in order to write a book about your ventures. You trade in stories and tales of your travels."
	outfit = /datum/outfit/job/roguetown/adventurer/scholar
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ALCHEMY_EXPERT)
	class_select_category = CLASS_CAT_TRADER
	category_tags = list(CTAG_TRADER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 1,
		STATKEY_SPD = 1,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/adventurer/scholar/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a scholar traveling the world in order to write a book about your ventures. You trade in stories and tales of your travels."))
	head = /obj/item/clothing/head/roguetown/roguehood/black
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/mageyellow
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/huntingknife/idagger
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	backpack_contents = list(
		/obj/item/paper/scroll = 3,
		/obj/item/book/rogue/knowledge1 = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/manapot = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/strongmanapot = 1,
		/obj/item/natural/feather = 1,
		/obj/item/roguegem/amethyst = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
