// Skeleton with no equipments but skills and stats
// Mostly meant for Tomb of Alotheos
/mob/living/carbon/human/species/skeleton/npc/medium/noequip
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/medium_skills_only

/datum/outfit/job/roguetown/skeleton/npc/medium_skills_only/pre_equip(mob/living/carbon/human/H)
	..()
	name = "Skeleton Soldier"
	H.STASTR = 11
	H.STASPD = 8
	H.STACON = 6
	H.STAWIL = 8
	H.STAINT = 1
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

/mob/living/carbon/human/species/skeleton/npc/hard/noequip
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/hard_skills_only

/datum/outfit/job/roguetown/skeleton/npc/hard_skills_only/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 12
	H.STACON = 8
	H.STAWIL = 10
	H.STAINT = 1
	name = "Skeleton Dreadnought"
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
