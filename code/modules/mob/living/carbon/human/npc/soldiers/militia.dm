//GLOBAL_LIST_INIT(militia_aggro, world.file2list("strings/rt/militiaaggrolines.txt")) //this doesn't exit but feel free to make it

/mob/living/carbon/human/species/human/northern/militia //weak peasant infantry. Neutral but can be given factions for events. doesn't attack players.
	ai_controller = /datum/ai_controller/human_npc
	d_intent = INTENT_PARRY
	faction = list(FACTION_NEUTRAL)
	ambushable = FALSE
	dodgetime = 28



/mob/living/carbon/human/species/human/northern/militia/Initialize()
	. = ..()
	set_species(pick(NPC_RACES_TYPES))
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)


/mob/living/carbon/human/species/human/northern/militia/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.highwayman_aggro, TRUE)
	job = "Militia"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/militia)
	AddComponent(/datum/component/npc_death_line, null, 25)
	dna.species.handle_body(src)
	//Random voices, this can probably be more random-ish but it'll do for now
	random_voice_NPC()
	random_hair_NPC()
	random_eye_color_NPC()
	correct_features_NPC()

	if(gender == FEMALE)
		real_name = pick(world.file2list("strings/names/first_female.txt"))
	else
		real_name = pick(world.file2list("strings/names/first_male.txt"))
	update_hair()
	update_body()
	src.regenerate_icons() //Fixes the weird body


/datum/outfit/job/roguetown/human/species/human/northern/militia/pre_equip(mob/living/carbon/human/H)
	cloak = /obj/item/clothing/cloak/tabard/stabard/guard
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	if(prob(25))
		armor = /obj/item/clothing/suit/roguetown/armor/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	if(prob(50))
		pants = /obj/item/clothing/under/roguetown/trou
	belt = /obj/item/storage/belt/rogue/leather
	if(prob(10))
		belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	// Helmet, or lackthereof
	switch(rand(1, 7))
		if(1 to 2)
			head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
		if(3)
			head = /obj/item/clothing/head/roguetown/helmet/sallet/iron
		if(4 to 5)
			head = /obj/item/clothing/head/roguetown/helmet/skullcap
		if(6)
			head = /obj/item/clothing/head/roguetown/armingcap
		if(7)
			head = null
	neck = /obj/item/clothing/neck/roguetown/leather
	if(prob(50))
		neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	if(prob(35))
		gloves = /obj/item/clothing/gloves/roguetown/angle
	H.STASTR = rand(10,11) //GENDER EQUALITY!!
	H.STASPD = 10
	H.STACON = 6
	H.STAWIL = 6
	H.STAPER = 10
	H.STAINT = 9 //Smarter, slightly
	switch(rand(1, 12))
		// Militia Weapon. Of course they spawn with it
		if(1)
			r_hand = /obj/item/rogueweapon/woodstaff/militia
		if(2)
			r_hand = /obj/item/rogueweapon/greataxe/militia
		if(3)
			r_hand = /obj/item/rogueweapon/spear/militia
		if(4)
			r_hand = /obj/item/rogueweapon/spear
			l_hand = /obj/item/rogueweapon/shield/wood
		if(5)
			r_hand = /obj/item/rogueweapon/scythe
		if(6)
			r_hand = /obj/item/rogueweapon/pick/militia
		if(7)
			r_hand = /obj/item/rogueweapon/sword/falchion/militia
		if(8)
			r_hand = /obj/item/rogueweapon/mace/cudgel
		if(9)
			r_hand = /obj/item/rogueweapon/mace/goden
		if(10)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
			l_hand = /obj/item/rogueweapon/shield/wood
		if(11)
			r_hand = /obj/item/rogueweapon/flail/peasantwarflail
		if(12)
			r_hand = /obj/item/rogueweapon/huntingknife/idagger
			l_hand = /obj/item/rogueweapon/shield/wood
	if(prob(5))
		neck = /obj/item/storage/belt/rogue/pouch/bombs
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather

	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/staves, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE) // Trash mobs, untrained.
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

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
				H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/haughty]

/mob/living/carbon/human/species/human/northern/militia/ambush

/mob/living/carbon/human/species/human/northern/militia/guard //variant that doesn't wander, if you want to place them as set dressing. will aggro enemies and animals

/mob/living/carbon/human/species/human/northern/militia/deserter // Bad deserter, trash mob
	threat_point = THREAT_MODERATE
	ambush_faction = "bandits"
	faction = list(FACTION_BANDITS, FACTION_STATION)

/mob/living/carbon/human/species/human/northern/militia/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = HEAD_BOUNTY_GOBLIN
