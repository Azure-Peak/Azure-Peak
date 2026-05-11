/datum/migrant_wave/knightly_journey
	name = "The Knightly Journey"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/knightly_journey
	downgrade_wave = /datum/migrant_wave/knightly_journey_down_one
	weight = 50
	roles = list(
		/datum/migrant_role/kj_knight = 1,
		/datum/migrant_role/kj_squire = 1,
	)

/datum/migrant_wave/knightly_journey_down_one
	name = "The Knightly Journey"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/knightly_journey
	downgrade_wave = /datum/migrant_wave/knightly_journey_down_two
	roles = list(
		/datum/migrant_role/kj_knight = 1,
		/datum/migrant_role/kj_squire = 1,
	)

/datum/migrant_wave/knightly_journey_down_two
	name = "The Knightly Journey"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/knightly_journey
	roles = list(
		/datum/migrant_role/kj_knight = 1,
		/datum/migrant_role/kj_squire = 1,
	)
