GLOBAL_LIST_INIT(mined_resource_loc, list())

/datum/round_event_control/collapsing_earth
	name = "Collapsing Earth"
	track = EVENT_TRACK_MODERATE
	typepath = /datum/round_event/collapsing_earth
	weight = 5
	max_occurrences = 8
	min_players = 0
	earliest_start = 25 MINUTES

	tags = list(
		TAG_NATURE,
		TAG_BOON,
		TAG_WORK,
	)


/datum/round_event/collapsing_earth
	var/static/list/weighted_rocks = list(
		/turf/closed/mineral/random/rogue/high = 5,
		/turf/closed/mineral/random/rogue/med = 10,
		/turf/closed/mineral/random/rogue = 20,
	)

/datum/round_event/collapsing_earth/start()
	. = ..()

	if(!length(GLOB.mined_resource_loc))
		return

	for(var/i = 1 to rand(1, 25))
		var/turf/open/turf = pick(GLOB.mined_resource_loc)
		if(!turf)
			continue
		turf.try_respawn_mined_chunks(150, weighted_rocks)
