// Ultra easy tier skeleton with no armor and just a single weapon.
/mob/living/carbon/human/species/skeleton/npc/supereasy
	threat_point = THREAT_LOW
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/supereasy

// Easy tier skeleton, with only incomplete chainmail and kilt
// Ambushes people in "safe" route. A replacement for old skeletons that were effectively naked.
/mob/living/carbon/human/species/skeleton/npc/easy
	threat_point = THREAT_MODERATE
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/easy

// Also an "easy" tier skeleton, pirate themed, with a free hand to grab you
/mob/living/carbon/human/species/skeleton/npc/pirate
	threat_point = THREAT_MODERATE
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/pirate

// Medium tier skeleton, 3 skills.
/mob/living/carbon/human/species/skeleton/npc/medium
	threat_point = THREAT_LOW
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/medium

// High tier skeleton, 4 skills. Heavy Armor.
/mob/living/carbon/human/species/skeleton/npc/hard
	threat_point = THREAT_TOUGH
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/hard

// Medium tier skeleton archer, bow skill 3.
/mob/living/carbon/human/species/skeleton/npc/archer
	threat_point = THREAT_LOW
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/archer

// For Duke Manor & Zizo Manor - Ground based spread, so no pirate in pool!
/mob/living/carbon/human/species/skeleton/npc/mediumspread
	threat_point = THREAT_MODERATE

/mob/living/carbon/human/species/skeleton/npc/mediumspread/Initialize()
	// Stopgap: archer outfit (was option 5) removed because the ranged NPC AI is unreliable.
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
	faction = list(FACTION_LICH)

// for Lich Dungeon
/mob/living/carbon/human/species/skeleton/npc/hardspread
	threat_point = THREAT_TOUGH

/mob/living/carbon/human/species/skeleton/npc/hardspread/Initialize()
	// Stopgap: archer outfit (was option 5) removed because the ranged NPC AI is unreliable.
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

// For Tomb of Matthios/Tomb of Alothesos Supreme Difficulty:TM: encounters.
/mob/living/carbon/human/species/skeleton/npc/special/vile_doctor
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/vile_doctor
	dodgetime = 15 //Moves a lot
	d_intent = INTENT_DODGE //Expert in this

/mob/living/carbon/human/species/skeleton/npc/special/disgraced_noble
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/disgraced_noble
	dodgetime = 15 //Moves a lot

