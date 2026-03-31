/datum/patron/divine/undivided
	name = "Undivided"
	domain = "The Sun, the Moon, Earth, Justice, Freedom, the Seas, Creation, Inspiration, Death, Decay, Love, Healing, and Life."
	desc = "A United Pantheon, Stalwart against the Darkness. The Ten grant lessons and boons to mortals. The primary form of worship being a generalist approach to worshipping all Ten, and taking lessons from all. This is the primary theology of the Grenzelhoft Holy See."
	worshippers = "Holy See Clergymen. Pragmatists of the Ten."
	mob_traits = list(TRAIT_UNDIVIDED)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI, // ONLY Lower miracles of other lists. A much more varied utility miracle list, and a much wider selection. Also, our generic miracles(Lesser heal + Divine blast for acolytes) are better. But no specialization makes a lower level list. We're going to exclude Abyssor.
					/obj/effect/proc_holder/spell/self/astrata_gaze				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/darkvision/miracle	= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/bless_food            = CLERIC_T1,
					/obj/effect/proc_holder/spell/self/divine_strike			= CLERIC_T2,
					/obj/effect/proc_holder/spell/targeted/blesscrop			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/avert					= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/infestation			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/mockery				= CLERIC_T3, // you'll have to be a real xylix templar to get this pretty decent combat debuff, sorry.
					/obj/effect/proc_holder/spell/invoked/conjure_tool			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/undivided	= CLERIC_T4
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
