/datum/language/thievescant
	name = "Thieves' Jargon"
	desc = "A tongue of knaves and free men, nobody reputable would be able to speak it."
	speech_verb = "says"
	ask_verb = "asks"
	exclaim_verb = "yells"
	key = "y"
	flags = TONGUELESS_SPEECH | SIGNLANG
	space_chance = 66
	default_priority = 80
	icon_state = "thief"
	spans = list(SPAN_PAPYRUS)
	signlang_verb = list(
		"bellows",
		"belches",
		"slaps their face",
		"loudly sniffs",
		"smacks their lips",
		"taps their temple",
		"burps",
		"spits on the floor",
		"inhales",
		"draws out a sigh",
		"rapidly blinks",
		"snaps their fingers",
		"claps their hands",
		"puts a thumbs up",
		"raises their middle finger",
		"drools",
	)
