/datum/outfit/job/roguetown/orc/npc/archer/pre_equip(mob/living/carbon/human/H)
	..()
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/quiver/arrows
	l_hand = /obj/item/rogueweapon/stoneaxe/boneaxe
	r_hand = null
	H.STASTR -= 2
	H.STAPER += 3
	H.STACON -= 1
	H.STAWIL -= 1
	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)

/mob/living/carbon/human/species/orc/npc/footsoldier
	threat_point = THREAT_HIGH
	ambush_faction = "orcs"
	orc_outfit = /datum/outfit/job/roguetown/orc/npc/footsoldier

/mob/living/carbon/human/species/orc/npc/marauder
	threat_point = THREAT_DANGEROUS
	orc_outfit = /datum/outfit/job/roguetown/orc/npc/marauder

/mob/living/carbon/human/species/orc/npc/berserker
	threat_point = THREAT_DANGEROUS
	orc_outfit = /datum/outfit/job/roguetown/orc/npc/berserker

/mob/living/carbon/human/species/orc/npc/warlord
	threat_point = THREAT_DEADLY
	orc_outfit = /datum/outfit/job/roguetown/orc/npc/warlord

// Underarmored orc with incomplete protection, bone axe / spear, and slow speed
/datum/outfit/job/roguetown/orc/npc/footsoldier/pre_equip(mob/living/carbon/human/H)
	name = "Orc Footsoldier"
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/barbarian //Cosmetic + Holding repair kits for looting mostly.
	if(prob(8))
		beltl = /obj/item/repair_kit/bad //So you can get repair kits easier from looting them
	if(prob(10))
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar //SHATTER MY BINDS
	var/cloak_choice = rand(1, 4)
	switch(cloak_choice)
		if(1)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
		if(2)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak/black
		if(3)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak //White
		if(4)
			cloak = /obj/item/clothing/cloak/volfmantle
	if(prob(50))
		armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	else
		armor = /obj/item/clothing/suit/roguetown/armor/leather
	pants = /obj/item/clothing/under/roguetown/loincloth
	if(prob(50))
		var/helmet_choice = rand(1, 3)
		switch(helmet_choice)
			if(1)
				head = /obj/item/clothing/head/roguetown/helmet/horned //SOVL
			if(2)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
			if(3)
				head = /obj/item/clothing/head/roguetown/helmet/leather
	shoes = /obj/item/clothing/shoes/roguetown/gladiator
	switch(rand(1, 3))
		if(1)
			l_hand = /obj/item/rogueweapon/stoneaxe/boneaxe
		if(2)
			l_hand = /obj/item/rogueweapon/spear/bonespear
			r_hand = /obj/item/rogueweapon/shield/wood // Help preserve integrity
		if(3)
			l_hand = /obj/item/rogueweapon/mace/cudgel/copper
	H.STASTR = 11
	H.STASPD = 8
	H.STACON = 7
	H.STAWIL = 6
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
	mask = /obj/item/clothing/mask/rogue/facemask
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/barbarian //Cosmetic + Holding repair kits for looting mostly.
	if(prob(10))
		beltl = /obj/item/repair_kit/bad //So you can get repair kits easier from looting them
	if(prob(10))
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar //SHATTER MY BINDS
	var/cloak_choice = rand(1, 4)
	switch(cloak_choice)
		if(1)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
		if(2)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak/black
		if(3)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak //White
		if(4)
			cloak = /obj/item/clothing/cloak/volfmantle
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/leather
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
	H.STACON = 9
	H.STAWIL = 8
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

