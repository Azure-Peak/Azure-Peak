/datum/round_event_control/antagonist/solo/dreamwalker
	name = "Dreamwalker"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	//Can roll at any time.
	roundstart = FALSE
	storyteller_antag_flags = STORYTELLER_ANTAG_SOFT
	storyteller_favor_flags = STORYTELLER_FAVOR_DREAMWALKER
	storyteller_guarantee_flags = STORYTELLER_FAVOR_DREAMWALKER
	storyteller_favor_multiplier = 2
	antag_flag = ROLE_DREAMWALKER
	shared_occurence_type = SHARED_MINOR_THREAT

	denominator = 80

	base_antags = 1
	maximum_antags = 2

	weight = 18
	max_occurrences = 2

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/dreamwalker
	antag_datum = /datum/antagonist/dreamwalker

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES

/datum/round_event/antagonist/solo/dreamwalker
