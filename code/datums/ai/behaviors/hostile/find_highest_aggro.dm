/datum/ai_behavior/find_aggro_targets
	action_cooldown = 1 SECONDS
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/find_aggro_targets/perform(seconds_per_tick, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()

	var/mob/living/living_mob = controller.pawn
	if(!living_mob || living_mob.pet_passive)
		finish_action(controller, succeeded = FALSE)
		return

	var/mob/current_target = controller.blackboard[BB_HIGHEST_THREAT_MOB]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!targetting_datum)
		CRASH("No target datum was supplied in the blackboard for [controller.pawn]")

	// Validate existing threat target
	if(current_target && istype(current_target, /mob/living))
		var/mob/living/living_target = current_target

		if(living_target.stat == DEAD)
			controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
			current_target = null
		else
			var/maintain_range = controller.blackboard[BB_AGGRO_MAINTAIN_RANGE] || 12

			if (!targetting_datum.can_attack(living_mob, current_target))
				controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
				current_target = null

			if(current_target && get_dist(living_mob, living_target) > maintain_range)
				// Hot-pursuit grace: if we were recently shot by this exact mob, keep them as
				// our threat regardless of melee-leash distance so we chase the sniper.
				var/last_hit = controller.blackboard["bb_last_ranged_hit_time"] || 0
				var/mob/last_shooter = controller.blackboard["bb_last_ranged_attacker"]
				var/in_grace = (last_shooter == current_target) && (world.time - last_hit < 15 SECONDS)
				if(!in_grace)
					controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
					current_target = null

	if(current_target)
		if(current_target == controller.blackboard[target_key])
			finish_action(controller, succeeded = FALSE)
			return
		AI_THINK(living_mob, "SCAN: locking [current_target]")
		AI_WORLD_THINK(living_mob, "LOCKED target [current_target]")
		controller.set_blackboard_key(target_key, current_target)

		var/atom/potential_hiding_location = find_hiding_location(living_mob, current_target)
		if(potential_hiding_location)
			controller.set_blackboard_key(hiding_location_key, potential_hiding_location)
		else
			controller.clear_blackboard_key(hiding_location_key)

		finish_action(controller, succeeded = TRUE)
		return

	controller.clear_blackboard_key(target_key)

	scan_for_new_targets(controller, living_mob, target_key, targetting_datum, hiding_location_key, targetting_datum_key)

/datum/ai_behavior/find_aggro_targets/proc/scan_for_new_targets(datum/ai_controller/controller, mob/living/living_mob, target_key, datum/targetting_datum/targetting_datum, hiding_location_key, targetting_datum_key)
	var/aggro_range = controller.blackboard[BB_AGGRO_RANGE] || 9
	var/list/potential_targets = hearers(aggro_range, living_mob) - living_mob

	if(!potential_targets.len)
		failed_to_find_anyone(controller, target_key, targetting_datum_key, hiding_location_key)
		finish_action(controller, succeeded = FALSE)
		return

	var/list/filtered_targets = list()
	for(var/mob/living/pot_target in potential_targets)
		if(pot_target.stat == DEAD)
			continue
		if (!targetting_datum.can_attack(living_mob, pot_target))
			continue
		// LOS gate: no aggro through walls/opaque structures.
		if(!can_see(living_mob, pot_target))
			continue
		if(pot_target.rogue_sneaking)
			var/extra_chance = (living_mob.health <= living_mob.maxHealth * 0.5) ? 30 : 0
			if(!living_mob.npc_detect_sneak(pot_target, extra_chance))
				continue

		filtered_targets += pot_target

	if(!filtered_targets.len)
		AI_THINK(living_mob, "SCAN: nobody in range [aggro_range]")
		failed_to_find_anyone(controller, target_key, targetting_datum_key, hiding_location_key)
		finish_action(controller, succeeded = FALSE)
		return

	// Prefer targeting players over animals
	var/mob/living/chosen_target
	for(var/mob/living/candidate in filtered_targets)
		if(candidate.client)
			chosen_target = candidate
			break
	if(!chosen_target)
		chosen_target = pick(filtered_targets)

	var/datum/component/ai_aggro_system/aggro_comp = living_mob.GetComponent(/datum/component/ai_aggro_system)
	if(aggro_comp)
		aggro_comp.add_threat_to_mob_capped(chosen_target, 15, 15)
		aggro_comp.add_threat_to_mob(chosen_target, 3)

	var/mob/highest_threat = controller.blackboard[BB_HIGHEST_THREAT_MOB]
	if(highest_threat)
		controller.set_blackboard_key(target_key, highest_threat)
	else if(chosen_target)
		controller.set_blackboard_key(target_key, chosen_target)
		var/atom/potential_hiding_location = find_hiding_location(living_mob, chosen_target)
		if(potential_hiding_location)
			controller.set_blackboard_key(hiding_location_key, potential_hiding_location)
		finish_action(controller, succeeded = TRUE)
	else
		finish_action(controller, succeeded = FALSE)

/// Base does nothing - field creation was removed in favor of spatial-grid wake/sleep.
/datum/ai_behavior/find_aggro_targets/proc/failed_to_find_anyone(datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	return

/datum/ai_behavior/find_aggro_targets/proc/find_hiding_location(mob/living/source, mob/living/target)
	if(!target)
		return null
	if(istype(target.loc, /obj/item) || istype(target.loc, /obj/structure) || istype(target.loc, /obj/machinery))
		return target.loc
	return null

/datum/ai_behavior/find_aggro_targets/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	if(succeeded)
		var/mob/living/pawn = controller.pawn
		if(pawn)
			pawn.cmode = TRUE
		controller.CancelActions()
		controller.modify_cooldown(controller, world.time + get_cooldown(controller))

/datum/ai_behavior/find_aggro_targets/bum/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	if(succeeded)
		var/mob/living/pawn = controller.pawn
		pawn.say(pick(GLOB.bum_aggro))

/datum/ai_behavior/find_aggro_targets/species_hostile/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	if(succeeded)
		var/mob/living/pawn = controller.pawn
		pawn.emote("rage")
		// TODO: Port species_hostile aggro lines for corrupted/feral human NPCs
		// pawn.say(pick(GLOB.species_hostile))

/datum/ai_behavior/find_aggro_targets/species_hostile/failed_to_find_anyone(datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	. = ..()
	var/mob/living/pawn = controller.pawn
	if(pawn)
		pawn.cmode = FALSE
