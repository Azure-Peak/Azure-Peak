/mob/living/carbon/human/species/human/northern/border_reiver/
	aggressive=1
	rude = TRUE
	mode = NPC_AI_IDLE
	faction = list("reiver")
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

/mob/living/carbon/human/species/human/northern/border_reiver/retaliate(mob/living/L)
	var/newtarg = target
	.=..()
	if(target)
		aggressive=1
		wander = TRUE
		if(!is_silent && target != newtarg)
			say(pick(GLOB.highwayman_aggro))
			pointed(target)

/mob/living/carbon/human/species/human/northern/border_reiver/should_target(mob/living/L)
	if(L.stat != CONSCIOUS)
		return FALSE
	. = ..()

/mob/living/carbon/human/species/human/northern/border_reiver/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE

/mob/living/carbon/human/species/human/northern/border_reiver/npc_idle()
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

/mob/living/carbon/human/species/human/northern/border_reiver/handle_combat()
	if(mode == NPC_AI_HUNT)
		if(prob(2)) // do not make this big or else they NEVER SHUT UP
			emote("laugh")
	. = ..()

//Border Reivers from a nearby state the. To "Reive" is to raid, These guys should be fast, look kind of poor but not be badly equipped.
//Solely an event mod atm expect alittle imbalance, readjust if added in actual gameplay

/datum/outfit/job/roguetown/human/northern/border_reiver/midgear/proc/add_random_reiver_helmet(mob/living/carbon/human/H)
	var/random_reiver_helmet = rand(1,3)
	switch(random_reiver_helmet)
		if(1)
			head = /obj/item/clothing/head/roguetown/helmet
		if(2)
			head = /obj/item/clothing/head/roguetown/helmet/skullcap
		if(3)
			head = /obj/item/clothing/head/roguetown/helmet/sallet

/datum/outfit/job/roguetown/human/northern/border_reiver/midgear/proc/add_random_reiver_weapons(mob/living/carbon/human/H)
	var/random_reiver_weapons = rand(1,5)
	switch(random_reiver_weapons)
		if(1)
			r_hand = /obj/item/rogueweapon/spear/short
			l_hand = /obj/item/rogueweapon/shield/wood
		if(2)
			r_hand = /obj/item/rogueweapon/sword/short
			l_hand = /obj/item/rogueweapon/shield/buckler
		if(3)
			r_hand = /obj/item/rogueweapon/spear/short
		if(4)
			r_hand = /obj/item/rogueweapon/sword/short
		if(5)
			r_hand = /obj/item/rogueweapon/sword/short
			l_hand = /obj/item/flashlight/flare/torch/prelit

/obj/item/clothing/cloak/thief_cloak/mageblue

/datum/outfit/job/roguetown/human/northern/border_reiver/proc/add_random_reiver_belt(mob/living/carbon/human/H)
	var/random_reiver_belt = rand(1,4)
	switch(random_reiver_belt)
		if(1)
			belt = /obj/item/storage/belt/rogue/leather
		if(2)
			belt = /obj/item/storage/belt/rogue/leather/knifebelt/black
		if(3)
			belt = /obj/item/storage/belt/rogue/leather/black
		if(4)
			belt = /obj/item/storage/belt/rogue/leather/rope

/datum/outfit/job/roguetown/human/northern/border_reiver/proc/add_random_reiver_cloak(mob/living/carbon/human/H)
	var/random_reiver_cloak = rand(1,3)
	switch(random_reiver_cloak)
		if(1)
			cloak = /obj/item/clothing/cloak/raincloak/mageblue
		if(2)
			cloak = /obj/item/clothing/cloak/thief_cloak/mageblue
		if(3)
			cloak = /obj/item/clothing/cloak/cotehardie/mageblue

/datum/outfit/job/roguetown/human/northern/border_reiver/proc/add_random_reiver_beltl_stuff(mob/living/carbon/human/H)
	var/add_random_reiver_beltl_stuff = rand(1,7)
	switch(add_random_reiver_beltl_stuff)
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
			beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel

/datum/outfit/job/roguetown/human/northern/border_reiver/proc/add_random_reiver_beltr_stuff(mob/living/carbon/human/H)
	var/add_random_reiver_beltr_stuff = rand(1,7)
	switch(add_random_reiver_beltr_stuff)
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
			beltr = /obj/item/rogueweapon/stoneaxe/handaxe

/datum/outfit/job/roguetown/human/northern/border_reiver/midgear/proc/add_random_reiver_armor(mob/living/carbon/human/H)
	var/add_random_reiver_armor = rand(1,4)
	switch(add_random_reiver_armor)
		if(1)
			armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		if(2)
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if(3)
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass
		if(4)
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted

/mob/living/carbon/human/species/human/northern/border_reiver/midgear
	aggressive=1
	rude = TRUE
	mode = NPC_AI_IDLE
	faction = list("reiver")
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
	npc_max_jump_stamina = 0

/mob/living/carbon/human/species/human/northern/border_reiver/midgear/ambush
	aggressive=1
	wander = TRUE

