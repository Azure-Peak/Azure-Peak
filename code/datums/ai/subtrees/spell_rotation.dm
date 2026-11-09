#define CASTER_DEFAULT_RESERVE 0.75
#define NPC_SPELL_RETRY_DELAY (4 SECONDS)
#define NPC_STATIONARY_TIME (2 SECONDS)
#define CASTER_CHARGE_KEEP_DISTANCE 3
#define CASTER_CHARGE_STRAFE_GRACE (1 SECONDS)
#define NPC_POKE_COOLDOWN_SLACK (2 SECONDS)
#define NPC_BIG_SPELL_SPACING (10 SECONDS)
#define NPC_BIG_SPELL_PATIENCE 40

/datum/ai_planning_subtree/spell_rotation
	var/target_key = BB_BASIC_MOB_CURRENT_TARGET
	var/spell_key = BB_CHOSEN_ACTION
	var/cast_behavior = /datum/ai_behavior/targeted_mob_ability/spell_rotation
	var/score_floor = 20
	var/score_jitter = 10

/datum/ai_planning_subtree/spell_rotation/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/target = controller.blackboard[target_key]
	var/mob/living/caster = controller.pawn
	if(!isliving(target) || target.stat == DEAD || !isliving(caster) || caster.doing)
		return
	if(world.time < controller.blackboard[BB_CASTER_NEXT_CAST])
		return
	var/datum/action/cooldown/spell/best
	var/atom/best_target
	var/best_score = score_floor
	for(var/datum/action/cooldown/spell/spell in caster.actions)
		if(world.time < spell.npc_retry_at || !spell.npc_within_reserve(controller) || !spell.IsAvailable())
			continue
		var/atom/spell_target = spell.npc_targets_allies ? spell.npc_pick_ally() : target
		if(!spell_target || !spell.can_use(spell_target))
			continue
		var/score = spell.npc_use_chance(spell_target)
		if(score <= 0)
			continue
		if(!controller.blackboard[BB_CASTER_MELEE] && world.time < controller.blackboard[BB_CASTER_BIG_READY_AT] && spell.npc_is_big_spell())
			score -= NPC_BIG_SPELL_PATIENCE
		score += rand(-score_jitter, score_jitter)
		if(score > best_score)
			best = spell
			best_target = spell_target
			best_score = score
	if(!best)
		return
	controller.set_blackboard_key(spell_key, best)
	controller.set_blackboard_key(BB_CASTER_SPELL_TARGET, best_target)
	controller.queue_behavior(cast_behavior, spell_key, BB_CASTER_SPELL_TARGET)

/datum/ai_behavior/targeted_mob_ability/spell_rotation
	action_cooldown = 1 SECONDS

/datum/ai_behavior/targeted_mob_ability/spell_rotation/perform(seconds_per_tick, datum/ai_controller/controller, ability_key, target_key)
	var/datum/action/cooldown/ability = controller.blackboard[ability_key]
	var/atom/target = controller.blackboard[target_key]
	if(istype(ability, /datum/action/cooldown/spell) && !QDELETED(target) && !controller.blackboard[BB_CASTER_MELEE])
		INVOKE_ASYNC(src, PROC_REF(strafe_while_charging), controller, ability, target)
	. = ..()
	var/datum/action/cooldown/spell/spell = ability
	if(istype(spell) && spell.npc_aborted)
		spell.npc_aborted = FALSE
		if(spell.charge_required && spell.is_cancel_penalized())
			spell.apply_cancel_penalty(TRUE)
	if(. & AI_BEHAVIOR_SUCCEEDED)
		controller.set_blackboard_key(BB_CASTER_NEXT_CAST, world.time + npc_cast_gap(controller.pawn))
		if(!controller.blackboard[BB_CASTER_MELEE] && istype(spell) && spell.npc_is_big_spell())
			controller.set_blackboard_key(BB_CASTER_BIG_READY_AT, world.time + NPC_BIG_SPELL_SPACING)
		if(istype(spell) && spell.npc_hold_time() > 0)
			controller.set_blackboard_key(BB_CASTER_HOLD_UNTIL, world.time + spell.npc_hold_time())
		if(!istype(ability, /datum/action/cooldown/spell/telegraphed_strike))
			controller.clear_blackboard_key(BB_ABILITY_COMMITTED_UNTIL)
		return
	if(!QDELETED(ability))
		ability.npc_retry_at = world.time + NPC_SPELL_RETRY_DELAY

