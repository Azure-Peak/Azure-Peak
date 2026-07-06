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
	set_species(pick(NPC_RACES_TYPES))
	gender = pick(MALE, FEMALE)
	dna.species.random_character(src) //Now we just randomise here, MUST be called after both race + gender
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
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/northern/heretical_fiend_no_gear/zizo_cultist)
	patron = /datum/patron/inhumen/zizo
	random_voice_NPC()
	random_hair_NPC()
	random_eye_color_NPC()
	correct_features_NPC()
	update_hair()
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = HEAD_BOUNTY_HERETICAL_FIEND
	src.grant_language(/datum/language/undead) //So they can speak Zizocant if we give them lines

	var/voice_choice = rand(1, 12)
	switch(voice_choice)
		if(1)
			src.voice_color = "0bb1e4"
		if(2)
			src.voice_color = "d30c0c"
		if(3)
			src.voice_color = "4d4afc"
		if(4)
			src.voice_color = "da40c0"
		if(5)
			src.voice_color = "51e251"
		if(6)
			src.voice_color = "a059cf"
		if(7)
			src.voice_color = "8700c5"
		if(8)
			src.voice_color = "cfc886"
		if(9)
			src.voice_color = "ff9100"
		if(10)
			src.voice_color = "a0a0a0"
		if(11)
			src.voice_color = "797979"
		if(12)
			src.voice_color = "ff5e00"

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
