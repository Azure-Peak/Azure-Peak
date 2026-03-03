/datum/patron/divine/pestra
	name = "Pestra"
	domain = "Goddess of Decay, Disease and Medicine"
	desc = "Goddess that blessed many a saint with healing hands, Pestra taught man the arts of medicine and its benefits."
	worshippers = "The Sick, Phyicians, Apothecaries"
	mob_traits = list(TRAIT_EMPATH, TRAIT_ROT_EATER)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/diagnose				= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/pestra_leech			= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/infestation			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/pestilent_blade		= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/pestra_heal			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/attach_bodypart		= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/heal					= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/cure_rot				= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/pestra		= CLERIC_T4,
	)
	confess_lines = list(
		"PESTRA SOOTHES ALL ILLS!",
		"DECAY IS A CONTINUATION OF LIFE!",
		"MY AFFLICTION IS MY TESTAMENT!",
	)
	storyteller = /datum/storyteller/pestra

// Near a well, cross, within the physicians, or within the church
/datum/patron/divine/pesta/can_pray(mob/living/follower)
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
	// Allows prayer in the appothocary's building.
	if(istype(get_area(follower), /area/rogue/indoors/town/physician))
		return TRUE
	// Allows prayer near wells. Weird one, but makes sense for health and disease. Miasma, water, etc.
	for(var/obj/structure/well/W in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Pestra to hear my prayer I must either pray within the church, phyisican's building, near a psycross, or near a well to observe the full circle of life.."))
	return FALSE

/datum/patron/divine/pestra/on_lesser_heal(
    mob/living/user,
    mob/living/target,
    message_out,
    message_self,
    conditional_buff,
    situational_bonus
)
	*message_out = span_info("An aura of clinical care encompasses [target]!")
	*message_self = span_notice("I'm sewn back together by sacred medicine!")

	if(iscarbon(target))
		var/mob/living/carbon/carbon = target
		if(!(carbon.mobility_flags & MOBILITY_STAND) && !carbon.buckled) // activate when your target is laying on the floor, not limited to critical state
			*conditional_buff = TRUE
			*situational_bonus = 1 // finally pestra wont be the only line of miracle caster with a 2.5 lesser miracle regen
			target.adjustToxLoss(-*situational_bonus*15) // flat 15 tox healing on lesser miracle effect application
			target.blood_volume = min(target.blood_volume + (BLOOD_VOLUME_SURVIVE / 3), BLOOD_VOLUME_NORMAL) // actually this time around it cannot overcap blood!
