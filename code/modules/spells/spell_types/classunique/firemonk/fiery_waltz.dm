/datum/action/cooldown/spell/fiery_waltz
	name = "Fiery Waltz"
	desc = "A cheap attack that causes you to dash forward, \
		inflicting burn stacks with each strike. Anyone caught inside of the attack is struck twice, inflicting 12 Burn total. \
		Empowering doubles the amount of Burn inflicted. \
		If your target defends against the strike, you will be left exposed and slowed."
	button_icon = 'icons/mob/actions/classuniquespells/firemonk.dmi'
	button_icon_state = "fiery_waltz"
	sound = 'sound/magic/firemonk/dash.ogg'
	spell_color = GLOW_COLOR_FIREMONK
	glow_intensity = GLOW_INTENSITY_MEDIUM

	cast_range = 7

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_MOBILITY

	invocations = list("Huǒ zhǎn!") //tl: fire chop
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_MINOR
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 12 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/max_range = 5
	var/strike_damage = 25
	var/momentum_cost = 3
	var/empower_cost = 5
	var/empowered = FALSE

/datum/action/cooldown/spell/fiery_waltz/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < momentum_cost)
		if(feedback)
			to_chat(H, span_warning("Not enough momentum! I need at least [momentum_cost] stacks!"))
		return FALSE
	return TRUE


/datum/action/cooldown/spell/fiery_waltz/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/start = get_turf(H)
	var/turf/dest

	if(isliving(cast_on))
		dest = find_landing_turf(H, cast_on)
	else
		dest = get_turf(cast_on)

	if(!dest || dest.z != start.z)
		to_chat(H, span_warning("Invalid target!"))
		return FALSE

	// Soft clamp: if too far or path blocked, dash as far as possible toward target
	dest = arcyne_find_max_blink_dest(H, dest, max_range)
	if(!dest)
		to_chat(H, span_warning("I can't dash there!"))
		return FALSE

	var/distance = get_dist(start, dest)
	if(distance < 1)
		to_chat(H, span_warning("I need somewhere to dash to!"))
		return FALSE

	var/list/full_path = getline(start, dest)

	var/list/mobs_in_path = list()
	for(var/turf/path_turf in full_path)
		if(path_turf == start)
			continue
		for(var/mob/living/M in path_turf)
			if(M != H && M.stat != DEAD)
				mobs_in_path += M

	INVOKE_ASYNC(src, PROC_REF(create_afterimage_trail), H, full_path)

	playsound(start, 'sound/magic/firemonk/dash.ogg', 40, TRUE)
	H.visible_message(
		span_warning("[H] vanishes in a blur of motion!"),
		span_notice("I dash!"))

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)
	do_teleport(H, dest, channel = TELEPORT_CHANNEL_MAGIC)
	playsound(dest, 'sound/magic/firemonk/dash.ogg', 25, TRUE)

	log_combat(H, cast_on, "used Fiery Waltz on")

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum && momentum.stacks >= empower_cost)
		momentum.consume_stacks(empower_cost)
		empowered = TRUE
		to_chat(H, span_notice("Momentum surges - double burn!"))


	if(length(mobs_in_path))
		addtimer(CALLBACK(src, PROC_REF(execute_path_strikes), H, mobs_in_path), 5)

	return TRUE

/datum/action/cooldown/spell/fiery_waltz/proc/find_landing_turf(mob/living/user, mob/living/target_mob)
	var/approach_dir = get_dir(user, target_mob)
	var/turf/far_side = get_step(target_mob, approach_dir)
	if(far_side && !far_side.density && !istransparentturf(far_side) && isfloorturf(far_side))
		return far_side
	return get_turf(target_mob)

