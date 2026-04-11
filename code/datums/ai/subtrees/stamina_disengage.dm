#define STAMINA_DISENGAGE_THRESHOLD    0.85 // 85% stamina damage = nearly exhausted
#define STAMINA_REENGAGE_THRESHOLD     0.3  // recover to 30% before re-engaging
#define BB_STAMINA_DISENGAGED          "bb_stamina_disengaged"
#define BB_LAST_RANGED_HIT_TIME        "bb_last_ranged_hit_time"
#define RANGED_PRESSURE_WINDOW         (5 SECONDS) // if hit by ranged within this window, don't disengage

/// NPCs back off when nearly exhausted to recover stamina. Ranged pressure keeps them engaged.
/datum/ai_planning_subtree/stamina_disengage

/datum/ai_planning_subtree/stamina_disengage/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target || QDELETED(target))
		controller.clear_blackboard_key(BB_STAMINA_DISENGAGED)
		return

	var/mob/living/pawn = controller.pawn
	var/disengaged = controller.blackboard[BB_STAMINA_DISENGAGED]

	// Check if under ranged pressure — don't disengage if being shot at
	var/last_ranged = controller.blackboard[BB_LAST_RANGED_HIT_TIME]
	var/under_ranged_pressure = last_ranged && (world.time - last_ranged < RANGED_PRESSURE_WINDOW)

	if(disengaged)
		// Currently disengaged — check if recovered enough to re-engage
		if(pawn.stamina <= pawn.max_stamina * STAMINA_REENGAGE_THRESHOLD || under_ranged_pressure)
			controller.clear_blackboard_key(BB_STAMINA_DISENGAGED)
			AI_THINK(pawn, "STAMINA: recovered, re-engaging!")
			pawn.visible_message(span_warning("[pawn] catches their breath and presses the attack!"))
			return
		// Still recovering — back away
		controller.queue_behavior(/datum/ai_behavior/run_away_from_target, BB_BASIC_MOB_CURRENT_TARGET, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
		return SUBTREE_RETURN_FINISH_PLANNING

	// Not disengaged — check if we should start
	if(pawn.stamina >= pawn.max_stamina * STAMINA_DISENGAGE_THRESHOLD && !under_ranged_pressure)
		controller.set_blackboard_key(BB_STAMINA_DISENGAGED, TRUE)
		AI_THINK(pawn, "STAMINA: exhausted, backing off! ([pawn.stamina]/[pawn.max_stamina])")
		pawn.visible_message(span_warning("[pawn] staggers back, gasping for breath!"))
		pawn.emote("painmoan")
		return // will disengage next tick

#undef STAMINA_DISENGAGE_THRESHOLD
#undef STAMINA_REENGAGE_THRESHOLD
#undef BB_STAMINA_DISENGAGED
#undef BB_LAST_RANGED_HIT_TIME
#undef RANGED_PRESSURE_WINDOW
