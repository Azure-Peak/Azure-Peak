/mob/living/carbon/human/species/human/northern/heretical_fiend_no_gear
	aggressive=1
	rude = TRUE
	mode = NPC_AI_IDLE
	faction = list("Heretical_Fiend", "dundead")
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

/mob/living/carbon/human/species/human/northern/heretical_fiend_no_gear/retaliate(mob/living/L)
	var/newtarg = target
	.=..()
	if(target)
		aggressive=1
		wander = TRUE
		if(!is_silent && target != newtarg)
			say(pick(GLOB.highwayman_aggro))
			pointed(target)

/mob/living/carbon/human/species/human/northern/heretical_fiend_no_gear/should_target(mob/living/L)
	if(L.stat != CONSCIOUS)
		return FALSE
	. = ..()

/mob/living/carbon/human/species/human/northern/heretical_fiend_no_gear/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE

/mob/living/carbon/human/species/human/northern/heretical_fiend_no_gear/npc_idle()
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

/mob/living/carbon/human/species/human/northern/heretical_fiend_no_gear/handle_combat()
	if(mode == NPC_AI_HUNT)
		if(prob(2)) // do not make this big or else they NEVER SHUT UP
			emote("laugh")
	. = ..()

//Stuff Starts Here

/datum/outfit/job/roguetown/human/northern/heretical_fiend_no_gear/proc/add_random_fiend_beltl_stuff(mob/living/carbon/human/H)
	var/add_random_fiend_beltl_stuff = rand(1,6)
	switch(add_random_fiend_beltl_stuff)
		if(1)
			beltl = /obj/item/storage/belt/rogue/pouch/food
		if(2)
			beltl = /obj/item/storage/belt/rogue/pouch/medicine
		if(3)
			beltl = /obj/item/storage/belt/rogue/pouch/alchemy
		if(4)
			beltl = /obj/item/clothing/neck/roguetown/psicross/inhumen/g
		if(5)
			beltl = /obj/item/book/rogue/arcyne
		if(6)
			beltl = /obj/item/reagent_containers/glass/bottle/alchemical/healthpot

/datum/outfit/job/roguetown/human/northern/heretical_fiend_no_gear/proc/add_random_fiend_beltr_stuff(mob/living/carbon/human/H)
	var/add_random_fiend_beltr_stuff = rand(1,6)
	switch(add_random_fiend_beltr_stuff)
		if(1)
			beltr = /obj/item/storage/belt/rogue/pouch/food
		if(2)
			beltr = /obj/item/storage/belt/rogue/pouch/medicine
		if(3)
			beltr = /obj/item/storage/belt/rogue/pouch/alchemy
		if(4)
			beltr = /obj/item/clothing/neck/roguetown/psicross/inhumen/g
		if(5)
			beltr = /obj/item/book/rogue/knowledge1
		if(6)
			beltr = /obj/item/reagent_containers/glass/bottle/alchemical/healthpot

/mob/living/carbon/human/species/human/northern/heretical_fiend_no_gear/zizo_cultist
	aggressive=1
	rude = TRUE
	mode = NPC_AI_IDLE
	faction = list("Heretical Fiend", "dundead")
	ambushable = FALSE
	cmode = 1
	dodgetime = 30
	flee_in_pain = FALSE
	a_intent = INTENT_HELP
	d_intent = INTENT_DODGE
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)
	possible_rmb_intents = list(
		/datum/rmb_intent/feint,\
		/datum/rmb_intent/aimed,\
		/datum/rmb_intent/strong,\
		/datum/rmb_intent/riposte,\
		/datum/rmb_intent/weak
	)
	npc_max_jump_stamina = 0

/mob/living/carbon/human/species/human/northern/heretical_fiend_no_gear/zizo_cultist/ambush
	aggressive=1
	wander = TRUE

/mob/living/carbon/human/species/human/northern/heretical_fiend_no_gear/zizo_cultist/after_creation()
	..()
	job = "Zizo Cultist"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/northern/heretical_fiend_no_gear/zizo_cultist)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	patron = /datum/patron/inhumen/zizo
	update_hair()
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 15 // Not much

/datum/outfit/job/roguetown/human/northern/heretical_fiend_no_gear/zizo_cultist/pre_equip(mob/living/carbon/human/H) //Intended to be super easy to kill
	..()
	ADD_TRAIT(H, TRAIT_ZIZOSIGHT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CABAL, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/staves, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 5, TRUE)
	H.STASTR = 10
	H.STAPER = 10
	H.STAINT = 14
	H.STACON = 10
	H.STAWIL = 12
	H.STASPD = 11
	H.STALUC = 10
	//Chest Gear
	cloak = /obj/item/clothing/suit/roguetown/shirt/robe/tabardwhite/evil_ah_ah
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/scarlet
//	armor =
	//Head Gear
	head = /obj/item/clothing/head/roguetown/roguehood/shroudwhite/evil_ah_ah
	mask = /obj/item/clothing/mask/rogue/facemask/steel/paalloy
	neck = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy
	//wrist Gear
	wrists = /obj/item/clothing/wrists/roguetown/allwrappings/scarlet
	gloves = /obj/item/clothing/gloves/roguetown/leather
	//Lower Gear
	pants = /obj/item/clothing/under/roguetown/tights
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	//beltslots
	belt = /obj/item/storage/belt/rogue/leather/rope
	add_random_fiend_beltr_stuff(H)
	add_random_fiend_beltl_stuff(H)
	//Weapons
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
//	l_hand = 
