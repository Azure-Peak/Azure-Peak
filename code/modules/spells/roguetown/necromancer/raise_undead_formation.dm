/datum/action/cooldown/spell/raise_undead_formation
	name = "Raise Undead Formation"
	desc = "Invoke forbidden magicka to summon a cohort of mindless, shambling skeletons.\nMindless skeletons can be given orders to guard, patrol, and attack by their summoner.\nThese skeletons are weaker than their more complex-jointed counterparts, but are harder to incapacitate."
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "skeleton_formation"
	cast_range = 7
	sound = 'sound/magic/magnet.ogg'
	primary_resource_cost = 40
	primary_resource_type = SPELL_COST_STAMINA
	charge_required = TRUE
	charge_time = 6 SECONDS
	charge_slowdown = 1
	associated_skill = /datum/skill/magic/arcane
	cooldown_time = 20 SECONDS
	zizo_spell = TRUE
	invocation_type = INVOCATION_SHOUT
	invocations = list("Evoca skeletos!")
	var/cabal_affine = FALSE
	var/is_summoned = FALSE
	var/to_spawn = 4
	var/spawn_lifespan

/datum/action/cooldown/spell/raise_undead_formation/cast(atom/cast_on)
	. = ..()

	if(istype(get_area(owner), /area/rogue/indoors/ravoxarena))
		to_chat(owner, span_userdanger("I reach for outer help, but something rebukes me! This challenge is only for me to overcome!"))
		reset_spell_cooldown()
		return FALSE

	var/turf/T = get_turf(cast_on)
	if(!isopenturf(T))
		to_chat(owner, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return FALSE

	for(var/i = 1 to to_spawn)
		if(i > to_spawn)
			i = 1

		if(i > 1)
			if(owner.dir == NORTH || owner.dir == SOUTH)
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
		var/skeleton_roll = rand(1, 100)
		var/mob/living/skeletonnew
		switch(skeleton_roll)
			if(1 to 20)
				skeletonnew = new /mob/living/simple_animal/hostile/rogue/skeleton/axe(T, owner, cabal_affine)
			if(21 to 40)
				skeletonnew = new /mob/living/simple_animal/hostile/rogue/skeleton/spear(T, owner, cabal_affine)
			if(41 to 60)
				skeletonnew = new /mob/living/simple_animal/hostile/rogue/skeleton/guard(T, owner, cabal_affine)
			if(61 to 80)
				skeletonnew = new /mob/living/simple_animal/hostile/rogue/skeleton/bow(T, owner, cabal_affine)
			if(81 to 100)
				skeletonnew = new /mob/living/simple_animal/hostile/rogue/skeleton(T, owner, cabal_affine)
		apply_mob_lifespan(skeletonnew, owner, spawn_lifespan)
	return TRUE

/datum/action/cooldown/spell/raise_undead_formation/necromancer
	cabal_affine = TRUE
	is_summoned = TRUE
	cooldown_time = 35 SECONDS
	to_spawn = 3
