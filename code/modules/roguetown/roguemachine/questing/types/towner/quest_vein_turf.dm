/turf/closed/mineral/quest_vein
	name = "rich vein"
	desc = "A glittering seam of ore, exposed by some violence to the rock."
	icon_state = "rock_Cinnabar"
	mineralType = null
	rockType = null
	mineralAmt = 0
	max_integrity = 200
	var/datum/weakref/quest_ref
	var/list/yield_paths = list()

/turf/closed/mineral/quest_vein/gets_drilled(mob/living/user, triggered_by_explosion = FALSE, give_exp = TRUE)
	for(var/path in yield_paths)
		var/count = yield_paths[path]
		for(var/i in 1 to count)
			new path(src)
	if(give_exp && user)
		user.adjust_experience(/datum/skill/labor/mining, 10, FALSE)
	var/datum/quest/kill/towner_miner_orevein/Q = quest_ref?.resolve()
	if(Q && !Q.complete)
		Q.on_cluster_mined(src)
	var/flags = NONE
	if(defer_change)
		flags = CHANGETURF_DEFER_CHANGE
	ScrapeAway(null, flags)
	addtimer(CALLBACK(src, PROC_REF(AfterChange)), 1, TIMER_UNIQUE)
