/obj/effect/proc_holder/spell/invoked/raise_undead_formation
	name = "Raise Undead Formation"
	desc = "Invoke forbidden magicka to summon a cohort of mindless, shambling skeletons. </br>Mindless skeletons can be given orders to guard, patrol, and attack by their \
	summoner. </br>These skeletons are weaker than their more complex-jointed counterparts, but are harder to incapacitate."
	clothes_req = FALSE
	overlay_state = "animate"
	range = 7
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 6 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	gesture_required = TRUE // Summon spell
	associated_skill = /datum/skill/magic/arcane
	recharge_time = 20 SECONDS
	var/cabal_affine = FALSE
	var/is_summoned = FALSE
	var/to_spawn = 4
	var/spawn_lifespan
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/cast(list/targets, mob/living/user)
	..()

	if(istype(get_area(user), /area/rogue/indoors/ravoxarena))
		to_chat(user, span_userdanger("I reach for outer help, but something rebukes me! This challenge is only for me to overcome!"))
		revert_cast()
		return FALSE

	var/turf/T = get_turf(targets[1])
	if(!isopenturf(T))
		to_chat(user, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return FALSE

	for(var/i = 1 to to_spawn)
		if(i > 1)
			if(user.dir == NORTH || user.dir == SOUTH)
				T = get_step(T, prob(50) ? EAST : WEST)
			else
				T = get_step(T, prob(50) ? NORTH : SOUTH)

		if(!isopenturf(T))
			continue
		new /obj/effect/temp_visual/bluespace_fissure(T)
		var/skeleton_roll = rand(1,100)
		var/skeleton_type

		switch(skeleton_roll)
			if(1 to 20)
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/axe
			if(21 to 30)
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/spear
			if(31 to 60)
//				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/guard
			if(61 to 70)
//				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/bow
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/axe
			if(71 to 100)
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/guard

		var/mob/living/simple_animal/hostile/rogue/skeleton/S = new skeleton_type(T, user, cabal_affine)

		if(S && miracle)
			var/holyLV = user.get_skill_level(/datum/skill/magic/holy)
			var/bonus = max(0, holyLV - 1) * 2

			S.STASTR += bonus
			S.STASPD += bonus / 2 
			S.maxHealth += bonus * 75
			S.health = S.maxHealth

			var/aggro_range = 8

			for(var/mob/living/M in view(aggro_range, 7))
				if(M == S)
					continue
				if(M.stat == DEAD)
					continue
				if(M.mind)
					continue
				if(!M.ai_controller)
					continue
				if(M.faction_check_mob(S))
					continue

				M.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, S)
				M.ai_controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, S)

				var/datum/component/ai_aggro_system/aggro = M.GetComponent(/datum/component/ai_aggro_system)
				if(aggro)
					aggro.add_threat_to_mob(S, 50)

		apply_mob_lifespan(S, user, spawn_lifespan)

	return TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/necromancer
	cabal_affine = TRUE
	is_summoned = TRUE
	recharge_time = 35 SECONDS
	to_spawn = 3
