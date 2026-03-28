/datum/action/cooldown/spell/heavens_strike
	button_icon = 'icons/mob/actions/mage_fulgurmancy.dmi'
	name = "Heaven's Strike"
	desc = "Call down a single devastating bolt of lightning on a target location, striking the aimed body part. \
	The strike is telegraphed and can be dodged, but deals massive damage to anything still standing in the impact zone. \
	Damage is increased by 100% versus simple-minded creechurs."
	button_icon_state = "heavens_strike"
	sound = 'sound/magic/lightning.ogg'
	spell_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_FULGURMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Caelum Feri!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 10 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	var/damage = 60
	var/telegraph_tick = TELEGRAPH_SKILLSHOT
	var/npc_simple_damage_mult = 2

/datum/action/cooldown/spell/heavens_strike/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/T = get_turf(cast_on)
	if(!T)
		return FALSE

	var/turf/source_turf = get_turf(H)
	if(T.z > H.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(T.z < H.z)
		source_turf = get_step_multiz(source_turf, DOWN)
	if(!(T in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	new /obj/effect/temp_visual/trap/thunderstrike(T, TELEGRAPH_SKILLSHOT)
	addtimer(CALLBACK(src, PROC_REF(strike_damage), T), TELEGRAPH_SKILLSHOT)
	return TRUE

/datum/action/cooldown/spell/heavens_strike/proc/strike_damage(turf/T)
	new /obj/effect/temp_visual/thunderstrike_actual(T)
	playsound(T, 'sound/magic/lightning.ogg', 80)
	var/mob/living/carbon/human/caster = owner
	var/target_zone = caster?.zone_selected || pick(BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	for(var/mob/living/L in T.contents)
		if(L.anti_magic_check())
			L.visible_message(span_warning("The lightning fades away around [L]!"))
			playsound(T, 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(spell_guard_check(L, TRUE))
			L.visible_message(span_warning("[L] weathers the lightning strike!"))
			continue
		var/actual_damage = damage
		if(!L.mind && !ishuman(L))
			actual_damage *= npc_simple_damage_mult
		// Zone-targeted burn damage via arcyne_strike for limb aiming
		if(istype(caster) && ishuman(L))
			arcyne_strike(caster, L, null, actual_damage, target_zone, \
				BCLASS_BURN, spell_name = "Heaven's Strike", \
				damage_type = BURN, npc_simple_damage_mult = 1, \
				skip_animation = TRUE)
		else
			L.electrocute_act(actual_damage, src, 1, SHOCK_NOSTUN)
		L.electrocute_act(0, src, 1, SHOCK_NOSTUN|SHOCK_VISUAL_ONLY)
		new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)
