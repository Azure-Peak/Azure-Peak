#define LEAP_CHANCE_OBSTACLE    35    // % chance to leap when path is much longer than direct (railing/obstacle)
#define LEAP_CHANCE_OPEN        0     //
#define LEAP_MIN_DISTANCE       4     // tiles - target must be at least this far to leap
#define LEAP_MAX_DISTANCE       8     // tiles - don't leap if target is too far (waste of stamina)
#define LEAP_OBSTACLE_PATH_RATIO 1.5  // path must be at least this much longer than direct distance to count as "obstacle in the way"
#define LEAP_STAMINA_RESERVE    0.5   // require at least this much stamina headroom (0-1, fraction of max)
#define LEAP_COOLDOWN           (10 SECONDS)
#define LEAP_RUN_RANGE          3     // jump_action with MOVE_INTENT_RUN reaches 3 tiles
#define LEAP_WALK_RANGE         2     // without run, 2 tiles

/// Leap toward a distant target to close the gap. Mirrors the old npc_try_jump pre-AI-controller behavior.
/datum/ai_planning_subtree/leap_attack

/datum/ai_planning_subtree/leap_attack/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	if(!istype(pawn))
		return
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target || QDELETED(target))
		return

	if(world.time < controller.blackboard[BB_HUMAN_NPC_JUMP_COOLDOWN])
		AI_THINK(pawn, "LEAP gate: on cooldown")
		return

	// Don't leap if we can't physically jump
	if(!(pawn.mobility_flags & MOBILITY_STAND))
		AI_THINK(pawn, "LEAP gate: not standing")
		return
	if(pawn.IsOffBalanced() || pawn.legcuffed)
		AI_THINK(pawn, "LEAP gate: off-balance/legcuffed")
		return
	if(pawn.pulledby)
		AI_THINK(pawn, "LEAP gate: being pulled")
		return
	if(pawn.get_num_legs() < 2)
		AI_THINK(pawn, "LEAP gate: missing legs")
		return
	if(istype(get_turf(pawn), /turf/open/water))
		AI_THINK(pawn, "LEAP gate: in water")
		return

	// Stamina gate — don't burn ourselves out
	if(pawn.stamina > pawn.max_stamina * (1 - LEAP_STAMINA_RESERVE))
		AI_THINK(pawn, "LEAP gate: low stam reserve ([pawn.stamina]/[pawn.max_stamina])")
		return

	var/distance = get_dist(pawn, target)
	if(distance < LEAP_MIN_DISTANCE || distance > LEAP_MAX_DISTANCE)
		AI_THINK(pawn, "LEAP gate: distance [distance] outside [LEAP_MIN_DISTANCE]-[LEAP_MAX_DISTANCE]")
		return

	if(target.z != pawn.z && !HAS_TRAIT(pawn, TRAIT_ZJUMP))
		AI_THINK(pawn, "LEAP gate: target on different z, no zjump")
		return

	// Detect structural obstacle on the direct line — only fences, railings, dense structures.
	// Mobs in the way don't count (we don't want to leap over allies/players).
	var/has_obstacle = FALSE
	#ifdef NPC_THINK_DEBUG
	var/obstacle_reason = "none"
	#endif
	if(_leap_has_structural_obstacle(pawn, target))
		has_obstacle = TRUE
		#ifdef NPC_THINK_DEBUG
		obstacle_reason = "structural-LOS-blocked"
		#endif
	else
		var/list/movement_path = controller.movement_path
		if(length(movement_path) >= distance * LEAP_OBSTACLE_PATH_RATIO)
			has_obstacle = TRUE
			#ifdef NPC_THINK_DEBUG
			obstacle_reason = "path-length [length(movement_path)] >= [distance * LEAP_OBSTACLE_PATH_RATIO]"
			#endif

	var/leap_chance = has_obstacle ? LEAP_CHANCE_OBSTACLE : LEAP_CHANCE_OPEN
	if(!prob(leap_chance))
		AI_THINK(pawn, "LEAP gate: prob([leap_chance]%) failed (obstacle=[has_obstacle] [obstacle_reason])")
		return

	AI_THINK(pawn, "LEAP committed: dist=[distance] obstacle=[has_obstacle] reason=[obstacle_reason] chance=[leap_chance]%")
	controller.queue_behavior(/datum/ai_behavior/human_npc_leap, BB_BASIC_MOB_CURRENT_TARGET)

