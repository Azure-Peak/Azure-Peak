/datum/action/cooldown/spell/lich
	abstract_type = /datum/action/cooldown/spell/lich
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "mob_ability"
	panel = null
	use_chance = 100
	shared_cooldown = "mob_special"
	npc_max_range = 24
	npc_requires_los = FALSE
	cast_range = 24

	click_to_activate = TRUE
	retrigger_after_cooldown = FALSE
	self_cast_possible = FALSE
	invocations = list()
	invocation_type = INVOCATION_NONE
	sound = null
	primary_resource_type = SPELL_COST_NONE
	spell_requirements = SPELL_REQUIRES_SAME_Z
	associated_stat = null
	has_visual_effects = FALSE
	glow_intensity = 0
	spell_impact_intensity = SPELL_IMPACT_NONE
	blocked_by_antimagic = FALSE
	charge_required = FALSE

/datum/action/cooldown/spell/lich/can_cast_spell(feedback = TRUE)
	return ..() && istype(owner, /mob/living/simple_animal/hostile/boss/lich)

/datum/action/cooldown/spell/lich/summon_minions
	name = "Minions, To Me"
	desc = "Raises a mob of skeletons around the caster."
	cooldown_time = 60 SECONDS
	lockout_time = 1 SECONDS
	click_to_activate = FALSE
	self_cast_possible = TRUE

/datum/action/cooldown/spell/lich/summon_minions/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/hostile/boss/lich/lich = owner
	lich.spawn_minions(lich.minions_to_spawn)
	INVOKE_ASYNC(lich, TYPE_PROC_REF(/atom/movable, say), "Minions, to me!", null, list("colossus", "yell"))
	return TRUE

/datum/action/cooldown/spell/lich/blink
	name = "Blink"
	desc = "Vanishes in a puff of smoke and reappears a short distance away."
	cooldown_time = 12 SECONDS
	lockout_time = 2 SECONDS
	click_to_activate = FALSE
	self_cast_possible = TRUE
	invocations = list("Witness my power!", "Die!", "Suffer!")
	invocation_type = INVOCATION_SHOUT
	smoke_type = /datum/effect_system/smoke_spread
	var/inner_tele_radius = 5
	var/outer_tele_radius = 6

/datum/action/cooldown/spell/lich/blink/cast(atom/cast_on)
	. = ..()
	var/list/turfs = list()
	for(var/turf/T in range(outer_tele_radius, owner))
		if(get_dist(owner, T) <= inner_tele_radius || T.density || T.teleport_restricted)
			continue
		turfs += T
	if(!length(turfs))
		return FALSE
	return do_teleport(owner, pick(turfs), forceMove = TRUE, channel = TELEPORT_CHANNEL_MAGIC)

/datum/action/cooldown/spell/lich/fireball_wave
	name = "Fireball Wave"
	desc = "Fires a fan of greater fireballs at the target."
	cooldown_time = 30 SECONDS
	lockout_time = 10 SECONDS

/datum/action/cooldown/spell/lich/fireball_wave/can_use(atom/target)
	var/mob/living/simple_animal/hostile/boss/lich/lich = owner
	return ..() && lich.health < lich.maxHealth * 0.33

/datum/action/cooldown/spell/lich/fireball_wave/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/hostile/boss/lich/lich = owner
	INVOKE_ASYNC(lich, TYPE_PROC_REF(/atom/movable, say), "I am immortal, you are NOTHING!", null, list("colossus", "yell"))
	playsound(get_turf(lich), 'sound/magic/antimagic.ogg', 70, TRUE)
	lich.blaststrong(cast_on)
	return TRUE

/datum/action/cooldown/spell/lich/projectile_wave
	name = "Projectile Wave"
	desc = "Fires a fan of random projectiles at the target."
	cooldown_time = 10 SECONDS
	lockout_time = 10 SECONDS

/datum/action/cooldown/spell/lich/projectile_wave/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/hostile/boss/lich/lich = owner
	lich.blast(cast_on)
	return TRUE
