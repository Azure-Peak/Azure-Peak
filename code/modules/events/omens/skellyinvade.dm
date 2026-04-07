/datum/round_event_control/skellyinvade
	name = "Skeleton Invasion"
	track = EVENT_TRACK_OMENS
	typepath = /datum/round_event/skellyinvade
	weight = 10
	max_occurrences = 2
	min_players = 0
	req_omen = TRUE
	todreq = list("night")
	announce_text = "The dead walk! Skeletons rise to plague the living!"
	announce_title = "Skeleton Invasion"

/datum/round_event/skellyinvade
	announceWhen	= 50
	var/spawncount = 3
	var/list/starts

/datum/round_event_control/skellyinvade/canSpawnEvent(players_amt, gamemode, fake_check)
	if(!LAZYLEN(GLOB.hauntstart))
		return FALSE

/datum/round_event/skellyinvade/setup()
	announceWhen = rand(announceWhen, announceWhen + 50)
//	var/maxi = max(GLOB.badomens.len, 1)
//	spawncount = 3 + maxi

/datum/round_event/skellyinvade/start()
	var/list/spawn_locs = GLOB.hauntstart.Copy()
	if(LAZYLEN(GLOB.hauntstart))
		for(var/i in 1 to spawncount)
			var/obj/effect/landmark/events/haunts/_T = pick_n_take(spawn_locs)
			if(_T)
				_T = get_turf(_T)
				if(isfloorturf(_T))
					new /mob/living/carbon/human/species/skeleton/npc(_T)

	return
