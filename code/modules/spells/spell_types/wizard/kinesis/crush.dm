/datum/action/cooldown/spell/crush
	button_icon = 'icons/mob/actions/mage_kinesis.dmi'
	name = "Crush"
	desc = "Compress gravitational force onto a single point, crushing the aimed body part. It is telegraphed and can be walked out of. \
	Crushes through armor with exceptional force. Slows struck targets briefly. \
	Deals 100% more damage to simple-minded creechurs."
	button_icon_state = "crush"
	sound = 'sound/magic/repulse.ogg'
	spell_color = GLOW_COLOR_KINESIS
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_KINESIS

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Conterere!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MINOR
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 8 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_HIGH
	displayed_damage = 60

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/telegraph_delay = TELEGRAPH_SKILLSHOT
	var/crush_damage = 60
	var/npc_simple_damage_mult = 2
	var/crush_intdamage_factor = 2

/datum/action/cooldown/spell/crush/cast(atom/cast_on)
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

	new /obj/effect/temp_visual/kinetic_blast(T)
	playsound(T, 'sound/magic/gravity.ogg', 60, TRUE, soundping = FALSE)
	addtimer(CALLBACK(src, PROC_REF(crush_strike), T, H), telegraph_delay)
	return TRUE

/datum/action/cooldown/spell/crush/proc/crush_strike(turf/T, mob/living/carbon/human/caster)
	new /obj/effect/temp_visual/gravity(T)
	playsound(T, 'sound/magic/repulse.ogg', 100, TRUE, soundping = FALSE)
	for(var/mob/living/L in T.contents)
		if(L.anti_magic_check())
			L.visible_message(span_warning("The gravity fades away around [L]!"))
			playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(spell_guard_check(L, TRUE))
			L.visible_message(span_warning("[L] stands firm against the crushing force!"))
			continue

		var/target_zone = caster?.zone_selected || pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST)
		arcyne_strike(caster, L, null, crush_damage, target_zone, BCLASS_BLUNT, \
			spell_name = "Crushing Force", damage_type = BRUTE, \
			npc_simple_damage_mult = npc_simple_damage_mult, skip_animation = TRUE, \
			intdamage_factor = crush_intdamage_factor)
		L.Slowdown(1)
		to_chat(L, span_userdanger("Gravitational force compresses around me!"))
		new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)
