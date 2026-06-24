/datum/patron/divine/astrata
	name = "Astrata"
	domain = "Goddess of the Sun, Dae, and Order"
	desc = "The Tyrant of the Ten, sister and rival to Noc - and the eldest of them all. Her radiance keeps the evils at bay during the dae. Nite, however, is a different tale."
	worshippers = "Zealots, Farmers, and the Noble-Hearted"
	mob_traits = list(TRAIT_APRICITY)
	miracles = list(/datum/action/cooldown/spell/touch/orison				= CLERIC_ORI,
					/datum/action/cooldown/spell/astrata/ignition			= CLERIC_T0,
					/datum/action/cooldown/spell/astrata/astrata_gaze		= CLERIC_T0,
					/datum/action/cooldown/spell/miracle/heal		 		= CLERIC_T1,
					/datum/action/cooldown/spell/miracle/bloodmiracle		= CLERIC_T1,
					/datum/action/cooldown/spell/projectile/sacred_flame	= CLERIC_T1,
					/datum/action/cooldown/spell/astrata/bladeorfist		= CLERIC_T2,
					/datum/action/cooldown/spell/miracle/fortify/astrata	= CLERIC_T2,
					/datum/action/cooldown/spell/astrata/miracle_pyre    	= CLERIC_T3,
					/datum/action/cooldown/spell/astrata/firecloak		    = CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/revive			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/immolation		= CLERIC_T4,
	)
	confess_lines = list(
		"ASTRATA IS MY LIGHT!",
		"ASTRATA BRINGS LAW!",
		"I SERVE THE GLORY OF THE SUN!",
	)
	storyteller = /datum/storyteller/astrata
	titles = list(
		"Tyrant",
		"Overtyrant",
		"Sun", // should match any sort of Sun(x) title
		"Aisata"
	)

// In daylight, church, cross, or ritual chalk.
/datum/patron/divine/astrata/can_pray(mob/living/follower)
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
	// Allows prayer during daytime if outside.
	if(istype(get_area(follower), /area/rogue/outdoors) && (GLOB.tod == "day" || GLOB.tod == "dawn"))
		return TRUE
	to_chat(follower, span_danger("For Astrata to hear my prayer I must either be in her blessed daylight, within the church, or near a psycross.."))
	return FALSE

/datum/patron/divine/astrata/on_lesser_heal(
    mob/living/user,
    mob/living/target,
    message_out,
    message_self,
    conditional_buff,
    situational_bonus
)
	*message_out = span_info("A wreath of gentle light passes over [target]!")
	*message_self = ("I'm bathed in holy light!")

	if(GLOB.tod == "day")
		*conditional_buff = TRUE
		*situational_bonus = 2

	if(HAS_TRAIT(target, TRAIT_NOBLE)) //We heal her favorites more.
		*conditional_buff = TRUE
		*situational_bonus = 2.5
