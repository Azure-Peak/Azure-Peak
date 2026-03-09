/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/Initialize()
	. = ..()
	ADD_TRAIT(src,TRAIT_NOFIRE, "[type]")
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SHOCKIMMUNE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)	//no wounding the obelisk
	return

/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/Move(newloc)
	if(binded)
		to_chat(src,span_warning("You're currently bound and unable to move!"))
		return
	.=..()

/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "voidstone obelisk"
	desc = "A construct from another age. It is marked by glowing sigils and it's material seems to absorb magic!"
	icon_state = "obelisk-combined"
	icon_living = "obelisk-combined"
	icon_dead = "obelisk-combined"

	faction = list("abberant")
	emote_hear = null
	emote_see = null
	turns_per_move = 6
	speed = 5
	see_in_dark = 9
	move_to_delay = 12
	vision_range = 9
	aggro_vision_range = 9
	movement_type = FLYING
	butcher_results = list()

	health = 750
	maxHealth = 750
	food_type = null

	base_intents = list(/datum/intent/simple/slam)
	attack_sound = list('sound/combat/hits/onstone/wallhit.ogg')
	obj_damage = 75
	melee_damage_lower = 30
	melee_damage_upper = 30
	STAWIL = 20
	STACON = 20
	STASTR = 12
	STASPD = 8

	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	environment_smash = ENVIRONMENT_SMASH_WALLS
	simple_detect_bonus = 60
	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 35
	retreat_health = 0
	food = 0
	dodgetime = 17
	aggressive = 1
	var/beam_cooldown = 0
	var/beam_range = 10
	/// How long does our beam last?
	var/beam_duration = 5 SECONDS
	/// How long do we wind up before firing?
	var/charge_duration = 1 SECONDS
	/// Overlay we show when we're about to fire
	var/static/image/direction_overlay = image('icons/effects/effects.dmi', "obeliak_telegraph_dir")
	/// A list of all the beam parts.
	var/list/beam_parts = list()
	summon_primer = "You are ancient. A construct built in an age before men, a time of dragons. Your builders don't seem to be around anymore, and time has past with you in standby. How you respond, is up to you."
	summon_tier = 3
	inherent_spells = list(/obj/effect/proc_holder/spell/invoked/fire_obelisk_beam)

/datum/intent/simple/slam
	name = "slam"
	icon_state = "instrike"
	attack_verb = list("slam", "rams")
	animname = "blank22"
	blade_class = BCLASS_BLUNT
	hitsound = 'sound/combat/hits/onstone/wallhit.ogg'
	chargetime = 0
	penfactor = 20
	swingdelay = 0
	candodge = TRUE
	canparry = TRUE
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/death(gibbed)
	..()
	var/turf/deathspot = get_turf(src)
	new /obj/item/magic/voidstone(deathspot)
	spill_embedded_objects()
	update_icon()
	sleep(1)
	qdel(src)


/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/MoveToTarget(list/possible_targets)
	stop_automated_movement = 1
	if(!target || !CanAttack(target))
		LoseTarget()
		return 0
	if(binded)
		return 0
	if(target in possible_targets)
		var/target_distance = get_dist(targets_from,target)
		if(world.time >= beam_cooldown)
			Activate(target)
		if(ranged) //We ranged? Shoot at em
			if(!target.Adjacent(targets_from) && ranged_cooldown <= world.time) //But make sure they're not in range for a melee attack and our range attack is off cooldown
				OpenFire(target)
		if(retreat_distance != null) //If we have a retreat distance, check if we need to run from our target
			if(target_distance <= retreat_distance) //If target's closer than our retreat distance, run
				walk_away(src,target,retreat_distance,move_to_delay)
			else
				Goto(target,move_to_delay,minimum_distance) //Otherwise, get to our minimum distance so we chase them
		else
			Goto(target,move_to_delay,minimum_distance)
		if(target)
			if(targets_from && isturf(targets_from.loc) && target.Adjacent(targets_from)) //If they're next to us, attack
				MeleeAction()
			else
				if(rapid_melee > 1 && target_distance <= melee_queue_distance)
					MeleeAction(FALSE)
				in_melee = FALSE //If we're just preparing to strike do not enter sidestep mode
			return 1
		return 0
	else
		if(ranged_ignores_vision && ranged_cooldown <= world.time) //we can't see our target... but we can fire at them!
			OpenFire(target)
		Goto(target,move_to_delay,minimum_distance)
		FindHidden()
		return 1


