/mob/living/carbon/human/species/skeleton/npc/bogguard
	threat_point = THREAT_MODERATE
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/npc/bogguard

/datum/outfit/job/roguetown/npc/skeleton/npc/bogguard/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(60))//WRIST
		wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	if(prob(90))//SHIRT
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/bog
	if(prob(75))
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson
		if(prob(50))
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	pants = /obj/item/clothing/under/roguetown/trou/leather
	if(prob(25))
		pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	if(prob(50))//HEAD
		head = /obj/item/clothing/head/roguetown/roguehood/bogman
		if(prob(60))
			head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	neck= /obj/item/clothing/neck/roguetown/chaincoif/iron
	cloak = /obj/item/clothing/cloak/tabard/stabard/bog
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	if(prob(50))
		shoes = /obj/item/clothing/shoes/roguetown/boots
	switch(rand(1, 7))
		if(1)
			r_hand = /obj/item/rogueweapon/sword/iron
		if(2)
			r_hand = /obj/item/rogueweapon/spear
		if(3)
			r_hand = /obj/item/rogueweapon/mace
		if(4)
			r_hand = /obj/item/rogueweapon/spear/militia
		if(5)
			r_hand = /obj/item/rogueweapon/sword/iron
			l_hand = /obj/item/rogueweapon/shield/wood
		if(6)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
		if(7)
			r_hand = /obj/item/rogueweapon/mace/cudgel
			l_hand = /obj/item/rogueweapon/shield/wood
	H.STASTR = rand(12,14)
	H.STASPD = 8
	H.STACON = 4
	H.STAWIL = 8
	H.STAINT = 1
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_APPRENTICE, TRUE)

/mob/living/carbon/human/species/skeleton/npc/bogguard/archer
	threat_point = THREAT_LOW
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/npc/bogguard/archer

/datum/outfit/job/roguetown/npc/skeleton/npc/bogguard/archer/pre_equip(mob/living/carbon/human/H)
	..()
	name = "Skeleton Archer"
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backl = /obj/item/quiver/randomfill/skeleton
	if(prob(60))//WRIST
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	if(prob(90))//SHIRT
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/bog
	if(prob(75))
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson
		if(prob(50))
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	pants = /obj/item/clothing/under/roguetown/trou/leather
	if(prob(50))//HEAD
		head = /obj/item/clothing/head/roguetown/roguehood/bogman
		if(prob(60))
			head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	neck= /obj/item/clothing/neck/roguetown/chaincoif/iron
	cloak = /obj/item/clothing/cloak/tabard/stabard/bog
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	if(prob(50))
		shoes = /obj/item/clothing/shoes/roguetown/boots
	head = null
	mask = null
	neck = null
	H.STAPER = 11
	H.STAWIL -= 1
	H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)

/mob/living/carbon/human/species/skeleton/npc/bogguard/master
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/npc/bogguard/master

/datum/outfit/job/roguetown/npc/skeleton/npc/bogguard/master/pre_equip(mob/living/carbon/human/H)
	. = ..()
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull
	mask = /obj/item/clothing/head/roguetown/roguehood/bogman
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
	H.STACON = 8
	H.STAWIL = 12
	H.STAINT = 1
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	if(!H.mind)
		return
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
