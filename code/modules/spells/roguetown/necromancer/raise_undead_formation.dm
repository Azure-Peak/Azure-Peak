/datum/action/cooldown/spell/raise_undead_formation
	name = "Raise Undead Formation"
	desc = "Invoke forbidden magicka to summon a cohort of mindless, shambling skeletons.\nMindless skeletons can be given orders to guard, patrol, and attack by their summoner.\nThese skeletons are weaker than their more complex-jointed counterparts, but are harder to incapacitate."
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "skeleton_formation"
	cast_range = 7
	sound = 'sound/magic/magnet.ogg'
	primary_resource_cost = 40
	primary_resource_type = SPELL_COST_STAMINA
	charge_required = TRUE
	charge_time = 3 SECONDS //Quick for combat, useless outside of it mostly.
	charge_slowdown = 1
	associated_skill = /datum/skill/magic/arcane
	cooldown_time = 25 SECONDS
	zizo_spell = TRUE
	invocation_type = INVOCATION_SHOUT
	invocations = list("Evoca skeletos!")
	var/miracle = FALSE
	var/cabal_affine = FALSE
	var/is_summoned = FALSE
	var/to_spawn = 4
	var/spawn_lifespan

/datum/action/cooldown/spell/raise_undead_formation/cast(atom/cast_on)
	. = ..()

	if(!owner)
		return FALSE

	if(istype(get_area(owner), /area/rogue/indoors/ravoxarena))
		to_chat(owner, span_userdanger("I reach for outer help, but something rebukes me! This challenge is only for me to overcome!"))
		reset_spell_cooldown()
		return FALSE

	var/turf/T = get_turf(cast_on)
	if(!isopenturf(T))
		to_chat(owner, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return FALSE

	for(var/i = 1 to to_spawn)
		var/turf/spawn_turf = T

		if(i > 1)
			if(owner.dir == NORTH || owner.dir == SOUTH)
				spawn_turf = get_step(T, prob(50) ? EAST : WEST)
			else
				spawn_turf = get_step(T, prob(50) ? NORTH : SOUTH)

		if(!isopenturf(spawn_turf) || spawn_turf.is_blocked_turf())
			continue

		new /obj/effect/temp_visual/bluespace_fissure(spawn_turf)

		var/skeleton_roll = rand(1,100)
		var/skeleton_type

		switch(skeleton_roll)
			if(1 to 20)
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/axe
			if(21 to 30)
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/spear
			if(31 to 60)
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/guard
			if(61 to 70)
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/axe
			if(71 to 100)
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/guard

		var/mob/living/simple_animal/hostile/rogue/skeleton/S = new skeleton_type(spawn_turf, owner, cabal_affine)

		if(!S)
			continue

		if(miracle)
			var/holyLV = owner.get_skill_level(/datum/skill/magic/holy)
			var/bonus = max(0, holyLV - 1) * 2

			S.STASTR += bonus
			S.STASPD += round(bonus / 2)
			S.maxHealth += bonus * 50
			S.health = S.maxHealth

		var/aggro_range = 8

		for(var/mob/living/M in view(aggro_range, S))
			if(M == S)
				continue
			if(M.stat == DEAD)
				continue
			if(M.mind)
				continue
			if(M.faction_check_mob(S))
				continue
			if(M.faction_check_mob(owner))
				continue

			M.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, S)
			M.ai_controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, S)

			var/datum/component/ai_aggro_system/aggro = M.GetComponent(/datum/component/ai_aggro_system)
			
			if(aggro)
				aggro.add_threat_to_mob(S, 100)

		apply_mob_lifespan(S, owner, spawn_lifespan)

	return TRUE

/datum/action/cooldown/spell/raise_undead_formation/necromancer
	cabal_affine = TRUE
	is_summoned = TRUE
	cooldown_time = 40 SECONDS
	to_spawn = 3
