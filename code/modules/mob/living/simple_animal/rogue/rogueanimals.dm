

//these mobs run away when attacked
/mob/living/simple_animal/hostile/retaliate/rogue
	see_in_dark = 6
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	faction = list(FACTION_ROGUEANIMAL)
	blood_toll_bucket = STATS_KILLED_LESSER_BEASTS
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	attack_sound = PUNCHWOOSH
	health = 40
	maxHealth = 40
	minbodytemp = 180
	harm_intent_damage = 5
	environment_smash = ENVIRONMENT_SMASH_NONE
	blood_volume = BLOOD_VOLUME_NORMAL
	food_type = list(
		/obj/item/reagent_containers/food/snacks/grown
		)
	var/food_max = 50
	var/obj/item/udder/udder = null
	footstep_type = FOOTSTEP_MOB_SHOE
	var/milkies = FALSE
	tame_chance = 0
	dodge_sound = 'sound/combat/dodge.ogg'
	dodge_prob = 0

	var/deaggroprob = 10
	var/eat_forever

	var/summon_tier = 0 // Tier of summoning
	var/summon_primer = null // The message they get when summoned
	var/list/death_loot = list() // Items spawned on death — cleared for bound creatures

	//If the creature is doing something they should STOP MOVING.
	var/can_act = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/Move()
	//If you cant act and dont have a player stop moving.
	if(!can_act && !client)
		return FALSE
	..()

/mob/living/simple_animal/hostile/retaliate/rogue/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE)
	. = ..()
	if(damagetype == BRUTE)
		if(damage > 5 && prob(damage * 3))
			emote("pain")
		if(damage > 10)
			shake_camera(src, 1, 1)
		if(show_redflash())
			if(damage < 10)
				flash_fullscreen("redflash1")
			else if(damage < 20)
				flash_fullscreen("redflash2")
			else if(damage >= 20)
				flash_fullscreen("redflash3")
	if(damagetype == BURN)
		if(damage > 10 && prob(damage))
			emote("pain")
			shake_camera(src, 1, 1)
		if(show_redflash())
			if(damage < 10)
				flash_fullscreen("redflash1")
			else if(damage < 20)
				flash_fullscreen("redflash2")
			else if(damage >= 20)
				flash_fullscreen("redflash3")

/mob/living/simple_animal/hostile/retaliate/rogue/death(gibbed)
	emote("death")
	..(gibbed)
	if(length(death_loot))
		var/turf/deathspot = get_turf(src)
		for(var/loot_path in death_loot)
			for(var/i in 1 to death_loot[loot_path])
				new loot_path(deathspot)

/mob/living/simple_animal/hostile/retaliate/rogue/AttackingTarget()
	//If you can't act and dont have a player stop moving.
	if(!can_act && !client)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/Initialize(mapload)
	. = ..()
	if(milkies)
		udder = new()
	if(tame)
		tamed()
	ADD_TRAIT(src, TRAIT_SIMPLE_WOUNDS, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/rogue/tamed(mob/user)
	aggressive = 0
	if(ai_controller?.has_aggro())
		if(prob(23))
			ai_controller.clear_aggro()
			src.visible_message(span_notice("[src] calms down."))
		else
			return
	if(user)
		friends |= user
	..()

/mob/living/simple_animal/hostile/retaliate/rogue/Destroy()
	QDEL_NULL(udder)
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/Life()
	. = ..()
	if(.)
		if(ai_controller?.has_aggro())
			if(prob(4))
				emote("cidle")
			if(prob(deaggroprob) && world.time > ai_controller.blackboard[BB_LAST_HIT_TIME] + 30 SECONDS)
				ai_controller.clear_aggro()
				src.visible_message(span_info("[src] calms down."))
		else
			if(prob(2)) //Plays an idle sound
				emote("idle")

			if(adult_growth)
				growth_prog += 0.5
				if(growth_prog >= 100)
					if(isturf(loc))
						var/mob/living/simple_animal/A = new adult_growth(loc)
						if(tame)
							A.tame = TRUE
						qdel(src)
						return
			else
				if(childtype)
					make_babies()
		if(udder)
			if(production > 0)
				production--
				udder.generateMilk()

/mob/living/simple_animal/hostile/retaliate/rogue/attackby(obj/item/O, mob/user, params)
	if(!stat && istype(O, /obj/item/reagent_containers/glass))
		if(udder)
			udder.milkAnimal(O, user)
			return 1
	else
		return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/shood(mob/user)
	if(tame && !(user in friends))
		ai_controller?.force_aggro(user)

/mob/living/simple_animal/hostile/retaliate/rogue/onkick(mob/M)
	..()
	ai_controller?.force_aggro(M)

/mob/living/simple_animal/hostile/retaliate/rogue/beckoned(mob/user)
	if(tame)
		ai_controller?.travel_for(user, 3 SECONDS)

/mob/living/simple_animal/hostile/retaliate/rogue/food_tempted(obj/item/O, mob/user)
	if(food_typecache?[O.type])
		ai_controller?.travel_for(user, 3 SECONDS)
