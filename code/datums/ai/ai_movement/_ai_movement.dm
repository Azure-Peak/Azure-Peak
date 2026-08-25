///This datum is an abstract class that can be overriden for different types of movement
/datum/ai_movement
	///Assoc list ist of controllers that are currently moving as key, and what they are moving to as value
	var/list/moving_controllers = list()
	///Does this ai require processing?
	var/requires_processing = TRUE
	///how many attempts do we make at pathing
	var/max_pathing_attempts
	///how long path limit movements bother checking
	var/max_path_distance = 30

/datum/ai_movement/proc/start_moving_towards(datum/ai_controller/controller, atom/current_movement_target, min_distance)
	controller.pathing_attempts = 0
	controller.set_blackboard_key(BB_CURRENT_MIN_MOVE_DISTANCE, min_distance)
	if(!moving_controllers.len && requires_processing)
		START_PROCESSING(SSai_movement, src)
	moving_controllers[controller] = current_movement_target

/datum/ai_movement/proc/stop_moving_towards(datum/ai_controller/controller)
	controller.pathing_attempts = 0
	moving_controllers -= controller
	if(!moving_controllers.len && requires_processing)
		STOP_PROCESSING(SSai_movement, src)

/datum/ai_movement/proc/charge_diagonal_step(datum/ai_controller/controller, turf/from)
	if(!from)
		return
	var/turf/landed = get_turf(controller.pawn)
	if(!landed || landed.z != from.z)
		return
	if(landed.x != from.x && landed.y != from.y)
		controller.movement_cooldown += controller.movement_delay
