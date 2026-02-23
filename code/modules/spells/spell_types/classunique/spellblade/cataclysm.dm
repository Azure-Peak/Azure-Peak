/* Cataclysm - Macebearer ultimate ground slam.
Blink to target location and slam the ground on arrival.
Hits everyone on the landing tile + 3x3 ring knockback outward.

Requires 7+ momentum (overcharge zone) — same pattern as Blade Storm / Gate of Reckoning.
At 7: base damage + knockback.
At 10: bonus damage + applies Exposed to all victims AND the caster.
The self-Exposed is the price for such an easy mass Expose.

Telegraph with spellwarning before landing. Short range (4 tiles) —
you're a macebearer, not a teleporter. Cross-Z not supported.
Respects spell_guard_check for the center hit. */

/obj/effect/proc_holder/spell/invoked/cataclysm
	name = "Cataclysm"
	desc = "Blink to a target location and slam the ground with cataclysmic force. \
		Hits everyone on the landing tile, then a shockwave knocks back everyone in a 3x3 ring. \
		Requires 7 momentum. At 10 momentum, all hits deal bonus damage and apply Exposed \
		to all victims — and to yourself. \
		Can be deflected by Defend stance."
	clothes_req = FALSE
	range = 4
	overlay_state = "jump"
	releasedrain = 40
	chargedrain = 1
	chargetime = 10
	recharge_time = 45 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	invocations = list()
	invocation_type = "shout"
	gesture_required = TRUE
	xp_gain = FALSE
	var/center_damage = 50
	var/ring_damage = 35
	var/bonus_center_damage = 15
	var/bonus_ring_damage = 10
	var/min_momentum = 7
	var/max_momentum = 10
	var/knockback_range = 2

/obj/effect/proc_holder/spell/invoked/cataclysm/can_cast(mob/user = usr)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/cataclysm/cast(list/targets, mob/user = usr)
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
	var/turf/dest = get_turf(target)
	var/turf/start = get_turf(H)

	if(!dest)
		to_chat(H, span_warning("Invalid target!"))
		revert_cast()
		return

	if(dest.density)
		to_chat(H, span_warning("I cannot land on solid ground!"))
		revert_cast()
		return

	if(dest.z != start.z)
		to_chat(H, span_warning("Too far — I need to be on the same level!"))
		revert_cast()
		return

	var/distance = get_dist(start, dest)
	if(distance < 2)
		to_chat(H, span_warning("Too close — I need more distance to leap!"))
		revert_cast()
		return

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		to_chat(H, span_warning("Not enough momentum! I need at least [min_momentum] stacks!"))
		revert_cast()
		return

	var/stacks = M.stacks
	var/empowered = stacks >= max_momentum
	var/final_center_damage = center_damage + (empowered ? bonus_center_damage : 0)
	var/final_ring_damage = ring_damage + (empowered ? bonus_ring_damage : 0)
	M.consume_all_stacks()
	to_chat(H, span_notice("All [stacks] momentum released — cataclysm [empowered ? "fully empowered" : "unleashed"]!"))

	H.say("RUINA CAELI!")
	H.visible_message(span_boldwarning("[H] gathers arcyne force for a devastating leap!"))

	new /obj/effect/temp_visual/blade_storm_telegraph(dest)
	for(var/turf/T in get_hear(1, dest))
		if(T != dest)
			new /obj/effect/temp_visual/blade_storm_telegraph(T)
	playsound(dest, 'sound/magic/charging.ogg', 60, TRUE)

	addtimer(CALLBACK(src, PROC_REF(do_landing), H, held_weapon, dest, start, final_center_damage, final_ring_damage, empowered), 8)

	log_combat(H, target, "used Cataclysm on")
	return TRUE

/obj/effect/proc_holder/spell/invoked/cataclysm/proc/do_landing(mob/living/carbon/human/user, obj/item/weapon, turf/dest, turf/start, center_dmg, ring_dmg, empowered)
	if(QDELETED(user) || user.stat == DEAD)
		return

	new /obj/effect/temp_visual/blink(get_turf(user), user)

	if(user.buckled)
		user.buckled.unbuckle_mob(user, TRUE)

	do_teleport(user, dest, channel = TELEPORT_CHANNEL_MAGIC)

	new /obj/effect/temp_visual/blink(dest, user)

	// Ground slam visuals
	for(var/swing_dir in list(NORTH, SOUTH, EAST, WEST))
		var/obj/effect/melee_swing/S = new(dest)
		S.dir = swing_dir
		flick(pick("left_swing", "right_swing"), S)
		QDEL_IN(S, 1 SECONDS)

	playsound(dest, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 100, TRUE)
	playsound(dest, 'sound/magic/blink.ogg', 65, TRUE)
	new /obj/effect/temp_visual/kinetic_blast(dest)

	user.visible_message(
		span_danger("[user] crashes down with cataclysmic force!"),
		span_notice("I bring the hammer down!"))

	// Center hit — everyone on landing tile
	for(var/mob/living/victim in dest)
		if(victim == user || victim.stat == DEAD)
			continue
		if(spell_guard_check(victim, FALSE, user))
			continue
		arcyne_strike(user, victim, weapon, center_dmg, BODY_ZONE_CHEST, BCLASS_BLUNT, spell_name = "Cataclysm (Impact)")
		if(empowered)
			victim.apply_status_effect(/datum/status_effect/debuff/exposed, 10 SECONDS)

	// Ring knockback — 3x3 ring around caster
	var/list/ring = list()
	for(var/dx in -1 to 1)
		for(var/dy in -1 to 1)
			if(dx == 0 && dy == 0)
				continue
			var/turf/T = locate(dest.x + dx, dest.y + dy, dest.z)
			if(T)
				ring += T
				new /obj/effect/temp_visual/kinetic_blast(T)

	for(var/turf/T in ring)
		for(var/mob/living/bystander in T)
			if(bystander == user || bystander.stat == DEAD)
				continue
			arcyne_strike(user, bystander, weapon, ring_dmg, BODY_ZONE_CHEST, BCLASS_BLUNT, spell_name = "Cataclysm (Shockwave)")
			if(empowered)
				bystander.apply_status_effect(/datum/status_effect/debuff/exposed, 10 SECONDS)
			var/push_dir = get_dir(user, bystander)
			if(!push_dir)
				push_dir = pick(GLOB.cardinals)
			bystander.safe_throw_at(get_edge_target_turf(user, push_dir), knockback_range, 1, user, force = MOVE_FORCE_STRONG)

	// Self-Exposed at max momentum — the price of power
	if(empowered)
		user.apply_status_effect(/datum/status_effect/debuff/exposed, 10 SECONDS)
		to_chat(user, span_boldwarning("The force of impact leaves me exposed!"))
