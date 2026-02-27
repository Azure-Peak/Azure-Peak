/////////////////////////VOID DRAGON////////////////////////////
/*
Void dragons are creatures of a bygone age. It is a melee creature, that will chase down and cut most people to shreds if they are by themself.
It will also call down lightning strikes from the sky, and fling people with it's tail, as well as fly up into the sky.*/

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NOFIRE, "[type]")
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_ANTIMAGIC, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SHOCKIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_GUIDANCE, TRAIT_GENERIC)	//The voiddragon rends
	src.adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE)	//parrying the voiddragon should be hard

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)	//no wounding the void dragon
	return

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)
		TailSwipe(pulledby)

#define DRAKE_SWOOP_HEIGHT 270 //how high up drakes go, in pixels
#define DRAKE_SWOOP_DIRECTION_CHANGE_RANGE 5 //the range our x has to be within to not change the direction we slam from

#define SWOOP_DAMAGEABLE 1
#define SWOOP_INVULNERABLE 2


/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/proc/SetRecoveryTime(buffer_time)
	recovery_time = world.time + buffer_time
	ranged_cooldown = world.time + buffer_time

/// This proc is called by the HRD-MDE grenade to enrage the megafauna. This should increase the megafaunas attack speed if possible, give it new moves, or disable weak moves. This should be reverseable, and reverses on zlvl change.
/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/proc/enrage()
	if(enraged || ((health / maxHealth) * 100 <= 80))
		return
	enraged = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/proc/unrage()
	enraged = FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/attackby(obj/item/I, mob/living/carbon/human/user, params)
	if(istype(I, /obj/item/magic))
		var/obj/item/magic/magicmaterial = I
		if(istype(magicmaterial, /obj/item/magic/voidstone))
			if(health == maxHealth)
				to_chat(user, "[src] is already healthy!")
				return
			to_chat(user, "I start healing [src] with [magicmaterial].")
			if(do_mob(user, src, 20))
				var/tier_diff = 0.5 //Voidstone is uncommon, and if your trying to heal the dragon, you deserve the half health heal.
				visible_message("[src] absorbs [magicmaterial] and is healed.")
				adjustBruteLoss(-maxHealth * tier_diff)
				qdel(magicmaterial)
				return
	..()

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon
	name = "void dragon"
	desc = "An ancient creature from a bygone age. Now would be a good time to run."
	health = 5000
	maxHealth = 5000
	attack_verb_continuous = "gouges"
	attack_verb_simple = "gouge"
	attack_sound = 'sound/misc/demon_attack1.ogg'
	icon = 'modular/icons/mob/96x96/ratwood_dragon.dmi'
	icon_state = "dragon"
	icon_living = "dragon"
	icon_dead = "dragon_dead"
	speak_emote = list("roars")
	emote_hear = null
	emote_see = null
	environment_smash = ENVIRONMENT_SMASH_WALLS
	base_intents = list(/datum/intent/unarmed/dragonclaw)
	faction = list("abberant")
	obj_damage = 400	//Behold, nothing shall keep the dragon out
	melee_damage_lower = 80
	melee_damage_upper = 80
	retreat_distance = 0
	retreat_health = 0
	minimum_distance = 0
	aggressive = 1
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	speed = 5
	move_to_delay = 5
	ranged = TRUE
	canparry = TRUE
	defprob = 70
	pixel_x = -32
	var/swooping = NONE
	var/player_cooldown = 0
	deathmessage = "collapses to the floor with a final roar, the impact rocking the ground."
	footstep_type = FOOTSTEP_MOB_HEAVY

	var/anger_modifier = 0
	var/recovery_time = 0
	var/chosen_attack = 1 // chosen attack num
	/// Has someone enabled hard mode?
	var/enraged = FALSE
	var/sound/Snd // so far only way i can think of to stop a sound, thank MSO for the idea.
	var/cl_cd
	var/lightning_cd
	var/summon_cd
	var/slam_cd
	summon_primer = "You are ancient. A creature long since banished to the void ages past, you were trapped in a seemingly timeless abyss. Now you've been freed, returned to the world- and everything has changed. It seems some of your constructs remain buried beneath the ground. How you react to these events, only time can tell."
	summon_tier = 5
	inherent_spells = list(
	/obj/effect/proc_holder/spell/invoked/dragon_lightning,
	/obj/effect/proc_holder/spell/self/dragon_slam,
	/obj/effect/proc_holder/spell/self/summon_obelisks,
	/obj/effect/proc_holder/spell/invoked/dragon_swoop,
	/obj/effect/proc_holder/spell/invoked/chain_lightning_breath)

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vdragon/drgn.ogg')

