/mob/living/carbon/human/proc/become_skeleton()
	set_species(/datum/species/human/northern)

	for(var/datum/charflaw/cf in charflaws)
		charflaws.Remove(cf)
		QDEL_NULL(cf)
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"
	mob_biotypes = MOB_UNDEAD
	var/obj/item/organ/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src, TRUE)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(src)
	for(var/obj/item/bodypart/B in bodyparts)
		B.skeletonize(FALSE)
	base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/simple/claw)
	update_a_intents()

	update_body()
	update_hair()
	update_body_parts(redraw = TRUE)

	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_FACELESS_KNOWN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIMBATTACHMENT, TRAIT_GENERIC)

	// Skeleton voicepack
	if(dna?.species)
		dna.species.soundpack_m = new /datum/voicepack/skeleton()
		dna.species.soundpack_f = new /datum/voicepack/skeleton()

	// Undead language
	grant_language(/datum/language/undead)


	// Offer to clear flavor text / OOC notes since they likely don't match a skeleton
	if(flavortext || ooc_notes)
		var/clear_choice = alert(src, "Your character is now a skeleton. Would you like to clear your flavor text and OOC notes?", "Skeleton Transformation", "Clear Both", "Keep Both")
		if(clear_choice == "Clear Both")
			if(flavortext)
				flavortext = null
				flavortext_cached = ""
			if(ooc_notes)
				ooc_notes = null
				ooc_notes_cached = ""
