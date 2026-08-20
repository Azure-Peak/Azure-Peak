/datum/idle_behavior/idle_random_walk
	///Chance that the mob random walks per second
	var/walk_chance = 10

/datum/idle_behavior/idle_random_walk/perform_idle_behavior(delta_time, datum/ai_controller/controller)
	. = ..()
	if(controller.blackboard[BB_BASIC_MOB_FOOD_TARGET]) // this means we are likely eating a corpse (maybe also moving)
		return

	var/mob/living/simple_animal/simple_mob = controller.pawn
	if(istype(simple_mob) && simple_mob.binded)
		return FALSE
	var/mob/living/wanderer = controller.pawn
	if (wanderer.doing) //Doing something (like eating)
		return
	if(prob(walk_chance) && (wanderer.mobility_flags & MOBILITY_MOVE) && isturf(wanderer.loc) && !wanderer.pulledby)
		var/move_dir = pick(GLOB.alldirs)
		var/turf/target_turf = get_step(wanderer, move_dir)
		if(target_turf?.can_traverse_safely(wanderer))
			step_towards(wanderer, target_turf, wanderer.cached_multiplicative_slowdown)

/datum/idle_behavior/idle_random_walk/less_walking
	walk_chance = 5
