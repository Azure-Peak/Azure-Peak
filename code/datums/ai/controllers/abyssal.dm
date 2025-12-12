/datum/ai_controller/assassin
	movement_delay = MINOR_DREAMFIEND_MOVEMENT_SPEED
	ai_movement = /datum/ai_movement/hybrid_pathing

	planning_subtrees = list(
		/datum/ai_planning_subtree/blink_if_far,
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/abyssal
	)
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_RETALIATE_ATTACKS_LEFT = 0,
		BB_BASIC_MOB_RETALIATE_LIST = list(),
		BB_RETALIATE_COOLDOWN = 0,
		BB_MAIN_TARGET = null
	)
	idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_controller/assassin/ancient
	movement_delay = ANCIENT_DREAMFIEND_MOVEMENT_SPEED
	ai_movement = /datum/ai_movement/hybrid_pathing

	planning_subtrees = list(
		/datum/ai_planning_subtree/blink_if_far,
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/abyssal,
		/datum/ai_planning_subtree/kick,
	)
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_RETALIATE_ATTACKS_LEFT = 0,
		BB_BASIC_MOB_RETALIATE_LIST = list(),
		BB_RETALIATE_COOLDOWN = 0,
		BB_MAIN_TARGET = null
	)
	idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_planning_subtree/basic_melee_attack_subtree/abyssal
	melee_attack_behavior = /datum/ai_behavior/basic_melee_attack/abyssal

/datum/ai_behavior/basic_melee_attack/abyssal

/datum/ai_behavior/basic_melee_attack/abyssal/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	var/retaliation_count = controller.blackboard[BB_RETALIATE_ATTACKS_LEFT]
	var/mob/living/simple_animal/hostile/rogue/dreamfiend/dreamfiend = controller.pawn

	if(retaliation_count <= 0)
		controller.set_blackboard_key(BB_RETALIATE_ATTACKS_LEFT, 2)
	if (isliving(dreamfiend))
		if (world.time < dreamfiend.melee_cooldown)
			return

	. = ..()
	//targetting datum will kill the action if not real anymore
	var/atom/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!targetting_datum.can_attack(dreamfiend, target))
		finish_action(controller, FALSE, target_key)
		return

	var/hiding_target = targetting_datum.find_hidden_mobs(dreamfiend, target) //If this is valid, theyre hidden in something!

	controller.set_blackboard_key(hiding_location_key, hiding_target)

	dreamfiend.face_atom()
	dreamfiend.a_intent = pick(dreamfiend.possible_a_intents) //randomized intent
	
	if(hiding_target) //Slap it!
		dreamfiend.ClickOn(hiding_target, list())
	else
		var/current_time = world.time
		var/last_decrease = controller.blackboard[BB_RETALIATE_COOLDOWN]
		if (current_time >= last_decrease)
			controller.set_blackboard_key(BB_RETALIATE_ATTACKS_LEFT, max(retaliation_count - 1, 0))
			controller.set_blackboard_key(BB_RETALIATE_COOLDOWN, current_time + 2 SECONDS)
		dreamfiend.ClickOn(target, list())

	if(sidesteps_after && prob(33)) //this is so fucking hacky, but going off og code this is exactly how it goes ignoring movetimers
		if(!target || !isturf(target.loc) || !isturf(dreamfiend.loc) || dreamfiend.stat == DEAD)
			return
		var/target_dir = get_dir(dreamfiend,target)

		var/static/list/cardinal_sidestep_directions = list(-90,-45,0,45,90)
		var/static/list/diagonal_sidestep_directions = list(-45,0,45)
		var/chosen_dir = 0
		if (target_dir & (target_dir - 1))
			chosen_dir = pick(diagonal_sidestep_directions)
		else
			chosen_dir = pick(cardinal_sidestep_directions)
		if(chosen_dir)
			chosen_dir = turn(target_dir,chosen_dir)
			dreamfiend.Move(get_step(dreamfiend,chosen_dir))
			dreamfiend.face_atom(target)
		
	if(retaliation_count <= 0)
		var/main_target = controller.blackboard[BB_MAIN_TARGET]
		controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
		controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, main_target)

/datum/ai_behavior/basic_melee_attack/abyssal/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		var/mob/target = controller.blackboard[target_key]
		var/mob/main_target = controller.blackboard[BB_MAIN_TARGET]
		controller.clear_blackboard_key(target_key)
		var/mob/living/simple_animal/hostile/rogue/dreamfiend/dreamfiend = controller.pawn
		if(main_target != null && target != main_target && main_target.stat == 0)
			//We lost the person we really want to kill... keep trying to teleport to them and kill them.
			dreamfiend.blink_to_target(target)
			controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, main_target)
		else if(main_target == null || main_target.stat != 0)
			dreamfiend.return_to_abyssor()

/datum/ai_planning_subtree/blink_if_far

/datum/ai_planning_subtree/blink_if_far/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/simple_animal/hostile/rogue/dreamfiend/dreamfiend = controller.pawn
	var/mob/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target || get_dist(dreamfiend, target) <= 5 )
		return

	// Attempt to blink and halt further planning if successful
	if(dreamfiend.blink_to_target(target))
		return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/kick

/datum/ai_planning_subtree/kick/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target))
		return
	controller.queue_behavior(/datum/ai_behavior/kick, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	return SUBTREE_RETURN_FINISH_PLANNING
	
/datum/ai_behavior/kick
	action_cooldown = 20 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/kick/setup(datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]
	if(isnull(targetting_datum))
		CRASH("No target datum was supplied in the blackboard for [controller.pawn]")

	//Hiding location is priority
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, target)

/datum/ai_behavior/kick/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()

	var/mob/living/user = controller.pawn
	var/mob/living/mob = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!istype(mob, /mob/living/carbon/human))
		finish_action(controller, TRUE, target_key)
		return
	
	var/mob/living/carbon/human/target = mob

	if(!targetting_datum.can_attack(user, target))
		finish_action(controller, FALSE, target_key)
		return

	user.do_attack_animation(target, ATTACK_EFFECT_DISARM)
	playsound(target, 'sound/combat/hits/kick/kick.ogg', 100, TRUE, -1)

	var/turf/target_oldturf = target.loc
	var/shove_dir = get_dir(user.loc, target_oldturf)
	var/turf/target_shove_turf = get_step(target.loc, shove_dir)
	var/mob/living/target_collateral_mob
	var/obj/structure/table/target_table
	var/shove_blocked = FALSE //Used to check if a shove is blocked so that if it is knockdown logic can be applied
	var/stander = TRUE
	if(!(target.mobility_flags & MOBILITY_STAND))
		stander = FALSE

	target_collateral_mob = locate(/mob/living) in target_shove_turf.contents
	if(target_collateral_mob)
		if(stander)
			shove_blocked = TRUE
	else
		target.Move(target_shove_turf, shove_dir)
		if(get_turf(target) == target_oldturf)
			if(stander)
				target_table = locate(/obj/structure/table) in target_shove_turf.contents
				shove_blocked = TRUE
		else
			if((stander && target.stamina >= target.max_stamina) || target.IsOffBalanced()) //if you are kicked while fatigued, you are knocked down no matter what
				target.Knockdown(target.IsOffBalanced() ? SHOVE_KNOCKDOWN_SOLID : 100)
				target.visible_message(span_danger("[user.name] charges [target.name], knocking them down!"),
				span_danger("I'm knocked down from a devestating leg swipe by the [user.name]!"), span_hear("I hear aggressive clacking followed by a loud thud!"), COMBAT_MESSAGE_RANGE, user)
				log_combat(user, target, "kicked", "knocking them down")

	if(shove_blocked && !target.is_shove_knockdown_blocked() && !target.buckled)
		var/directional_blocked = FALSE
		if(shove_dir in GLOB.cardinals) //Directional checks to make sure that we're not shoving through a windoor or something like that
			var/target_turf = get_turf(target)
			for(var/obj/O in target_turf)
				if(O.flags_1 & ON_BORDER_1 && O.dir == shove_dir && O.density)
					directional_blocked = TRUE
					break
			if(target_turf != target_shove_turf) //Make sure that we don't run the exact same check twice on the same tile
				for(var/obj/O in target_shove_turf)
					if(O.flags_1 & ON_BORDER_1 && O.dir == turn(shove_dir, 180) && O.density)
						directional_blocked = TRUE
						break
		if((!target_table && !target_collateral_mob) || directional_blocked)
			target.Knockdown(SHOVE_KNOCKDOWN_SOLID)
			target.visible_message(span_danger("[user.name] charges [target.name], knocking them down!"),
			span_danger("I'm knocked down from a devestating leg swipe by the [user.name]!"), span_hear("I hear aggressive clacking followed by a loud thud!"), COMBAT_MESSAGE_RANGE, user)
			log_combat(user, target, "kicked", "knocking them down")
		else if(target_table)
			target.Knockdown(SHOVE_KNOCKDOWN_TABLE)
			target.visible_message(span_danger("[user.name] charges [target.name] onto \the [target_table]!"),
			span_danger("I'm knocked down from a devestating leg swipe by the [user.name]!"), span_hear("I hear aggressive clacking followed by a loud thud!"), COMBAT_MESSAGE_RANGE, user)
			target.throw_at(target_table, 1, 1, null, FALSE) //1 speed throws with no spin are basically just forcemoves with a hard collision check
			log_combat(user, target, "kicked", "onto [target_table] (table)")
		else if(target_collateral_mob)
			target.Knockdown(SHOVE_KNOCKDOWN_HUMAN)
			target_collateral_mob.Knockdown(SHOVE_KNOCKDOWN_COLLATERAL)
			target.visible_message(span_danger("[user.name] charges [target.name] into [target_collateral_mob.name]!"),
			span_danger("I'm knocked down from a devestating leg swipe by the [user.name]!"), span_hear("I hear aggressive clacking followed by a loud thud!"), COMBAT_MESSAGE_RANGE, user)
			log_combat(user, target, "kicked", "into [target_collateral_mob.name]")
	else
		target.visible_message(span_danger("[user.name] charges [target.name]!"),
		span_danger("I'm knocked down from a devestating leg swipe by the [user.name]!"), span_hear("I hear aggressive clacking followed by a loud thud!"), COMBAT_MESSAGE_RANGE, user)
		log_combat(user, target, "kicked")

	var/obj/item/bodypart/affecting = target.get_bodypart(BODY_ZONE_CHEST)
	var/armor_block = target.run_armor_check(BODY_ZONE_CHEST, "blunt", blade_dulling = BCLASS_BLUNT)
	var/damage = 50
	if(!target.apply_damage(damage, UNARMED_ATTACK, affecting, armor_block))
		target.next_attack_msg += VISMSG_ARMOR_BLOCKED
	else
		affecting.bodypart_attacked_by(BCLASS_BLUNT, damage, user, BODY_ZONE_CHEST)
	playsound(target, 'sound/combat/hits/kick/kick.ogg', 100, TRUE, -1)
	target.lastattacker = user.real_name
	target.lastattackerckey = user.ckey
	target.lastattacker_weakref = WEAKREF(user)
	if(target.mind)
		target.mind.attackedme[user.real_name] = world.time
	user.stamina_add(15)
	target.forcesay(GLOB.hit_appends)

	finish_action(controller, TRUE, target_key)
	return

