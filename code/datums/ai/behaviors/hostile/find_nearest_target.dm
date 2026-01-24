/// Picks targets based on which one is closest to you, choice between targets at equal distance is arbitrary
/datum/ai_behavior/find_potential_targets/nearest

/datum/ai_behavior/find_potential_targets/nearest/perform(seconds_per_tick, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	// Use the mob's aggro_vision_range if available, otherwise fall back to the behavior's vision_range
	var/mob/living/simple_animal/hostile/hostile_mob = controller.pawn
	if(istype(hostile_mob) && hostile_mob.aggro_vision_range)
		vision_range = hostile_mob.aggro_vision_range
	return ..()

/datum/ai_behavior/find_potential_targets/nearest/pick_final_target(datum/ai_controller/controller, list/filtered_targets)
	var/turf/our_position = get_turf(controller.pawn)
	return get_closest_atom(/atom/, filtered_targets, our_position)

/// As above but targets have been filtered from the 'retaliate' blackboard list
/datum/ai_behavior/target_from_retaliate_list/nearest

/datum/ai_behavior/target_from_retaliate_list/nearest/pick_final_target(datum/ai_controller/controller, list/enemies_list)
	var/turf/our_position = get_turf(controller.pawn)
	return get_closest_atom(/atom/, enemies_list, our_position)
