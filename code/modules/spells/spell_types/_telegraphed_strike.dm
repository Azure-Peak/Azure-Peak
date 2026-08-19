// Telegraphed melee strike AOE that travels with you
/datum/action/cooldown/spell/telegraphed_strike
	click_to_activate = FALSE
	self_cast_possible = TRUE
	weapon_cast_penalized = FALSE
	charge_required = FALSE
	invocation_type = INVOCATION_SHOUT

	var/damage = 50
	var/strike_damage_type = BRUTE
	var/blade_class = BCLASS_CUT
	var/strike_armor_pen = PEN_NONE
	var/detonate_sound = 'sound/combat/newstuck.ogg'
	var/strike_sound = 'sound/magic/blade_burst.ogg'
	/// Played on each victim struck, on top of the per-turf detonate_sound.
	var/list/hit_sound
	var/windup_time = TELEGRAPH_DODGEABLE
	var/committed_strike = TRUE
	var/interruptible = FALSE
	var/lock_direction = FALSE
	/// Makes the AI Caster keep facing their target during the windup
	var/track_target = FALSE
	var/redraw_interval = 2
	var/sweep_step = 1
	/// If TRUE, a guard deflection aborts the remaining bands instead of just sparing that victim.
	var/guard_aborts_sweep = FALSE
	/// Band currently resolving, INDEXED FROM 1. Transient.
	var/band_index = 0
	var/impact_delay = 0
	var/stop_at_dense = TRUE
	var/damage_structures = TRUE
	var/structure_damage = 0
	var/swipe_state = null
	var/vuln_on_hit = 0
	var/immobilize_on_hit = 0
	var/knockdown_on_hit = 0
	var/telegraph_type = /obj/effect/temp_visual/telegraph
	// AI Hint to keep the target in its pattern
	var/require_target_in_pattern = FALSE
	var/requires_weapon = FALSE
	var/weapon_missing_message = "I need a weapon to strike with!"
	var/sweep_hit_count = 0
	var/list/struck_obstacles
	var/list/struck_mobs

/datum/action/cooldown/spell/telegraphed_strike/proc/get_strike_duration()
	return windup_time + impact_delay + max(0, length(get_sweep_bands()) - 1) * sweep_step

/datum/action/cooldown/spell/telegraphed_strike/ai_commit_time()
	return get_strike_duration()

/datum/action/cooldown/spell/telegraphed_strike/can_use(atom/target)
	. = ..()
	if(!. || !require_target_in_pattern || !npc_controlled() || QDELETED(target) || target == owner)
		return .
	var/turf/goal = get_turf(target)
	if(!goal)
		return FALSE
	return (goal in get_pattern_turfs(owner, telegraph_cardinal(get_dir(owner, target))))

/datum/action/cooldown/spell/telegraphed_strike/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	if(damage > 0)
		stats += span_info("Damage: [damage]")
	return stats

/datum/action/cooldown/spell/telegraphed_strike/cast(atom/cast_on)
	. = ..()
	var/mob/living/H = owner
	if(!isliving(H))
		return FALSE
	if(requires_weapon && !get_strike_weapon(H))
		to_chat(H, span_warning(weapon_missing_message))
		return FALSE
	var/strike_duration = get_strike_duration()
	if(committed_strike)
		H.changeNext_move(strike_duration)
		if(interruptible)
			H.apply_status_effect(/datum/status_effect/swingdelay/disrupt, strike_duration + 2, FALSE)
		else
			H.apply_status_effect(/datum/status_effect/swingdelay/penalty/committed, strike_duration + 2, TRUE)
	INVOKE_ASYNC(src, PROC_REF(windup_and_strike), H, cast_on)
	return TRUE

