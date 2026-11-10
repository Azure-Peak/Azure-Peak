#define BLADE_CAEDO_SCORE 45
#define BLADE_AIR_SCORE 40
#define BLADE_STORM_SCORE 70
#define BLADE_EXTRA_HOSTILE_BONUS 15
#define BLADE_STILL_BONUS 15
#define BLADE_AIR_RESOLVE_DELAY 2
#define BLADE_ANCHOR_SCORE 30
#define BLADE_ANCHOR_RANGE 3
#define BLADE_ANCHOR_HEALTH 0.7
#define BLADE_RECALL_SCORE 90
#define BLADE_RECALL_HEALTH 0.4
#define BLADE_RECALL_CROWD 2

/datum/action/cooldown/spell/caedo
	npc_max_range = 4
	var/datum/weakref/npc_line_ref

/datum/action/cooldown/spell/caedo/proc/npc_line_hostiles(atom/through)
	var/list/path = get_impact_turfs(through)
	if(!length(path) || npc_allies_in(path))
		return 0
	return npc_hostiles_in(path)

/datum/action/cooldown/spell/caedo/npc_use_chance(atom/target)
	var/mob/living/victim = target
	npc_line_ref = null
	if(!isliving(victim))
		return 0
	var/mob/living/best = victim
	var/best_count = npc_line_hostiles(victim)
	for(var/mob/living/other in view(npc_max_range, owner))
		if(other == victim || other.stat == DEAD || npc_is_ally(other))
			continue
		var/count = npc_line_hostiles(other)
		if(count > best_count)
			best = other
			best_count = count
	if(!best_count)
		return 0
	npc_line_ref = WEAKREF(best)
	return BLADE_CAEDO_SCORE + BLADE_EXTRA_HOSTILE_BONUS * (best_count - 1)

/datum/action/cooldown/spell/caedo/npc_cast_target(atom/target)
	var/atom/line_target = npc_line_ref?.resolve() || target
	npc_line_ref = null
	if(isliving(line_target))
		return find_landing_turf(owner, npc_lead_turf(line_target, charge_time))
	return get_turf(line_target)

/datum/action/cooldown/spell/air_strike
	npc_max_range = 4
	var/datum/intent/npc_intent

/datum/action/cooldown/spell/air_strike/npc_use_chance(atom/target)
	var/mob/living/L = owner
	var/mob/living/victim = target
	npc_intent = null
	if(!istype(L) || !isliving(victim))
		return 0
	var/turf/origin = get_turf(victim)
	var/facing = get_dir(get_turf(L), origin) || L.dir
	var/best_value = 0
	var/best_count = 0
	for(var/datum/intent/intent in L.possible_a_intents)
		var/list/turfs = strike_turfs(origin, facing, intent.blade_class)
		if(npc_allies_in(turfs))
			continue
		var/count = npc_hostiles_in(turfs)
		var/value = count * strike_damage(intent.blade_class)
		if(value > best_value)
			best_value = value
			best_count = count
			npc_intent = intent
	if(!npc_intent)
		return 0
	. = BLADE_AIR_SCORE + BLADE_EXTRA_HOSTILE_BONUS * max(0, best_count - 1)
	if(npc_target_stationary(victim))
		. += BLADE_STILL_BONUS

/datum/action/cooldown/spell/air_strike/npc_cast_target(atom/target)
	var/mob/living/L = owner
	if(istype(L) && npc_intent && (npc_intent in L.possible_a_intents))
		L.a_intent = npc_intent
		L.used_intent = npc_intent
	npc_intent = null
	return npc_lead_turf(target, charge_time + BLADE_AIR_RESOLVE_DELAY)

/datum/action/cooldown/spell/leyline_anchor
	npc_escape = TRUE

/datum/action/cooldown/spell/leyline_anchor/can_use(atom/target)
	return isliving(owner)

/datum/action/cooldown/spell/leyline_anchor/npc_cast_target(atom/target)
	return owner

/datum/action/cooldown/spell/leyline_anchor/npc_use_chance(atom/target)
	var/mob/living/L = owner
	if(!istype(L) || !target)
		return 0
	var/health_ratio = L.health / L.maxHealth
	if(!active_portal || QDELETED(active_portal))
		if(health_ratio < BLADE_ANCHOR_HEALTH || get_dist(L, target) > BLADE_ANCHOR_RANGE)
			return 0
		return BLADE_ANCHOR_SCORE
	if(L.pulledby || L.restrained() || L.buckled)
		return 0
	var/turf/portal_turf = get_turf(active_portal)
	if(!portal_turf || portal_turf.z != L.z || get_dist(L, portal_turf) > max_range || get_dist(portal_turf, target) <= 1)
		return 0
	if(health_ratio < BLADE_RECALL_HEALTH || npc_hostiles_in(npc_turfs_around(get_turf(L), 1)) >= BLADE_RECALL_CROWD)
		return BLADE_RECALL_SCORE
	return 0

/datum/action/cooldown/spell/blade_storm
	npc_max_range = 7

/datum/action/cooldown/spell/blade_storm/npc_use_chance(atom/target)
	if(!isliving(target))
		return 0
	var/list/footprint = get_impact_turfs(target)
	if(npc_allies_in(footprint))
		return 0
	. = BLADE_STORM_SCORE + BLADE_EXTRA_HOSTILE_BONUS * max(0, npc_hostiles_in(footprint) - 1)
	if(npc_target_stationary(target))
		. += BLADE_STILL_BONUS

/datum/action/cooldown/spell/blade_storm/npc_cast_target(atom/target)
	return npc_lead_turf(target, charge_time + telegraph_delay)

#undef BLADE_CAEDO_SCORE
#undef BLADE_AIR_SCORE
#undef BLADE_STORM_SCORE
#undef BLADE_EXTRA_HOSTILE_BONUS
#undef BLADE_STILL_BONUS
#undef BLADE_AIR_RESOLVE_DELAY
#undef BLADE_ANCHOR_SCORE
#undef BLADE_ANCHOR_RANGE
#undef BLADE_ANCHOR_HEALTH
#undef BLADE_RECALL_SCORE
#undef BLADE_RECALL_HEALTH
#undef BLADE_RECALL_CROWD
