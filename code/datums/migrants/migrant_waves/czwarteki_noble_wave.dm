/datum/migrant_wave/czwarteki_noble
	name = "Czwarteki Retinue"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/czwarteki_noble
	weight = 25
	downgrade_wave = /datum/migrant_wave/czwarteki_noble_down_one
	roles = list(
		/datum/migrant_role/czwarteki/lord = 1,
		/datum/migrant_role/czwarteki/heir = 1,
		/datum/migrant_role/czwarteki/hussar = 2,
		/datum/migrant_role/czwarteki/journeyman = 4,
		/datum/migrant_role/czwarteki/servant = 2,
	)
	greet_text = "You are a Retinue under a Czwarteki Lord, be it diplomacy, war, or simple passing through the Vale to see or assist an old alliance."

/datum/migrant_wave/czwarteki_noble_down_one
	name = "Czwarteki Retinue"
	shared_wave_type = /datum/migrant_wave/czwarteki_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/czwarteki_noble_down_two
	roles = list(
		/datum/migrant_role/czwarteki/lord = 1,
		/datum/migrant_role/czwarteki/heir = 1,
		/datum/migrant_role/czwarteki/hussar = 2,
		/datum/migrant_role/czwarteki/journeyman = 3,
		/datum/migrant_role/czwarteki/servant = 2,
	)
	greet_text = "You're part of a retinue aiding one of Tomorzurkh's many Lords in their travels - be it for diplomacy, conflict, or just passing through Azuria for reasons yet to be discovered."

/datum/migrant_wave/czwarteki_noble_down_two
	name = "Tomorzurkh Lord's Retinue"
	shared_wave_type = /datum/migrant_wave/czwarteki_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/czwarteki_noble_down_three
	roles = list(
		/datum/migrant_role/czwarteki/lord = 1,
		//datum/migrant_role/czwarteki/heir = 1,
		//datum/migrant_role/czwarteki/hussar = 2,
		//datum/migrant_role/czwarteki/journeyman = 2,
		//datum/migrant_role/czwarteki/servant = 2,
	)
	greet_text = "You're part of a retinue aiding one of Tomorzurkh's many Lords in their travels - be it for diplomacy, conflict, or just passing through Azuria for reasons yet to be discovered."

/datum/migrant_wave/czwarteki_noble_down_three
	name = "Tomorzurkh Lord's Retinue"
	shared_wave_type = /datum/migrant_wave/czwarteki_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/czwarteki_noble_down_four
	roles = list(
		//datum/migrant_role/czwarteki/lord = 1,
		/datum/migrant_role/czwarteki/heir = 1,
		//datum/migrant_role/czwarteki/hussar = 2,
		//datum/migrant_role/czwarteki/journeyman = 2,
		//datum/migrant_role/czwarteki/servant = 1,
	)
	greet_text = "You're part of a retinue aiding one of Tomorzurkh's many Lords in their travels - be it for diplomacy, conflict, or just passing through Azuria for reasons yet to be discovered."

/datum/migrant_wave/czwarteki_noble_down_four
	name = "Tomorzurkh Lord's Retinue"
	shared_wave_type = /datum/migrant_wave/czwarteki_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/czwarteki_noble_down_five
	roles = list(
		//datum/migrant_role/czwarteki/lord = 1,
		//datum/migrant_role/czwarteki/heir = 1,
		//datum/migrant_role/czwarteki/hussar = 2,
		//datum/migrant_role/czwarteki/journeyman = 2,
		/datum/migrant_role/czwarteki/servant = 1,
	)
	greet_text = "You're part of a retinue aiding one of Tomorzurkh's many Lords in their travels - be it for diplomacy, conflict, or just passing through Azuria for reasons yet to be discovered."

/datum/migrant_wave/czwarteki_noble_down_five
	name = "Tomorzurkh Lord's Retinue"
	shared_wave_type = /datum/migrant_wave/czwarteki_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/czwarteki_noble_down_six
	roles = list(
		//datum/migrant_role/czwarteki/lord = 1,
		//datum/migrant_role/czwarteki/heir = 1,
		/datum/migrant_role/czwarteki/hussar = 1,
		//datum/migrant_role/czwarteki/journeyman = 1,
		//datum/migrant_role/czwarteki/servant = 1,
	)
	greet_text = "You're part of a retinue aiding one of Tomorzurkh's many Lords in their travels - be it for diplomacy, conflict, or just passing through Azuria for reasons yet to be discovered."

/datum/migrant_wave/czwarteki_noble_down_six
	name = "Tomorzurkh Lord's Retinue"
	shared_wave_type = /datum/migrant_wave/czwarteki_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/czwarteki_noble_down_seven
	roles = list(
		//datum/migrant_role/czwarteki/lord = 1,
		//datum/migrant_role/czwarteki/heir = 1,
		//datum/migrant_role/czwarteki/hussar = 1,
		/datum/migrant_role/czwarteki/journeyman = 1,
	)
	greet_text = "You're part of a retinue aiding one of Tomorzurkh's many Lords in their travels - be it for diplomacy, conflict, or just passing through Azuria for reasons yet to be discovered."

/datum/migrant_wave/czwarteki_noble_down_seven
	name = "Tomorzurkh Lord's Retinue"
	shared_wave_type = /datum/migrant_wave/czwarteki_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/czwarteki_noble_down_eight
	roles = list(
		/datum/migrant_role/czwarteki/lord = 1,
		/datum/migrant_role/czwarteki/heir = 1,
		/datum/migrant_role/czwarteki/hussar = 1,
	)
	greet_text = "You're part of a retinue aiding one of Tomorzurkh's many Lords in their travels - be it for diplomacy, conflict, or just passing through Azuria for reasons yet to be discovered."


/datum/migrant_wave/czwarteki_noble_down_eight
	name = "Tomorzurkh Lord's Retinue"
	shared_wave_type = /datum/migrant_wave/czwarteki_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/czwarteki_noble_down_nine
	roles = list(
		/datum/migrant_role/czwarteki/lord = 1,
		/datum/migrant_role/czwarteki/hussar = 1,
	)
	greet_text = "You're part of a retinue aiding one of Tomorzurkh's many Lords in their travels - be it for diplomacy, conflict, or just passing through Azuria for reasons yet to be discovered."

/datum/migrant_wave/czwarteki_noble_down_nine
	name = "Czwarteki Retinue"
	shared_wave_type = /datum/migrant_wave/czwarteki_noble
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/czwarteki/lord = 1,
	)
	greet_text = "You're part of a retinue aiding one of Tomorzurkh's many Lords in their travels - be it for diplomacy, conflict, or just passing through Azuria for reasons yet to be discovered."
