/datum/migrant_wave/fablefield
	name = "The Fablefield Troupe"
	track = MIGRANT_TRACK_SPECIAL
	max_spawns = 1
	weight = 20
	required_roles = list(
		/datum/migrant_role/fablefield/goliard = 1,
	)
	optional_roles = list(
		/datum/migrant_role/fablefield/troubadour = 3,
	)
	min_optional_fills = 1
	greet_text = "A troupe of troubadours from fair Fablefield, you travel to Azure Peak seeking inspiration, drawn at every step seemingly by the whims of Xylix. The people here look like they could do with a good show, give them one they'll remember!"
