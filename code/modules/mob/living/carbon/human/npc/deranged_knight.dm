/* *
 * Deranged Knight
 * A miniboss for quest system, designed to be a high-level challenge for multiple players.
 * Gear uses /datum/component/item_on_drop/dust to crumble on removal, preventing looting.
 */

GLOBAL_LIST_INIT(matthios_aggro, world.file2list("strings/rt/matthiosaggrolines.txt"))
GLOBAL_LIST_INIT(zizo_aggro, world.file2list("strings/rt/zizoaggrolines.txt"))
GLOBAL_LIST_INIT(graggar_aggro, world.file2list("strings/rt/graggaraggrolines.txt"))
GLOBAL_LIST_INIT(baotha_aggro, world.file2list("strings/rt/baothaaggrolines.txt"))
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
	var/preset_lines = "hedgeknight"

/mob/living/carbon/human/species/human/northern/deranged_knight/Initialize(mapload)
	. = ..()
	//Begin RANDOMISE here
	gender = pick(MALE, FEMALE)
	dna.species.random_character(src) //Now we just randomise here, MUST be called after both race + gender
	cut_overlays()
	if(!npc_archetype)
		spawn(10) // To prevent dropping weapons
			after_creation()

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
	var/list/aggro_lines
	switch(preset_lines)
		if("graggar")
			aggro_lines = GLOB.graggar_aggro
		if("matthios")
			aggro_lines = GLOB.matthios_aggro
		if("zizo")
			aggro_lines = GLOB.zizo_aggro
			src.grant_language(/datum/language/undead)
		if("baotha")
			aggro_lines = GLOB.baotha_aggro
		if("hedgeknight")
			aggro_lines = GLOB.hedgeknight_aggro
	if(aggro_lines)
		SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, aggro_lines, TRUE)

	for(var/obj/item/equipped_item in get_equipped_items() + held_items)
		equipped_item.AddComponent(/datum/component/item_on_drop/dust)
	for(var/obj/item/held_item in held_items)
		ADD_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)

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
	if(prob(50))
		if(preset_lines == "matthios")
			if(prob(95))
				say(pick("Matthios, I have failed you...","My lord... I tried...","The weight of myne wealth was too much...","My final... Transaction..?"), forced = TRUE, npc_speech = TRUE)
			else
				say("Matthios, is this true?!", forced = TRUE, npc_speech = TRUE)
		else if(preset_lines == "zizo")
			if(prob(95))
				say(pick("Zizo, forgive me!","Zizo, one last... chance...","Death is never... The end...?","Failure... How...?","Not like this... Zizo..."), forced = TRUE, npc_speech = TRUE)
			else
				say("We lyve in a Zociety...", forced = TRUE, npc_speech = TRUE)
		else if(preset_lines == "graggar")
			if(prob(95))
				say(pick("NO... More... Blood...","Shatter... My..-","I feel... calm...?","This... Cannot be...","Free at... Last...","Failure...? N-No..."), forced = TRUE, npc_speech = TRUE)
			else
				say("WHERE'S THE BLOOD?!!", forced = TRUE, npc_speech = TRUE)
		else if(preset_lines == "baotha")
			if(prob(95))
				say(pick("Where's the high...","I just... Wanted to be happy..","It hurts... So much","I... Don't feel so good..","My... Greatest end..?"), forced = TRUE, npc_speech = TRUE)
			else
				say("YOU ARE EVERRRRRYTHING BOATHAAAA!!!", forced = TRUE, npc_speech = TRUE)
	emote("superagony")
	. = ..()
	if(!gibbed)
		if(preset_lines == "matthios")
			playsound(src, 'sound/effects/matth_barter.ogg', 100)
			src.visible_message(span_matthios("[src] is unmade by gilded light for their [pick("debt's repayment","failure","final transaction","final exchange","insolence")]!"))
			var/turf/T = get_turf(src)
			new /obj/effect/temp_visual/barter_fx(T)
		if(preset_lines == "graggar")
			playsound(src, 'sound/magic/graggar_bloodrush.ogg', 100)
			src.visible_message(span_graggar("[src] is unmade by motive force after their [pick("pitiful fight","failure","worthy fight","loss to another","insolence")]!"))
		if(preset_lines == "zizo")
			playsound(src, 'sound/misc/zizo.ogg', 100)
			src.visible_message(span_zizo("[src] is unmade by profane magic for their [pick("ignorance","failure","backwards ways","stagnation","insolence")]!"))
		if(preset_lines == "baotha")
			playsound(src, 'sound/magic/baotha_blessdrink.ogg', 100)
			src.visible_message(span_baotha("[src] is unmade by a prismatic mist for their [pick("greatest end","failure","joyless demise","lack of true indulgence","insolence")]!"))
		gib()
		//dust(FALSE, FALSE, TRUE)

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
	npc_archetype = /datum/npc_archetype/deranged_knight/zizo/mixed
	preset_lines = "zizo"

/mob/living/carbon/human/species/human/northern/deranged_knight/zizo_heavy
	npc_archetype = /datum/npc_archetype/deranged_knight/zizo_heavy/mixed
	preset_lines = "zizo"

/mob/living/carbon/human/species/human/northern/deranged_knight/graggar
	npc_archetype = /datum/npc_archetype/deranged_knight/graggar
	preset_lines = "graggar"

/mob/living/carbon/human/species/human/northern/deranged_knight/graggar_heavy
	npc_archetype = /datum/npc_archetype/deranged_knight/graggar_heavy
	preset_lines = "graggar"

/mob/living/carbon/human/species/human/northern/deranged_knight/matthios
	npc_archetype = /datum/npc_archetype/deranged_knight/matthios_heavy
	preset_lines = "matthios"

/mob/living/carbon/human/species/human/northern/deranged_knight/baotha
	d_intent = INTENT_DODGE
	npc_archetype = /datum/npc_archetype/deranged_knight/baotha
	preset_lines = "baotha"
