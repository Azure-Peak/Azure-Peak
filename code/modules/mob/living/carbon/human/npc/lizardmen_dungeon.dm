GLOBAL_LIST_INIT(psyvault_aggro, world.file2list("strings/rt/psyvaultaggrolines.txt"))
//These guys are intended to be no joke, if they are getting stomped something is wrong
//Intended difficulty [HARD]
/mob/living/carbon/human/species/lizardfolk/psy_vault_guard
	race = /datum/species/lizardfolk
	faction = list(FACTION_PSY_VAULT_GUARD)
	ambushable = FALSE
	cmode = 1
	setparrytime = 20
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)
	var/big_guy_lizard = TRUE

	npc_archetype = /datum/npc_archetype/psy_vault_guard/guardian

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/Initialize(mapload)
	. = ..()
	gender = pick(MALE, FEMALE)
	set_species(/datum/species/lizardfolk)
	if(!npc_archetype)
		spawn(10) // To prevent dropping weapons
			after_creation()

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/after_creation()
	..()
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.psyvault_aggro, TRUE)
	//This Stuff handles their parts
	var/obj/item/organ/tail/lizard/tail = src.getorganslot(ORGAN_SLOT_TAIL)
	var/obj/item/organ/snout/lizard/psy_vault_guard/snout = src.getorganslot(ORGAN_SLOT_SNOUT)
	var/obj/item/organ/ears/psy_vault_guard/ears = src.getorganslot(ORGAN_SLOT_EARS)
	if(tail)
		tail.Remove(src,1)
		QDEL_NULL(tail)
	tail = new /obj/item/organ/tail/lizard
	tail.Insert(src)
	if(snout)
		snout.Remove(src,1)
		QDEL_NULL(snout)
	snout = new /obj/item/organ/snout/lizard/psy_vault_guard
	snout.Insert(src)
	if(ears)
		ears.Remove(src,1)
		QDEL_NULL(ears)
	ears = new /obj/item/organ/ears/psy_vault_guard
	ears.Insert(src)
	//This Stuff handles their parts
	job = "Zardman Jailer"
	real_name = "Zardman Jailer"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/lizardfolk/psy_vault_guard)
	update_overlays()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = HEAD_BOUNTY_LIZARDMAN
	//are we beeg?
	if(big_guy_lizard)
		transform = transform.Scale(1.25, 1.25)
		transform = transform.Translate(0, 0.25 * 16)
		update_transform()
	src.regenerate_icons() //Fixes the weird body but lets check performance first

/datum/outfit/job/roguetown/human/species/lizardfolk/psy_vault_guard/pre_equip(mob/living/carbon/human/H)
	..()
	//Body Stuff
	H.skin_tone = "e9d298"
	//purity afloat
	H.grant_language(/datum/language/otavan)
	//cause there's naledians in that vault too now
	H.grant_language(/datum/language/celestial)
	ADD_TRAIT(H, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
	if(prob(60))
		var/voicepack_choice = rand(1, 3)
		switch(voicepack_choice)
			if(1)
				H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior]
				H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]
			if(2)
				H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/stern]
				H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/haughty]
			if(3)
				H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/knight]
				H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/haughty]

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/magemonk
	npc_archetype = /datum/npc_archetype/psy_vault_guard/magemonk
	big_guy_lizard = FALSE

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/magemonk_entry
	npc_archetype = /datum/npc_archetype/psy_vault_guard/magemonk_entry
	big_guy_lizard = FALSE

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/archer
	npc_archetype = /datum/npc_archetype/psy_vault_guard/archer
	big_guy_lizard = FALSE

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/caster
	npc_archetype = /datum/npc_archetype/psy_vault_guard/caster/mixed
	big_guy_lizard = FALSE

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/caster/cryomancer
	npc_archetype = /datum/npc_archetype/psy_vault_guard/caster/cryomancer
	big_guy_lizard = FALSE

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/caster/telomancer
	npc_archetype = /datum/npc_archetype/psy_vault_guard/caster/telomancer
	big_guy_lizard = FALSE

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/caster/fulgurmancer
	npc_archetype = /datum/npc_archetype/psy_vault_guard/caster/fulgurmancer
	big_guy_lizard = FALSE
