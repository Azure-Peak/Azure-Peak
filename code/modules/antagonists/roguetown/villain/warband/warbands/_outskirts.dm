#define DUTY_ATTACK "attack"
#define DUTY_DEFEND "defend"
#define DUTY_SIMPLEMOB "simplemob"

///////////////////////////////////////////////////////////////
/datum/outskirts_encounter
	// cranked up for stress testing, set back
	var/min_wave_size = 10 // deletenote: set back to 10
	var/max_wave_size = 50 // deletenote: reset back to 30-40
	var/max_waves = 5
	var/wave_number = 0

	var/list/current_wave = list()
	var/list/pending_cleanup = list()

	var/prep_time = 10 SECONDS // DELETENOTE: reset back to 3 minutes
	var/prep_started = FALSE
	var/outskirts_locked = TRUE	
	var/encounter_disabled = FALSE	
	var/encounter_active = FALSE
	var/encounter_start_time = 0

	var/attacker_rout_active = FALSE
	var/rout_wave_spawned = FALSE
	var/processing_cleanup = FALSE
	var/rout_start_time = 0
	var/next_integrity_check = 0 
	var/next_cleanup_attempt = 0
	var/cleanup_attempt_interval = 50
	var/integrity_check_interval = 30
	var/initial_besieger_count = 0
	var/march_timer

	var/datum/outskirts_wave/custom_wave
	var/atom/movable/screen/warband/manager/linked_warband	
	var/obj/effect/landmark/outskirts_objective/objective
	var/obj/structure/fluff/traveltile/warband/outskirts_to_intermission/attacker_entry
	var/obj/structure/fluff/traveltile/warband/outskirts_to_camp/defender_entry

	var/list/attack_npcs = list()	// defending npcs going through the 'attack' loop in their decision tree
	var/list/cached_objective_path

//////////////////////////////////////////////////////////////
///////////////////////////////////////////////// CANCEL MARCH
/*
	cancels an in-progress march to the encounter (initiated via an attacker interacting with the warband's intermission_to_outskirts tile)
	deletes the march timer and resets the encounter
	notifies all attacking mobs that the march was called off
*/
/datum/outskirts_encounter/proc/cancel_march()
	if(encounter_active)
		return FALSE // can't cancel if encounter has already started
	
	if(!prep_started)
		return FALSE // nothing to cancel

	if(march_timer)
		deltimer(march_timer)
		march_timer = null
	
	prep_started = FALSE
	reset_encounter()

	for(var/mob/living/carbon/human/attacker in linked_warband.incoming_mobs)
		if(!attacker || !attacker.mind)
			continue
		to_chat(attacker, span_warning("The march has been called off."))

	return TRUE

/datum/outskirts_encounter/proc/begin_march()
	if(prep_started || encounter_active)
		return FALSE

	prep_started = TRUE
	march_timer = addtimer(CALLBACK(src, PROC_REF(start_encounter)), prep_time, TIMER_STOPPABLE)
	return TRUE

//////////////////////////////////////////////////////////////
///////////////////////////////////////////////// FIND ENTRIES
/*
	a single outskirts_to_camp tile acts as the Defender Spawn
	a single outskirts_to_intermission tile acts as the Attacker Spawn

*/
/datum/outskirts_encounter/proc/find_defender_entry()	
	for(var/obj/structure/fluff/traveltile/warband/outskirts_to_camp/entry in SSwarbands.warband_machines)
		if(entry.warband_ID == linked_warband.warband_ID)
			defender_entry = entry
			return TRUE
	return FALSE

/datum/outskirts_encounter/proc/find_attacker_entry()
	for(var/obj/structure/fluff/traveltile/warband/outskirts_to_intermission/entry in SSwarbands.warband_machines)
		if(entry.warband_ID == linked_warband.warband_ID)
			attacker_entry = entry
			return TRUE
	return FALSE

/////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// CALCULATE WAVE SIZE
/*
	determines the size of the defender wave to spawn
	base size is min_wave_size (10)
	scales 1:1 with attacker count above 5, capped at max_wave_size (30)
	uses the initial_besieger_count if it's available, otherwise it just combines the incoming (in the intermission) and besieging (in the outskirts) mobs
*/
/datum/outskirts_encounter/proc/calculate_wave_size()
	var/base_size = min_wave_size

	var/incoming = initial_besieger_count
	if(incoming == 0)
		var/list/all_attackers = linked_warband.incoming_mobs | linked_warband.besieging_mobs
		for(var/mob/living/M in all_attackers)
			if(!M || M.stat == DEAD)
				all_attackers -= M
		incoming = all_attackers.len

	// minimum of 10
	// 1:1 ratio past 5 incoming, capped at 30
	if(incoming <= 5)
		return base_size
	
	var/additional = incoming - 5
	var/calculated_size = base_size + additional
	return min(calculated_size, max_wave_size)

