/////////////////////////////////////////////////////////////////////////// 
///////////////////////////////////////////////// ROUT & CLEANUP MECHANICS

/datum/outskirts_encounter/proc/trigger_rout(type)
	if(attacker_rout_active)
		return
	
	attacker_rout_active = TRUE
	rout_start_time = world.time
	objective.reset_position()
	
	if(type == "attacker")
		handle_attacker_rout()
	else
		handle_defender_rout()


///////////////////////////////////////////////////////////////
///////////////////////////////////////////////// ATTACKER ROUT
/*
	handles the sequence when attackers are routed
	notifies attackers they must escape or die
	locks outskirts and spawns extra defender wave if attackers remain
	sets multiple timers:
		- 1min: spawn additional defender wave (if attackers remain)
		- 1min: notify any remaining attackers that they're trapped
		- 7min: end rout state
		- 7min: force the end cleanup

*/
/datum/outskirts_encounter/proc/handle_attacker_rout()
	var/sound/S = sound('sound/misc/surrender.ogg', repeat = 0, wait = 0, channel = 0, volume = 100)
	for(var/mob/living/carbon/human/attacker in linked_warband.besieging_mobs)
		if(!attacker || !attacker.mind)
			continue
		to_chat(attacker, span_userdanger("We've been routed! I must escape before I'm encircled!"))
		SEND_SOUND(attacker, S)

	for(var/mob/living/carbon/human/defender in linked_warband.members)
		if(!defender || !defender.mind)
			continue
		to_chat(defender, span_warning("Our scouts report a victory in our camp's outskirts."))

	outskirts_locked = TRUE
	attacker_rout_active = TRUE
	rout_wave_spawned = FALSE
	encounter_active = FALSE
	if(length(linked_warband.besieging_mobs)) // if there are any attackers left, send an extra wave
		addtimer(CALLBACK(src, PROC_REF(spawn_defender_wave), TRUE), 60 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(trapped_warning)), 60 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(end_attacker_rout)), 7 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(reset_encounter)), 7 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(force_end_cleanup)), 7 MINUTES) // if the cleanup isn't over by this point (likely via interruptions) we want to pretend it is

/datum/outskirts_encounter/proc/trapped_warning()
	var/sound/S = sound('sound/misc/surrender.ogg', repeat = 0, wait = 0, channel = 0, volume = 100)
	for(var/obj/structure/fluff/traveltile/warband/outskirts_to_intermission/exit in SSwarbands.warband_machines)
		if(exit.warband_ID == linked_warband.warband_ID)
			exit.visible_message(span_warning("The enemy flanks the escape route!"))
	
	for(var/mob/living/carbon/human/attacker in linked_warband.besieging_mobs)
		if(attacker.mind)
			to_chat(attacker, span_userdanger("I've lingered for too long and my window for escape has closed. I must survive."))
			SEND_SOUND(attacker, S)

/datum/outskirts_encounter/proc/end_attacker_rout()
	for(var/obj/structure/fluff/traveltile/warband/outskirts_to_intermission/exit in SSwarbands.warband_machines)
		if(exit.warband_ID == linked_warband.warband_ID)
			exit.visible_message(span_userdanger("The encirclement is broken. The passage is clear."))
	
	for(var/obj/structure/fluff/traveltile/warband/intermission_to_outskirts/entry in SSwarbands.warband_machines)
		if(entry.warband_ID == linked_warband.warband_ID)
			entry.visible_message(span_userdanger("The path ahead awaits..."))
	
	attacker_rout_active = FALSE

///////////////////////////////////////////////////////////////
///////////////////////////////////////////////// DEFENDER ROUT
/*
	handles the sequence when defenders are routed
	determines rout reason (max waves reached or no reinforcements)
	notifies the attackers of victory and the defenders of defeat

	completely disables encounter and leaves the outskirts unlocked
	doesn't clear out the npcs. they remain as stragglers

*/
/datum/outskirts_encounter/proc/handle_defender_rout()
	var/rout_reason = ""
	
	if(wave_number >= max_waves)
		rout_reason = "Our defensive line has been shattered."
	else if(linked_warband.spawns <= 0)
		rout_reason = "We have no more reinforcements to send."

	for(var/mob/living/carbon/human/attacker in linked_warband.besieging_mobs)
		if(attacker.mind)
			to_chat(attacker, span_userdanger("The enemy line is shattered. We have prevailed."))
	for(var/mob/living/carbon/human/defender in linked_warband.members)
		if(defender.mind)
			to_chat(defender, span_danger("Our scouts send word of a disaster in our camp's outskirts. [rout_reason]"))

	encounter_disabled = TRUE
	encounter_active = FALSE
	attacker_rout_active = FALSE
	outskirts_locked = FALSE


