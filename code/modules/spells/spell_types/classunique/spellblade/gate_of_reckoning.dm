/* Gate of Reckoning - Phalangite ultimate single-target spell.
Conjure a portal above a target, rain three phantom spears down on them,
then blink to their position and strike them twice. Also do a pseudo
Repulse without knockdown to clear space around the target on arrival.

Originally, it involved the caster jumping, but it won't make sense
where there is ceiling, and neuters the class in cramped spaces, so
instead now it drops spears and teleports.

Sequences:
1. Open portal above target (Telegraph + Warning) (Use spellwarning to warn)
2. Drop three phantom spears simultaneously onto the target in a wing formation.
The spears respect aim zone (Since melee want to break armor on one spot) (pseudo-melee, respects guard)
3. Blinks to the caster's portal to target's position
4. Strikes twice on arrival (1 tick apart) + sweep + knockback bystanders simultaneously
5. DYNASTY WARRIORS!!!!! Guan dao sweep — 3x3 ring slash around caster on landing

Requires 7+ momentum (overcharge zone) — same pattern as Blade Storm.
At 7: base damage. At 10: bonus damage on all hits.
No blink validation — rewards creative cross-Z use after building momentum.
If Defended against, both instance will be deflected for no damage, but the caster will still teleport and knockback will still occur.
Cross-Z uses a longer telegraph.*/

/obj/effect/proc_holder/spell/invoked/gate_of_reckoning
	name = "Gate of Reckoning"
	desc = "Porta Iudicii — the Gate of Judgement. Tear open a leyline portal above your target. \
		Three phantom spears rain down, striking your aimed bodypart. \
		Then step through the gate yourself — two quick thrusts followed by a sweeping blow that knocks back bystanders. \
		Requires 7 momentum. Overcharged at 10 momentum: all hits deal bonus damage. \
		The arrival strikes can be deflected by Defend stance. Works across Z-levels."
	clothes_req = FALSE
	range = 6
	action_icon = 'icons/mob/actions/spellblade.dmi'
	overlay_state = "gate_of_reckoning" // Icon by Prominence.
	releasedrain = 40
	chargedrain = 1
	chargetime = 10
	recharge_time = 60 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	invocations = list()
	invocation_type = "shout"
	gesture_required = TRUE
	xp_gain = FALSE
	var/spear_damage = 30
	var/arrival_damage = 25
	var/sweep_damage = 40
	var/bonus_spear_damage = 20
	var/bonus_arrival_damage = 15
	var/bonus_sweep_damage = 20
	var/min_momentum = 7
	var/max_momentum = 10
	var/knockback_range = 1
	var/spear_count = 3

/obj/effect/proc_holder/spell/invoked/gate_of_reckoning/can_cast(mob/user = usr)
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

/obj/effect/proc_holder/spell/invoked/gate_of_reckoning/cast(list/targets, mob/user = usr)
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
		to_chat(H, span_warning("I cannot open a gate into solid ground!"))
		revert_cast()
		return

	var/distance = get_dist(start, dest)
	if(distance < 2 && dest.z == start.z)
		to_chat(H, span_warning("Too close — I need more distance to open a gate!"))
		revert_cast()
		return

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		to_chat(H, span_warning("Not enough momentum! I need at least [min_momentum] stacks!"))
		revert_cast()
		return

	var/stacks = M.stacks
	var/empowered = stacks >= max_momentum
	var/final_spear_damage = spear_damage + (empowered ? bonus_spear_damage : 0)
	var/final_arrival_damage = arrival_damage + (empowered ? bonus_arrival_damage : 0)
	var/final_sweep_damage = sweep_damage + (empowered ? bonus_sweep_damage : 0)
	M.consume_all_stacks()
	to_chat(H, span_notice("All [stacks] momentum released — gate [empowered ? "fully empowered" : "opened"]!"))

	var/cross_z = (dest.z != start.z)
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST

	H.say("Porta Iudicii!", forced = "spell")
	H.visible_message(span_boldwarning("[H] tears open a leyline rift above [target], aimed at the [span_combatsecondarybp(parse_zone(def_zone))]!"))

	new /obj/effect/temp_visual/gate_of_reckoning_rift(dest)
	playsound(dest, 'sound/misc/portalactivate.ogg', 80, TRUE)

	new /obj/effect/temp_visual/blade_storm_telegraph(dest)
	new /obj/effect/temp_visual/gate_of_reckoning_warning(dest)
	for(var/turf/T in get_hear(1, dest))
		if(T != dest)
			new /obj/effect/temp_visual/blade_storm_telegraph(T)

	var/telegraph_ticks = cross_z ? 12 : 8

	// All three spears drop simultaneously — visuals offset in wing formation
	addtimer(CALLBACK(src, PROC_REF(do_spear_drop), user, held_weapon, dest, target, final_spear_damage, def_zone), telegraph_ticks)

	// Arrival 2 ticks after spear impact (spears drop at telegraph_ticks, impact 2 ticks later)
	addtimer(CALLBACK(src, PROC_REF(do_arrival_strike), H, held_weapon, dest, target, start, def_zone, final_arrival_damage, final_sweep_damage), telegraph_ticks + 2 + 2)

	log_combat(H, target, "used Gate of Reckoning on")
	return TRUE

