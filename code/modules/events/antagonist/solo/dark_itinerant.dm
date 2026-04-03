/datum/round_event_control/antagonist/solo/dark_itinerant
	name = "Dark Itinerants"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
		TAG_TRICKERY,
	)
	roundstart = TRUE
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN
	storyteller_favor_flags = STORYTELLER_FAVOR_DARK_ITINERANT
	storyteller_favor_multiplier = 2
	antag_flag = ROLE_DARK_ITINERANT
	shared_occurence_type = SHARED_HIGH_THREAT

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES
	base_antags = 2
	antag_scaling = 1
	maximum_antags = 4

	earliest_start = 0 SECONDS
	max_occurrences = 1
	weight = 5

	typepath = /datum/round_event/antagonist/solo/dark_itinerant
	antag_datum = /datum/antagonist/zizo_knight

/datum/round_event_control/antagonist/solo/dark_itinerant/proc/get_pair_amount(player_count = null)
	if(isnull(player_count))
		player_count = SSgamemode.get_correct_popcount()
	var/max_pairs = SSgamemode.story_antag_slot_cap(antag_datum, TRUE)
	var/pair_amount = SSgamemode.storyteller_scale_slots(max_pairs, player_count, FALSE, SSgamemode.story_antag_scaling_step(antag_datum, antag_scaling), SSgamemode.story_antag_min_players(antag_datum))
	if(pair_amount > 1 && SSgamemode.story_combat_pop() <= 10)
		pair_amount = 1
	return pair_amount

/datum/round_event_control/antagonist/solo/dark_itinerant/get_base_antag_amount(player_count = null)
	var/pair_amount = get_pair_amount(player_count)
	if(pair_amount <= 0)
		return 0
	return min(maximum_antags, pair_amount * 2)

/datum/round_event_control/antagonist/solo/dark_itinerant/get_antag_amount()
	var/player_count = SSgamemode.get_correct_popcount()
	return SSgamemode.story_antag_slots(get_base_antag_amount(player_count), antag_datum, player_count)

/datum/round_event/antagonist/solo/dark_itinerant/start()
	var/pair_count = FLOOR(length(setup_minds) / 2, 1)
	if(pair_count <= 0)
		return

	var/list/knights = list()
	var/list/squires = list()
	var/assigned_knights = 0

	for(var/datum/mind/antag_mind as anything in setup_minds)
		var/datum/job/job = SSjob.GetJob(antag_mind.current?.job)
		job?.current_positions = max(job?.current_positions - 1, 0)
		antag_mind.current?.unequip_everything()

		if(assigned_knights < pair_count)
			var/datum/antagonist/zizo_knight/knight = new
			antag_mind.add_antag_datum(knight)
			knights += knight
			assigned_knights++
			continue

		var/datum/antagonist/zizo_knight/squire/squire = new
		antag_mind.add_antag_datum(squire)
		squires += squire

	for(var/index in 1 to min(length(knights), length(squires)))
		var/datum/antagonist/zizo_knight/knight = knights[index]
		var/datum/antagonist/zizo_knight/squire/squire = squires[index]
		if(!knight?.owner || !squire?.owner)
			continue

		var/datum/objective/dark_itinerant/train_squire = new /datum/objective/dark_itinerant(null, knight.owner)
		var/datum/objective/dark_itinerant/squire/serve_knight = new /datum/objective/dark_itinerant/squire(null, squire.owner)

		train_squire.target = squire.owner
		train_squire.explanation_text = "Train your squire [squire.owner.current?.real_name] in the field. Show them the ropes. Ensure they survive."
		knight.objectives += train_squire

		serve_knight.target = knight.owner
		serve_knight.explanation_text = "Serve faithfully to your knight [knight.owner.current?.real_name], heed their commands and help them."
		squire.objectives += serve_knight

		knight.owner.announce_objectives()
		squire.owner.announce_objectives()
