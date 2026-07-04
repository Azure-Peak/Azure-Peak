/datum/action/cooldown/spell/gravity
	button_icon = 'icons/mob/actions/mage_kinesis.dmi'
	name = "Gravity"
	desc = "Weighten space around someone, crushing them and knocking them to the floor. Stronger opponents will resist and be off-balanced. Target can adapt to gravity for 15 seconds after being knocked down, making them stand firm against conseuctive hit.\n\n\
	Deals 100% more damage to simple-minded creechurs."
	button_icon_state = "gravity"
	sound = 'sound/magic/gravity.ogg'
	spell_color = GLOW_COLOR_KINESIS
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_KINESIS

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SINGLE_CC

	invocations = list("Pondus!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	displayed_damage = 60

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// Ticks of warning before the crush lands
	var/telegraph_delay = TELEGRAPH_SKILLSHOT
	/// Damage dealt to targets whose STR is at or below the threshold
	var/crush_damage = 60
	/// Damage dealt to targets who resist via STR
	var/resisted_damage = 15
	/// Knockdown duration (in ticks) for targets who don't resist
	var/knockdown_time = 5
	/// Off-balance duration (in ticks) for targets who resist
	var/offbalance_time = 10
	/// STR threshold — at or below this, full knockdown. Above, off-balanced only
	var/str_threshold = 15
	var/simple_npc_damage_modifier = 2

/datum/action/cooldown/spell/gravity/cast(atom/cast_on)
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

	new /obj/effect/temp_visual/gravity_trap(T)
	playsound(T, 'sound/magic/gravity.ogg', 80, TRUE, soundping = FALSE)
	addtimer(CALLBACK(src, PROC_REF(gravity_crush), T), telegraph_delay)
	return TRUE

/datum/action/cooldown/spell/gravity/proc/gravity_crush(turf/T)
	new /obj/effect/temp_visual/gravity(T)
	for(var/mob/living/L in T.contents)
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
				spell_name = "Gravity", damage_type = BRUTE, \
				npc_simple_damage_mult = simple_npc_damage_modifier, skip_animation = TRUE)
			if(!adapted)
				L.Knockdown(knockdown_time)
				L.mob_timers[MT_GRAVITY_ADAPTATION] = world.time
				to_chat(L, span_userdanger("I'm magically weighed down, losing my footing!"))
			else
				to_chat(L, span_userdanger("The gravity crushes me, but I keep my footing!"))
		else
			arcyne_strike(owner, L, null, resisted_damage, target_zone, BCLASS_BLUNT, \
				spell_name = "Gravity", damage_type = BRUTE, \
				npc_simple_damage_mult = simple_npc_damage_modifier, skip_animation = TRUE)
			if(!adapted)
				L.OffBalance(offbalance_time)
				L.mob_timers[MT_GRAVITY_ADAPTATION] = world.time
				to_chat(L, span_userdanger("I'm magically weighed down, but my strength resist!"))
			else
				to_chat(L, span_userdanger("The gravity crushes me, but I keep my footing!"))
		new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)

/obj/effect/temp_visual/gravity
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_squares"
	name = "gravity magic"
	desc = "Get out of the way!"
	randomdir = FALSE
	duration = 3 SECONDS
	layer = MASSIVE_OBJ_LAYER
	light_outer_range = 2
	light_color = GLOW_COLOR_KINESIS

/obj/effect/temp_visual/gravity_trap
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_blast"
	dir = NORTH
	name = "rippling arcyne energy"
	desc = "Get out of the way!"
	randomdir = FALSE
	duration = 5 SECONDS
	layer = MASSIVE_OBJ_LAYER