/datum/action/cooldown/spell/telegraphed_strike/proc/windup_and_strike(mob/living/H, atom/cast_on)
	var/list/indicator = list()
	var/iterations = max(1, round(windup_time / redraw_interval))
	var/turf/last_turf
	var/last_facing
	var/locked_facing = lock_direction ? get_cardinal(H.dir) : null
	if(locked_facing)
		H.setDir(locked_facing)
		H.tempfixeye = TRUE
		H.nodirchange = TRUE
		H.facing_locked = TRUE
	if(charge_slowdown)
		H.add_movespeed_modifier(MOVESPEED_ID_SPELL_CASTING, TRUE, 100, override = TRUE, multiplicative_slowdown = charge_slowdown)
	announce_telegraph(H)
	apply_cast_freeze(H, windup_time)
	show_cast_effect(H)
	for(var/i in 1 to iterations)
		if(QDELETED(H) || H.stat != CONSCIOUS || strike_disrupted(H))
			break
		if(track_target && !QDELETED(cast_on) && cast_on != H)
			H.face_atom(cast_on)
		var/facing = locked_facing || get_cardinal(H.dir)
		if(get_turf(H) != last_turf || facing != last_facing)
			last_turf = get_turf(H)
			last_facing = facing
			draw_indicators(H, facing, indicator)
		sleep(redraw_interval)
	if(charge_slowdown && !QDELETED(H))
		H.remove_movespeed_modifier(MOVESPEED_ID_SPELL_CASTING)
	if(locked_facing && !QDELETED(H))
		H.tempfixeye = FALSE
		H.nodirchange = FALSE
		H.facing_locked = FALSE
	clear_cast_freeze(H)
	clear_cast_effect(H)
	if(QDELETED(H) || H.stat != CONSCIOUS || strike_disrupted(H))
		clear_indicators(indicator)
		return
	strike(H, locked_facing || get_cardinal(H.dir), indicator, cast_on)

/datum/action/cooldown/spell/telegraphed_strike/proc/strike_disrupted(mob/living/H)
	if(!interruptible)
		return FALSE
	var/datum/status_effect/swingdelay/disrupt/SW = H.has_status_effect(/datum/status_effect/swingdelay/disrupt)
	return SW && SW.is_disrupted()

/datum/action/cooldown/spell/telegraphed_strike/proc/draw_indicators(mob/living/H, facing, list/indicator)
	draw_offsets(H, facing, indicator, get_pattern_offsets())

/datum/action/cooldown/spell/telegraphed_strike/proc/draw_offsets(mob/living/H, facing, list/indicator, list/offs)
	telegraph_draw(get_pattern_origin(H), facing, indicator, offs, telegraph_type, stop_at_dense)

/datum/action/cooldown/spell/telegraphed_strike/proc/clear_indicators(list/indicator)
	telegraph_clear(indicator)

/datum/action/cooldown/spell/telegraphed_strike/proc/strike(mob/living/H, facing, list/indicator, atom/cast_on)
	if(!length(get_pattern_offsets()))
		clear_indicators(indicator)
		return
	if(strike_sound)
		playsound(get_turf(H), strike_sound, 75, TRUE)
	var/atom/movable/visual = do_blade_animation(H, facing)
	INVOKE_ASYNC(src, PROC_REF(execute_hits), H, facing, indicator, visual)

