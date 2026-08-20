#define BB_BOAR_CHARGE_COOLDOWN "boar_charge_cooldown"
#define BB_BOAR_CHARGE_ATTEMPTS "boar_charge_attempts"

/datum/ai_controller/boar/undead
	movement_delay = BOAR_UNDEAD_MOVEMENT_SPEED
	ai_movement = /datum/ai_movement/hybrid_pathing
	idle_behavior = /datum/idle_behavior/idle_random_walk

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
		BB_BOAR_CHARGE_COOLDOWN = 0,
		BB_BOAR_CHARGE_ATTEMPTS = 0
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		// Whee!!
		/datum/ai_planning_subtree/boar_charge/undead,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

/datum/ai_planning_subtree/boar_charge/undead
	behavior_type_boar = /datum/ai_behavior/boar_charge/undead

/datum/ai_behavior/boar_charge/undead
	charge_cooldown = 25 SECONDS
	charge_speed = 1
	windup_time = 0.75 SECONDS

/datum/ai_behavior/boar_charge/undead/on_wall_impact(mob/living/boar, list/blocked_turfs)
	for(var/turf/T in blocked_turfs)
		var/obj/structure/flora/hit_flora = locate(/obj/structure/flora) in T
		if(!hit_flora || !hit_flora.density)
			continue

		boar.visible_message(span_danger("The impact violently splinters [hit_flora], spraying sharp wooden thorns everywhere!"))
		playsound(T, 'sound/combat/Ranged/flatbow-shot-01.ogg', 100, TRUE)
		var/projectiles = rand(4, 9)
		var/base_angle_step = 360 / projectiles 
		for(var/i in 1 to projectiles)
			var/angle = (i * base_angle_step) + rand(-15, 15)

			var/offset_x = round(cos(angle) * 4)
			var/offset_y = round(sin(angle) * 4)
			var/turf/target_turf = locate(T.x + offset_x, T.y + offset_y, T.z)

			if(!target_turf || target_turf == T)
				continue

			var/obj/projectile/bullet/thorn/P = new(T)
			P.starting = T
			P.firer = boar
			P.fired_from = hit_flora

			P.yo = target_turf.y - T.y
			P.xo = target_turf.x - T.x
			P.original = target_turf

			P.preparePixelProjectile(target_turf, T)
			P.fire()

/obj/projectile/bullet/thorn
	name = "sharp thorn wood splinter"
	desc = "A lethal, jagged piece of shattered wood flying at blinding speeds."
	icon = 'icons/roguetown/weapons/ranged/arrow_proj.dmi'
	icon_state = "thorn"
	damage = 60
	embedchance = 0
	armor_penetration = PEN_BSTEEL
	woundclass = BCLASS_PIERCE
	damage_type = BRUTE
	speed = 1.3

#undef BB_BOAR_CHARGE_COOLDOWN
#undef BB_BOAR_CHARGE_ATTEMPTS
