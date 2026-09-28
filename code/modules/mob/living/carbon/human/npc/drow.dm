GLOBAL_LIST_INIT(drowraider_aggro, world.file2list("strings/rt/drowaggrolines.txt"))

/mob/living/carbon/human/species/elf/dark/drowraider
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_DROW)
	ambushable = FALSE
	dodgetime = 30
	d_intent = INTENT_DODGE
	blood_toll_bucket = STATS_KILLED_DROWS
	npc_archetype = /datum/npc_archetype/drow/raider


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



/mob/living/carbon/human/species/elf/dark/drowraider/Initialize(mapload)
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
	roll_drow_voice()
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
	random_voice_NPC()
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
			if(4)
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


/mob/living/carbon/human/species/elf/dark/drowraider/proc/roll_drow_voice()
	if(!prob(50))
		return
	switch(rand(1, 4))
		if(1)
			dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior]
			dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]
		if(2)
			dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/stern]
			dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/haughty]
		if(3)
			dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/foppish]
			dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/dainty]
		if(4)
			dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/wizard] //Aura
			dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/haughty]

/mob/living/carbon/human/species/elf/dark/drowraider/archer
	ai_controller = /datum/ai_controller/human_npc/archer
	npc_archetype = /datum/npc_archetype/drow/archer

/mob/living/carbon/human/species/elf/dark/drowraider/archer/ambush
	threat_point = THREAT_TOUGH
	ambush_faction = "underdark"

