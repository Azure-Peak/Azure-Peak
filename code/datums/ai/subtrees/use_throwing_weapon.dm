#define THROW_WINDUP_TIME (0.7 SECONDS)

/proc/ai_min_throw_dist(obj/item/throwable)
	return istype(throwable, /obj/item/explosive) ? 3 : 2

/datum/ai_planning_subtree/use_throwable
	var/max_throw_dist = 7 // Only throw if within this distance

/datum/ai_planning_subtree/use_throwable/SelectBehaviors(datum/ai_controller/controller, delta_time)
	if(LAZYACCESS(controller.current_behaviors, GET_AI_BEHAVIOR(/datum/ai_behavior/use_throwable)))
		controller.queue_behavior(/datum/ai_behavior/use_throwable)
		return
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		return
	if(controller.blackboard[BB_HELD_CONSUMABLE])
		return

	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	if(!inv)
		return

	var/obj/item/throwingknife = inv.get_item(AI_ITEM_THROWING)
	if(!throwingknife)
		return

	var/mob/living/pawn = controller.pawn
	var/dist = get_dist(pawn, target)

	// Only throw within our sweet spot range
	if(dist > max_throw_dist || dist < ai_min_throw_dist(throwingknife))
		return

	// Need line of sight to throw
	if(!can_see(pawn, target, max_throw_dist))
		return

	controller.queue_behavior(/datum/ai_behavior/use_throwable, BB_HELD_CONSUMABLE, BB_BASIC_MOB_CURRENT_TARGET, throwingknife)

/datum/ai_planning_subtree/spacing/ranged/thrower
	finish_planning = TRUE
	honor_commit = FALSE

/datum/ai_planning_subtree/spacing/ranged/thrower/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	if(!inv?.get_item(AI_ITEM_THROWING))
		return
	return ..()

/datum/ai_planning_subtree/spacing/ranged/thrower/is_ready_to_attack(datum/ai_controller/controller, mob/living/living_pawn)
	return controller.behavior_cooldowns[GET_AI_BEHAVIOR(/datum/ai_behavior/use_throwable)] <= world.time

/datum/ai_behavior/use_throwable
	action_cooldown = 4 SECONDS
	behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION | AI_BEHAVIOR_EXECUTE_ALONGSIDE

/datum/ai_behavior/use_throwable/perform(delta_time, datum/ai_controller/controller, consumable_key, target_key, obj/item/throwingknife)
	controller.set_blackboard_key(BB_HELD_CONSUMABLE, throwingknife)
	if(!throwingknife)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

	var/mob/living/target = controller.blackboard[target_key]
	if(!target || QDELETED(target))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

	var/mob/living/pawn = controller.pawn
	if(pawn.incapacitated())
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

	pawn.face_atom(target)
	var/min_dist = ai_min_throw_dist(throwingknife)
	var/windup_until = controller.blackboard[BB_THROW_WINDUP_UNTIL]

	if(windup_until && world.time < windup_until)
		windup_move(controller, target, min_dist)
		return AI_BEHAVIOR_INSTANT

	var/dist = get_dist(pawn, target)
	if(dist > throwingknife.throw_range || dist < min_dist)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

	if(!can_see(pawn, target, throwingknife.throw_range))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

	if(!windup_until)
		var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
		var/obj/item/usable = inv?.draw_usable_item(throwingknife, AI_ITEM_THROWING)
		if(!usable)
			return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
		controller.set_blackboard_key(BB_HELD_CONSUMABLE, usable)
		controller.set_blackboard_key(BB_THROW_WINDUP_UNTIL, world.time + THROW_WINDUP_TIME)
		return AI_BEHAVIOR_INSTANT

	var/obj/item/in_hand = pawn.get_active_held_item()
	if(!in_hand || !(in_hand.flags_ai_inventory & AI_ITEM_THROWING))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED // lost the throwable mid-windup, bail and restore
	pawn.throw_item(get_turf(target))
	return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED

/datum/ai_behavior/use_throwable/proc/windup_move(datum/ai_controller/controller, atom/target, min_dist)
	if(LAZYACCESS(controller.current_behaviors, GET_AI_BEHAVIOR(/datum/ai_behavior/strafe_target)))
		return
	if(controller.ai_movement.moving_controllers[controller])
		return
	if(!COOLDOWN_FINISHED(controller, movement_cooldown))
		return
	ai_strafe_step(controller, target, min_dist, TRUE)

/datum/ai_behavior/use_throwable/finish_action(datum/ai_controller/controller, succeeded, consumable_key, target_key)
	. = ..()
	controller.clear_blackboard_key(BB_HELD_CONSUMABLE)
	controller.clear_blackboard_key(BB_THROW_WINDUP_UNTIL)
	// Restore hands to whatever they were holding before
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	inv?.restore_hands()

#undef THROW_WINDUP_TIME
