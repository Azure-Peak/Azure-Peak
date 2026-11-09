#define CIRCUMDATUM_BASE_NEED 10
#define CIRCUMDATUM_ENGAGED_NEED 30
#define CIRCUMDATUM_WOUNDED_NEED 20
#define CIRCUMDATUM_BASE_SCORE 25
#define VOLLEY_MODE_CASCADE 1
#define VOLLEY_MODE_SEEKER 2
#define VOLLEY_MODE_SOULSHOT 3
#define TELO_EXPOSED_BONUS 10

/proc/telo_npc_exposed(mob/living/victim)
	return !!victim.has_status_effect(/datum/status_effect/debuff/exposed)

/proc/telo_npc_guarding(mob/living/victim)
	return !!victim.has_status_effect(/datum/status_effect/buff/clash)

/datum/action/cooldown/spell/circumdatum
	npc_max_range = 7
	npc_targets_allies = TRUE

/datum/action/cooldown/spell/circumdatum/npc_ally_need(mob/living/ally)
	if(!ishuman(ally) || ally.has_status_effect(/datum/status_effect/buff/circumdatum))
		return 0
	. = CIRCUMDATUM_BASE_NEED
	if(npc_ally_engaged(ally))
		. += CIRCUMDATUM_ENGAGED_NEED
	if(ally.maxHealth > 0)
		. += round(CIRCUMDATUM_WOUNDED_NEED * clamp(1 - ally.health / ally.maxHealth, 0, 1))

/datum/action/cooldown/spell/circumdatum/npc_use_chance(atom/target)
	var/mob/living/ally = target
	if(!isliving(ally))
		return 0
	var/need = npc_ally_need(ally)
	if(need <= 0)
		return 0
	return CIRCUMDATUM_BASE_SCORE + need

/datum/action/cooldown/spell/projectile/arcyne_volley
	npc_min_range = 1
	npc_max_range = 8

/datum/action/cooldown/spell/projectile/arcyne_volley/npc_can_fire_past_allies()
	return TRUE

/datum/action/cooldown/spell/projectile/arcyne_volley/proc/npc_set_mode(index)
	if(index != current_mode)
		current_mode = index
		apply_mode(current_mode)

/datum/action/cooldown/spell/projectile/arcyne_volley/set_ai_aim_lock(turf/locked_turf)
	if(modes[current_mode]["fire"] == "homing")
		aim_locked_turf = null
		return
	return ..()

/datum/action/cooldown/spell/projectile/arcyne_volley/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	var/guarded = telo_npc_guarding(victim)
	var/bonus = telo_npc_exposed(victim) ? TELO_EXPOSED_BONUS : 0
	if(npc_line_blocked(victim))
		if(guarded)
			return 0
		npc_set_mode(VOLLEY_MODE_SEEKER)
		return 45 + bonus
	if(!guarded)
		npc_set_mode(VOLLEY_MODE_SOULSHOT)
		var/list/pierce = get_impact_turfs(victim)
		var/hostiles = npc_hostiles_in(pierce)
		if(hostiles >= 2 && !npc_allies_in(pierce))
			return 55 + 10 * (hostiles - 2) + bonus
	npc_set_mode(VOLLEY_MODE_CASCADE)
	return 60 + bonus

/datum/action/cooldown/spell/void_beam
	npc_min_range = 2
	npc_max_range = 8

/datum/action/cooldown/spell/void_beam/npc_strafes_while_charging()
	return FALSE

/datum/action/cooldown/spell/void_beam/npc_hold_time()
	return beam_delay

/datum/action/cooldown/spell/void_beam/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim) || !npc_target_stationary(victim) || telo_npc_exposed(victim))
		return 0
	var/list/line = get_impact_turfs(victim)
	if(!(get_turf(victim) in line) || npc_allies_in(line))
		return 0
	return 70 + 10 * max(0, npc_hostiles_in(line) - 1)

/datum/action/cooldown/spell/arcyne_burst
	npc_min_range = 2
	npc_max_range = 7

/datum/action/cooldown/spell/arcyne_burst/npc_is_big_spell()
	return FALSE

/datum/action/cooldown/spell/arcyne_burst/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	var/list/area = get_impact_turfs(victim)
	if(!length(area) || npc_allies_in(area))
		return 0
	. = 55 + 10 * max(0, npc_hostiles_in(area) - 1)
	if(npc_target_stationary(victim))
		. += 20
	if(telo_npc_exposed(victim))
		. += TELO_EXPOSED_BONUS

#undef CIRCUMDATUM_BASE_NEED
#undef CIRCUMDATUM_ENGAGED_NEED
#undef CIRCUMDATUM_WOUNDED_NEED
#undef CIRCUMDATUM_BASE_SCORE
#undef VOLLEY_MODE_CASCADE
#undef VOLLEY_MODE_SEEKER
#undef VOLLEY_MODE_SOULSHOT
#undef TELO_EXPOSED_BONUS
