GLOBAL_LIST_INIT(drowraider_aggro, world.file2list("strings/rt/drowaggrolines.txt"))

/mob/living/carbon/human/species/elf/dark/drowraider
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_DROW)
	ambushable = FALSE
	dodgetime = 30
	d_intent = INTENT_DODGE
	blood_toll_bucket = STATS_KILLED_DROWS


/mob/living/carbon/human/species/elf/dark/drowraider/ambush
	threat_point = THREAT_TOUGH
	ambush_faction = "underdark"

// Testing-only subtype: forced whip loadout to verify NPC reach handling on weapons with reach > 1.
/mob/living/carbon/human/species/elf/dark/drowraider/whip_test

/mob/living/carbon/human/species/elf/dark/drowraider/whip_test/after_creation()
	..()
	for(var/obj/item/I in held_items)
		qdel(I)
	put_in_active_hand(new /obj/item/rogueweapon/whip(src))

// Testing-only subtype: forced spear loadout (reach 2) to verify polearm reach handling.
/mob/living/carbon/human/species/elf/dark/drowraider/spear_test
	threat_point = THREAT_TOUGH

/mob/living/carbon/human/species/elf/dark/drowraider/spear_test/after_creation()
	..()
	for(var/obj/item/I in held_items)
		qdel(I)
	put_in_active_hand(new /obj/item/rogueweapon/spear(src))

// Testing-only subtype: forced short sword loadout (reach 1) as a baseline control.
/mob/living/carbon/human/species/elf/dark/drowraider/sword_test
	threat_point = THREAT_TOUGH

/mob/living/carbon/human/species/elf/dark/drowraider/sword_test/after_creation()
	..()
	for(var/obj/item/I in held_items)
		qdel(I)
	put_in_active_hand(new /obj/item/rogueweapon/sword/short(src))

// Testing-only subtype: empty-handed spawn. Use to verify find_weapon pickup behavior —
// drop a rogueweapon nearby and watch them path to it.
/mob/living/carbon/human/species/elf/dark/drowraider/disarmed_test

/mob/living/carbon/human/species/elf/dark/drowraider/disarmed_test/after_creation()
	..()
	for(var/obj/item/I in held_items)
		qdel(I)



/mob/living/carbon/human/species/elf/dark/drowraider/Initialize()
	. = ..()
	set_species(/datum/species/elf/dark/raider)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)


/mob/living/carbon/human/species/elf/dark/drowraider/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.drowraider_aggro, TRUE)
	job = "Drow Raider"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/elf/dark/drowraider)
	if(prob(40))
		gender = MALE
	else
		gender = FEMALE
	regenerate_icons()

	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/organ/ears/organ_ears = getorgan(/obj/item/organ/ears)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/himecut,
						/datum/sprite_accessory/hair/head/countryponytailalt,
						/datum/sprite_accessory/hair/head/stacy,
						/datum/sprite_accessory/hair/head/kusanagi_alt))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytailwitcher,
						/datum/sprite_accessory/hair/head/dave,
						/datum/sprite_accessory/hair/head/emo,
						/datum/sprite_accessory/hair/head/sabitsuki,
						/datum/sprite_accessory/hair/head/sabitsuki_ponytail))

	var/datum/bodypart_feature/hair/head/new_hair = new()
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
	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)

	new_hair.accessory_colors = "#DDDDDD"
	new_hair.hair_color = "#DDDDDD"
	hair_color = "#DDDDDD"

	head.add_bodypart_feature(new_hair)
	head.sellprice = HEAD_BOUNTY_DROW

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)
	//eye picks, we have four-cause its easier to work with. Don't ask me why it randomly breaks to white eyes but sovlful NGL
	if(organ_eyes)
		var/eye_choice = rand(1, 4)
		switch(eye_choice)
			if(1)
				organ_eyes.eye_color = "#FFBF00"
				organ_eyes.accessory_colors = "#FFBF00#FFBF00"
			if(2)
				organ_eyes.eye_color = "#e60000"
				organ_eyes.accessory_colors = "#e60000#e60000"
			if(3)
				organ_eyes.eye_color = "#96fc9e"
				organ_eyes.accessory_colors = "#96fc9e#96fc9e"
			if(3)
				organ_eyes.eye_color = "#bb68ff"
				organ_eyes.accessory_colors = "#bb68ff#bb68ff"

	if(organ_ears)
		organ_ears.accessory_colors = "#5f5f70"

	skin_tone = "5f5f70"

	if(gender == FEMALE)
		real_name = pick(world.file2list("strings/rt/names/elf/elfdf.txt"))
	else
		real_name = pick(world.file2list("strings/rt/names/elf/elfdm.txt"))

	update_hair()
	update_body()


