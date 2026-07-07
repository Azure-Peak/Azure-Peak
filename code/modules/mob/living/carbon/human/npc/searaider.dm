GLOBAL_LIST_INIT(searaider_aggro, world.file2list("strings/rt/searaideraggrolines.txt"))

/mob/living/carbon/human/species/human/northern/searaider
	ai_controller = /datum/ai_controller/human_npc
	d_intent = INTENT_PARRY
	faction = list(FACTION_GRONNMEN, FACTION_STATION)
	ambushable = FALSE
	dodgetime = 30
	blood_toll_bucket = STATS_KILLED_GRONNMEN


/mob/living/carbon/human/species/human/northern/searaider/ambush
	threat_point = THREAT_MODERATE
	ambush_faction = "raiders"



/mob/living/carbon/human/species/human/northern/searaider/Initialize()
	. = ..()
	//Begin RANDOMISE here
	set_species(pick(NPC_RACES_TYPES))
	gender = pick(MALE, FEMALE)
	dna.species.random_character(src) //Now we just randomise here, MUST be called after both race + gender
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)


/mob/living/carbon/human/species/human/northern/searaider/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.searaider_aggro, TRUE)
	job = "Sea Raider"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/searaider)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = HEAD_BOUNTY_SEARAIDER
	dna.species.handle_body(src)
	random_voice_NPC()
	random_hair_NPC()
	random_eye_color_NPC()
	correct_features_NPC()

	if(gender == FEMALE)
		real_name = pick(world.file2list("strings/rt/names/human/vikingf.txt"))
	else
		real_name = pick(world.file2list("strings/rt/names/human/vikingm.txt"))
	update_hair()
	update_body()
	src.regenerate_icons() //Fixes the weird body but lets check performance first


/datum/outfit/job/roguetown/human/species/human/northern/searaider/pre_equip(mob/living/carbon/human/H)
	belt = /obj/item/storage/belt/rogue/leather //Cosmetic + Holding repair kits for looting mostly.
	if(prob(15))
		beltl = /obj/item/repair_kit/bad //So you can get repair kits easier from looting them
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	if(prob(50))
		wrists = wrists = /obj/item/clothing/wrists/roguetown/bracers/copper
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	if(prob(50))
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor //We don't want anything that dips below waist, looks bad w/kilt
	if(prob(20))
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar //SHATTER MY BINDS
	var/armor_choice = rand(1, 4)
	switch(armor_choice)
		if(1)
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
		if(2)
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
		if(3)
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper
		if(4)
			armor = /obj/item/clothing/suit/roguetown/armor/gambeson
	var/cloak_choice = rand(1, 4)
	switch(cloak_choice)
		if(1)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
		if(2)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak/black
		if(3)
			cloak = /obj/item/clothing/cloak/raincloak/furcloak //White
		if(4)
			cloak = /obj/item/clothing/cloak/volfmantle
	var/leg_choice = rand(1, 3)
	switch(leg_choice)
		if(1)
			pants = /obj/item/clothing/under/roguetown/chainlegs/iron
		if(2)
			pants = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
		if(3)
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt
	if(prob(60)) //60% of a random helmet
		var/helmet_choice = rand(1, 4)
		switch(helmet_choice)
			if(1)
				head = /obj/item/clothing/head/roguetown/helmet/horned //SOVL
			if(2)
				head = /obj/item/clothing/head/roguetown/helmet/sallet/iron/banded
			if(3)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
			if(4)
				head = /obj/item/clothing/head/roguetown/helmet/leather
	var/neck_choice = rand(1, 3)
	switch(neck_choice)
		if(1)
			neck = /obj/item/clothing/neck/roguetown/gorget //SOVL
		if(2)
			neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
		if(3)
			neck = /obj/item/clothing/neck/roguetown/bevor/iron
	gloves = /obj/item/clothing/gloves/roguetown/leather
	if(prob(40))
		gloves = /obj/item/clothing/gloves/roguetown/plate/iron/banded
	switch(rand(1, 6))
		if(1)
			r_hand = /obj/item/rogueweapon/sword/iron
			l_hand = /obj/item/rogueweapon/shield/wood
		if(2)
			r_hand = /obj/item/rogueweapon/stoneaxe/handaxe
			l_hand = /obj/item/rogueweapon/shield/wood
		if(3)
			r_hand = /obj/item/rogueweapon/spear
		if(4)
			r_hand = /obj/item/rogueweapon/greataxe
		if(5)
			r_hand = /obj/item/rogueweapon/greatsword/iron
		if(6) //GRAGGAR, LET ME BE WITNESSED
			r_hand = /obj/item/rogueweapon/stoneaxe/handaxe/copper
			l_hand = /obj/item/rogueweapon/stoneaxe/handaxe/copper
			ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC) //lets them actually use it, not just for show, sire.

	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedboots
	if(prob(30))
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	H.STASPD = 9
	H.STACON = 7
	H.STAWIL = 8
	H.STAPER = 8 //AIMING? Who needs that lame-ass shit? GRAGGAR GRAGGAR GRAGGAR!!
	H.STAINT = 8 //Minimal req to use specials
	H.STASTR = 14
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior]
	H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]

