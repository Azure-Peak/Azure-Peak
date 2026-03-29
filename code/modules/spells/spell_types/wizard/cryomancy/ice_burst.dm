// Ice Burst — Cryomancy's Fireball equivalent
// Charged projectile that explodes in a 3x3 radius on impact, dealing flat damage and applying frost stacks

/datum/action/cooldown/spell/projectile/ice_burst
	button_icon = 'icons/mob/actions/mage_cryomancy.dmi'
	name = "Ice Burst"
	desc = "Launch a burst of frozen energy that shatters on impact, freezing and burning all nearby targets in a small area. \
	Applies one stack of frost to all targets in the blast radius. \
	Toggle arc mode (Ctrl+G) while the spell is active to fire it over intervening mobs. Arced attacks deal 25% less damage."
	button_icon_state = "ice_burst"
	sound = 'sound/spellbooks/crystal.ogg'
	spell_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_CRYOMANCY

	projectile_type = /obj/projectile/magic/ice_burst
	projectile_type_arc = /obj/projectile/magic/ice_burst/arc
	cast_range = SPELL_RANGE_PROJECTILE
	point_cost = 6
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Glacies Frangor!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 16 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/obj/projectile/magic/ice_burst
	name = "ice burst"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "wipe"
	speed = MAGE_PROJ_VERY_SLOW
	damage = 55
	damage_type = BURN
	woundclass = BCLASS_BURN
	npc_simple_damage_mult = 2.5
	accuracy = 40
	nodamage = FALSE
	flag = "fire"
	hitsound = 'sound/blank.ogg'
	/// Radius for AOE blast around impact point
	var/aoe_radius = 1
	/// AOE damage as a fraction of the projectile's base damage
	var/aoe_damage_ratio = 0.66

/obj/projectile/magic/ice_burst/arc
	name = "arced ice burst"
	damage = 41
	arcshot = TRUE

/obj/projectile/magic/ice_burst/on_hit(target)
	..()
	var/mob/living/M = ismob(target) ? target : null

	if(M?.anti_magic_check())
		visible_message(span_warning("[src] fizzles on contact with \the [target]!"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		qdel(src)
		return BULLET_ACT_BLOCK

	var/aoe_damage = round(damage * aoe_damage_ratio)
	var/turf/epicenter = get_turf(target)

	if(epicenter)
		playsound(epicenter, 'sound/spellbooks/crystal.ogg', 100, TRUE, 6)
		playsound(epicenter, pick('sound/combat/fracture/fracturedry (1).ogg', 'sound/combat/fracture/fracturedry (2).ogg', 'sound/combat/fracture/fracturedry (3).ogg'), 80, TRUE)

	if(aoe_radius > 0 && istype(firer, /mob/living/carbon/human))
		var/mob/living/carbon/human/caster = firer
		var/mob/living/direct_hit = M
		for(var/turf/T in range(aoe_radius, epicenter))
			new /obj/effect/temp_visual/snap_freeze(T)
			for(var/mob/living/L in T)
				if(L == direct_hit || L.stat == DEAD)
					continue
				if(L.anti_magic_check())
					continue
				arcyne_strike(caster, L, null, aoe_damage, BODY_ZONE_CHEST, \
					BCLASS_BURN, spell_name = "Ice Burst (Shatter)", \
					allow_shield_check = TRUE, damage_type = BURN, \
					npc_simple_damage_mult = npc_simple_damage_mult, \
					skip_animation = TRUE)
				apply_frost_stack(L)
				new /obj/effect/temp_visual/spell_impact(get_turf(L), GLOW_COLOR_ICE, SPELL_IMPACT_MEDIUM)

	// Apply frost to direct hit target (AOE loop skips them)
	if(isliving(target))
		var/mob/living/L = target
		if(L.on_fire)
			L.adjust_fire_stacks(-1)
			L.visible_message(span_warning("The frost dampens the flames on [L]!"))
		apply_frost_stack(L)

	qdel(src)
	return TRUE
