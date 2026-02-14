/datum/migrant_wave/grenzel_envoy
	name = "Grenzelhoftian Envoy"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/grenzel_envoy
	weight = 25
	downgrade_wave = /datum/migrant_wave/grenzel_envoy_down_one
	roles = list(
		/datum/migrant_role/grenzel/envoy = 1,
		/datum/migrant_role/grenzel/bodyguard = 2,
		/datum/migrant_role/grenzel/priest = 1,
	)
	greet_text = "You are a Grenzelhoftian envoy, traveling with bodyguards and a priest to represent your homeland."

/datum/migrant_wave/grenzel_envoy_down_one
	name = "Grenzelhoftian Envoy"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/grenzel_envoy
	downgrade_wave = /datum/migrant_wave/grenzel_envoy_down_two
	roles = list(
		/datum/migrant_role/grenzel/envoy = 1,
		/datum/migrant_role/grenzel/bodyguard = 1,
		/datum/migrant_role/grenzel/priest = 1,
	)
	greet_text = "You are a Grenzelhoftian envoy, traveling with bodyguards and a priest to represent your homeland."

/datum/migrant_wave/grenzel_envoy_down_two
	name = "Grenzelhoftian Envoy"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/grenzel_envoy
	downgrade_wave = /datum/migrant_wave/grenzel_envoy_down_three
	roles = list(
		/datum/migrant_role/grenzel/envoy = 1,
		/datum/migrant_role/grenzel/bodyguard = 2,
	)
	greet_text = "You are a Grenzelhoftian envoy, traveling with bodyguards and a priest to represent your homeland."

/datum/migrant_wave/grenzel_envoy_down_three
	name = "Grenzelhoftian Envoy"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/grenzel_envoy
	downgrade_wave = /datum/migrant_wave/grenzel_envoy_down_four
	roles = list(
		/datum/migrant_role/grenzel/envoy = 1,
		/datum/migrant_role/grenzel/bodyguard = 1,
	)
	greet_text = "You are a Grenzelhoftian envoy, traveling with bodyguards and a priest to represent your homeland."

/datum/migrant_wave/grenzel_envoy_down_four
	name = "Grenzelhoftian Envoy"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/grenzel_envoy
	downgrade_wave = /datum/migrant_wave/grenzel_envoy_down_five
	roles = list(
		/datum/migrant_role/grenzel/envoy = 1,
		/datum/migrant_role/grenzel/priest = 1,
	)
	greet_text = "You are a Grenzelhoftian envoy, traveling with bodyguards and a priest to represent your homeland."

/datum/migrant_wave/grenzel_envoy_down_five
	name = "Grenzelhoftian Envoy"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/grenzel_envoy
	roles = list(
		/datum/migrant_role/grenzel/envoy = 1,
	)
	greet_text = "You are a Grenzelhoftian envoy, traveling with bodyguards and a priest to represent your homeland."
