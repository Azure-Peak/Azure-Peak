/datum/action/cooldown/spell/mass_crush
	button_icon = 'icons/mob/actions/mage_kinesis.dmi'
	name = "Mass Crush"
	desc = "Compress gravitational force over a wide area, crushing everyone within. \
	The spell is highly telegraphed but devastating to anyone caught inside. \
	Crushes through armor with exceptional force. Slows struck targets briefly. \
	Deals 100% more damage to simple-minded creechurs."
	button_icon_state = "crush"
	sound = 'sound/magic/repulse.ogg'
	spell_color = GLOW_COLOR_KINESIS
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_KINESIS

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE

	invocations = list("Conterere Omnia!")
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

	var/telegraph_delay = TELEGRAPH_HIGH_IMPACT
	var/crush_damage = 60
	var/npc_simple_damage_mult = 2
	var/crush_intdamage_factor = 2
	var/aoe_range = 2 // 5x5

/datum/action/cooldown/spell/mass_crush/cast(atom/cast_on)
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

	for(var/turf/T in range(aoe_range, centerpoint))
		new /obj/effect/temp_visual/gravity_trap(T)

	playsound(centerpoint, 'sound/magic/gravity.ogg', 80, TRUE, soundping = FALSE)
	addtimer(CALLBACK(src, PROC_REF(mass_crush_strike), centerpoint, H), telegraph_delay)
	return TRUE

/datum/action/cooldown/spell/mass_crush/proc/mass_crush_strike(turf/centerpoint, mob/living/carbon/human/caster)
	if(QDELETED(src) || QDELETED(owner))
		return
	for(var/turf/T in range(aoe_range, centerpoint))
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/mob/living/L in T.contents)
			if(L == owner)
				continue
			if(L.anti_magic_check())
				L.visible_message(span_warning("The gravity fades away around [L]!"))
				playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
				continue
			if(spell_guard_check(L, TRUE))
				L.visible_message(span_warning("[L] stands firm against the crushing force!"))
				continue

			var/target_zone = pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			arcyne_strike(caster, L, null, crush_damage, target_zone, BCLASS_BLUNT, \
				spell_name = "Mass Crush", damage_type = BRUTE, \
				npc_simple_damage_mult = npc_simple_damage_mult, skip_animation = TRUE, \
				intdamage_factor = crush_intdamage_factor)
			L.Slowdown(1)
			to_chat(L, span_userdanger("Gravitational force compresses around me!"))
			new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)

	playsound(centerpoint, 'sound/magic/repulse.ogg', 100, TRUE, soundping = FALSE)
