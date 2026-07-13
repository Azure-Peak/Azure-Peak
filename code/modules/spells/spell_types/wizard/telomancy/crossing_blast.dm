/datum/action/cooldown/spell/telegraphed_strike/crossing_blast
	button_icon = 'icons/mob/actions/mage_telomancy.dmi'
	name = "Crossing Blast"
	desc = "Wind up a burst of raw arcyne force, then detonate it in radiating arms around you, striking and hurling back everyone. Its shape change with every cast, not even the caster can predict what shape it will take."
	button_icon_state = "energetic_blast"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_TELOMANCY

	invocation_type = INVOCATION_SHOUT
	invocations = list("Cruce Ferio!")

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	cooldown_time = 20 SECONDS
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_HIGH
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	damage = 75
	strike_damage_type = BRUTE
	blade_class = BCLASS_BLUNT
	npc_simple_damage_mult = 1.5
	committed_strike = TRUE
	interruptible = FALSE
	charging_slowdown = 1
	windup_time = TELEGRAPH_AREA_DENIAL
	sweep_step = 0
	telegraph_type = /obj/effect/temp_visual/trap/telomancy
	strike_sound = 'sound/magic/vlightning.ogg'
	detonate_sound = 'sound/magic/blink.ogg'

	var/arm_length = 3
	var/push_dist = 2
	/// The pattern rolled for the current cast, cached so telegraph and strike always match.
	var/list/current_pattern

/datum/action/cooldown/spell/telegraphed_strike/crossing_blast/cast(atom/cast_on)
	current_pattern = roll_pattern()
	return ..()

/datum/action/cooldown/spell/telegraphed_strike/crossing_blast/proc/roll_pattern()
	var/list/offsets = list()
	switch(rand(1, 3))
		if(1) // cross
			for(var/i in 1 to arm_length)
				offsets += list(list(0, i), list(0, -i), list(i, 0), list(-i, 0))
		if(2) // saltire
			for(var/i in 1 to arm_length)
				offsets += list(list(i, i), list(i, -i), list(-i, i), list(-i, -i))
		else // star
			for(var/i in 1 to max(1, arm_length - 1))
				offsets += list(list(0, i), list(0, -i), list(i, 0), list(-i, 0), list(i, i), list(i, -i), list(-i, i), list(-i, -i))
	return offsets

/datum/action/cooldown/spell/telegraphed_strike/crossing_blast/get_pattern_offsets()
	if(!current_pattern)
		current_pattern = roll_pattern()
	return current_pattern

/datum/action/cooldown/spell/telegraphed_strike/crossing_blast/get_sweep_bands()
	return list(get_pattern_offsets())

/datum/action/cooldown/spell/telegraphed_strike/crossing_blast/on_impact(mob/living/carbon/human/H, facing, atom/movable/visual)
	var/turf/origin = get_turf(H)
	if(!origin)
		return
	for(var/list/off in get_pattern_offsets())
		var/list/r = rotate_offset(off[1], off[2], facing)
		var/turf/T = locate(origin.x + r[1], origin.y + r[2], origin.z)
		if(!T || T.density)
			continue
		new /obj/effect/temp_visual/crossing_blast(T)

/datum/action/cooldown/spell/telegraphed_strike/crossing_blast/on_hit_target(mob/living/carbon/human/H, mob/living/L, facing)
	var/push_dir = get_dir(H, L)
	if(!push_dir)
		return
	L.safe_throw_at(get_ranged_target_turf(L, push_dir, push_dist), push_dist, 2, H, force = MOVE_FORCE_STRONG)

/obj/effect/temp_visual/trap/telomancy
	color = GLOW_COLOR_ARCANE
	light_color = GLOW_COLOR_ARCANE
	duration = 3 SECONDS

/obj/effect/temp_visual/crossing_blast
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_blast"
	name = "arcyne discharge"
	desc = "Get out of the way!"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER
	light_outer_range = 2
	light_color = GLOW_COLOR_ARCANE
