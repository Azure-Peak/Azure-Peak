/datum/round_event_control/antagonist/solo/werewolf
	name = "Verevolfs"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_WEREWOLF
	shared_occurence_type = SHARED_HIGH_THREAT

	denominator = 50

	base_antags = 2
	maximum_antags = 2
	min_players = 25
	weight = 7

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/werewolf
	antag_datum = /datum/antagonist/werewolf

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES

/datum/round_event/antagonist/solo/werewolf
