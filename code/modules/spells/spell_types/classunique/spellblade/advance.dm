/datum/action/cooldown/spell/advance
	source_aspect = /datum/magic_aspect/pseudo/spellblade
	name = "Advance!"
	desc = "Leap forward up to 4 tiles, passing through enemies, then stab ahead on landing. \
		At 3+ momentum: consumes 3 to double damage. \
		Strikes your aimed bodypart. Can be deflected by Defend stance."
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "advance"
	sound = 'sound/combat/wooshes/bladed/wooshsmall (1).ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	cast_range = 15

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_MOBILITY

	invocations = list()
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_POKE
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 15 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_LOW
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/leap_range = 4
	var/base_damage = 30
	var/empowered_mult = 2
	var/momentum_cost = 3
	var/step_delay = 1

/datum/action/cooldown/spell/advance/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		return FALSE

	H.say("Procede!", forced = "spell", language = /datum/language/common)

	var/turf/target_turf = get_turf(cast_on)
	var/turf/start = get_turf(H)
	var/facing = get_dir(start, target_turf) || H.dir
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST

	var/turf/first_step = get_step(start, facing)
	if(!first_step || first_step.density)
		to_chat(H, span_warning("There's no room to leap!"))
		return FALSE

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released - empowered advance!"))

	var/damage = empowered ? (base_damage * empowered_mult) : base_damage

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)

	H.visible_message(
		span_warning("[H] lowers [H.p_their()] [held_weapon.name] and leaps forward!"),
		span_notice("I advance!"))
	playsound(start, pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 60, TRUE)

	// Leap phase - pass through mobs with jump arc animation
	var/old_pass = H.pass_flags
	var/old_throwing = H.throwing
	H.pass_flags |= PASSMOB
	H.throwing = TRUE
	var/prev_pixel_z = H.pixel_z
	var/prev_transform = H.transform

	animate(H, pixel_z = prev_pixel_z + 18, time = 1, easing = EASE_OUT)

	var/max_steps = leap_range
	if(facing & (facing - 1))
		max_steps = max(1, round(leap_range / sqrt(2), 1))

	var/steps_taken = 0
	for(var/i in 1 to max_steps)
		if(H.stat != CONSCIOUS || H.IsParalyzed() || H.IsStun() || QDELETED(H))
			break
		var/turf/before = get_turf(H)
		var/completed = leap_step(H, facing)
		if(get_turf(H) != before) // a blocked diagonal can still leave us on the corner tile
			steps_taken++
		if(!completed)
			break

		if(i < max_steps)
			sleep(step_delay)

	// Slam down - fast drop with impact tilt
	var/land_angle = pick(-20, -15, 15, 20)
	animate(H, pixel_z = prev_pixel_z, transform = turn(prev_transform, land_angle), time = 1, easing = EASE_IN)
	animate(transform = prev_transform, time = 2)

	H.pass_flags = old_pass
	H.throwing = old_throwing

	var/turf/landing_turf = get_turf(H)
	if(landing_turf?.zFall(H))
		return TRUE

	if(steps_taken == 0)
		to_chat(H, span_warning("My leap is blocked!"))
		return TRUE

	// Strike phase - stab 1 tile ahead of landing
	var/turf/jab_turf = get_step(get_turf(H), facing)
	if(!jab_turf)
		H.visible_message(span_notice("[H] lands with a thrust at the air."))
		return TRUE

	var/hit_count = 0
	var/deflected = FALSE
	for(var/mob/living/victim in jab_turf)
		if(victim == H || victim.stat == DEAD)
			continue
		if(spell_guard_check(victim, FALSE, H, punish_caster = deflected ? FALSE : null))
			deflected = TRUE
			continue
		arcyne_strike(H, victim, held_weapon, damage, def_zone, BCLASS_STAB, spell_name = "Advance!")
		hit_count++

	if(!hit_count)
		// Also check landing tile for targets standing on top of caster
		var/turf/landing = get_turf(H)
		for(var/mob/living/victim in landing)
			if(victim == H || victim.stat == DEAD)
				continue
			if(spell_guard_check(victim, FALSE, H, punish_caster = deflected ? FALSE : null))
				deflected = TRUE
				continue
			arcyne_strike(H, victim, held_weapon, damage, def_zone, BCLASS_STAB, spell_name = "Advance!")
			hit_count++

	if(!hit_count)
		H.visible_message(span_notice("[H] lands with a thrust at the air."))
	else
		H.visible_message(span_danger("[H] lands and drives [H.p_their()] [held_weapon.name] forward!"))

	log_combat(H, null, "used Advance! ([hit_count] hits)")
	return TRUE

/datum/action/cooldown/spell/advance/proc/can_leap_into(turf/T)
	if(!T || T.density)
		return FALSE
	for(var/obj/structure/S in T.contents)
		if(S.density && !S.climbable)
			return FALSE
	return TRUE

/datum/action/cooldown/spell/advance/proc/leap_step(mob/living/carbon/human/H, dir)
	var/turf/current = get_turf(H)
	var/turf/destination = get_step(current, dir)
	if(!can_leap_into(destination))
		return FALSE
	if(!(dir & (dir - 1)))
		return step(H, dir)

	var/vertical = dir & (NORTH|SOUTH)
	var/horizontal = dir & (EAST|WEST)
	for(var/list/halves in list(list(vertical, horizontal), list(horizontal, vertical)))
		if(!can_leap_into(get_step(current, halves[1])))
			continue
		if(!step(H, halves[1]))
			continue
		step(H, halves[2])
		return get_turf(H) == destination
	return FALSE
