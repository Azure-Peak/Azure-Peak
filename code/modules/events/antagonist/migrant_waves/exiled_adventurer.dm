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
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN
	storyteller_midround_antag_flags = STORYTELLER_ANTAG_VILLAIN

/datum/round_event_control/antagonist/migrant_wave/werewolf/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE
	var/player_count = SSgamemode.get_correct_popcount()
	var/max_werewolves = SSgamemode.story_antag_slots(SSgamemode.storyteller_scale_slots(SSgamemode.story_antag_slot_cap(/datum/antagonist/werewolf, TRUE), player_count), /datum/antagonist/werewolf, player_count)
	if(max_werewolves <= 1)
		return FALSE
	var/current_werewolves = 0
	for(var/mob/living/living as anything in GLOB.mob_living_list)
		if(living.mind?.has_antag_datum(/datum/antagonist/werewolf))
			current_werewolves++
	return current_werewolves < max_werewolves

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
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN
	storyteller_midround_antag_flags = STORYTELLER_ANTAG_VILLAIN

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
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN
	storyteller_midround_antag_flags = STORYTELLER_ANTAG_VILLAIN

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
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN
	storyteller_midround_antag_flags = STORYTELLER_ANTAG_VILLAIN

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
