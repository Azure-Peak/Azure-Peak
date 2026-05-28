/datum/patron/vheslyn
	name = "Vheslyn"
	domain = "Unreality. The space in between your world and nothingness. The back of your amygdala."
	desc = "The Archdevil, the Great Worm, the Earth Mover, the Leviathan, the Defiler, the Unmaker. The rottting worm at the center of a discarded apple. The embodiment of pure evil that seeketh to sunder the world in fire and agony, to return it all to nonexistence. There will be no forgiveness or mercy for you, and you will give none in return."
	worshippers = "EMPTY FUCKING HUSKS, THE BROKEN, THE HURT, THE IGNORED. THE DESPERATE, THE HURT, THE ONES WHO HURT YOU. MURDERERS AND KILLERS AND HUNTERS. NO INNOCENTS. NEVER INNOCENTS."
	associated_faith = /datum/faith/accelerationism
	mob_traits = list(TRAIT_UNFORGIVABLE, TRAIT_DNR, TRAIT_NOMOOD, TRAIT_DETACHED, TRAIT_NOPAIN, TRAIT_NOPAINSTUN, TRAIT_PSYCHOSIS) //You're not humen, no, there's no humenity in you.
	profane_words = list("psydon", "allfather") //SPEAKETH ALL THOU SIN THOU WISH, BUT SPEAK NAUGHT THE NAME O' THE DECIEVER
	preference_accessible = FALSE //LOL, NO
	undead_hater = TRUE
	//Unforgivable evil to a comedic extent.
	confess_lines = list(
		"HELL IS REAL! CHAOS WILL ALWAYS TRIUMPH!",
		"FORGET SALVATION! PUT A FYRE TO THE GARDEN!",
		"THE WEEPER WEEPS NO MORE! SOON THE WORLD WILL JOIN!",
		"KILL THEM ALL, ALL OF THEM! YOU CANNOT STOP FATE!",
		"I KNOW WHAT I AM! DO YOU KNOW WHAT YOU ARE?!",
	)

	//I guess, not like it matters sire, Vheslyn is dead
	titles = list(
		"Great Worm",
		"Leviathan",
		"Defiler",
		"Unmaker",
		"Archdevil",
		"Earth Mover"
	)

	//literally evil incarnate, there are no holy casters, there are no miracles. You have to draw power from something... else..
	//Also because Vheslyn is fucking dead, you're shit outta luck sire, the COMET SYON ended the archdevil. You're more of... a reminant of that corruption.

/datum/patron/vheslyn/can_pray(mob/living/follower) //You already knew that answer
	. = ..()
	. = FALSE
	to_chat(follower, span_userdanger(pick("... NOTHING RESPONDS ...", "... THE WORLD GROWS SILENT ...", "... BUT NOTHING RESPONDED ...", "... SILENCE, TASTE OF SWEET OBLIVION ...")))
	return FALSE
