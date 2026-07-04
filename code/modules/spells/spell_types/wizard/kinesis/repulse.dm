/datum/action/cooldown/spell/repulse
	button_icon = 'icons/mob/actions/mage_kinesis.dmi'
	name = "Repulse"
	desc = "Conjure forth a wave of energy, repelling anyone around you.\
	Deals massive damage to anyone below you on the ground."
	button_icon_state = "repulse"
	sound = 'sound/magic/repulse.ogg'
	spell_color = GLOW_COLOR_KINESIS
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = TRUE
	self_cast_possible = TRUE
	point_cost = 3

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Repello!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_drain = 1
	// Very high slowdown to make it offensively less useful
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY 
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 25 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/maxthrow = 3
	var/sparkle_path = /obj/effect/temp_visual/gravpush
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG
	var/showsparkles = TRUE
	var/floor_slam_damage = 90
	var/push_range = 1

/datum/action/cooldown/spell/repulse/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	for(var/turf/T in get_hear(push_range, user))
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == user || AM.anchored)
			continue

		var/guard_deflected = FALSE
		if(ismob(AM))
			var/mob/M = AM
			if(M.anti_magic_check())
				continue
			if(isliving(M) && spell_guard_check(M, TRUE))
				M.visible_message(span_warning("[M] braces against the wave of force!"))
				guard_deflected = TRUE

		throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(AM, user)))
		distfromcaster = get_dist(user, AM)
		if(guard_deflected)
			AM.safe_throw_at(throwtarget, 2, 1, user, force = repulse_force)
		else if(distfromcaster == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				arcyne_strike(user, AM, null, floor_slam_damage, BODY_ZONE_CHEST, \
				BCLASS_BLUNT, spell_name = "Repulse", \
				damage_type = BRUTE, npc_simple_damage_mult = 1, \
				skip_animation = TRUE)
				to_chat(M, span_danger("You're slammed into the floor by [user]!"))
				new /obj/effect/temp_visual/spell_impact(get_turf(M), spell_color, spell_impact_intensity)
		else
			if(showsparkles)
				new sparkle_path(get_turf(AM), get_dir(user, AM))
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				to_chat(M, span_danger("You're thrown back by [user]!"))
			AM.safe_throw_at(throwtarget, ((CLAMP((maxthrow - (CLAMP(distfromcaster - 2, 0, distfromcaster))), 3, maxthrow))), 1, user, force = repulse_force)
	return TRUE
