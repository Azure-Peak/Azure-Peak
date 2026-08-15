/datum/ai_planning_subtree/spacing //keep distance during attack cooldown, dip back in after. This may be cycle taxing
	/// Blackboard key holding atom we want to stay away from
	var/target_key = BB_BASIC_MOB_CURRENT_TARGET
	/// How close will we allow our target to get?
	var/minimum_distance = 1
	/// How far away will we allow our target to get?
	var/maximum_distance = 4

	var/view_distance = 8
	/// the run away behavior we will use
	var/run_away_behavior = /datum/ai_behavior/step_away
	var/need_los = FALSE

/datum/ai_planning_subtree/spacing/spear
	minimum_distance = 2
	/// How far away will we allow our target to get?
	maximum_distance = 2

/datum/ai_planning_subtree/spacing/melee
	minimum_distance = 2
	/// How far away will we allow our target to get?
	maximum_distance = 2

/datum/ai_planning_subtree/spacing/ranged //keep distance during attack cooldown, dip back in after. This may be cycle taxing
	/// How close will we allow our target to get?
	minimum_distance = 3
	/// How far away will we allow our target to get?
	maximum_distance = 6

	need_los = TRUE // this means that simple ranged mobs will seek out their targets - probably at their own peril


/datum/ai_planning_subtree/spacing/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	var/mob/living/living_pawn = controller.pawn

	if (!isliving(target))
		return
	if(need_los && !can_see(controller.pawn, target, view_distance)) //Chase into vision if need be. For ranged
		return

	var/range = get_dist(living_pawn, target)
	var/ready_to_attack = is_ready_to_attack(controller, living_pawn)

	// If you are committed to moving toward the enemy, do not space away from enemies so that telegraphed strike follows.
	if (world.time < controller.blackboard[BB_ABILITY_COMMITTED_UNTIL])
		controller.queue_behavior(/datum/ai_behavior/pursue_to_range, target_key, minimum_distance)
		return

	if (range < minimum_distance) // they closed on us, give ground regardless
		AI_THINK(living_pawn, "SPACING: too close ([range]<[minimum_distance]), backing off")
		controller.queue_behavior(run_away_behavior, target_key, minimum_distance)
		return

	if (!ready_to_attack)
		if (should_give_ground(controller, living_pawn))
			AI_THINK(living_pawn, "SPACING: on cooldown at [range], giving ground")
			controller.queue_behavior(run_away_behavior, target_key, minimum_distance)
			return
		// Staying on them instead. Close to melee rather than idling at spacing range.
		AI_THINK(living_pawn, "SPACING: on cooldown at [range], piling on")
		controller.queue_behavior(/datum/ai_behavior/pursue_to_range, target_key, 1)
		return
	var/canReach = need_los || living_pawn.Adjacent(target) || living_pawn.CanReach(target)	//Check adjacency first because (probably) cheaper
	if ((range > maximum_distance) || (ready_to_attack) || !canReach) // next attack ready or target too far for us
		if(!canReach) //living_pawn.a_intent.reach if we can't reach then move into melee - possibly on a corner
			minimum_distance = 1
		AI_THINK(living_pawn, "SPACING: closing to [minimum_distance] from [range][ready_to_attack ? " (ready)" : ""]")
		controller.queue_behavior(/datum/ai_behavior/pursue_to_range, target_key, minimum_distance)
		return

/// Whether we back off during our attack cooldown, or stay in their face. Default is always back off.
/datum/ai_planning_subtree/spacing/proc/should_give_ground(datum/ai_controller/controller, mob/living/living_pawn)
	return TRUE

/// Melee swing cadence, which is what spacing was built around.
/datum/ai_planning_subtree/spacing/proc/is_ready_to_attack(datum/ai_controller/controller, mob/living/living_pawn)
	return living_pawn.next_move < world.time

/*
	next_move is melee cadence and is almost always in the past for a ranged mob, so it read as
	permanently ready and advanced to minimum range forever instead of ever falling back.
*/
/datum/ai_planning_subtree/spacing/ranged/is_ready_to_attack(datum/ai_controller/controller, mob/living/living_pawn)
	for(var/datum/action/cooldown/special in living_pawn.actions)
		if(special.npc_max_range > 1 && special.IsAvailable())
			return TRUE
	return FALSE

/datum/ai_planning_subtree/spacing/cover_minimum_distance
	run_away_behavior = /datum/ai_behavior/cover_minimum_distance

/*
	Orbits instead of retreating in a straight line, so the approach angle keeps changing between attack
*/
/datum/ai_planning_subtree/spacing/circling
	run_away_behavior = /datum/ai_behavior/circle_target

/datum/ai_planning_subtree/spacing/circling/melee
	minimum_distance = 2
	maximum_distance = 2

/*
	Keeps orbiting and circling you until you attack them enough to back off.
*/
/datum/ai_planning_subtree/spacing/circling/reactive
	minimum_distance = 2
	maximum_distance = 2
	/// Having been hit inside this window is reason enough to break off.
	var/react_window = 3 SECONDS
	/// Swings thrown without repositioning before it wants a new angle anyway.
	var/swings_before_circling = 3

