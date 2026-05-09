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

	var/skeleton_roll

	for(var/i = 1 to to_spawn)
		if(i > 1)
			if(user.dir == NORTH || user.dir == SOUTH)
				if(prob(50))
					T = get_step(T, EAST)
				else
					T = get_step(T, WEST)
			else
				if(prob(50))
					T = get_step(T, NORTH)
				else
					T = get_step(T, SOUTH)

		if(!isopenturf(T))
			continue

		new /obj/effect/temp_visual/bluespace_fissure(T)

		skeleton_roll = rand(1,100)

		var/mob/living/simple_animal/hostile/rogue/skeleton/S

		switch(skeleton_roll)
			if(1 to 20)
				S = new /mob/living/simple_animal/hostile/rogue/skeleton/axe(T, user, cabal_affine)
			if(21 to 40)
				S = new /mob/living/simple_animal/hostile/rogue/skeleton/spear(T, user, cabal_affine)
			if(41 to 60)
				S = new /mob/living/simple_animal/hostile/rogue/skeleton/guard(T, user, cabal_affine)
			if(61 to 80)
				S = new /mob/living/simple_animal/hostile/rogue/skeleton/bow(T, user, cabal_affine)
			if(81 to 100)
				S = new /mob/living/simple_animal/hostile/rogue/skeleton/guard(T, user, cabal_affine)

		if(S && miracle)
			var/holyLV = user.get_skill_level(/datum/skill/magic/holy)
			var/bonus = max(0, holyLV - 1) * 2

			S.STACON += bonus * 2
			S.STASTR += bonus
			S.STASPD += bonus / 2

			to_chat(user, span_notice("Summoned [S] stats: STR [S.STASTR] | CON [S.STACON] | SPD [S.STASPD]"))

			var/aggro_range = 8

			for(var/mob/living/M in view(aggro_range, S))
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

		var/mob/living/skeletonnew
		switch(skeleton_roll)
			if(1 to 20)
				skeletonnew = new /mob/living/simple_animal/hostile/rogue/skeleton/axe(T, user, cabal_affine)
			if(21 to 40)
				skeletonnew = new /mob/living/simple_animal/hostile/rogue/skeleton/spear(T, user, cabal_affine)
			if(41 to 60)
				skeletonnew = new /mob/living/simple_animal/hostile/rogue/skeleton/guard(T, user, cabal_affine)
			if(61 to 80)
				skeletonnew = new /mob/living/simple_animal/hostile/rogue/skeleton/bow(T, user, cabal_affine)
			if(81 to 100)
				skeletonnew = new /mob/living/simple_animal/hostile/rogue/skeleton(T, user, cabal_affine)
		apply_mob_lifespan(skeletonnew, user, spawn_lifespan)
	return TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/necromancer
	cabal_affine = TRUE
	is_summoned = TRUE
	recharge_time = 35 SECONDS
	to_spawn = 3
