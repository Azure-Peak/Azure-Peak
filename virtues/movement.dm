/datum/virtue/movement/acrobatic
	name = "Acrobatic"
	desc = "I have powerful legs, allowing me to land precisely where I want to, even with a running start."
	added_traits = list(TRAIT_LEAPER, TRAIT_NOFALLDAMAGE1)

/datum/virtue/movement/equestrian
	name = "Equestrian"
	desc = "My mount understands me. We've worked together as one on our difficult journey. I can navigate through doors and other small gaps without getting thrown off my saddle."
	added_skills = list(list(/datum/skill/misc/riding, 1, 6))
	added_traits = list(TRAIT_EQUESTRIAN)
	added_stashed_items = list("Saddle" = /obj/item/natural/saddle)

/datum/virtue/movement/equestrian/apply_to_human(mob/living/carbon/human/recipient)
	new /mob/living/simple_animal/hostile/retaliate/rogue/goatmale/tame(get_turf(recipient))
