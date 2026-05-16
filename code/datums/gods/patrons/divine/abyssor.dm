/datum/patron/divine/abyssor
	name = "Abyssor"
	domain = "The great dreamer, primordial father of the tides. The ancient one, the most warped and potent of the ten."
	desc = "The strongest of the Ten; when awakened, the world flooded for a thousand daes and a thousand nights before he was put to slumber. Resting fitfully did Dendor split from his skull like a gaping wound. Communes rarely with his followers, only offering glimpses in dreams. Gifted primordial Man water. "
	worshippers = "Men of the Sea, Primitive Aquatics"
	mob_traits = list(TRAIT_ABYSSOR_SWIM, TRAIT_SEA_DRINKER)
	miracles = list(/datum/action/cooldown/spell/touch/orison					= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/aquatic_compulsion	= CLERIC_T0,
					/obj/effect/proc_holder/spell/self/abyssor_wind				= CLERIC_T0,
					/datum/action/cooldown/spell/miracle/heal 					= CLERIC_T1,
					/datum/action/cooldown/spell/miracle/bloodmiracle			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/abyssor_bends			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/abyssor_undertow		= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/abyssheal				= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/call_mossback			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/call_dreamfiend		= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/abyssal_infusion		= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/resurrect/abyssor		= CLERIC_T4,
	)
	confess_lines = list(
		"ABYSSOR COMMANDS THE WAVES!",
		"THE OCEAN'S FURY IS ABYSSOR'S WILL!",
		"I AM DRAWN BY THE PULL OF THE TIDE!",
	)
	titles = list(
		"Dreamer",
		"Forgotten One"
	)

	storyteller = /datum/storyteller/abyssor

// Near water, cross, or within the church.
/datum/patron/divine/abyssor/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer near any body of water turf.
	for(var/turf/open/water in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Abyssor to hear my prayer I must either pray within the church, near a psycross, or at any body of water so that the tides of prayer may flow.."))
	return FALSE

/datum/patron/divine/abyssor/on_lesser_heal(
    mob/living/user,
    mob/living/target,
    message_out,
    message_self,
    conditional_buff,
    situational_bonus
)
	*message_out = span_info("A mist of salt-scented vapour settles on [target]!")
	*message_self = span_notice("I'm invigorated by healing vapours!")

	if(istype(get_turf(target), /turf/open/water))
		*conditional_buff = TRUE
		*situational_bonus = 1.5