/datum/intent/unarmed/dragonclaw
	name = "gouge"
	icon_state = "inchop"
	attack_verb = list("slashes", "gouges", "eviscerates")
	animname = "cut"
	blade_class = BCLASS_CHOP
	hitsound = "genslash"
	penfactor = 60
	damfactor = 40
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"

/datum/action/innate/megafauna_attack
	name = "Megafauna Attack"
	icon_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = ""
	var/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/M
	var/chosen_message
	var/chosen_attack_num = 0

/datum/action/innate/megafauna_attack/Grant(mob/living/L)
	M = L
	return ..()
/datum/action/innate/megafauna_attack/Activate()
	M.chosen_attack = chosen_attack_num
	to_chat(M, chosen_message)

/obj/effect/proc_holder/spell/invoked/dragon_lightning
	name = "Summon Sundering Lightning"
	recharge_time = 20 SECONDS
	overlay_state = "lightning_sunder"//this icon is really awful but it's consistent with the existing spell
	chargetime = 0
	range = 15
	antimagic_allowed = TRUE
/obj/effect/proc_holder/spell/invoked/dragon_lightning/cast(list/targets, mob/living/user = usr)
	if(istype(user, /mob/living/simple_animal/hostile/retaliate/rogue/voiddragon))
		var/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/dragon = user
		if(world.time <= dragon.lightning_cd)
			to_chat(user,span_warning("Too soon!"))
			revert_cast()
			return FALSE
		dragon.visible_message(span_danger("[dragon] calls forth lightning from the sky!"))
		dragon.create_lightning(targets[1])

/obj/effect/proc_holder/spell/self/dragon_slam
	name = "Slam"
	recharge_time = 15 SECONDS
	overlay_state = "bloodrage"
	chargetime = 0
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/self/dragon_slam/cast(list/targets, mob/living/user = usr)
	if(istype(user, /mob/living/simple_animal/hostile/retaliate/rogue/voiddragon))
		var/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/dragon = user
		if(world.time <= dragon.slam_cd)
			to_chat(user,span_warning("Too soon!"))
			revert_cast()
			return FALSE
		dragon.visible_message(span_colossus("[dragon] slams the ground, creating a shockwave!"))
		dragon.dragon_slam(dragon,2,10,8)

/obj/effect/proc_holder/spell/self/summon_obelisks
	name = "Summon Obelisks"
	recharge_time = 200 SECONDS
	overlay_state = "sands_of_time"
	chargetime = 0
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/self/summon_obelisks/cast(list/targets, mob/living/user = usr)
	if(istype(user, /mob/living/simple_animal/hostile/retaliate/rogue/voiddragon))
		var/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/dragon = user
		if(world.time <= dragon.summon_cd)
			to_chat(user,span_warning("Too soon!"))
			revert_cast()
			return FALSE
		dragon.summon_obelisk()

/obj/effect/proc_holder/spell/invoked/dragon_swoop
	name = "Swoop Attack"
	recharge_time = 30 SECONDS//there's not a fitting var for this because the lightning swoop thing is handled differently than other procs, just gonna make it do this instead
	overlay_state = "dendor"
	chargetime = 0
	range = 15
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/invoked/dragon_swoop/cast(list/targets, mob/living/user = usr)
	if(istype(user, /mob/living/simple_animal/hostile/retaliate/rogue/voiddragon))
		var/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/dragon = user
		dragon.swoop_attack(manual_target = targets[1])

