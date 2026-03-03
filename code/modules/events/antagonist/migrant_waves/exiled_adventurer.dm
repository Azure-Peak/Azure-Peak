/datum/round_event_control/antagonist/migrant_wave/werewolf
	name = "Exiled Werewolf"
	wave_type = /datum/migrant_wave/werewolf

	weight = 4
	max_occurrences = 2

	earliest_start = 25 MINUTES

	tags = list(
		TAG_HAUNTED,
		TAG_VILLIAN,
		TAG_COMBAT,
	)

/datum/migrant_wave/werewolf
	name = "Exiled Adventurer (Verevolf)"
	roles = list(
		/datum/migrant_role/werewolf = 1,
	)
	can_roll = FALSE

/datum/migrant_role/werewolf
	name = "Adventurer"
	antag_datum = /datum/antagonist/werewolf
	advclass_cat_rolls = list(CTAG_ADVENTURER = 5)

/datum/round_event_control/antagonist/migrant_wave/vampire
	name = "Exiled Vampire"
	wave_type = /datum/migrant_wave/vampire

	weight = 4
	max_occurrences = 2

	earliest_start = 25 MINUTES

	tags = list(
		TAG_HAUNTED,
		TAG_COMBAT,
		TAG_VILLIAN,
	)

/datum/migrant_wave/vampire
	name = "Exiled Adventurer (Vampire)"
	roles = list(
		/datum/migrant_role/vampire = 1,
	)
	can_roll = FALSE

/datum/migrant_role/vampire
	name = "Adventurer"
	antag_datum = /datum/antagonist/vampire
	advclass_cat_rolls = list(CTAG_ADVENTURER = 5)

/datum/round_event_control/antagonist/migrant_wave/unbound_death_knight
	name = "Death knight (Unbound)"
	wave_type = /datum/migrant_wave/unbound_death_knight

	weight = 6
	max_occurrences = 2

	earliest_start = 10 MINUTES

	tags = list(
		TAG_HAUNTED,
		TAG_COMBAT,
		TAG_VILLIAN,
	)

/datum/migrant_wave/unbound_death_knight
	name = "Death knight (Unbound)"
	roles = list(
		/datum/migrant_role/unbound_death_knight = 1,
	)
	can_roll = FALSE

/datum/migrant_role/unbound_death_knight
	name = "Adventurer"
	antag_datum = /datum/antagonist/unbound_death_knight
	advclass_cat_rolls = null

/datum/round_event_control/antagonist/migrant_wave/unbound_spellblade
	name = "Ancient Spellblade (Unbound)"
	wave_type = /datum/migrant_wave/unbound_spellblade

	weight = 6
	max_occurrences = 2

	earliest_start = 10 MINUTES

	tags = list(
		TAG_HAUNTED,
		TAG_COMBAT,
		TAG_VILLIAN,
	)

/datum/migrant_wave/unbound_spellblade
	name = "Ancient Spellblade (Unbound)"
	roles = list(
		/datum/migrant_role/unbound_spellblade = 1,
	)
	can_roll = FALSE

/datum/migrant_role/unbound_spellblade
	name = "Adventurer"
	antag_datum = /datum/antagonist/unbound_spellblade
	advclass_cat_rolls = null
