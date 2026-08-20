/datum/action/cooldown/spell/telegraphed_strike/kinetic_burst
	button_icon = 'icons/mob/actions/mage_kinesis.dmi'
	name = "Kinetic Burst"
	desc = "Wind up raw arcyne force in a 5x5 area around yourself, then detonate it - hurling everyone caught back, hurting them and leaving them Vulnerable for a moment. \
	The field follows you as you wind it up. Guard will deflect the strike entirely and you are vulnerable while charging this up."
	button_icon_state = "gravity_anchor"
	sound = 'sound/magic/repulse.ogg'
	spell_color = GLOW_COLOR_KINESIS
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_KINESIS

	invocation_type = INVOCATION_SHOUT
	invocations = list("Impello!")

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	cooldown_time = 30 SECONDS
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	damage = 60
	strike_damage_type = BRUTE
	blade_class = BCLASS_BLUNT
	npc_simple_damage_mult = 1.5
	committed_strike = TRUE
	interruptible = FALSE
	lock_direction = FALSE
	charging_slowdown = CHARGING_SLOWDOWN_SMALL
	windup_time = 2 SECONDS
	sweep_step = 0
	vuln_on_hit = 2 SECONDS
	telegraph_type = /obj/effect/temp_visual/trap/kinesis
	strike_sound = 'sound/magic/repulse.ogg'
	detonate_sound = 'sound/magic/gravity.ogg'

	var/push_dist = 3

/datum/action/cooldown/spell/telegraphed_strike/kinetic_burst/get_pattern_offsets()
	var/list/offsets = list()
	for(var/x in -2 to 2)
		for(var/y in -2 to 2)
			if(!x && !y)
				continue
			offsets += list(list(x, y))
	return offsets

/datum/action/cooldown/spell/telegraphed_strike/kinetic_burst/get_sweep_bands()
	return list(get_pattern_offsets())

/datum/action/cooldown/spell/telegraphed_strike/kinetic_burst/on_impact(mob/living/carbon/human/H, facing, atom/movable/visual)
	var/turf/origin = get_turf(H)
	if(!origin)
		return
	for(var/list/off in get_pattern_offsets())
		var/turf/T = locate(origin.x + off[1], origin.y + off[2], origin.z)
		if(!T || T.density)
			continue
		new /obj/effect/temp_visual/kinetic_blast(T)

/datum/action/cooldown/spell/telegraphed_strike/kinetic_burst/on_hit_target(mob/living/carbon/human/H, mob/living/L, facing)
	var/push_dir = get_dir(H, L)
	if(!push_dir)
		return
	L.safe_throw_at(get_ranged_target_turf(L, push_dir, push_dist), push_dist, 2, H, force = MOVE_FORCE_STRONG)

/obj/effect/temp_visual/trap/kinesis
	color = GLOW_COLOR_KINESIS
	light_color = GLOW_COLOR_KINESIS
	duration = 3 SECONDS

/obj/effect/temp_visual/trap/kinesis/Initialize(mapload)
	. = ..()
	var/target_alpha = alpha
	alpha = 0
	animate(src, alpha = target_alpha, time = 4)