/mob/living/carbon/human/species/human/northern/searaider/archer
	ai_controller = /datum/ai_controller/human_npc/archer
	var/archer_outfit = /datum/outfit/job/roguetown/human/species/human/northern/searaider/archer

/mob/living/carbon/human/species/human/northern/searaider/archer/ambush
	threat_point = THREAT_MODERATE
	ambush_faction = "raiders"

/mob/living/carbon/human/species/human/northern/searaider/archer/ambush/reaver
	archer_outfit = /datum/outfit/job/roguetown/human/species/human/northern/searaider/archer/reaver

/mob/living/carbon/human/species/human/northern/searaider/archer/after_creation()
	..()
	STAPER = 12
	STAINT = 8
	STASTR = 12 // These are archers
	for(var/obj/item/I in held_items)
		qdel(I)
	for(var/obj/item/I in get_equipped_items(FALSE))
		if(istype(I, /obj/item/gun) || istype(I, /obj/item/quiver))
			qdel(I)
	equipOutfit(new archer_outfit)

/datum/outfit/job/roguetown/human/species/human/northern/searaider/archer/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic
	pants = /obj/item/clothing/under/roguetown/tights
	head = /obj/item/clothing/head/roguetown/helmet/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backl = /obj/item/quiver/arrows
	r_hand = /obj/item/rogueweapon/sword/iron
	H.STASPD = 9
	H.STACON = 8
	H.STAWIL = 8
	H.STAPER = 13
	H.STAINT = 1
	H.STASTR = 12
	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)

/datum/outfit/job/roguetown/human/species/human/northern/searaider/archer/reaver/pre_equip(mob/living/carbon/human/H)
	..()
	backl = /obj/item/quiver/randomfill/reaver

/mob/living/carbon/human/species/human/northern/searaider/huscarl
	threat_point = THREAT_DANGEROUS

/mob/living/carbon/human/species/human/northern/searaider/huscarl/ambush
	threat_point = THREAT_DANGEROUS
	ambush_faction = "raiders"

/mob/living/carbon/human/species/human/northern/searaider/huscarl/after_creation()
	..()
	job = "Sea Raider Huscarl"
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	for(var/obj/item/old in get_equipped_items() + held_items)
		qdel(old)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/searaider/huscarl)
	regenerate_icons()
	for(var/obj/item/gear in get_equipped_items() + held_items)
		lock_gear_piece(gear, "searaider_huscarl_gear")

/mob/living/carbon/human/species/human/northern/searaider/huscarl/death(gibbed, nocutscene = FALSE)
	. = ..()
	for(var/obj/item/gear in get_equipped_items() + held_items)
		REMOVE_TRAIT(gear, TRAIT_NODROP, "searaider_huscarl_gear")

/datum/outfit/job/roguetown/human/species/human/northern/searaider/huscarl/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/old/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	belt = /obj/item/storage/belt/rogue/leather
	r_hand = /obj/item/rogueweapon/greatsword/iron
	H.STASTR = 15
	H.STASPD = 9
	H.STACON = 10
	H.STAWIL = 9
	H.STAPER = 9
	H.STAINT = 8
	H.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior]
	H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]
