/datum/ai_behavior/static_melee_attack //attack on the spot, other behaviors will handle moving
	action_cooldown = 0.2 SECONDS 
	behavior_flags = AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/static_melee_attack/setup(datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]
	if(isnull(targetting_datum))
		CRASH("No target datum was supplied in the blackboard for [controller.pawn]")

	//Hiding location is priority
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE

/datum/ai_behavior/static_melee_attack/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	var/mob/living/simple_animal/basic_mob = controller.pawn
	var/reaction_time = basic_mob.npc_reaction_time()
	if(world.time + reaction_time < basic_mob.next_move)
		return AI_BEHAVIOR_INSTANT

	//targetting datum will kill the action if not real anymore
	var/atom/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!targetting_datum.can_attack(basic_mob, target))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

	var/hiding_target = targetting_datum.find_hidden_mobs(basic_mob, target) //If this is valid, theyre hidden in something!

	controller.set_blackboard_key(hiding_location_key, hiding_target)

	basic_mob.face_atom(target)
	basic_mob.a_intent = pick(basic_mob.possible_a_intents)

	var/turf/locked_turf = get_turf(target)
	sleep(reaction_time)
	if(QDELETED(basic_mob) || QDELETED(target) || QDELETED(controller) || controller.pawn != basic_mob)
		return AI_BEHAVIOR_DELAY

	var/atom/swing_at = basic_mob.pick_swing_target(target, locked_turf, hiding_target)
	if(!swing_at || !basic_mob.claim_pack_swing(target))
		return AI_BEHAVIOR_DELAY
	basic_mob.ClickOn(swing_at, list())

	controller.blackboard[BB_SWINGS_SINCE_CIRCLING] = (controller.blackboard[BB_SWINGS_SINCE_CIRCLING] || 0) + 1
	return AI_BEHAVIOR_DELAY

/datum/ai_behavior/static_melee_attack/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)