////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// START DEFENDER CLEANUP
/*
	initiates the cleanup sequence for defender NPCs
	if there's no living defenders, completes cleanup immediately
	otherwise every living defender is added to the pending_cleanup queue

*/
/datum/outskirts_encounter/proc/start_defender_cleanup()
	var/list/living_defenders = list()
	
	for(var/mob/M in current_wave)
		if(M && M.stat != DEAD && M.stat != UNCONSCIOUS && M.stat != SOFT_CRIT)
			living_defenders += M
	
	if(!living_defenders.len)
		complete_cleanup_sequence()
		return
	pending_cleanup = living_defenders.Copy()
	next_cleanup_attempt = world.time + cleanup_attempt_interval


//////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// ATTEMPT DEFENDER CLEANUP
/*
	dead/unconscious defenders are skipped and removed from the wave list
	performs 6-second do_after for departure

	on success: finalizes cleanup
	on failure: adds mob back to pending queue for retry

*/
/datum/outskirts_encounter/proc/attempt_defender_cleanup(mob/living/carbon/human/M)
	if(!M || M.stat == DEAD || M.stat == UNCONSCIOUS)
		current_wave -= M
		check_cleanup_completion()
		return

	M.mode = NPC_AI_IDLE
	M.target = null
	M.wander = FALSE
	M.clear_path()
	M.visible_message(span_warning("[M] begins to depart the battlefield..."))

	var/success = do_after(M, 6 SECONDS, target = M)
	
	if(success)
		M.visible_message(span_warning("[M] departs the battlefield."))
		finalize_defender_cleanup(M)
	else
		M.visible_message(span_warning("[M]'s departure is halted!"))
		pending_cleanup |= M

///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// PROCESS CLEANUP QUEUE
/*
	called by subsystem (warbands.dm) 
	processes the pending_cleanup queue

	verifies that
	1: a cleanup is actually scheduled to begin with
	2: no attackers (besieging_mobs) are left alive

*/
/datum/outskirts_encounter/proc/process_cleanup_queue()
	if(!processing_cleanup || !pending_cleanup.len)
		return
	
	if(world.time < next_cleanup_attempt)
		return

	for(var/mob/living/carbon/human/attacker in linked_warband.besieging_mobs)
		if(!attacker || !attacker.mind)
			linked_warband.besieging_mobs -= attacker
			continue
		if(attacker.stat != DEAD && attacker.stat != UNCONSCIOUS && attacker.stat != SOFT_CRIT && !(HAS_TRAIT(attacker, TRAIT_ZOMBIE_SPEECH)))
			next_cleanup_attempt = world.time + cleanup_attempt_interval
			return

	var/mob/living/carbon/human/M = pending_cleanup[1]
	pending_cleanup -= M
	next_cleanup_attempt = world.time + cleanup_attempt_interval
	
	attempt_defender_cleanup(M)

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// FINALIZE DEFENDER CLEANUP
/*
	goons get recycled
	anything else (simplemobs, for example) gets qdel'd

*/
/datum/outskirts_encounter/proc/finalize_defender_cleanup(mob/living/carbon/human/M)
	if(!M || M.stat == DEAD)
		return
	if(M.type == /mob/living/carbon/human/species/human/northern/goon)
		var/mob/living/carbon/human/species/human/northern/goon/basic_goon = M
		basic_goon.recycle()
	else
		qdel(M)
	check_cleanup_completion()

/datum/outskirts_encounter/proc/check_cleanup_completion()
	if(!processing_cleanup)
		return

	var/defenders_remaining = FALSE
	for(var/mob/M in current_wave)
		if(M && M.stat != DEAD && M.stat != UNCONSCIOUS && M.stat != SOFT_CRIT)
			defenders_remaining = TRUE
			break
	
	if(!defenders_remaining)
		complete_cleanup_sequence()


/datum/outskirts_encounter/proc/complete_cleanup_sequence()
	processing_cleanup = FALSE
	rout_wave_spawned = FALSE
	pending_cleanup = list()
	clear_wave()

/datum/outskirts_encounter/proc/force_end_cleanup()
	if(processing_cleanup)
		complete_cleanup_sequence()
