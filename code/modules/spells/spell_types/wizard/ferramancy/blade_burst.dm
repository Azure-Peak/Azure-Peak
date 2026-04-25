
/datum/action/cooldown/spell/blade_burst
	button_icon = 'icons/mob/actions/mage_ferramancy.dmi'
	name = "Blade Burst"
	desc = "Summon a storm of arcyne blades erupting from the ground in an area. After a short delay, the blades burst upward and cut anything still standing in the zone. \
	Targets your aimed zone, with reduced accuracy for precise zones. \
	Damage is increased by 100% versus simple-minded creechurs."
	button_icon_state = "blade_burst"
	sound = 'sound/magic/blade_burst.ogg'
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_FERRAMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Erumpere Gladios!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MINOR
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 12 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	displayed_damage = 65

	var/delay = TELEGRAPH_HIGH_IMPACT
	var/damage = 65
	var/npc_simple_damage_mult = 2
	var/area_of_effect = 1

/datum/action/cooldown/spell/blade_burst/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/T = get_turf(cast_on)

	var/turf/source_turf = get_turf(H)
	if(T.z > H.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(T.z < H.z)
		source_turf = get_step_multiz(source_turf, DOWN)

	if(!(T in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		if(!(affected_turf in get_hear(cast_range, source_turf)))
			continue
		new /obj/effect/temp_visual/trap/ferramancy(affected_turf)
	playsound(T, 'sound/magic/blade_burst.ogg', 80, TRUE, soundping = TRUE)

	addtimer(CALLBACK(src, PROC_REF(blade_burst_detonate), T, source_turf, H), delay)
	return TRUE

/datum/action/cooldown/spell/blade_burst/proc/blade_burst_detonate(turf/T, turf/source_turf, mob/living/carbon/human/caster)
	var/play_cleave = FALSE

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		if(!(affected_turf in get_hear(cast_range, source_turf)))
			continue
		new /obj/effect/temp_visual/blade_burst(affected_turf)
		for(var/mob/living/L in affected_turf.contents)
			if(L.anti_magic_check())
				L.visible_message(span_warning("The blades dispel when they near [L]!"))
				playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
				continue
			if(spell_guard_check(L, TRUE))
				L.visible_message(span_warning("[L] steps out of the way of the blades!"))
				continue
			play_cleave = TRUE
			var/total_damage = damage
			if(ishuman(caster) && ishuman(L))
				var/target_zone = caster.zone_selected || BODY_ZONE_CHEST
				arcyne_strike(caster, L, null, total_damage, target_zone, \
					BCLASS_CUT, spell_name = "Blade Burst", \
					damage_type = BRUTE, npc_simple_damage_mult = npc_simple_damage_mult, \
					skip_animation = TRUE)
			else
				var/actual_damage = total_damage
				if(!L.mind && !ishuman(L))
					actual_damage *= npc_simple_damage_mult
				L.adjustBruteLoss(actual_damage)
			playsound(affected_turf, "genslash", 80, TRUE)
			to_chat(L, span_userdanger("You're cut by arcyne force!"))
			new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)

	if(play_cleave)
		playsound(T, 'sound/combat/newstuck.ogg', 80, TRUE, soundping = TRUE)

/obj/effect/temp_visual/trap
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	duration = 12
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/trap/ferramancy
	color = GLOW_COLOR_METAL
	light_color = GLOW_COLOR_METAL

/obj/effect/temp_visual/blade_burst
	icon = 'icons/effects/wizard_spell_effects.dmi'
	icon_state = "grassblade"
	dir = NORTH
	name = "arcyne blade"
	desc = "Get out of the way!"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER
