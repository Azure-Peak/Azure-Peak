/mob/living/simple_animal/hostile
	faction = list(FACTION_HOSTILE)
	stop_automated_movement_when_pulled = 0
	obj_damage = 40
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES //Bitflags. Set to ENVIRONMENT_SMASH_STRUCTURES to break closets,tables,racks, etc; ENVIRONMENT_SMASH_WALLS for walls; ENVIRONMENT_SMASH_RWALLS for rwalls
	var/atom/target
	var/ranged = FALSE
	var/rapid = 0 //How many shots per volley.
	var/rapid_fire_delay = 2 //Time between rapid fire shots

	var/dodging = FALSE
	var/approaching_target = FALSE //We should dodge now
	var/in_melee = FALSE	//We should sidestep now
	var/dodge_prob = 0
	var/sidestep_per_cycle = 1 //How many sidesteps per npcpool cycle when in melee

	var/projectiletype	//set ONLY it and NULLIFY casingtype var, if we have ONLY projectile
	var/projectilesound
	var/casingtype		//set ONLY it and NULLIFY projectiletype, if we have projectile IN CASING
	move_to_delay = 3 //delay for the automated movement.
	var/list/friends = list()
	var/list/emote_taunt = list()
	var/taunt_chance = 0

	var/rapid_melee = 1				//Number of melee attacks between each npc pool tick. Spread evenly.
	var/melee_queue_distance = 4 //If target is close enough start preparing to hit them if we have rapid_melee enabled

	var/ranged_message = "fires" //Fluff text for ranged mobs
	var/ranged_cooldown = 0 //What the current cooldown on ranged attacks is, generally world.time + ranged_cooldown_time
	var/ranged_cooldown_time = 30 //How long, in deciseconds, the cooldown of ranged attacks is
	var/ranged_ignores_vision = FALSE //if it'll fire ranged attacks even if it lacks vision on its target, only works with environment smash
	var/check_friendly_fire = 0 // Should the ranged mob check for friendlies when shooting
	var/retreat_distance = null //If our mob runs from players when they're too close, set in tile distance. By default, mobs do not retreat.
	var/minimum_distance = 1 //Minimum approach distance, so ranged mobs chase targets down, but still keep their distance set in tiles to the target, set higher to make mobs keep distance


//These vars are related to how mobs locate and target
	var/robust_searching = 0 //By default, mobs have a simple searching method, set this to 1 for the more scrutinous searching (stat_attack, stat_exclusive, etc), should be disabled on most mobs
	var/vision_range = 6 //How big of an area to search for targets in, a vision of 9 attempts to find targets as soon as they walk into screen view
	var/aggro_vision_range = 18 //If a mob is aggro, we search in this radius. Defaults to 9 to keep in line with original simple mob aggro radius
	var/search_objects = 0 //If we want to consider objects when searching around, set this to 1. If you want to search for objects while also ignoring mobs until hurt, set it to 2. To completely ignore mobs, even when attacked, set it to 3
	var/search_objects_timer_id //Timer for regaining our old search_objects value after being attacked
	var/search_objects_regain_time = 30 //the delay between being attacked and gaining our old search_objects value back
	var/list/wanted_objects = list() //A typecache of objects types that will be checked against to attack, should we have search_objects enabled
	var/stat_attack = CONSCIOUS //Mobs with stat_attack to UNCONSCIOUS will attempt to attack things that are unconscious, Mobs with stat_attack set to DEAD will attempt to attack the dead.
	var/stat_exclusive = FALSE //Mobs with this set to TRUE will exclusively attack things defined by stat_attack, stat_attack DEAD means they will only attack corpses
	var/attack_same = 0 //Set us to 1 to allow us to attack our own faction
	var/atom/targets_from = null //all range/attack/etc. calculations should be done from this atom, defaults to the mob itself, useful for Vehicles and such
	var/attack_all_objects = FALSE //if true, equivalent to having a wanted_objects list containing ALL objects.

	var/lose_patience_timer_id //id for a timer to call LoseTarget(), used to stop mobs fixating on a target they can't reach
	var/lose_patience_timeout = 300 //30 seconds by default, so there's no major changes to AI behaviour, beyond actually bailing if stuck forever

	var/del_on_deaggro = 0 //seconds to delete after losing aggro
	var/last_aggro_loss = null

	var/retreat_health

	var/next_seek

	cmode = 1
	setparrytime = 30
	dodgetime = 30