/datum/ai_planning_subtree/spacing/circling/reactive/should_give_ground(datum/ai_controller/controller, mob/living/living_pawn)
	var/last_hit = controller.blackboard[BB_LAST_HIT_TIME] || 0
	var/swings = controller.blackboard[BB_SWINGS_SINCE_CIRCLING] || 0
	if((world.time - last_hit > react_window) && (swings < swings_before_circling))
		return FALSE
	controller.blackboard[BB_SWINGS_SINCE_CIRCLING] = 0
	return TRUE

/datum/ai_behavior/circle_target
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	required_distance = 0
	action_cooldown = 0.2 SECONDS

/datum/ai_behavior/circle_target/perform(seconds_per_tick, datum/ai_controller/controller, target_key, minimum_distance)
	var/atom/current_target = controller.blackboard[target_key]
	var/mob/living/our_pawn = controller.pawn
	if(QDELETED(current_target) || !isliving(our_pawn))
		finish_action(controller, succeeded = FALSE)
		return
	if(!COOLDOWN_FINISHED(controller, movement_cooldown))
		return
	controller.advance_movement_cooldown()
	if(get_dist(our_pawn, current_target) < minimum_distance)
		var/turf/give_ground = get_step_away(our_pawn, current_target)
		if(give_ground && !give_ground.is_blocked_turf(exclude_mobs = TRUE))
			our_pawn.Move(give_ground, get_dir(our_pawn, give_ground))
			our_pawn.face_atom(current_target)
			finish_action(controller, succeeded = TRUE)
			return
	our_pawn.combat_sidestep(current_target, null, TRUE)
	finish_action(controller, succeeded = TRUE)

/// Take one step away
/datum/ai_behavior/step_away
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	required_distance = 0
	action_cooldown = 0.2 SECONDS

/datum/ai_behavior/step_away/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/current_target = controller.blackboard[target_key]
	if (QDELETED(current_target))
		return FALSE

	var/mob/living/our_pawn = controller.pawn
	our_pawn.face_atom(current_target)

	var/turf/next_step = get_step_away(controller.pawn, current_target)
	if (!isnull(next_step) && !next_step.is_blocked_turf(exclude_mobs = TRUE))
		set_movement_target(controller, target = next_step, new_movement = /datum/ai_movement/basic_avoidance/backstep)
		return TRUE

	var/list/all_dirs = GLOB.alldirs.Copy()
	all_dirs -= get_dir(controller.pawn, next_step)
	all_dirs -= get_dir(controller.pawn, current_target)
	shuffle_inplace(all_dirs)

	for (var/dir in all_dirs)
		next_step = get_step(controller.pawn, dir)
		if (!isnull(next_step) && !next_step.is_blocked_turf(exclude_mobs = TRUE))
			set_movement_target(controller, target = next_step, new_movement = /datum/ai_movement/basic_avoidance/backstep)
			return TRUE
	return FALSE

/datum/ai_behavior/step_away/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	finish_action(controller, succeeded = TRUE)

/datum/ai_behavior/step_away/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.change_ai_movement_type(initial(controller.ai_movement))

/// Pursue a target until we are within a provided range
/datum/ai_behavior/pursue_to_range
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION | AI_BEHAVIOR_MOVE_AND_PERFORM
	action_cooldown = 0.2 SECONDS

/datum/ai_behavior/pursue_to_range/setup(datum/ai_controller/controller, target_key, range)
	. = ..()
	var/atom/current_target = controller.blackboard[target_key]
	if (QDELETED(current_target))
		return FALSE
	if (get_dist(controller.pawn, current_target) <= range)
		return FALSE
	set_movement_target(controller, current_target)

/datum/ai_behavior/pursue_to_range/perform(seconds_per_tick, datum/ai_controller/controller, target_key, range)
	var/atom/current_target = controller.blackboard[target_key]
	if (!QDELETED(current_target) && get_dist(controller.pawn, current_target) > range)
		return
	finish_action(controller, succeeded = TRUE)

///instead of taking a single step, we cover the entire distance
/datum/ai_behavior/cover_minimum_distance
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	required_distance = 0
	action_cooldown = 0.2 SECONDS

/datum/ai_behavior/cover_minimum_distance/setup(datum/ai_controller/controller, target_key, minimum_distance)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	var/required_distance = minimum_distance - get_dist(controller.pawn, target) //the distance we need to move
	var/distance = 0
	var/turf/chosen_turf
	for(var/turf/open/potential_turf in oview(required_distance, controller.pawn))
		var/new_distance_from_target = get_dist(potential_turf, target)
		if(potential_turf.is_blocked_turf())
			continue
		if(new_distance_from_target > distance)
			chosen_turf = potential_turf
			distance = new_distance_from_target
	if(isnull(chosen_turf))
		return FALSE
	set_movement_target(controller, target = chosen_turf)

/datum/ai_behavior/cover_minimum_distance/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()
	finish_action(controller, succeeded = TRUE)
