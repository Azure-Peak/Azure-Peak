/datum/round_event_control/antagonist/solo/werewolflite
	name = "Verevolfs Lite"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_WEREWOLF
	shared_occurence_type = SHARED_MINOR_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_ROUNDSTART | STORYTELLER_ANTAG_MEDIUM
	storyteller_pill_label = "Verevolfs Lite"
	storyteller_rumour_name = "Verevolfs Lite"
	storyteller_slot_key = "Verevolfs Lite"


	denominator = 50

	base_antags = 2
	maximum_antags = 2
	min_players = 40
	weight = 7

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/werewolflite
	antag_datum = /datum/antagonist/werewolf/noinfect

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_COMBAT_ROLES

/datum/round_event_control/antagonist/solo/werewolf/preRunEvent()
	if(is_storyteller_villain_blocked())
		return EVENT_CANT_RUN
	return ..()

/datum/round_event/antagonist/solo/werewolflite
