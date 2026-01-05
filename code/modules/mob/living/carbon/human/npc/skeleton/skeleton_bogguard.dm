/mob/living/carbon/human/species/skeleton/npc/bogguard
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/npc/bogguard

/datum/outfit/job/roguetown/npc/skeleton/npc/bogguard/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(50))//WRIST
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	if(prob(10))//ARMOUR
		armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	if(prob(50))//SHIRT
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
		if(prob(15))
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
			if(prob(15))
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	if(prob(50))//PANTS
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(25))
			pants = /obj/item/clothing/under/roguetown/chainlegs/iron
			if(prob(25))
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	if(prob(50))//HEAD
		head = /obj/item/clothing/neck/roguetown/coif
		if(prob(30))
			head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	if(prob(50))
		neck= /obj/item/clothing/neck/roguetown/chaincoif/iron
	if(prob(50))//CLOAK
		cloak = /obj/item/clothing/cloak/tabard/stabard/bog
	switch(rand(1, 3))
		if(1)
			r_hand = /obj/item/rogueweapon/sword/iron
		if(2)
			r_hand = /obj/item/rogueweapon/spear
		if(3)
			r_hand = /obj/item/rogueweapon/mace
	H.STASTR = rand(12,14)
	H.STASPD = 8
	H.STACON = 4
	H.STAWIL = 15
	H.STAINT = 1
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)

/mob/living/carbon/human/species/skeleton/npc/bogguard/master
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/npc/bogguard/master

/datum/outfit/job/roguetown/npc/skeleton/npc/bogguard/master/pre_equip(mob/living/carbon/human/H)
	. = ..()
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull
	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	cloak = /obj/item/clothing/cloak/tabard/stabard/bog
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather
	r_hand = /obj/item/rogueweapon/halberd
	H.STASTR = 18
	H.STASPD = 10
	H.STACON = 10
	H.STAWIL = 16
	H.STAINT = 1
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	if(!H.mind)
		return
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
