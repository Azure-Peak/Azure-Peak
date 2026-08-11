/datum/advclass/sage // godsblood witch, but without the witch outfit, deathsight, zadform, etc; cleric offrole, similar outfit to sextons
	name = "Sage"
	tutorial = "Unlike most of the townsfolk, you bear a rare devotion to the gods. Your penchant for healing the sick and aiding the troubled has earned you the gratitude of many among the townsfolk."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/adventurer/sage
	forbidden_races = list(RACES_DESPISED) // unlike witch, this ISN'T an outcast role
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	traits_applied = list(TRAIT_ALCHEMY_EXPERT)
	townie_contract_gate_exempt = TRUE
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1
	)
	age_mod = /datum/class_age_mod/sage

	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)
	maximum_possible_slots = 20 // Should not fill, just a hack to make it shows what types of towners are in round

/datum/outfit/job/roguetown/adventurer/sage/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	gloves = /obj/item/clothing/gloves/roguetown/leather
	pants = /obj/item/clothing/under/roguetown/trou
	belt = /obj/item/storage/belt/rogue/leather/sash
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	beltl = /obj/item/rogueweapon/shovel/small
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/reagent_containers/glass/mortar = 1,
		/obj/item/pestle = 1,
		/obj/item/candle/yellow = 2,
	)
	switch(H.patron?.type)
		if(/datum/patron/divine/undivided)
			neck = /obj/item/clothing/neck/roguetown/psicross/undivided
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/psicross/xylix
		else
			neck = /obj/item/clothing/neck/roguetown/psicross
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_LOWER_MIDDLE_CLASS, H)
