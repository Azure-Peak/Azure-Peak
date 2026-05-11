/mob/living/simple_animal/hostile/boss/baroness //Huge thank you to felinid for their lich_boss code. They inspired this entire project.
	name = "Baroness"
	real_name = "Baroness Granita Narâg'Thark"
	gender = FEMALE
	desc = "An old, dwarven woman with a malicious stare. Her sallow skin is stretched taut over their skeletal structure. She is dressed in expensive clothes."
	mob_biotypes = MOB_HUMANOID | MOB_ORGANIC
	faction = list(FACTION_DUNDEAD)
	del_on_death = FALSE
	icon = 'icons/mob/baroness.dmi'
	icon_state = "baroness"
	icon_dead = "baronessdead"
	wander = 0 //some vars kept for balance tweaking but are default var values
	vision_range = 8
	aggro_vision_range = 24
	ranged = 1
	rapid = 3
	rapid_fire_delay = 10
	ranged_message = "casts a spell"
	ranged_cooldown = 0
	ranged_cooldown_time = 90
	ranged_ignores_vision = TRUE
	check_friendly_fire = 1
	environment_smash = 0
	minimum_distance = 1
	retreat_distance = 0
	retreat_health = 0.5
	dodging = TRUE
	dodge_prob = 10
	move_to_delay = 3
	obj_damage = 100
	base_intents = list(/datum/intent/simple/baroness)
	melee_damage_lower = 30
	melee_damage_upper = 50
	health = 3333
	maxHealth = 3333 //Increased from 3000.
	speak_chance = 3
	speak = list("An invader in my fortress?! I will feed your corpse to my pit!", 
	"Disgusting creature, you aren't worth the sum of your parts.",
	"I will flay your flesh and ensure you are conscious for every agonizing moment!",
	"Your soul will belong to me - my toy for eternity!")

	STASTR = 14
	STAPER = 20
	STAINT = 18
	STACON = 18
	STAWIL = 18
	STASPD = 15
	STALUC = 15
	loot = list(/obj/effect/temp_visual/baroness_dying)
	projectiletype = /obj/projectile/magic
	projectilesound = list('sound/magic/charged.ogg')
	var/allowed_projectile_types = list(/obj/projectile/magic/lightning, /obj/projectile/magic/frostbolt, /obj/projectile/energy/rogue3, /obj/projectile/magic/acidsplash)
	patron = /datum/patron/inhumen/zizo
	footstep_type = FOOTSTEP_MOB_SHOE
	stat_attack = UNCONSCIOUS

	var/mob_type
	var/mob/new_mob
	var/next_cast = 0
	var/spawned_mobs = 0
	var/minions_to_spawn = 1
	var/next_summon = 0
	var/list/minions = list( /mob/living/carbon/human/species/dwarfskeleton/ambush/knight/summoned = 100)

/mob/living/simple_animal/hostile/boss/baroness/Initialize()
	. = ..()
	//REMOVE_TRAIT(src, TRAIT_SIMPLE_WOUNDS, TRAIT_GENERIC) //Increased damage malus from silver. Minor over-time damage increase from bleeding wounds. Un-// if it's too easy.
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/boss/baroness/Shoot()
	projectiletype = pick(allowed_projectile_types)
	..()

/mob/living/simple_animal/hostile/boss/baroness/handle_automated_action()
	. = ..()
	if(health < 1500)
		minimum_distance = 3
		retreat_distance = 3
		if(target && next_cast < world.time && next_summon < world.time)
			spawn_minions(minions_to_spawn)
			INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, say), "Defend your Matriarch!", null, list("colossus", "yell"))
			next_cast = world.time + 10
			next_summon = world.time + 1800
			return .

/obj/projectile/magic/frostbolt/Baroness
	speed = 11
	damage = 10

/obj/projectile/energy/rogue3
	speed = 13

/obj/projectile/magic/baroness/lightning/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
			L.Immobilize(1, src)
			playsound(get_turf(src), pick('sound/misc/elec (1).ogg', 'sound/misc/elec (2).ogg', 'sound/misc/elec (3).ogg'), 100, FALSE)
	qdel(src)

