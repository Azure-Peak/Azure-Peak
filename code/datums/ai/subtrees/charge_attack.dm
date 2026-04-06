#define BB_CHARGE_COOLDOWN         "bb_charge_cooldown"
#define CHARGE_COOLDOWN            (15 SECONDS)
#define CHARGE_MIN_DIST            3   // minimum tiles to start a charge
#define CHARGE_MAX_DIST            8   // maximum tiles to consider charging
#define CHARGE_BASE_CHANCE         15  // base % chance to charge when conditions met
#define CHARGE_STAT_ADVANTAGE      2   // how much stronger (STR+CON avg) NPC must be to consider charging

/// Subtree that makes NPCs sprint-charge at distant targets, using the game's built-in running tackle mechanic.
/datum/ai_planning_subtree/charge_attack

/datum/ai_planning_subtree/charge_attack/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target || QDELETED(target))
		return
	var/mob/living/pawn = controller.pawn
	if(!(pawn.mobility_flags & MOBILITY_STAND))
		return
	if(pawn.IsOffBalanced())
		return
	if(pawn.STAINT < 8)
		return // Too dumb to deliberately charge

	var/next_charge = controller.blackboard[BB_CHARGE_COOLDOWN]
	if(next_charge && world.time < next_charge)
		return

	var/dist = get_dist(pawn, target)
	if(dist < CHARGE_MIN_DIST || dist > CHARGE_MAX_DIST)
		return

	// Only charge if we have a stat advantage — don't suicide charge a stronger opponent
	var/self_points = FLOOR((pawn.STACON + pawn.STASTR) / 2, 1)
	var/target_points = FLOOR((target.STACON + target.STASTR) / 2, 1)
	if(self_points < target_points + CHARGE_STAT_ADVANTAGE)
		return

	// Check clear straight line to target
	var/turf/pawn_turf = get_turf(pawn)
	var/turf/target_turf = get_turf(target)
	if(pawn_turf.z != target_turf.z)
		return
	var/direction = get_dir(pawn, target)
	if(!(direction in GLOB.cardinals))
		return // Only charge in cardinal directions for clean sprint_dir
	var/turf/check = pawn_turf
	for(var/i in 1 to dist)
		check = get_step(check, direction)
		if(!check || check.density)
			return
		for(var/obj/structure/S in check)
			if(S.density)
				return

	if(!AI_INT_SCALE_PROB(pawn, CHARGE_BASE_CHANCE))
		return

	controller.queue_behavior(/datum/ai_behavior/npc_charge_run, BB_BASIC_MOB_CURRENT_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

/// Behavior: toggle run mode and sprint toward target. The game's MobBump handles the tackle.
/datum/ai_behavior/npc_charge_run
	action_cooldown = 0.5 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/npc_charge_run/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(!target)
		return FALSE
	var/mob/living/pawn = controller.pawn
	pawn.m_intent = MOVE_INTENT_RUN
	pawn.update_move_intent_slowdown()
	pawn.face_atom(target)
	AI_THINK(pawn, "CHARGE: sprinting at [target]!")
	controller.set_blackboard_key(BB_CHARGE_COOLDOWN, world.time + CHARGE_COOLDOWN)
	set_movement_target(controller, target)

/datum/ai_behavior/npc_charge_run/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/pawn = controller.pawn
	var/mob/living/target = controller.blackboard[target_key]

	if(!target || QDELETED(target))
		stop_charge(pawn)
		finish_action(controller, FALSE, target_key)
		return

	// If we reached them (adjacent), the MobBump already fired — stop running
	if(pawn.Adjacent(target))
		stop_charge(pawn)
		finish_action(controller, TRUE, target_key)
		return

	// If we got knocked down from the charge (lost the contest), stop
	if(!(pawn.mobility_flags & MOBILITY_STAND))
		stop_charge(pawn)
		finish_action(controller, FALSE, target_key)
		return

	// If we're no longer running (MobBump toggles back to walk on contact), stop
	if(pawn.m_intent != MOVE_INTENT_RUN)
		finish_action(controller, TRUE, target_key)
		return

/datum/ai_behavior/npc_charge_run/proc/stop_charge(mob/living/pawn)
	if(pawn.m_intent == MOVE_INTENT_RUN)
		pawn.m_intent = MOVE_INTENT_WALK
		pawn.update_move_intent_slowdown()

/datum/ai_behavior/npc_charge_run/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()
	var/mob/living/pawn = controller.pawn
	stop_charge(pawn)
