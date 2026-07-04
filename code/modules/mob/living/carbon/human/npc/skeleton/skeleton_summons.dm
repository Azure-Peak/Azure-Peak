/mob/living/carbon/human/species/skeleton/npc/summon //Unique skilled NPC summons exclusive to necromancers, these guys are a menace to fight.
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/npc/summon

/datum/outfit/job/roguetown/npc/skeleton/npc/summon //On par getup almost with greater summons, because sovl.

	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
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
		if(4)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
	switch(rand(1, 3)) //Random Cloaks, akin to regular-ish necro skeletons.
		if(1)
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/necro
		if(2)
			cloak = /obj/item/clothing/cloak/tabard/necro
		if(3)
			cloak = /obj/item/clothing/cloak/half/lich
	H.STASTR = rand(11,13)
	H.STASPD = 7 //Slightly slower cause you can have a LOT of these guys.
	H.STACON = 7 //Decently tough, has a lifespan + player tied, will still crumble to fients/numbers.
	H.STAINT = 1
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE) //Good parrying, still will crumble to numbers. Intended so lone advs/garrison can't just solo through a necromancer's summons with ease.
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)

	H.energy = H.max_energy //Always combat-ready
