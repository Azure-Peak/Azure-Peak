/datum/round_event_control/antagonist/solo/masquerade
	name = "Masquerade"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_VAMPIRE
	shared_occurence_type = SHARED_HIGH_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	storyteller_pill_label = "Masquerade"
	storyteller_rumour_name = "a vampire masquerade"
	storyteller_slot_key = "Masquerade"

	weight = 8

	denominator = 80

	base_antags = 2
	maximum_antags = 2

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/masquerade
	antag_datum = /datum/antagonist/vampire

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES

/datum/round_event/antagonist/solo/masquerade/add_datum_to_mind(datum/mind/antag_mind)
	var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(forced_clan = FALSE, generation = GENERATION_ANCILLAE)
	antag_mind.add_antag_datum(new_antag)