/obj/effect/proc_holder/spell/invoked/gate_of_reckoning/proc/do_spear_drop(mob/living/carbon/human/user, obj/item/weapon, turf/dest, atom/original_target, damage, def_zone)
	if(QDELETED(user) || user.stat == DEAD)
		return

	// Wing formation: center spear ahead, two flanking far behind for dramatic spread
	// All spears shifted left to compensate for the right-biased 64x64 sprite
	var/obj/effect/temp_visual/gate_of_reckoning_spear/center = new(dest)
	center.pixel_x = -16
	center.pixel_z = 96
	center.pixel_y = -6
	animate(center, pixel_z = 0, time = 2, easing = LINEAR_EASING)

	var/obj/effect/temp_visual/gate_of_reckoning_spear/left = new(dest)
	left.pixel_x = -28
	left.pixel_z = 96
	left.pixel_y = 8
	animate(left, pixel_z = 0, time = 2, easing = LINEAR_EASING)

	var/obj/effect/temp_visual/gate_of_reckoning_spear/right = new(dest)
	right.pixel_x = -4
	right.pixel_z = 96
	right.pixel_y = 8
	animate(right, pixel_z = 0, time = 2, easing = LINEAR_EASING)

	addtimer(CALLBACK(src, PROC_REF(do_spear_impact), user, weapon, dest, original_target, damage, def_zone), 2)

/obj/effect/proc_holder/spell/invoked/gate_of_reckoning/proc/do_spear_impact(mob/living/carbon/human/user, obj/item/weapon, turf/dest, atom/original_target, damage, def_zone)
	if(QDELETED(user) || user.stat == DEAD)
		return

	playsound(dest, pick('sound/combat/hits/bladed/genthrust (1).ogg', 'sound/combat/hits/bladed/genthrust (2).ogg'), 100, TRUE)
	new /obj/effect/temp_visual/kinetic_blast(dest)

	for(var/mob/living/victim in dest)
		if(victim == user || victim.stat == DEAD)
			continue
		if(spell_guard_check(victim, FALSE, user))
			continue
		// Three spear strikes — skip animation and message since the visual is the spear drop itself
		for(var/i in 1 to spear_count)
			arcyne_strike(user, victim, weapon, damage, def_zone, BCLASS_STAB, spell_name = "Gate of Reckoning (Spear)", skip_animation = TRUE)
		victim.visible_message(
			span_danger("Phantom spears impale [victim]'s [parse_zone(def_zone)]!"),
			span_userdanger("Phantom spears pierce my [parse_zone(def_zone)]!"))

/obj/effect/proc_holder/spell/invoked/gate_of_reckoning/proc/do_arrival_strike(mob/living/carbon/human/user, obj/item/weapon, turf/dest, atom/original_target, turf/start, def_zone, damage, sweep_dmg)
	if(QDELETED(user) || user.stat == DEAD)
		return

	new /obj/effect/temp_visual/blink(get_turf(user), user)

	if(user.buckled)
		user.buckled.unbuckle_mob(user, TRUE)

	do_teleport(user, dest, channel = TELEPORT_CHANNEL_MAGIC)

	new /obj/effect/temp_visual/blink(dest, user)
	playsound(dest, 'sound/magic/blink.ogg', 65, TRUE)

	user.visible_message(
		span_danger("[user] erupts from the leyline rift!"),
		span_notice("I step through the gate!"))

	var/mob/living/victim = null

	if(isliving(original_target))
		var/mob/living/L = original_target
		if(!QDELETED(L) && L.stat != DEAD && get_dist(dest, get_turf(L)) <= 1)
			victim = L

	if(!victim)
		for(var/mob/living/M in dest)
			if(M != user && M.stat != DEAD)
				victim = M
				break
	if(!victim)
		for(var/turf/T in get_hear(1, dest))
			for(var/mob/living/M in T)
				if(M != user && M.stat != DEAD)
					victim = M
					break
			if(victim)
				break

	if(!victim)
		user.visible_message(span_notice("[user] lands with a thrust at the air."))
		do_landing_sweep(user, weapon, dest, sweep_dmg)
		return

	if(spell_guard_check(victim, FALSE, user))
		do_landing_sweep(user, weapon, dest, sweep_dmg)
		return

	// First arrival strike + sweep happens simultaneously
	arcyne_strike(user, victim, weapon, damage, def_zone, BCLASS_STAB, spell_name = "Gate of Reckoning (Arrival)")
	do_landing_sweep(user, weapon, dest, sweep_dmg, victim)
	// Second arrival strike after 1 tick
	addtimer(CALLBACK(src, PROC_REF(do_second_arrival_strike), user, victim, weapon, damage, def_zone), 1)

