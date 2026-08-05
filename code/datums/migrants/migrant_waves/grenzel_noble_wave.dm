/datum/migrant_wave/grenzel_envoy
	name = "Grenzelhoftian Envoy"
	track = MIGRANT_TRACK_SPECIAL
	max_spawns = 1
	weight = 50
	required_roles = list(
		/datum/migrant_role/grenzel/envoy = 1,
	)
	optional_roles = list(
		/datum/migrant_role/grenzel/bodyguard = 2,
		/datum/migrant_role/grenzel/priest = 1,
	)
	min_optional_fills = 1
	greet_text = "You are a Grenzelhoftian envoy, traveling with bodyguards and a priest to represent your homeland."
