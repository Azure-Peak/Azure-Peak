/* Advance! - Phalangite charge attack
The polar opposite of Azurean Phalanx. Where Phalanx pushes enemies back
to create space, Advance closes distance — 3 rapid steps forward in the
user's facing direction, ending with a spear thrust on anything in front.
Short cooldown, no slowdown, but the charge is visible and can be
interrupted (stun, knockdown). Builds 1 momentum on hit.
At 3+ momentum: consumes 3 stacks, doubles strike damage.

Pseudo-melee: the final thrust respects spell_guard_check. */

/obj/effect/proc_holder/spell/self/advance
	name = "Advance!"
	desc = "Charge forward 3 paces and deliver a spear thrust. \
		The opposite of Azurean Phalanx — close distance instead of creating it. \
		Builds 1 momentum on hit. \
		At 3+ momentum: consumes 3 stacks to double thrust damage. \
		The thrust strikes the bodypart you are aiming at. \
		Pseudo-melee: can be deflected by Defend stance."
	clothes_req = FALSE
	overlay_icon = 'icons/mob/actions/spellblade.dmi'
	overlay_state = "advance"
	releasedrain = 15
	chargedrain = 0
	chargetime = 2
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
	var/base_damage = 30
	var/empowered_mult = 2
	var/momentum_cost = 3
	var/step_delay = 2

/obj/effect/proc_holder/spell/self/advance/cast(list/targets, mob/user = usr)
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

	var/facing = H.dir
	var/turf/start = get_turf(H)
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
		to_chat(H, span_notice("[momentum_cost] momentum released — empowered charge!"))

	var/damage = empowered ? (base_damage * empowered_mult) : base_damage

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)

	H.visible_message(
		span_warning("[H] surges forward!"),
		span_notice("I advance!"))
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

	var/mob/living/victim = null

	for(var/mob/living/L in get_turf(H))
		if(L != H && L.stat != DEAD)
			victim = L
			break

	if(!victim)
		var/turf/ahead = get_step(get_turf(H), facing)
		if(ahead)
			for(var/mob/living/L in ahead)
				if(L != H && L.stat != DEAD)
					victim = L
					break

	if(!victim)
		H.visible_message(span_notice("[H] finishes the charge with a thrust at the air."))
		return

	if(spell_guard_check(victim, FALSE, H))
		return

	arcyne_strike(H, victim, held_weapon, damage, def_zone, BCLASS_STAB, spell_name = "Advance!")

	if(M)
		M.add_stacks(1)

	log_combat(H, victim, "used Advance! on")
	return TRUE
