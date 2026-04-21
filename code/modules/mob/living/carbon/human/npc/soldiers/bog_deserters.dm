
//After the bogfort fell to undead, the remaining guard who didn't flea turned to bandirty. Wellarmed and trained.
//These guys use alot of iron stuff with small amounts of steel mixed in, not really one for finetuned balance might be too hard or easy idk. Going off vibes atm
/datum/outfit/job/roguetown/human/northern/bog_deserters/proc/add_random_deserter_cloak(mob/living/carbon/human/H)
	var/random_deserter_cloak = rand(1,4)
	switch(random_deserter_cloak)
		if(1)
			cloak = /obj/item/clothing/cloak/tabard/stabard/bog
		if(2)
			cloak = /obj/item/clothing/cloak/tabard/stabard/dungeon
		if(3)
			cloak = /obj/item/clothing/suit/roguetown/armor/longcoat/brown

/datum/outfit/job/roguetown/human/northern/bog_deserters/proc/add_random_deserter_weapon(mob/living/carbon/human/H)
	var/random_deserter_weapon = rand(1,3)
	switch(random_deserter_weapon)
		if(1)
			r_hand = /obj/item/rogueweapon/sword/iron
			l_hand = /obj/item/rogueweapon/shield/heater
		if(2)
			r_hand = /obj/item/rogueweapon/spear
		if(3)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut

/datum/outfit/job/roguetown/human/northern/bog_deserters/proc/add_random_deserter_weapon_hard(mob/living/carbon/human/H)
	var/add_random_deserter_weapon_hard = rand(1,4)
	switch(add_random_deserter_weapon_hard)
		if(1)
			r_hand = /obj/item/rogueweapon/sword/iron
			l_hand = /obj/item/rogueweapon/shield/heater
		if(2)
			r_hand = /obj/item/rogueweapon/mace/warhammer
			l_hand = /obj/item/rogueweapon/shield/heater
		if(3)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
		if(4)
			r_hand = /obj/item/rogueweapon/flail
			l_hand = /obj/item/rogueweapon/shield/heater

/datum/outfit/job/roguetown/human/northern/bog_deserters/proc/add_random_deserter_beltl_stuff(mob/living/carbon/human/H)
	var/add_random_deserter_beltl_stuff = rand(1,7)
	switch(add_random_deserter_beltl_stuff)
		if(1)
			beltl = /obj/item/storage/belt/rogue/pouch/food
		if(2)
			beltl = /obj/item/storage/belt/rogue/pouch/medicine
		if(3)
			beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
		if(4)
			beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
		if(5)
			beltl = /obj/item/reagent_containers/glass/bottle/waterskin
		if(6)
			beltl = /obj/item/reagent_containers/glass/bottle/alchemical/healthpot
		if(7)
			beltl = /obj/item/rogueweapon/scabbard/sheath

/datum/outfit/job/roguetown/human/northern/bog_deserters/proc/add_random_deserter_beltr_stuff(mob/living/carbon/human/H)
	var/add_random_deserter_beltr_stuff = rand(1,7)
	switch(add_random_deserter_beltr_stuff)
		if(1)
			beltr = /obj/item/storage/belt/rogue/pouch/food
		if(2)
			beltr = /obj/item/storage/belt/rogue/pouch/medicine
		if(3)
			beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
		if(4)
			beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
		if(5)
			beltr = /obj/item/reagent_containers/glass/bottle/waterskin
		if(6)
			beltr = /obj/item/reagent_containers/glass/bottle/alchemical/healthpot
		if(7)
			beltr = /obj/item/rogueweapon/scabbard/sword

/datum/outfit/job/roguetown/human/northern/bog_deserters/proc/add_random_deserter_armor_hard(mob/living/carbon/human/H)
	var/random_deserter_armor_hard = rand(1,3)
	switch(random_deserter_armor_hard)
		if(1)
			armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		if(2)
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron
		if(3)
			armor = /obj/item/clothing/suit/roguetown/armor/plate/scale

/mob/living/carbon/human/species/human/northern/bog_deserters
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_VIKING, FACTION_STATION)
	ambushable = FALSE
	cmode = 1
	setparrytime = 30
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)


/mob/living/carbon/human/species/human/northern/bog_deserters/ambush
	threat_point = THREAT_DANGEROUS
	ambush_faction = "bandits"



/mob/living/carbon/human/species/human/northern/bog_deserters/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)


/mob/living/carbon/human/species/human/northern/bog_deserters/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.highwayman_aggro, TRUE)
	job = "Garrison Deserter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/northern/bog_deserters)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_hair()
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 50 // Big sellprice for these guys since they're deserters
	AddComponent(/datum/component/npc_death_line, null, 25)


/datum/outfit/job/roguetown/human/northern/bog_deserters/pre_equip(mob/living/carbon/human/H)
	..()
	//Body Stuff
	H.eye_color = "27becc"
	H.hair_color = "61310f"
	H.facial_hair_color = H.hair_color
	if(H.gender == FEMALE)
		H.hairstyle =  "Messy (Rogue)"
	else
		H.hairstyle = "Messy"
		H.facial_hairstyle = "Beard (Manly)"
	//skill Stuff
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE) //NPCs do not get these skills unless a mind takes them over, hopefully in the future someone can fix
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	H.STASTR = rand(12,14)
	H.STASPD = 11
	H.STACON = 8
	H.STAWIL = 8
	H.STAPER = 11
	H.STAINT = 10
	//Chest Gear
	add_random_deserter_cloak(H)
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	//Head Gear
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	//wrist Gear
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	//Lower Gear
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	//Weapons
	if(prob(30)) // ranged
		belt = /obj/item/storage/belt/rogue/leather
		backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
		backl = /obj/item/quiver/arrows
		r_hand = /obj/item/rogueweapon/sword/iron
		H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
		H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
		H.STASTR -= 2
		H.STAPER += 3
	else if(prob(50)) // tossblade
		belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
		H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		add_random_deserter_weapon(H)
	else
		belt = /obj/item/storage/belt/rogue/leather
		add_random_deserter_weapon(H)
	add_random_deserter_beltl_stuff(H)
	add_random_deserter_beltr_stuff(H)

