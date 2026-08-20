/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_charge
	name = "Gore Charge"
	desc = "Lowers your horns and runs your quarry down."
	button_icon_state = "gore_charge"
	cooldown_time = 18 SECONDS
	freeze_cast = FALSE

	use_chance = 50
	npc_min_range = 3
	npc_max_range = 8
	required_zones = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

	windup_time = TELEGRAPH_HIGH_IMPACT
	track_target = TRUE
	lock_direction = FALSE
	committed_strike = TRUE
	interruptible = FALSE
	damage_structures = FALSE
	strike_sound = 'sound/combat/clash_charge.ogg'
	recovery_time = 4 SECONDS
	telegraph_sound = list('sound/vo/mobs/minotaur/minoroar.ogg','sound/vo/mobs/minotaur/minoroar2.ogg','sound/vo/mobs/minotaur/minoroar3.ogg','sound/vo/mobs/minotaur/minoroar4.ogg')
	cast_effect_x_offset = 16
	cast_effect_y_offset = 16

	var/lane_length = 8
	var/step_delay = 1
	var/gore_damage = 55
	var/gore_exposed = 6 SECONDS
	var/slam_stun = 2 SECONDS
	var/slam_exposed = 6 SECONDS
	var/brace_damage = 45
	var/brace_recovery = 4 SECONDS

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_charge/get_pattern_offsets()
	var/list/offs = list()
	for(var/d in 1 to lane_length)
		offs += list(list(-1, d), list(0, d), list(1, d))
	return offs

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_charge/proc/perpendicular_dirs(facing)
	switch(facing)
		if(EAST, WEST)
			return list(NORTH, SOUTH)
	return list(WEST, EAST)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_charge/proc/row_turfs(turf/centre, facing)
	. = list(centre)
	for(var/side in perpendicular_dirs(facing))
		var/turf/flank = get_step(centre, side)
		if(flank && !flank.density)
			. += flank

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_charge/strike(mob/living/H, facing, list/indicator, atom/cast_on)
	clear_indicators(indicator)
	if(strike_sound)
		playsound(get_turf(H), strike_sound, 100, TRUE)
	H.visible_message(span_danger("<b>[H]</b> hurls itself forward!"))
	INVOKE_ASYNC(src, PROC_REF(charge_run), H, facing)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_charge/proc/charge_run(mob/living/bull, facing)
	var/list/perp_dirs = perpendicular_dirs(facing)
	var/shove_toggle = 0
	for(var/i in 1 to lane_length)
		if(QDELETED(bull) || bull.stat != CONSCIOUS || bull.incapacitated())
			return
		var/turf/next = get_step(get_turf(bull), facing)
		if(!next || next.density)
			slam_into_wall(bull, next || get_turf(bull))
			return
		var/blocked = FALSE
		for(var/obj/structure/S in next)
			if(S.density && !S.climbable)
				blocked = TRUE
				break
		if(blocked)
			slam_into_wall(bull, next)
			return

		var/list/gored = list()
		var/fouled = FALSE
		for(var/turf/T in row_turfs(next, facing))
			for(var/mob/living/victim in T)
				if(victim == bull || victim.stat == DEAD)
					continue
				if(bull.faction_check_mob(victim))
					var/shove_dir = perp_dirs[(shove_toggle % 2) + 1]
					shove_toggle++
					var/turf/shove_dest = get_step(get_turf(victim), shove_dir)
					if(shove_dest && !shove_dest.density)
						victim.safe_throw_at(shove_dest, 1, 1, bull, force = MOVE_FORCE_STRONG)
					victim.visible_message(span_warning("[victim] is rammed aside by [bull]!"))
					fouled = TRUE
					continue
				gored += victim
		if(length(gored))
			for(var/mob/living/victim in gored)
				if(!gore(bull, victim, facing))
					return
			open_up(bull, recovery_time, /datum/status_effect/debuff/vulnerable)
			return
		if(fouled)
			bull.visible_message(span_boldwarning("<b>[bull]</b> stumbles to a halt!"))
			open_up(bull, recovery_time, /datum/status_effect/debuff/vulnerable)
			return

		step(bull, facing)
		new /obj/effect/temp_visual/kinetic_blast(get_turf(bull))
		sleep(step_delay)

	bull.visible_message(span_notice("[bull] brings itself to a skidding halt!"))
	open_up(bull, recovery_time, /datum/status_effect/debuff/vulnerable)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_charge/proc/gore(mob/living/bull, mob/living/victim, facing)
	if(brace_charge(bull, victim, brace_damage, brace_recovery))
		return FALSE
	playsound(get_turf(victim), 'sound/combat/brutal_impalement.ogg', 100, TRUE)
	victim.visible_message(span_userdanger("[bull] gores [victim] on its horns!"))
	arcyne_strike(bull, victim, null, gore_damage, pick(BODY_ZONE_CHEST, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), BCLASS_STAB, armor_penetration = PEN_HEAVY, spell_name = name, skip_animation = TRUE, exact_zone = TRUE)
	if(victim.mobility_flags & MOBILITY_STAND)
		victim.apply_status_effect(/datum/status_effect/debuff/exposed, gore_exposed)
	var/turf/behind = get_step(get_turf(victim), facing)
	if(behind && !behind.density)
		victim.safe_throw_at(behind, 1, 1, bull, force = MOVE_FORCE_STRONG)
	return TRUE

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_charge/proc/slam_into_wall(mob/living/bull, turf/wall)
	bull.visible_message(span_boldwarning("<b>[bull]</b> slams headlong into \the [wall] and reels!"))
	playsound(wall, 'sound/misc/meteorimpact.ogg', 100, TRUE)
	shake_camera(bull, 3, 3)
	bull.Stun(slam_stun, ignore_canstun = TRUE)
	open_up(bull, slam_exposed, /datum/status_effect/debuff/exposed)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_charge/proc/open_up(mob/living/bull, duration, status)
	if(QDELETED(bull) || duration <= 0)
		return
	bull.apply_status_effect(status, duration)
	bull.apply_status_effect(/datum/status_effect/debuff/clickcd, duration)
