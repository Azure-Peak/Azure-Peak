/datum/round_event_control/antagonist/solo/lich
	name = "Lich"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN
	storyteller_favor_flags = STORYTELLER_FAVOR_LICH
	storyteller_guarantee_flags = STORYTELLER_FAVOR_LICH
	storyteller_favor_multiplier = 2
	antag_flag = ROLE_LICH
	shared_occurence_type = SHARED_HIGH_THREAT

	denominator = 80

	base_antags = 1
	maximum_antags = 1

	weight = 2	//i hate you
	max_occurrences = 1 // mashallah

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/lich
	antag_datum = /datum/antagonist/lich

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES

/datum/round_event/antagonist/solo/lich
