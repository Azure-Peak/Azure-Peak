/* Charge! - Macebearer ramming charge.
5 rapid steps forward in the user's facing direction, shoving
anyone in the path to the sides for zero damage.
Only strikes at the final tile (or wherever the charge stops).

Knockback on final hit is 1 tile regardless of empowerment.
At 3+ momentum: consumes 3 stacks, doubles strike damage.
Does NOT build momentum on hit — use normal melee for that. */

/obj/effect/proc_holder/spell/invoked/charge
	name = "Charge!"
	desc = "Infuse mana into your legs, charging forth five paces — \
		ramming everyone in your path to the sides for no damage. \
		Bashes everything at the destination and knocks them back 1 tile. \
		At 3+ momentum: consumes 3 to double damage. \
		Strikes your aimed bodypart. Can be deflected by Defend stance."
	clothes_req = FALSE
	range = 15
	action_icon = 'icons/mob/actions/spellblade.dmi'
	overlay_state = "advance" // Icon by Prominence. Shared with Advance since the spells are very similar.
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
	var/charge_steps = 5
	var/base_damage = 45
	var/empowered_mult = 2
	var/base_push = 1
	var/momentum_cost = 3
	var/step_delay = 2

/obj/effect/proc_holder/spell/invoked/charge/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		revert_cast()
		return

	H.say("Impete!", forced = "spell")

	var/atom/target = targets[1]
	var/turf/target_turf = get_turf(target)
	var/turf/start = get_turf(H)
	var/facing = get_dir(start, target_turf) || H.dir

	var/turf/first_step = get_step(start, facing)
	if(!first_step || first_step.density)
		to_chat(H, span_warning("There's no room to charge!"))
		revert_cast()
		return

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released — empowered charge!"))

	var/damage = empowered ? (base_damage * empowered_mult) : base_damage

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)

	H.visible_message(
		span_warning("[H] barrels forward!"),
		span_notice("I charge!"))
	playsound(start, pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 60, TRUE)

	// Compute perpendicular directions for side-shoving
	var/list/perp_dirs = get_perpendicular_dirs(facing)
	var/shove_toggle = 0 // Alternate left/right

	var/steps_taken = 0
	for(var/i in 1 to charge_steps)
		if(H.stat != CONSCIOUS || H.IsParalyzed() || H.IsStun() || QDELETED(H))
			break
		var/turf/next = get_step(get_turf(H), facing)
		if(!next || next.density)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in next.contents)
			if(S.density)
				blocked = TRUE
				break
		if(blocked)
			break

		// Shove mobs on the next tile to the sides before stepping in
		for(var/mob/living/victim in next)
			if(victim == H || victim.stat == DEAD)
				continue
			var/shove_dir = perp_dirs[(shove_toggle % 2) + 1]
			shove_toggle++
			var/turf/shove_dest = get_step(get_turf(victim), shove_dir)
			if(shove_dest && !shove_dest.density)
				victim.safe_throw_at(shove_dest, 1, 1, H, force = MOVE_FORCE_STRONG)
				victim.visible_message(span_warning("[victim] is shoved aside by [H]'s charge!"))

		step(H, facing)
		steps_taken++
		new /obj/effect/temp_visual/kinetic_blast(get_turf(H))

		if(i < charge_steps)
			sleep(step_delay)

	if(steps_taken == 0)
		to_chat(H, span_warning("My charge is blocked!"))
		return

	var/hit_count = 0
	var/turf/dest = get_turf(H)

	for(var/mob/living/victim in dest)
		if(victim == H || victim.stat == DEAD)
			continue
		if(spell_guard_check(victim, FALSE, hit_count == 0 ? H : null))
			continue
		if(empowered)
			arcyne_strike(H, victim, held_weapon, round(damage / 2), H.zone_selected, BCLASS_BLUNT, spell_name = "Charge!", skip_message = TRUE)
			arcyne_strike(H, victim, held_weapon, round(damage / 2), H.zone_selected, BCLASS_BLUNT, spell_name = "Charge!")
		else
			arcyne_strike(H, victim, held_weapon, damage, H.zone_selected, BCLASS_BLUNT, spell_name = "Charge!")
		hit_count++
		var/push_dir = get_dir(H, victim)
		if(!push_dir)
			push_dir = facing
		victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, base_push), base_push, 1, H, force = MOVE_FORCE_STRONG)

	// If no one was hit at destination, check the next tile ahead
	if(!hit_count)
		var/turf/ahead = get_step(dest, facing)
		if(ahead)
			for(var/mob/living/victim in ahead)
				if(victim == H || victim.stat == DEAD)
					continue
				if(spell_guard_check(victim, FALSE, hit_count == 0 ? H : null))
					continue
				if(empowered)
					arcyne_strike(H, victim, held_weapon, round(damage / 2), H.zone_selected, BCLASS_BLUNT, spell_name = "Charge!", skip_message = TRUE)
					arcyne_strike(H, victim, held_weapon, round(damage / 2), H.zone_selected, BCLASS_BLUNT, spell_name = "Charge!")
				else
					arcyne_strike(H, victim, held_weapon, damage, H.zone_selected, BCLASS_BLUNT, spell_name = "Charge!")
				hit_count++
				var/push_dir = get_dir(H, victim)
				if(!push_dir)
					push_dir = facing
				victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, base_push), base_push, 1, H, force = MOVE_FORCE_STRONG)

	if(!hit_count)
		H.visible_message(span_notice("[H] finishes the charge with a swing at the air."))
		return

	playsound(dest, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 80, TRUE)

	log_combat(H, null, "used Charge!")
	return TRUE

/obj/effect/proc_holder/spell/invoked/charge/proc/get_perpendicular_dirs(dir)
	switch(dir)
		if(NORTH, SOUTH)
			return list(WEST, EAST)
		if(EAST, WEST)
			return list(NORTH, SOUTH)
		if(NORTHEAST)
			return list(NORTHWEST, SOUTHEAST)
		if(NORTHWEST)
			return list(NORTHEAST, SOUTHWEST)
		if(SOUTHEAST)
			return list(NORTHEAST, SOUTHWEST)
		if(SOUTHWEST)
			return list(NORTHWEST, SOUTHEAST)
	return list(WEST, EAST)