/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_VIKING, FACTION_STATION)
	ambushable = FALSE
	cmode = 1
	setparrytime = 30
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)

/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush
	threat_point = THREAT_DANGEROUS

/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/after_creation()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Garrison Deserter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/northern/bog_deserters/better_gear)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_hair()
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 50 // Big sellprice for these guys since they're deserters

/datum/outfit/job/roguetown/human/northern/bog_deserters/better_gear/pre_equip(mob/living/carbon/human/H)
	//Body Stuff
	H.eye_color = "27becc"
	H.hair_color = "61310f"
	H.facial_hair_color = H.hair_color
	if(H.gender == FEMALE)
		H.hairstyle =  "Messy (Rogue)"
	else
		H.hairstyle = "Messy"
		H.facial_hairstyle = "Beard (Manly)"
	//skill Stuff
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE) //NPCs do not get these skills unless a mind takes them over, hopefully in the future someone can fix
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	H.STASTR = rand(12,14)
	H.STASPD = 11
	H.STACON = 10
	H.STAWIL = 10
	H.STAPER = 11
	H.STAINT = 10
	//Chest Gear
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	add_random_deserter_armor_hard(H)
	add_random_deserter_cloak(H)
	//Head Gear
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle
	//wrist Gear
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	//Lower Gear
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	//Weapons
	if(prob(50)) // tossblade
		belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
		H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		add_random_deserter_weapon_hard(H)
	else
		belt = /obj/item/storage/belt/rogue/leather
		add_random_deserter_weapon_hard(H)
	add_random_deserter_beltl_stuff(H)
	add_random_deserter_beltr_stuff(H)

//Tosser variants - always spawn with tossblade belt and archer AI
/mob/living/carbon/human/species/human/northern/bog_deserters/tosser
	ai_controller = /datum/ai_controller/human_npc/archer

/mob/living/carbon/human/species/human/northern/bog_deserters/tosser/ambush
	threat_point = THREAT_DANGEROUS
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/bog_deserters/tosser/after_creation()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.highwayman_aggro, TRUE)
	job = "Garrison Deserter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/northern/bog_deserters/tosser)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_hair()
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 50

/datum/outfit/job/roguetown/human/northern/bog_deserters/tosser/pre_equip(mob/living/carbon/human/H)
	//Body Stuff
	H.eye_color = "27becc"
	H.hair_color = "61310f"
	H.facial_hair_color = H.hair_color
	if(H.gender == FEMALE)
		H.hairstyle =  "Messy (Rogue)"
	else
		H.hairstyle = "Messy"
		H.facial_hairstyle = "Beard (Manly)"
	//skill Stuff
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	H.STASTR = rand(12,14)
	H.STASPD = 11
	H.STACON = 8
	H.STAWIL = 8
	H.STAPER = 11
	H.STAINT = 10
	//Chest Gear
	add_random_deserter_cloak(H)
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	//Head Gear
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	//wrist Gear
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	//Lower Gear
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	//Weapons - guaranteed tossblade + melee
	H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
	add_random_deserter_weapon(H)
	add_random_deserter_beltl_stuff(H)
	add_random_deserter_beltr_stuff(H)

/mob/living/carbon/human/species/human/northern/bog_deserters/tosser/better_gear
	ai_controller = /datum/ai_controller/human_npc/archer

/mob/living/carbon/human/species/human/northern/bog_deserters/tosser/better_gear/ambush
	threat_point = THREAT_DANGEROUS

/mob/living/carbon/human/species/human/northern/bog_deserters/tosser/better_gear/after_creation()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Garrison Deserter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/northern/bog_deserters/tosser/better_gear)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_hair()
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 50

/datum/outfit/job/roguetown/human/northern/bog_deserters/tosser/better_gear/pre_equip(mob/living/carbon/human/H)
	//Body Stuff
	H.eye_color = "27becc"
	H.hair_color = "61310f"
	H.facial_hair_color = H.hair_color
	if(H.gender == FEMALE)
		H.hairstyle =  "Messy (Rogue)"
	else
		H.hairstyle = "Messy"
		H.facial_hairstyle = "Beard (Manly)"
	//skill Stuff
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	H.STASTR = rand(12,14)
	H.STASPD = 11
	H.STACON = 10
	H.STAWIL = 10
	H.STAPER = 11
	H.STAINT = 10
	//Chest Gear
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	add_random_deserter_armor_hard(H)
	add_random_deserter_cloak(H)
	//Head Gear
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle
	//wrist Gear
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	//Lower Gear
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	//Weapons - guaranteed tossblade + melee
	H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
	add_random_deserter_weapon_hard(H)
	add_random_deserter_beltl_stuff(H)
	add_random_deserter_beltr_stuff(H)

