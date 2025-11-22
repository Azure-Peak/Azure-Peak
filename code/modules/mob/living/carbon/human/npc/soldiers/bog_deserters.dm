
//After the bogfort fell to undead, the remaining guard who didn't flea turned to bandirty. Wellarmed and trained.
//These guys use alot of iron stuff with small amounts of steel mixed in, not really one for finetuned balance might be too hard or easy idk. Going off vibes atm
/datum/outfit/job/roguetown/human/northern/bog_deserters/proc/add_random_deserter_cloak(mob/living/carbon/human/H)
	var/random_deserter_cloak = rand(1,4)
	switch(random_deserter_cloak)
		if(1)
			cloak = /obj/item/clothing/cloak/stabard/bog
		if(2)
			cloak = /obj/item/clothing/cloak/stabard/dungeon
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
	aggressive=1
	rude = TRUE
	mode = NPC_AI_IDLE
	faction = list("viking", "station")
	ambushable = FALSE
	cmode = 1
	setparrytime = 30
	flee_in_pain = TRUE
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)
	possible_rmb_intents = list(
		/datum/rmb_intent/feint,\
		/datum/rmb_intent/aimed,\
		/datum/rmb_intent/strong,\
		/datum/rmb_intent/riposte,\
		/datum/rmb_intent/weak
	)
	var/is_silent = FALSE /// Determines whether or not we will scream our funny lines at people.
	npc_max_jump_stamina = 0


/mob/living/carbon/human/species/human/northern/bog_deserters/ambush
	aggressive=1
	wander = TRUE

/mob/living/carbon/human/species/human/northern/bog_deserters/retaliate(mob/living/L)
	var/newtarg = target
	.=..()
	if(target)
		aggressive=1
		wander = TRUE
		if(!is_silent && target != newtarg)
			say(pick(GLOB.highwayman_aggro))
			pointed(target)

/mob/living/carbon/human/species/human/northern/bog_deserters/should_target(mob/living/L)
	if(L.stat != CONSCIOUS)
		return FALSE
	. = ..()

/mob/living/carbon/human/species/human/northern/bog_deserters/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE


/mob/living/carbon/human/species/human/northern/bog_deserters/after_creation()
	..()
	job = "Garrison Deserter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC) //For when they're just kinda patrolling around/ambushes
	equipOutfit(new /datum/outfit/job/roguetown/human/northern/bog_deserters)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_hair()
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 50 // Big sellprice for these guys since they're deserters

/mob/living/carbon/human/species/human/northern/bog_deserters/npc_idle()
	if(m_intent == MOVE_INTENT_SNEAK)
		return
	if(world.time < next_idle)
		return
	next_idle = world.time + rand(30, 70)
	if((mobility_flags & MOBILITY_MOVE) && isturf(loc) && wander)
		if(prob(20))
			var/turf/T = get_step(loc,pick(GLOB.cardinals))
			if(!istype(T, /turf/open/transparent/openspace))
				Move(T)
		else
			face_atom(get_step(src,pick(GLOB.cardinals)))
	if(!wander && prob(10))
		face_atom(get_step(src,pick(GLOB.cardinals)))

/mob/living/carbon/human/species/human/northern/bog_deserters/handle_combat()
	if(mode == NPC_AI_HUNT)
		if(prob(2)) // do not make this big or else they NEVER SHUT UP
			emote("laugh")
	. = ..()

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
	H.STACON = rand(11,13)
	H.STAWIL = 13
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
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	//Weapons
	add_random_deserter_weapon(H)
	add_random_deserter_beltl_stuff(H)
	add_random_deserter_beltr_stuff(H)

/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear
	aggressive=1
	rude = TRUE
	mode = NPC_AI_IDLE
	faction = list("viking", "station")
	ambushable = FALSE
	cmode = 1
	setparrytime = 30
	flee_in_pain = TRUE
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)
	possible_rmb_intents = list(
		/datum/rmb_intent/feint,\
		/datum/rmb_intent/aimed,\
		/datum/rmb_intent/strong,\
		/datum/rmb_intent/riposte,\
		/datum/rmb_intent/weak
	)

/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush
	aggressive=1
	wander = TRUE

/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/after_creation()
	job = "Garrison Deserter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC) //For when they're just kinda patrolling around/ambushes
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
	H.STACON = rand(11,13)
	H.STAWIL = 13
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
	add_random_deserter_weapon_hard(H)
	add_random_deserter_beltl_stuff(H)
	add_random_deserter_beltr_stuff(H)
