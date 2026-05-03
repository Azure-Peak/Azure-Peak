// adds a third tier of reduction to hybrid movement
// so now it goes: Dumb Movement -> Basic Avoidance -> A*
/datum/ai_movement/hybrid_pathing/dumb_hybrid_movement
	max_path_distance = 200
	repath_distance_tolerance = 5
	
	var/dumb_stuck_duration = 2 SECONDS // how long the direct step must be continuously blocked before graduating to basic avoidance & A*
	var/list/dumb_stuck_since = list() // tracks when someone on Dumb Movement stopped making progress
	var/list/dumb_promoted = list()	// controllers "promoted" to use full pathfinding/a*
	var/list/dumb_weakrefs = list()

// We're Sending Every Goon to Jupiter To Get More Stupider
/datum/ai_movement/hybrid_pathing/dumb_hybrid_movement/goon
	max_basic_failures = 3
	max_pathing_attempts = 10 // 3 basic failures + 7 a* attempts
	
	// a hard limit on A* attempts. reduces the impact of a mob endlessly trying to reach something it can't (the most tragic example being: a viable target behind something transparent)
	repath_cooldown_duration = 8 SECONDS 
	repath_anticipation_cooldown_duration = 2 SECONDS

/datum/ai_movement/hybrid_pathing/dumb_hybrid_movement/pre_movement_hook(datum/ai_controller/controller, atom/movable/movable_pawn, turf/target_turf)
	if(controller in dumb_promoted)
		return FALSE

	var/datum/weakref/weak = dumb_weakrefs[controller]
	var/turf/current_loc = get_turf(movable_pawn)
	var/turf/next_step = get_step(movable_pawn, get_dir(movable_pawn, target_turf))
	var/direct_step_blocked = !next_step || next_step.is_blocked_turf(source_atom = movable_pawn)

	movable_pawn.Move(next_step, get_dir(current_loc, next_step))

	var/actually_moved = current_loc != get_turf(movable_pawn)
	if(actually_moved) // we still want to track pathing_attempts for the base hybrid_movement's sake
		controller.pathing_attempts = 0

	if(direct_step_blocked)
		if(isnull(dumb_stuck_since[weak]))
			dumb_stuck_since[weak] = world.time
		if(world.time - dumb_stuck_since[weak] >= dumb_stuck_duration)  // stuck for too long
			dumb_stuck_since -= weak
			dumb_promoted |= controller
			return FALSE // graduate to basic avoidance & A*
	else
		dumb_stuck_since -= weak

	return TRUE

// resets back to being dumb whenever a new movement target gets assigned
/datum/ai_movement/hybrid_pathing/dumb_hybrid_movement/start_moving_towards(datum/ai_controller/controller, atom/current_movement_target, min_distance)
	controller.pathing_attempts = 0
	dumb_promoted -= controller
	var/datum/weakref/weak = WEAKREF(controller)
	dumb_weakrefs[controller] = weak
	dumb_stuck_since -= weak
	dumb_stuck_duration = rand(1, 4) SECONDS // randomized stuck duration, to pad out the CPU load of swarms of goons swapping to a*
	return ..()

/datum/ai_movement/hybrid_pathing/dumb_hybrid_movement/stop_moving_towards(datum/ai_controller/controller)
	dumb_promoted -= controller
	var/datum/weakref/weak = dumb_weakrefs[controller]
	dumb_stuck_since -= weak
	dumb_weakrefs -= controller
	controller.pathing_attempts = 0
	return ..()

/datum/ai_movement/hybrid_pathing/dumb_hybrid_movement/process(delta_time)
	if(world.time >= next_resolve)
		for(var/datum/ai_controller/controller in dumb_promoted)
			if(QDELETED(controller))
				dumb_promoted -= controller
		for(var/datum/ai_controller/controller in dumb_weakrefs)
			if(QDELETED(controller))
				var/datum/weakref/weak = dumb_weakrefs[controller]
				dumb_stuck_since -= weak
				dumb_weakrefs -= controller
	return ..()

// goon-specific pre_movement_hook
/datum/ai_movement/hybrid_pathing/dumb_hybrid_movement/goon/pre_movement_hook(datum/ai_controller/controller, atom/movable/movable_pawn, turf/target_turf)
	if(controller in dumb_promoted)
		if(!COOLDOWN_FINISHED(controller, repath_cooldown))
			if(length(controller.movement_path))
				return FALSE
			var/turf/next_step = get_step(movable_pawn, get_dir(movable_pawn, target_turf))
			if(next_step) // whenever a* is on cooldown, we revert back to Dumb Moves
				movable_pawn.Move(next_step, get_dir(get_turf(movable_pawn), next_step))
			return TRUE
		if(controller.blackboard[BB_MOVEMENT_PATH_PROTECTED] && controller.movement_path)
			COOLDOWN_START(controller, repath_cooldown, repath_cooldown_duration)
			return FALSE
		controller.movement_path = null
		controller.clear_blackboard_key(future_path_blackboard_key)
		return FALSE
	return ..()
