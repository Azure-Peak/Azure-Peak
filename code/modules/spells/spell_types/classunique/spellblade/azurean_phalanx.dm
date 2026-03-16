/* Azurean Phalanx - Phalangite bread-and-butter 3x1 line thrust with pushback
Hits everyone in a 3-tile line in front of the caster and pushes them back 1 tile.
Spacing tool — the core of the Phalangite's "hold the line" identity.
Builds 1 momentum on hit regardless of targets struck (same as a normal weapon swing).
At 3+ momentum: consumes 3 stacks and doubles damage. */

/obj/effect/proc_holder/spell/invoked/azurean_phalanx
	name = "Azurean Phalanx"
	desc = "Hold the line. Thrust forward with arcyne-infused reach, striking a 3-tile line and pushing them back 1 tile. \
		Builds 1 momentum on hit. \
		At 3+ momentum: consumes 3 to double damage. \
		Strikes your aimed bodypart. Can be deflected by Defend stance."
	clothes_req = FALSE
	range = 7
	action_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	overlay_state = "azurean_phalanx" // Icon by Prominence
	releasedrain = SPELLCOST_SB_POKE
	chargedrain = 0
	chargetime = 5
	recharge_time = 12 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 0
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("Phalanx Azurea!")
	invocation_type = "shout"
	gesture_required = TRUE
	xp_gain = FALSE
	var/line_length = 3
	var/base_damage = 40
	var/empowered_mult = 2
	var/push_dist = 1 // I tried making the pushing higher and it was just too much
	// Turns out rotating a very high tile push makes it impossible to deal with.
	var/empowered_push = 1
	var/momentum_cost = 3
	var/telegraph_delay = 4

/obj/effect/proc_holder/spell/invoked/azurean_phalanx/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		revert_cast()
		return

	var/atom/target = targets[1]
	var/turf/target_turf = get_turf(target)
	var/turf/start = get_turf(H)
	var/facing = get_dir(start, target_turf) || H.dir

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released — empowered thrust!"))

	var/damage = empowered ? (base_damage * empowered_mult) : base_damage

	var/list/line_turfs = list()
	var/turf/current = start
	for(var/i in 1 to line_length)
		current = get_step(current, facing)
		if(!current || current.density)
			break
		var/struct_blocked = FALSE
		for(var/obj/structure/S in current.contents)
			if(S.density && !S.climbable)
				struct_blocked = TRUE
				break
		if(struct_blocked)
			break
		line_turfs += current

	if(!length(line_turfs))
		to_chat(H, span_warning("There's no room to thrust!"))
		revert_cast()
		return

	// Telegraph — show warning on affected tiles
	for(var/turf/T in line_turfs)
		new /obj/effect/temp_visual/air_strike_telegraph(T)

	// Grunt as they wind up the thrust
	H.emote("attackgrunt", forced = TRUE)

	addtimer(CALLBACK(src, PROC_REF(resolve_thrust), H, line_turfs, facing, damage, empowered), telegraph_delay)
	return TRUE

/obj/effect/proc_holder/spell/invoked/azurean_phalanx/proc/resolve_thrust(mob/living/carbon/human/H, list/line_turfs, facing, damage, empowered)
	if(QDELETED(H) || H.stat == DEAD)
		return

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		return

	var/def_zone = H.zone_selected || BODY_ZONE_CHEST

	// Visual and sound effects
	for(var/turf/T in line_turfs)
		var/obj/effect/temp_visual/V = new /obj/effect/temp_visual/blade_burst(T)
		V.dir = facing
	playsound(get_turf(H), pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 80, TRUE)

	H.emote("attack", forced = TRUE)

	var/hit_count = 0
	var/deflected = FALSE
	var/list/already_hit = list()
	for(var/turf/T in line_turfs)
		for(var/mob/living/victim in T)
			if(victim == H || victim.stat == DEAD || (victim in already_hit))
				continue
			if(spell_guard_check(victim, FALSE, deflected ? null : H))
				deflected = TRUE
				continue
			if(empowered)
				arcyne_strike(H, victim, held_weapon, round(damage / 2), def_zone, BCLASS_STAB, spell_name = "Azurean Phalanx", skip_message = TRUE)
				arcyne_strike(H, victim, held_weapon, round(damage / 2), def_zone, BCLASS_STAB, spell_name = "Azurean Phalanx")
			else
				arcyne_strike(H, victim, held_weapon, damage, def_zone, BCLASS_STAB, spell_name = "Azurean Phalanx")
			hit_count++
			already_hit += victim

			var/push_dir = get_dir(H, victim)
			if(!push_dir)
				push_dir = facing
			victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, push_dist), push_dist, 1, H, force = MOVE_FORCE_STRONG)

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(hit_count)
		if(M)
			M.add_stacks(1)
		H.visible_message(span_danger("[H] thrusts [H.p_their()] [held_weapon.name] forward in a powerful line!"))
	else
		H.visible_message(span_notice("[H] thrusts [H.p_their()] [held_weapon.name] forward!"))
	if(hit_count >= 2)
		if(M)
			M.add_stacks(1)
			to_chat(H, span_notice("DOUBLE STRIKE! ARCYNE SURGE!"))

	log_combat(H, null, "used Azurean Phalanx")
