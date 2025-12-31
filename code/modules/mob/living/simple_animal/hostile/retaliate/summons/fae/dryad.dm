/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad	//Make this cause giant vine tangled messes
	icon = 'icons/mob/summonable/32x64.dmi'
	name = "dryad"
	desc = "A human-like figure formed of the flesh and bark of a tree, easier taller than a man. Guardians \
	of fae groves, and well-reputed for their vicioussness in the prosectuion of their duty."
	icon_state = "dryad"
	icon_living = "dryad"
	icon_dead = "vvd"
	summon_primer = "You are a dryad, a large sized fae. You spend time tending to forests, guarding sacred ground from tresspassers. Now you've been pulled from your home into a new world, that is decidedly less wild and natural. How you react to these events, only time can tell."
	summon_tier = 3
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 6
	see_in_dark = 6
	move_to_delay = 12
	base_intents = list(/datum/intent/simple/elementalt2_unarmed)
	butcher_results = list()
	faction = list("fae")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 650
	maxHealth = 650
	melee_damage_lower = 20
	melee_damage_upper = 30
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 18
	STASTR = 14
	STASPD = 4
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	canparry = TRUE
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = "plantcross"
	dodgetime = 30
	aggressive = 1
//	stat_attack = UNCONSCIOUS
	ranged = FALSE
	var/vine_cd
	inherent_spells = list(/obj/effect/proc_holder/spell/self/create_vines)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/Initialize()
	src.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/Move(newloc)	//vine movespeed buff
	.=..()
	if(isturf(newloc))
		var/turf/T = newloc
		if(contains_vines(T))
			src.move_to_delay = 6
			src.STASPD = 15
		else
			src.move_to_delay = 12
			src.STASPD = 4

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/proc/contains_vines(var/turf/T)
	for(var/obj/structure/vine/V in T)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)	//no wounding the watcher
	return

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/MoveToTarget(list/possible_targets)//Step 5, handle movement between us and our target
	stop_automated_movement = 1
	if(!target || !CanAttack(target))
		LoseTarget()
		return 0
	if(binded)
		return 0
	if(target in possible_targets)
		var/target_distance = get_dist(targets_from,target)
		if(ranged) //We ranged? Shoot at em
			if(!target.Adjacent(targets_from) && ranged_cooldown <= world.time) //But make sure they're not in range for a melee attack and our range attack is off cooldown
				OpenFire(target)
		if(world.time >= src.vine_cd + 100 && !mind)
			vine()
			src.vine_cd = world.time
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

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/proc/vine()
	visible_message(span_boldwarning("Vines spread out from [src]!"))
	for(var/turf/turf as anything in RANGE_TURFS(2,src.loc))
		if(!locate(/obj/structure/vine) in turf)
			new /obj/structure/vine(turf)
	src.vine_cd = world.time
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/death(gibbed)
	..()
	for(var/obj/structure/vine/V in view(src))
		qdel(V)
	src.visible_message(span_boldwarning("Vines near [src] wither as it returns to it's plane!"))
	var/turf/deathspot = get_turf(src)
	new /obj/item/magic/melded/t1(deathspot)
	new /obj/item/magic/iridescentscale(deathspot)
	new /obj/item/magic/iridescentscale(deathspot)
	new /obj/item/magic/heartwoodcore(deathspot)
	new /obj/item/magic/heartwoodcore(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	update_icon()
	spill_embedded_objects()
	qdel(src)

/obj/effect/proc_holder/spell/self/create_vines
	name = "Spawn Vines"
	recharge_time = 10 SECONDS
	sound = 'sound/magic/churn.ogg'
	overlay_state = "blesscrop"

/obj/effect/proc_holder/spell/self/create_vines/cast(list/targets, mob/living/user = usr)
	if(istype(user, /mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad))
		var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/treeguy = user
		if(world.time <= treeguy.vine_cd + 100)//shouldn't ever happen cuz the spell cd is the same as summon_cd but I'd rather it check with the internal cd just in case
			to_chat(user,span_warning("Too soon!"))
			revert_cast()
			return FALSE
		treeguy.vine()
		treeguy.vine_cd = world.time