/obj/effect/proc_holder/spell/invoked/chain_lightning_breath
	name = "Chain Lightning"
	recharge_time = 50 SECONDS
	overlay_state = "lightning"
	chargetime = 0
	range = 15
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/invoked/chain_lightning_breath/cast(list/targets, mob/living/user = usr)
	if(istype(user, /mob/living/simple_animal/hostile/retaliate/rogue/voiddragon))
		var/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/dragon = user
		if(world.time <= dragon.cl_cd)
			to_chat(user,span_warning("Too soon!"))
			revert_cast()
			return FALSE
		dragon.visible_message(span_colossus("[src] opens its maw, and lightning crackles beyond its teeth!"))
		if(!dragon.chain_lightning(targets[1], dragon))
			revert_cast()
			return FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/proc/TailSwipe(mob/victim)
	var/mob/living/target = victim
	src.visible_message(span_notice("[src] slams [target] with it's tail, knocking them to the floor!"))
	target.Paralyze(5)
	target.apply_damage(20, BRUTE)
	shake_camera(target, 2, 1)

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/OpenFire()
	if(swooping)
		return

	anger_modifier = clamp(max((maxHealth - health) / 50, enraged ? 15 : 0), 0, 20)
	ranged_cooldown = world.time + ranged_cooldown_time

	if(client)
		return
	if(prob(15 + anger_modifier))
		lava_swoop()
	if(world.time >= cl_cd)
		src.visible_message(span_colossus("[src] opens its maw, and lightning crackles beyond its teeth."))
		chain_lightning(target, src)
		return
	if(health <= 0.75 * maxHealth && world.time >= summon_cd)
		summon_obelisk()
		return
	if(world.time >= lightning_cd)
		create_lightning(target)
		return

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/proc/summon_obelisk()
	var/list/spawnLists = list(/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk,/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk)
	var/reinforcement_count = 2
	src.visible_message(span_cultbigbold("[src] summons abberant obelisks from beneath the ground."))
	summon_cd = world.time + 2000
	while(reinforcement_count > 0)
		var/list/turflist = list()
		for(var/turf/t in RANGE_TURFS(1, src))
			turflist += t

		var/turf/picked = pick(turflist)


		var/spawnTypes = pick_n_take(spawnLists)
		new spawnTypes(picked)
		reinforcement_count--
		continue

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/MeleeAction(patience = TRUE)
	if(rapid_melee > 1)
		var/datum/callback/cb = CALLBACK(src, PROC_REF(CheckAndAttack))
		var/delay = SSnpcpool.wait / rapid_melee
		for(var/i in 1 to rapid_melee)
			addtimer(cb, (i - 1)*delay)
	else
		if(world.time >= slam_cd && !client)
			src.visible_message(span_colossus("[src] slams the ground, creating a shockwave!"))
			dragon_slam(src,2,10,8)
		AttackingTarget()
	if(patience)
		GainPatience()

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/proc/dragon_slam(mob/owner, range, delay, throw_range)
	var/turf/origin = get_turf(owner)
	if(!origin)
		return
	slam_cd = world.time + 150
	var/list/all_turfs = RANGE_TURFS(range, origin)
	for(var/sound_range = 0 to range)
		playsound(origin,'sound/misc/bamf.ogg', 600, TRUE, 10)
		for(var/turf/stomp_turf in all_turfs)
			if(get_dist(origin, stomp_turf) > sound_range)
				continue
			new /obj/effect/temp_visual/small_smoke/halfsecond(stomp_turf)
			for(var/mob/living/hit_mob in stomp_turf)
				if(hit_mob == owner || hit_mob.throwing)
					continue
				to_chat(hit_mob, span_userdanger("[owner]'s ground slam shockwave sends you flying!"))
				var/turf/thrownat = get_ranged_target_turf_direct(owner, hit_mob, throw_range, rand(-10, 10))
				hit_mob.throw_at(thrownat, 8, 2, null, TRUE, force = MOVE_FORCE_OVERPOWERING)
				hit_mob.apply_damage(20, BRUTE)
				shake_camera(hit_mob, 2, 1)
			all_turfs -= stomp_turf
		SLEEP_CHECK_DEATH(delay)

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/proc/create_lightning(atom/target)
	if(!target)
		return
	var/turf/targetturf = get_turf(target)
	var/last_dist = 0
	lightning_cd = world.time + 250
	for(var/t in spiral_range_turfs(4, targetturf))
		var/turf/T = t
		if(!T)
			continue
		var/dist = get_dist(targetturf, T)
		if(dist > last_dist)
			last_dist = dist
			sleep(2 + min(4 - last_dist, 12) * 0.5) //gets faster
		new /obj/effect/temp_visual/targetlightning(T)

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/proc/lightning_strikes(amount, delay = 0.8)
	if(!target)
		return
	target.visible_message(span_colossus("Lightning starts to strike down from the sky!"))
	while(amount > 0)
		if(QDELETED(target))
			break
		var/turf/T = pick(RANGE_TURFS(enraged ? 2 : 1, target))
		new /obj/effect/temp_visual/targetlightning(T)
		amount--
		SLEEP_CHECK_DEATH(delay)

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/proc/lava_swoop(amount = 30)
	if(health < maxHealth * 0.5)
		return swoop_attack(lava_arena = TRUE, swoop_cooldown = enraged ? 2 SECONDS : 6 SECONDS)
	INVOKE_ASYNC(src, PROC_REF(lightning_strikes), enraged ? 60 : amount)
	swoop_attack(FALSE, target, 1000) // longer cooldown until it gets reset below
	SLEEP_CHECK_DEATH(0)
	if(health < maxHealth*0.5)
		SetRecoveryTime(40)

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/proc/swoop_attack(lava_arena = FALSE, atom/movable/manual_target, swoop_cooldown = 30)
	if(stat || swooping)
		return
	if(manual_target)
		GiveTarget(manual_target)
	if(!target)
		return
	playsound(loc, 'sound/vo/mobs/vdragon/drgnroar.ogg', 50, TRUE, -1)
	stop_automated_movement = TRUE
	swooping |= SWOOP_DAMAGEABLE
	movement_type = FLYING
	density = FALSE
	icon_state = "shadow"
	visible_message("<span class='boldwarning'>[src] swoops up high!</span>")

	var/negative
	var/initial_x = x
	if(target.x < initial_x) //if the target's x is lower than ours, swoop to the left
		negative = TRUE
	else if(target.x > initial_x)
		negative = FALSE
	else if(target.x == initial_x) //if their x is the same, pick a direction
		negative = prob(50)
	var/obj/effect/temp_visual/dragon_flight/F = new /obj/effect/temp_visual/dragon_flight(loc, negative)

	negative = !negative //invert it for the swoop down later

	var/oldtransform = transform
	alpha = 255
	animate(src, alpha = 204, transform = matrix()*0.9, time = 3, easing = BOUNCE_EASING)
	for(var/i in 1 to 3)
		sleep(1)
		if(QDELETED(src) || stat == DEAD) //we got hit and died, rip us
			qdel(F)
			if(stat == DEAD)
				swooping &= ~SWOOP_DAMAGEABLE
				animate(src, alpha = 255, transform = oldtransform, time = 0, flags = ANIMATION_END_NOW) //reset immediately
			return
	animate(src, alpha = 100, transform = matrix()*0.7, time = 7)
	swooping |= SWOOP_INVULNERABLE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	SLEEP_CHECK_DEATH(7)

	while(target && loc != get_turf(target))
		forceMove(get_step(src, get_dir(src, target)))
		SLEEP_CHECK_DEATH(0.5)

	// Ash drake flies onto its target and rains fire down upon them
	var/descentTime = 10

	//ensure swoop direction continuity.
	if(negative)
		if(ISINRANGE(x, initial_x + 1, initial_x + DRAKE_SWOOP_DIRECTION_CHANGE_RANGE))
			negative = FALSE
	else
		if(ISINRANGE(x, initial_x - DRAKE_SWOOP_DIRECTION_CHANGE_RANGE, initial_x - 1))
			negative = TRUE
	new /obj/effect/temp_visual/dragon_flight/end(loc, negative)
	new /obj/effect/temp_visual/dragon_swoop(loc)
	animate(src, alpha = 255, transform = oldtransform, descentTime)
	SLEEP_CHECK_DEATH(descentTime)
	swooping &= ~SWOOP_INVULNERABLE
	mouse_opacity = initial(mouse_opacity)
	icon_state = "[initial(icon_state)]"
	playsound(loc, 'sound/misc/meteorimpact.ogg', 200, TRUE)
	for(var/mob/living/L in orange(1, src))
		if(L.stat)
			visible_message(span_warning("[src] slams down on [L], crushing [L.p_them()]!"))
			L.gib()
		else
			L.adjustBruteLoss(75)
			if(L && !QDELETED(L)) // Some mobs are deleted on death
				var/throw_dir = get_dir(src, L)
				if(L.loc == loc)
					throw_dir = pick(GLOB.alldirs)
				var/throwtarget = get_edge_target_turf(src, throw_dir)
				L.throw_at(throwtarget, 3)
				visible_message(span_warning("[L] is thrown clear of [src]!</span>"))
	for(var/mob/M in range(7, src))
		shake_camera(M, 15, 1)
	movement_type = GROUND
	density = TRUE
	SLEEP_CHECK_DEATH(1)
	swooping &= ~SWOOP_DAMAGEABLE
	SetRecoveryTime(swoop_cooldown)

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/ex_act(severity, target)
	if(severity == EXPLODE_LIGHT)
		return
	..()

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/adjustHealth(amount, updating_health = TRUE)
	if(swooping & SWOOP_INVULNERABLE)
		return FALSE
	return ..()



/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/AttackingTarget()
	if(!swooping)
		return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/DestroySurroundings()
	if(!swooping)
		..()

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/Move()
	if(binded)
		to_chat(src,span_warning("You're currently bound and unable to move!"))
		return
	if(!swooping)
		..()

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/Goto(target, delay, minimum_distance)
	if(!swooping)
		..()

/obj/effect/temp_visual/lava_warning
	icon_state = "lavastaff_warn"
	layer = BELOW_MOB_LAYER
	light_outer_range = 2
	duration = 13

/obj/effect/temp_visual/lava_warning/ex_act()
	return

/obj/effect/temp_visual/lava_warning/Initialize(mapload, reset_time = 10)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(fall), reset_time)
	src.alpha = 63.75
	animate(src, alpha = 255, time = duration)

/obj/effect/temp_visual/lava_warning/proc/fall(reset_time)
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/fleshtostone.ogg', 80, TRUE)
	sleep(duration)
	playsound(T,'sound/magic/fireball.ogg', 200, TRUE)

	for(var/mob/living/L in T.contents)
		if(istype(L, /mob/living/simple_animal/hostile/retaliate/rogue/voiddragon))
			continue
		L.adjustFireLoss(10)
		to_chat(L, "<span class='userdanger'>You fall directly into the pool of lava!</span>")

	// changes turf to lava temporarily
	if(!T.density && !islava(T))
		var/lava_turf = /turf/open/lava
		var/reset_turf = T.type
		T.ChangeTurf(lava_turf)
		sleep(reset_time)
		T.ChangeTurf(reset_turf)

