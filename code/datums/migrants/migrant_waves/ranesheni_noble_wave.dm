/datum/migrant_wave/ranesheni_noble
	name = "Ranesheni Emir"
	track = MIGRANT_TRACK_SPECIAL
	max_spawns = 1
	weight = 50
	required_roles = list(
		/datum/migrant_role/ranesheni/emir = 1,
	)
	optional_roles = list(
		/datum/migrant_role/ranesheni/amirah = 1,
		/datum/migrant_role/ranesheni/janissary = 2,
		/datum/migrant_role/ranesheni/advisor = 1,
	)
	min_optional_fills = 1
	greet_text = "You are far from home on missive from the Ranesheni Empire."
