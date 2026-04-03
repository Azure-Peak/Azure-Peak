#define GTSTRIKE_CENTER_DAMAGE 80
#define GTSTRIKE_OUTER_DAMAGE 80
#define GTSTRIKE_TELEGRAPH 16

/datum/action/cooldown/spell/greater_thunderstrike
	button_icon = 'icons/mob/actions/mage_fulgurmancy.dmi'
	name = "Greater Thunderstrike"
	desc = "PLACEHOLDER MASTERY SPELL - may be replaced later.\n\n\
	Call a massive lightning strike that engulfs the entire area at once. \
	Damage falls off with distance from the center."
	button_icon_state = "thunderstrike"
	sound = 'sound/magic/lightning.ogg'
	spell_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_FULGURMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE

	invocations = list("Caelum Fulmine Immane!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/aoe_range = 3

/datum/action/cooldown/spell/greater_thunderstrike/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/centerpoint = get_turf(cast_on)
	if(!centerpoint)
		return FALSE

	var/turf/source_turf = get_turf(H)
	if(centerpoint.z > H.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(centerpoint.z < H.z)
		source_turf = get_step_multiz(source_turf, DOWN)
	if(!(centerpoint in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	// Telegraph on all tiles simultaneously
	for(var/turf/T in range(aoe_range, centerpoint))
		if(!(T in get_hear(aoe_range, centerpoint)))
			continue
		new /obj/effect/temp_visual/trap/thunderstrike(T, GTSTRIKE_TELEGRAPH)

	H.visible_message(span_boldwarning("[H] calls down a massive storm of lightning!"))
	playsound(centerpoint, 'sound/magic/charging.ogg', 80, TRUE, 6)
	addtimer(CALLBACK(src, PROC_REF(strike_all), centerpoint), GTSTRIKE_TELEGRAPH)
	return TRUE

/datum/action/cooldown/spell/greater_thunderstrike/proc/strike_all(turf/centerpoint)
	if(QDELETED(src) || QDELETED(owner))
		return
	var/mob/living/carbon/human/caster = owner
	var/static/list/random_zones = list(BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	playsound(centerpoint, 'sound/magic/lightning.ogg', 100, TRUE, 8)
	for(var/turf/T in range(aoe_range, centerpoint))
		if(!(T in get_hear(aoe_range, centerpoint)))
			continue
		var/dist = get_dist(centerpoint, T)
		var/stage_damage = dist <= 0 ? GTSTRIKE_CENTER_DAMAGE : GTSTRIKE_OUTER_DAMAGE
		new /obj/effect/temp_visual/thunderstrike_actual(T)
		for(var/mob/living/L in T.contents)
			if(L == owner)
				continue
			if(L.anti_magic_check())
				L.visible_message(span_warning("The lightning fades away around [L]!"))
				playsound(T, 'sound/magic/magic_nulled.ogg', 100)
				continue
			if(spell_guard_check(L, TRUE))
				L.visible_message(span_warning("[L] weathers the lightning strike!"))
				continue
			if(istype(caster) && ishuman(L))
				arcyne_strike(caster, L, null, stage_damage, pick(random_zones), \
					BCLASS_BURN, spell_name = "Greater Thunderstrike", \
					damage_type = BURN, npc_simple_damage_mult = 1, \
					skip_animation = TRUE)
			else
				L.electrocute_act(stage_damage, src, 1, SHOCK_NOSTUN)
			L.electrocute_act(0, src, 1, SHOCK_NOSTUN|SHOCK_VISUAL_ONLY)
			new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)

#undef GTSTRIKE_CENTER_DAMAGE
#undef GTSTRIKE_OUTER_DAMAGE
#undef GTSTRIKE_TELEGRAPH