/obj/effect/temp_visual/drakewall
	desc = "An ash drakes true flame."
	name = "Fire Barrier"
	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	anchored = TRUE
	opacity = FALSE
	density = TRUE
	duration = 82
	color = COLOR_DARK_ORANGE

/obj/effect/temp_visual/drakewall/CanAtmosPass(direction)
	return !density


/obj/effect/temp_visual/dragon_swoop
	name = "certain death"
	desc = "Don't just stand there, move!"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "void_blink_in"
	layer = BELOW_MOB_LAYER
	pixel_x = -32
	pixel_y = -32
	color = "#FF0000"
	duration = 10

/obj/effect/temp_visual/dragon_flight
	icon = 'modular/icons/mob/96x96/ratwood_dragon.dmi'
	icon_state = "dragon"
	layer = ABOVE_ALL_MOB_LAYER
	pixel_x = -32
	duration = 10
	randomdir = FALSE

/obj/effect/temp_visual/dragon_flight/Initialize(mapload, negative)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(flight), negative)

/obj/effect/temp_visual/dragon_flight/proc/flight(negative)
	if(negative)
		animate(src, pixel_x = -DRAKE_SWOOP_HEIGHT*0.1, pixel_z = DRAKE_SWOOP_HEIGHT*0.15, time = 3, easing = BOUNCE_EASING)
	else
		animate(src, pixel_x = DRAKE_SWOOP_HEIGHT*0.1, pixel_z = DRAKE_SWOOP_HEIGHT*0.15, time = 3, easing = BOUNCE_EASING)
	sleep(3)
	icon_state = "dragon_swoop"
	if(negative)
		animate(src, pixel_x = -DRAKE_SWOOP_HEIGHT, pixel_z = DRAKE_SWOOP_HEIGHT, time = 7)
	else
		animate(src, pixel_x = DRAKE_SWOOP_HEIGHT, pixel_z = DRAKE_SWOOP_HEIGHT, time = 7)

/obj/effect/temp_visual/dragon_flight/end
	pixel_x = DRAKE_SWOOP_HEIGHT
	pixel_z = DRAKE_SWOOP_HEIGHT
	duration = 10

