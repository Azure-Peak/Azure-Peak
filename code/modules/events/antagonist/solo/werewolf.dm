/datum/round_event_control/antagonist/solo/werewolf
	name = "Verevolfs"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN
	storyteller_favor_flags = STORYTELLER_FAVOR_WEREWOLF
	storyteller_guarantee_flags = STORYTELLER_FAVOR_WEREWOLF
	storyteller_favor_multiplier = 2
	antag_flag = ROLE_WEREWOLF
	shared_occurence_type = SHARED_HIGH_THREAT

	denominator = 50

	base_antags = 1
	maximum_antags = 2
	min_players = 25
	weight = 7

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/werewolf
	antag_datum = /datum/antagonist/werewolf

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES

/datum/round_event/antagonist/solo/werewolf

/datum/round_event_control/antagonist/solo/werewolf/get_base_antag_amount(player_count = null)
	if(isnull(player_count))
		player_count = SSgamemode.get_correct_popcount()
	var/max_slots = SSgamemode.story_antag_slot_cap(antag_datum, TRUE)
	return SSgamemode.storyteller_scale_slots(max_slots, player_count, FALSE, SSgamemode.story_antag_scaling_step(antag_datum, antag_scaling), SSgamemode.story_antag_min_players(antag_datum))

/datum/round_event_control/antagonist/solo/werewolf/get_antag_amount()
	var/player_count = SSgamemode.get_correct_popcount()
	var/amount = SSgamemode.story_antag_slots(get_base_antag_amount(player_count), antag_datum, player_count)
	return guaranteed_villain_cap(amount, player_count)