/////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// START ENCOUNTER
/*
	unlocks outskirts & activates the encounter
	spawns the initial defender wave and the objective

*/
/datum/outskirts_encounter/proc/start_encounter()
	var/sound/S = sound('sound/misc/warband/warband_warhorn3.ogg', repeat = 0, wait = 0, channel = 0, volume = 100)	

	march_timer = null
	linked_warband.outskirts_prep_timer = 0

	if(encounter_active)
		return

	if(!prep_started)
		return

	for(var/mob/living/carbon/human/attacker in linked_warband.incoming_mobs)
		if(!attacker || !attacker.mind)
			continue
		to_chat(attacker, span_boldwarning("We've arrived! The enemy sallies forth to meet us!"))
		SEND_SOUND(attacker, S)

	for(var/mob/living/carbon/human/defender in linked_warband.members)
		if(!defender || !defender.mind)
			continue
		if(defender.mind.special_role == "Warlord" || defender.mind.special_role == "Lieutenant" || defender.mind.special_role == "Aspirant Lieutenant")
			to_chat(defender, span_boldwarning("Our scouts report a skirmish in our camp's outskirts! We are beset by [src.linked_warband.incoming_mobs.len] attackers!"))
	
	prep_started = FALSE
	outskirts_locked = FALSE
	encounter_active = TRUE
	encounter_start_time = world.time
	next_integrity_check = world.time + 70 SECONDS
	spawn_defender_wave()
	
/////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// RESET ENCOUNTER
/datum/outskirts_encounter/proc/reset_encounter()
	wave_number = 0
	initial_besieger_count = 0
	next_integrity_check = 0
	encounter_start_time = 0
	linked_warband.outskirts_prep_timer = 0
	rout_wave_spawned = FALSE
	processing_cleanup = FALSE
	attack_npcs = list()

////////////////////////////////////////////////////////////
///////////////////////////////////////////////// OBJECTIVES
/* 
	the objective isn't actually an objective at the moment
	it just exists as a waypoint for NPCs, essentially

	there was some attempt to set up a 'king of the hill' / 'tug of war' minigame
	but it's been simplified to 'just kill them' (via the failure conditions in the spawn_defender_wave proc)
	either way, the base combat mechanics are developed enough that a full minigame on top of them would probably just be overwhelming

*/

/obj/effect/landmark/outskirts_objective
	var/attacker_goal
	var/defender_goal
	var/datum/outskirts_encounter/linked_encounter
	var/turf/starting_position

/obj/effect/landmark/outskirts_objective/threshold
	name = "threshold"

/obj/effect/landmark/outskirts_objective/Destroy()
	linked_encounter.objective = null
	linked_encounter = null
	starting_position = null
	return ..()

// gets the middle point between the attacker & defender spawn
/datum/outskirts_encounter/proc/spawn_objective()
	var/turf/attacker_turf = get_turf(attacker_entry)
	var/turf/defender_turf = get_turf(defender_entry)
	var/list/path = get_path_to(attacker_turf, defender_turf, TYPE_PROC_REF(/turf, Heuristic_cardinal_3d), 200, 200, 1, adjacent = TYPE_PROC_REF(/turf, reachableTurftest3d))
	var/midpoint = round(path.len / 2)
	var/turf/spawn_turf = path[midpoint]
	for(var/turf/open/candidate in range(3, spawn_turf))
		if(!candidate.density)
			objective = new /obj/effect/landmark/outskirts_objective/threshold(candidate)
			objective.linked_encounter = src
			objective.attacker_goal = attacker_turf
			objective.defender_goal = defender_turf
			objective.starting_position = candidate

			// slice off the defender-side half, then reverse it
			var/list/slice = path.Copy(midpoint, 0)
			cached_objective_path = list()
			for(var/i = slice.len, i >= 1, i--) // cache that as an a* route for freshly spawned defender mobs
				cached_objective_path += slice[i]
			return
