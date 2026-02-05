/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "fiend"
	desc = "A much larger relative of the common infernal imp, this otherworldly creature stands to an impressive height \
	and breadth. Whenever it ceases to move its body freezes to a complete standstill, as if it were a gargoyle."
	icon_state = "fiend"
	icon_living = "fiend"
	icon_dead = "vvd"
	summon_primer = "You are fiend, a large sized demon from the infernal plane. You have imps and hounds at your beck and call, able to do whatever you wished. Now you've been pulled from your home into a new world, that is decidedly lacking in fire. How you react to these events, only time can tell."
	summon_tier = 4
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 10
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list()
	faction = list("infernal")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 700
	maxHealth = 700
	obj_damage = 150
	melee_damage_lower = 20
	melee_damage_upper = 30
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	retreat_distance = 4
	minimum_distance = 4
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STAWIL = 15
	STACON = 13
	STASTR = 12
	STASPD = 8
	simple_detect_bonus = 20
	deaggroprob = 0
	canparry = TRUE
	defprob = 50
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = list('sound/misc/lava_death.ogg')
	dodgetime = 30
	aggressive = 1
	ranged = TRUE
	rapid = TRUE
	projectiletype = /obj/projectile/magic/aoe/fireball/rogue/great
	ranged_message = "throws fire"
	var/flame_cd = 0
	var/summon_cd = 0
	inherent_spells = list(/obj/effect/proc_holder/spell/self/call_infernals,
	/obj/effect/proc_holder/spell/invoked/fiend_meteor)

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend/death(gibbed)
	..()
	var/turf/deathspot = get_turf(src)
	new /obj/item/magic/infernal/flame(deathspot)
	new /obj/item/magic/infernal/core(deathspot)
	new /obj/item/magic/infernal/core(deathspot)
	new /obj/item/magic/infernal/fang(deathspot)
	new /obj/item/magic/infernal/fang(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/melded/t2(deathspot)
	update_icon()
	spill_embedded_objects()
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend/OpenFire(atom/A)
	if(CheckFriendlyFire(A))
		return
	visible_message(span_danger("<b>[src]</b> [ranged_message] at [A]!"))

	if(world.time >= src.flame_cd + 250 && !mind)
		var/mob/living/targetted = target
		create_meteors(targetted)
		src.flame_cd = world.time

	if(world.time >= src.summon_cd + 200 && !mind)
		callforbackup()

		src.summon_cd = world.time

	if(rapid > 1)
		var/datum/callback/cb = CALLBACK(src, PROC_REF(Shoot), A)
		for(var/i in 1 to rapid)
			addtimer(cb, (i - 1)*rapid_fire_delay)
	else
		Shoot(A)
	ranged_cooldown = world.time + ranged_cooldown_time

/obj/effect/proc_holder/spell/invoked/fiend_meteor
	name = "Meteor storm"
	desc = "Summons forth dangerous meteors from the sky to scatter and smash foes."
	overlay_state = "meteor_storm"
	recharge_time = 20 SECONDS
	chargetime = 0
	range = 15
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/invoked/fiend_meteor/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(targets[1])
	playsound(T,'sound/magic/meteorstorm.ogg', 80, TRUE)
	sleep(2)
	create_meteors(T)

/obj/effect/proc_holder/spell/invoked/fiend_meteor/proc/create_meteors(atom/target)
	if(!target)
		return
	target.visible_message(span_boldwarning("Fire rains from the sky!"))
	var/turf/targetturf = get_turf(target)
	for(var/turf/turf as anything in RANGE_TURFS(4,targetturf))
		if(prob(20))
			new /obj/effect/temp_visual/target(turf)

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend/proc/create_meteors(atom/target)
	if(!target)
		return
	target.visible_message(span_boldwarning("Fire rains from the sky!"))
	var/turf/targetturf = get_turf(target)
	for(var/turf/turf as anything in RANGE_TURFS(4,targetturf))
		if(prob(20))
			new /obj/effect/temp_visual/target(turf)

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend/proc/callforbackup()
	var/list/spawnLists = list(/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp,
	/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp,
	/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound,
	/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound)
	var/reinforcement_count = 3
	src.visible_message(span_notice("[src] summons reinforcements from the infernal abyss."))
	while(reinforcement_count > 0)
		var/list/turflist = list()
		for(var/turf/t in RANGE_TURFS(1, src))
			turflist += t

		var/turf/picked = pick(turflist)


		var/spawnTypes = pick_n_take(spawnLists)
		new spawnTypes(picked)
		reinforcement_count--
		continue

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)	//no wounding the fiend
	return

/obj/effect/proc_holder/spell/self/call_infernals
	name = "Call Infernals"
	recharge_time = 20 SECONDS
	sound = list('sound/magic/whiteflame.ogg')
	overlay_state = "burning"

/obj/effect/proc_holder/spell/self/call_infernals/cast(list/targets, mob/living/user = usr)
	if(istype(user, /mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend))
		var/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend/demonguy = user
		if(world.time <= demonguy.summon_cd + 200)//shouldn't ever happen cuz the spell cd is the same as summon_cd but I'd rather it check with the internal cd just in case
			to_chat(user,span_warning("Too soon!"))
			revert_cast()
			return FALSE
		demonguy.callforbackup()
		demonguy.say("To me, my minions!")
		demonguy.summon_cd = world.time
