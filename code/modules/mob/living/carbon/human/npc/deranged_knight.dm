/* *
 * Deranged Knight
 * A miniboss for quest system, designed to be a high-level challenge for multiple players.
 * Gear uses /datum/component/item_on_drop/dust to crumble on removal, preventing looting.
 */

GLOBAL_LIST_INIT(matthios_aggro, world.file2list("strings/rt/matthiosaggrolines.txt"))
GLOBAL_LIST_INIT(zizo_aggro, world.file2list("strings/rt/zizoaggrolines.txt"))
GLOBAL_LIST_INIT(graggar_aggro, world.file2list("strings/rt/graggaraggrolines.txt"))
GLOBAL_LIST_INIT(hedgeknight_aggro, world.file2list("strings/rt/hedgeknightaggrolines.txt"))

/mob/living/carbon/human/species/human/northern/deranged_knight
	ai_controller = /datum/ai_controller/human_npc
	d_intent = INTENT_PARRY
	faction = list(FACTION_DUNDEAD)
	ambushable = FALSE
	cmode = 1
	setparrytime = 20
	dodgetime = 20
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)

/mob/living/carbon/human/species/human/northern/deranged_knight/Initialize(mapload)
	. = ..()
	//Begin RANDOMISE here
	set_species(pick(NPC_RACES_TYPES))
	gender = pick(MALE, FEMALE)
	dna.species.random_character(src) //Now we just randomise here, MUST be called after both race + gender
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/deranged_knight/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Ascendant Knight"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)

	for(var/obj/item/equipped_item in get_equipped_items() + held_items)
		equipped_item.AddComponent(/datum/component/item_on_drop/dust)
	for(var/obj/item/held_item in held_items)
		ADD_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)

	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.hedgeknight_aggro, TRUE)

	regenerate_icons()

	random_voice_NPC()
	random_hair_no_beard_NPC()
	random_eye_color_NPC()
	correct_features_NPC()

	if(prob(1))
		real_name = "Taras Mura"
	update_hair()
	update_body()

/mob/living/carbon/human/species/human/northern/deranged_knight/death(gibbed, nocutscene)
	emote("painscream")
	. = ..()
	if(!gibbed)
		dust(FALSE, FALSE, TRUE)

/datum/outfit/job/roguetown/quest_miniboss/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()

	if(prob(60))
		var/voicepack_choice = rand(1, 6)
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
			if(5)
				H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/wizard]
				H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]
			if(6)
				H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/evil]
				H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]
/*
 * Goon preset
 * Intended to support knight, but should not have any special/overly expensive gear.
*/

/mob/living/carbon/human/species/human/northern/highwayman/dk_goon
	faction = list(FACTION_DUNDEAD)

/mob/living/carbon/human/species/human/northern/deranged_knight/zizo
	npc_archetype = /datum/npc_archetype/deranged_knight/zizo

/mob/living/carbon/human/species/human/northern/deranged_knight/zizo_heavy
	npc_archetype = /datum/npc_archetype/deranged_knight/zizo_heavy

/mob/living/carbon/human/species/human/northern/deranged_knight/graggar
	npc_archetype = /datum/npc_archetype/deranged_knight/graggar

/mob/living/carbon/human/species/human/northern/deranged_knight/graggar_heavy
	npc_archetype = /datum/npc_archetype/deranged_knight/graggar_heavy

/mob/living/carbon/human/species/human/northern/deranged_knight/matthios
	npc_archetype = /datum/npc_archetype/deranged_knight/matthios_heavy

/mob/living/carbon/human/species/human/northern/deranged_knight/baotha
	d_intent = INTENT_DODGE
	npc_archetype = /datum/npc_archetype/deranged_knight/baotha
