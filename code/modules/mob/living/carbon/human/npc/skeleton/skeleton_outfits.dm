// Ultra easy tier skeleton with no armor and just a single weapon.
/mob/living/carbon/human/species/skeleton/npc/supereasy
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/supereasy

// Easy tier skeleton, with only incomplete chainmail and kilt
// Ambushes people in "safe" route. A replacement for old skeletons that were effectively naked.
/mob/living/carbon/human/species/skeleton/npc/easy
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/easy

// Also an "easy" tier skeleton, pirate themed, with a free hand to grab you
/mob/living/carbon/human/species/skeleton/npc/pirate
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/pirate

// Medium tier skeleton, 3 skills.
/mob/living/carbon/human/species/skeleton/npc/medium
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/medium

// High tier skeleton, 4 skills. Heavy Armor.
/mob/living/carbon/human/species/skeleton/npc/hard
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/hard

// For Duke Manor & Zizo Manor - Ground based spread, so no pirate in pool!
/mob/living/carbon/human/species/skeleton/npc/mediumspread/Initialize()
	var/outfit = rand(1, 4)
	switch(outfit)
		if(1)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/supereasy
		if(2)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/easy
		if(3)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/medium
		if(4)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/hard
	..()

/mob/living/carbon/human/species/skeleton/npc/mediumspread/lich
	faction = list("lich")

// for Lich Dungeon
/mob/living/carbon/human/species/skeleton/npc/hardspread/Initialize()
	var/outfit = rand(1,4)
	switch(outfit)
		if(1)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/hard
		if(2)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/medium
		if(3)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/pirate
		if(4)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/hard
	..()

/datum/outfit/job/roguetown/skeleton/npc/supereasy/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 10
	H.STASPD = 8
	H.STACON = 4
	H.STAWIL = 10
	H.STAINT = 1
	name = "Skeleton"
	if(prob(50))
		shirt = /obj/item/clothing/suit/roguetown/shirt/rags
	else
		shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	if(prob(50))
		pants = /obj/item/clothing/under/roguetown/tights/random
	else
		pants = /obj/item/clothing/under/roguetown/loincloth
	var/weapon_choice = rand(1, 4)
	switch(weapon_choice)
		if(1)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/aaxe
		if(2)
			r_hand = /obj/item/rogueweapon/sword/short/ashort
		if(3)
			r_hand = /obj/item/rogueweapon/spear/aalloy
		if(4)
			r_hand = /obj/item/rogueweapon/mace/alloy
	H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/datum/outfit/job/roguetown/skeleton/npc/easy/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 9
	H.STASPD = 8
	H.STACON = 4 // Same statblock as before easily killed
	H.STAWIL = 12
	H.STAINT = 1
	name = "Skeleton Footsoldier"
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	var/weapon_choice = rand(1, 4)
	switch(weapon_choice)
		if(1)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/aaxe
		if(2)
			r_hand = /obj/item/rogueweapon/sword/short/ashort
		if(3)
			r_hand = /obj/item/rogueweapon/spear/aalloy
		if(4)
			r_hand = /obj/item/rogueweapon/mace/alloy
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/datum/outfit/job/roguetown/skeleton/npc/pirate/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 9
	H.STASPD = 8
	H.STACON = 4 // Same statblock as before easily killed
	H.STAWIL = 12
	H.STAINT = 1
	name = "Skeleton Pirate"
	head =  /obj/item/clothing/head/roguetown/helmet/tricorn
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	if(prob(50))
		r_hand = /obj/item/rogueweapon/huntingknife/idagger/adagger
	else
		r_hand = /obj/item/rogueweapon/knuckles/aknuckles
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/datum/outfit/job/roguetown/skeleton/npc/medium/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 11
	H.STASPD = 8
	H.STACON = 6 // Slightly tougher now!
	H.STAWIL = 10
	H.STAINT = 1
	name = "Skeleton Soldier"
	cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/guard // Ooo Spooky Old Dead MAA
	head = /obj/item/clothing/head/roguetown/helmet/heavy/aalloy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	belt = /obj/item/storage/belt/rogue/leather/rope
	if(prob(15))
		beltl = /obj/item/repair_kit/bad
	if(prob(33)) // 33% chance of shield, so ranged don't get screwed over entirely
		l_hand = /obj/item/rogueweapon/shield/tower/metal/alloy
	if(prob(33))
		r_hand = /obj/item/rogueweapon/spear/aalloy
	else if(prob(33))
		r_hand = /obj/item/rogueweapon/sword/short/gladius/agladius	// ave
	else
		r_hand = /obj/item/rogueweapon/flail/aflail
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

/datum/outfit/job/roguetown/skeleton/npc/hard/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 12
	H.STACON = 8 // Woe, actual limb health.
	H.STAWIL = 12
	H.STAINT = 1
	name = "Skeleton Dreadnought"
	// This combines the khopesh  and withered dreadknight
	var/skeletonclass = rand(1, 2)
	if(skeletonclass == 1) // Khopesh Knight
		H.STASPD = 12 // Hue
		cloak = /obj/item/clothing/cloak/hierophant
		mask = /obj/item/clothing/mask/rogue/facemask/aalloy
		armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/aalloy
		shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
		wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
		pants = /obj/item/clothing/under/roguetown/platelegs/aalloy
		shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
		neck = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy
		gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
		r_hand = /obj/item/rogueweapon/sword/sabre/alloy
		l_hand = /obj/item/rogueweapon/sword/sabre/alloy
	else // Withered Dreadknight
		H.STASPD = 8
		cloak = /obj/item/clothing/cloak/tabard/blkknight
		head = /obj/item/clothing/head/roguetown/helmet/heavy/guard/aalloy
		armor = /obj/item/clothing/suit/roguetown/armor/plate/aalloy
		shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy
		wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
		pants = /obj/item/clothing/under/roguetown/platelegs/aalloy
		shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
		neck = /obj/item/clothing/neck/roguetown/gorget/aalloy
		gloves = /obj/item/clothing/gloves/roguetown/plate/aalloy
		belt = /obj/item/storage/belt/rogue/leather
		if(prob(15))
			beltl = /obj/item/repair_kit/metal/bad
		if(prob(50))
			r_hand = /obj/item/rogueweapon/greatsword/aalloy
		else
			r_hand = /obj/item/rogueweapon/mace/goden/aalloy
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
