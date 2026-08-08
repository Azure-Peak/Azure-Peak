// amalgam of miner+townsmith, builder n supplier for the others
/datum/advclass/outcast/scrapper
	name = "Scrapper"
	tutorial = "You were once a humble laborer, slaving away to supply the endless stream of wanderers with arms and armor. For one reason or another, that carefree lyfe came to an end, and you've found yourself on the run. You know something most exiles don't: true power comes not from the strength of one's sword-arm, but from well-equipped allies."

	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/outcast/scrapper

	category_tags = list(CTAG_OUTCAST)
	traits_applied = list(TRAIT_DARKVISION, TRAIT_SMITHING_EXPERT, TRAIT_TRAINED_SMITH)
	subclass_stats = list( // towner miner is _9_ statweight. uh, lmao, so these lose 1str and 1lck to bring them down to the outcast baseline of 6
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_LCK = 1,
		STATKEY_WIL = 2
	)
	subclass_skills = list( // townsmith/miner amalgam but slightly worse
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN, // get it. they get into scraps. (ok yes this is already a thing on townminer shh)
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
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_JOURNEYMAN, // worse at smithing n smelting than townsmiths by 1 level since they're also getting mining
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/smelting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	maximum_possible_slots = 20 // Should not fill, just a hack to make it shows what types of outcasts are in round

// miner loadout with a bit of blacksmith mixed in, and the munitioneer hood
/datum/outfit/job/roguetown/outcast/scrapper/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/cap
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/pick
	beltr = /obj/item/storage/hip/orestore/bronze
	backl = /obj/item/storage/backpack/rogue/backpack
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	cloak = /obj/item/clothing/cloak/apron/blacksmith
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/chisel = 1,
						/obj/item/rogueweapon/hammer/wood = 1,
						/obj/item/recipe_book/builder = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1,
						/obj/item/rogueweapon/huntingknife = 1,
						/obj/item/storage/hip/orestore/bronze = 1
						)
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/brown
	if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
		pants = /obj/item/clothing/under/roguetown/trou
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	if(H.mind)
		H.AddComponent(/datum/component/ore_sight)
	outcast_select_bounty(H)
