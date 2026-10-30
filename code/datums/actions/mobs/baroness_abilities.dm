/datum/action/cooldown/baroness_summon
	name = "Defend Your Matriarch"
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "mob_ability"
	check_flags = AB_CHECK_CONSCIOUS
	use_chance = 100
	npc_max_range = 24
	npc_requires_los = FALSE
	cooldown_time = 180 SECONDS

/datum/action/cooldown/baroness_summon/IsAvailable()
	return ..() && istype(owner, /mob/living/simple_animal/hostile/boss/baroness)

/datum/action/cooldown/baroness_summon/can_use(atom/target)
	var/mob/living/simple_animal/hostile/boss/baroness/baroness = owner
	return ..() && baroness.health < baroness.phase_two_health

/datum/action/cooldown/baroness_summon/Activate(atom/target)
	var/mob/living/simple_animal/hostile/boss/baroness/baroness = owner
	baroness.spawn_minions(baroness.minions_to_spawn)
	INVOKE_ASYNC(baroness, TYPE_PROC_REF(/atom/movable, say), "Defend your Matriarch!", null, list("colossus", "yell"))
	StartCooldown()
	return TRUE
