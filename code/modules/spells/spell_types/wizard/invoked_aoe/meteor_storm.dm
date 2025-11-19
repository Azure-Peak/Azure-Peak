/obj/effect/proc_holder/spell/invoked/meteor_storm
	name = "Meteor Storm"
	desc = "Summons forth dangerous meteors from the sky to scatter and smash foes."
	overlay_state = "meteor_storm"
	cost = 9
	spell_tier = 4 // Highest tier AOE
	releasedrain = 50
	chargedrain = 1
	chargetime = 50
	recharge_time =  100 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/meteor_storm/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(targets[1])
//	var/list/affected_turfs = list()
	playsound(T,'sound/magic/meteorstorm.ogg', 80, TRUE)
	T.visible_message(span_boldwarning("Fire rains from the sky!"))
	sleep(30)
	create_meteors(T)

//meteor storm and lightstorm.
/obj/effect/proc_holder/spell/invoked/meteor_storm/proc/create_meteors(atom/target)
	if(!target)
		return
	var/turf/targetturf = get_turf(target)
	for(var/turf/turf as anything in RANGE_TURFS(6,targetturf))
		if(prob(20))
			new /obj/effect/temp_visual/target(turf)

/obj/effect/temp_visual/fireball
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "meteor"
	name = "meteor"
	desc = "Get out of the way!"
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
	duration = 9
	pixel_z = 270

/obj/effect/temp_visual/fireball/Initialize(mapload)
	. = ..()
	animate(src, pixel_z = 0, time = duration)

/obj/effect/temp_visual/target
	icon = 'icons/mob/actions/actions_spells.dmi'
	icon_state = "projectile"
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE
	light_outer_range = 2
	duration = 9
	var/exp_heavy = 0
	var/exp_light = 2
	var/exp_flash = 2
	var/exp_fire = 1
	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')

/obj/effect/temp_visual/target/Initialize(mapload, list/flame_hit)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(fall), flame_hit)

/obj/effect/temp_visual/target/proc/fall(list/flame_hit)
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/meteorstorm.ogg', 80, TRUE)
	new /obj/effect/temp_visual/fireball(T)
	sleep(duration)
	if(ismineralturf(T))
		var/turf/closed/mineral/M = T
		M.gets_drilled()
	new /obj/effect/hotspot(T)
	for(var/turf/nearby in RANGE_TURFS(3, T))
		var/dist = get_dist(T, nearby)
		if(dist > 3)
			continue

		for(var/mob/living/L in nearby.contents)
			if(islist(flame_hit) && flame_hit[L]) // already hit by this meteor
				L.adjustFireLoss(5)
				continue

			switch(dist)
				if(0) // Direct impact
					L.adjustFireLoss(40)
					L.adjust_fire_stacks(8)
					L.ignite_mob()
					to_chat(L, span_userdanger("You're hit by a meteor!"))
				if(1) // Very close
					L.adjustFireLoss(20)
					L.adjust_fire_stacks(4)
					L.ignite_mob()
					to_chat(L, span_danger("Heat from the meteor sears you!"))
				if(2) // Nearby
					L.adjustFireLoss(10)
					L.adjust_fire_stacks(2)
					to_chat(L, span_warning("You feel the scorching blast!"))
				if(3) // Edge of the blast
					L.adjustFireLoss(5)
					L.adjust_fire_stacks(1)

			if(islist(flame_hit))
				flame_hit[L] = TRUE
	explosion(T, -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire, soundin = explode_sound)
