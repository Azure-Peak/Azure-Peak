///Uses Byond's basic obstacle avoidance mvovement
/datum/ai_movement/basic_avoidance
	requires_processing = TRUE
	max_pathing_attempts = 10


///Put your movement behavior in here!
/datum/ai_movement/basic_avoidance/process(delta_time)
	for(var/datum/ai_controller/controller as anything in moving_controllers)
		if(!COOLDOWN_FINISHED(controller, movement_cooldown))
			continue
		COOLDOWN_START(controller, movement_cooldown, controller.movement_delay)

		var/atom/movable/movable_pawn = controller.pawn
		if(!controller.can_move())
			continue

		var/current_loc = get_turf(movable_pawn)

		var/turf/target_turf = get_step_towards(movable_pawn, controller.current_movement_target)

		if(target_turf?.can_traverse_safely(movable_pawn))
			if(istype(movable_pawn, /mob/living/simple_animal))
				var/dir_to_target = get_dir(current_loc, target_turf)			
				for(var/obj/structure/O in get_step(movable_pawn, dir_to_target))
					if(O.density && O.climbable)
						O.climb_structure(movable_pawn)
						break
			step_to(movable_pawn, controller.current_movement_target, controller.blackboard[BB_CURRENT_MIN_MOVE_DISTANCE], controller.movement_delay)

		if(current_loc == get_turf(movable_pawn)) //Did we even move after trying to move?
			controller.pathing_attempts++
			if(controller.pathing_attempts >= max_pathing_attempts)
				controller.CancelActions()

/datum/ai_movement/basic_avoidance/backstep
	//move_flags = MOVEMENT_LOOP_START_FAST
