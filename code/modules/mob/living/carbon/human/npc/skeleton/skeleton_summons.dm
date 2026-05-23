/mob/living/carbon/human/species/skeleton/npc/summon
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/npc/summon

/datum/outfit/job/roguetown/npc/skeleton/npc/summon

	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	head = /obj/item/clothing/head/roguetown/helmet/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots

/datum/outfit/job/roguetown/npc/skeleton/npc/summon/pre_equip(mob/living/carbon/human/H)
	..()

	shirt = prob(50) ? /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant : /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	switch(rand(1, 4)) //Random Weaponry choices - Slightly larger pool than bog guards.
		if(1)
			r_hand = /obj/item/rogueweapon/sword/iron
		if(2)
			r_hand = /obj/item/rogueweapon/spear
		if(3)
			r_hand = /obj/item/rogueweapon/mace
		if(3)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
	switch(rand(1, 3)) //Random Cloaks, akin to lich skeletons.
		if(1)
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if(2)
			cloak = /obj/item/clothing/cloak/tabard/lich
		if(3)
			cloak = /obj/item/clothing/cloak/half/lich
			mask = /obj/item/clothing/cloak/tabard/stabard/guardhood/lich
	H.STASTR = rand(11,13)
	H.STASPD = 8
	H.STACON = 7 //Decently tough, has a lifespan + player tied
	H.STAINT = 1
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)

	H.energy = H.max_energy //Always combat-ready
