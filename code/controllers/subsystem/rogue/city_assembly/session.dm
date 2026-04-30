/datum/assembly_session
	var/number = 0
	var/state = ASSEMBLY_SESSION_OPEN
	var/opened_at
	// ballots[motion_id] = list(weakref => choice_string)
	var/list/ballots = list()
	// candidates[weakref] = list("name" => string, "pledge" => string)
	var/list/candidates = list()

/datum/assembly_session/New(num)
	number = num
	opened_at = world.time
	ballots[ASSEMBLY_MOTION_ELECTION] = list()
	ballots[ASSEMBLY_MOTION_TRADE_AUTH] = list()
	ballots[ASSEMBLY_MOTION_DEFENSE_AUTH] = list()
	// ballots[ASSEMBLY_MOTION_POLL_TAX] = list()  // disabled pending anti-dodge design
	ballots[ASSEMBLY_MOTION_RECALL] = list()
	ballots[ASSEMBLY_MOTION_CENSURE] = list()

/datum/assembly_session/proc/count_distinct_voters()
	var/list/distinct = list()
	for(var/motion_id in ballots)
		for(var/datum/weakref/wr in ballots[motion_id])
			distinct[wr] = TRUE
	return length(distinct)

