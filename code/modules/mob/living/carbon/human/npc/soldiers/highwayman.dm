GLOBAL_LIST_INIT(highwayman_aggro, world.file2list("strings/rt/highwaymanaggrolines.txt"))

/mob/living/carbon/human/species/human/northern/highwayman
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_BANDITS, FACTION_STATION)
	ambushable = FALSE
	dodgetime = 30
	d_intent = INTENT_PARRY
	blood_toll_bucket = STATS_KILLED_HIGHWAYMEN

/mob/living/carbon/human/species/human/northern/highwayman/ambush
	threat_point = THREAT_MODERATE
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/mount_reaver
	name = "mount reaver"
	threat_point = THREAT_HIGH
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/mount_reaver/after_creation()
	..()
	job = "Mount Reaver"
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/mount_reaver)

/mob/living/carbon/human/species/human/northern/highwayman/archer
	ai_controller = /datum/ai_controller/human_npc/archer
	threat_point = THREAT_MODERATE
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/archer/after_creation()
	..()
	job = "Highwayman Archer"
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/highwayman/archer)

/mob/living/carbon/human/species/human/northern/highwayman/crossbowman
	ai_controller = /datum/ai_controller/human_npc/archer
	threat_point = THREAT_MODERATE
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/crossbowman/after_creation()
	..()
	job = "Highwayman Crossbowman"
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/highwayman/crossbowman)



/mob/living/carbon/human/species/human/northern/highwayman/Initialize()
	. = ..()
	//Begin RANDOMISE here
	set_species(pick(NPC_RACES_TYPES))
	gender = pick(MALE, FEMALE)
	dna.species.random_character(src) //Now we just randomise here, MUST be called after both race + gender
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)


/mob/living/carbon/human/species/human/northern/highwayman/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.highwayman_aggro, TRUE)
	job = "Highwayman"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/highwayman)
	dna.species.handle_body(src)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = HEAD_BOUNTY_HIGHWAYMAN
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


/datum/outfit/job/roguetown/human/species/human/northern/highwayman/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	if(prob(10))
		belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	if(prob(50))
		shoes = /obj/item/clothing/shoes/roguetown/boots //Dark boots
	if(prob(30)) //30% cloak chance - themed off bandits
		var/cloak_choice = rand(1, 5)
		switch(cloak_choice)
			if(1)
				cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
			if(2)
				cloak = /obj/item/clothing/cloak/raincloak/red
			if(3)
				cloak = /obj/item/clothing/cloak/raincloak/green
			if(4)
				cloak = /obj/item/clothing/cloak/raincloak/blue
			if(5)
				cloak = /obj/item/clothing/cloak/raincloak/brown
	if(prob(50)) //50% MASK, SER MASK OFF, SER MASK
		var/mask_choice = rand(1, 3)
		switch(mask_choice)
			if(1)
				mask = /obj/item/clothing/mask/rogue/ragmask/red
			if(2)
				mask = /obj/item/clothing/mask/rogue/ragmask/black
			if(3)
				mask = /obj/item/clothing/mask/rogue/skullmask
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	if(prob(50))
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	if(prob(50)) //50% random helm chance
		var/helmet_choice = rand(1, 5)
		switch(helmet_choice)
			if(1)
				head = /obj/item/clothing/head/roguetown/helmet/leather
			if(2)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
			if(3)
				head = /obj/item/clothing/head/roguetown/helmet/tricorn //YARRRGH
			if(4)
				head = /obj/item/clothing/head/roguetown/armingcap
			if(5)
				head = /obj/item/clothing/head/roguetown/menacing/bandit //IS THIS TRVE?
	neck = /obj/item/storage/belt/rogue/pouch/bombs //Expect more booms
	if(prob(98)) //2% bomber chance
		var/neck_choice = rand(1, 2)
		switch(neck_choice)
			if(1)
				neck = /obj/item/clothing/neck/roguetown/coif //SOVL
			if(2)
				neck = neck = /obj/item/clothing/neck/roguetown/leather

	H.STASTR = rand(11,14) //random strength
	H.STASPD = 11
	H.STACON = 6
	H.STAWIL = 6
	H.STAPER = 10
	H.STAINT = 8
	switch(rand(1, 7))
		if(1)
			r_hand = /obj/item/rogueweapon/sword/short/iron
			if(prob(45))
				l_hand = /obj/item/rogueweapon/shield/wood
		if(2)
			r_hand = /obj/item/rogueweapon/mace/cudgel
			if(prob(25))
				l_hand = /obj/item/rogueweapon/shield/wood

		if(3)
			r_hand = /obj/item/rogueweapon/sword/falchion/militia
			if(prob(20))
				l_hand = /obj/item/rogueweapon/shield/wood
		if(4)
			r_hand = /obj/item/rogueweapon/pick/militia
			if(prob(35))
				l_hand = /obj/item/rogueweapon/shield/buckler/palloy
		if(5)
			r_hand = /obj/item/rogueweapon/greataxe/militia
		if(6)
			l_hand = /obj/item/rogueweapon/woodstaff/militia
		if(7)
			r_hand = /obj/item/rogueweapon/huntingknife/idagger
			if(prob(65)) //More likely but loses upgrade for shield pick
				l_hand = /obj/item/rogueweapon/shield/buckler/palloy

	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/staves, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE) // Trash mobs, untrained.
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
				H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/haughty]

