GLOBAL_LIST_INIT(bum_quotes, world.file2list("strings/rt/bumlines.txt"))
GLOBAL_LIST_INIT(bum_aggro, world.file2list("strings/rt/bumaggrolines.txt"))

/mob/living/carbon/human/species/human/northern/bum
	ai_controller = /datum/ai_controller/human_npc
	d_intent = INTENT_PARRY
	faction = list(FACTION_BUMS, FACTION_STATION)
	ambushable = FALSE
	dodgetime = 30

/mob/living/carbon/human/species/human/northern/bum/ambush



/mob/living/carbon/human/species/human/northern/bum/Initialize()
	. = ..()
	//Begin RANDOMISE here
	set_species(pick(NPC_RACES_TYPES))
	gender = pick(MALE, FEMALE)
	dna.species.random_character(src) //Now we just randomise here, MUST be called after both race + gender
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/bum/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.bum_aggro, TRUE)
	job = "Beggar"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	random_voice_NPC()
	random_hair_NPC()
	random_eye_color_NPC()
	correct_features_NPC()
	STALUC = rand(5, 15)
	STACON = rand(4, 10)
	STAWIL = rand(4, 10)
	STASTR = rand(7, 10)
	STAINT = rand(5, 15) //Hilarious
	equipOutfit(new /datum/outfit/job/roguetown/bum_npc)

/datum/outfit/job/roguetown/bum_npc/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/knives, rand(0,3), TRUE) // Exceedingly trash mobs, ...sometimes
	H.adjust_skillrank(/datum/skill/combat/polearms, rand(0,3), TRUE)
	H.adjust_skillrank(/datum/skill/combat/staves, rand(0,3), TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, rand(0,3), TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, rand(0,3), TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, rand(0,3), TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, rand(0,3), TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, rand(2,5), TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, rand(2,5), TRUE)

	belt = /obj/item/storage/belt/rogue/leather/rope
	if(prob(70))
		switch(rand(1, 10))
			if(1)
				r_hand = /obj/item/rogueweapon/mace/woodclub
			if(2)
				r_hand = /obj/item/rogueweapon/mace/cudgel
			if(3)
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff
			if(4)
				r_hand = /obj/item/rogueweapon/stoneaxe
			if(5)
				l_hand = /obj/item/rogueweapon/woodstaff
			if(6)
				r_hand = /obj/item/rogueweapon/huntingknife/idagger
			if(7)
				l_hand = /obj/item/rogueweapon/stoneaxe/woodcut
			if(8)
				l_hand = /obj/item/rogueweapon/huntingknife/stoneknife
			if(9)
				l_hand = /obj/item/rogueweapon/flail
			if(10)
				l_hand = /obj/item/rogueweapon/spear
	if(prob(1))
		belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	if(prob(20))
		head = /obj/item/clothing/head/roguetown/knitcap

	if(prob(5))
		beltr = /obj/item/reagent_containers/powder/moondust

	if(prob(5))
		backl = /obj/item/storage/backpack/rogue/backpack/bagpack

	if(prob(10))
		beltl = /obj/item/clothing/mask/cigarette/rollie/cannabis

	if(prob(10))
		cloak = /obj/item/clothing/cloak/raincloak/brown

	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else
		armor = null
		pants = /obj/item/clothing/under/roguetown/tights/vagrant

		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l

		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant

		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

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