/mob/living/simple_animal/hostile/Initialize(mapload)
	. = ..()
	last_aggro_loss = world.time //so we delete even if we never found a target
	if(!targets_from)
		targets_from = src
	wanted_objects = typecacheof(wanted_objects)

/mob/living/simple_animal/hostile/Destroy()
	if(target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	target = null
	targets_from = null
	return ..()

/mob/living/simple_animal/hostile/examine(mob/user)
	. = ..()
	if(user in friends)
		. += span_notice("[src] seems friendly towards you.")

/mob/living/simple_animal/hostile/Login()
	. = ..()
	if(target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
		target = null
	approaching_target = FALSE
	in_melee = FALSE

/mob/living/simple_animal/hostile/proc/AttackingTarget()
	if(target == src)
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, target) & COMPONENT_HOSTILE_NO_PREATTACK)
		return FALSE //but more importantly return before attack_animal called
	SEND_SIGNAL(src, COMSIG_HOSTILE_ATTACKINGTARGET, target)
	in_melee = TRUE

	if(!QDELETED(target))
		return target.attack_animal(src)

/mob/living/simple_animal/hostile/proc/Aggro()
	vision_range = aggro_vision_range
	if(world.time >= (mob_timers["npc_chatter"] + 15 SECONDS))
		if(target && emote_taunt.len && prob(taunt_chance))
			emote("me", 1, "[pick(emote_taunt)] at [target].")
			taunt_chance = max(taunt_chance-7,2)
		emote("aggro")
		mob_timers["npc_chatter"] = world.time

/mob/living/simple_animal/hostile/proc/CheckFriendlyFire(atom/A)
	if(check_friendly_fire)
		for(var/turf/T in getline(src,A)) // Not 100% reliable but this is faster than simulating actual trajectory
			for(var/mob/living/L in T)
				if(L == src || L == A)
					continue
				if(faction_check_mob(L) && !attack_same)
					return TRUE

/mob/living/simple_animal/hostile/proc/OpenFire(atom/A)
	if(binded)
		return FALSE
	if(CheckFriendlyFire(A))
		return
	visible_message(span_danger("<b>[src]</b> [ranged_message] at [A]!"))


	var/turf/locked_turf = get_turf(A)
	var/aim_window = get_ranged_aim_window()
	var/datum/callback/cb = CALLBACK(src, PROC_REF(Shoot), A, locked_turf)
	if(rapid > 1)
		for(var/i in 1 to rapid)
			addtimer(cb, aim_window + ((i - 1) * rapid_fire_delay))
	else
		addtimer(cb, aim_window)
	ranged_cooldown = world.time + ranged_cooldown_time


/mob/living/simple_animal/hostile/proc/Shoot(atom/targeted_atom, turf/locked_turf)
	if(QDELETED(src) || QDELETED(targets_from) || !targets_from.loc)
		return
	if( QDELETED(targeted_atom) || targeted_atom == targets_from.loc || targeted_atom == targets_from )
		return
	var/turf/startloc = get_turf(targets_from)
	if(casingtype)
		var/obj/item/ammo_casing/casing = new casingtype(startloc)
		playsound(src, projectilesound, 100, TRUE)
		apply_ranged_accuracy(casing.BB)
		var/atom/aim_at = locked_turf ? get_ranged_lead_turf(targeted_atom, locked_turf, casing.BB?.speed) : targeted_atom
		casing.fire_casing(aim_at || targeted_atom, src, null, null, null, ran_zone(), 0,	src)
	else if(projectiletype)
		var/obj/projectile/P = new projectiletype(startloc)
		playsound(src, projectilesound, 100, TRUE)
		apply_ranged_accuracy(P)
		var/atom/aim_at = locked_turf ? get_ranged_lead_turf(targeted_atom, locked_turf, P.speed) : targeted_atom
		if(!aim_at)
			aim_at = targeted_atom
		P.starting = startloc
		P.firer = src
		P.fired_from = src
		P.yo = aim_at.y - startloc.y
		P.xo = aim_at.x - startloc.x
		P.original = aim_at
		P.def_zone = ran_zone()
		P.preparePixelProjectile(aim_at, src)
		P.fire()
		return P


/mob/living/simple_animal/hostile/RangedAttack(atom/A, params) //Player firing
	if(ranged && ranged_cooldown <= world.time)
		OpenFire(A)
	..()

/mob/living/simple_animal/hostile/checkdefense(datum/intent/attack_intent, mob/living/user)
	if(user in friends)
		return FALSE
	return ..()
