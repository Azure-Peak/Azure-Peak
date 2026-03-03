/* Charge! - Macebearer charge attack.
3 rapid steps forward in the user's facing direction, ending with
a bash on anything at the destination. Knockback on hit.
Interruptible by stun/knockdown.

More disruptive than Advance (knockback on arrival). Strikes aimed bodypart.

At 3+ momentum: consumes 3 stacks, doubles damage and knockback distance.
Builds 1 momentum on hit. */

/obj/effect/proc_holder/spell/invoked/charge
	name = "Charge!"
	desc = "Infuse mana into your legs, charging forth three paces with unexpected force — \
		bashing everything at the destination and knocking them back 1 tile. \
		Builds 1 momentum on hit. \
		At 3+ momentum: consumes 3 to double damage. \
		Strikes your aimed bodypart. Can be deflected by Defend stance."
	clothes_req = FALSE
	range = 5
	action_icon = 'icons/mob/actions/spellblade.dmi'
	overlay_state = "advance" // Icon by Prominence. Shared with Advance since the spells are very similar.
	releasedrain = 15
	chargedrain = 0
	chargetime = 5
	recharge_time = 12 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 0
	chargedloop = /datum/looping_sound/invokegen
	invocations = list()
	invocation_type = "shout"
	gesture_required = TRUE
	xp_gain = FALSE
	var/charge_steps = 3
	var/base_damage = 45
	var/empowered_mult = 2
	var/base_push = 1
	var/empowered_push = 1
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
	var/push_dist = empowered ? empowered_push : base_push

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)

	H.visible_message(
		span_warning("[H] barrels forward!"),
		span_notice("I charge!"))
	playsound(start, pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 60, TRUE)

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
		victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, push_dist), push_dist, 1, H, force = MOVE_FORCE_STRONG)

	// If no one was hit at destination, check the next tile ahead AND the tile
	// that blocked the charge (e.g. someone standing on a table or log)
	if(!hit_count)
		var/list/extra_turfs = list()
		var/turf/ahead = get_step(dest, facing)
		if(ahead)
			extra_turfs += ahead
		// If the charge was stopped short, the blocking tile may have victims on it
		if(steps_taken < charge_steps)
			var/turf/blocked_turf = get_step(dest, facing)
			if(blocked_turf && !(blocked_turf in extra_turfs))
				extra_turfs += blocked_turf
		for(var/turf/check_turf in extra_turfs)
			for(var/mob/living/victim in check_turf)
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
				victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, push_dist), push_dist, 1, H, force = MOVE_FORCE_STRONG)

	if(!hit_count)
		H.visible_message(span_notice("[H] finishes the charge with a swing at the air."))
		return

	if(M)
		M.add_stacks(1)
	playsound(dest, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 80, TRUE)

	log_combat(H, null, "used Charge!")
	return TRUE
