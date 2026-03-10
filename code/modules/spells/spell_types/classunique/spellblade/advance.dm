/* Advance! - Phalangite leap-strike.
Leaps up to 4 tiles in the aimed direction, passing through mobs.
On landing, stabs 1 tile ahead in the aimed direction.

The 5-tick telegraph is the counterplay window. The leap itself is fast.

At 3+ momentum: consumes 3, doubles strike damage.
Does NOT build momentum on hit — use normal melee for that. */

/obj/effect/proc_holder/spell/invoked/advance
	name = "Advance!"
	desc = "Leap forward up to 4 tiles, passing through enemies, then stab ahead on landing. \
		At 3+ momentum: consumes 3 to double damage. \
		Strikes your aimed bodypart. Can be deflected by Defend stance."
	clothes_req = FALSE
	range = 15
	action_icon = 'icons/mob/actions/spellblade.dmi'
	overlay_state = "advance"
	releasedrain = 15
	chargedrain = 0
	chargetime = 5
	recharge_time = 15 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 0
	chargedloop = /datum/looping_sound/invokegen
	invocations = list()
	invocation_type = "shout"
	gesture_required = TRUE
	xp_gain = FALSE
	var/leap_range = 4
	var/base_damage = 30
	var/empowered_mult = 2
	var/momentum_cost = 3
	var/step_delay = 1

/obj/effect/proc_holder/spell/invoked/advance/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		revert_cast()
		return

	H.say("Procede!", forced = "spell")

	var/atom/target = targets[1]
	var/turf/target_turf = get_turf(target)
	var/turf/start = get_turf(H)
	var/facing = get_dir(start, target_turf) || H.dir
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST

	var/turf/first_step = get_step(start, facing)
	if(!first_step || first_step.density)
		to_chat(H, span_warning("There's no room to leap!"))
		revert_cast()
		return

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released — empowered advance!"))

	var/damage = empowered ? (base_damage * empowered_mult) : base_damage

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)

	H.visible_message(
		span_warning("[H] lowers [H.p_their()] [held_weapon.name] and leaps forward!"),
		span_notice("I advance!"))
	playsound(start, pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 60, TRUE)

	// Leap phase — pass through mobs with jump arc animation
	var/old_pass = H.pass_flags
	H.pass_flags |= PASSMOB
	var/prev_pixel_z = H.pixel_z
	var/prev_transform = H.transform

	// Launch into the air — dramatic arc
	animate(H, pixel_z = prev_pixel_z + 18, time = 1, easing = EASE_OUT)

	var/steps_taken = 0
	for(var/i in 1 to leap_range)
		if(H.stat != CONSCIOUS || H.IsParalyzed() || H.IsStun() || QDELETED(H))
			break
		var/turf/next = get_step(get_turf(H), facing)
		if(!next || next.density)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in next.contents)
			if(S.density && !S.climbable)
				blocked = TRUE
				break
		if(blocked)
			break

		step(H, facing)
		steps_taken++

		if(i < leap_range)
			sleep(step_delay)

	// Slam down — fast drop with impact tilt
	var/land_angle = pick(-20, -15, 15, 20)
	animate(H, pixel_z = prev_pixel_z, transform = turn(prev_transform, land_angle), time = 1, easing = EASE_IN)
	animate(transform = prev_transform, time = 2)

	H.pass_flags = old_pass

	if(steps_taken == 0)
		to_chat(H, span_warning("My leap is blocked!"))
		return

	// Strike phase — stab 1 tile ahead of landing
	var/turf/jab_turf = get_step(get_turf(H), facing)
	if(!jab_turf)
		H.visible_message(span_notice("[H] lands with a thrust at the air."))
		return

	var/hit_count = 0
	for(var/mob/living/victim in jab_turf)
		if(victim == H || victim.stat == DEAD)
			continue
		if(spell_guard_check(victim, FALSE, hit_count == 0 ? H : null))
			continue
		arcyne_strike(H, victim, held_weapon, damage, def_zone, BCLASS_STAB, spell_name = "Advance!")
		hit_count++

	if(!hit_count)
		// Also check landing tile for targets standing on top of caster
		var/turf/landing = get_turf(H)
		for(var/mob/living/victim in landing)
			if(victim == H || victim.stat == DEAD)
				continue
			if(spell_guard_check(victim, FALSE, hit_count == 0 ? H : null))
				continue
			arcyne_strike(H, victim, held_weapon, damage, def_zone, BCLASS_STAB, spell_name = "Advance!")
			hit_count++

	if(!hit_count)
		H.visible_message(span_notice("[H] lands with a thrust at the air."))
	else
		H.visible_message(span_danger("[H] lands and drives [H.p_their()] [held_weapon.name] forward!"))

	log_combat(H, null, "used Advance! ([hit_count] hits)")
	return TRUE
