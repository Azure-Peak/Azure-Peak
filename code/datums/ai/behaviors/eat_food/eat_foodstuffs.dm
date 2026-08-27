//For mobs who only eat actual food, not carrion/scavengers who eat all (hide, bones, etc)
/datum/ai_behavior/eat_food
	required_distance = 1
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT
	action_cooldown = 2 SECONDS

/datum/ai_behavior/eat_food/setup(datum/ai_controller/controller, target_key)
	. = ..()
	set_movement_target(controller, controller.blackboard[target_key])

/datum/ai_behavior/eat_food/perform(seconds_per_tick, datum/ai_controller/controller, target_key, hunger_timer_key)
	var/mob/living/living_pawn = controller.pawn
	if(living_pawn.incapacitated())
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	var/obj/item/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return AI_BEHAVIOR_DELAY

	if(!(target in living_pawn.held_items))
		if(!living_pawn.get_empty_held_indexes() || !living_pawn.put_in_hands(target))
			return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

	target.melee_attack_chain(living_pawn, living_pawn)

	if(QDELETED(target) || prob(10)) // Even if we don't finish it all we can randomly decide to be done
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED
	return AI_BEHAVIOR_DELAY

/datum/ai_behavior/eat_food/finish_action(datum/ai_controller/controller, succeeded, target_key, hunger_timer_key)
	. = ..()
	if(succeeded)
		controller.set_blackboard_key(hunger_timer_key, world.time + rand(12 SECONDS, 60 SECONDS))