/datum/outfit/job/roguetown/human/species/elf/dark/drowraider/pre_equip(mob/living/carbon/human/H)
	if(prob(40)) //40% cloak chance
		var/cloak_choice = rand(1, 3)
		switch(cloak_choice)
			if(1)
				cloak = /obj/item/clothing/cloak/raincloak/mortus
			if(2)
				cloak = /obj/item/clothing/cloak/half/rider/red
			if(3)
				cloak = /obj/item/clothing/cloak/half

	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/drowraider
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest/drowraider
	shirt = /obj/item/clothing/suit/roguetown/shirt/shadowshirt/elflock/drowraider
	gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	var/mask_choice = rand(1, 5)
	switch(mask_choice)
		if(1 to 2)
			mask = /obj/item/clothing/mask/rogue/facemask
		if(3 to 4)
			mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask/delf
		if(5)
			mask = /obj/item/clothing/mask/rogue/xylixmask //WHY SO SERIOUS?!
	var/neck_choice = rand(1, 3)
	switch(neck_choice)
		if(1)
			neck = /obj/item/clothing/neck/roguetown/coif/heavypadding //SOVL
		if(2)
			neck = /obj/item/clothing/neck/roguetown/leather
			head = /obj/item/clothing/head/roguetown/helmet/kettle/iron //So they have head armor
		if(2)
			neck = /obj/item/clothing/neck/roguetown/gorget
			head = /obj/item/clothing/head/roguetown/helmet/kettle/iron //So they have head armor
	// Stopgap: archer roll removed because the ranged NPC AI is unreliable.
	if(prob(45)) // whip
		r_hand = /obj/item/rogueweapon/whip
	else if(prob(50)) // dual falx
		r_hand = /obj/item/rogueweapon/sword/falx/stalker
		l_hand = /obj/item/rogueweapon/sword/falx/stalker
	else // dual daggers
		r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/stalker
		l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/stalker

	H.STASTR = 12 // 6 Points
	H.STASPD = 13 // 3 points
	H.STACON = 9
	H.STAWIL = 8
	H.STAPER = 10
	H.STAINT = 10
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	if(prob(50))
		var/voicepack_choice = rand(1, 4)
		switch(voicepack_choice)
			if(1)
				H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
				H.dna.species.soundpack_f = new /datum/voicepack/female/warrior()
			if(2)
				H.dna.species.soundpack_m = new /datum/voicepack/male/stern()
				H.dna.species.soundpack_f = new /datum/voicepack/female/haughty()
			if(3)
				H.dna.species.soundpack_m = new /datum/voicepack/male/foppish()
				H.dna.species.soundpack_f = new /datum/voicepack/female/dainty()
			if(4)
				H.dna.species.soundpack_m = new /datum/voicepack/male/wizard() //Aura
				H.dna.species.soundpack_f = new /datum/voicepack/female/haughty()

/mob/living/carbon/human/species/elf/dark/drowraider/archer
	ai_controller = /datum/ai_controller/human_npc/archer

/mob/living/carbon/human/species/elf/dark/drowraider/archer/ambush
	threat_point = THREAT_TOUGH
	ambush_faction = "underdark"

/mob/living/carbon/human/species/elf/dark/drowraider/archer/after_creation()
	..()
	for(var/obj/item/I in held_items)
		qdel(I)
	for(var/obj/item/I in get_equipped_items(FALSE))
		if(istype(I, /obj/item/gun) || istype(I, /obj/item/quiver))
			qdel(I)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/elf/dark/drowraider/archer)

/datum/outfit/job/roguetown/human/species/elf/dark/drowraider/archer/pre_equip(mob/living/carbon/human/H)
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/drowraider
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest/drowraider
	shirt = /obj/item/clothing/suit/roguetown/shirt/shadowshirt/elflock/drowraider
	gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/facemask
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backl = /obj/item/quiver/arrows
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/stalker
	H.STASTR = 10
	H.STASPD = 13
	H.STACON = 9
	H.STAWIL = 8
	H.STAPER = 13
	H.STAINT = 10
	H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
