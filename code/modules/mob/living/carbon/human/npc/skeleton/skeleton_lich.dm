/mob/living/carbon/human/species/skeleton/npc/dungeon/lich
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
	H.faction = list("lich")
	H.wander = FALSE

	H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/masonry, 1, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/sewing, 1, TRUE)

	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, 2, TRUE)

	H.set_patron(/datum/patron/inhumen/zizo)
	if(prob(50))
		r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
	else
		r_hand = /obj/item/rogueweapon/greatsword/zwei
