/datum/action/cooldown/lich
	abstract_type = /datum/action/cooldown/lich
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "mob_ability"
	check_flags = AB_CHECK_CONSCIOUS
	use_chance = 100
	npc_max_range = 24
	npc_requires_los = FALSE
	shared_cooldown = "lich"

/datum/action/cooldown/lich/IsAvailable()
	return ..() && istype(owner, /mob/living/simple_animal/hostile/boss/lich)

/datum/action/cooldown/lich/summon_minions
	name = "Minions, To Me"
	cooldown_time = 60 SECONDS
	lockout_time = 1 SECONDS

/datum/action/cooldown/lich/summon_minions/Activate(atom/target)
	var/mob/living/simple_animal/hostile/boss/lich/lich = owner
	lich.spawn_minions(lich.minions_to_spawn)
	INVOKE_ASYNC(lich, TYPE_PROC_REF(/atom/movable, say), "Minions, to me!", null, list("colossus", "yell"))
	StartCooldown()
	return TRUE

/datum/action/cooldown/lich/blink
	name = "Blink"
	cooldown_time = 12 SECONDS
	lockout_time = 2 SECONDS

/datum/action/cooldown/lich/blink/Activate(atom/target)
	var/mob/living/simple_animal/hostile/boss/lich/lich = owner
	if(!lich.blink?.cast_check(0, lich))
		return FALSE
	lich.blink.choose_targets(lich)
	lich.blink.invocations += pick(lich.taunt)
	StartCooldown()
	return TRUE

/datum/action/cooldown/lich/fireball_wave
	name = "Fireball Wave"
	cooldown_time = 30 SECONDS
	lockout_time = 10 SECONDS

/datum/action/cooldown/lich/fireball_wave/can_use(atom/target)
	var/mob/living/simple_animal/hostile/boss/lich/lich = owner
	return ..() && lich.health < lich.maxHealth * 0.33

/datum/action/cooldown/lich/fireball_wave/Activate(atom/target)
	var/mob/living/simple_animal/hostile/boss/lich/lich = owner
	INVOKE_ASYNC(lich, TYPE_PROC_REF(/atom/movable, say), "I am immortal, you are NOTHING!", null, list("colossus", "yell"))
	playsound(get_turf(lich), 'sound/magic/antimagic.ogg', 70, TRUE)
	lich.blaststrong(target)
	StartCooldown()
	return TRUE

/datum/action/cooldown/lich/projectile_wave
	name = "Projectile Wave"
	cooldown_time = 10 SECONDS
	lockout_time = 10 SECONDS

/datum/action/cooldown/lich/projectile_wave/Activate(atom/target)
	var/mob/living/simple_animal/hostile/boss/lich/lich = owner
	lich.blast(target)
	StartCooldown()
	return TRUE
