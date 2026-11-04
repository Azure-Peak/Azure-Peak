//challenge class, spawns with no items at all
/datum/advclass/nudist
	name = "Nudist"
	tutorial = "They say that the most devout of Dendor forgo clothing in order to weather their body to the natural elements. You happen to be one of them!"
	allowed_sexes = list(MALE, FEMALE)
	allowed_patrons = list(/datum/patron/divine/dendor)
	outfit = /datum/outfit/job/roguetown/adventurer/nudist
	category_tags = list(CTAG_ADVENTURER, CTAG_LICKER_WRETCH)
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_INT = -2
	)
	subclass_skills = list(
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/nudist/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/rogueweapon/huntingknife/stoneknife
	neck = /obj/item/clothing/neck/roguetown/psicross/dendor

//this is so fucking abysmal, I'm sorry
//VL uses this, other antags in pre-set roles w/out varience can also use it, its a failsafe fallback to make a blank-slate 4 roundstarters
/datum/advclass/nothing
	name = "No Outfit"
	tutorial = "You shouldn't be seeing this"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/nothing
	category_tags = list(CTAG_NO_OUTFIT)

/datum/outfit/job/roguetown/adventurer/nothing/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(0)
