
////////////////////////////////////////////////////////
///////////////////////////////////////////////// DUTIES

/datum/npc_duty
	var/duty_type
	var/mob/assigned_npc
	var/obj/effect/landmark/outskirts_objective/objective_ref
	var/datum/outskirts_encounter/encounter_ref
	var/next_position_check = 0
	var/next_target_attempt = 0
	var/has_reached_objective = FALSE
	var/last_active_time = 0
	var/movement_start_time = 0
	var/idle_threshold = 10 SECONDS		// if a mob is idle for more than 10 seconds, the duty gives them someone entirely new to attack	
	var/movement_timeout = 10 SECONDS	// time limit for an attacker reaching the objective. after this point, they just pretend they reached it & begin attacking

/datum/npc_duty/New(mob/npc, obj/effect/landmark/outskirts_objective/obje, datum/outskirts_encounter/encounter, type = DUTY_ATTACK)
	..()
	assigned_npc = npc
	objective_ref = obje
	encounter_ref = encounter
	duty_type = type
	next_position_check = world.time + 30 SECONDS
	next_target_attempt = world.time + 3 SECONDS
	last_active_time = world.time
	movement_start_time = world.time

/datum/npc_duty/Destroy()
	objective_ref = null
	encounter_ref = null
	assigned_npc = null
	return ..()


////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// PROCESS DUTIES
/* 
	main processing loop for NPC duties
	routes to appropriate duty processor based on type:
		- DUTY_ATTACK: process attack behavior
		- DUTY_DEFEND: process defend behavior	(defunct as they no longer have an objective to defend)
		- DUTY_SIMPLEMOB: process simple mob AI (also defunct. what am i doing here)

*/
/datum/npc_duty/proc/process_duty()
	if(assigned_npc && assigned_npc.stat != DEAD && objective_ref && encounter_ref && assigned_npc.loc)
		switch(duty_type)
			if(DUTY_ATTACK)
				process_attack_duty()
			if(DUTY_DEFEND)
				process_defend_duty()
			if(DUTY_SIMPLEMOB)
				process_simplemob_duty()
		return TRUE
	else
		return FALSE

/////////////////////////////////////////////////////////////
///////////////////////////////////////////////// ATTACK DUTY
/* 
	move towards the objective
	afterwards, they're assigned a target from the besieging_mobs list & told to march towards them

	they are considered to reach the objective if:
		1: they come within 5 tiles of the objective	
		2: they're attacked
		3: they haven't reached the objective after 10 seconds

*/
/datum/npc_duty/proc/process_attack_duty()
	if(!is_complex_mob())
		return
	
	var/mob/living/carbon/human/npc = assigned_npc
	
	// if they got attacked (target is a mob, not the objective), we consider objective reached
	if(!has_reached_objective && npc.target && ismob(npc.target))
		var/mob/living/target_mob = npc.target
		if(target_mob.stat != DEAD)
			has_reached_objective = TRUE
			npc.mode = NPC_AI_HUNT
			npc.wander = TRUE
			npc.clear_path()
			last_active_time = world.time
			return
	
	var/distance = get_dist(npc, objective_ref)
	if(has_reached_objective)
		if(npc.mode == NPC_AI_MARCH && npc.target && ismob(npc.target)) // if they're marching toward a player target, check if they've closed the gap
			var/mob/living/march_target = npc.target					// if so, we're gonna set them to Hunt
			if(march_target.stat != DEAD)
				if(get_dist(npc, march_target) <= npc.interesting_dist)
					npc.mode = NPC_AI_HUNT
					last_active_time = world.time
			else
				npc.target = null
				npc.mode = NPC_AI_IDLE
			return

		check_idle(npc)
		attempt_assign_player_target(npc)
		if(npc.target && ismob(npc.target))
			var/mob/living/target_mob = npc.target
			if(target_mob.stat != DEAD)
				if(npc.mode == NPC_AI_IDLE)
					npc.mode = NPC_AI_HUNT
					last_active_time = world.time
			else
				npc.target = null
				npc.mode = NPC_AI_IDLE
	else if(distance <= 5)
		reach_objective_attack(npc)
	else if((world.time - movement_start_time) > movement_timeout)
		reach_objective_attack(npc)
	else
		move_to_objective(npc)

/datum/npc_duty/proc/check_idle(mob/living/carbon/human/npc)
	if(npc.mode == NPC_AI_IDLE && (world.time - last_active_time) > idle_threshold)
		npc.target = null
		npc.clear_path()
		next_target_attempt = world.time
		last_active_time = world.time
	else if(npc.mode != NPC_AI_IDLE)
		last_active_time = world.time

/datum/npc_duty/proc/reach_objective_attack(mob/living/carbon/human/npc)
	has_reached_objective = TRUE
	npc.mode = NPC_AI_IDLE
	npc.wander = TRUE
	npc.target = null
	npc.clear_path()
	next_target_attempt = world.time + 3 SECONDS

//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// ATTEMPT ASSIGN PLAYER TARGET
/*
	tries to assign a player target to the NPC
	skips if the NPC already has a valid, living target
	calls assign_player_target() to find new target

*/
/datum/npc_duty/proc/attempt_assign_player_target(mob/living/carbon/human/npc)
	if(world.time < next_target_attempt)
		return
	next_target_attempt = world.time + 5 SECONDS
	
	if(npc.target && ismob(npc.target))
		var/mob/living/target_mob = npc.target
		if(target_mob.stat != DEAD && target_mob.stat != UNCONSCIOUS && target_mob.stat != SOFT_CRIT)
			return // if we already have a valid living mob as a target, we don't want to reassign a new one
	
	assign_player_target(npc)
	if(npc.target)
		last_active_time = world.time