/datum/outfit/job/roguetown/skeleton/npc/supereasy/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 10
	H.STASPD = 8
	H.STACON = 3
	H.STAWIL = 4
	H.STAINT = 1
	name = "Skeleton"
	if(prob(10))
		var/amulet_choice = rand(1, 3)
		switch(amulet_choice)
			if(1)
				id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy //ZIZO. ZIZO. ZIZO.
			if(2)
				id = /obj/item/clothing/neck/roguetown/psicross/aalloy
			if(3)
				id = /obj/item/clothing/neck/roguetown/psicross/noc/aalloy
	if(prob(50))
		shirt = /obj/item/clothing/suit/roguetown/shirt/rags
	else
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
	if(prob(10))
		cloak = /obj/item/clothing/cloak/raincloak/brown
	if(prob(50))
		pants = /obj/item/clothing/under/roguetown/tights/random
	else
		pants = /obj/item/clothing/under/roguetown/loincloth/brown
	if(prob(60))
		shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	var/weapon_choice = rand(1, 5)
	switch(weapon_choice)
		if(1)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/aaxe
		if(2)
			r_hand = /obj/item/rogueweapon/sword/short/ashort
		if(3)
			r_hand = /obj/item/rogueweapon/spear/aalloy
		if(4)
			r_hand = /obj/item/rogueweapon/mace/alloy
		if(5)
			r_hand = /obj/item/rogueweapon/mace/woodclub
	if(prob(40))
		var/hat_choice = rand(1, 4)
		switch(hat_choice)
			if(1)
				head = /obj/item/clothing/head/roguetown/cap
			if(2)
				head = /obj/item/clothing/head/roguetown/roguehood
			if(3)
				head = /obj/item/clothing/head/roguetown/fisherhat
			if(4)
				head = /obj/item/clothing/head/roguetown/knitcap
	H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/datum/outfit/job/roguetown/skeleton/npc/easy/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 9
	H.STASPD = 8
	H.STACON = 3
	H.STAWIL = 6
	H.STAINT = 1
	name = "Skeleton Footsoldier"
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/aalloy //Legionnaire look
	if(prob(50)) //50% chance of a decrepit helm w/coif
		head = /obj/item/clothing/head/roguetown/helmet/kettle/aalloy
		neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	if(prob(10))
		var/amulet_choice = rand(1, 3)
		switch(amulet_choice)
			if(1)
				id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy //ZIZO. ZIZO. ZIZO.
			if(2)
				id = /obj/item/clothing/neck/roguetown/psicross/aalloy
			if(3)
				id = /obj/item/clothing/neck/roguetown/psicross/noc/aalloy
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
	var/cloak_choice = rand(1, 3)
	switch(cloak_choice)
		if(1)
			cloak = /obj/item/clothing/cloak/tabard/toga/lich
		if(2)
			cloak = /obj/item/clothing/cloak/half/lich
		if(3)
			cloak = /obj/item/clothing/cloak/tabard/toga/lich/alt
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
	H.STACON = 3
	H.STAWIL = 6
	H.STAINT = 1
	name = "Skeleton Pirate"
	head =  /obj/item/clothing/head/roguetown/helmet/tricorn
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	shoes = /obj/item/clothing/shoes/roguetown/sandals/aalloy
	if(prob(10))
		var/amulet_choice = rand(1, 4)
		switch(amulet_choice)
			if(1)
				id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy //ZIZO. ZIZO. ZIZO.
			if(2)
				id = /obj/item/clothing/neck/roguetown/psicross/aalloy
			if(3)
				id = /obj/item/clothing/neck/roguetown/psicross/noc/aalloy
			if(4)
				id = /obj/item/clothing/neck/roguetown/psicross/abyssor
	if(prob(50))
		r_hand = /obj/item/rogueweapon/huntingknife/idagger/adagger
	else
		gloves = /obj/item/clothing/gloves/roguetown/knuckles/decrepit
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE) //YARR
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/datum/outfit/job/roguetown/skeleton/npc/medium/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 11
	H.STASPD = 8
	H.STACON = 5
	H.STAWIL = 8
	H.STAINT = 1
	name = "Skeleton Soldier"
	head = /obj/item/clothing/head/roguetown/helmet/heavy/aalloy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	belt = /obj/item/storage/belt/rogue/leather/rope
	if(prob(20)) //20% chance to have overpowered levels of aurafarming
		mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich
	if(prob(15))
		beltl = /obj/item/repair_kit/bad
	if(prob(10))
		var/amulet_choice = rand(1, 3)
		switch(amulet_choice)
			if(1)
				id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy //ZIZO. ZIZO. ZIZO.
			if(2)
				id = /obj/item/clothing/neck/roguetown/psicross/aalloy
			if(3)
				id = /obj/item/clothing/neck/roguetown/psicross/noc/aalloy
	var/weapon_choice = rand(1, 5)
	switch(weapon_choice) //Also covers shoes, for a bit of immersion
		if(1)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/aaxe
			if(prob(20)) // 20% chance of replacing this with a decently okay shield
				l_hand = /obj/item/rogueweapon/shield/tower/metal/alloy
			shoes = /obj/item/clothing/shoes/roguetown/sandals/aalloy //Legionnarie look
		if(2)
			r_hand = /obj/item/rogueweapon/sword/short/gladius/agladius // ave
			if(prob(45)) // 45% chance of shield, these ones are really weak and break easily
				l_hand = /obj/item/rogueweapon/shield/bronze/aalloy
			shoes = /obj/item/clothing/shoes/roguetown/sandals/aalloy //Legionnarie look
		if(3)
			r_hand = /obj/item/rogueweapon/flail/aflail
			if(prob(65)) // 65% chance of shield, these ones are really weak and break easily
				l_hand = /obj/item/rogueweapon/shield/bronze/aalloy
			shoes = /obj/item/clothing/shoes/roguetown/sandals/aalloy //Legionnarie look
		if(4)
			r_hand = /obj/item/rogueweapon/mace/warhammer/alloy //Nastier for MAA skele
			if(prob(40)) // 40% chance of replacing this with a decently okay shield
				l_hand = /obj/item/rogueweapon/shield/tower/metal/alloy
			shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy //Bulwark look
		if(5)
			r_hand = /obj/item/rogueweapon/halberd/bardiche/aalloy
			shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy //Bulwark look
	var/cloak_choice = rand(1, 3)
	switch(cloak_choice)
		if(1)
			cloak = /obj/item/clothing/cloak/tabard/toga/lich
		if(2)
			cloak = /obj/item/clothing/cloak/tabard/toga/lich/alt
		if(3)
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich // Ooo Spooky Old Dead MAA
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

