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



/mob/living/carbon/human/species/human/northern/highwayman/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
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
	gender = pick(MALE, FEMALE)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = HEAD_BOUNTY_HIGHWAYMAN
	var/hairf = pick(list(
						/datum/sprite_accessory/hair/head/lowbraid,
						/datum/sprite_accessory/hair/head/countryponytailalt,
						/datum/sprite_accessory/hair/head/gloomy,
						/datum/sprite_accessory/hair/head/zone,
						/datum/sprite_accessory/hair/head/hime,
						/datum/sprite_accessory/hair/head/stacy,
						/datum/sprite_accessory/hair/head/sabitsuki,
						/datum/sprite_accessory/hair/head/sabitsuki_ponytail, 
						/datum/sprite_accessory/hair/head/kusanagi_alt,
						/datum/sprite_accessory/hair/head/fluffy,
						/datum/sprite_accessory/hair/head/fluffylong))
	var/hairm = pick(list(
						/datum/sprite_accessory/hair/head/ponytailwitcher,
						/datum/sprite_accessory/hair/head/bowlcut, 
						/datum/sprite_accessory/hair/head/bowlcut2,
						/datum/sprite_accessory/hair/head/lowbraid,
						/datum/sprite_accessory/hair/head/emo,
						/datum/sprite_accessory/hair/head/sabitsuki,
						/datum/sprite_accessory/hair/head/sabitsuki_ponytail, 
						/datum/sprite_accessory/hair/head/rogue))
	var/beard = pick(list(/datum/sprite_accessory/hair/facial/stubble,
						/datum/sprite_accessory/hair/facial/manly,
						/datum/sprite_accessory/hair/facial/fiveoclockmoustache,
						/datum/sprite_accessory/hair/facial/sevenoclockm,
						/datum/sprite_accessory/hair/facial/chinlessbeard,
						/datum/sprite_accessory/hair/facial/fullbeard,
						/datum/sprite_accessory/hair/facial/chinstrap,
						/datum/sprite_accessory/hair/facial/vandyke,
						/datum/sprite_accessory/hair/facial/longbeard))
	AddComponent(/datum/component/npc_death_line, null, 25)
	//Random voices, this can probably be more random-ish but it'll do for now
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
	//Next up, we add hair
	var/datum/bodypart_feature/hair/head/new_hair = new()
	var/datum/bodypart_feature/hair/facial/new_facial = new()

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)
		new_facial.set_accessory_type(beard, null, src)

	var/haircolor_choice = rand(1, 4)
	switch(haircolor_choice)
		if(1)
			new_hair.accessory_colors = "#C1A287"
			new_hair.hair_color = "#C1A287"
			new_facial.accessory_colors = "#C1A287"
			new_facial.hair_color = "#C1A287"
			hair_color = "#C1A287"
		if(2)
			new_hair.accessory_colors = "#A56B3D"
			new_hair.hair_color = "#A56B3D"
			new_facial.accessory_colors = "#A56B3D"
			new_facial.hair_color = "#A56B3D"
			hair_color = "#A56B3D"
		if(3) //Black
			new_hair.accessory_colors = "#030107"
			new_hair.hair_color = "#030107"
			new_facial.accessory_colors = "#030107"
			new_facial.hair_color = "#030107"
			hair_color = "#030107"
		if(4) //Red
			new_hair.accessory_colors = "#a53d3d"
			new_hair.hair_color = "#a53d3d"
			new_facial.accessory_colors = "#a53d3d"
			new_facial.hair_color = "#a53d3d"
			hair_color = "#a53d3d"
	//Now we take skin-tone picks
	var/skintone_choice = rand(1, 7) //Heavily simplified
	switch(skintone_choice)
		if(1)
			skin_tone = "SKIN_COLOR_GRENZELHOFT"
		if(2)
			skin_tone = "SKIN_COLOR_AVAR"
		if(3)
			skin_tone = "SKIN_COLOR_OTAVA"
		if(4)
			skin_tone = "SKIN_COLOR_SHALVISTINE"
		if(5)
			skin_tone = "SKIN_COLOR_LALVESTINE"
		if(6)
			skin_tone = "SKIN_COLOR_NALEDI"
		if(7)
			skin_tone = "SKIN_COLOR_KAZENGUN"
	//Add our hair bodypart features
	head.add_bodypart_feature(new_hair)
	head.add_bodypart_feature(new_facial)

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)
	//eye picks, we have four-cause its easier to work with. Don't ask me why it randomly breaks to white eyes but sovlful NGL
	if(organ_eyes)
		var/eye_choice = rand(1, 4)
		switch(eye_choice)
			if(1)
				organ_eyes.eye_color = "#336699"
				organ_eyes.accessory_colors = "#336699#336699"
			if(2)
				organ_eyes.eye_color = "#339933"
				organ_eyes.accessory_colors = "#339933#339933"
			if(3)
				organ_eyes.eye_color = "#995333"
				organ_eyes.accessory_colors = "#995333#995333"
			if(3)
				organ_eyes.eye_color = "#131313" //Souless greytider look
				organ_eyes.accessory_colors = "#131313#131313"

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