/datum/action/cooldown/spell/fiery_waltz/proc/execute_path_strikes(mob/living/carbon/human/user, list/victims)
	if(!user || QDELETED(user))
		return
	var/deflected = FALSE
	var/hit_count = 0
	for(var/mob/living/victim in victims)
		if(QDELETED(victim) || victim.stat == DEAD)
			continue
		if(spell_guard_check(victim, FALSE, deflected ? null : user))
			if(!deflected)
				deflected = TRUE
				user.Slowdown(2)
			continue
		var/total_damage = strike_damage
		arcyne_strike(user, victim, total_damage, spell_name = "Fiery Waltz", skip_animation = TRUE, skip_message = TRUE)
		playsound(user, 'sound/magic/firemonk/hitslash.ogg', 100, TRUE)
		if(empowered)
			victim.apply_burn(12)
		else
			victim.apply_burn(6)
		hit_count++
		var/turf/victim_turf = get_turf(victim)
		if(victim_turf)
			var/slash_dir = get_dir(user, victim)
			var/obj/effect/temp_visual/blade_cut/V = new(victim_turf)
			V.dir = slash_dir
		addtimer(CALLBACK(src, PROC_REF(second_strike), user, victim), 3)
	if(hit_count >= 2)
		var/datum/status_effect/buff/arcyne_momentum/surge = user.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
		if(surge)
			surge.add_stacks(1)

/datum/action/cooldown/spell/fiery_waltz/proc/second_strike(mob/living/carbon/human/user, mob/living/victim)
	if(!user || QDELETED(user) || !victim || QDELETED(victim) || victim.stat == DEAD)
		return
	var/total_damage = strike_damage
	arcyne_strike(user, victim, total_damage, spell_name = "Fiery Waltz", skip_animation = TRUE, skip_message = TRUE)
	playsound(user, 'sound/magic/firemonk/hitslashstrong.ogg', 100, TRUE)
	if(empowered)
		victim.apply_burn(12)
	else
		victim.apply_burn(6)
	var/turf/victim_turf = get_turf(victim)
	if(victim_turf)
		var/slash_dir = get_dir(user, victim)
		var/obj/effect/temp_visual/blade_cut/V = new(victim_turf)
		V.dir = slash_dir

/datum/action/cooldown/spell/fiery_waltz/proc/create_afterimage_trail(mob/living/carbon/human/user, list/path_turfs)
	set waitfor = FALSE
	var/list/images = list()
	var/path_len = length(path_turfs)
	if(path_len < 2)
		return
	var/travel_dir = get_dir(path_turfs[1], path_turfs[path_len])

	var/front_px = 0
	var/front_py = 0
	var/back_px = 0
	var/back_py = 0
	switch(travel_dir)
		if(NORTH)
			front_py = 10
			back_py = -10
		if(SOUTH)
			front_py = -10
			back_py = 10
		if(EAST)
			front_px = 10
			back_px = -10
		if(WEST)
			front_px = -10
			back_px = 10
		if(NORTHEAST)
			front_px = 8
			front_py = 8
			back_px = -8
			back_py = -8
		if(NORTHWEST)
			front_px = -8
			front_py = 8
			back_px = 8
			back_py = -8
		if(SOUTHEAST)
			front_px = 8
			front_py = -8
			back_px = -8
			back_py = 8
		if(SOUTHWEST)
			front_px = -8
			front_py = -8
			back_px = 8
			back_py = 8

	for(var/i in 1 to path_len)
		var/turf/T = path_turfs[i]
		var/base_alpha = round(40 + 80 * (i - 1) / max(path_len - 1, 1))
		for(var/side in 1 to 2)
			var/obj/effect/after_image/img = new(T, 0, 0, 0, 0, 0.5 SECONDS, 3 SECONDS, 0)
			images += img
			img.name = user.name
			img.appearance = user.appearance
			img.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
			img.dir = travel_dir
			img.alpha = base_alpha
			if(side == 1)
				img.pixel_x = front_px
				img.pixel_y = front_py
			else
				img.pixel_x = back_px
				img.pixel_y = back_py
	QDEL_LIST_IN(images, 2 SECONDS)

/obj/effect/temp_visual/blade_cut
	icon = 'icons/effects/effects.dmi'
	icon_state = "cut"
	dir = NORTH
	name = "arcyne slash"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER
