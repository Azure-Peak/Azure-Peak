#define ARC_BOLT_MODE_CHAIN 1
#define ARC_BOLT_MODE_FOCUS 2
#define ARC_BOLT_MODE_ARC 3
#define FULMINATION_MODE_STRIKE 1
#define FULMINATION_MODE_STORM 2
#define FULG_ARCED_PENALTY 30
#define FULG_LEVIN_TOO_CLOSE 2
#define FULG_LEVIN_LINEUP 2

/proc/fulg_npc_shock_ready(mob/living/victim)
	var/last = victim.mob_timers[MT_LIGHTNING_ADAPTATION]
	return !last || world.time > last + LIGHTNING_ADAPTATION_COOLDOWN

/proc/fulg_npc_shocked(mob/living/victim)
	return !!victim.has_status_effect(/datum/status_effect/buff/lightningstruck)

/datum/action/cooldown/spell/projectile/arc_bolt
	npc_min_range = 1
	npc_max_range = 7

/datum/action/cooldown/spell/projectile/arc_bolt/npc_can_lob()
	return TRUE

/datum/action/cooldown/spell/projectile/arc_bolt/proc/npc_set_mode(index)
	if(index != current_mode)
		current_mode = index
		apply_mode(current_mode)

/datum/action/cooldown/spell/projectile/arc_bolt/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	if(npc_line_blocked(victim))
		npc_set_mode(ARC_BOLT_MODE_ARC)
		return 45 - FULG_ARCED_PENALTY
	npc_set_mode(ARC_BOLT_MODE_CHAIN)
	var/list/chain = get_impact_turfs(victim)
	if(npc_allies_in(chain))
		npc_set_mode(ARC_BOLT_MODE_FOCUS)
		return 45
	return 45 + 10 * max(0, npc_hostiles_in(chain) - 1)

/datum/action/cooldown/spell/projectile/lightning_bolt
	npc_min_range = 1
	npc_max_range = 7

/datum/action/cooldown/spell/projectile/lightning_bolt/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	if(!fulg_npc_shock_ready(victim))
		return 25
	. = 60
	if(npc_target_closing(victim))
		. += 15

/datum/action/cooldown/spell/fulmination
	npc_min_range = 2
	npc_max_range = 6

/datum/action/cooldown/spell/fulmination/proc/npc_set_mode(index)
	if(index != current_mode)
		current_mode = index
		apply_mode(current_mode)

/datum/action/cooldown/spell/fulmination/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	var/slowed = fulg_npc_shocked(victim) || npc_target_pinned(victim)
	npc_set_mode(FULMINATION_MODE_STORM)
	var/list/storm = get_impact_turfs(victim)
	var/hostiles = npc_hostiles_in(storm)
	if(!npc_allies_in(storm) && (slowed || hostiles >= 2))
		return 55 + 10 * max(0, hostiles - 1) + (slowed ? 20 : 0)
	npc_set_mode(FULMINATION_MODE_STRIKE)
	if(npc_allies_in(get_impact_turfs(victim)))
		return 0
	. = 45
	if(slowed || npc_target_stationary(victim))
		. += 20

/datum/action/cooldown/spell/levinstroke
	npc_max_range = 4
	npc_escape = TRUE
	var/datum/weakref/npc_line_ref

/datum/action/cooldown/spell/levinstroke/npc_strafes_while_charging()
	return FALSE

/datum/action/cooldown/spell/levinstroke/proc/npc_line_hostiles(atom/through)
	var/list/path = get_impact_turfs(through)
	if(!length(path) || npc_allies_in(path))
		return 0
	return npc_hostiles_in(path)

/datum/action/cooldown/spell/levinstroke/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	var/victim_count = npc_line_hostiles(victim)
	var/mob/living/best = victim
	var/best_count = victim_count
	for(var/mob/living/other in view(npc_max_range, owner))
		if(other == victim || other.stat == DEAD || npc_is_ally(other))
			continue
		var/count = npc_line_hostiles(other)
		if(count > best_count)
			best = other
			best_count = count
	if(get_dist(owner, victim) <= FULG_LEVIN_TOO_CLOSE && victim_count)
		if(best_count < FULG_LEVIN_LINEUP)
			best = victim
			best_count = victim_count
		npc_line_ref = WEAKREF(best)
		return 60 + 10 * max(0, best_count - 1)
	if(best_count >= FULG_LEVIN_LINEUP)
		npc_line_ref = WEAKREF(best)
		return 50 + 10 * (best_count - FULG_LEVIN_LINEUP)
	npc_line_ref = null
	return 0

/datum/action/cooldown/spell/levinstroke/npc_cast_target(atom/target)
	var/atom/line_target = npc_line_ref?.resolve()
	npc_line_ref = null
	return line_target || target

#undef ARC_BOLT_MODE_CHAIN
#undef ARC_BOLT_MODE_FOCUS
#undef ARC_BOLT_MODE_ARC
#undef FULMINATION_MODE_STRIKE
#undef FULMINATION_MODE_STORM
#undef FULG_ARCED_PENALTY
#undef FULG_LEVIN_TOO_CLOSE
#undef FULG_LEVIN_LINEUP
