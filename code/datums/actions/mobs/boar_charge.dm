/datum/action/cooldown/spell/telegraphed_strike/mob_ability/boar_charge
	name = "Charge"
	desc = "Lowers its head and barrels forward."
	button_icon_state = "boar_charge"
	cooldown_time = 20 SECONDS
	npc_min_range = 2
	npc_max_range = 7
	required_zones = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)

	windup_time = TELEGRAPH_DODGEABLE
	telegraph_sound = list('sound/vo//mobs/boar/boar_charge.ogg')
	strike_sound = null
	freeze_cast = FALSE

	var/step_delay = 0.5
	var/gore_damage = 60
	var/brace_damage = 40
	var/brace_recovery = 3 SECONDS
	var/missed_once = FALSE

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/boar_charge/get_pattern_offsets()
	. = list()
	for(var/d in 1 to npc_max_range)
		. += list(list(-1, d), list(0, d), list(1, d))

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/boar_charge/strike(mob/living/H, facing, list/indicator, atom/cast_on)
	clear_indicators(indicator)
	if(QDELETED(cast_on) || H.buckled || H.incapacitated())
		return
	H.visible_message(span_danger("<b>[H]</b> charges!"))
	INVOKE_ASYNC(src, PROC_REF(charge_run), H, facing)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/boar_charge/proc/perpendicular_dirs(facing)
	switch(facing)
		if(EAST, WEST)
			return list(NORTH, SOUTH)
	return list(WEST, EAST)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/boar_charge/proc/row_turfs(turf/centre, facing)
	. = list(centre)
	for(var/side in perpendicular_dirs(facing))
		var/turf/flank = get_step(centre, side)
		if(flank && !flank.density)
			. += flank

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/boar_charge/proc/charge_run(mob/living/boar, facing)
	var/swing_sfx = pick('sound/combat/ground_smash_start.ogg', 'sound/combat/flail_sweep_hit_minor.ogg')
	playsound(get_turf(boar), swing_sfx, 80, TRUE)
	for(var/i in 1 to npc_max_range)
		if(QDELETED(boar) || boar.stat != CONSCIOUS || boar.incapacitated())
			return
		var/turf/next = get_step(get_turf(boar), facing)
		var/list/blocked_turfs = list()
		if(!next || next.density)
			blocked_turfs += (next || get_turf(boar))
		else
			for(var/obj/structure/S in next)
				if(S.density && !S.climbable)
					blocked_turfs += next
					break
		if(length(blocked_turfs))
			slam_into_wall(boar, blocked_turfs)
			return

		for(var/turf/T in row_turfs(next, facing))
			var/obj/effect/temp_visual/special_intent/fx = new (T, 0.5 SECONDS)
			fx.icon = 'icons/effects/effects.dmi'
			fx.icon_state = "sweep_fx"
			for(var/mob/living/victim in T)
				if(victim == boar || victim.stat == DEAD)
					continue
				if(boar.faction_check_mob(victim))
					continue
				gore(boar, victim)
				return

		step(boar, facing)
		sleep(step_delay)

	if(!missed_once)
		missed_once = TRUE
		reset_spell_cooldown()
		boar.visible_message(span_notice("[boar] skids to a halt and prepares to lunge again!"))
	else
		missed_once = FALSE

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/boar_charge/proc/gore(mob/living/boar, mob/living/victim)
	if(brace_charge(boar, victim, brace_damage, brace_recovery))
		missed_once = FALSE
		return
	victim.visible_message(span_userdanger("[boar] gores [victim]!"))
	if(iscarbon(victim))
		var/mob/living/carbon/C = victim
		var/obj/item/bodypart/chest = C.get_bodypart(BODY_ZONE_CHEST)
		if(chest)
			chest.add_wound(/datum/wound/slash/boar_gore)
	victim.Stun(2 SECONDS)
	victim.apply_status_effect(/datum/status_effect/debuff/exposed, 10 SECONDS)
	boar.Stun(3 SECONDS)
	arcyne_strike(boar, victim, null, gore_damage, BODY_ZONE_CHEST, BCLASS_STAB, armor_penetration = PEN_HEAVY, spell_name = name, skip_animation = TRUE, exact_zone = TRUE)
	playsound(victim, 'sound/combat/crit.ogg', 75, TRUE)
	missed_once = FALSE

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/boar_charge/proc/slam_into_wall(mob/living/boar, list/blocked_turfs)
	var/turf/impact_turf = blocked_turfs[1]
	boar.visible_message(span_danger("[boar] slams into the environment with bone-shattering force!"))
	playsound(impact_turf, 'sound/combat/hits/onwood/fence_hit3.ogg', 100, TRUE)
	boar.Stun(3 SECONDS)
	on_wall_impact(boar, blocked_turfs)
	for(var/turf/T in range(1, impact_turf))
		var/obj/effect/temp_visual/special_intent/smash = new (T, 0.5 SECONDS)
		smash.icon = 'icons/effects/effects.dmi'
		smash.icon_state = "strike"
	for(var/mob/living/L in range(1, impact_turf))
		if(L == boar)
			continue
		L.visible_message(span_warning("The shockwave from [boar]'s impact staggers [L]!"))
		L.apply_status_effect(/datum/status_effect/debuff/vulnerable, 6 SECONDS)
		L.apply_status_effect(/datum/status_effect/debuff/dazed)
		arcyne_strike(boar, L, null, 20, BODY_ZONE_CHEST, BCLASS_BLUNT, spell_name = name, skip_animation = TRUE, exact_zone = TRUE)
	missed_once = FALSE

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/boar_charge/proc/on_wall_impact(mob/living/boar, list/blocked_turfs)
	return

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/boar_charge/undead
	cooldown_time = 25 SECONDS
	step_delay = 2

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/boar_charge/undead/on_wall_impact(mob/living/boar, list/blocked_turfs)
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
