// Proximity monitor that checks to see if anything interesting enters our bounds
/datum/proximity_monitor/advanced/ai_aggro_tracking
	edge_is_a_field = TRUE
	/// The ai behavior who owns us
	var/datum/ai_behavior/find_aggro_targets/owning_behavior
	/// The ai controller we're using
	var/datum/ai_controller/controller
	/// The target key we're trying to fill
	var/target_key
	/// The targeting strategy KEY we're using
	var/targeting_strategy_key
	/// The hiding location key we're using
	var/hiding_location_key

	/// The targeting strategy we're using
	var/datum/targetting_datum/filter
	/// If we've built our field yet
	/// Prevents wasted work on the first build (since the behavior did it)
	var/first_build = TRUE

// Initially, run the check manually
// If that fails, set up a field and have it manage the behavior fully
/datum/proximity_monitor/advanced/ai_aggro_tracking/New(atom/_host, range, _ignore_if_not_on_turf = TRUE, datum/ai_behavior/find_aggro_targets/owning_behavior, datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	. = ..()
	src.owning_behavior = owning_behavior
	src.controller = controller
	src.target_key = target_key
	src.targeting_strategy_key = targeting_strategy_key
	src.hiding_location_key = hiding_location_key
	src.filter = controller.blackboard[targeting_strategy_key]
	RegisterSignal(controller, COMSIG_PARENT_QDELETING, PROC_REF(controller_deleted))
	RegisterSignal(controller, COMSIG_AI_CONTROLLER_PICKED_BEHAVIORS, PROC_REF(controller_think))
	RegisterSignal(controller, AI_CONTROLLER_BEHAVIOR_QUEUED(owning_behavior.type), PROC_REF(behavior_requeued))
	RegisterSignal(controller, COMSIG_AI_BLACKBOARD_KEY_SET(targeting_strategy_key), PROC_REF(targeting_datum_changed))
	RegisterSignal(controller, COMSIG_AI_BLACKBOARD_KEY_CLEARED(targeting_strategy_key), PROC_REF(targeting_datum_cleared))
	recalculate_field(full_recalc = TRUE)

/datum/proximity_monitor/advanced/ai_aggro_tracking/Destroy()
	. = ..()
	if(!QDELETED(controller) && owning_behavior)
		controller.modify_cooldown(owning_behavior, world.time + owning_behavior.get_cooldown(controller))
		controller.clear_blackboard_key(BB_FIND_TARGETS_FIELD(owning_behavior.type))
	owning_behavior = null
	controller = null
	targeting_strategy_key = null
	hiding_location_key = null
	filter = null

/datum/proximity_monitor/advanced/ai_aggro_tracking/recalculate_field(full_recalc = FALSE)
	. = ..()
	first_build = FALSE

/datum/proximity_monitor/advanced/ai_aggro_tracking/setup_field_turf(turf/target)
	. = ..()
	if(first_build)
		return
	var/list/present = list()
	for(var/atom/movable/AM in target)
		present += AM
	if(length(present))
		trigger_alert_mode(present)
		// No new_atoms_found() call: that path adds threat with no LOS check, causing
		// wall/door aggro. Alert mode flips on the 2s LOS-gated scan, which will lock
		// the target the moment line of sight actually opens.
	else
		owning_behavior.new_turf_found(target, controller, filter)

/datum/proximity_monitor/advanced/ai_aggro_tracking/field_turf_crossed(atom/movable/movable, turf/location, turf/old_location)
	if(!owning_behavior.atom_allowed(movable, filter, controller.pawn))
		return

	trigger_alert_mode(list(movable))
	// No new_atoms_found() call - see note in setup_field_turf. Alert mode + LOS-gated
	// scan handles actual target acquisition.

/// Flag the NPC into alert mode for AI_ALERT_MODE_DURATION seconds. In alert mode,
/// find_aggro_targets runs every 2 seconds (vs 3s default) and breaks past the
/// "field exists so don't scan" gate. Actual target acquisition still requires LOS
/// (enforced inside scan_for_new_targets), so alert != aggro.
/datum/proximity_monitor/advanced/ai_aggro_tracking/proc/trigger_alert_mode(list/trigger_atoms)
	if(QDELETED(controller) || !controller.pawn)
		return
	// Only care about living-mob entries for alert purposes - ignore items, effects etc.
	var/living_found = FALSE
	for(var/mob/living/M in trigger_atoms)
		if(M == controller.pawn)
			continue
		living_found = TRUE
		break
	if(!living_found)
		return
	var/was_alert = controller.blackboard[BB_AI_ALERT_MODE_UNTIL] || 0
	var/new_until = world.time + AI_ALERT_MODE_DURATION
	controller.set_blackboard_key(BB_AI_ALERT_MODE_UNTIL, new_until)
	if(was_alert < world.time)
		AI_WORLD_THINK(controller.pawn, "entered ALERT mode (someone in aggro bubble, scanning for LOS)")

/// React to controller planning
/datum/proximity_monitor/advanced/ai_aggro_tracking/proc/controller_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/// React to the pawn goin byebye
/datum/proximity_monitor/advanced/ai_aggro_tracking/proc/pawn_changed(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/// React to controller planning
/datum/proximity_monitor/advanced/ai_aggro_tracking/proc/controller_think(datum/ai_controller/source, list/datum/ai_behavior/old_behaviors, list/datum/ai_behavior/new_behaviors)
	SIGNAL_HANDLER
	// If our parent was forgotten, nuke ourselves
	if(!new_behaviors[owning_behavior])
		qdel(src)

/datum/proximity_monitor/advanced/ai_aggro_tracking/proc/behavior_requeued(datum/source, list/new_arguments)
	SIGNAL_HANDLER
	check_new_args(arglist(new_arguments))

/// Ensure our args and locals are up to date
/datum/proximity_monitor/advanced/ai_aggro_tracking/proc/check_new_args(target_key, targeting_strategy_key, hiding_location_key)
	var/update_filter = FALSE
	if(src.target_key != target_key)
		src.target_key = target_key
	if(src.targeting_strategy_key != targeting_strategy_key)
		src.targeting_strategy_key = targeting_strategy_key
		update_filter = TRUE
	if(src.hiding_location_key != hiding_location_key)
		src.hiding_location_key = hiding_location_key
	if(update_filter)
		targeting_datum_changed(null)

/datum/proximity_monitor/advanced/ai_aggro_tracking/proc/targeting_datum_changed(datum/source)
	SIGNAL_HANDLER
	filter = controller.blackboard[targeting_strategy_key]
	// Filter changed, need to do a full reparse
	// Fucking 9 * 9 out here I stg
	for(var/turf/in_field as anything in field_turfs + edge_turfs)
		owning_behavior.new_turf_found(in_field, controller, filter)

/datum/proximity_monitor/advanced/ai_aggro_tracking/proc/targeting_datum_cleared(datum/source)
	SIGNAL_HANDLER
	// Go fuckin home bros
	qdel(src)