/// Delayed second arrival thrust
/obj/effect/proc_holder/spell/invoked/gate_of_reckoning/proc/do_second_arrival_strike(mob/living/carbon/human/user, mob/living/victim, obj/item/weapon, damage, def_zone)
	if(QDELETED(user) || user.stat == DEAD)
		return
	if(!QDELETED(victim) && victim.stat != DEAD && get_dist(get_turf(user), get_turf(victim)) <= 1)
		if(!spell_guard_check(victim, FALSE, user))
			arcyne_strike(user, victim, weapon, damage, def_zone, BCLASS_STAB, spell_name = "Gate of Reckoning (Arrival)")

/// DYNASTY WARRIORS!!!!! Guan dao sweep — single wide slash hitting 3x3 ring around caster
/obj/effect/proc_holder/spell/invoked/gate_of_reckoning/proc/do_landing_sweep(mob/living/carbon/human/user, obj/item/weapon, turf/dest, damage, mob/living/primary_target)
	// Melee swing visuals — same as Blade Storm
	for(var/swing_dir in list(NORTH, SOUTH, EAST, WEST))
		var/obj/effect/melee_swing/S = new(dest)
		S.dir = swing_dir
		flick(pick("left_swing", "right_swing"), S)
		QDEL_IN(S, 1 SECONDS)

	playsound(dest, pick("genslash"), 100, TRUE)
	playsound(dest, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 80, TRUE)

	// Hit 3x3 ring (center excluded — that's the arrival thrust target)
	var/list/ring = list()
	for(var/dx in -1 to 1)
		for(var/dy in -1 to 1)
			if(dx == 0 && dy == 0)
				continue
			var/turf/T = locate(dest.x + dx, dest.y + dy, dest.z)
			if(T)
				ring += T

	for(var/turf/T in ring)
		for(var/mob/living/bystander in T)
			if(bystander == user || bystander == primary_target || bystander.stat == DEAD)
				continue
			arcyne_strike(user, bystander, weapon, damage, BODY_ZONE_CHEST, BCLASS_CUT, spell_name = "Gate of Reckoning (Sweep)")
			// Knockback
			var/push_dir = get_dir(user, bystander)
			if(!push_dir)
				push_dir = pick(GLOB.cardinals)
			bystander.safe_throw_at(get_ranged_target_turf(bystander, push_dir, knockback_range), knockback_range, 1, user, force = MOVE_FORCE_STRONG)

/obj/effect/temp_visual/gate_of_reckoning_rift
	icon = 'icons/effects/effects.dmi'
	icon_state = "rift"
	duration = 20
	layer = ABOVE_LIGHTING_LAYER
	light_outer_range = 2
	pixel_y = 96

/obj/effect/temp_visual/gate_of_reckoning_spear
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	icon_state = "bronzewingedspear"
	duration = 6
	layer = ABOVE_LIGHTING_LAYER

/obj/effect/temp_visual/gate_of_reckoning_spear/Initialize(mapload)
	. = ..()
	// Sprite faces upper-right (~45 deg) by default. Scale down and rotate 135 deg to point straight down (tip-first from the sky).
	var/matrix/M = matrix()
	M.Scale(0.8, 0.8)
	M.Turn(135)
	transform = M

/// Spellwarning marker on the target tile — bright warning that a spear is about to drop
/obj/effect/temp_visual/gate_of_reckoning_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "spellwarning"
	duration = 15
	layer = ABOVE_LIGHTING_LAYER
	light_outer_range = 2
