// Move to a position further away from your current target
//todo: Could possibly redo if we lose target to run away from their last known coordinates
/datum/ai_behavior/run_away_from_target
	required_distance = 0
	action_cooldown = 0
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION | AI_BEHAVIOR_MOVE_AND_PERFORM
	/// How far do we try to run? Further makes for smoother running, but potentially weirder pathfinding
	var/run_distance = 8
	var/until_destination = FALSE

/datum/ai_behavior/run_away_from_target/setup(datum/ai_controller/controller, target_key, hiding_location_key)
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]

	if(QDELETED(target))
		return FALSE

	if (!plot_path_away_from(controller, target))
		return FALSE
	return ..()

/datum/ai_behavior/run_away_from_target/perform(delta_time, datum/ai_controller/controller, target_key, hiding_location_key)
	. = ..()
	//
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]
	var/escaped =	QDELETED(target) || !can_see(controller.pawn, target, run_distance) // If we can't see it we got away
	if (escaped)
		finish_action(controller, succeeded = TRUE)
		return
	if (!in_range(controller.pawn, controller.current_movement_target))
		if(until_destination)
			finish_action(controller, succeeded = TRUE)
		return
	if (plot_path_away_from(controller, target))
		return
	finish_action(controller, succeeded = TRUE)

/datum/ai_behavior/run_away_from_target/proc/plot_path_away_from(datum/ai_controller/controller, atom/target)
	var/turf/target_destination = get_turf(controller.pawn)
	var/static/list/offset_angles = list(45, 90, 135, 180, 225, 270)
	for(var/angle in offset_angles)
		var/turf/test_turf = get_furthest_turf(controller.pawn, angle, target)
		if(isnull(test_turf))
			continue
		var/distance_from_target = get_dist(target, test_turf)
		if(distance_from_target <= get_dist(target, target_destination))
			continue
		target_destination = test_turf
		if(distance_from_target == run_distance) //we already got the max running distance
			break
	if (target_destination == get_turf(controller.pawn))
		return FALSE
	set_movement_target(controller, target_destination)
	return TRUE

/datum/ai_behavior/run_away_from_target/proc/get_furthest_turf(atom/source, angle, atom/target)
	var/turf/return_turf
	for(var/i in 1 to run_distance)
		var/turf/test_destination = get_ranged_target_turf_direct(source, target, range = i, offset = angle)
		if(is_blocked_turf(test_destination, exclude_mobs = !source.density))
			break
		return_turf = test_destination
	return return_turf

/datum/ai_behavior/run_away_from_target/until_destination
	until_destination = TRUE
	run_distance = 4

/datum/ai_behavior/run_away_from_target/until_destination/finish_action(datum/ai_controller/controller, succeeded, target_key, hiding_location_key)
	. = ..()

	controller.set_blackboard_key(BB_BASIC_MOB_RUN_WITH_ITEM, FALSE)
