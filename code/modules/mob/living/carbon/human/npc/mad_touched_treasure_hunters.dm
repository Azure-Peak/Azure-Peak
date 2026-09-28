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
	npc_archetype = /datum/npc_archetype/mad_touched/hunter

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/ambush
	threat_point = THREAT_ELITE
	ambush_faction = "treasure_hunters"

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/Initialize(mapload)
	. = ..()
	//Begin RANDOMISE here
	set_species(pick(NPC_RACES_TYPES))
	gender = pick(MALE, FEMALE)
	dna.species.random_character(src) //Now we just randomise here, MUST be called after both race + gender
	if(!npc_archetype)
		addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
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
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = HEAD_BOUNTY_MAD_TOUCHED
	dna.species.handle_body(src)
	random_voice_NPC()
	random_hair_no_beard_NPC()
	random_eye_color_NPC()
	roll_mad_touched_voice()
	var/obj/item/organ/ears/organ_ears = getorgan(/obj/item/organ/ears)
	if(organ_ears)
		organ_ears.accessory_colors = "[src.skin_tone]"

	dna.species.handle_body(src)

	real_name = pick(world.file2list("strings/rt/names/human/mad_touched_names.txt"))

	update_hair()
	update_body()
	src.regenerate_icons() //Fixes the weird body

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/proc/roll_mad_touched_voice()
	if(!prob(40))
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
			dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/knight]
			dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/haughty]

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
	npc_archetype = /datum/npc_archetype/mad_touched/marksman

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/archer/ambush
	threat_point = THREAT_ELITE
	ambush_faction = "treasure_hunters"

/datum/npc_warband/solo_treasure_hunter
	name = "Lone Treasure Hunter"
	category = FACTION_MADMEN
	faction_tag = "treasure_hunters"
	members = list(
		/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/ambush = 1,
	)

/datum/npc_warband/duo_treasure_hunter
	name = "Treasure Hunter Pair"
	category = FACTION_MADMEN
	faction_tag = "treasure_hunters"
	members = list(
		/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/ambush = 2,
	)

/datum/npc_warband/treasure_hunter_posse
	name = "Treasure Hunter Posse"
	category = FACTION_MADMEN
	faction_tag = "treasure_hunters"
	members = list(
		/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/ambush = 3,
	)