/mob/living/carbon/human/species/human/northern/border_reiver/midgear/after_creation()
	..()
	job = "Border Reiver"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/northern/border_reiver/midgear)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_hair()
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 15 // Not much

/datum/outfit/job/roguetown/human/northern/border_reiver/midgear/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	H.STASTR = rand(12,14)
	H.STASPD = rand(12,14)
	H.STACON = rand(11,12)
	H.STAWIL = rand(11,12)
	H.STAPER = rand(10,11)
	H.STAINT = rand(9,10)
	//Chest Gear
	add_random_reiver_cloak(H)
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord/heavy
	add_random_reiver_armor(H)
	//Head Gear
	neck = /obj/item/clothing/neck/roguetown/leather
	mask = /obj/item/clothing/head/roguetown/armingcap/padded
	add_random_reiver_helmet(H)
	//wrist Gear
	gloves = /obj/item/clothing/gloves/roguetown/angle
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	//Lower Gear
	add_random_reiver_belt(H)
	add_random_reiver_beltl_stuff(H)
	add_random_reiver_beltr_stuff(H)
	pants = /obj/item/clothing/under/roguetown/brigandinelegs
	shoes = /obj/item/clothing/shoes/roguetown/ridingboots
	//Weapons
	add_random_reiver_weapons(H)

//LOWTIER

/datum/outfit/job/roguetown/human/northern/border_reiver/lowgear/proc/add_random_reiver_lowgearhelmet(mob/living/carbon/human/H)
	var/random_reiver_lowgearhelmet = rand(1,4)
	switch(random_reiver_lowgearhelmet)
		if(1)
			head = /obj/item/clothing/head/roguetown/helmet
		if(2)
			head = /obj/item/clothing/head/roguetown/knitcap
		if(3)
			head = /obj/item/clothing/head/roguetown/brimmed
		if(4)
			head =/obj/item/clothing/head/roguetown/roguehood/mageblue

/datum/outfit/job/roguetown/human/northern/border_reiver/proc/add_random_reiver_lowgear_weapons(mob/living/carbon/human/H)
	var/random_reiver_lowgear_weapons = rand(1,6)
	switch(random_reiver_lowgear_weapons)
		if(1)
			r_hand = /obj/item/rogueweapon/pick/militia
		if(2)
			r_hand = /obj/item/rogueweapon/greataxe/militia
		if(3)
			r_hand = /obj/item/rogueweapon/woodstaff/militia
		if(4)
			r_hand = /obj/item/rogueweapon/flail/militia
		if(5)
			r_hand = /obj/item/rogueweapon/sword/short
			l_hand = /obj/item/flashlight/flare/torch/prelit
		if(6)
			r_hand = /obj/item/rogueweapon/spear/short

/mob/living/carbon/human/species/human/northern/border_reiver/lowgear
	aggressive=1
	rude = TRUE
	mode = NPC_AI_IDLE
	faction = list("reiver")
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

/mob/living/carbon/human/species/human/northern/border_reiver/lowgear/ambush
	aggressive=1
	wander = TRUE

/mob/living/carbon/human/species/human/northern/border_reiver/lowgear/after_creation()
	..()
	job = "Border Reiver"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/northern/border_reiver/lowgear)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_hair()
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 15 // Not much

/datum/outfit/job/roguetown/human/northern/border_reiver/lowgear/pre_equip(mob/living/carbon/human/H)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/staves, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	H.STASTR = rand(12,13)
	H.STASPD = rand(12,13)
	H.STACON = rand(10,11)
	H.STAWIL = rand(10,11)
	H.STAPER = rand(9,10)
	H.STAINT = rand(8,9)
	//Chest Gear
	add_random_reiver_cloak(H)
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	//Head Gear
	neck = /obj/item/clothing/neck/roguetown/leather
	add_random_reiver_lowgearhelmet(H)
	//wrist Gear
	//Lower Gear
	add_random_reiver_belt(H)
	add_random_reiver_beltl_stuff(H)
	add_random_reiver_beltr_stuff(H)
	pants = /obj/item/clothing/under/roguetown/tights
	shoes = /obj/item/clothing/shoes/roguetown/boots
	//Weapons
	add_random_reiver_lowgear_weapons(H)

//HIGHGEAR

/datum/outfit/job/roguetown/human/northern/border_reiver/highgear/proc/add_random_reiver_weaponshighgear(mob/living/carbon/human/H)
	var/random_reiver_weaponshighgear = rand(1,5)
	switch(random_reiver_weaponshighgear)
		if(1)
			r_hand = /obj/item/rogueweapon/spear/short
			l_hand = /obj/item/rogueweapon/shield/iron
		if(2)
			r_hand = /obj/item/rogueweapon/sword/rapier
			l_hand = /obj/item/rogueweapon/shield/buckler
		if(3)
			r_hand = /obj/item/rogueweapon/spear/short
		if(4)
			r_hand = /obj/item/rogueweapon/sword/sabre
		if(5)
			r_hand = /obj/item/rogueweapon/sword/sabre
			l_hand = /obj/item/flashlight/flare/torch/prelit

