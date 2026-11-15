#define NPC_WINDED_DEFAULT			0.75
#define NPC_RECOVERED_AT			0.35
#define DISENGAGE_PRESSURE_RANGE	2
#define DISENGAGE_KEEP_DISTANCE		3
#define DISENGAGE_RANGED_WINDOW		(3 SECONDS)
#define DISENGAGE_ALLY_RANGE		7

/proc/npc_is_winded(datum/ai_controller/controller)
	var/mob/living/pawn = controller.pawn
	if(!isliving(pawn) || pawn.max_stamina <= 0)
		return FALSE
	var/ratio = pawn.stamina / pawn.max_stamina
	if(controller.blackboard[BB_NPC_WINDED])
		if(ratio > NPC_RECOVERED_AT)
			return TRUE
		controller.clear_blackboard_key(BB_NPC_WINDED)
		AI_THINK(pawn, "STAMINA: recovered ([pawn.stamina]/[pawn.max_stamina])")
		pawn.visible_message(span_warning("[pawn] catches [pawn.p_their()] breath!"))
		return FALSE
	if(ratio < (controller.blackboard[BB_NPC_WINDED_AT] || NPC_WINDED_DEFAULT))
		return FALSE
	controller.set_blackboard_key(BB_NPC_WINDED, TRUE)
	AI_THINK(pawn, "STAMINA: winded ([pawn.stamina]/[pawn.max_stamina])")
	pawn.visible_message(span_warning("[pawn] gasps for breath!"))
	pawn.emote("painmoan")
	return TRUE

/proc/npc_has_backup(mob/living/pawn)
	for(var/mob/living/other in view(DISENGAGE_ALLY_RANGE, pawn))
		if(other == pawn || other.stat != CONSCIOUS)
			continue
		if(pawn.faction_check_mob(other))
			return TRUE
	return FALSE

/datum/ai_planning_subtree/stamina_disengage
	var/yield_at_range = FALSE

/datum/ai_planning_subtree/stamina_disengage/caster
	yield_at_range = TRUE

/datum/ai_planning_subtree/stamina_disengage/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target) || !npc_is_winded(controller))
		return
	var/mob/living/pawn = controller.pawn
	var/range = get_dist(pawn, target)
	if(range > DISENGAGE_PRESSURE_RANGE && world.time - controller.blackboard[BB_LAST_HIT_TIME] < DISENGAGE_RANGED_WINDOW)
		return
	var/close = range < DISENGAGE_KEEP_DISTANCE
	if(yield_at_range && !close)
		return
	if(npc_has_backup(pawn))
		controller.queue_behavior(/datum/ai_behavior/run_away_from_target, BB_BASIC_MOB_CURRENT_TARGET, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
		return SUBTREE_RETURN_FINISH_PLANNING
	if(close)
		controller.queue_behavior(/datum/ai_behavior/back_off_facing, BB_BASIC_MOB_CURRENT_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/back_off_facing
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	required_distance = 0
	action_cooldown = 0.2 SECONDS

/datum/ai_behavior/back_off_facing/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	var/atom/target = controller.blackboard[target_key]
	var/mob/living/pawn = controller.pawn
	if(QDELETED(target) || !isliving(pawn))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	if(!COOLDOWN_FINISHED(controller, movement_cooldown) || !controller.can_move())
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED
	var/away = turn(npc_face_dir(pawn, target), 180)
	var/current = get_dist(pawn, target)
	for(var/move_dir in list(away, turn(away, 90), turn(away, -90)))
		var/turf/destination = get_step(pawn, move_dir)
		if(!destination || get_dist(destination, target) < current)
			continue
		if(ai_strafe_move(controller, pawn, target, move_dir))
			break
	return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED

#undef NPC_WINDED_DEFAULT
#undef NPC_RECOVERED_AT
#undef DISENGAGE_PRESSURE_RANGE
#undef DISENGAGE_KEEP_DISTANCE
#undef DISENGAGE_RANGED_WINDOW
#undef DISENGAGE_ALLY_RANGE
