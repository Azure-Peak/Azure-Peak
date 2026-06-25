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
	set_species(/datum/species/human/northern)
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
	gender = pick(MALE, FEMALE)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/lowbraid,
						/datum/sprite_accessory/hair/head/countryponytailalt))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytailwitcher,
						/datum/sprite_accessory/hair/head/lowbraid))
	var/beard = pick(list(/datum/sprite_accessory/hair/facial/viking,
						/datum/sprite_accessory/hair/facial/manly,
						/datum/sprite_accessory/hair/facial/longbeard))
	head.sellprice = HEAD_BOUNTY_SEARAIDER
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
			skin_tone = SKIN_COLOR_GRENZELHOFT
		if(2)
			skin_tone = SKIN_COLOR_AVAR
		if(3)
			skin_tone = SKIN_COLOR_OTAVA
		if(4)
			skin_tone = SKIN_COLOR_SHALVISTINE
		if(5)
			skin_tone = SKIN_COLOR_LALVESTINE
		if(6)
			skin_tone = SKIN_COLOR_NALEDI
		if(7)
			skin_tone = SKIN_COLOR_KAZENGUN
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
	// Stopgap: archer roll removed because the ranged NPC AI is unreliable.
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

/mob/living/carbon/human/species/human/northern/searaider/archer/ambush
	threat_point = THREAT_MODERATE
	ambush_faction = "raiders"

/mob/living/carbon/human/species/human/northern/searaider/archer/after_creation()
	..()
	for(var/obj/item/I in held_items)
		qdel(I)
	for(var/obj/item/I in get_equipped_items(FALSE))
		if(istype(I, /obj/item/gun) || istype(I, /obj/item/quiver))
			qdel(I)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/searaider/archer)

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
