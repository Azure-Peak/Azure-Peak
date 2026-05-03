/mob/living/carbon/human/species/human/northern/heretical_fiend_no_gear
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_HERETICAL_FIEND, FACTION_DUNDEAD)
	ambushable = FALSE
	cmode = 1
	setparrytime = 30
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)



/mob/living/carbon/human/species/human/northern/heretical_fiend_no_gear/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)


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
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_HERETICAL_FIEND, FACTION_DUNDEAD)
	ambushable = FALSE
	cmode = 1
	dodgetime = 30
	a_intent = INTENT_HELP
	d_intent = INTENT_DODGE
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)

/mob/living/carbon/human/species/human/northern/heretical_fiend_no_gear/zizo_cultist/ambush

/mob/living/carbon/human/species/human/northern/heretical_fiend_no_gear/zizo_cultist/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
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
	ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
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
	H.STACON = 5
	H.STAWIL = 6
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
