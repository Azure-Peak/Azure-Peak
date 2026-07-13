/datum/action/cooldown/spell/arcyne_burst
	button_icon = 'icons/mob/actions/mage_telomancy.dmi'
	name = "Arcyne Burst"
	desc = "Mark a nearby area with arcyne force. It swells for a few seconds before bursting, striking everyone across the whole zone with a wave of kinetic force and hurling them outward."
	button_icon_state = "seeker_volley"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_TELOMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Erumpe!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	displayed_damage = 75

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/blast_radius = 1
	var/blast_delay = 2 SECONDS
	var/blast_damage = 75
	var/push_dist = 3

/datum/action/cooldown/spell/arcyne_burst/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE

	if(!(center in get_hear(cast_range, get_turf(H))))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	for(var/turf/T in range(blast_radius, center))
		if(T.density)
			continue
		new /obj/effect/temp_visual/pillar_warning/fadein(T, blast_delay)

	playsound(center, 'sound/magic/charging.ogg', 60, TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(arcyne_burst_erupt), center, H, blast_radius, blast_damage, push_dist, src, name), blast_delay)

	return TRUE

/proc/arcyne_burst_erupt(turf/epicenter, mob/living/carbon/human/caster, radius = 1, damage = 50, push_dist = 3, datum/action/cooldown/spell/guard_source, spell_name = "Arcyne Burst")
	if(!epicenter)
		return
	playsound(epicenter, 'sound/magic/repulse.ogg', 90, TRUE, 4)
	var/static/list/random_zones = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	for(var/turf/T in range(radius, epicenter))
		if(!(T in get_hear(radius, epicenter)))
			continue
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/mob/living/L in T.contents)
			if(L.anti_magic_check())
				L.visible_message(span_warning("The arcyne force dissipates around [L]!"))
				playsound(T, 'sound/magic/magic_nulled.ogg', 100)
				continue
			if(guard_source && !QDELETED(guard_source) && guard_source.spell_guard_check(L, TRUE))
				L.visible_message(span_warning("[L] braces against the blast!"))
				continue
			if(istype(caster) && !QDELETED(caster) && ishuman(L))
				arcyne_strike(caster, L, null, damage, pick(random_zones), \
					BCLASS_BLUNT, spell_name = spell_name, \
					damage_type = BRUTE, npc_simple_damage_mult = 1, \
					skip_animation = TRUE)
			else
				L.adjustBruteLoss(damage * 1.5)
			var/push_dir = get_dir(epicenter, L) || pick(GLOB.cardinals)
			L.safe_throw_at(get_ranged_target_turf(L, push_dir, push_dist), push_dist, 1, caster, force = MOVE_FORCE_STRONG)
			new /obj/effect/temp_visual/spell_impact(get_turf(L), GLOW_COLOR_ARCANE, SPELL_IMPACT_MEDIUM)
