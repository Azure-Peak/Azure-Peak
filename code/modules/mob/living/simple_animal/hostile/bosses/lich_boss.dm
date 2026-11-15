/mob/living/simple_animal/hostile/boss/lich
	name = "Archlich"
	desc = "An incomprehensibly powerful necromancer, dressed in the papal garbs of a Rockhillian priest - a glimpse into what once was. The air around you crackles with unholy energy."
	mob_biotypes = MOB_HUMANOID|MOB_UNDEAD
	boss_abilities = list(/datum/action/boss/lich_summon_minions)
	faction = list(FACTION_LICH)
	del_on_death = TRUE
	icon = 'icons/mob/evilpope.dmi'
	icon_state = "EvilPope"
	ai_controller = /datum/ai_controller/lich
	ranged = 1
	rapid = 3
	rapid_fire_delay = 8
	ranged_message = "casts a spell"
	ranged_cooldown_time = 40
	environment_smash = 0
	obj_damage = 100
	base_intents = list(/datum/intent/simple/lich)
	melee_damage_lower = 60
	melee_damage_upper = 80
	health = 6666
	maxHealth = 6666 //Increased from 5000, to account for the new vulnerabilities to silver. Revert if it's too hard.
	STASTR = 12
	STAPER = 20
	STAINT = 18
	STACON = 20
	STAWIL = 20
	STASPD = 15
	STALUC = 15
	loot = list(/obj/effect/temp_visual/lich_dying)
	projectiletype = /obj/projectile/magic
	var/allowed_projectile_types = list(/obj/projectile/magic/lightning,
	/obj/projectile/magic/sickness,
	/obj/projectile/magic/arcane_barrage,
	/obj/projectile/magic/acidsplash,
	/obj/projectile/magic/spitfire)
	patron = /datum/patron/inhumen/zizo
	footstep_type = FOOTSTEP_MOB_SHOE

	var/minions_to_spawn = 6
	var/mob_type
	var/mob/new_mob
	var/spawned_mobs = 0
	var/list/minions = list(
		/mob/living/carbon/human/species/skeleton/npc/mediumspread/lich = 60,
	)

/mob/living/simple_animal/hostile/boss/lich/Initialize(mapload)
	projectiletype = /obj/projectile/bullet/reusable/deepone
	. = ..()
	//ADD_TRAIT(src, TRAIT_NOFIRE, TRAIT_GENERIC) //Testing vulnerability to the new silver changes. Un-// these if it becomes too easy.
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOZIZORECRUIT, TRAIT_GENERIC) //I know what you are
	//REMOVE_TRAIT(src, TRAIT_SIMPLE_WOUNDS, TRAIT_GENERIC) //Ditto.
	AddComponent(/datum/component/ai_aggro_system, aggro_range = 8, maintain_range = 24)
	for(var/ability_type in list(
		/datum/action/cooldown/spell/lich/summon_minions,
		/datum/action/cooldown/spell/lich/blink,
		/datum/action/cooldown/spell/lich/fireball_wave,
		/datum/action/cooldown/spell/lich/projectile_wave,
	))
		var/datum/action/cooldown/spell/ability = new ability_type(src)
		ability.Grant(src)

/mob/living/simple_animal/hostile/boss/lich/Shoot()
	projectiletype = pick(allowed_projectile_types)
	..()

//First Summon Ability. Spawns two fully armored carbon skeletons.
/datum/action/boss/lich_summon_minions
	name = "Summon Minions"
	button_icon_state = "art_summon"
	usage_probability = 100
	boss_cost = 70
	boss_type = /mob/living/simple_animal/hostile/boss/lich
	needs_target = TRUE
	say_when_triggered = "Hgf'ant'kthar!"
	var/static/summoned_minions = 0

/datum/action/boss/lich_summon_minions/Trigger()
	if(summoned_minions <= 6 && ..())
		var/list/minions = list(
		/mob/living/carbon/human/species/skeleton/npc/dungeon/lich = 30)
		var/list/directions = GLOB.cardinals.Copy()
		for(var/i in 1 to 2)
			var/minions_chosen = pickweight(minions)
			new minions_chosen (get_step(boss,pick_n_take(directions)), 1)
		summoned_minions += 1;

/mob/living/simple_animal/hostile/boss/lich/proc/blast(atom/victim, set_angle)
	var/turf/target_turf = get_turf(victim)
	var/angle_to_target = Get_Angle(src, target_turf)
	if(isnum(set_angle))
		angle_to_target = set_angle
	var/static/list/colossus_shotgun_shot_angles = list(30, 20, 10, 0, -10, -20, -30)
	for(var/i in colossus_shotgun_shot_angles)
		shoot_projectile(victim, target_turf, angle_to_target + i)

/mob/living/simple_animal/hostile/boss/lich/proc/shoot_projectile(atom/victim, turf/marker, set_angle)
	if(!isnum(set_angle) && (!marker || marker == loc))
		return
	var/turf/startloc = get_turf(src)
	var/obj/projectile/P = new projectiletype(startloc)
	P.preparePixelProjectile(marker, startloc)
	P.firer = src
	P.original = victim
	P.fire(set_angle)

