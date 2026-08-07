/mob/living/carbon/human/species/skeleton/npc/dungeon/lich
	threat_point = THREAT_ELITE
	skel_fragile = FALSE
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/dungeon/lich

/datum/outfit/job/roguetown/npc/skeleton/dungeon/lich/pre_equip(mob/living/carbon/human/H)
	..()
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/blkknight/death
	armor = /obj/item/clothing/suit/roguetown/armor/plate/blkknight/death
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blkknight/death
	pants = /obj/item/clothing/under/roguetown/platelegs/blkknight/death
	neck = /obj/item/clothing/neck/roguetown/bevor
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/black
	belt = /obj/item/storage/belt/rogue/leather/black
	H.STASTR = 20
	H.STAPER = 20
	H.STASPD = 10
	H.STACON = 20
	H.STAWIL = 20
	H.STAINT = 1
	H.faction = list(FACTION_LICH)


	H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_NOVICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_NOVICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_NOVICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_NOVICE, TRUE)

	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_APPRENTICE, TRUE)

	H.set_patron(/datum/patron/inhumen/zizo)
	if(prob(50))
		r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
	else
		r_hand = /obj/item/rogueweapon/greatsword/zwei
