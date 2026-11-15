/datum/action/cooldown/spell/baroness_summon
	name = "Defend Your Matriarch"
	desc = "Calls a skeletal knight to the Matriarch's side."
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "mob_ability"
	panel = null
	use_chance = 100
	cooldown_time = 180 SECONDS
	npc_max_range = 24
	npc_requires_los = FALSE

	click_to_activate = FALSE
	retrigger_after_cooldown = FALSE
	self_cast_possible = TRUE
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

/datum/action/cooldown/spell/baroness_summon/can_cast_spell(feedback = TRUE)
	return ..() && istype(owner, /mob/living/simple_animal/hostile/boss/baroness)

/datum/action/cooldown/spell/baroness_summon/can_use(atom/target)
	var/mob/living/simple_animal/hostile/boss/baroness/baroness = owner
	return ..() && baroness.health < baroness.phase_two_health

/datum/action/cooldown/spell/baroness_summon/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/hostile/boss/baroness/baroness = owner
	baroness.spawn_minions(baroness.minions_to_spawn)
	INVOKE_ASYNC(baroness, TYPE_PROC_REF(/atom/movable, say), "Defend your Matriarch!", null, list("colossus", "yell"))
	return TRUE
