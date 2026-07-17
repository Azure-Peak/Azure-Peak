/* 
*	these guys are intended to be a speedbump to solo adventurers at mount decap
*	deadly but small in numbers. come back with a party, chump
*/

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter
	ai_controller = /datum/ai_controller/human_npc
	d_intent = INTENT_PARRY
	faction = list(FACTION_MADMEN, FACTION_BANDITS) // Avoid them hitting bandits in dungeon
	ambushable = FALSE
	dodgetime = 15
	var/mad_outfit = /datum/outfit/job/roguetown/human/species/human/northern/mad_touched_treasure_hunter

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/ambush
	threat_point = THREAT_DANGEROUS
	ambush_faction = "treasure_hunters"

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/Initialize()
	. = ..()
	//Begin RANDOMISE here
	set_species(pick(NPC_RACES_TYPES))
	gender = pick(MALE, FEMALE)
	dna.species.random_character(src) //Now we just randomise here, MUST be called after both race + gender
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Mad-touched Treasure Hunter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_DISFIGURED, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	equipOutfit(new mad_outfit)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = HEAD_BOUNTY_MAD_TOUCHED
	dna.species.handle_body(src)
	random_voice_NPC()
	random_hair_no_beard_NPC()
	random_eye_color_NPC()
	var/obj/item/organ/ears/organ_ears = getorgan(/obj/item/organ/ears)
	if(organ_ears)
		organ_ears.accessory_colors = "[src.skin_tone]"

	dna.species.handle_body(src)
	
	real_name = pick(world.file2list("strings/rt/names/human/mad_touched_names.txt"))

	update_hair()
	update_body()
	src.regenerate_icons() //Fixes the weird body


/datum/outfit/job/roguetown/human/species/human/northern/mad_touched_treasure_hunter/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	mask = /obj/item/clothing/mask/rogue/facemask/steel/paalloy/mad_touched
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy
	pants = /obj/item/clothing/under/roguetown/platelegs/iron
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron/banded
	cloak = /obj/item/clothing/cloak/wickercloak
	if(prob(40))
		var/amulet_choice = rand(1, 4)
		switch(amulet_choice)
			if(1)
				id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy //ZIZO. ZIZO. ZIZO.
			if(2)
				id = /obj/item/clothing/neck/roguetown/psicross/aalloy
			if(3)
				id = /obj/item/clothing/neck/roguetown/psicross/noc/aalloy
			if(4)
				id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios //IS THIS TRVE?!
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	if(prob(20))
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	if(prob(33))
		beltl = /obj/item/reagent_containers/glass/bottle/alchemical/healthpot
	head = /obj/item/clothing/head/roguetown/menacing/mad_touched_treasure_hunter
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/menacing/bandit/mad_touched_treasure_hunter //IS THIS TRVE?!
	if(prob(33))
		r_hand = /obj/item/rogueweapon/greatsword/paalloy
	else if(prob(33))
		r_hand = /obj/item/rogueweapon/shield/buckler
		l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
	else
		r_hand = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
		l_hand = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
		ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC) //Making them an absolute menace again

	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	//carbon ai is still pretty dumb so making them a threat to players requires pretty crazy looking stats. don't think too hard about it.
	H.STASTR = 15
	H.STASPD = 15
	H.STACON = 12
	H.STAWIL = 12
	H.STAPER = 15
	H.STAINT = 12

	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	if(prob(40))
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

/obj/item/clothing/head/roguetown/menacing/bandit/mad_touched_treasure_hunter //its here so it doesnt wind up on some class' loadout.
	name = "sack hood"
	desc = "A ragged hood of thick red dyed jute fibres. The itchiness is unbearable."
	sewrepair = TRUE
	armor = ARMOR_LEATHER

/obj/item/clothing/head/roguetown/menacing/mad_touched_treasure_hunter //its here so it doesnt wind up on some class' loadout.
	name = "sack hood"
	desc = "A ragged hood of thick jute fibres. The itchiness is unbearable."
	sewrepair = TRUE
	color = "#999999"
	armor = ARMOR_LEATHER

/obj/item/clothing/mask/rogue/facemask/steel/paalloy/mad_touched
	name = "eerie ancient mask"

/obj/item/clothing/mask/rogue/facemask/steel/paalloy/mad_touched/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_WEAR_MASK)
		ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
		var/mob/living/carbon/human/mad_touched = user
		mad_touched.apply_damage(25, BRUTE, BODY_ZONE_HEAD)

/obj/item/clothing/mask/rogue/facemask/steel/paalloy/mad_touched/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/archer
	ai_controller = /datum/ai_controller/human_npc/archer
	mad_outfit = /datum/outfit/job/roguetown/human/species/human/northern/mad_touched_treasure_hunter/archer

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/archer/ambush
	threat_point = THREAT_DANGEROUS
	ambush_faction = "treasure_hunters"

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/archer/after_creation()
	..()
	job = "Mad-touched Marksman"

/datum/outfit/job/roguetown/human/species/human/northern/mad_touched_treasure_hunter/archer/pre_equip(mob/living/carbon/human/H)
	..()
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backl = /obj/item/quiver/randomfill/highwayman
	beltr = /obj/item/quiver/randomfill/highwayman
	H.STACON -= 1
	H.STAWIL -= 1
	H.adjust_skillrank(/datum/skill/combat/bows, 5, TRUE)

/datum/ambush_config/solo_treasure_hunter
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/ambush = 1,
	)
	threat_point = THREAT_ELITE
	faction_tag = "treasure_hunters"

/datum/ambush_config/duo_treasure_hunter
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/ambush = 2,
	)
	threat_point = 2 * THREAT_ELITE
	faction_tag = "treasure_hunters"

/datum/ambush_config/treasure_hunter_posse
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/ambush = 3,
	)
	threat_point = 3 * THREAT_ELITE
	faction_tag = "treasure_hunters"