/mob/living/carbon/human/species/human/northern/border_reiver/highgear
	aggressive=1
	rude = TRUE
	mode = NPC_AI_IDLE
	faction = list("reiver")
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
	npc_max_jump_stamina = 0

/mob/living/carbon/human/species/human/northern/border_reiver/highgear/ambush
	aggressive=1
	wander = TRUE

/mob/living/carbon/human/species/human/northern/border_reiver/highgear/after_creation()
	..()
	job = "Border Reiver"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/northern/border_reiver/highgear)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_hair()
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 15 // Not much

/datum/outfit/job/roguetown/human/northern/border_reiver/highgear/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	H.STASTR = rand(13,14)
	H.STASPD = rand(13,14)
	H.STACON = rand(12,13)
	H.STAWIL = rand(12,13)
	H.STAPER = rand(11,12)
	H.STAINT = rand(10,11)
	//Chest Gear
	add_random_reiver_cloak(H)
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy
	//Head Gear
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	mask = /obj/item/clothing/head/roguetown/armingcap/padded
	head = /obj/item/clothing/head/roguetown/helmet
	//wrist Gear
	gloves = /obj/item/clothing/gloves/roguetown/angle
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	//Lower Gear
	add_random_reiver_belt(H)
	add_random_reiver_beltl_stuff(H)
	add_random_reiver_beltr_stuff(H)
	pants = /obj/item/clothing/under/roguetown/brigandinelegs
	shoes = /obj/item/clothing/shoes/roguetown/ridingboots
	//Weapons
	add_random_reiver_weaponshighgear(H)


//Simple Mobs

/mob/living/simple_animal/hostile/rogue/border_reiver_crossbow
	name = "Reiver Crossbowman"
	icon = 'icons/mob/border_reivers.dmi'
	faction = list("reiver")
	icon_state = "reiver_crossbow"
	icon_living = "reiver_crossbow"
	icon_dead = "reiver_crossbow_dead"
	projectiletype = /obj/projectile/bullet/reusable/bolt
	projectilesound = 'sound/combat/Ranged/crossbow-small-shot-01.ogg'
	ranged = 1
	retreat_distance = 2
	minimum_distance = 5
	ranged_cooldown_time = 150
	check_friendly_fire = 1
	health = 200
	maxHealth = 200
	ai_controller = /datum/ai_controller/reiver_crossbow
	gender = MALE
	mob_biotypes = MOB_HUMANOID 
	robust_searching = 1
	turns_per_move = 1
	move_to_delay = 3
	STACON = 13
	STASTR = 14
	STASPD = 14
	vision_range = 7
	aggro_vision_range = 9
	limb_destroyer = 0
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	attack_sound = 'sound/blank.ogg'
	canparry = TRUE
	d_intent = INTENT_PARRY
	defprob = 50
	speak_emote = list("grunts")
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = FALSE

/mob/living/simple_animal/hostile/rogue/border_reiver_lance_rider
	name = "Reiver Rider"
	faction = list("reiver")
	icon = 'icons/roguetown/mob/monster/reiver_rider.dmi'
	base_intents = list(/datum/intent/simple/spear/reiver_rider_lancer,)
	icon_state = "lance_rider"
	icon_living = "lance_rider"
	icon_dead = "lance_rider_dead"
	attack_sound = 'sound/foley/pierce.ogg'
	ai_controller = /datum/ai_controller/reiver_rider/lance
	health = 650
	maxHealth = 650
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	robust_searching = 1
	turns_per_move = 5
	move_to_delay = 13
	STACON = 15
	STASTR = 12
	STASPD = 18
	melee_damage_lower = 60
	melee_damage_upper = 90
	vision_range = 7
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	limb_destroyer = 0
	canparry = TRUE
	d_intent = INTENT_PARRY
	defprob = 60
	speak_emote = list("grunts")
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = FALSE
	pixel_x = -16

/mob/living/simple_animal/hostile/rogue/border_reiver_lance_rider/sabre
	ai_controller = /datum/ai_controller/reiver_rider
	base_intents = list(/datum/intent/simple/reiver_rider_sabre,)
	icon_state = "sabre_rider"
	icon_living = "sabre_rider"
	icon_dead = "sabre_rider_dead"
	melee_damage_lower = 30
	melee_damage_upper = 45
	attack_sound = 'sound/combat/hits/bladed/genslash (1).ogg'

/datum/intent/simple/spear/reiver_rider_lancer
	reach = 2
	clickcd = REIVER_LANCE_ATTACK_SPEED
	chargetime = 1
	animname = "stab"
	penfactor = 25

/datum/intent/simple/reiver_rider_sabre
	name = "hack"
	icon_state = "instrike"
	attack_verb = list("hacks at", "chops at", "bashes")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = list("genchop", "genslash")
	chargetime = 0
	penfactor = 0
	swingdelay = 2
	candodge = TRUE
	canparry = TRUE
	item_d_type = "slash"
	clickcd = REIVER_SABRE_ATTACK_SPEED