/datum/outfit/job/roguetown/skeleton/npc/hard/pre_equip(mob/living/carbon/human/H)
	..()
	H.STACON = 6
	H.STAWIL = 10
	H.STAINT = 1
	name = "Skeleton Dreadnought"
	// This combines the khopesh  and withered dreadknight
	var/skeletonclass = rand(1, 2)
	if(skeletonclass == 1) // Khopesh Knight
		H.STASPD = 12 // Hue
		H.STASTR = 12
		ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC) //Parity slightly with deadlier dreadknight + swift on heavy armor no longer being cracked
		H.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE) //Needed at expert else we lose our duel blades by falling over in water cause heavy
		cloak = /obj/item/clothing/cloak/hierophant
		mask = /obj/item/clothing/mask/rogue/facemask/aalloy
		head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich
		wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
		pants = /obj/item/clothing/under/roguetown/platelegs/aalloy
		shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
		neck = /obj/item/clothing/neck/roguetown/gorget/aalloy
		belt = /obj/item/storage/belt/rogue/leather/black
		gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
		r_hand = /obj/item/rogueweapon/sword/sabre/alloy
		l_hand = /obj/item/rogueweapon/sword/sabre/alloy
		var/amulet_choice = rand(1, 2) //Cultist look so, no Psydon choice
		switch(amulet_choice)
			if(1)
				id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy //ZIZO. ZIZO. ZIZO.
			if(2)
				id = /obj/item/clothing/neck/roguetown/psicross/noc/aalloy
		if(prob(60))
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/aalloy
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
		else
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy/heavy
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	else // Withered Dreadknight
		H.STASPD = 8
		H.STASTR = 14 //Hits harder than other skeles
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE) //Tanky but falls over in water
		wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
		pants = /obj/item/clothing/under/roguetown/platelegs/aalloy
		shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
		neck = /obj/item/clothing/neck/roguetown/gorget/aalloy
		gloves = /obj/item/clothing/gloves/roguetown/plate/aalloy
		belt = /obj/item/storage/belt/rogue/leather
		if(prob(60))
			head = /obj/item/clothing/head/roguetown/helmet/heavy/guard/aalloy
		else
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/aalloy
		if(prob(60))
			armor = /obj/item/clothing/suit/roguetown/armor/plate/aalloy
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy
		else
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy/heavy
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
		if(prob(15))
			beltl = /obj/item/repair_kit/metal/bad
		var/weapon_choice = rand(1, 4)
		switch(weapon_choice)
			if(1)
				r_hand = /obj/item/rogueweapon/greatsword/aalloy
			if(2)
				r_hand = /obj/item/rogueweapon/mace/goden/aalloy
			if(3)
				r_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge/aalloy
			if(4)
				r_hand = /obj/item/rogueweapon/flail/aflail
				l_hand = /obj/item/rogueweapon/shield/bronze/great/aalloy //THE WALL, THE WALL, THE WALL
		var/cloak_choice = rand(1, 3)
		switch(cloak_choice)
			if(1)
				cloak = /obj/item/clothing/cloak/tabard/toga/lich
			if(2)
				cloak = /obj/item/clothing/cloak/tabard/toga/lich/alt
			if(3)
				cloak = /obj/item/clothing/cloak/tabard/blkknight // SOVL

	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)

