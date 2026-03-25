///////////////////////////////////////////////////////////////
///////////////////////////////////////////////// SPECIAL WAVES
/* 
	npc pools only take complex mobs at the moment

*/
/datum/outskirts_wave/ascendant
	wave_alert_phrase = list(
		"Fanatics emerge from the shadows!",
		"Heathen altars call for my blood!"
	)
	npc_pool = list(
		/mob/living/carbon/human/species/human/northern/deranged_knight/hedgeknight
	)
	special_npc_chance = 15


/datum/outskirts_wave
	var/list/wave_alert_phrase = list(
		"The enemy sallies forth!",
		"Give them steel!",
		"Warhorns cry out. More."
	)
	var/list/npc_pool = list()
	var/special_npc_chance = 15


/datum/outskirts_wave/feud

/////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// WAVE MANAGEMENT


//////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// CALCULATE WAVE INTEGRITY
/*
	calculates the status of the current defender wave
	counts total spawned mobs and those that are alive
	for simple animals: counts as alive if not dead/unconscious (this also doesn't really matter atm since we're no longer spawning them)
	for complex mobs: counts as alive if not dead/unconscious/fleeing
	returns integrity percentage (alive / total spawned * 100)

*/
/datum/outskirts_encounter/proc/calculate_wave_integrity()
	var/total_alive = 0
	var/total_spawned = 0
	
	for(var/mob/M in current_wave)
		total_spawned++
		
		if(istype(M, /mob/living/simple_animal))
			if(M.stat != DEAD && M.stat != UNCONSCIOUS)
				total_alive++
		else if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.stat != DEAD && H.stat != UNCONSCIOUS && H.mode != NPC_AI_FLEE)
				total_alive++
	
	var/integrity = 0
	if(total_spawned > 0)
		integrity = (total_alive / total_spawned) * 100
	
	return integrity

//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// CALCULATE ATTACKER INTEGRITY
/*
	calculates the health/status of attacking player force
	counts effective attackers (alive, conscious, not zombified)
	calculates casualties from initial_besieger_count
	returns integrity percentage based on losses

*/
/datum/outskirts_encounter/proc/calculate_attacker_integrity()
	if(initial_besieger_count == 0)
		return 0
	
	var/total_effective = 0

	for(var/mob/living/carbon/human/attacker in linked_warband.besieging_mobs)
		if(attacker.stat != DEAD && attacker.stat != UNCONSCIOUS && attacker.stat != SOFT_CRIT && !(HAS_TRAIT(attacker, TRAIT_ZOMBIE_SPEECH)))
			total_effective++
	
	// casualties = everyone who is no longer effective
	// this includes: dead, unconscious, and those who fled (mobs missing from the initial besieger count)
	var/casualties = initial_besieger_count - total_effective
	
	var/integrity = ((initial_besieger_count - casualties) / initial_besieger_count) * 100
	return integrity

