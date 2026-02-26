/* Advance! - Phalangite jousting charge.
Must move at least one tile to start (no free point-blank).
Once moving, jabs ahead 3 times. If blocked mid-charge, keeps
jabbing in place for the remaining steps.

Fast — 1 tick between jabs. Counterplay is sidestepping or parrying.
Interruptible by stun/knockdown.

At 3+ momentum: consumes 3, jab damage increases from 15 to 25.
Builds 1 momentum on hit. */

/obj/effect/proc_holder/spell/invoked/advance
	name = "Advance!"
	desc = "Lower the spear and charge — one pace to build speed, then three rapid jabs ahead. \
		If blocked, keeps jabbing in place. \
		Builds 1 momentum on hit. \
		At 3+ momentum: consumes 3 to increase jab damage. \
		Strikes your aimed bodypart. Can be deflected by Defend stance."
	clothes_req = FALSE
	range = 5
	action_icon = 'icons/mob/actions/spellblade.dmi'
	overlay_state = "advance"
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
	var/base_damage = 15
	var/empowered_damage = 25
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
		to_chat(H, span_warning("There's no room to charge!"))
		revert_cast()
		return

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released — empowered advance!"))

	var/damage = empowered ? empowered_damage : base_damage

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)

	H.visible_message(
		span_warning("[H] lowers [H.p_their()] [held_weapon.name] and charges!"),
		span_notice("I advance!"))
	playsound(start, pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 60, TRUE)

	// First step is mandatory — prevents free point-blank abuse
	if(!step(H, facing))
		to_chat(H, span_warning("My charge is blocked!"))
		return
	new /obj/effect/temp_visual/kinetic_blast(get_turf(H))

	var/hit_count = 0
	var/stopped = FALSE

	for(var/i in 1 to charge_steps)
		if(H.stat != CONSCIOUS || H.IsParalyzed() || H.IsStun() || QDELETED(H))
			break

		// Jab the tile ahead — spear thrust forward
		var/turf/jab_turf = get_step(get_turf(H), facing)
		if(jab_turf)
			for(var/mob/living/victim in jab_turf)
				if(victim == H || victim.stat == DEAD)
					continue
				if(spell_guard_check(victim, FALSE, hit_count == 0 ? H : null))
					continue
				arcyne_strike(H, victim, held_weapon, damage, def_zone, BCLASS_STAB, spell_name = "Advance!")
				hit_count++

		if(i < charge_steps)
			sleep(step_delay)

		// Try to advance after jabbing (except on final step)
		if(i < charge_steps && !stopped)
			var/turf/next = get_step(get_turf(H), facing)
			if(!next || next.density)
				stopped = TRUE
			else
				var/struct_blocked = FALSE
				for(var/obj/structure/S in next.contents)
					if(S.density && !S.climbable)
						struct_blocked = TRUE
						break
				if(struct_blocked)
					stopped = TRUE
				else if(!step(H, facing))
					stopped = TRUE
			if(!stopped)
				new /obj/effect/temp_visual/kinetic_blast(get_turf(H))

	if(hit_count)
		if(M)
			M.add_stacks(1)
		H.visible_message(span_danger("[H] skewers [hit_count > 1 ? "[hit_count] targets" : "a target"] during [H.p_their()] advance!"))
	else
		H.visible_message(span_notice("[H] finishes the charge with a thrust at the air."))

	log_combat(H, null, "used Advance! ([hit_count] hits)")
	return TRUE