/datum/action/cooldown/spell/mass_gravity
	button_icon = 'icons/mob/actions/mage_kinesis.dmi'
	name = "Mass Gravity"
	desc = "Weighten space in an entire area, crushing everyone within and bringing them to the ground. \
	Stronger opponents will resist and merely be off-balanced. \
	The spell takes longer to materialize than its single-target counterpart, but covers a much larger zone.\n\n\
	Target can adapt to gravity for 15 seconds after being knocked down, making them stand firm against conseuctive hit.\n\n\
	Deals 100% more damage to simple-minded creechurs."
	button_icon_state = "mass_gravity"
	sound = 'sound/magic/gravity.ogg'
	spell_color = GLOW_COLOR_KINESIS
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_KINESIS

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Pondus Immane!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 25 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	// Less damage than single target
	var/crush_damage = 40
	var/resisted_damage = 10
	var/knockdown_time = 5
	var/offbalance_time = 10
	var/str_threshold = 15
	var/simple_npc_damage_modifier = 2
	var/aoe_range = 1 // 3x3
	var/telegraph_delay = TELEGRAPH_HIGH_IMPACT

/datum/action/cooldown/spell/mass_gravity/cast(atom/cast_on)
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
	addtimer(CALLBACK(src, PROC_REF(mass_crush), centerpoint), telegraph_delay)
	return TRUE

/datum/action/cooldown/spell/mass_gravity/proc/mass_crush(turf/centerpoint)
	if(QDELETED(src) || QDELETED(owner))
		return
	for(var/turf/T in range(aoe_range, centerpoint))
		new /obj/effect/temp_visual/gravity(T)
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
			var/target_zone = pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST)
			// Gravity Adaptation: CC gated behind adaptation timer, damage always applies
			var/adapted = L.mob_timers[MT_GRAVITY_ADAPTATION] && world.time < L.mob_timers[MT_GRAVITY_ADAPTATION] + GRAVITY_ADAPTATION_COOLDOWN
			if(adapted)
				var/remaining = round((L.mob_timers[MT_GRAVITY_ADAPTATION] + GRAVITY_ADAPTATION_COOLDOWN - world.time) / 10)
				L.balloon_alert_to_viewers("<font color='#7B68EE'>gravity adapted ([remaining]s)!</font>")
			if(L.STASTR <= str_threshold)
				arcyne_strike(owner, L, null, crush_damage, target_zone, BCLASS_BLUNT, \
					spell_name = "Mass Gravity", damage_type = BRUTE, \
					npc_simple_damage_mult = simple_npc_damage_modifier, skip_animation = TRUE)
				if(!adapted)
					L.Knockdown(knockdown_time)
					L.mob_timers[MT_GRAVITY_ADAPTATION] = world.time
					to_chat(L, span_userdanger("The immense gravity crushes me to the ground!"))
				else
					to_chat(L, span_userdanger("The gravity crushes me, but I keep my footing!"))
			else
				arcyne_strike(owner, L, null, resisted_damage, target_zone, BCLASS_BLUNT, \
					spell_name = "Mass Gravity", damage_type = BRUTE, \
					npc_simple_damage_mult = 1, skip_animation = TRUE)
				if(!adapted)
					L.OffBalance(offbalance_time)
					L.mob_timers[MT_GRAVITY_ADAPTATION] = world.time
					to_chat(L, span_userdanger("The gravity weighs on me, but my strength prevails!"))
				else
					to_chat(L, span_userdanger("The gravity crushes me, but I keep my footing!"))
			new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)
