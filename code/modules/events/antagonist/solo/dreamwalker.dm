/datum/round_event_control/antagonist/solo/dreamwalker
	name = "Dreamwalker"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	//Can roll at any time.
	roundstart = FALSE
	antag_flag = ROLE_DREAMWALKER
	shared_occurence_type = SHARED_MINOR_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_SOFT
	storyteller_guarantee_flags = STORYTELLER_FAVOR_DREAMWALKER

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

/datum/round_event_control/antagonist/solo/dreamwalker/roundstart
	name = "Dreamwalker"
	roundstart = TRUE
	min_players = CHARACTER_INJECTION_MIN_POP
	base_antags = 2
	maximum_antags = 2
	max_occurrences = 1
	allowed_storytellers = list(/datum/storyteller/abyssor)
