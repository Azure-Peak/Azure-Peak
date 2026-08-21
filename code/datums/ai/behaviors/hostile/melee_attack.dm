/datum/ai_behavior/basic_melee_attack
	action_cooldown = 0.2 SECONDS // We gotta check unfortunately often because we're in a race condition with nextmove
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	var/sidesteps_after = TRUE
	var/sidestep_chance = 15
	var/list/sidestep_offsets
	var/sidestep_seeks_flank = FALSE

/datum/ai_behavior/basic_melee_attack/setup(datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]
	if(isnull(targetting_datum))
		CRASH("No target datum was supplied in the blackboard for [controller.pawn]")

	//Hiding location is priority
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, target)

/datum/ai_behavior/basic_melee_attack/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	if (isliving(controller.pawn))
		var/mob/living/pawn = controller.pawn
		if (world.time < pawn.melee_cooldown)
			return

	. = ..()
	var/mob/living/simple_animal/basic_mob = controller.pawn
	//targetting datum will kill the action if not real anymore
	var/atom/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!targetting_datum.can_attack(basic_mob, target))
		finish_action(controller, FALSE, target_key)
		return

	var/hiding_target = targetting_datum.find_hidden_mobs(basic_mob, target) //If this is valid, theyre hidden in something!

	controller.set_blackboard_key(hiding_location_key, hiding_target)

	if(target == basic_mob)
		finish_action(controller, FALSE, target_key)
		return
	basic_mob.face_atom(target)
	var/forced_zone = controller.blackboard[BB_FORCED_ATTACK_ZONE]
	if(forced_zone)
		basic_mob.zone_selected = forced_zone
	basic_mob.a_intent = pick(basic_mob.possible_a_intents) //randomized intent

	var/atom/swing_at = resolve_swing_target(controller, basic_mob, target, target_key, hiding_target)
	if(!swing_at)
		return
	basic_mob.ClickOn(swing_at, list())

	if(sidesteps_after && prob(sidestep_chance))
		basic_mob.combat_sidestep(target, sidestep_offsets, sidestep_seeks_flank)

/datum/ai_behavior/basic_melee_attack/circler
	sidestep_seeks_flank = TRUE

/datum/ai_behavior/basic_melee_attack/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		// Don't clear target if the aggro board still tracks a valid threat — let find_aggro re-evaluate instead
		if(!controller.blackboard[BB_HIGHEST_THREAT_MOB])
			controller.clear_blackboard_key(target_key)

/datum/ai_behavior/basic_melee_attack/proc/resolve_swing_target(datum/ai_controller/controller, mob/living/pawn, atom/target, target_key, atom/hiding_target)
	var/turf/locked_turf = get_turf(target)
	// Hates using sleep but it works, timer spam is worse anyway
	sleep(max(MELEE_NPC_REACTION_TIME_MIN, MELEE_NPC_REACTION_TIME_BASE - round((pawn.STAPER + pawn.STAINT) / MELEE_NPC_REACTION_PER_STAT_POINT)))

	if(QDELETED(pawn) || QDELETED(target) || QDELETED(controller) || controller.pawn != pawn)
		return null

	var/swing_reach = pawn.used_intent?.reach || 1
	if(!pawn.CanReach(target, pawn.get_active_held_item()) && locked_turf && get_dist(pawn, locked_turf) > swing_reach)
		finish_action(controller, FALSE, target_key)
		return null

	if(hiding_target)
		return hiding_target
	if(!locked_turf || get_dist(pawn, locked_turf) > swing_reach)
		return target

	if(get_turf(target) != locked_turf)
		if(AI_INT_SCALE_PROB(pawn, MELEE_NPC_TRACK_CEILING_CHANCE))
			AI_THINK(pawn, "WHIFF: target moved but we tracked - hit anyway")
			return target
		AI_THINK(pawn, "WHIFF: target stepped off [locked_turf], swinging at empty tile")
		return locked_turf

	if(AI_INT_SCALE_PROB(pawn, 100 - MELEE_NPC_WHIFF_FLOOR_CHANCE))
		return target

	var/list/nearby = list()
	for(var/turf/candidate in range(1, locked_turf))
		if(candidate == locked_turf || candidate.density)
			continue
		if(get_dist(pawn, candidate) > swing_reach)
			continue
		nearby += candidate
	if(!length(nearby))
		return target

	var/turf/sloppy = pick(nearby)
	AI_THINK(pawn, "WHIFF: sloppy swing, hit [sloppy] instead of target")
	return sloppy

/datum/ai_behavior/basic_ranged_attack
	action_cooldown = 0.6 SECONDS
	behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM
	required_distance = 3

/datum/ai_behavior/basic_ranged_attack/setup(datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]
	if(QDELETED(target) || !target) 
		return FALSE
	set_movement_target(controller, (target))


/datum/ai_behavior/basic_ranged_attack/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/mob/living/simple_animal/basic_mob = controller.pawn
	//targetting datum will kill the action if not real anymore
	var/atom/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]


	if(!targetting_datum.can_attack(basic_mob, target))
		finish_action(controller, FALSE, target_key)
		return
	if(target == basic_mob)
		finish_action(controller, FALSE, target_key)
		return

	var/atom/hiding_target = targetting_datum.find_hidden_mobs(basic_mob, target) //If this is valid, theyre hidden in something!

	controller.set_blackboard_key(hiding_location_key, hiding_target)

	basic_mob.face_atom(target)
	if(hiding_target) //Shoot it!
		basic_mob.RangedAttack(hiding_target)
	else
		basic_mob.RangedAttack(target)

/datum/ai_behavior/basic_ranged_attack/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)

/datum/ai_behavior/opportunistic_ranged_attack
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	required_distance = 0
	action_cooldown = 0.4 SECONDS

/datum/ai_behavior/opportunistic_ranged_attack/setup(datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	var/atom/target = controller.blackboard[target_key]
	return !QDELETED(target)

/datum/ai_behavior/opportunistic_ranged_attack/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/mob/living/simple_animal/hostile/basic_mob = controller.pawn
	var/atom/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]
	if(!istype(basic_mob) || QDELETED(target) || target == basic_mob || !targetting_datum?.can_attack(basic_mob, target))
		finish_action(controller, FALSE, target_key)
		return
	basic_mob.face_atom(target)
	basic_mob.RangedAttack(target)
	finish_action(controller, TRUE, target_key)


/datum/ai_behavior/basic_melee_attack/bog_troll/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)
		controller.pawn.icon_state = "Trollso"

/datum/ai_behavior/basic_melee_attack/mimic/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)
		var/mob/living/simple_animal/hostile/retaliate/rogue/mimic/mimic_pawn = controller.pawn
		mimic_pawn.disguise()

