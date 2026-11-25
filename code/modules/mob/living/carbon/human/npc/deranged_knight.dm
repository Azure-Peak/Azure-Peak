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
	var/preset_title ="the untitled"

/mob/living/carbon/human/species/human/northern/deranged_knight/Initialize(mapload)
	. = ..()
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
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	var/list/aggro_lines
	switch(preset_lines)
		if("graggar")
			preset_title = pick("of Graggar","the Butcherer","Orphanbane","the Warlord","Blood-Chosen","the Bloody","of the Darkstar","of the Sinistar","the Chainbreaker","the Unshackled","the War-Born","the Murderer","Bane of Peace","the Herald of Graggar","the Culler","the Slaughterer of Lambs")
			aggro_lines = GLOB.graggar_aggro
		if("matthios")
			preset_title = pick("the Rich","of Equal Exchange","the Opulant","of the Gilded Flame","Fyre-Kindled","the Brigand","of Matthios","of the Transactor","the Free","the Wealthy","of the Kindled Pyre","of the Gilded Drakkyn","the Herald of Matthios","of the Gilded Exchange","of the Gilded Camaraderie")
			aggro_lines = GLOB.matthios_aggro
		if("zizo")
			preset_title = pick("of Zizo","of the Avantyne Legion","bane of the Hallowed","the Defiler","the Shadow-Blessed","the Insane","sworn-in-her-name","the Herald of Progress","the Herald of Zizo","the Luxbane","of the Dark Shield","of Shadows","the Truesighted","the Truth-Seeker","of the Pale Lady")
			aggro_lines = GLOB.zizo_aggro
			src.grant_language(/datum/language/undead)
		if("baotha")
			preset_title = pick("of Baotha","the Heartache","the Indulgent","the Mirthful","the Never-Sober","the Manic","of the Spider","the Herald of Baotha","the Herald of Heartache","the Luxdrinker","of the The Overflowing Goblet","of the Lady of Heartache","of the Lady of Pleasure")
			aggro_lines = GLOB.baotha_aggro
		if("hedgeknight")
			preset_title = pick("the Outlawed","the Brigand","the Disgraced","the Bastard","of the Outcast","disgrace of Azuria","the Unchained","the Boss","the Wall","the Unbreakable","the Warlord","the Deserter","the Gauntlet","the Uncrushable","the Unstoppable")
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
	else
		real_name = "[real_name] [preset_title]" //give us a fancy title. based on patron.
	update_hair()
	update_body()

/mob/living/carbon/human/species/human/northern/deranged_knight/death(gibbed, nocutscene)
	if(prob(50))
		if(preset_lines == "matthios")
			if(prob(95))
				say(pick("Matthios, I have failed you...","My lord... I tried...","The weight of myne wealth was too much...","My final... Transaction..?","Myne wealth hath... become woe..?"), forced = TRUE, npc_speech = TRUE)
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
				say("YOU ARE EVERRRRRYTHING!!!", forced = TRUE, npc_speech = TRUE)
	emote("painscream")
	. = ..()
	if(!gibbed)
		if(preset_lines == "matthios")
			playsound(src, 'sound/effects/matth_barter.ogg', 100)
			var/turf/T = get_turf(src)
			new /obj/effect/temp_visual/barter_fx(T) //hilarious
		dust(FALSE, FALSE, TRUE)
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

/mob/living/carbon/human/species/human/northern/deranged_knight/hedgeknight
	npc_archetype = /datum/npc_archetype/deranged_knight/hedgeknight
	preset_lines = "hedgeknight"