/obj/effect/temp_visual/dragon_flight/end/flight(negative)
	if(negative)
		pixel_x = -DRAKE_SWOOP_HEIGHT
		animate(src, pixel_x = -32, pixel_z = 0, time = 5)
	else
		animate(src, pixel_x = -32, pixel_z = 0, time = 5)

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/proc/chain_lightning(var/list/targets, mob/user = usr)
	targets = list()

	for(var/mob/living/target in view(7, src))
		if(target == src)
			continue
		if(istype(target,/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk))
			continue
		targets += target
	src.move_resist = MOVE_FORCE_VERY_STRONG
	var/mob/living/carbon/target = targets[1]
	var/distance = get_dist(user.loc,target.loc)
	if(distance>3)
		to_chat(user, span_colossus("[target.p_theyre(TRUE)] too far away!"))

		return FALSE
	if(do_after(user, 2 SECONDS, target = src))
		user.Beam(target,icon_state="lightning[rand(1,12)]",time=5)
		src.visible_message(span_colossus("[src] unleashes a storm of lightning from it's maw!"))
		cl_cd = world.time + 500
		Bolt(user,target,30,5,user)
		src.move_resist = initial(src.move_resist)
		return TRUE
	else
		return FALSE//if the dragon cancels its do_after by moving or something, don't put it on cd

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/proc/Bolt(mob/origin,mob/target,bolt_energy,bounces,mob/user = usr)
	origin.Beam(target,icon_state="lightning[rand(1,12)]",time=5)
	var/mob/living/carbon/current = target
	if(current.anti_magic_check())
		current.visible_message(span_warning("[current] absorbs the spell, remaining unharmed!"), span_danger("I absorb the spell, remaining unharmed!"))
	else if(bounces < 1)
		current.electrocute_act(bolt_energy,"Lightning Bolt",flags = SHOCK_NOGLOVES)
	else
		current.electrocute_act(bolt_energy,"Lightning Bolt",flags = SHOCK_NOGLOVES)
		var/list/possible_targets = new
		for(var/mob/living/M in view(7,target))
			if(user == M || target == M && los_check(current,M)) // || origin == M ? Not sure double shockings is good or not
				continue
			possible_targets += M
		if(!possible_targets.len)
			return
		var/mob/living/next = pick(possible_targets)
		if(next)
			Bolt(current,next,max((bolt_energy-5),5),bounces-1,user)

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/proc/los_check(mob/A,mob/B)
	//Checks for obstacles from A to B
	var/obj/dummy = new(A.loc)
	dummy.pass_flags |= PASSTABLE
	for(var/turf/turf in getline(A,B))
		for(var/atom/movable/AM in turf)
			if(!AM.CanPass(dummy,turf,1))
				qdel(dummy)
				return 0
	qdel(dummy)
	return 1

/obj/effect/proc_holder/spell/invoked/repulse/voiddragon
	name = "Tail Sweep"
	desc = "Throw back attackers with a sweep of your tail."
	sound = 'sound/misc/tail_swing.ogg'
	recharge_time = 15 SECONDS
	clothes_req = FALSE
	cooldown_min = 150
	invocation_type = "none"
	sparkle_path = /obj/effect/temp_visual/dir_setting/tailsweep
	action_icon_state = "tailsweep"
	action_background_icon_state = "bg_alien"
	antimagic_allowed = FALSE
	range = 2

/obj/effect/proc_holder/spell/invoked/repulse/voiddragon/cast(list/targets, mob/user = usr)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		playsound(C.loc, 'sound/combat/hits/punch/punch_hard (3).ogg', 80, TRUE, TRUE)
		C.spin(6, 1)
	..(targets, user, 3)

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/death()
	..()
	var/turf/deathspot = get_turf(src)
	new /obj/item/clothing/ring/dragon_ring(deathspot)
	new /obj/item/clothing/ring/dragon_ring(deathspot)
	new /obj/item/clothing/ring/dragon_ring(deathspot)
	new /obj/item/book/granter/spell_points/voiddragon
	new /obj/item/book/granter/spell_points/voiddragon
	new /obj/item/book/granter/spell_points/voiddragon
	update_icon()
	spill_embedded_objects()

#undef DRAKE_SWOOP_HEIGHT
#undef DRAKE_SWOOP_DIRECTION_CHANGE_RANGE
#undef SWOOP_DAMAGEABLE
#undef SWOOP_INVULNERABLE