/datum/outfit/job/roguetown/skeleton/npc/archer/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 8
	H.STASPD = 10
	H.STACON = 5
	H.STAWIL = 8
	H.STAPER = 13
	H.STAINT = 1
	name = "Skeleton Archer"
	head = /obj/item/clothing/head/roguetown/helmet/kettle/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backl = /obj/item/quiver/arrows
	r_hand = /obj/item/rogueweapon/mace/alloy
	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
	if(prob(10))
		var/amulet_choice = rand(1, 3)
		switch(amulet_choice)
			if(1)
				id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy //ZIZO. ZIZO. ZIZO.
			if(2)
				id = /obj/item/clothing/neck/roguetown/psicross/aalloy
			if(3)
				id = /obj/item/clothing/neck/roguetown/psicross/noc/aalloy
	var/cloak_choice = rand(1, 3)
	switch(cloak_choice)
		if(1)
			cloak = /obj/item/clothing/cloak/tabard/toga/lich
		if(2)
			cloak = /obj/item/clothing/cloak/half/lich
		if(3)
			cloak = /obj/item/clothing/cloak/tabard/toga/lich/alt
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

/datum/outfit/job/roguetown/skeleton/npc/vile_doctor/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 12
	H.STACON = 5 //Fragile to mages/sunders
	H.STAWIL = 10
	H.STASPD = 14 // that dagger WILL get thru ur parry.
	H.STAINT = 10 //Miniboss, lets them do fients + specials
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC) //Unique fighting style
	name = "Vile Doctor"
	belt = /obj/item/storage/belt/rogue/leather/black
	mask = /obj/item/clothing/mask/rogue/physician/plaguebearer //Tougher face armor only otherwise on wretches, also unique loot for defeating them
	head = /obj/item/clothing/head/roguetown/physician
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/physician
	pants = /obj/item/clothing/under/roguetown/trou/leather/courtphysician
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	neck = /obj/item/clothing/neck/roguetown/coif/padded
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)

/datum/outfit/job/roguetown/skeleton/npc/disgraced_noble/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 12 // stabs quick, stabs strong.
	H.STACON = 8
	H.STAWIL = 10
	H.STASPD = 12 //Lets them keep the pace a bit against dodgers.
	H.STAINT = 12 //Miniboss, lets them do fients + specials, better than doctor at fients/resisting them
	name = "Disgraced Ancient Noble"
	var/skeletonclass = rand(0,2) // lets shake it up a little :3
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	l_hand = /obj/item/rogueweapon/sword/rapier/dec
	pants = /obj/item/clothing/under/roguetown/platelegs/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy/heavy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	neck = /obj/item/clothing/neck/roguetown/coif/padded //Tougher
	head = /obj/item/clothing/head/roguetown/chaperon/noble/evil

	if(skeletonclass == 0) // "standard"
		id = /obj/item/clothing/ring/onyxa
		mask = /obj/item/clothing/mask/rogue/sack
		gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
		cloak = /obj/item/clothing/cloak/half/red
	if(skeletonclass == 1)
		id = /obj/item/clothing/ring/gold// slightly better
		r_hand = /obj/item/rogueweapon/shield/tower/metal/alloy // and a shield to go with it
		mask = /obj/item/clothing/mask/rogue/sack
		gloves = /obj/item/clothing/gloves/roguetown/plate/aalloy
		cloak = /obj/item/clothing/cloak/half/orange
	if(skeletonclass == 2)
		id = /obj/item/clothing/ring/coral // +30 value compared to onyx btw
		H.adjust_skillrank(H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)) // hardest, probably
		mask = /obj/item/clothing/mask/rogue/facemask // nose crits not as easy
		gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
		cloak = /obj/item/clothing/cloak/cape/purple
	
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