//////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// ASSIGN PLAYER TARGET
/*
	picks a target from the list of living player targets (besieging_mobs list)

*/
/datum/npc_duty/proc/assign_player_target(mob/living/carbon/human/npc)
	if(!encounter_ref.linked_warband.besieging_mobs?.len)
		return

	var/list/valid_targets = get_valid_player_targets()
	if(!valid_targets.len)
		return
	
	var/mob/living/carbon/human/chosen_target = pick(valid_targets)
	npc.retaliate(chosen_target)

	if(get_dist(npc, chosen_target) > npc.interesting_dist)
		npc.mode = NPC_AI_MARCH
		npc.next_complex_path_time = world.time + rand(4, 8) SECONDS

/////////////////////////////////////////////////////////////
///////////////////////////////////////////////// DEFEND DUTY
/*
	unused atm as the objective was scrapped
	if the objective was reached: monitors the mob's position to stay near objective
	if they're far from objective: returns to it
	they're considered to have reached the objective once they come within 5 tiles

*/
/datum/npc_duty/proc/process_defend_duty()
	if(!is_complex_mob())
		return

	var/mob/living/carbon/human/npc = assigned_npc
	var/distance = get_dist(npc, objective_ref)
	if(has_reached_objective)
		check_defender_position(npc, distance)
	else if(distance <= 5)
		reach_objective_defend(npc)
	else
		move_to_objective(npc)

/datum/npc_duty/proc/reach_objective_defend(mob/living/carbon/human/npc)
	has_reached_objective = TRUE
	npc.mode = NPC_AI_IDLE
	npc.wander = TRUE
	npc.target = null
	npc.clear_path()

/datum/npc_duty/proc/check_defender_position(mob/living/carbon/human/npc, distance)
	if(world.time < next_position_check)
		return
	next_position_check = world.time + 20 SECONDS
	
	if(distance > 5) // if a defender is too far from the objective, they run back
		has_reached_objective = FALSE
		move_to_objective(npc)

/datum/npc_duty/proc/process_simplemob_duty()
	if(!is_simplemob())
		return
	
	var/mob/living/simple_animal/hostile/retaliate/npc = assigned_npc
	var/distance = get_dist(npc, objective_ref)
	
	if(distance <= 5) // if we've reached the objective, start hunting players
		if(!has_reached_objective)
			has_reached_objective = TRUE
			npc.LoseTarget()
		attempt_assign_simplemob_target(npc)
		return TRUE
	
	if(!npc.target || npc.target != objective_ref)
		npc.GiveTarget(objective_ref)
		npc.Goto(objective_ref, npc.move_to_delay, 1)

/datum/npc_duty/proc/attempt_assign_simplemob_target(mob/living/simple_animal/hostile/retaliate/npc)
	if(npc.target && isliving(npc.target))
		var/mob/living/current = npc.target
		if(current.stat != DEAD && current.stat != UNCONSCIOUS && current.stat != SOFT_CRIT)
			return

	var/list/valid_targets = get_valid_player_targets()
	if(!valid_targets.len)
		return
	
	var/mob/living/chosen_target = pick(valid_targets)
	npc.GiveTarget(chosen_target)
	npc.Goto(chosen_target, npc.move_to_delay, npc.minimum_distance)

/datum/npc_duty/proc/release_simplemob(mob/living/simple_animal/hostile/retaliate/npc)
	npc.LoseTarget()
	walk(npc, 0)

/datum/npc_duty/proc/is_complex_mob()
	return istype(assigned_npc, /mob/living/carbon/human)

/datum/npc_duty/proc/is_simplemob()
	return istype(assigned_npc, /mob/living/simple_animal)

/datum/npc_duty/proc/move_to_objective(mob/living/carbon/human/npc)
	if(npc.target != objective_ref)
		npc.mode = NPC_AI_MARCH
		npc.target = objective_ref
		npc.npc_march(objective_ref)

/datum/npc_duty/proc/get_valid_player_targets()
	var/list/targets = list()
	for(var/mob/living/carbon/human/potential_target in encounter_ref.linked_warband.besieging_mobs)
		if(potential_target.stat != DEAD)
			targets += potential_target
	return targets


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
	var/is_moving = FALSE
	var/last_interaction = 0
	var/interaction_cooldown = 3 SECONDS

/obj/effect/landmark/outskirts_objective/threshold
	name = "threshold"

/obj/effect/landmark/outskirts_objective/Destroy()
	linked_encounter.objective = null
	linked_encounter = null
	starting_position = null
	return ..()

/obj/effect/landmark/outskirts_objective/proc/reset_position()
	if(starting_position)
		forceMove(starting_position)

// gets the middle point between the attacker & defender spawn
/datum/outskirts_encounter/proc/spawn_objective()
	var/turf/attacker_turf = get_turf(attacker_entry)
	var/turf/defender_turf = get_turf(defender_entry)
	var/list/path = get_path_to(attacker_turf, defender_turf, TYPE_PROC_REF(/turf, Heuristic_cardinal_3d), 200, 200, 1, adjacent = TYPE_PROC_REF(/turf, reachableTurftest3d))
	var/turf/spawn_turf = path[round(path.len / 2)]
	for(var/turf/open/candidate in range(3, spawn_turf))
		if(!candidate.density)
			objective = new /obj/effect/landmark/outskirts_objective/threshold(candidate)
			objective.linked_encounter = src
			objective.attacker_goal = attacker_turf
			objective.defender_goal = defender_turf
			objective.starting_position = candidate
			return