/datum/ai_behavior/targeted_mob_ability/spell_rotation/proc/strafe_while_charging(datum/ai_controller/controller, datum/action/cooldown/spell/spell, atom/target)
	if(!spell.charge_required || spell.charge_time <= 0 || !spell.npc_strafes_while_charging())
		return
	var/give_up_at = world.time + spell.charge_time + CASTER_CHARGE_STRAFE_GRACE
	sleep(world.tick_lag)
	while(world.time < give_up_at)
		if(QDELETED(controller) || QDELETED(spell) || QDELETED(target) || !spell.currently_charging)
			return
		if(COOLDOWN_FINISHED(controller, movement_cooldown))
			ai_strafe_step(controller, target, CASTER_CHARGE_KEEP_DISTANCE)
		sleep(world.tick_lag)

/proc/npc_cast_gap(mob/living/caster)
	if(!isliving(caster))
		return 5 SECONDS
	return clamp(5 SECONDS - (caster.STAINT - 8) * (0.5 SECONDS), 2 SECONDS, 5 SECONDS)

/datum/ai_planning_subtree/spacing/ranged/caster
	finish_planning = TRUE
	commit_distance = 1

/datum/ai_planning_subtree/spacing/ranged/caster/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	if(world.time < controller.blackboard[BB_CASTER_HOLD_UNTIL])
		return SUBTREE_RETURN_FINISH_PLANNING
	return ..()

/datum/ai_planning_subtree/spacing/ranged/caster/is_ready_to_attack(datum/ai_controller/controller, mob/living/living_pawn)
	for(var/datum/action/cooldown/spell/spell in living_pawn.actions)
		if(spell.npc_escape || spell.npc_max_range <= 1)
			continue
		if(spell.npc_within_reserve(controller) && spell.IsAvailable())
			return TRUE
	return FALSE

/datum/action/cooldown/spell
	var/npc_aborted = FALSE
	var/npc_targets_allies = FALSE
	var/npc_requires_bound_weapon = FALSE

/datum/action/cooldown/spell/proc/npc_on_spawn(mob/living/carbon/human/H)
	return

/datum/action/cooldown/spell/can_use(atom/target)
	if(npc_requires_bound_weapon && (!ishuman(owner) || !arcyne_get_weapon(owner)))
		return FALSE
	return ..()

/datum/action/cooldown/spell/proc/npc_pick_ally()
	var/mob/living/caster = owner
	var/mob/living/best
	var/best_need = 0
	for(var/mob/living/carbon/human/ally in view(npc_max_range, caster))
		if(ally == caster || ally.stat == DEAD || !npc_is_ally(ally))
			continue
		var/need = npc_ally_need(ally)
		if(need > best_need)
			best = ally
			best_need = need
	return best

/datum/action/cooldown/spell/proc/npc_ally_need(mob/living/ally)
	return 1

/datum/action/cooldown/spell/proc/npc_ally_engaged(mob/living/ally)
	for(var/mob/living/other in orange(1, ally))
		if(other.stat != DEAD && !npc_is_ally(other))
			return TRUE
	return FALSE

/datum/action/cooldown/spell/proc/npc_cast_safe(atom/cast_on)
	return !npc_allies_in(get_impact_turfs(cast_on))

/datum/action/cooldown/spell/proc/npc_hold_time()
	return 0

/datum/action/cooldown/spell/proc/npc_is_poke()
	return primary_resource_cost <= SPELLCOST_MINOR_PROJECTILE && cooldown_time <= SPELL_COOLDOWN_POKE + NPC_POKE_COOLDOWN_SLACK

