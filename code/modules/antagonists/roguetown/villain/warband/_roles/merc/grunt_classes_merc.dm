/////////////////////////////////////////////
/////////////////////////////////// MERCENARY
/*
	the Mercenary Company Warband is entirely reliant on the existing mercenary classes
	this just gives them an overall stat nudge to put them above the non-antag mercs
*/
/datum/advclass/warband/mercenary/grunt/merc
	title = "MERCENARY"
	name = "Mercenary"
	tutorial = "The MERCENARY's livelihood is held upon a simple promise. For the right price, he will die."
	outfit = /datum/outfit/job/roguetown/warband/mercenary/grunt/merc
	traits_applied = list(TRAIT_FORMATIONFIGHTER)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,		
	)



/datum/outfit/job/roguetown/warband/mercenary/grunt/merc/pre_equip(mob/living/carbon/human/H)
	..()
	H.change_stat(STATKEY_LCK, 1)
	H.change_stat(STATKEY_WIL, 1)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_INT, 1)
