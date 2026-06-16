/datum/action/cooldown/spell/coordinated_assault
	name = "Coordinated Assault"
	desc = "A cheap, one-slash attack that causes you to dash to your opponent, \
		inflicting burn and buffing members of the Church in your sight if they are currently inflicted with Burn. \
		There is no benefit to empowering. \
		If your target defends against the strike, you will be left exposed and slowed."
	button_icon = 'icons/mob/actions/classuniquespells/firemonk.dmi'
	button_icon_state = "coordinated"
	sound = 'sound/magic/firemonk/dash.ogg'
	spell_color = GLOW_COLOR_FIREMONK
	glow_intensity = GLOW_INTENSITY_MEDIUM

	cast_range = 7

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_MOBILITY

	invocations = list("Huā zhǎn!") //tl: flower slash
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_POKE
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 12 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_LOW
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/max_range = 5

/datum/action/cooldown/spell/coordinated_assault/cast(atom/cast_on)
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
		span_warning("[H] vanishes in a flurry of flames!"),
		span_notice("I dash!"))

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)
	do_teleport(H, dest, channel = TELEPORT_CHANNEL_MAGIC)
	playsound(dest, 'sound/magic/firemonk/dash.ogg', 25, TRUE)

	log_combat(H, cast_on, "used Coordinated Assault on")

	var/locked_zone = H.zone_selected || BODY_ZONE_CHEST

	if(length(mobs_in_path))
		addtimer(CALLBACK(src, PROC_REF(execute_path_strikes), H, mobs_in_path, locked_zone), 5)

	return TRUE

/datum/action/cooldown/spell/coordinated_assault/proc/find_landing_turf(mob/living/user, mob/living/target_mob)
	var/approach_dir = get_dir(user, target_mob)
	var/turf/far_side = get_step(target_mob, approach_dir)
	if(far_side && !far_side.density && !istransparentturf(far_side) && isfloorturf(far_side))
		return far_side
	return get_turf(target_mob)

/datum/action/cooldown/spell/coordinated_assault/proc/execute_path_strikes(mob/living/carbon/human/user, list/victims)
	if(!user || QDELETED(user))
		return
	var/strike_zone = user.zone_selected || BODY_ZONE_CHEST
	var/deflected = FALSE
	for(var/mob/living/victim in victims)
		if(QDELETED(victim) || victim.stat == DEAD)
			continue
		if(spell_guard_check(victim, FALSE, deflected ? null : user))
			if(!deflected)
				deflected = TRUE
				user.Slowdown(2)
			continue
		arcyne_strike(user, victim, damage = 15, def_zone = strike_zone, spell_name = "Coordinated Assault", skip_animation = TRUE, skip_message = TRUE)
		for(var/mob/living/carbon/human/buffed in (get_hearers_in_view(5, user)))
			if(isliving(buffed))
				if(buffed.has_status_effect(/datum/status_effect/stacking/burn))
					if(buffed.job in GLOB.church_positions)
						buffed.apply_status_effect(/datum/status_effect/buff/coordinated_assault)
		var/turf/victim_turf = get_turf(victim)
		if(victim_turf)
			new /obj/effect/temp_visual/flame_slash/(victim_turf)


/datum/action/cooldown/spell/coordinated_assault/proc/create_afterimage_trail(mob/living/carbon/human/user, list/path_turfs)
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

/obj/effect/temp_visual/flame_slash
	icon = 'icons/effects/effects.dmi'
	icon_state = "burn_flash"
	name = "flashing sunup"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER

/datum/status_effect/buff/coordinated_assault
	id = "coordinated_assault"
	alert_type = /atom/movable/screen/alert/status_effect/buff/coordinated_assault
	effectedstats = list(STATKEY_LCK = 1, STATKEY_CON = 1, STATKEY_WIL = 1, STATKEY_INT = 2)
	duration = 5 MINUTES
	var/originalcmode = ""

/atom/movable/screen/alert/status_effect/buff/coordinated_assault
	name = "coordinated assault"
	desc = "I'm bolstered by the flames surrounding me. Time to strike."
	icon_state = "strike"


/datum/status_effect/buff/coordinated_assault/on_apply()
	. = ..()
	originalcmode = owner.cmode_music
	owner.cmode_music = 'sound/music/combat_coordinated.ogg'

/datum/status_effect/buff/coordinated_assault/on_remove()
	owner.cmode_music = originalcmode
	. = ..()