/datum/ai_behavior/kick/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		var/mob/target = controller.blackboard[target_key]
		var/mob/main_target = controller.blackboard[BB_MAIN_TARGET]
		controller.clear_blackboard_key(target_key)
		var/mob/living/simple_animal/hostile/rogue/dreamfiend/dreamfiend = controller.pawn
		if(main_target != null && target != main_target && main_target.stat == 0)
			//We lost the person we really want to kill... keep trying to teleport to them and kill them.
			dreamfiend.blink_to_target(target)
			controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, main_target)
		else if(main_target == null || main_target.stat != 0)
			dreamfiend.return_to_abyssor()

/datum/ai_controller/dreamfiend_unbound
	movement_delay = MINOR_DREAMFIEND_MOVEMENT_SPEED
	ai_movement = /datum/ai_movement/hybrid_pathing

	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/blink_if_far,
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/basic_melee_attack_subtree
	)
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_BASIC_MOB_RETALIATE_LIST = list(),
	)
	idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_controller/dreamfiend_unbound_ancient
	movement_delay = MINOR_DREAMFIEND_MOVEMENT_SPEED
	ai_movement = /datum/ai_movement/hybrid_pathing

	planning_subtrees = list(
        /datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/blink_if_far,
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/kick
	)
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_BASIC_MOB_RETALIATE_LIST = list(),
	)
	idle_behavior = /datum/idle_behavior/idle_random_walk
