// New spell system
/datum/action/cooldown/spell/projectile/fireball
	name = "Fireball"
	desc = "Shoot out a ball of fire that explodes on impact, scorching nearby targets and knocking them back. \
	Toggle arc mode (Ctrl+G) while the spell is active to fire it over intervening mobs. Arced attacks deal 25% less damage."
	button_icon_state = "fireball"
	sound = 'sound/magic/fireball.ogg'
	spell_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_HIGH

	projectile_type = /obj/projectile/magic/aoe/fireball/rogue
	projectile_type_arc = /obj/projectile/magic/aoe/fireball/rogue/arc
	cast_range = 8
	point_cost = 6

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Sphaera Ignis!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 1.5 SECONDS
	charge_drain = 1
	charge_slowdown = 3
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 16 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3

/obj/projectile/magic/aoe/fireball/rogue
	name = "fireball"
	exp_heavy = -1
	exp_light = -1
	exp_flash = 0
	exp_fire = 0
	damage = 60
	damage_type = BURN
	npc_simple_damage_mult = 3 // Intentionally higher than other fireballs due to arcyne mark disparity
	accuracy = 40 // Lower base — burn bypasses armor
	nodamage = FALSE
	flag = "fire"
	hitsound = 'sound/blank.ogg'
	aoe_range = 0
	/// Radius for AOE arcyne_strike blast around impact point. 0 = no AOE.
	var/arcyne_aoe_radius = 1
	/// AOE damage as a fraction of the projectile's base damage.
	var/arcyne_aoe_damage_ratio = 0.66
	/// Structural damage dealt to structures/walls in AOE radius. 0 = none.
	var/structural_damage = 50
	/// Radius for structural damage. Uses arcyne_aoe_radius if not set.
	var/structural_damage_radius = 0

/obj/projectile/magic/aoe/fireball/rogue/arc
	name = "Arced Fireball"
	damage = 45 // 25% damage penalty
	arcshot = TRUE

/obj/projectile/magic/aoe/fireball/rogue/on_hit(target)
	..()
	var/mob/living/M = ismob(target) ? target : null

	if(M?.anti_magic_check())
		visible_message(span_warning("[src] fizzles on contact with [target]!"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		qdel(src)
		return BULLET_ACT_BLOCK

	var/aoe_damage = round(damage * arcyne_aoe_damage_ratio)

	var/turf/epicenter = get_turf(target)

	if(epicenter)
		new /obj/effect/temp_visual/explosion(epicenter)
		playsound(epicenter, pick('sound/misc/explode/bomb.ogg', 'sound/misc/explode/explosionclose (1).ogg', 'sound/misc/explode/explosionclose (2).ogg', 'sound/misc/explode/explosionclose (3).ogg'), 120, TRUE, 8)
		playsound(epicenter, pick('sound/misc/explode/incendiary (1).ogg', 'sound/misc/explode/incendiary (2).ogg'), 100, TRUE, 4)

	if(arcyne_aoe_radius > 0 && istype(firer, /mob/living/carbon/human))
		var/mob/living/carbon/human/caster = firer
		var/mob/living/direct_hit = M
		for(var/turf/T in range(arcyne_aoe_radius, epicenter))
			new /obj/effect/temp_visual/fire(T)
			for(var/mob/living/L in T)
				if(L == direct_hit || L.stat == DEAD)
					continue
				if(L.anti_magic_check())
					continue
				arcyne_strike(caster, L, null, aoe_damage, BODY_ZONE_CHEST, \
					BCLASS_BURN, spell_name = "Fireball (Blast)", \
					allow_shield_check = TRUE, damage_type = BURN, \
					npc_simple_damage_mult = npc_simple_damage_mult, \
					skip_animation = TRUE)
				L.adjust_fire_stacks(1)
				L.ignite_mob()
			for(var/atom/movable/AM in T)
				if(AM.anchored || AM == src)
					continue
				var/throw_dir = get_dir(epicenter, AM)
				if(!throw_dir)
					throw_dir = pick(GLOB.cardinals)
				var/turf/throw_target = get_ranged_target_turf(AM, throw_dir, 1)
				if(throw_target)
					AM.safe_throw_at(throw_target, 1, 1, firer, spin = FALSE)

	if(arcyne_aoe_radius > 0)
		var/struct_radius = structural_damage_radius ? structural_damage_radius : arcyne_aoe_radius
		for(var/turf/T in range(struct_radius, epicenter))
			T.fire_act()
			for(var/atom/A in T)
				if(ismob(A))
					continue
				A.fire_act()
		if(structural_damage > 0)
			for(var/obj/structure/damaged in view(struct_radius, epicenter))
				if(!istype(damaged, /obj/structure/flora/newbranch))
					damaged.take_damage(structural_damage, BRUTE, "blunt", 1)
			for(var/turf/closed/wall/damagedwalls in view(struct_radius, epicenter))
				damagedwalls.take_damage(structural_damage, BRUTE, "blunt", 1)

	return TRUE
