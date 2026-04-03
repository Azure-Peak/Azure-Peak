/datum/patron/divine/undivided
	name = "Undivided"
	domain = "The Divine, Lyfe, Death, Existence."
	desc = "Ten Eternal, Divine Pantheon United, Bulwark against the Darkness. The Ten dilligently watch over their flock granting them potent boons, but not every man catches the attention of merely one. Take lessons from all from them all, for they are your masters and mentors."
	worshippers = "Commonfolk, Grenzelhoft, Holy See Clergymen, Pragmatists of the Ten."
	mob_traits = list(TRAIT_UNDIVIDED)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison					= CLERIC_ORI,
					/obj/effect/proc_holder/spell/self/twinned_gaze						= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/ignition/undivided			= CLERIC_T0,
					/datum/action/cooldown/spell/darkvision/miracle/undivided			= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/recuperation					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/perseverance					= CLERIC_T2,
					/obj/effect/proc_holder/spell/self/undivided_miracle_bundle 		= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/heal/undivided				= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/gallowshumor					= CLERIC_T3,
					/obj/effect/proc_holder/spell/self/ten_united						= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/resurrect/undivided			= CLERIC_T4
	)
	confess_lines = list(
		"THE HOLY DECAGRAM SHALL SHIELD MY SOUL!",
		"I SERVE THE PANTHEON RESPLENDENT!",
		"THE TEN ETERNAL, FOREVERMORE!",
	)
	storyteller = /datum/storyteller/astrata // no unique storyteller for this one, since its so broad. No real reason to have a unique storyteller - Undivided contributes to ecah of the Ten's follower count.

/datum/patron/divine/undivided/can_pray(mob/living/follower)
	. = ..()
	// Undivided - More restricted, needs to be within range of a pantheon cross or the church itself.
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE

/datum/patron/divine/undivided/on_lesser_heal(
    mob/living/user,
    mob/living/target,
    message_out,
    message_self,
    conditional_buff,
    situational_bonus
)
	*message_out = span_info("A wreath of holy power passes over [target]!") // we're always good.
	*message_self = ("I'm bathed in holy power!")

	*conditional_buff = TRUE
	*situational_bonus = 2
