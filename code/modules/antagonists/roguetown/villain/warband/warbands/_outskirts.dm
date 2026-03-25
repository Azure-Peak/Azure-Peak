#define DUTY_ATTACK "attack"
#define DUTY_DEFEND "defend"
#define DUTY_SIMPLEMOB "simplemob"

///////////////////////////////////////////////////////////////
/datum/outskirts_encounter
	// cranked up for stress testing, set back
	var/min_wave_size = 40 // deletenote: set back to 10
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
	var/march_timer = null

	var/datum/outskirts_wave/custom_wave
	var/list/active_duties = list()	
	var/atom/movable/screen/warband/manager/linked_warband	
	var/obj/effect/landmark/outskirts_objective/objective
	var/obj/structure/fluff/traveltile/warband/outskirts_to_intermission/attacker_entry
	var/obj/structure/fluff/traveltile/warband/outskirts_to_camp/defender_entry	

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
	
////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// PROCESS DUTIES
/*
	called from the subsystem (warbands.dm)
	manages NPC behavior in an encounter (which is kinda pointless since the objective was scrapped, but Y'Know)
	clears out duties that return FALSE from process_duty()

*/
/datum/outskirts_encounter/proc/process_duties()
	if(!active_duties?.len)
		return
	
	for(var/datum/npc_duty/duty in active_duties)
		if(!duty.process_duty())
			active_duties -= duty
			qdel(duty)

/datum/outskirts_encounter/proc/clear_wave()
	current_wave = list()
	
	for(var/datum/npc_duty/duty in active_duties)
		qdel(duty)
	active_duties = list()

/datum/outskirts_encounter/proc/reset_encounter()
	wave_number = 0
	initial_besieger_count = 0
	next_integrity_check = 0
	encounter_start_time = 0
	linked_warband.outskirts_prep_timer = 0
	rout_wave_spawned = FALSE
	processing_cleanup = FALSE
