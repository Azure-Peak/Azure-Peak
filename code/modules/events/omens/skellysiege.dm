/datum/round_event_control/skellysiege
	name = "Skeleton Omen"
	track = EVENT_TRACK_OMENS
	typepath = /datum/round_event/skellysiege
	weight = 10
	max_occurrences = 2
	min_players = 0
	req_omen = TRUE
	todreq = list("dusk", "night", "dawn", "day")
	earliest_start = 2 HOURS
	announce_text = "The dead walk! Skeletons rise to plague the living!"
	announce_title = "Skeleton Omen"
	var/last_siege = 0


/datum/round_event/skellysiege
	announceWhen	= 1

/datum/round_event/skellysiege/setup()
	return

/datum/round_event/skellysiege/start()
	SSmapping.add_world_trait(/datum/world_trait/skeleton_siege, rand(4 MINUTES, 8 MINUTES))
	for(var/mob/dead/observer/O in GLOB.player_list)
		addtimer(CALLBACK(O, TYPE_PROC_REF(/mob/dead/observer, horde_respawn)), 1)
	return

/* - Old Code Below (Kept cus it's got more unqiue stuff in it that may be useful for a rework eventually.)
/datum/round_event_control/rogue/skeleton_siege
	name = "skellysiege"
	typepath = /datum/round_event/rogue/skeleton_siege
	weight = 10
	max_occurrences = 0
	min_players = 0
	req_omen = TRUE
	todreq = list("dusk", "night", "dawn", "day")
	earliest_start = 0 // Allow immediate start for dark chant
	var/last_siege = 0

/datum/round_event/rogue/skeleton_siege
	announceWhen	= 1
	var/spawncount = 5  // Number of skeletons per area
	var/spawn_delay = 30 SECONDS
	var/waves = 3

/datum/round_event/rogue/skeleton_siege/setup()
	return TRUE

/datum/round_event/rogue/skeleton_siege/start()
	message_admins("Skeleton siege event starting...")
	
	// Get only public town areas
	var/list/indoor_areas = list()
	var/list/outdoor_areas = list()
	
	for(var/area/rogue/A in world)
		// Only allow ground-level town areas, no roofs or underground
		if(!istype(A, /area/rogue/under) && !istype(A, /area/rogue/outdoors/town/roofs))
			if(istype(A, /area/rogue/indoors/town/tavern) || \
			   istype(A, /area/rogue/indoors/town/church/chapel) || \
			   istype(A, /area/rogue/indoors/town/manor))
				indoor_areas += A
			else if(istype(A, /area/rogue/outdoors/town))
				outdoor_areas += A
			
	if(!LAZYLEN(indoor_areas) && !LAZYLEN(outdoor_areas))
		message_admins("WARNING: No valid town areas found for skeleton siege!")
		return
		
	message_admins("Found [length(indoor_areas)] indoor and [length(outdoor_areas)] outdoor areas")
	
	// Pick areas to spawn in, ensuring at least one outdoor area
	var/list/chosen_areas = list()
	
	// First, pick an outdoor area
	if(LAZYLEN(outdoor_areas))
		var/area/rogue/chosen_outdoor = pick_n_take(outdoor_areas)
		chosen_areas += chosen_outdoor
	
	// Then fill remaining slots with random areas
	var/list/remaining_areas = indoor_areas + outdoor_areas
	while(length(chosen_areas) < 3 && LAZYLEN(remaining_areas))
		var/area/rogue/chosen = pick_n_take(remaining_areas)
		chosen_areas += chosen
		
	message_admins("Chosen [length(chosen_areas)] areas for skeleton spawns")
	
	// Spawn waves of skeletons
	for(var/wave in 1 to waves)
		message_admins("Spawning wave [wave] of skeletons")
		
		for(var/area/rogue/A in chosen_areas)
			var/list/valid_turfs = list()
			
			// Get all valid floor turfs in the area
			for(var/turf/T in A.contents)
				if(isfloorturf(T) && !T.density)
					valid_turfs += T
					
			if(LAZYLEN(valid_turfs) >= spawncount)
				message_admins("Spawning [spawncount] skeletons in [A]")
				for(var/i in 1 to spawncount) 
					var/turf/T = pick(valid_turfs)
					valid_turfs -= T
					if(T)
						var/mob/living/carbon/human/species/skeleton/S = new /mob/living/carbon/human/species/skeleton/npc(T)
						S.faction = list(FACTION_SKELETON)
						
		if(wave < waves)
			sleep(spawn_delay) // Wait before next wave
*/
