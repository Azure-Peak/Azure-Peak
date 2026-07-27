/datum/action/cooldown/spell/blade_storm
	source_aspect = /datum/magic_aspect/pseudo/spellblade
	name = "Blade Storm"
	desc = "Mark a patch of ground within reach - a shadow of yourself coalesces there. Then, a mote later, you emerge in a storm of slashes, focusing on whomever is at its center and sweep around them.\
		Requires 7 Momentum: 4 strikes at 30 damage each. \
		Overcharged at 10 Momentum: 6 strikes at 30 damage each."
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "blade_storm"
	sound = 'sound/magic/blink.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_HIGH

	cast_range = 7

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_ULT

	invocations = list("Procella Gladiorum!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_MINOR
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_HIGH
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/telegraph_delay = 4
	var/cut_delay = 2

	var/aoe_damage = 30
	var/aoe_base_cuts = 3
	var/aoe_bonus_cuts = 2
	var/personal_damage = 30
	var/personal_base_cuts = 4
	var/personal_bonus_cuts = 7
	var/min_momentum = 7
	var/empowered_momentum = 10
	var/storm_deflected = FALSE

	var/cached_aoe_cuts = 3
	var/cached_p_cuts = 4
	var/cached_locked_zone = BODY_ZONE_CHEST

/datum/action/cooldown/spell/blade_storm/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/blade_storm/cast(atom/cast_on)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		return FALSE

	var/turf/center = get_turf(cast_on)
	if(!center)
		to_chat(H, span_warning("Invalid target!"))
		return FALSE
	if(center.density)
		to_chat(H, span_warning("I cannot strike into solid ground!"))
		return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		to_chat(H, span_warning("Not enough momentum! I need at least [min_momentum] stacks!"))
		return FALSE

	var/stacks = M.stacks
	cached_aoe_cuts = aoe_base_cuts
	cached_p_cuts = personal_base_cuts
	if(stacks >= empowered_momentum)
		cached_aoe_cuts += aoe_bonus_cuts
		cached_p_cuts += personal_bonus_cuts
	M.consume_all_stacks()
	to_chat(H, span_notice("All [stacks] momentum released into shadow!"))

	cached_locked_zone = H.zone_selected || BODY_ZONE_CHEST

	H.visible_message(span_boldwarning("[H] marks the ground - a shadow of [H.p_them()]self coalesces!"))
	log_combat(H, cast_on, "used Blade Storm on")

	var/list/ring_turfs = get_hollow_ring(center)
	new /obj/effect/temp_visual/blade_storm_telegraph/warning(center, telegraph_delay)
	for(var/turf/T in ring_turfs)
		new /obj/effect/temp_visual/blade_storm_telegraph/warning(T, telegraph_delay)
	playsound(center, 'sound/magic/charging.ogg', 60, TRUE)

	addtimer(CALLBACK(src, PROC_REF(execute_storm), H, held_weapon, center, ring_turfs, cached_aoe_cuts, aoe_damage, cached_p_cuts, personal_damage, cached_locked_zone), telegraph_delay)
	. = ..()

/datum/action/cooldown/spell/blade_storm/proc/execute_storm(mob/living/carbon/human/user, obj/item/weapon, turf/center, list/ring_turfs, aoe_cuts, aoe_dmg, p_cuts, p_dmg, def_zone)
	if(QDELETED(user) || user.stat == DEAD || !center)
		return

	weapon = arcyne_get_weapon(user)
	if(!weapon)
		return

	var/turf/start = get_turf(user)
	var/obj/effect/after_image/img = new(start, 0, 0, 0, 0, 0.5 SECONDS, 2 SECONDS, 0)
	img.name = user.name
	img.appearance = user.appearance
	img.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	img.alpha = 80
	QDEL_IN(img, 2 SECONDS)

	if(user.buckled)
		user.buckled.unbuckle_mob(user, TRUE)
	do_teleport(user, center, channel = TELEPORT_CHANNEL_MAGIC)
	playsound(center, 'sound/magic/blink.ogg', 40, TRUE)

	user.visible_message(
		span_warning("[user] erupts from the shadow!"),
		span_notice("I emerge from the shadow!"))
	playsound(center, 'sound/magic/blade_burst.ogg', 80, TRUE)
	user.visible_message(span_boldwarning("[user] raises [weapon.name] - arcyne energy surges toward the [span_combatsecondarybp(parse_zone(def_zone))]!"))

	storm_deflected = FALSE
	for(var/cut_num in 1 to aoe_cuts)
		addtimer(CALLBACK(src, PROC_REF(do_storm_cut), user, weapon, center, ring_turfs, cut_num, def_zone, aoe_dmg), (cut_num - 1) * cut_delay)

	for(var/strike_num in 1 to p_cuts)
		addtimer(CALLBACK(src, PROC_REF(do_personal_strike), user, weapon, center, strike_num, def_zone, p_dmg), (strike_num - 1) * cut_delay)

/datum/action/cooldown/spell/blade_storm/proc/do_storm_cut(mob/living/carbon/human/user, obj/item/weapon, turf/center, list/ring_turfs, cut_num, def_zone, aoe_dmg)
	if(QDELETED(user) || user.stat == DEAD)
		return

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
			arcyne_strike(user, victim, weapon, aoe_dmg, def_zone, BCLASS_CUT, spell_name = "Blade Storm (Cut [cut_num])", skip_animation = TRUE, skip_message = TRUE)

/datum/action/cooldown/spell/blade_storm/proc/do_personal_strike(mob/living/carbon/human/user, obj/item/weapon, turf/center, strike_num, def_zone, p_dmg)
	if(QDELETED(user) || user.stat == DEAD || !center)
		return

	for(var/mob/living/victim in center)
		if(victim == user || victim.stat == DEAD)
			continue
		if(spell_guard_check(victim, FALSE, user))
			continue
		arcyne_strike(user, victim, weapon, p_dmg, def_zone, spell_name = "Blade Storm (Strike [strike_num])", skip_animation = TRUE)
		var/obj/effect/temp_visual/blade_cut/V = new(center)
		V.dir = get_dir(user, victim)

/datum/action/cooldown/spell/blade_storm/proc/get_hollow_ring(turf/center)
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

/obj/effect/temp_visual/blade_storm_telegraph/warning
	alpha = 0

/obj/effect/temp_visual/blade_storm_telegraph/warning/Initialize(mapload, fade_in_time)
	if(fade_in_time)
		duration = fade_in_time
	. = ..()
	animate(src, alpha = 255, time = duration)

/obj/effect/melee_swing
	name = "arcyne slash"
	icon = 'icons/effects/meleeeffects.dmi'
	icon_state = ""
	pixel_x = -32
	pixel_y = -32
	anchored = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
