/mob/living/simple_animal/hostile
	faction = list(FACTION_HOSTILE)
	obj_damage = 40
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES //Bitflags. Set to ENVIRONMENT_SMASH_STRUCTURES to break closets,tables,racks, etc; ENVIRONMENT_SMASH_WALLS for walls; ENVIRONMENT_SMASH_RWALLS for rwalls
	var/atom/target
	var/ranged = FALSE
	var/rapid = 0 //How many shots per volley.
	var/rapid_fire_delay = 2 //Time between rapid fire shots

	var/dodge_prob = 0

	var/projectiletype	//set ONLY it and NULLIFY casingtype var, if we have ONLY projectile
	var/projectilesound
	var/casingtype		//set ONLY it and NULLIFY projectiletype, if we have projectile IN CASING
	var/list/friends = list()
	var/list/emote_taunt = list()
	var/taunt_chance = 0

	var/ranged_message = "fires" //Fluff text for ranged mobs
	var/ranged_cooldown = 0 //What the current cooldown on ranged attacks is, generally world.time + ranged_cooldown_time
	var/ranged_cooldown_time = 30 //How long, in deciseconds, the cooldown of ranged attacks is
	var/check_friendly_fire = 0 // Should the ranged mob check for friendlies when shooting

	cmode = 1
	setparrytime = 30
	dodgetime = 30

/mob/living/simple_animal/hostile/Destroy()
	if(target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	target = null
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

/mob/living/simple_animal/hostile/proc/AttackingTarget()
	if(target == src)
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, target) & COMPONENT_HOSTILE_NO_PREATTACK)
		return FALSE //but more importantly return before attack_animal called
	SEND_SIGNAL(src, COMSIG_HOSTILE_ATTACKINGTARGET, target)

	if(!QDELETED(target))
		return target.attack_animal(src)

/mob/living/simple_animal/hostile/proc/Aggro()
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
				if(faction_check_mob(L))
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
	if(QDELETED(src) || !loc)
		return
	if( QDELETED(targeted_atom) || targeted_atom == loc || targeted_atom == src )
		return
	var/turf/startloc = get_turf(src)
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
