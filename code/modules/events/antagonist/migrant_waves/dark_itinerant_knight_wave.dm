/datum/round_event_control/antagonist/migrant_wave/evil_knight
	name = "The Unknightly Journey"
	wave_type = /datum/migrant_wave/evil_knight

	weight = 6
	max_occurrences = 1

	earliest_start = 10 MINUTES

	tags = list(
		TAG_HAUNTED,
		TAG_COMBAT,
		TAG_VILLIAN,
	)

/datum/migrant_wave/evil_knight
	name = "The Unknightly Journey"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/evil_knight
	weight = 8
	roles = list(
		/datum/migrant_role/dark_itinerant_knight = 1,
		/datum/migrant_role/dark_itinerant_squire = 1,
	)
	greet_text = "These lands have insulted once more Zizo, you are here to remind them of her prowess."

/datum/migrant_role/dark_itinerant_knight
	name = "Zizite Knight"
	greet_text = "You are an evil itinerant Knight, you have embarked alongside your squire on a voyage to engulf chaos within these lands."
	antag_datum = /datum/antagonist/zizo_knight
	grant_lit_torch = TRUE

/datum/migrant_role/dark_itinerant_squire
	name = "Underling Squire"
	greet_text = "You are the squire of an evil knight, they have taken you under their custody as you were the only one who didn't object to their dubious ethics."
	antag_datum = /datum/antagonist/zizo_knight/squire
	grant_lit_torch = TRUE

