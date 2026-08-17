/datum/ai_planning_subtree/retrieve_arrows
	parent_type = /datum/ai_planning_subtree/archer_base

/datum/ai_planning_subtree/retrieve_arrows/SelectBehaviors(datum/ai_controller/controller, delta_time)
	if(!validate_archer_equipment(controller))
		return
	var/obj/item/quiver/Q = controller.blackboard[BB_ARCHER_NPC_QUIVER]

	if(Q.get_current_weight() >= (Q.max_storage - ARCHER_NPC_SCAVENGE_RESERVE))
		return
	var/mob/living/threat = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(isliving(threat) && threat.stat != DEAD)
		var/threat_dist = get_dist(controller.pawn, threat)
		if(threat_dist <= ARCHER_NPC_SCAVENGE_SAFE_DIST)
			return
		if(threat_dist <= ARCHER_NPC_SHOOT_RANGE && length(Q.arrows) >= ARCHER_NPC_SCAVENGE_COMBAT_FLOOR)
			return
	if(!controller.blackboard[BB_ARCHER_NPC_TARGET_ARROW])
		var/obj/item/arrow = _find_nearby_arrow(get_turf(controller.pawn), Q)
		if(!arrow)
			return
		controller.set_blackboard_key(BB_ARCHER_NPC_TARGET_ARROW, arrow)

	AI_THINK(controller.pawn, "SCAVENGE: quiver [Q.get_current_weight()]/[Q.max_storage] (cap [Q.max_storage - ARCHER_NPC_SCAVENGE_RESERVE]), [length(Q.arrows)] loose - going for [controller.blackboard[BB_ARCHER_NPC_TARGET_ARROW]]")
	controller.queue_behavior(/datum/ai_behavior/retrieve_arrow, BB_ARCHER_NPC_TARGET_ARROW)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/retrieve_arrows/proc/_find_nearby_arrow(mob/living/carbon/human/pawn, obj/item/quiver/Q)
	var/turf/pawn_turf = get_turf(pawn)
	for(var/obj/item/ammo_casing/arrow in range(ARCHER_NPC_ARROW_SEARCH_RANGE, pawn_turf))
		if(istype(arrow, Q.allowed_ammo_type))
			return arrow
	return null


/datum/ai_behavior/retrieve_arrow
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	action_cooldown = 0.5 SECONDS

/datum/ai_behavior/retrieve_arrow/setup(datum/ai_controller/controller, arrow_key)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/arrow = controller.blackboard[arrow_key]
	if(!arrow || QDELETED(arrow))
		controller.clear_blackboard_key(arrow_key)
		return FALSE
	controller.current_movement_target = arrow
	return TRUE

/datum/ai_behavior/retrieve_arrow/perform(delta_time, datum/ai_controller/controller, arrow_key)
	var/mob/living/carbon/human/pawn = controller.pawn
	var/obj/item/ammo_casing/arrow = controller.blackboard[arrow_key]

	if(!arrow || QDELETED(arrow))
		finish_action(controller, FALSE, arrow_key)
		return

	if(!pawn.CanReach(arrow))
		AI_THINK(pawn, "SCAVENGE: can't reach [arrow], dropping it")
		finish_action(controller, FALSE, arrow_key)
		return

	// Find the quiver again at perform time in case equipment changed
	var/obj/item/quiver/Q = null
	for(var/obj/item/quiver/worn in pawn.get_equipped_items())
		if(istype(arrow, worn.allowed_ammo_type))
			Q = worn
			break

	if(!Q || Q.get_current_weight() >= (Q.max_storage - ARCHER_NPC_SCAVENGE_RESERVE))
		AI_THINK(pawn, "SCAVENGE: quiver full or missing, aborting")
		finish_action(controller, FALSE, arrow_key)
		return

	if(!Q.eatarrow(arrow))
		AI_THINK(pawn, "SCAVENGE: [arrow] wouldn't fit, aborting")
		finish_action(controller, FALSE, arrow_key)
		return

	AI_THINK(pawn, "SCAVENGE: stowed [arrow] - now [Q.get_current_weight()]/[Q.max_storage], [length(Q.arrows)] loose")
	finish_action(controller, TRUE, arrow_key)

/datum/ai_behavior/retrieve_arrow/finish_action(datum/ai_controller/controller, succeeded, arrow_key)
	. = ..()
	controller.clear_blackboard_key(arrow_key)