/datum/action/cooldown/spell/telegraphed_strike/proc/execute_hits(mob/living/H, facing, list/indicator, atom/movable/visual)
	var/turf/last_turf = get_turf(H)
	draw_indicators(H, facing, indicator)
	var/elapsed = 0
	while(elapsed < impact_delay)
		if(QDELETED(H) || H.stat != CONSCIOUS)
			clear_indicators(indicator)
			return
		if(get_turf(H) != last_turf)
			last_turf = get_turf(H)
			draw_indicators(H, facing, indicator)
		sleep(redraw_interval)
		elapsed += redraw_interval
	if(!QDELETED(H) && H.stat == CONSCIOUS)
		on_impact(H, facing, visual)
	var/list/bands = get_sweep_bands()
	var/deflected = FALSE
	sweep_hit_count = 0
	struck_obstacles = list()
	struck_mobs = list()
	for(var/b in 1 to length(bands))
		if(QDELETED(H) || H.stat != CONSCIOUS)
			break
		if(deflected && guard_aborts_sweep)
			break
		band_index = b
		on_band_start(H, b)
		var/turf/origin = get_pattern_origin(H)
		for(var/list/off in bands[b])
			var/list/r = rotate_offset(off[1], off[2], facing)
			var/turf/T = origin ? locate(origin.x + r[1], origin.y + r[2], origin.z) : null
			if(!T)
				continue
			if(T.density)
				if(damage_structures)
					damage_obstacles(T)
				continue
			if(stop_at_dense)
				var/turf/blocker = path_blocked(origin, T)
				if(blocker)
					if(damage_structures)
						damage_obstacles(blocker)
					continue
			if(damage_structures)
				damage_obstacles(T)
			deflected = hit_turf(H, T, facing, deflected)
			on_pattern_turf(T, H, facing)
			if(swipe_state)
				var/obj/effect/temp_visual/dir_setting/attack_effect/slash = new(T, facing)
				slash.icon_state = swipe_state
		var/list/remaining = list()
		for(var/j in b + 1 to length(bands))
			remaining += bands[j]
		draw_offsets(H, facing, indicator, remaining)
		if(sweep_step > 0 && b < length(bands))
			sleep(sweep_step)
	clear_indicators(indicator)
	on_strike_complete(H, sweep_hit_count, deflected)
	start_recovery(H)

/datum/action/cooldown/spell/telegraphed_strike/proc/on_impact(mob/living/H, facing, atom/movable/visual)
	return

/// Called once per band as it begins resolving, before any of its turfs are hit.
/datum/action/cooldown/spell/telegraphed_strike/proc/on_band_start(mob/living/H, band)
	return

/// Called for every turf the pattern actually reaches, after its occupants are struck.
/datum/action/cooldown/spell/telegraphed_strike/proc/on_pattern_turf(turf/T, mob/living/H, facing)
	return

/// The turfs this pattern reaches, with obstacles already filtered out.
/datum/action/cooldown/spell/telegraphed_strike/proc/get_pattern_turfs(mob/living/H, facing, list/offs)
	. = list()
	var/turf/origin = get_pattern_origin(H)
	if(!origin)
		return
	for(var/list/off in (offs || get_pattern_offsets()))
		var/list/r = rotate_offset(off[1], off[2], facing)
		var/turf/T = locate(origin.x + r[1], origin.y + r[2], origin.z)
		if(!T || T.density)
			continue
		if(stop_at_dense && path_blocked(origin, T))
			continue
		. += T

/datum/action/cooldown/spell/telegraphed_strike/proc/hit_turf(mob/living/H, turf/T, facing, deflected = FALSE)
	if(QDELETED(H) || QDELETED(T))
		return deflected
	var/obj/item/weapon = get_strike_weapon(H)
	var/dmg = get_strike_damage()
	var/hit_any = FALSE
	for(var/mob/living/L in T.contents)
		if(L == H)
			continue
		if(L in struck_mobs)
			continue
		if(!can_strike_victim(H, L))
			continue
		struck_mobs += L
		if(blocked_by_antimagic && L.anti_magic_check())
			on_antimagic_block(L)
			continue
		if(spell_guard_check(L, FALSE, deflected ? null : H))
			deflected = TRUE
			continue
		hit_any = TRUE
		sweep_hit_count++
		var/target_zone = H.zone_selected || BODY_ZONE_CHEST
		arcyne_strike(H, L, weapon, dmg, target_zone, blade_class, armor_penetration = strike_armor_pen, spell_name = name, damage_type = strike_damage_type, skip_animation = TRUE)
		if(length(hit_sound))
			playsound(get_turf(L), hit_sound, 100, TRUE)
		if(vuln_on_hit)
			L.apply_status_effect(/datum/status_effect/debuff/vulnerable, vuln_on_hit)
		if(immobilize_on_hit)
			L.apply_status_effect(STATUS_EFFECT_IMMOBILIZED, immobilize_on_hit)
		if(knockdown_on_hit)
			L.Knockdown(knockdown_on_hit)
		if(spell_impact_intensity != SPELL_IMPACT_NONE)
			new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)
		on_hit_target(H, L, facing)
	if(hit_any && detonate_sound)
		playsound(T, detonate_sound, 65, TRUE)
	return deflected

