#define RIMECAST_MODE_LANCE 1
#define RIMECAST_MODE_BURST 2
#define CRYO_FROST_TIER_BONUS 10
#define CRYO_EXTRA_HOSTILE_BONUS 15
#define CRYO_SHARDS_SCORE 55
#define CRYO_LANCE_SCORE 50
#define CRYO_BURST_SCORE 45
#define CRYO_VERGLAS_SCORE 35
#define CRYO_VERGLAS_CLOSING_BONUS 15
#define CRYO_VERGLAS_ALLY_MARGIN 2
#define CRYO_WALL_SCORE 60

/proc/cryo_npc_frost_tier(mob/living/victim)
	if(victim.has_status_effect(/datum/status_effect/debuff/frosted3))
		return 3
	if(victim.has_status_effect(/datum/status_effect/debuff/frosted2))
		return 2
	if(victim.has_status_effect(/datum/status_effect/debuff/frosted1))
		return 1
	return 0

/datum/action/cooldown/spell/projectile/frost_shards
	npc_min_range = 1
	npc_max_range = 4

/datum/action/cooldown/spell/projectile/frost_shards/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	return CRYO_SHARDS_SCORE + CRYO_FROST_TIER_BONUS * cryo_npc_frost_tier(victim)

/datum/action/cooldown/spell/projectile/rimecast
	npc_min_range = 2
	npc_max_range = 8

/datum/action/cooldown/spell/projectile/rimecast/npc_can_fire_past_allies()
	return TRUE

/datum/action/cooldown/spell/projectile/rimecast/proc/npc_set_mode(index)
	if(index != current_mode)
		current_mode = index
		apply_mode(current_mode)

/datum/action/cooldown/spell/projectile/rimecast/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	var/bonus = CRYO_FROST_TIER_BONUS * cryo_npc_frost_tier(victim)
	if(!npc_line_blocked(victim))
		npc_set_mode(RIMECAST_MODE_LANCE)
		var/list/line = get_impact_turfs(victim)
		var/pierced = npc_hostiles_in(line)
		if(pierced && !npc_allies_in(line))
			return CRYO_LANCE_SCORE + CRYO_EXTRA_HOSTILE_BONUS * (pierced - 1) + bonus
	npc_set_mode(RIMECAST_MODE_BURST)
	var/list/blast = get_impact_turfs(victim)
	if(!length(blast) || npc_allies_in(blast))
		return 0
	return CRYO_BURST_SCORE + CRYO_EXTRA_HOSTILE_BONUS * max(0, npc_hostiles_in(blast) - 1) + bonus

/datum/action/cooldown/spell/verglas
	npc_min_range = 5
	npc_max_range = 7

/datum/action/cooldown/spell/verglas/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(verglas_mode != initial(verglas_mode) || !isliving(victim) || npc_target_shooting(victim))
		return 0
	var/list/patch = get_impact_turfs(victim)
	if(!length(patch) || npc_allies_in(get_visible_area_turfs(get_turf(victim), verglas_radius + CRYO_VERGLAS_ALLY_MARGIN)))
		return 0
	. = CRYO_VERGLAS_SCORE + CRYO_EXTRA_HOSTILE_BONUS * max(0, npc_hostiles_in(patch) - 1)
	if(npc_target_closing(victim))
		. += CRYO_VERGLAS_CLOSING_BONUS

/datum/action/cooldown/spell/forcewall/ice
	npc_min_range = 2
	npc_max_range = 3
	npc_escape = TRUE

/datum/action/cooldown/spell/forcewall/ice/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim) || npc_target_shooting(victim) || !npc_target_closing(victim))
		return 0
	var/facing = npc_face_dir(owner, victim)
	var/turf/front = get_step(owner, facing)
	if(!front)
		return 0
	for(var/turf/T as anything in wall_turfs(front, facing))
		if(T.density || (locate(/mob/living) in T))
			return 0
	return CRYO_WALL_SCORE

/datum/action/cooldown/spell/forcewall/ice/npc_cast_target(atom/target)
	var/facing = npc_face_dir(owner, target)
	owner.setDir(facing)
	return get_step(owner, facing)

#undef RIMECAST_MODE_LANCE
#undef RIMECAST_MODE_BURST
#undef CRYO_FROST_TIER_BONUS
#undef CRYO_EXTRA_HOSTILE_BONUS
#undef CRYO_SHARDS_SCORE
#undef CRYO_LANCE_SCORE
#undef CRYO_BURST_SCORE
#undef CRYO_VERGLAS_SCORE
#undef CRYO_VERGLAS_CLOSING_BONUS
#undef CRYO_VERGLAS_ALLY_MARGIN
#undef CRYO_WALL_SCORE
