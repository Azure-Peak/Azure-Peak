#define BB_TROLL_ROCK_COOLDOWN "troll_rock_cooldown"
#define BB_TROLL_SLAP_COOLDOWN "troll_slap_cooldown"
#define BB_TROLL_CONSECUTIVE_SHOVES "troll_consecutive_shoves"

/datum/ai_controller/undead_troll
	movement_delay = TROLL_UNDEAD_MOVEMENT_SPEED
	ai_movement = /datum/ai_movement/hybrid_pathing
	idle_behavior = /datum/idle_behavior/idle_random_walk

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
		BB_TROLL_ROCK_COOLDOWN = 0,
		BB_TROLL_CONSECUTIVE_SHOVES = 0,
		BB_TROLL_SLAP_COOLDOWN = 0
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/troll_rock_toss,
		/datum/ai_planning_subtree/basic_melee_attack_subtree
	)

/datum/ai_planning_subtree/troll_rock_toss

/datum/ai_planning_subtree/troll_rock_toss/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target) || !isliving(target))
		return

	if(controller.blackboard[BB_TROLL_ROCK_COOLDOWN] > world.time)
		return

	var/mob/living/troll = controller.pawn
	var/distance = get_dist(troll, target)

	if(distance <= 2)
		if(controller.blackboard[BB_TROLL_SLAP_COOLDOWN] <= world.time)
			var/mob/living/victim = target
			if(troll.incapacitated() || victim.incapacitated())
				return
			troll.visible_message(span_danger("<b>[troll]</b> shoves [victim] back to clear some space!"))
			playsound(troll, 'sound/combat/flail_sweep_hit_minor.ogg', 80, TRUE)
			victim.Knockdown(1.5 SECONDS)
			var/shove_dir = get_dir(troll, victim)
			victim.throw_at(get_edge_target_turf(victim, shove_dir), 4, 2, troll)
			var/consecutive = controller.blackboard[BB_TROLL_CONSECUTIVE_SHOVES] || 0
			consecutive++
			controller.set_blackboard_key(BB_TROLL_CONSECUTIVE_SHOVES, consecutive)
			var/penalty_cooldown = min(0.7 SECONDS + (consecutive - 1) * 1 SECONDS, 10 SECONDS)
			controller.set_blackboard_key(BB_TROLL_SLAP_COOLDOWN, world.time + penalty_cooldown)
			return SUBTREE_RETURN_FINISH_PLANNING
		else
			return
	controller.queue_behavior(/datum/ai_behavior/troll_rock_toss, BB_BASIC_MOB_CURRENT_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/troll_rock_toss
	var/throw_cooldown = 25 SECONDS
	var/windup_time = 1.2 SECONDS

/datum/ai_behavior/troll_rock_toss/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	var/mob/living/troll = controller.pawn
	var/atom/target = controller.blackboard[target_key]

	if(QDELETED(target) || troll.buckled || troll.incapacitated())
		finish_action(controller, FALSE)
		return
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		finish_action(controller, FALSE)
		return
	troll.visible_message(span_danger("<b>[troll]</b> rips a massive boulder right out of the earth and winds up!"))
	playsound(troll, 'sound/combat/ground_smash_start.ogg', 90, TRUE)

	var/list/warning_zone = range(1, target_turf)
	for(var/turf/T in warning_zone)
		new /obj/effect/temp_visual/special_intent/warning(T, windup_time)

	controller.set_blackboard_key(BB_TROLL_ROCK_COOLDOWN, world.time + throw_cooldown)
	controller.set_blackboard_key(BB_TROLL_CONSECUTIVE_SHOVES, 0)
	controller.set_blackboard_key(BB_TROLL_SLAP_COOLDOWN, 0)
	addtimer(CALLBACK(src, .proc/spawn_rock, controller, target_turf), windup_time)
	finish_action(controller, TRUE)

/datum/ai_behavior/troll_rock_toss/proc/spawn_rock(datum/ai_controller/controller, turf/target_turf)
	var/mob/living/troll = controller.pawn
	if(QDELETED(troll) || troll.incapacitated() || !target_turf)
		return
	var/turf/start_turf = get_turf(troll)
	if(!start_turf)
		return

	var/obj/projectile/bullet/thrown_boulder/B = new(start_turf)
	B.starting = start_turf
	B.firer = troll
	B.original = target_turf
	B.yo = target_turf.y - start_turf.y
	B.xo = target_turf.x - start_turf.x
	B.preparePixelProjectile(target_turf, start_turf)
	B.fire()

/obj/projectile/bullet/thrown_boulder
	name = "massive boulder"
	desc = "A terrifyingly huge slab of rock rocketing through the air."
	icon = 'icons/roguetown/weapons/ranged/arrow_proj.dmi'
	icon_state = "boulder"
	damage = 0
	speed = 1.8

/obj/projectile/bullet/thrown_boulder/Initialize(mapload, turf/target_turf, mob/living/boss_source)
	. = ..()
	playsound(src, 'sound/misc/meteorimpact.ogg', 80, TRUE)

/obj/projectile/bullet/thrown_boulder/on_hit(atom/target, blocked)
	var/turf/impact_turf = get_turf(target) || get_turf(src)
	explode_payload(impact_turf)
	return BULLET_ACT_HIT

/obj/projectile/bullet/thrown_boulder/proc/explode_payload(turf/epicentre)
	if(!epicentre)
		epicentre = get_turf(src)
	if(!epicentre)
		qdel(src)
		return

	playsound(epicentre, 'sound/misc/explode/explosionfar (1).ogg', 100, TRUE)

	for(var/dx in -2 to 2)
		for(var/dy in -2 to 2)
			var/abs_x = abs(dx)
			var/abs_y = abs(dy)
			if(abs_x == 2 && abs_y == 2)
				continue
			var/turf/T = locate(epicentre.x + dx, epicentre.y + dy, epicentre.z)
			if(!T)
				continue
			if(dx == 0 && dy == 0)
				process_impact_zone(T, zone_type = "O")
			else if(abs_x <= 1 && abs_y <= 1)
				process_impact_zone(T, zone_type = "R")
			else
				process_impact_zone(T, zone_type = "S")
	qdel(src)

/obj/projectile/bullet/thrown_boulder/proc/process_impact_zone(turf/T, zone_type)
	var/shatter_delay = 0.6 SECONDS
	var/obj/effect/temp_visual/special_intent/shatter = new (T, shatter_delay)
	shatter.icon = 'icons/effects/effects.dmi'
	shatter.icon_state = "sweep_fx"
	var/static/list/shatter_zones = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
	)
	switch(zone_type)
		if("O")
			for(var/mob/living/L in T)
				if(L == firer)
					continue
				L.visible_message(span_userdanger("The boulder lands directly on [L]!"))
				L.Knockdown(4 SECONDS)
				L.adjustBruteLoss(75)
				playsound(L, 'sound/combat/tf2crit.ogg', 90, TRUE)
				if(iscarbon(L))
					var/limbs_broken_this_hit = 0
					var/arm_broken_this_hit = FALSE
					var/mob/living/carbon/C = L
					for(var/obj/item/bodypart/BP in C.bodyparts)
						if(limbs_broken_this_hit >= 2)
							break
						if((BP.body_zone in shatter_zones) && !BP.has_wound(/datum/wound/fracture))
							var/is_arm = (BP.body_zone == BODY_ZONE_L_ARM || BP.body_zone == BODY_ZONE_R_ARM)
							// I'm not that evil, okay?
							if(is_arm && arm_broken_this_hit)
								continue
							if(prob(10))
								BP.add_wound(/datum/wound/fracture/no_bleed)
								limbs_broken_this_hit++
								if(is_arm)
									arm_broken_this_hit = TRUE
			if(istype(T, /turf/closed))
				T.ex_act(EXPLODE_HEAVY)
			for(var/obj/structure/S in T)
				S.ex_act(EXPLODE_HEAVY)
		if("R")
			shatter.color = "#888888"
			for(var/mob/living/L in T)
				if(L == firer)
					continue
				L.visible_message(span_userdanger("[L] is crushed by flying stone shrapnel!"))
				L.Knockdown(2 SECONDS)
				L.adjustBruteLoss(45)
			if(istype(T, /turf/closed))
				T.ex_act(EXPLODE_LIGHT)
			for(var/obj/structure/S in T)
				S.ex_act(EXPLODE_LIGHT)
		if("S")
			shatter.alpha = 150
			for(var/mob/living/L in T)
				if(L == firer)
					continue
				L.visible_message(span_warning("The blast wave sweeps [L] off their feet!"))
				L.Knockdown(1 SECONDS)
				L.apply_status_effect(/datum/status_effect/debuff/dazed)
				L.adjustBruteLoss(15)

/obj/projectile/bullet/thrown_boulder/Range()
	var/turf/current_turf = get_turf(src)
	if(current_turf == original)
		explode_payload(current_turf)
		return
	return ..()

#undef BB_TROLL_ROCK_COOLDOWN
#undef BB_TROLL_SLAP_COOLDOWN
#undef BB_TROLL_CONSECUTIVE_SHOVES
