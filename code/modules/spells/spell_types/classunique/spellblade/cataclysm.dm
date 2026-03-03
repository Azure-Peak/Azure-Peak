/* Cataclysm - Macebearer ultimate AoE.
Conjure an arcyne hammer and hurl it at a target area.
On impact it explodes, crushing everyone in a 5x5 area.
Applies Vulnerable on hit to encourage melee follow-up.

Requires 7+ momentum (overcharge zone) — same pattern as Blade Storm / Gate of Reckoning.
At 7: base damage. At 10: bonus damage on all hits.
No mobility, no teleport. Pure telegraphed AoE damage.
Applies a nice little spin animation for flavor and fun.
Travel time + telegraph time is exact same as snap freeze total.
Longest range AOE Ult for Spellblade but Macebearer has no actual ranged poke.
Also massive FF potential.
Defend blocks damage, no reflect penalty. Same Z-level only. */

/obj/effect/proc_holder/spell/invoked/cataclysm
	name = "Cataclysm"
	desc = "Let the mountain fall. Conjure a hammer of pure arcyne force and hurl it at a target area. \
		On impact it explodes, crushing everyone in a 5x5 area for 100 blunt damage and leaving them Vulnerable. \
		Requires 7 momentum. Overcharged at 10 momentum: 180 damage. \
		Same level only. Can be blocked by Defend stance."
	clothes_req = FALSE
	range = 7
	action_icon = 'icons/mob/actions/spellblade.dmi' // Icon by Prominence / Nobleed
	overlay_state = "cataclysm"
	releasedrain = 40
	chargedrain = 1
	chargetime = 20
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
	var/delay = 10
	var/damage = 100
	var/bonus_damage = 80
	var/area_of_effect = 2
	var/min_momentum = 7
	var/empowered_momentum = 10
	var/vulnerable_duration = 6 SECONDS

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
	var/turf/T = get_turf(target)
	var/turf/start = get_turf(H)

	if(!T)
		to_chat(H, span_warning("Invalid target!"))
		revert_cast()
		return

	if(T.density)
		to_chat(H, span_warning("I cannot hurl a hammer into solid ground!"))
		revert_cast()
		return

	if(T.z != start.z)
		to_chat(H, span_warning("Too far — I need to be on the same level!"))
		revert_cast()
		return

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		to_chat(H, span_warning("Not enough momentum! I need at least [min_momentum] stacks!"))
		revert_cast()
		return

	var/stacks = M.stacks
	var/empowered = stacks >= empowered_momentum
	var/final_damage = damage + (empowered ? bonus_damage : 0)
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST
	M.consume_all_stacks()
	to_chat(H, span_notice("All [stacks] momentum released — cataclysm [empowered ? "fully empowered" : "unleashed"]!"))

	H.say("RUINA CAELI!", forced = "spell")

	// Conjure hammer — loud boom
	playsound(start, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 100, TRUE)
	H.visible_message(span_boldwarning("[H] conjures a massive hammer out of arcyne force!"))

	// Telegraph — 5x5 area (snap_freeze pattern)
	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		new /obj/effect/temp_visual/blade_storm_telegraph(affected_turf)

	log_combat(H, target, "used Cataclysm on")

	sleep(delay)

	if(QDELETED(H) || H.stat == DEAD)
		return

	H.visible_message(span_boldwarning("[H] hurls the hammer, aimed at the [span_combatsecondarybp(parse_zone(def_zone))]!"))
	playsound(get_turf(H), 'sound/combat/shieldraise.ogg', 100)
	var/obj/effect/temp_visual/cataclysm_boulder/boulder = new(get_turf(H))
	var/dx = (T.x - H.x) * 32
	var/dy = (T.y - H.y) * 32
	// Movement
	animate(boulder, pixel_x = dx, pixel_y = dy, time = 4)
	// Parallel spin — chain four 90° steps (360° in one step = identity = no visible rotation)
	var/matrix/q1 = matrix()
	q1.Turn(90)
	animate(boulder, transform = q1, time = 1, flags = ANIMATION_PARALLEL)
	var/matrix/q2 = matrix()
	q2.Turn(180)
	animate(transform = q2, time = 1)
	var/matrix/q3 = matrix()
	q3.Turn(270)
	animate(transform = q3, time = 1)
	animate(transform = matrix(), time = 1)

	sleep(4)

	qdel(boulder)

	// Impact
	playsound(T, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 100, TRUE)

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		new /obj/effect/temp_visual/kinetic_blast(affected_turf)
		for(var/mob/living/L in affected_turf.contents)
			if(L == H || L.stat == DEAD)
				continue
			if(L.anti_magic_check())
				L.visible_message(span_warning("The hammer shatters around [L]!"))
				playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
				continue
			if(spell_guard_check(L, TRUE))
				L.visible_message(span_warning("[L] endures the impact!"))
				continue
			if(empowered)
				arcyne_strike(H, L, held_weapon, round(final_damage / 2), def_zone, BCLASS_BLUNT, spell_name = "Cataclysm", skip_message = TRUE)
				arcyne_strike(H, L, held_weapon, round(final_damage / 2), def_zone, BCLASS_BLUNT, spell_name = "Cataclysm")
			else
				arcyne_strike(H, L, held_weapon, final_damage, def_zone, BCLASS_BLUNT, spell_name = "Cataclysm")
			L.apply_status_effect(/datum/status_effect/debuff/vulnerable, vulnerable_duration)
			playsound(affected_turf, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 60, TRUE)

	return TRUE

// --- Projectile visual ---

/obj/effect/temp_visual/cataclysm_boulder
	icon = 'icons/roguetown/weapons/blunt32.dmi'
	icon_state = "iwarhammer"
	name = "arcyne hammer"
	desc = "A hammer of pure arcyne force."
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
	duration = 8
