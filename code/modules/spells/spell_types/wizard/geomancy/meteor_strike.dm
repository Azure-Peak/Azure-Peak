#define METEOR_STRIKE_RADIUS 3 // 7x7 area
#define METEOR_SPLASH_RADIUS 1 // 3x3 splash per meteor
#define METEOR_FRAGMENT_COUNT 6
#define METEOR_TELEGRAPH_TIME 3 SECONDS

/datum/action/cooldown/spell/meteor_strike
	button_icon = 'icons/mob/actions/mage_geomancy.dmi'
	name = "Meteor Strike"
	desc = "Call down a devastating barrage of nine boulders onto a wide area. \
	Each boulder deals heavy damage on direct hit, splashes nearby, and sends gravel fragments flying. \
	Deals 2x damage to structures. \
	Extremely telegraphed - only a fool would stand in the impact zone."
	button_icon_state = "boulder_strike"
	sound = 'sound/magic/meteorstorm.ogg'
	spell_color = GLOW_COLOR_EARTHEN
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_GEOMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE

	invocations = list("Caelum Saxum Ruinam!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/direct_damage = 60 // If you get hit direct you deserve it
	var/splash_damage = 25
	var/fragment_damage = 15
	var/npc_simple_damage_mult = 2
	var/impact_count = 12

/datum/action/cooldown/spell/meteor_strike/cast(atom/cast_on)
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

	var/list/valid_turfs = list()
	for(var/turf/T in range(METEOR_STRIKE_RADIUS, centerpoint))
		if(T.density)
			continue
		valid_turfs += T

	if(!length(valid_turfs))
		return FALSE

	var/list/impact_turfs = list()
	for(var/i in 1 to impact_count)
		impact_turfs += pick(valid_turfs)

	centerpoint.visible_message(span_boldwarning("The sky darkens as boulders begin to fall!"))

	// Show telegraph markers on all tiles in the impact zone
	for(var/turf/T in valid_turfs)
		new /obj/effect/temp_visual/trap/meteor(T)

	// Boulders start dropping after the telegraph
	var/delay_offset = METEOR_TELEGRAPH_TIME
	for(var/turf/impact_turf in impact_turfs)
		addtimer(CALLBACK(src, PROC_REF(drop_boulder), impact_turf), delay_offset)
		delay_offset += rand(3, 5)

	return TRUE

/datum/action/cooldown/spell/meteor_strike/proc/drop_boulder(turf/T)
	if(QDELETED(src) || QDELETED(owner))
		return
	// Telegraph + falling boulder visual
	new /obj/effect/temp_visual/falling_boulder(T, CALLBACK(src, PROC_REF(meteor_impact), T))

/datum/action/cooldown/spell/meteor_strike/proc/meteor_impact(turf/T)
	if(QDELETED(src) || QDELETED(owner))
		return
	playsound(T, 'sound/combat/hits/onstone/stonedeath.ogg', 100, TRUE, 6)
	// Structural damage - 2x to objects on impact tile
	for(var/obj/structure/S in T.contents)
		S.take_damage(direct_damage, BRUTE, "blunt", object_damage_multiplier = 2)
	T.take_damage(direct_damage, BRUTE, "blunt", object_damage_multiplier = 2)
	var/mob/living/carbon/human/caster = owner
	var/static/list/random_zones = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	// Direct hit on impact tile
	for(var/mob/living/L in T.contents)
		if(L == owner)
			continue
		if(L.anti_magic_check())
			L.visible_message(span_warning("The boulder fades away around [L]!"))
			playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(spell_guard_check(L, TRUE))
			L.visible_message(span_warning("[L] endures the boulder strike!"))
			continue
		var/actual_damage = direct_damage
		if(!L.mind && !ishuman(L))
			actual_damage *= npc_simple_damage_mult
		if(istype(caster) && ishuman(L))
			arcyne_strike(caster, L, null, actual_damage, pick(random_zones), \
				BCLASS_BLUNT, spell_name = "Meteor Strike", \
				damage_type = BRUTE, npc_simple_damage_mult = 1, \
				skip_animation = TRUE)
		else
			L.adjustBruteLoss(actual_damage)
		L.Knockdown(3)
		new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)
	// Splash damage on adjacent tiles
	for(var/turf/aoe_turf in range(METEOR_SPLASH_RADIUS, T))
		if(aoe_turf == T)
			continue
		for(var/mob/living/L in aoe_turf.contents)
			if(L == owner)
				continue
			if(L.anti_magic_check())
				continue
			if(spell_guard_check(L, TRUE))
				continue
			var/actual_damage = splash_damage
			if(!L.mind && !ishuman(L))
				actual_damage *= npc_simple_damage_mult
			if(istype(caster) && ishuman(L))
				arcyne_strike(caster, L, null, actual_damage, pick(random_zones), \
					BCLASS_BLUNT, spell_name = "Meteor Strike", \
					damage_type = BRUTE, npc_simple_damage_mult = 1, \
					skip_animation = TRUE)
			else
				L.adjustBruteLoss(actual_damage)
	// Spawn gravel fragments
	spawn_fragments(T)

/datum/action/cooldown/spell/meteor_strike/proc/spawn_fragments(turf/T)
	var/list/cardinal_dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
	var/frag_count = min(METEOR_FRAGMENT_COUNT, length(cardinal_dirs))
	var/list/chosen_dirs = list()
	for(var/i in 1 to frag_count)
		var/dir = pick_n_take(cardinal_dirs)
		chosen_dirs += dir
	for(var/dir in chosen_dirs)
		var/turf/target = get_ranged_target_turf(T, dir, 3)
		var/obj/projectile/magic/gravel_blast/frag = new(T)
		frag.damage = fragment_damage
		frag.firer = owner
		frag.preparePixelProjectile(target, T)
		frag.fire()

// Falling boulder visual - uses the boulder projectile sprite
/obj/effect/temp_visual/falling_boulder
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "rock"
	name = "falling boulder"
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
	duration = 9
	pixel_z = 270
	var/datum/callback/on_impact

/obj/effect/temp_visual/falling_boulder/Initialize(mapload, datum/callback/impact_cb)
	. = ..()
	on_impact = impact_cb
	animate(src, pixel_z = 0, time = duration)
	addtimer(CALLBACK(src, PROC_REF(do_impact)), duration)

/obj/effect/temp_visual/falling_boulder/proc/do_impact()
	on_impact?.Invoke()

/obj/effect/temp_visual/trap/meteor
	color = GLOW_COLOR_EARTHEN
	light_color = GLOW_COLOR_EARTHEN
	duration = METEOR_TELEGRAPH_TIME

#undef METEOR_STRIKE_RADIUS
#undef METEOR_SPLASH_RADIUS
#undef METEOR_FRAGMENT_COUNT
#undef METEOR_TELEGRAPH_TIME
