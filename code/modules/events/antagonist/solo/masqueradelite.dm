/datum/round_event_control/antagonist/solo/masqueradelite
	name = "Masquerade lite"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_VAMPIRE
	shared_occurence_type = SHARED_MINOR_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_ROUNDSTART | STORYTELLER_ANTAG_MEDIUM
	storyteller_pill_label = "Masquerade Lite"
	storyteller_rumour_name = "a vampire masquerade with only towners"
	storyteller_slot_key = "Masquerade Lite"

	weight = 8

	denominator = 80

	base_antags = 2
	maximum_antags = 2
	min_players = 40

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/masqueradelite
	antag_datum = /datum/antagonist/vampire

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_COMBAT_ROLES

/datum/round_event/antagonist/solo/masqueradelite/add_datum_to_mind(datum/mind/antag_mind)
	var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(forced_clan = FALSE, generation = GENERATION_ANCILLAE)
	antag_mind.add_antag_datum(new_antag)
