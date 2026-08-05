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
	dodgetime = 30
	var/preset = "matthios"
	var/forced_preset = "" // If set, force a specific preset instead of randomizing.



/mob/living/carbon/human/species/human/northern/deranged_knight/Initialize()
	. = ..()
	//Begin RANDOMISE here
	set_species(pick(NPC_RACES_TYPES))
	gender = pick(MALE, FEMALE)
	dna.species.random_character(src) //Now we just randomise here, MUST be called after both race + gender
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/deranged_knight/proc/outfit_dk(datum/outfit/outfit)
	if(!outfit)
		return
	equipOutfit(outfit)
	// Apply dust-on-drop to all equipped gear so it can't be looted via dismemberment or stripping.
	// TRAIT_NODROP on held items prevents grab disarming.
	for(var/obj/item/equipped_item in get_equipped_items() + held_items)
		equipped_item.AddComponent(/datum/component/item_on_drop/dust)
	for(var/obj/item/held_item in held_items)
		ADD_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)

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
	if(forced_preset)
		preset = forced_preset
	else
		switch(rand(1, 4))
			if(1)
				preset = "graggar"
			if(2)
				preset = "matthios"
			if(3)
				preset = "zizo"
			if(4)
				preset = "hedgeknight"
	switch(preset)
		if("graggar")
			ADD_TRAIT(src, TRAIT_HORDE, TRAIT_GENERIC)
			outfit_dk(new /datum/outfit/job/roguetown/quest_miniboss/graggar)
		if ("matthios")
			ADD_TRAIT(src, TRAIT_FREEMAN, TRAIT_GENERIC)
			outfit_dk(new /datum/outfit/job/roguetown/quest_miniboss/matthios)
		if ("zizo")
			ADD_TRAIT(src, TRAIT_CABAL, TRAIT_GENERIC)
			src.grant_language(/datum/language/undead)
			outfit_dk(new /datum/outfit/job/roguetown/quest_miniboss/zizo)
		if ("hedgeknight")
			if(prob(50))
				outfit_dk(new /datum/outfit/job/roguetown/quest_miniboss/hedge_knight)
			else
				outfit_dk(new /datum/outfit/job/roguetown/quest_miniboss/blacksteel)
			// No special trait for hedgeknight, he's just a generic tough guy.

	var/list/aggro_lines
	switch(preset)
		if("graggar")
			aggro_lines = GLOB.graggar_aggro
		if("matthios")
			aggro_lines = GLOB.matthios_aggro
		if("zizo")
			aggro_lines = GLOB.zizo_aggro
		if("hedgeknight")
			aggro_lines = GLOB.hedgeknight_aggro
	if(aggro_lines)
		SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, aggro_lines, TRUE)

	regenerate_icons()

	random_voice_NPC()
	random_hair_no_beard_NPC()
	random_eye_color_NPC()
	correct_features_NPC()

	if(prob(1))
		real_name = "Taras Mura"
	update_hair()
	update_body()

	def_intent_change(INTENT_PARRY)


/mob/living/carbon/human/species/human/northern/deranged_knight/death(gibbed, nocutscene)
	if(preset == "matthios")
		if(prob(95))
			say("Matthios, I have failed you...", forced = TRUE, npc_speech = TRUE)
		else
			say("Matthios, is this true?!", forced = TRUE, npc_speech = TRUE)
	else if(preset == "zizo")
		if(prob(95))
			say("Zizo, forgive me!", forced = TRUE, npc_speech = TRUE)
		else
			say("We lyve in a Zociety...", forced = TRUE, npc_speech = TRUE)
	else if(preset == "graggar")
		if(prob(95))
			say("No more... Blood!", forced = TRUE, npc_speech = TRUE)
		else
			say("WHERE'S THE BLOOD?!!", forced = TRUE, npc_speech = TRUE)
	emote("painscream")
	. = ..()
	if(!gibbed)
		dust(FALSE, FALSE, TRUE)

/datum/outfit/job/roguetown/quest_miniboss/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.STASTR = 15
	H.STASPD = 14
	H.STACON = 12
	H.STAWIL = 12
	H.STAPER = 12
	H.STAINT = 12
	H.STALUC = 10

	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE) //No more swimming cheese
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

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

/datum/outfit/job/roguetown/quest_miniboss/matthios/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/matthios
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/matthios
	pants = /obj/item/clothing/under/roguetown/platelegs/matthios
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/matthios
	wrists = /obj/item/clothing/wrists/roguetown/bracers/matthios
	gloves = /obj/item/clothing/gloves/roguetown/plate/matthios
	head = /obj/item/clothing/head/roguetown/helmet/heavy/matthios
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle/matthios
	r_hand = /obj/item/rogueweapon/flail/peasantwarflail/matthios
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios //IS THIS TRVE?!

/datum/outfit/job/roguetown/quest_miniboss/zizo/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/zizo
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo
	pants = /obj/item/clothing/under/roguetown/platelegs/zizo/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/zizo
	wrists = /obj/item/clothing/wrists/roguetown/bracers/zizo
	gloves = /obj/item/clothing/gloves/roguetown/plate/zizo/heavy
	head = /obj/item/clothing/head/roguetown/helmet/heavy/zizo
	neck = /obj/item/clothing/neck/roguetown/bevor/zizo
	r_hand = /obj/item/rogueweapon/sword/long/zizo
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/g //ZIZO. ZIZO. ZIZO. (golden inverted cross)

/datum/outfit/job/roguetown/quest_miniboss/graggar/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/graggar
	pants = /obj/item/clothing/under/roguetown/platelegs/graggar
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/graggar
	gloves = /obj/item/clothing/gloves/roguetown/plate/graggar
	wrists = /obj/item/clothing/wrists/roguetown/bracers/graggar
	head = /obj/item/clothing/head/roguetown/helmet/heavy/graggar
	neck = /obj/item/clothing/neck/roguetown/gorget/steel/graggar
	r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead/graggar
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	cloak = /obj/item/clothing/cloak/graggar
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar //SHATTER MY BINDS

/datum/outfit/job/roguetown/quest_miniboss/blacksteel/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel/modern
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather/steel
	pants = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blacksteel/modern
	gloves = /obj/item/clothing/gloves/roguetown/plate/blacksteel/modern
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	head = /obj/item/clothing/head/roguetown/helmet/blacksteel/modern
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	r_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel //I am evil, yes.
	wrists = /obj/item/clothing/wrists/roguetown/bracers

/datum/outfit/job/roguetown/quest_miniboss/hedge_knight/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	pants = /obj/item/clothing/under/roguetown/platelegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	gloves = /obj/item/clothing/gloves/roguetown/plate
	head = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	r_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/sword/long
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	cloak = /obj/item/clothing/cloak/tabard/stabard/black

/*
 * Goon preset
 * Intended to support knight, but should not have any special/overly expensive gear.
*/

/mob/living/carbon/human/species/human/northern/highwayman/dk_goon
	faction = list(FACTION_DUNDEAD)

/mob/living/carbon/human/species/human/northern/deranged_knight/matthios
	forced_preset = "matthios"

/mob/living/carbon/human/species/human/northern/deranged_knight/zizo
	forced_preset = "zizo"

/mob/living/carbon/human/species/human/northern/deranged_knight/graggar
	forced_preset = "graggar"

/mob/living/carbon/human/species/human/northern/deranged_knight/hedgeknight
	forced_preset = "hedgeknight"
