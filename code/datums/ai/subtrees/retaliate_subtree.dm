/// Sets the BB target to a mob which you can see and who has recently attacked you
/datum/ai_planning_subtree/target_retaliate
	/// Blackboard key which tells us how to select valid targets
	var/targetting_datum_key = BB_TARGETTING_DATUM
	/// Blackboard key in which to store selected target
	var/target_key = BB_BASIC_MOB_CURRENT_TARGET
	/// Blackboard key in which to store selected target's hiding place
	var/hiding_place_key = BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION
	var/tame_key = BB_BASIC_MOB_TAMED
	var/ignore_faction = TRUE

/datum/ai_planning_subtree/target_retaliate/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	controller.queue_behavior(/datum/ai_behavior/target_from_retaliate_list, 
								BB_BASIC_MOB_RETALIATE_LIST, 
								target_key, targetting_datum_key, hiding_place_key, ignore_faction, tame_key
																
								)

/// Places a mob which you can see and who has recently attacked you into some 'run away from this' AI keys
/// Can use a different targetting datum than you use to select attack targets
/// Not required if fleeing is the only target behaviour or uses the same target datum
/datum/ai_planning_subtree/target_retaliate/to_flee
	targetting_datum_key = BB_FLEE_TARGETTING_DATUM
	target_key = BB_BASIC_MOB_FLEE_TARGET
	hiding_place_key = BB_BASIC_MOB_FLEE_TARGET_HIDING_LOCATION

/**
 * Picks a target from a provided list of atoms who have been pissing you off
 * You will probably need /datum/element/ai_retaliate to take advantage of this unless you're populating the blackboard yourself
 */
/datum/ai_behavior/target_from_retaliate_list
	action_cooldown = 2 SECONDS
	/// How far can we see stuff?
	var/vision_range = 9

/datum/ai_behavior/target_from_retaliate_list/perform(seconds_per_tick, datum/ai_controller/controller, shitlist_key, target_key, targetting_datum_key, hiding_location_key, ignore_faction, tame_key)
	var/mob/living/living_mob = controller.pawn
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]
	var/tamed = controller.blackboard[tame_key]
	var/mob/living/targetted = controller.blackboard[target_key]

	if(!targetting_datum)
		CRASH("No target datum was supplied in the blackboard for [controller.pawn]")
	
	if (tamed && !QDELETED(targetted)) //if we have a retal target as a tamed pawn, chance to drop aggro
		var/deaggro_chance = 23 // why 23? I don't know. It was in the code.
		if(prob(deaggro_chance))
			living_mob.visible_message(span_notice("[living_mob] calms down.")) 
			controller.clear_blackboard_key(shitlist_key)
			controller.clear_blackboard_key(target_key)
			controller.CancelActions() // Otherwise they will try and get one last attack
			return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED

	var/list/shitlist = controller.blackboard[shitlist_key]
	if (!length(shitlist))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

	//If we're good with our current target - in enemies list and ok with targetting datum
	if (!QDELETED(targetted) && (locate(targetted) in shitlist) && targetting_datum.can_attack(living_mob, targetted, vision_range))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED

	var/list/enemies_list = list() //use shitlist to make new list of potentials
	for(var/mob/living/living_target in shitlist)
		if(living_target.rogue_sneaking) // can't see them
			continue
		var/extra_chance = (living_mob.health <= living_mob.maxHealth * 50) ? 30 : 0 // if we're below half health, we're way more alert
		if(!living_mob.npc_detect_sneak(living_target, extra_chance))
			continue //still can't see them
		if(!targetting_datum.can_attack(living_mob, living_target)) //not ok with target strat
			continue
		enemies_list += living_target

	if (!length(enemies_list)) // no valid targets, not shitlist or target so just clear everything. start again
		controller.clear_blackboard_key(shitlist_key)
		controller.clear_blackboard_key(target_key)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	var/atom/new_target = pick_final_target(controller, enemies_list)
	controller.set_blackboard_key(target_key, new_target)

	var/atom/potential_hiding_location = targetting_datum.find_hidden_mobs(living_mob, new_target)

	if(potential_hiding_location) //If they're hiding inside of something, we need to know so we can go for that instead initially.
		controller.set_blackboard_key(hiding_location_key, potential_hiding_location)

	return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED

/// Returns true if this target is valid for attacking based on current conditions
/datum/ai_behavior/target_from_retaliate_list/proc/can_attack_target(mob/living/living_mob, atom/target, datum/targetting_datum/targetting_datum)
	if (!target)
		return FALSE
	if (target == living_mob)
		return FALSE
	if (!can_see(living_mob, target, vision_range))
		return FALSE
	return targetting_datum.can_attack(living_mob, target)

/// Returns the desired final target from the filtered list of enemies
/datum/ai_behavior/target_from_retaliate_list/proc/pick_final_target(datum/ai_controller/controller, list/enemies_list)
	return pick(enemies_list)
