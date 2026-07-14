/obj/structure/earthen_wall
	name = "earthen wall"
	desc = "A wall of conjured stone. It will crumble in time."
	icon = 'icons/obj/flora/rocks.dmi'
	icon_state = "basalt1"
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	density = TRUE
	opacity = TRUE
	max_integrity = 300
	var/timeleft = 10 SECONDS

/obj/structure/earthen_wall/Initialize()
	. = ..()
	if(timeleft)
		QDEL_IN(src, timeleft)

#define MT_ROCKSHOT "rockshot"
#define ROCKSHOT_DR_DURATION 1 SECONDS

/obj/projectile/magic/gravel_blast
	name = "gravel shot"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "stone"
	damage = 26
	nodamage = FALSE
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	range = SPELL_RANGE_PROJECTILE
	speed = MAGE_PROJ_SLOW
	accuracy = 50
	guard_deflectable = TRUE
	npc_simple_damage_mult = 1.5
	intdamfactor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	object_damage_multiplier = 2
	hitsound = 'sound/combat/hits/onstone/wallhit.ogg'
	ricochets_max = 2
	ricochet_chance = 80
	ricochet_auto_aim_angle = 40
	ricochet_auto_aim_range = 5
	ricochet_incidence_leeway = 40
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1
	var/reduced_damage = 11

/obj/projectile/magic/gravel_blast/arc
	name = "arced gravel shot"
	damage = 20
	arcshot = TRUE

/obj/projectile/magic/gravel_blast/prehit(atom/target)
	if(ismob(target))
		var/mob/living/M = target
		if(M == firer)
			damage = round(damage / 2)
		else if(M.mob_timers[MT_ROCKSHOT] && world.time < M.mob_timers[MT_ROCKSHOT] + ROCKSHOT_DR_DURATION)
			damage = reduced_damage
		else
			M.mob_timers[MT_ROCKSHOT] = world.time
	return ..()

/obj/projectile/magic/gravel_blast/on_hit(target)
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] shatters harmlessly against [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()

#undef MT_ROCKSHOT
#undef ROCKSHOT_DR_DURATION

/obj/effect/temp_visual/trap/geomancy
	color = GLOW_COLOR_EARTHEN
	light_color = GLOW_COLOR_EARTHEN
	duration = 4 SECONDS

/obj/structure/earthen_pillar
	name = "stone pillar"
	desc = "A pillar of conjured stone. Sturdy, but not indestructible. Shatters into gravel when destroyed."
	icon = 'icons/obj/flora/rocks.dmi'
	icon_state = "basalt1"
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	density = TRUE
	opacity = TRUE
	max_integrity = 150
	anchored = TRUE
	var/datum/weakref/caster_ref
	var/fragment_count = 3
	var/fragment_damage = 15

/obj/structure/earthen_pillar/Destroy()
	caster_ref = null
	return ..()

/obj/structure/earthen_pillar/obj_break()
	shatter_fragments()
	return ..()

/obj/structure/earthen_pillar/proc/shatter_fragments()
	var/turf/T = get_turf(src)
	if(!T)
		return
	var/mob/caster = caster_ref?.resolve()
	var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
	for(var/i in 1 to fragment_count)
		var/dir = pick_n_take(dirs)
		var/turf/target = get_ranged_target_turf(T, dir, 3)
		var/obj/projectile/magic/gravel_blast/frag = new(T)
		frag.damage = fragment_damage
		frag.ricochets_max = 0
		if(caster)
			frag.firer = caster
		frag.preparePixelProjectile(target, T)
		frag.fire()
