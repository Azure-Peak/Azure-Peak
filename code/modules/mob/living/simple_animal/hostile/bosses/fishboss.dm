/mob/living/simple_animal/hostile/boss/fishboss
	name = "Duke of the Deep"
	desc = ""
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	boss_abilities = list(/datum/action/boss/lich_summon_minions)
	faction = list(FACTION_DEEPONE)
	icon = 'icons/roguetown/mob/monster/pufferboss.dmi'
	icon_state = "pufferman"
	wander = 0
	vision_range = 16
	aggro_vision_range = 24
	ranged = 1
	rapid = 4
	rapid_fire_delay = 8
	ranged_message = "spits stones"
	ranged_cooldown_time = 200
	ranged_ignores_vision = TRUE
	environment_smash = 0
	minimum_distance = 2
	retreat_distance = 0
	move_to_delay = 10
	obj_damage = 100
	base_intents = list(/datum/intent/simple/claw/deepone_boss)
	melee_damage_lower = 65
	melee_damage_upper = 90
	health = 4500
	maxHealth = 4500
	STASTR = 18
	STAPER = 15
	STAINT = 12
	STACON = 20
	STAWIL = 20
	STASPD = 15
	STALUC = 14
	projectiletype = /obj/projectile/bullet/reusable/deepone
	projectilesound = 'sound/combat/wooshes/punch/punchwoosh (1).ogg'
	patron = /datum/patron/divine/abyssor
	stat_attack = SOFT_CRIT
	var/minions_to_spawn = 8
	var/next_summon = 0
	var/list/minions = list(
		/mob/living/simple_animal/hostile/rogue/deepone/boss = 40,
		/mob/living/simple_animal/hostile/rogue/deepone/spit/boss = 30,
		/mob/living/simple_animal/hostile/rogue/deepone/arm/boss = 20,
		/mob/living/simple_animal/hostile/rogue/deepone/wiz/boss = 20)
	var/mob_type
	var/mob/new_mob
	var/spawned_mobs = 0	
	loot = list(/obj/item/rogueweapon/mace/goden/deepduke)
//stolen from lich code
/mob/living/simple_animal/hostile/boss/fishboss/handle_automated_action()
	. = ..()
	if(target && next_summon < world.time) //Second summon ability. Spawns a mob of simple skeletons
		spawn_minions(minions_to_spawn)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, say), "Ggglg- ♐︎◆︎♋︎❒︎♑︎'♎︎□︎♓︎♑︎!", null, list("colossus", "yell"))
		next_summon = world.time + 600
		return .

/mob/living/simple_animal/hostile/boss/fishboss/proc/spawn_minions()
	var/spawn_chance = 100
	if (prob(spawn_chance))
		var/turf/spawn_turf
		var/i = 0
		while (i < minions_to_spawn)
			spawn_turf = get_random_valid_turf()
			if (spawn_turf)
				mob_type = pickweight(minions)
				new_mob = new mob_type(spawn_turf)
				if (new_mob)
					spawned_mobs++
			i++

/mob/living/simple_animal/hostile/boss/fishboss/proc/get_random_valid_turf()
	var/list/valid_turfs = list()
	for (var/turf/T in range(6, src))
		if (is_valid_spawn_turf(T))
			valid_turfs += T
	if (valid_turfs.len == 0)
		return null
	return pick(valid_turfs)

/mob/living/simple_animal/hostile/boss/fishboss/proc/is_valid_spawn_turf(turf/T)
	if (!(istype(T, /turf/open/floor/rogue)))
		return FALSE
	if (istype(T, /turf/closed))
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/boss/fishboss/death()
	src.visible_message("<span class='warning'>The bloated, grotesque fishman explodes in a shower of gore!</span>","<span class='warning'>The bloated, grotesque fishman explodes in a shower of gore!</span>")
	src.spawn_gibs()
	src.spawn_gibs()
	src.spawn_gibs()
	new/obj/item/rogueweapon/mace/goden/deepduke(src.drop_location())
	qdel(src)
	return