/datum/action/cooldown/spell/telegraphed_strike/proc/path_blocked(turf/origin, turf/target)
	return telegraph_path_blocked(origin, target)

/datum/action/cooldown/spell/telegraphed_strike/proc/damage_obstacles(turf/T)
	if(!T || (T in struck_obstacles))
		return
	struck_obstacles += T
	var/dmg = structure_damage ? structure_damage : damage
	var/hit_any = FALSE
	for(var/obj/structure/S in T)
		S.take_damage(dmg, BRUTE, "blunt", TRUE)
		hit_any = TRUE
	if(hit_any)
		if(spell_impact_intensity != SPELL_IMPACT_NONE)
			new /obj/effect/temp_visual/spell_impact(T, spell_color, spell_impact_intensity)
		if(detonate_sound)
			playsound(T, detonate_sound, 65, TRUE)

/datum/action/cooldown/spell/telegraphed_strike/proc/forward_reach(mob/living/H, facing, max_steps)
	var/reach = 0
	var/turf/current = get_turf(H)
	for(var/i in 1 to max_steps)
		var/turf/next = get_step(current, facing)
		if(!next || next.density)
			break
		current = next
		reach++
		for(var/obj/structure/S in next)
			if(S.density && !S.climbable)
				return reach
	return reach

/datum/action/cooldown/spell/telegraphed_strike/proc/get_strike_weapon(mob/living/H)
	return null

/datum/action/cooldown/spell/telegraphed_strike/proc/get_strike_damage()
	return damage

/datum/action/cooldown/spell/telegraphed_strike/proc/on_hit_target(mob/living/H, mob/living/L, facing)
	return

/datum/action/cooldown/spell/telegraphed_strike/proc/on_strike_complete(mob/living/H, hit_count, deflected)
	return

/// The turf the pattern offsets are measured from. Override to anchor a pattern somewhere other than the caster.
/datum/action/cooldown/spell/telegraphed_strike/proc/get_pattern_origin(mob/living/H)
	return get_turf(H)

/datum/action/cooldown/spell/telegraphed_strike/proc/can_strike_victim(mob/living/H, mob/living/L)
	return TRUE

/datum/action/cooldown/spell/telegraphed_strike/proc/on_antimagic_block(mob/living/L)
	L.visible_message(span_warning("The arcyne blades dispel as they near [L]!"))
	playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)

/datum/action/cooldown/spell/telegraphed_strike/proc/do_blade_animation(mob/living/H, facing)
	return

/datum/action/cooldown/spell/telegraphed_strike/proc/get_pattern_offsets()
	return list()

/datum/action/cooldown/spell/telegraphed_strike/proc/get_sweep_bands()
	var/list/bands = list()
	for(var/list/off in get_pattern_offsets())
		bands += list(list(off))
	return bands

/datum/action/cooldown/spell/telegraphed_strike/proc/get_cardinal(dir)
	return telegraph_cardinal(dir)

/datum/action/cooldown/spell/telegraphed_strike/proc/rotate_offset(dx, dy, facing)
	return telegraph_rotate_offset(dx, dy, facing)

/datum/action/cooldown/spell/telegraphed_strike/proc/facing_position_angle(facing)
	switch(facing)
		if(EAST)
			return 90
		if(SOUTH)
			return 180
		if(WEST)
			return 270
	return 0
