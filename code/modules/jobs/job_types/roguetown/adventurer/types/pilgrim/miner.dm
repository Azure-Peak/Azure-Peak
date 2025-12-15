/datum/advclass/miner
	name = "Miner"
	tutorial = "Swing the pick. Heave. Swing. Heave. Deep underground where the days lose their meaning, the work is grueling, the tunnels cramped, and the stale air full of coal dust, yet tales abound of the lucky few who persevered, and found enough precious gems to set them for life."

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/miner

	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	traits_applied = list(TRAIT_DARKVISION, TRAIT_SMITHING_EXPERT) // Smithing Expert, because from what I observe of miner players they tend to do smithing far more than farming etc.
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_LCK = 2,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, // Tough. Well fed. The strongest of the strong.
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/mining = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)


/datum/outfit/job/roguetown/adventurer/miner/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/cap
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/pick
	beltr = /obj/item/storage/hip/orestore/bronze
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/chisel = 1,
						/obj/item/rogueweapon/hammer/wood = 1,
						/obj/item/recipe_book/survival = 1,
						/obj/item/recipe_book/builder = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1,
						/obj/item/rogueweapon/huntingknife = 1,
						/obj/item/storage/hip/orestore/bronze = 1
						)
	if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/brown
	if(H.pronouns == HE_HIM || H.pronouns == THEY_THEM || H.pronouns == IT_ITS)
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
		pants = /obj/item/clothing/under/roguetown/trou
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mineroresight)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_WORKING_CLASS, H, "Savings.")