/// Walk the line from pawn to target and look for dense structures only — ignore mobs.
/datum/ai_planning_subtree/leap_attack/proc/_leap_has_structural_obstacle(mob/pawn, atom/target)
	var/turf/our_turf = get_turf(pawn)
	var/turf/their_turf = get_turf(target)
	if(!our_turf || !their_turf || our_turf.z != their_turf.z)
		return FALSE
	var/list/line = getline(our_turf, their_turf)
	if(length(line) <= 2) // adjacent — nothing in between
		return FALSE
	for(var/i in 2 to length(line) - 1) // skip the endpoints
		var/turf/T = line[i]
		if(!T)
			continue
		if(T.density)
			return TRUE
		for(var/obj/structure/S in T)
			if(S.density)
				return TRUE
	return FALSE

/datum/ai_behavior/human_npc_leap
	action_cooldown = 0.5 SECONDS
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/human_npc_leap/perform(delta_time, datum/ai_controller/controller, target_key)
	var/mob/living/carbon/human/pawn = controller.pawn
	if(!controller.can_move())
		finish_action(controller, FALSE)
		return
	var/mob/living/target = controller.blackboard[target_key]
	if(!target || QDELETED(target))
		finish_action(controller, FALSE)
		return

	// Pick a destination — prefer a turf adjacent to the target so we land in melee range, not on top
	var/turf/dest = get_step_towards(target, pawn)
	if(!dest || dest.density || !dest.can_traverse_safely(pawn))
		dest = get_turf(target)
	if(!dest || dest.density)
		AI_THINK(pawn, "LEAP abort: no valid destination")
		finish_action(controller, FALSE)
		return

	// Validate the leap path itself — if there's a wall/dense structure on the line between us
	// and dest, we'd just slam into it. Don't waste stamina and cooldown on a doomed jump.
	var/turf/our_turf = get_turf(pawn)
	if(our_turf && our_turf.z == dest.z)
		var/list/leap_line = getline(our_turf, dest)
		for(var/i in 2 to length(leap_line) - 1) // skip start, allow ending in melee range
			var/turf/T = leap_line[i]
			if(!T)
				continue
			if(T.density)
				AI_THINK(pawn, "LEAP abort: wall in leap path at [T]")
				finish_action(controller, FALSE)
				return
			for(var/obj/structure/S in T)
				if(S.density)
					AI_THINK(pawn, "LEAP abort: structure [S] in leap path")
					finish_action(controller, FALSE)
					return

	// Set up jump intent — jump_action() reads mmb_intent.clickcd
	var/datum/intent/old_mmb = pawn.mmb_intent
	var/datum/intent/old_used = pawn.used_intent
	var/old_m_intent = pawn.m_intent

	pawn.mmb_intent = new /datum/intent/jump(pawn)
	pawn.used_intent = pawn.mmb_intent
	// Run for full 3-tile range if the gap is wide enough
	if(get_dist(pawn, dest) > LEAP_WALK_RANGE)
		pawn.m_intent = MOVE_INTENT_RUN

	pawn.emote("battlecry", forced = TRUE)
	AI_THINK(pawn, "LEAP: jumping to [dest] (target=[target], dist=[get_dist(pawn, target)])")
	var/jumped = pawn.jump_action(dest)

	// Cleanup
	QDEL_NULL(pawn.mmb_intent)
	pawn.mmb_intent = old_mmb
	pawn.used_intent = old_used
	pawn.m_intent = old_m_intent

	controller.set_blackboard_key(BB_HUMAN_NPC_JUMP_COOLDOWN, world.time + LEAP_COOLDOWN)
	finish_action(controller, jumped)

#undef LEAP_CHANCE_OBSTACLE
#undef LEAP_CHANCE_OPEN
#undef LEAP_MIN_DISTANCE
#undef LEAP_MAX_DISTANCE
#undef LEAP_OBSTACLE_PATH_RATIO
#undef LEAP_STAMINA_RESERVE
#undef LEAP_COOLDOWN
#undef LEAP_RUN_RANGE
#undef LEAP_WALK_RANGE
