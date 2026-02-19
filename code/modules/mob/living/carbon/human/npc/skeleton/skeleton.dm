/mob/living/carbon/human/species/skeleton
	name = "skeleton"

	race = /datum/species/human/northern
	gender = MALE
	bodyparts = list(/obj/item/bodypart/chest, /obj/item/bodypart/head, /obj/item/bodypart/l_arm,
					 /obj/item/bodypart/r_arm, /obj/item/bodypart/r_leg, /obj/item/bodypart/l_leg)
	faction = list("undead")
	var/skel_outfit = /datum/outfit/job/roguetown/npc/skeleton
	var/skel_fragile = FALSE
	ambushable = FALSE
	rot_type = null
	base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw)
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_SPECIAL, INTENT_JUMP, INTENT_KICK, INTENT_BITE)
	cmode_music = 'sound/music/combat_weird.ogg'

/mob/living/carbon/human/species/skeleton/npc
	aggressive = 1
	mode = NPC_AI_IDLE
	wander = FALSE
	skel_fragile = TRUE
	npc_jump_chance = 0 // no jumping skeletons
	rude = TRUE

/mob/living/carbon/human/species/skeleton/npc/ambush

	wander = TRUE

/mob/living/carbon/human/species/skeleton/Initialize()
	. = ..()
	cut_overlays()
	spawn(10)
		after_creation()

/mob/living/carbon/human/species/skeleton/after_creation()
	..()
	if(dna && dna.species)
		dna.species.species_traits |= NOBLOOD
		dna.species.soundpack_m = new /datum/voicepack/skeleton()
		dna.species.soundpack_f = new /datum/voicepack/skeleton()
	for(var/datum/charflaw/cf in charflaws)
		charflaws.Remove(cf)
		QDEL_NULL(cf)
	name = "Skeleton"
	real_name = "Skeleton"
	voice_type = VOICE_TYPE_MASC //So that "Unknown Man" properly substitutes in with face cover
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_LIMBATTACHMENT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	if(skel_fragile)
		ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	else
		ADD_TRAIT(src, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC) // If not fragile, then you're summoned by a real antag
		// Therefore you get the trait to grind up to Jman.
	skeletonize()
	if(skel_outfit)
		var/datum/outfit/OU = new skel_outfit
		if(OU)
			equipOutfit(OU)

/mob/living/carbon/human/species/skeleton/fully_heal(admin_revive = FALSE, break_restraints = FALSE)
	. = ..()
	skeletonize()

/mob/living/carbon/human/species/skeleton/proc/skeletonize()
	mob_biotypes |= MOB_UNDEAD
	var/obj/item/bodypart/O = get_bodypart(BODY_ZONE_R_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	O = get_bodypart(BODY_ZONE_L_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	regenerate_limb(BODY_ZONE_R_ARM)
	regenerate_limb(BODY_ZONE_L_ARM)
	var/obj/item/organ/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)
	eyes = SSwardrobe.provide_type(/obj/item/organ/eyes/night_vision/zombie)
	eyes.Insert(src)
	for(var/obj/item/bodypart/B in bodyparts)
		B.skeletonize(FALSE)
	update_body()

/mob/living/carbon/human/species/skeleton/npc/no_equipment
	skel_outfit = null

/mob/living/carbon/human/species/skeleton/no_equipment
	skel_outfit = null
	var/datum/weakref/crystal

/mob/living/carbon/human/species/skeleton/no_equipment/death(gibbed, nocutscene = FALSE)
	..()
	var/obj/item/necro_relics/necro_crystal/active_crystal = crystal.resolve()
	for(var/datum/weakref/W in active_crystal.active_skeletons)
		if(W.resolve() == src)
			active_crystal.active_skeletons -= W
	active_crystal = null
	gib(no_brain = TRUE, no_organs = TRUE)
