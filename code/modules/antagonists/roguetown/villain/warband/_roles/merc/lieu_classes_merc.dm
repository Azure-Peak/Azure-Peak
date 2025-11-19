//////////////////////////////////////////////////////////////////
/////////////////////////////////// 
/*
	the Mercenary Company Warband is entirely reliant on the existing mercenary classes
	these classes give them an overall stat nudge to put them above the non-antagonists
	+ sweep
*/

/datum/advclass/warband/mercenary/lieutenant/vanguard
	title = "VANGUARD"
	name = "Vanguard"
	tutorial = "First to the fray and first to bloody himself, the VANGUARD takes a lion's share of the Company's pay."
	outfit = /datum/outfit/job/roguetown/warband/mercenary/lieutenant/vanguard
	traits_applied = list(TRAIT_LAWEXPERT, TRAIT_FORMATIONFIGHTER)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,		
	)

/datum/outfit/job/roguetown/warband/mercenary/lieutenant/vanguard/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)
	H.change_stat(STATKEY_WIL, 3)
	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_CON, 3)
	H.change_stat(STATKEY_INT, -2)


/datum/advclass/warband/mercenary/lieutenant/tactician
	title = "TACTICIAN"
	name = "Tactician"
	tutorial = "In death's dance, the most essential movements call for swift decisions from a keen mind. The TACTICIAN provides."
	outfit = /datum/outfit/job/roguetown/warband/mercenary/lieutenant/tactician
	traits_applied = list(TRAIT_LAWEXPERT, TRAIT_FORMATIONFIGHTER)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,		
	)


/datum/outfit/job/roguetown/warband/mercenary/lieutenant/tactician/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)
	H.change_stat(STATKEY_LCK, 2)
	H.change_stat(STATKEY_PER, 3)
	H.change_stat(STATKEY_SPD, -1)
	H.change_stat(STATKEY_STR, -2)
	H.change_stat(STATKEY_CON, -1)
	H.change_stat(STATKEY_INT, 3)


/datum/advclass/warband/mercenary/lieutenant/skirmisher
	title = "SKIRMISHER"
	name = "Skirmisher"
	tutorial = "The SKIRMISHER is the epitome of mercenary philosophy: Fight when it's easy, and live long enough to get paid."
	traits_applied = list(TRAIT_LAWEXPERT, TRAIT_FORMATIONFIGHTER)
	subclass_stats = list(
		STATKEY_LCK = 2,
		STATKEY_WIL = -2,
		STATKEY_PER = 3,
		STATKEY_SPD = 3,
		STATKEY_STR = -3,
		STATKEY_CON = -2,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,		
	)

	outfit = /datum/outfit/job/roguetown/warband/mercenary/lieutenant/skirmisher

/datum/outfit/job/roguetown/warband/mercenary/lieutenant/skirmisher/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)
	H.change_stat(STATKEY_LCK, 2)
	H.change_stat(STATKEY_WIL, -2)
	H.change_stat(STATKEY_PER, 3)
	H.change_stat(STATKEY_SPD, 3)
	H.change_stat(STATKEY_STR, -2)
	H.change_stat(STATKEY_CON, -2)
	H.change_stat(STATKEY_INT, 1)
