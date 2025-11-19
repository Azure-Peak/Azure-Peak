/datum/advclass/warband/mercenary/warlord/captain
	title = "CAPTAIN"
	name = "Captain"
	tutorial = "Take a merchant's cunning, a soldier's grit, and the pragmatism of both. Brew them all together, and you'll get an \
	especially unpleasant person. Now arrives the CAPTAIN - as unpleasant as they come, and paid quite handsomely for it."
	outfit = /datum/outfit/job/roguetown/warband/mercenary/warlord/captain

	traits_applied = list(TRAIT_FORMATIONFIGHTER, TRAIT_LAWEXPERT, TRAIT_STEELHEARTED)

	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,		
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,		
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/warband/mercenary/warlord/captain/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)
	H.change_stat(STATKEY_LCK, 2)
	H.change_stat(STATKEY_WIL, 2)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_INT, 2)
