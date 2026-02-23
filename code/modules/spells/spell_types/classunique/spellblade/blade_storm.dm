/* Blade Storm - Spellblade ultimate AoE
Requires 7+ momentum (overcharge zone). Strikes a 3x3 hollow square around target.
Center tile is immune — counterplay for the target (stay in the middle).
2 cuts at 7 momentum, 4 cuts at 10. 1s initial delay, 0.4s between cuts.
8 tick telegraph with (!) before damage starts.
Inherently an anti-dorpel spell to punish people for surrounding, and
can be used to support an ally who is surrounded too.
Forces them away or to take massive damage.
Uses Eris melee swing sprites (96x96) for the slash visuals. */

/obj/effect/proc_holder/spell/invoked/blade_storm
	name = "Blade Storm"
	desc = "Unleash all momentum into a devastating storm of arcyne slashes. \
		Strikes a 3x3 area around the target — the center tile is safe. \
		Requires 7 momentum. At 10 momentum, two extra slashes are added. \
		Strikes the bodypart you are aiming at. \
		Enemies have a brief window to escape the marked area."
	clothes_req = FALSE
	range = 5
	overlay_icon = 'icons/mob/actions/spellblade.dmi'
	overlay_state = "blade_storm"
	releasedrain = 50
	chargedrain = 1
	chargetime = 20
	recharge_time = 45 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("Finis.")
	invocation_type = "shout"
	gesture_required = TRUE
	xp_gain = FALSE
	var/damage_per_cut = 40
	var/min_momentum = 7
	var/max_momentum_cuts = 10
	var/base_cuts = 2
	var/bonus_cuts = 2
	var/telegraph_delay = 8
	var/cut_delay = 4
	var/storm_deflected = FALSE

/obj/effect/proc_holder/spell/invoked/blade_storm/can_cast(mob/user = usr)
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

/obj/effect/proc_holder/spell/invoked/blade_storm/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		revert_cast()
		return

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		to_chat(H, span_warning("Not enough momentum! I need at least [min_momentum] stacks!"))
		revert_cast()
		return

	var/stacks = M.stacks
	var/num_cuts = base_cuts
	if(stacks >= max_momentum_cuts)
		num_cuts = base_cuts + bonus_cuts
	M.consume_all_stacks()
	to_chat(H, span_notice("All [stacks] momentum released — [num_cuts] cuts!"))

	var/atom/target = targets[1]
	var/turf/center = get_turf(target)
	if(!center)
		revert_cast()
		return

	var/list/ring_turfs = get_hollow_ring(center)

	for(var/turf/T in ring_turfs)
		new /obj/effect/temp_visual/blade_storm_telegraph(T)
	playsound(center, 'sound/magic/blade_burst.ogg', 80, TRUE)

	H.say("Procella Gladiorum!!")
	H.visible_message(span_boldwarning("[H] raises [held_weapon.name] — arcyne energy surges outward!"))

	storm_deflected = FALSE
	var/locked_zone = H.zone_selected || BODY_ZONE_CHEST
	// Telegraph, then staggered cuts via addtimer
	for(var/cut_num in 1 to num_cuts)
		var/delay = telegraph_delay + (cut_num - 1) * cut_delay
		addtimer(CALLBACK(src, PROC_REF(do_storm_cut), H, held_weapon, center, ring_turfs, cut_num, locked_zone), delay)

	log_combat(H, target, "used Blade Storm on")
	return TRUE

/obj/effect/proc_holder/spell/invoked/blade_storm/proc/do_storm_cut(mob/living/carbon/human/user, obj/item/weapon, turf/center, list/ring_turfs, cut_num, def_zone = BODY_ZONE_CHEST)
	if(QDELETED(user) || user.stat == DEAD)
		return
	// Four melee swings from each cardinal, covering the ring
	for(var/swing_dir in list(NORTH, SOUTH, EAST, WEST))
		var/obj/effect/melee_swing/S = new(center)
		S.dir = swing_dir
		flick(pick("left_swing", "right_swing"), S)
		QDEL_IN(S, 1 SECONDS)

	playsound(center, pick("genslash"), 80, TRUE)

	for(var/turf/T in ring_turfs)
		for(var/mob/living/victim in T)
			if(victim == user || victim.stat == DEAD)
				continue
			if(spell_guard_check(victim, FALSE, storm_deflected ? null : user))
				storm_deflected = TRUE
				continue
			arcyne_strike(user, victim, weapon, damage_per_cut, def_zone, BCLASS_CUT, spell_name = "Blade Storm (Cut [cut_num])", skip_animation = TRUE)

/obj/effect/proc_holder/spell/invoked/blade_storm/proc/get_hollow_ring(turf/center)
	var/list/ring = list()
	for(var/dx in -1 to 1)
		for(var/dy in -1 to 1)
			if(dx == 0 && dy == 0)
				continue
			var/turf/T = locate(center.x + dx, center.y + dy, center.z)
			if(T)
				ring += T
	return ring

/obj/effect/temp_visual/blade_storm_telegraph
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 1
	duration = 8
	layer = MASSIVE_OBJ_LAYER

/obj/effect/melee_swing
	name = "arcyne slash"
	icon = 'icons/effects/meleeeffects.dmi'
	icon_state = ""
	pixel_x = -32
	pixel_y = -32
	anchored = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