///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// CHECK WAVE INTEGRITY
/*
	monitors encounter integrity and triggers the appropriate responses
	during rout: 
		- checks if all attackers eliminated to start cleanup
	during active encounter: 
		- spawns new defender wave if integrity drops below 40%
		- triggers attacker rout if their integrity drops below 30%
			- also auto-routs after 4 checks with no attackers
			- covers the case where someone starts the encounter & then just decides to Leave
			- like some kind of Psycho

*/
/datum/outskirts_encounter/proc/check_wave_integrity()
	if(attacker_rout_active && !processing_cleanup)
		var/attackers_alive = FALSE
		for(var/mob/living/carbon/human/attacker in linked_warband.besieging_mobs)
			if(!attacker || !attacker.mind)
				continue
			if(attacker && attacker.stat != DEAD && attacker.stat != UNCONSCIOUS && !(HAS_TRAIT(attacker, TRAIT_ZOMBIE_SPEECH)))
				attackers_alive = TRUE
				break
		
		if(!attackers_alive)
			processing_cleanup = TRUE
			start_defender_cleanup()
		return
	
	if(!encounter_active || encounter_disabled)
		return
	
	if(attacker_rout_active || processing_cleanup)
		return

	if(world.time < next_integrity_check)
		return
	
	next_integrity_check = world.time + (integrity_check_interval * 10)
	

	var/effective_attackers = 0
	for(var/mob/living/carbon/human/attacker in linked_warband.besieging_mobs)
		if(!attacker || !attacker.mind)
			continue
		if(attacker && attacker.stat != DEAD && attacker.stat != UNCONSCIOUS && !(HAS_TRAIT(attacker, TRAIT_ZOMBIE_SPEECH)))
			effective_attackers++
	
	// automatically rout after 4 integrity checks with 0 attackers
	var/checks_performed = ((world.time - encounter_start_time) / (integrity_check_interval * 10))
	if(checks_performed >= 4 && effective_attackers == 0)
		trigger_rout("attacker")
		return

	// defender wave integrity
	var/defender_integrity = calculate_wave_integrity()
	if(defender_integrity <= 40)
		spawn_defender_wave()
	
	// attacker wave integrity
	var/attacker_integrity = 100
	if(initial_besieger_count > 0)
		var/casualties = initial_besieger_count - effective_attackers
		attacker_integrity = ((initial_besieger_count - casualties) / initial_besieger_count) * 100
	
	if(attacker_integrity <= 30)
		trigger_rout("attacker")

/////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// SPAWN DEFENDER WAVE
/*
	spawns wave_size mobs at defender entry point
	deducts spawned mobs from warband spawn pool
	assigns duties to every spawned mobs
	if this is the first wave, it also records the initial_besieger_count based off of the incoming_mobs
	also checks victory conditions:
		- max waves reached: defender rout
		- insufficient spawns: defender rout	
		- no attackers alive: start cleanup

*/
/datum/outskirts_encounter/proc/spawn_defender_wave(is_rout_wave = FALSE)
	if(is_rout_wave)
		var/attackers_alive = FALSE
		for(var/mob/living/carbon/human/attacker in linked_warband.besieging_mobs)
			if(!attacker || !attacker.mind)
				continue
			if(attacker && attacker.stat != DEAD && attacker.stat != UNCONSCIOUS && !(HAS_TRAIT(attacker, TRAIT_ZOMBIE_SPEECH)))
				attackers_alive = TRUE
				break
		
		if(!attackers_alive)
			if(!processing_cleanup)
				processing_cleanup = TRUE
				start_defender_cleanup()
			return FALSE

	if(wave_number >= max_waves && !is_rout_wave)
		trigger_rout("defender")
		return FALSE // defenders rout if the wave limit is hit
	
	var/turf/spawn_location = get_turf(defender_entry)
	var/wave_size = calculate_wave_size()
	
	if(linked_warband.spawns < wave_size && !is_rout_wave)
		trigger_rout("defender")
		return FALSE // defenders rout if no more spawns are left
	
	var/wavestart = pick('sound/misc/warband/warband_warhorn1.ogg', 'sound/misc/warband/warband_warhorn2.ogg', 'sound/misc/warband/warband_warhorn3.ogg')
	var/sound/S = sound(wavestart, repeat = 0, wait = 0, channel = 0, volume = 9000)	
	for(var/mob/living/attacker in linked_warband.besieging_mobs)
		if(!attacker || !attacker.mind)
			continue
		SEND_SOUND(attacker, S)
	if(!is_rout_wave)
		send_wave_alerts()
	
	var/current_special_chance = custom_wave?.special_npc_chance || 15
	
	if(is_rout_wave)
		rout_wave_spawned = TRUE
		current_special_chance = 80 // special mob chance is cranked up during rout waves
	
	var/mobs_spawned = 0
	var/list/newly_spawned = list()
	
	for(var/i = 1 to wave_size)
		var/mob/spawned = spawn_wave_mob(spawn_location, current_special_chance)
		current_wave += spawned
		newly_spawned += spawned
		mobs_spawned++
		if(objective)
			assign_mob_duty(spawned)
	
	if(!is_rout_wave) // rout waves don't deduct from the warband's spawns
		if(mobs_spawned > 0)
			linked_warband.spawns -= mobs_spawned

	// records the initial besieger count after first wave spawns
	if(wave_number == 0 && initial_besieger_count == 0)
		var/list/attackers = linked_warband.incoming_mobs | linked_warband.besieging_mobs
		initial_besieger_count = attackers.len
	
	wave_number++
	process_duties()
	if(processing_cleanup) // if a wave spawns during a rout, we want to make sure they're scheduled to recycle themselves
		for(var/mob/M in newly_spawned)
			pending_cleanup += M
	
	if(is_rout_wave && !processing_cleanup)
		var/attackers_alive = FALSE
		for(var/mob/living/carbon/human/attacker in linked_warband.besieging_mobs)
			if(!attacker || !attacker.mind)
				continue
			if(attacker && attacker.stat != DEAD && attacker.stat != UNCONSCIOUS && !(HAS_TRAIT(attacker, TRAIT_ZOMBIE_SPEECH)))
				attackers_alive = TRUE
				break
		
		if(!attackers_alive)
			processing_cleanup = TRUE
			start_defender_cleanup()
	
	return TRUE