/mob/living/simple_animal/hostile/boss/lich/proc/blaststrong(atom/victim, set_angle)
	var/turf/target_turf = get_turf(victim)
	var/angle_to_target = Get_Angle(src, target_turf)
	if(isnum(set_angle))
		angle_to_target = set_angle
	var/static/list/colossus_shotgun_shot_angles = list(45, 30, 15, 0, -15, -30, -45)
	for(var/i in colossus_shotgun_shot_angles)
		shoot_projectilestrong(victim, target_turf, angle_to_target + i)

/mob/living/simple_animal/hostile/boss/lich/proc/shoot_projectilestrong(atom/victim, turf/marker, set_angle)
	if(!isnum(set_angle) && (!marker || marker == loc))
		return
	var/turf/startloc = get_turf(src)
	var/obj/projectile/P = new /obj/projectile/magic/aoe/fireball/rogue/great/lich(startloc)
	P.preparePixelProjectile(marker, startloc)
	P.firer = src
	P.original = victim
	P.fire(set_angle)

/obj/projectile/magic/sickness/lich
	speed = 15
	damage = 20

/obj/projectile/magic/aoe/fireball/rogue/great/lich
	speed = 20

/obj/projectile/magic/lich/lightning
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
/obj/projectile/magic/lich/lightning/on_hit(target)
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
			if(out_of_effective_range())
				return
			L.Immobilize(1, src)
			playsound(get_turf(src), pick('sound/misc/elec (1).ogg', 'sound/misc/elec (2).ogg', 'sound/misc/elec (3).ogg'), 100, FALSE)
	qdel(src)

/mob/living/simple_animal/hostile/boss/lich/proc/spawn_minions()
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

/mob/living/simple_animal/hostile/boss/lich/proc/get_random_valid_turf()
	var/list/valid_turfs = list()
	for (var/turf/T in range(6, src))
		if (is_valid_spawn_turf(T))
			valid_turfs += T
	if (valid_turfs.len == 0)
		return null
	return pick(valid_turfs)

/mob/living/simple_animal/hostile/boss/lich/proc/is_valid_spawn_turf(turf/T)
	if (!(istype(T, /turf/open/floor/rogue)))
		return FALSE
	if (istype(T, /turf/closed))
		return FALSE
	return TRUE

/obj/effect/temp_visual/lich_dying
	name = "Lich"
	desc = ""
	layer = ABOVE_OPEN_TURF_LAYER
	icon = 'icons/mob/evilpope.dmi'
	icon_state = "popedeath"
	anchored = TRUE
	duration = 30
	randomdir = FALSE

/obj/effect/temp_visual/lich_dying/Initialize(mapload)
	. = ..()
	visible_message(span_boldannounce("The Archlich collapses into a pile of dust and bone, unholy energy dispersing into the air!"))
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, say), "Impossible!", null, list("colossus", "yell"))

/obj/effect/temp_visual/lich_dying/Destroy()
	for(var/mob/M in range(7,src))
		shake_camera(M, 7, 1)
	var/turf/T = get_turf(src)
	playsound(T,'sound/vo/mobs/skel/skeleton_death (5).ogg', 80, TRUE, TRUE)
	new /obj/item/roguekey/mage/lich(T)
	return ..()

/mob/living/simple_animal/hostile/boss/lich/simple_limb_hit(zone)
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

/datum/intent/simple/lich
	name = "lich"
	icon_state = "instrike"
	attack_verb = list("strikes", "cuts", "cleaves", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = 'sound/combat/hits/bladed/genchop (1).ogg'
	chargetime = 20
	penfactor = PEN_MEDIUM
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_d_type = "stab"

/obj/effect/oneway
	name = "one way effect"
	desc = ""
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "field_dir"
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE

/obj/effect/oneway/CanPass(atom/movable/mover, turf/target)
	if(!(ismob(mover))) //Fixes cart exploit that broke one way boss arena doors. Only mobs can pass through now.
		return ..() && 0
	var/turf/T = get_turf(src)
	var/turf/MT = get_turf(mover)
	return ..() && (T == MT || get_dir(MT,T) == dir)

/obj/effect/oneway/lich //one way barrier to the boss room. Can be despawned with the key the boss drops.
	name = "magical barrier"
	max_integrity = 99999
	desc = "Victory or death - once you pass this point you will either triumph or fall. Recommended 5 players or more."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	invisibility = SEE_INVISIBLE_LIVING
	anchored = TRUE

/obj/effect/oneway/lich/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/roguekey/mage/lich))
		visible_message(span_boldannounce("The magical barrier disperses!"))
		qdel(src)


/turf/open/floor/rogue/carpet/lord/center/no_teleport //sanity check to keep the Lich from blinking outside the combat arena
	teleport_restricted = TRUE

//Loot
/obj/item/roguekey/mage/lich
	name = "archlich's key"
	desc = "A strange key the Archlich dropped."
	icon_state = "eyekey"
	lockid = "lich"