/datum/outfit/job/roguetown/human/species/human/northern/mount_reaver/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	mask = /obj/item/clothing/mask/rogue/ragmask/black //Guarrenteed vs before
	if(prob(15)) //On top of the other 10%, a lot higher chance to be using this.
		belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	H.STASTR = 12
	H.STASPD = 11
	H.STACON = 8
	H.STAWIL = 8
	H.STAPER = 11
	H.STAINT = 10 //Higher, due to losing their bombs cause of how inhereting the loadout works.
	// Rest of the random gear is handled via subtyping regular highwaymen, this includes our weaponry picks. Which yes, means a slight downgrade.

	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/staves, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

// Overrides only the weapon loadout on top of the base highwayman gear (no ..(), so clothing/stats
// from after_creation's first equip stay). The melee sidearm covers the close-range handoff.
/datum/outfit/job/roguetown/human/species/human/northern/highwayman/archer/pre_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/rogueweapon/sword/short/iron
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backl = /obj/item/quiver/randomfill/highwayman
	H.STAPER += 3
	H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)

/datum/outfit/job/roguetown/human/species/human/northern/highwayman/crossbowman/pre_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/rogueweapon/huntingknife/idagger
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	backl = /obj/item/quiver/bolt/standard
	H.STAPER += 3
	H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)

/mob/living/carbon/human/species/human/northern/highwayman/road_knight
	threat_point = THREAT_DANGEROUS
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/road_knight/after_creation()
	..()
	job = "Road Knight"
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	for(var/obj/item/old in get_equipped_items() + held_items)
		qdel(old)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/highwayman/road_knight)
	regenerate_icons()
	for(var/obj/item/gear in get_equipped_items() + held_items)
		lock_gear_piece(gear, "road_knight_gear")

/mob/living/carbon/human/species/human/northern/highwayman/road_knight/death(gibbed, nocutscene = FALSE)
	. = ..()
	for(var/obj/item/gear in get_equipped_items() + held_items)
		REMOVE_TRAIT(gear, TRAIT_NODROP, "road_knight_gear")

/datum/outfit/job/roguetown/human/species/human/northern/highwayman/road_knight/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/armor/plate/iron
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	belt = /obj/item/storage/belt/rogue/leather
	r_hand = /obj/item/rogueweapon/sword/iron
	l_hand = /obj/item/rogueweapon/shield/heater
	H.STASTR = 14
	H.STASPD = 10
	H.STACON = 10
	H.STAWIL = 10
	H.STAPER = 10
	H.STAINT = 8
	H.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)

/mob/living/carbon/human/species/human/northern/highwayman/sharpshooter
	ai_controller = /datum/ai_controller/human_npc/archer
	threat_point = THREAT_DANGEROUS
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/sharpshooter/after_creation()
	..()
	job = "Highwayman Sharpshooter"
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	for(var/obj/item/old in get_equipped_items() + held_items)
		qdel(old)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/highwayman/sharpshooter)
	regenerate_icons()
	for(var/obj/item/gear in get_equipped_items())
		if(gear == backr || gear == backl)
			continue
		lock_gear_piece(gear, "sharpshooter_gear")

/mob/living/carbon/human/species/human/northern/highwayman/sharpshooter/death(gibbed, nocutscene = FALSE)
	. = ..()
	for(var/obj/item/gear in get_equipped_items())
		REMOVE_TRAIT(gear, TRAIT_NODROP, "sharpshooter_gear")

/datum/outfit/job/roguetown/human/species/human/northern/highwayman/sharpshooter/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	cloak = /obj/item/clothing/cloak/raincloak/green
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/quiver/randomfill/reaver
	beltr = /obj/item/rogueweapon/sword/short/iron
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backl = /obj/item/quiver/randomfill/reaver
	H.STASTR = 12
	H.STASPD = 10
	H.STACON = 8
	H.STAWIL = 9
	H.STAPER = 15
	H.STAINT = 8
	H.adjust_skillrank(/datum/skill/combat/bows, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
