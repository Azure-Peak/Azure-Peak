/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog
	name = "bog troll"
	desc = "Elven legends say these monsters were servants of Dendor tasked to guard his realm; nowadays they are sometimes found in the company of orcs. It's said that fire curbs their almost magical regeneration."
	pixel_x = -16
	threat_point = THREAT_DANGEROUS

	wander = FALSE		// bog trolls are ambush predators
	turns_per_move = 4
	see_in_dark = 10

	melee_damage_lower = 30
	melee_damage_upper = 50
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES

	STACON = 16
	STASTR = 16
	STASPD = 3
	STAWIL = 15

	defprob = 30
	dodgetime = 15

/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC)	// bogtroll does not mind kneestingers

/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog/after_creation()
	..()
	var/obj/item/organ/eyes/eyes = src.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/nightmare
	eyes.Insert(src)
