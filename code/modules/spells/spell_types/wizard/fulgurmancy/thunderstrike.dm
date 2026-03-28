#define TSTRIKE_STAGE1_DAMAGE 80
#define TSTRIKE_STAGE2_DAMAGE 40
#define TSTRIKE_STAGE3_DAMAGE 30
#define TSTRIKE_STAGE1_DELAY 8
#define TSTRIKE_STAGE2_DELAY 12
#define TSTRIKE_STAGE3_DELAY 16

/datum/action/cooldown/spell/thunderstrike
	button_icon = 'icons/mob/actions/mage_fulgurmancy.dmi'
	name = "Thunderstrike"
	desc = "Call a high-damage strike of lightning onto an area, followed by lesser aftershocks that ripple outwards in concentric layers."
	button_icon_state = "thunderstrike"
	sound = 'sound/magic/lightning.ogg'
	spell_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_FULGURMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Feri Fulmine Hostem!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

/datum/action/cooldown/spell/thunderstrike/cast(atom/cast_on)
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

	// Stage 1: Center tile
	new /obj/effect/temp_visual/trap/thunderstrike(centerpoint)
	addtimer(CALLBACK(src, PROC_REF(thunderstrike_damage), centerpoint, TSTRIKE_STAGE1_DAMAGE), TSTRIKE_STAGE1_DELAY)

	// Stage 2: First concentric layer (1 tile out)
	for(var/turf/T in range(1, centerpoint))
		if(!(T in get_hear(1, centerpoint)))
			continue
		if(get_dist(centerpoint, T) != 1)
			continue
		new /obj/effect/temp_visual/trap/thunderstrike/layer_one(T)
		addtimer(CALLBACK(src, PROC_REF(thunderstrike_damage), T, TSTRIKE_STAGE2_DAMAGE), TSTRIKE_STAGE2_DELAY)

	// Stage 3: Second concentric layer (2 tiles out)
	for(var/turf/T in range(2, centerpoint))
		if(!(T in get_hear(2, centerpoint)))
			continue
		if(get_dist(centerpoint, T) != 2)
			continue
		new /obj/effect/temp_visual/trap/thunderstrike/layer_two(T)
		addtimer(CALLBACK(src, PROC_REF(thunderstrike_damage), T, TSTRIKE_STAGE3_DAMAGE), TSTRIKE_STAGE3_DELAY)
	return TRUE

/datum/action/cooldown/spell/thunderstrike/proc/thunderstrike_damage(turf/effect_layer, stage_damage)
	new /obj/effect/temp_visual/thunderstrike_actual(effect_layer)
	playsound(effect_layer, 'sound/magic/lightning.ogg', 50)
	var/mob/living/carbon/human/caster = owner
	var/static/list/random_zones = list(BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	for(var/mob/living/L in effect_layer.contents)
		if(L.anti_magic_check())
			L.visible_message(span_warning("The lightning fades away around [L]!"))
			playsound(effect_layer, 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(spell_guard_check(L, TRUE))
			L.visible_message(span_warning("[L] weathers the lightning strike!"))
			continue
		if(istype(caster) && ishuman(L))
			arcyne_strike(caster, L, null, stage_damage, pick(random_zones), \
				BCLASS_BURN, spell_name = "Thunderstrike", \
				damage_type = BURN, npc_simple_damage_mult = 1, \
				skip_animation = TRUE)
		else
			L.electrocute_act(stage_damage, src, 1, SHOCK_NOSTUN)
		L.electrocute_act(0, src, 1, SHOCK_NOSTUN|SHOCK_VISUAL_ONLY)
		new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)

#undef TSTRIKE_STAGE1_DAMAGE
#undef TSTRIKE_STAGE2_DAMAGE
#undef TSTRIKE_STAGE3_DAMAGE
#undef TSTRIKE_STAGE1_DELAY
#undef TSTRIKE_STAGE2_DELAY
#undef TSTRIKE_STAGE3_DELAY
