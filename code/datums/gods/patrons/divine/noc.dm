/datum/patron/divine/noc
	name = "Noc"
	domain = "God of the Moon, Night, Knowledge and Arcyne"
	desc = "The Nite-Scholar, brother and rival to Astrata. His wisdom paves the way in the moonlight. Tales of esoteric magicka at the destination are sung - in the words of decaying scripts."
	worshippers = "Wizards and Scholars"
	mob_traits = list(TRAIT_NIGHT_OWL)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/noc_sight				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/darkvision/miracle	= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/moondream             = CLERIC_T0,
					/obj/effect/proc_holder/spell/self/wise_moon                = CLERIC_T1,
					/obj/effect/proc_holder/spell/self/moon_light     			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/invisibility/miracle	= CLERIC_T1,
					/obj/effect/proc_holder/spell/self/blindnessorsilence		= CLERIC_T2,
					/obj/effect/proc_holder/spell/self/noc_spell_bundle			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/noc			= CLERIC_T4,
	)
	confess_lines = list(
		"NOC IS NIGHT!",
		"NOC SEES ALL!",
		"I SEEK THE MYSTERIES OF THE MOON!",
	)
	traits_tier = list(TRAIT_DARKVISION = CLERIC_T1)
	storyteller = /datum/storyteller/noc

// In moonlight, church, cross, or ritual chalk
/datum/patron/divine/noc/can_pray(mob/living/follower)
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
	// Allows prayer during nightime if outside.
	if(istype(get_area(follower), /area/rogue/outdoors) && (GLOB.tod == "night" || GLOB.tod == "dusk"))
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/noc in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Noc to hear my prayer I must either be in his blessed moonlight, within the church, or near a psycross."))
	return FALSE

/datum/patron/divine/noc/on_lesser_heal(
    mob/living/user,
    mob/living/target,
    message_out,
    message_self,
    conditional_buff,
    situational_bonus
)
	*message_out = span_info("A shroud of soft moonlight falls upon [target]!")
	*message_self = span_notice("I'm shrouded in gentle moonlight!")

	if(GLOB.tod == "night")
		*conditional_buff = TRUE
