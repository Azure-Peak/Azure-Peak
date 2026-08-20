#define BB_RAT_SUMMON_READY "rat_summon_ready"

/datum/ai_controller/rat/undead
	movement_delay = RAT_UNDEAD_MOVEMENT_SPEED
	ai_movement = /datum/ai_movement/hybrid_pathing
	idle_behavior = /datum/idle_behavior/idle_random_walk

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
		BB_RAT_SUMMON_READY = TRUE // Checked before summoning. Offspring will have this initialized to FALSE.
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/summon_rat,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

/datum/ai_controller/rat/undead/summoned
	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

/datum/ai_planning_subtree/summon_rat

/datum/ai_planning_subtree/summon_rat/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target))
		return
	if(!controller.blackboard[BB_RAT_SUMMON_READY])
		return
	controller.queue_behavior(/datum/ai_behavior/summon_rat, BB_BASIC_MOB_CURRENT_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/summon_rat
	var/summon_windup = 0.5 SECONDS

/datum/ai_behavior/summon_rat/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	var/mob/living/simple_animal/summoner = controller.pawn
	var/atom/target = controller.blackboard[target_key]

	if(QDELETED(target) || summoner.buckled || summoner.incapacitated())
		finish_action(controller, FALSE)
		return

	// Instantly consume the summon charge so it can't be spammed during windup
	controller.set_blackboard_key(BB_RAT_SUMMON_READY, FALSE)

	if(do_after(summoner, summon_windup))
		summoner.visible_message(span_danger("<b>[summoner]</b> lets out a sickening screech, calling forth reinforcements!"))
		playsound(summoner, 'sound/magic/slimesquish.ogg', 75, TRUE)

		// Find an open adjacent turf to place the phantom
		var/turf/origin = get_turf(summoner)
		var/turf/spawn_turf
		var/list/dirs = GLOB.alldirs.Copy()

		while(length(dirs))
			var/picked_dir = pick_n_take(dirs)
			var/turf/T = get_step(origin, picked_dir)
			if(T && !T.is_blocked_turf(exclude_mobs = TRUE))
				spawn_turf = T
				break

		// Fallback to origin turf if all surrounding tiles are completely blocked
		if(!spawn_turf)
			spawn_turf = origin

		// Initialize the phantom with our target mob, no rot path, and custom 5 second delay
		new /obj/effect/temp_visual/hunting_phantom(spawn_turf, /mob/living/simple_animal/hostile/retaliate/rogue/bigrat/undead/summoned, null, 5 SECONDS)
	else
		// We got cancelled by something, try again.
		controller.set_blackboard_key(BB_RAT_SUMMON_READY, TRUE)

	finish_action(controller, TRUE)

#undef BB_RAT_SUMMON_READY
