/datum/patron/vheslyn
	name = "Vheslyn"
	domain = "Unreality. The space in between your world and nothingness. The back of your amygdala."
	desc = "The Archdevil, the Great Worm, the Earth Mover, the Leviathan, the Defiler, the Unmaker. The rottting worm at the center of a discarded apple. The embodiment of pure evil that seeketh to sunder the world in fire and agony, to return it all to nonexistence. There will be no forgiveness or mercy for you, and you will give none in return."
	worshippers = "Accelerationists, Extremists, Nihilists, Sadists, Freaks, Wretches, and You."
	associated_faith = /datum/faith/accelerationism
	mob_traits = list(TRAIT_UNFORGIVABLE, TRAIT_DNR, TRAIT_NOMOOD, TRAIT_DETACHED, TRAIT_NOPAIN, TRAIT_NOPAINSTUN, TRAIT_PSYCHOSIS) //You're not humen, no, there's no humenity in you.
	preference_accessible = TRUE
	undead_hater = TRUE
	//Intended more as final bouts of unholy spite, confessing will violently kill YOU and the PERSON doing a confession from you.
	confess_lines = list(
		"HELL IS REAL!! LET CHAOS BE OUR LAMPTERN!!",
		"KILL THEM ALL, ALL OF THEM!!",
		"I KNOW WHAT I AM!! DO YOU KNOW WHAT YOU ARE?!!",
	)

	//literally evil incarnate, there are no holy casters, there are no miracles. You have to draw power from something... else..
	//Also because Vheslyn is fucking dead, you're shit outta luck sire, the COMET SYON ended the archdevil. You're more of... a reminant of that corruption.

/datum/patron/vheslyn/can_pray(mob/living/follower) //You already knew that answer
	. = ..()
	. = FALSE
	to_chat(follower, span_userdanger(pick("... NOTHING RESPONDS, GOOD ...", "... THE WORLD GROWS SILENT, AS IT SHOULD BE ...", "... BUT NOTHING RESPONDED ...", "... SILENCE, TASTE OF SWEET OBLIVION ...")))
	to_chat(follower, span_bloody("I SEE YOU."))
	return FALSE