/obj/projectile/magic/baroness/lightning
	name = "bolt of lightning"
	tracer_type = /obj/effect/projectile/tracer/stun
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	light_color = LIGHT_COLOR_WHITE
	damage = 25
	damage_type = BURN
	nodamage = FALSE
	speed = 0.3
	flag = "fire"
	light_color = "#ffffff"
/obj/projectile/magic/baroness/lightning/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
			L.Immobilize(1, src)
			playsound(get_turf(src), pick('sound/misc/elec (1).ogg', 'sound/misc/elec (2).ogg', 'sound/misc/elec (3).ogg'), 100, FALSE)
	qdel(src)

/mob/living/simple_animal/hostile/boss/baroness/proc/spawn_minions()
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

/mob/living/simple_animal/hostile/boss/baroness/proc/get_random_valid_turf()
	var/list/valid_turfs = list()
	for (var/turf/T in range(2, src))
		if (is_valid_spawn_turf(T))
			valid_turfs += T
	if (valid_turfs.len == 0)
		return null
	return pick(valid_turfs)

/mob/living/simple_animal/hostile/boss/baroness/proc/is_valid_spawn_turf(turf/T)
	if (!(istype(T, /turf/open/floor/rogue)))
		return FALSE
	if (istype(T, /turf/closed))
		return FALSE
	return TRUE

/obj/effect/temp_visual/baroness_dying
	name = "Baroness"
	desc = "The corpse of the baroness. Seems she was mortal after all."
	layer = ABOVE_OPEN_TURF_LAYER
	icon = 'icons/mob/baroness.dmi'
	icon_state = "baronessdead"
	anchored = TRUE
	duration = 10
	randomdir = FALSE

/obj/effect/temp_visual/baroness_dying/Initialize()
	. = ..()
	visible_message(span_boldannounce("The Baroness' staff shatters and she crumples to the floor."))
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, say), "Mistress!...", null, list("colossus", "yell"))

/obj/effect/temp_visual/baroness_dying/Destroy()
	for(var/mob/M in range(7,src))
		shake_camera(M, 7, 1)
	var/turf/T = get_turf(src)
	playsound(T,'sound/vo/female/gen/deathgurgle (1).ogg', 80, TRUE, TRUE)
	new /obj/item/roguekey/mage/baroness(T)
	new /obj/item/clothing/neck/roguetown/ornateamulet(T)
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/boss/baroness/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()

/datum/intent/simple/baroness
	name = "baroness"
	icon_state = "instrike"
	attack_verb = list("magically slashes", "magically cuts", "magically stabs")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = 'sound/combat/hits/bladed/genchop (1).ogg'
	chargetime = 15
	penfactor = PEN_LIGHT
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_d_type = "stab"

/mob/living/carbon/human/species/dwarfskeleton/ambush/knight/summoned

/obj/effect/oneway
	name = "one way effect"
	desc = ""
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "field_dir"
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE

/obj/effect/oneway/CanPass(atom/movable/mover, turf/target)
	var/turf/T = get_turf(src)
	var/turf/MT = get_turf(mover)
	return ..() && (T == MT || get_dir(MT,T) == dir)

/obj/effect/oneway/baroness //one way barrier to the boss room. Can be despawned with the key the boss drops.
	name = "magical barrier"
	max_integrity = 99999
	desc = "Victory or death - once you pass this point you will either triumph or fall. Recommended 3 players or more."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	invisibility = SEE_INVISIBLE_LIVING
	anchored = TRUE

/obj/effect/oneway/baroness/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/roguekey/mage/baroness))
		visible_message(span_boldannounce("The magical barrier disperses!"))
		qdel(src)

//Loot
/obj/item/roguekey/mage/baroness
	name = "baroness' key"
	desc = "An offputting key the Baroness dropped."
	icon_state = "toothkey"
	lockid = "baroness"