/datum/outskirts_encounter/proc/send_wave_alerts()
	var/attacker_message = pick(custom_wave.wave_alert_phrase)
	for(var/mob/living/carbon/human/attacker in linked_warband.besieging_mobs)
		if(!attacker || !attacker.mind)
			continue
		to_chat(attacker, span_userdanger("[attacker_message]"))
	
	for(var/mob/living/carbon/human/defender in linked_warband.members)
		if(!defender || !defender.mind)
			continue
		if(defender.mind.special_role == "Warlord" || defender.mind.special_role == "Lieutenant" || defender.mind.special_role == "Aspirant Lieutenant")
			to_chat(defender, span_warning("Our scouts report a wave of casualties in our outskirts."))

/datum/outskirts_encounter/proc/spawn_wave_mob(turf/spawn_location, special_chance = 15)
	var/spawn_special = custom_wave.npc_pool?.len && prob(special_chance)
	
	if(spawn_special)
		return spawn_special_mob(spawn_location)
	else
		return spawn_grunt_mob(spawn_location)

/datum/outskirts_encounter/proc/spawn_special_mob(turf/spawn_location)
	if(!custom_wave)
		return
	var/mob/special_type = pick(custom_wave.npc_pool)
	var/mob/spawned = new special_type(spawn_location)
	spawned.faction = list("warband_[linked_warband.warband_ID]")
	return spawned


/////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// SPAWN GRUNT MOB
/*
	spawns and returns a standard grunt defender
	prioritizes any recycled special mobs from previous waves
	if no recycled mobs are available, it pulls from warband's cache

*/
/datum/outskirts_encounter/proc/spawn_grunt_mob(turf/spawn_location)
	var/mob/living/carbon/human/species/human/northern/goon/new_grunt = linked_warband.get_cached_grunt(spawn_location)
	new_grunt.aggressive = TRUE
	new_grunt.wander = TRUE
	new_grunt.faction = list("warband_[linked_warband.warband_ID]")
	return new_grunt

/datum/outskirts_encounter/proc/assign_mob_duty(mob/spawned)
	var/duty_type
	
	if(istype(spawned, /mob/living/simple_animal))
		duty_type = DUTY_SIMPLEMOB
	else
		duty_type = DUTY_ATTACK
	
	var/datum/npc_duty/new_duty = new(spawned, objective, src, duty_type)
	active_duties += new_duty
	new_duty.process_duty()
