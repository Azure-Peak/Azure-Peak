/datum/advclass/zealot
	name = "Zealot"
	tutorial = "You are a commoner of unwavering faith. Obnoxiously so. You may be a laborer, a farmer, or simply another face among the townsfolk, but your devotion to your god runs deeper than most can understand. You pray, you believe, and somehow the gods cannot seem to look away. When you call upon them, they answer."
	outfit = /datum/outfit/job/roguetown/adventurer/zealot
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_UNCONVERTIBLE) // your job is to convert others, not to end converted, ser. (also so you don't gain lesser miracle back lol)
	townie_contract_gate_exempt = TRUE
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE, //potential for repairs
	) //A little bit of every basic labor/craft skill, but zero combat skills
	maximum_possible_slots = 20 // Should not fill, just a hack to make it shows what types of towners are in round

/datum/outfit/job/roguetown/adventurer/zealot/pre_equip(mob/living/carbon/human/H)
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
		/obj/item/reagent_containers/glass/bottle/rogue/beer = 1,
		)

	if(H.mind)
		var/choice
		if(H.patron?.type in OLD_GOD_PATRON) // PSYDON. WILL. ENDVRE.
			choice = "Fervorous Faith (+1 Tier, No Healing)"
		else
			choice = input(H, "How does your devotion manifest?", "MY GOD IS EVERYTHING TO ME") as anything in list("Fervorous Faith (+1 Tier, No Healing)","Pious Devotion (Healing)")

		var/datum/devotion/D = new /datum/devotion/(H, H.patron)
		switch(choice)
			if("Fervorous Faith (+1 Tier, No Healing)")
				D.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_1)
				H.mind.RemoveSpell(/datum/action/cooldown/spell/miracle/heal)
				H.mind.RemoveSpell(/datum/action/cooldown/spell/miracle/heal/undivided)

			if("Pious Devotion (Healing)")
				D.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_1)

		SStreasury.grant_savings(ECONOMIC_LOWER_MIDDLE_CLASS, H)