/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vobelisk/construct.ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/Destroy()
	extinguish_laser()
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/proc/Activate(atom/target)

	src.face_atom(target)
	src.move_resist = MOVE_FORCE_VERY_STRONG
	src.add_overlay(direction_overlay)
	src.visible_message(span_notice("The air chills as [src] takes in energy..."))
	var/fully_charged = do_after(src, delay = charge_duration, target = src)
	src.cut_overlay(direction_overlay)
	if (!fully_charged)
		return TRUE

	if (!fire_laser())
		var/static/list/fail_emotes = list("tremors.", "creaks.", "emits green steam as it fails to fire.")
		src.manual_emote(pick(fail_emotes))
		return TRUE

	do_after(src, delay = beam_duration, target = src)
	extinguish_laser()
	beam_cooldown = world.time + 200
	return TRUE

/// Create a laser in the direction we are facing
/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/proc/fire_laser()
	src.visible_message(span_danger("[src] fires a aberrant beam!"))
	playsound(src, 'sound/magic/obeliskbeam.ogg', 150, FALSE, 0, 3)
	var/turf/target_turf = get_ranged_target_turf(src, src.dir, beam_range)
	var/turf/origin_turf = get_turf(src)
	var/list/affected_turfs = get_line(origin_turf, target_turf) - origin_turf
	for(var/turf/affected_turf in affected_turfs)
		if(affected_turf.opacity)
			break
		var/blocked = FALSE
		for(var/obj/potential_block in affected_turf.contents)
			if(potential_block.opacity)
				blocked = TRUE
				break
		if(blocked)
			break
		var/obj/effect/obeliskbeam/new_obeliskbeam = new(affected_turf)
		new_obeliskbeam.dir = src.dir
		beam_parts += new_obeliskbeam
		new_obeliskbeam.assign_creator(src)
		for(var/mob/living/hit_mob in affected_turf.contents)
			hit_mob.apply_damage(damage = 25, damagetype = BURN)
			to_chat(hit_mob, span_userdanger("You're blasted by [src]'s aberrant beam!"))
//		RegisterSignal(new_obeliskbeam, COMSIG_QDELETING, PROC_REF(extinguish_laser)) // In case idk a singularity eats it or something
	if(!length(beam_parts))
		return FALSE
	var/atom/last_obeliskbeam = beam_parts[length(beam_parts)]
	last_obeliskbeam.icon_state = "obeliskbeam_end"
	var/atom/first_obeliskbeam = beam_parts[1]
	first_obeliskbeam.icon_state = "obeliskbeam_start"
	return TRUE

/// Get rid of our laser when we are done with it
/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/proc/extinguish_laser()
	if(!length(beam_parts))
		return FALSE
	src.move_resist = initial(src.move_resist)
	for(var/obj/effect/obeliskbeam/beam in beam_parts)
		beam.disperse()
	beam_parts = list()

/// Segments of the actual beam, these hurt if you stand in them
/obj/effect/obeliskbeam
	name = "abberant beam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "obeliskbeam_mid"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_color = "#008080"
	light_power = 4
	light_outer_range = 3
	/// Who made us?
	var/datum/weakref/creator

/obj/effect/obeliskbeam/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSfastprocess, src)

/obj/effect/obeliskbeam/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/effect/obeliskbeam/process()
	var/atom/ignore = creator?.resolve()
	for(var/mob/living/hit_mob in get_turf(src))
		if(hit_mob == ignore)
			continue
		damage(hit_mob)

/// Hurt the passed mob
/obj/effect/obeliskbeam/proc/damage(mob/living/hit_mob)
	hit_mob.apply_damage(damage = 15, damagetype = BURN)
	to_chat(hit_mob, span_danger("You're damaged by [src]!"))

/// Ignore damage dealt to this mob
/obj/effect/obeliskbeam/proc/assign_creator(mob/living/maker)
	creator = WEAKREF(maker)

/// Disappear
/obj/effect/obeliskbeam/proc/disperse()
	animate(src, time = 0.5 SECONDS, alpha = 0)
	QDEL_IN(src, 0.5 SECONDS)

/obj/effect/proc_holder/spell/invoked/fire_obelisk_beam
	name = "Fire Beam"
	recharge_time = 20 SECONDS //voidstone obelisk's beam is different than other mob spells since the cooldown actually begins one the beam is finished, we'll just eyeball it
	overlay_state = "regression"
	chargetime = 0
	range = 10
	antimagic_allowed = TRUE //the magic is coming from inside the house

/obj/effect/proc_holder/spell/invoked/fire_obelisk_beam/cast(list/targets, mob/living/user = usr)
	if(istype(user, /mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk))
		var/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/obby = user
		if(world.time <= obby.beam_cooldown)
			to_chat(user,span_warning("Too soon!"))
			revert_cast()
			return FALSE
		obby.Activate(targets[1])
