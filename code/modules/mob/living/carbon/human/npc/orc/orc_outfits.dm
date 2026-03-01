/mob/living/carbon/human/species/orc/npc/footsoldier
	orc_outfit = /datum/outfit/job/roguetown/orc/npc/footsoldier

/mob/living/carbon/human/species/orc/npc/marauder
	orc_outfit = /datum/outfit/job/roguetown/orc/npc/marauder

/mob/living/carbon/human/species/orc/npc/berserker
	npc_jump_chance = 25 // Meant to leap and scare you - probably
	orc_outfit = /datum/outfit/job/roguetown/orc/npc/berserker

/mob/living/carbon/human/species/orc/npc/warlord
	orc_outfit = /datum/outfit/job/roguetown/orc/npc/warlord

// Underarmored orc with incomplete protection, bone axe / spear, and slow speed
/datum/outfit/job/roguetown/orc/npc/footsoldier/pre_equip(mob/living/carbon/human/H)
	name = "Orc Footsoldier"
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	if(prob(50))
		armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	else
		armor = /obj/item/clothing/suit/roguetown/armor/leather
	pants = /obj/item/clothing/under/roguetown/loincloth
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/leather
	shoes = /obj/item/clothing/shoes/roguetown/gladiator
	var/wepchoice = rand(1, 3)
	switch(wepchoice)
		if(1)
			l_hand = /obj/item/rogueweapon/stoneaxe/boneaxe
		if(2)
			l_hand = /obj/item/rogueweapon/spear/bonespear
			r_hand = /obj/item/rogueweapon/shield/wood // Help preserve integrity
		if(3)
			l_hand = /obj/item/rogueweapon/mace/cudgel/copper
	H.STASTR = 11
	H.STASPD = 8
	H.STACON = 11
	H.STAWIL = 11
	H.STAINT = 4 // Very dumb
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)

// Slightly armored orc with slight facial protection, incomplete chainmail and spear / sword
/datum/outfit/job/roguetown/orc/npc/marauder/pre_equip(mob/living/carbon/human/H)
	name = "Orc Marauder"
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	neck = /obj/item/clothing/neck/roguetown/coif
	head = /obj/item/clothing/head/roguetown/helmet/leather
	mask = /obj/item/clothing/mask/rogue/facemask
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	var/wepchoice = rand(1, 5)
	switch(wepchoice)
		if(1)
			l_hand = /obj/item/rogueweapon/spear
		if(2)
			l_hand = /obj/item/rogueweapon/sword/short/falchion
			r_hand = /obj/item/rogueweapon/shield/wood // Help preserve integrity
		if(3)
			l_hand = /obj/item/rogueweapon/mace // Threat to parry-er
		if(4)
			l_hand = /obj/item/rogueweapon/greataxe
		if(5)
			l_hand = /obj/item/rogueweapon/pick/militia
	H.STASTR = 12 // GAGGER GAGGER GAGGER
	H.STASPD = 8
	H.STACON = 12
	H.STAWIL = 10
	H.STAINT = 4
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

// Lightly armored orc in light armor with no pain stun, and grappling oriented weapons
/datum/outfit/job/roguetown/orc/npc/berserker/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/trou/leather
	head = /obj/item/clothing/head/roguetown/helmet/leather
	neck = /obj/item/clothing/neck/roguetown/coif
	mask = /obj/item/clothing/mask/rogue/facemask
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	var/wepchoice = rand(1, 2)
	switch(wepchoice)
		if(1)
			l_hand = /obj/item/rogueweapon/huntingknife/idagger
		if(2)
			l_hand = /obj/item/rogueweapon/pick/militia
	H.STASTR = 13 // GAGGER GAGGER GAGGER
	H.STASPD = 10 // Fast, for an orc
	H.STACON = 12
	H.STAWIL = 12
	H.STAINT = 1 // Minmax department
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, INNATE_TRAIT)

// Heavily armored orc with complete iron protection, heavy armor, and a two hander.
/datum/outfit/job/roguetown/orc/npc/warlord/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	head = /obj/item/clothing/head/roguetown/helmet/skullcap
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	mask = /obj/item/clothing/mask/rogue/facemask
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	var/wepchoice = rand(1, 6)
	switch(wepchoice)
		if(1)
			l_hand = /obj/item/rogueweapon/halberd/bardiche
		if(2)
			l_hand = /obj/item/rogueweapon/halberd
		if(3)
			l_hand = /obj/item/rogueweapon/greataxe
		if(4)
			l_hand = /obj/item/rogueweapon/eaglebeak/lucerne
		if(5)
			l_hand = /obj/item/rogueweapon/mace/goden
		if(6)
			l_hand = /obj/item/rogueweapon/sword/short/falchion
			r_hand = /obj/item/rogueweapon/sword/short/falchion // intrusive thoughts
	H.STASTR = 14 // GAGGER GAGGER GAGGER
	H.STASPD = 10 // Fast, for an orc
	H.STACON = 12
	H.STAWIL = 12
	H.STAINT = 1
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRIT_THRESHOLD, TRAIT_GENERIC)
