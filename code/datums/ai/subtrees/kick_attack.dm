#define BB_KICK_COOLDOWN           "bb_kick_cooldown"
#define BB_GRAB_REACTION_AT        "bb_grab_reaction_at"
#define BB_GRAB_REACTION_GRABBER   "bb_grab_reaction_grabber"
#define KICK_COOLDOWN              (20 SECONDS)
#define KICK_WALLED_CHANCE         30  // target backed against a wall
#define KICK_CHOKEPOINT_CHANCE     25  // target in a doorway/corridor (2+ dense neighbors)
#define KICK_STACKED_ENEMY_CHANCE  20  // non-allied mob behind target to knock into
#define KICK_OPPORTUNISTIC_CHANCE  10  // target is off-balanced, prone, or stunned
#define KICK_EXHAUSTED_CHANCE      35  // target is fatigued - kick guarantees knockdown
#define KICK_EXHAUSTED_THRESHOLD   1 // 1 = fully exhausted, guarantees knockdown per species.dm
#define KICK_CHOKEPOINT_THRESHOLD  2   // minimum dense cardinal neighbors to count as chokepoint
#define GRAB_REACTION_BASE         20  // deciseconds; reduced by (STAINT + STAPER)
#define GRAB_REACTION_MIN          3   // floor so even maxed stats can't be frame-perfect
#define GRAB_REACTION_JITTER       2   // +/- deciseconds of randomness

/datum/ai_planning_subtree/kick_attack