/datum/action/cooldown/spell/proc/npc_is_big_spell()
	return !npc_escape && !npc_targets_allies && !npc_is_poke()

/datum/action/cooldown/spell/proc/npc_stamina_cost()
	. = 0
	if(primary_resource_type == SPELL_COST_STAMINA)
		. += get_adjusted_cost(primary_resource_cost)
	if(secondary_resource_type == SPELL_COST_STAMINA)
		. += get_adjusted_cost(secondary_resource_cost)

/datum/action/cooldown/spell/proc/npc_within_reserve(datum/ai_controller/controller)
	if(npc_escape)
		return TRUE
	var/mob/living/caster = owner
	if(!isliving(caster))
		return FALSE
	var/reserve = controller.blackboard[BB_CASTER_RESERVE] || CASTER_DEFAULT_RESERVE
	return caster.stamina + npc_stamina_cost() <= caster.max_stamina * reserve

/datum/action/cooldown/spell/proc/npc_strafes_while_charging()
	return !(spell_requirements & SPELL_REQUIRES_NO_MOVE)

/datum/action/cooldown/spell/proc/npc_target_pinned(mob/living/victim)
	if(!isliving(victim))
		return FALSE
	if(victim.IsImmobilized() || victim.IsKnockdown() || victim.IsStun() || victim.IsParalyzed())
		return TRUE
	return !(victim.mobility_flags & MOBILITY_STAND) || victim.buckled || victim.pulledby

/datum/action/cooldown/spell/proc/npc_target_stationary(mob/living/victim)
	if(npc_target_pinned(victim))
		return TRUE
	return isliving(victim) && world.time - victim.last_move_time > NPC_STATIONARY_TIME

/datum/action/cooldown/spell/proc/npc_target_closing(mob/living/victim)
	if(!isliving(victim) || !victim.last_move)
		return FALSE
	if(world.time - victim.last_move_time > 1 SECONDS)
		return FALSE
	return !!(get_dir(victim, owner) & victim.last_move)

/datum/action/cooldown/spell/proc/npc_target_shooting(mob/living/victim)
	if(!isliving(victim))
		return FALSE
	if(victim.channeling_spell)
		return TRUE
	if(!iscarbon(victim))
		return FALSE
	var/mob/living/carbon/C = victim
	return istype(C.get_active_held_item(), /obj/item/gun) || istype(C.get_inactive_held_item(), /obj/item/gun)

/datum/action/cooldown/spell/proc/npc_line_blocked(atom/target)
	var/mob/living/shooter = owner
	for(var/turf/T in getline(shooter, target))
		for(var/mob/living/blocker in T)
			if(blocker == shooter || blocker == target)
				continue
			if(shooter.faction_check_mob(blocker))
				return TRUE
	return FALSE

/datum/action/cooldown/spell/proc/npc_is_ally(mob/living/other)
	if(other == owner)
		return TRUE
	return other.stat != DEAD && owner.faction_check_mob(other)

/datum/action/cooldown/spell/proc/npc_allies_in(list/turfs)
	for(var/turf/T as anything in turfs)
		for(var/mob/living/other in T)
			if(npc_is_ally(other))
				return TRUE
	return FALSE

/datum/action/cooldown/spell/proc/npc_hostiles_in(list/turfs)
	. = 0
	for(var/turf/T as anything in turfs)
		for(var/mob/living/other in T)
			if(other.stat == DEAD || npc_is_ally(other))
				continue
			.++

/datum/action/cooldown/spell/proc/npc_turfs_around(turf/center, radius)
	. = list()
	if(!center)
		return
	for(var/turf/T in range(radius, center))
		. += T

#undef CASTER_DEFAULT_RESERVE
#undef NPC_SPELL_RETRY_DELAY
#undef NPC_STATIONARY_TIME
#undef CASTER_CHARGE_KEEP_DISTANCE
#undef CASTER_CHARGE_STRAFE_GRACE
#undef NPC_POKE_COOLDOWN_SLACK
#undef NPC_BIG_SPELL_SPACING
#undef NPC_BIG_SPELL_PATIENCE
