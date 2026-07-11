/mob/living/carbon/human/species/human/northern/thief //I'm a thief, give me your shit
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_THIEVES)
	ambushable = FALSE
	dodgetime = 30
	a_intent = INTENT_HELP
	m_intent = MOVE_INTENT_SNEAK
	d_intent = INTENT_DODGE



/mob/living/carbon/human/species/human/northern/thief/Initialize()
	. = ..()
	//Begin RANDOMISE here
	set_species(pick(NPC_RACES_TYPES))
	gender = pick(MALE, FEMALE)
	dna.species.random_character(src) //Now we just randomise here, MUST be called after both race + gender
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/thief/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Thief"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/thief)
	//Begin RANDOMISE here
	dna.species.handle_body(src)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	random_voice_NPC()
	random_hair_no_beard_NPC()
	random_eye_color_NPC()
	correct_features_NPC()

	if(gender == FEMALE)
		real_name = pick(world.file2list("strings/names/first_female.txt"))
	else
		real_name = pick(world.file2list("strings/names/first_male.txt"))
	update_hair()
	update_body()
	src.regenerate_icons() //Fixes the weird body but lets check performance first
	head.sellprice = HEAD_BOUNTY_THIEF


/datum/outfit/job/roguetown/human/species/human/northern/thief/pre_equip(mob/living/carbon/human/H)
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	if(prob(50))
		wrists = /obj/item/clothing/wrists/roguetown/bracers/copper
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper
	if(prob(50))
		armor = /obj/item/clothing/suit/roguetown/armor/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/trou/leather
	head = /obj/item/clothing/head/roguetown/helmet/leather
	mask = /obj/item/clothing/mask/rogue/skullmask
	neck = /obj/item/clothing/neck/roguetown/gorget/copper
	if(prob(50))
		neck = /obj/item/clothing/neck/roguetown/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	l_hand = /obj/item/rogueweapon/huntingknife/idagger
	if(prob(50))
		l_hand = /obj/item/rogueweapon/huntingknife/copper
	H.STASTR = 11
	H.STASPD = 12
	H.STACON = 5
	H.STAWIL = 5
	H.STAPER = 11
	H.STAINT = 1
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	if(prob(30))
		var/voicepack_choice = rand(1, 4)
		switch(voicepack_choice)
			if(1)
				H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior]
				H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]
			if(2)
				H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/stern]
				H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/haughty]
			if(3)
				H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/foppish]
				H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/dainty]
			if(4)
				H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/knight]
				H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/dainty]