/datum/ai_planning_subtree/kick_attack/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target || QDELETED(target))
		return
	var/mob/living/pawn = controller.pawn
	if(!pawn.Adjacent(target))
		return
	if(pawn.IsOffBalanced())
		return
	if(pawn.get_num_legs() < 2)
		return
	// Don't kick a downed target you cruel bastard
	if(!(target.mobility_flags & MOBILITY_STAND))
		return

	// Cooldown check via blackboard
	var/next_kick = controller.blackboard[BB_KICK_COOLDOWN]
	if(next_kick && world.time < next_kick)
		return

	// Shared technique cooldown prevents kick/feint/special from chaining back-to-back.
	var/next_technique = controller.blackboard[BB_HUMAN_NPC_TECHNIQUE_CD]
	if(next_technique && world.time < next_technique)
		return

	var/turf/target_turf = get_turf(target)
	var/kick_dir = get_dir(pawn, target)
	var/should_kick = FALSE

	// Situation 0: Being passive-grabbed - instinctive self-preservation. Skill-gated
	// reaction delay so a dim goblin (low INT+PER) is slow to respond; sharp NPCs react fast.
	var/mob/stored_grabber = controller.blackboard[BB_GRAB_REACTION_GRABBER]
	if(pawn.pulledby == target && pawn.pulledby.grab_state < GRAB_AGGRESSIVE)
		if(stored_grabber != pawn.pulledby)
			// Newly grabbed (or grabber changed) - roll a fresh reaction timer.
			var/reaction_delay = max(GRAB_REACTION_MIN, GRAB_REACTION_BASE - (pawn.STAINT + pawn.STAPER))
			reaction_delay += rand(-GRAB_REACTION_JITTER, GRAB_REACTION_JITTER)
			controller.set_blackboard_key(BB_GRAB_REACTION_AT, world.time + reaction_delay)
			controller.set_blackboard_key(BB_GRAB_REACTION_GRABBER, pawn.pulledby)
		else if(world.time >= controller.blackboard[BB_GRAB_REACTION_AT])
			should_kick = TRUE
	else if(stored_grabber)
		// No longer grabbed - clear so next grab gets a fresh roll.
		controller.clear_blackboard_key(BB_GRAB_REACTION_AT)
		controller.clear_blackboard_key(BB_GRAB_REACTION_GRABBER)

	// Situation 1: Chokepoint - target in a doorway/corridor (instinctive, no INT gate)
	var/dense_neighbors = 0
	for(var/dir in GLOB.cardinals)
		var/turf/T = get_step(target_turf, dir)
		if(!T || T.density)
			dense_neighbors++
			continue
		for(var/obj/structure/S in T)
			if(S.density)
				dense_neighbors++
				break
	if(dense_neighbors >= KICK_CHOKEPOINT_THRESHOLD && prob(KICK_CHOKEPOINT_CHANCE))
		should_kick = TRUE

	// Situation 2+: Tactical kicks require INT 8+
	var/turf/behind_target = get_step(target_turf, kick_dir)
	if(!should_kick && pawn.STAINT >= 8)
		// Target against a wall
		var/walled = FALSE
		if(!behind_target || behind_target.density)
			walled = TRUE
		else
			for(var/obj/structure/S in behind_target)
				if(S.density)
					walled = TRUE
					break
		if(walled && AI_INT_SCALE_PROB(pawn, KICK_WALLED_CHANCE))
			should_kick = TRUE

		// Two non-allied enemies stacked - kick one into the other
		if(!should_kick && behind_target && !behind_target.density)
			for(var/mob/living/M in behind_target)
				if(M == pawn)
					continue
				if(pawn.faction_check_mob(M))
					continue
				if(AI_INT_SCALE_PROB(pawn, KICK_STACKED_ENEMY_CHANCE))
					should_kick = TRUE
					break

		// Opportunistic - target is vulnerable (prone handled by the global gate above)
		if(!should_kick)
			if(target.IsOffBalanced() || target.IsStun())
				if(AI_INT_SCALE_PROB(pawn, KICK_OPPORTUNISTIC_CHANCE))
					should_kick = TRUE

		// Target is exhausted
		if(!should_kick)
			if(target.stamina >= target.max_stamina * KICK_EXHAUSTED_THRESHOLD)
				if(AI_INT_SCALE_PROB(pawn, KICK_EXHAUSTED_CHANCE))
					should_kick = TRUE

	if(!should_kick)
		return

	controller.queue_behavior(/datum/ai_behavior/npc_kick_attack, BB_BASIC_MOB_CURRENT_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/npc_kick_attack
	action_cooldown = 0.5 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/npc_kick_attack/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(!target)
		return FALSE
	set_movement_target(controller, target)

/datum/ai_behavior/npc_kick_attack/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/pawn = controller.pawn
	var/mob/living/target = controller.blackboard[target_key]

	if(!target || QDELETED(target) || !pawn.Adjacent(target))
		finish_action(controller, FALSE, target_key)
		return

	if(!pawn.can_kick(target, do_message = FALSE))
		finish_action(controller, FALSE, target_key)
		return

	// Aim low when prone - kick at feet/legs
	if(!(pawn.mobility_flags & MOBILITY_STAND))
		pawn.aimheight_change(rand(1, 4))

	// Set up kick intent
	var/old_mmb = pawn.mmb_intent
	pawn.mmb_intent = new INTENT_KICK(pawn)
	pawn.try_kick(target)
	QDEL_NULL(pawn.mmb_intent)
	pawn.mmb_intent = old_mmb

	controller.set_blackboard_key(BB_KICK_COOLDOWN, world.time + KICK_COOLDOWN)
	controller.set_blackboard_key(BB_HUMAN_NPC_TECHNIQUE_CD, world.time + 3 SECONDS)
	// Kick is a committed action; block the next melee swing briefly so they don't immediately
	// combo into a full attack right after.
	if(pawn.next_click < world.time + 1.2 SECONDS)
		pawn.next_click = world.time + 1.2 SECONDS
	AI_THINK(pawn, "KICK: kicked [target]!")
	finish_action(controller, TRUE, target_key)

/datum/ai_behavior/npc_kick_attack/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)

#undef BB_KICK_COOLDOWN
#undef BB_GRAB_REACTION_AT
#undef BB_GRAB_REACTION_GRABBER
#undef KICK_COOLDOWN
#undef KICK_WALLED_CHANCE
#undef KICK_CHOKEPOINT_CHANCE
#undef KICK_STACKED_ENEMY_CHANCE
#undef KICK_OPPORTUNISTIC_CHANCE
#undef KICK_EXHAUSTED_CHANCE
#undef KICK_EXHAUSTED_THRESHOLD
#undef KICK_CHOKEPOINT_THRESHOLD
#undef GRAB_REACTION_BASE
#undef GRAB_REACTION_MIN
#undef GRAB_REACTION_JITTER