// Lightly armored orc in light armor with no pain stun, and duel-wielder oriented weapons
/datum/outfit/job/roguetown/orc/npc/berserker/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/trou/leather
	neck = /obj/item/clothing/neck/roguetown/coif
	mask = /obj/item/clothing/mask/rogue/facemask
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/barbarian //Cosmetic + Holding repair kits for looting mostly.
	if(prob(15))
		beltl = /obj/item/repair_kit/bad //So you can get repair kits easier from looting them
	if(prob(20))
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar //SHATTER MY BINDS
	head = /obj/item/clothing/head/roguetown/helmet/skullcap
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/horned
	var/cloak_choice = rand(1, 4)
	switch(cloak_choice)
		if(1)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
		if(2)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak/black
		if(3)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak //White
		if(4)
			cloak = /obj/item/clothing/cloak/volfmantle
	var/wepchoice = rand(1, 3)
	switch(wepchoice)
		if(1)
			l_hand = /obj/item/rogueweapon/huntingknife/idagger
			r_hand = /obj/item/rogueweapon/huntingknife/idagger
		if(2)
			l_hand = /obj/item/rogueweapon/stoneaxe/handaxe
			r_hand = /obj/item/rogueweapon/stoneaxe/handaxe
		if(3)
			l_hand = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
			r_hand = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
	H.STASTR = 13 // GAGGER GAGGER GAGGER
	H.STASPD = 10 // Fast, for an orc
	H.STACON = 11
	H.STAWIL = 10
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
	ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)

// Heavily armored orc with complete iron protection, heavy armor, and a two hander. Is able to do special attacks.
/datum/outfit/job/roguetown/orc/npc/warlord/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/iron/banded //Tough upgrade for ironclad, pretty average for anyone else who can't use heavy armor 
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	head = /obj/item/clothing/head/roguetown/helmet/sallet/iron/banded
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced //Stays cause this is slightly-higher-ended
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/black //Cosmetic + Holding repair kits for looting mostly.
	if(prob(50))
		beltl = /obj/item/repair_kit/bad //So you can get repair kits easier from looting them
	if(prob(66))
		beltr = /obj/item/reagent_containers/glass/bottle/alchemical/healthpot //Small heal to loot since they do a lot of damage
	if(prob(60))
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar //SHATTER MY BINDS
	var/neck_choice = rand(1, 3)
	switch(neck_choice)
		if(1)
			neck = /obj/item/clothing/neck/roguetown/gorget //SOVL
		if(2)
			neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
		if(3)
			neck = /obj/item/clothing/neck/roguetown/bevor/iron
	var/cloak_choice = rand(1, 4)
	switch(cloak_choice)
		if(1)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
		if(2)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak/black
		if(3)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak //White
		if(4)
			cloak = /obj/item/clothing/cloak/volfmantle
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
			l_hand = /obj/item/rogueweapon/greatsword/iron
	H.STASTR = 14 // GAGGER GAGGER GAGGER
	H.STASPD = 8
	H.STACON = 9
	H.STAWIL = 11
	H.STAINT = 8 //Minimal req to do special attacks.
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


/mob/living/carbon/human/species/orc/npc/juggernaut
	threat_point = THREAT_ELITE
	ambush_faction = "orcs"
	orc_outfit = /datum/outfit/job/roguetown/orc/npc/warlord/juggernaut

/mob/living/carbon/human/species/orc/npc/juggernaut/after_creation()
	..()
	job = "Orc Juggernaut"
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	var/obj/item/bodypart/head/jug_head = get_bodypart(BODY_ZONE_HEAD)
	if(jug_head)
		jug_head.sellprice = HEAD_BOUNTY_BIG_GUY
	for(var/obj/item/gear in get_equipped_items() + held_items)
		lock_gear_piece(gear, "orc_juggernaut_gear")

/mob/living/carbon/human/species/orc/npc/juggernaut/death(gibbed, nocutscene = FALSE)
	. = ..()
	for(var/obj/item/gear in get_equipped_items() + held_items)
		REMOVE_TRAIT(gear, TRAIT_NODROP, "orc_juggernaut_gear")

/datum/outfit/job/roguetown/orc/npc/warlord/juggernaut/pre_equip(mob/living/carbon/human/H)
	..()
	name = "Orc Juggernaut"
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	H.STASTR = 16
	H.STASPD = 8
	H.STACON = 13
	H.STAWIL = 13
	H.STAINT = 8
	H.adjust_skillrank(/datum/skill/combat/polearms, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
