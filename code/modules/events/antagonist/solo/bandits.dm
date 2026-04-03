/datum/round_event_control/antagonist/solo/bandits
	name = "Bandits"
	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
		TAG_LOOT
	)
	roundstart = TRUE
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN
	storyteller_favor_flags = STORYTELLER_FAVOR_BANDIT
	storyteller_guarantee_flags = STORYTELLER_FAVOR_BANDIT
	storyteller_favor_multiplier = 2
	antag_flag = ROLE_BANDIT
	shared_occurence_type = SHARED_MINOR_THREAT

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES
	base_antags = 1
	antag_scaling = 2
	maximum_antags = 6

	earliest_start = 0 SECONDS

	weight = 18

	typepath = /datum/round_event/antagonist/solo/bandits
	antag_datum = /datum/antagonist/bandit

/datum/round_event/antagonist/solo/bandits
	var/leader = FALSE

/datum/round_event/antagonist/solo/bandits/start()
	var/datum/job/bandit_job = SSjob.GetJob("Bandit")
	var/opened_slots = max(antag_count, length(setup_minds))
	bandit_job.total_positions = opened_slots
	bandit_job.spawn_positions = opened_slots
	SSmapping.retainer.bandit_goal = rand(200,400) + (opened_slots * rand(200,400))
	for(var/datum/mind/antag_mind as anything in setup_minds)
		var/datum/job/J = SSjob.GetJob(antag_mind.current?.job)
		J?.current_positions = max(J?.current_positions-1, 0)
		antag_mind.current.unequip_everything()
		SSjob.AssignRole(antag_mind.current, "Bandit")
		SSmapping.retainer.bandits |= antag_mind.current
		antag_mind.add_antag_datum(/datum/antagonist/bandit)

		SSrole_class_handler.setup_class_handler(antag_mind.current, list(CTAG_BANDIT = 20))
		antag_mind.current:advsetup = TRUE
		antag_mind.current.hud_used?.set_advclass()

	if(length(setup_minds))
		SSrole_class_handler.bandits_in_round = TRUE
/datum/round_event_control/antagonist/solo/bandits/get_base_antag_amount(player_count = null)
	if(isnull(player_count))
		player_count = SSgamemode.get_correct_popcount()
	var/max_slots = SSgamemode.story_antag_slot_cap(antag_datum, TRUE)
	return SSgamemode.storyteller_scale_slots(max_slots, player_count, FALSE, SSgamemode.story_antag_scaling_step(antag_datum, antag_scaling), SSgamemode.story_antag_min_players(antag_datum))
