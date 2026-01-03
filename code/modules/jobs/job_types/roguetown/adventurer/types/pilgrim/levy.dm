/datum/advclass/levy
	name = "Levy"
	tutorial = "When the bailiff came to your household it was the worst dae of your lyfe, dragging you away into service to the Crown with nothing more but a trusty spear. Safeguard your home from the terrors beyond the walls and those lurking in the bog."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/levy
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	category_tags = list(CTAG_TOWNER)
	maximum_possible_slots = 3 //So you don't get a swarm of ppl
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = -1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/levy/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	neck = /obj/item/clothing/neck/roguetown/coif
	mask = /obj/item/clothing/head/roguetown/armingcap
	cloak = /obj/item/clothing/cloak/tabard/stabard/bog
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	r_hand = /obj/item/rogueweapon/spear
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_DESTITUTE, H, "Savings.")
