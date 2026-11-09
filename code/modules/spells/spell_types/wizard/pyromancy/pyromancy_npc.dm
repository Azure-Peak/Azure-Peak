#define WYRMFIRE_MODE_BALL 1
#define WYRMFIRE_MODE_ARTILLERY 2
#define WYRMFIRE_MODE_PILLAR 3
#define SCORCH_CHARRED_AT 4
#define SCORCH_FINISHER_BONUS 35
#define SCORCH_BUILD_BONUS 5
#define ARCED_SHOT_PENALTY 30
#define CURTAIN_VS_PLAYER_WEIGHT 0.4

/proc/pyro_npc_scorch_bonus(mob/living/victim, stacks)
	var/current = get_scorch_stacks(victim)
	if(current + stacks >= SCORCH_CHARRED_AT)
		return SCORCH_FINISHER_BONUS
	return current * SCORCH_BUILD_BONUS

/datum/action/cooldown/spell/projectile/spitfire
	npc_min_range = 1
	npc_max_range = 9

/datum/action/cooldown/spell/projectile/spitfire/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	. = 40
	if(get_dist(owner, victim) >= 3)
		. += 10
	if(npc_line_blocked(victim))
		. -= ARCED_SHOT_PENALTY
	. += pyro_npc_scorch_bonus(victim, 1)

/datum/action/cooldown/spell/ultio
	npc_min_range = 1
	npc_max_range = 7

/datum/action/cooldown/spell/ultio/npc_impact_turfs(atom/cast_on)
	var/turf/center = get_turf(cast_on)
	return center ? list(center) : list()

/datum/action/cooldown/spell/ultio/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	. = 40
	if(npc_target_stationary(victim))
		. += 25
	. += pyro_npc_scorch_bonus(victim, scorch_stacks)

/datum/action/cooldown/spell/ultio/npc_cast_target(atom/target)
	var/turf/aim = get_turf(target)
	if(!isliving(target) || !aim)
		return aim
	var/mob/living/victim = target
	if(npc_target_stationary(victim) || !victim.last_move)
		return aim
	var/turf/lead = get_step(aim, victim.last_move)
	if(!lead || lead.density || npc_allies_in(list(lead)))
		return aim
	if(!(lead in get_hear(cast_range, get_turf(owner))))
		return aim
	return lead

/datum/action/cooldown/spell/fire_curtain
	npc_min_range = 3
	npc_max_range = 6
	npc_escape = TRUE

/datum/action/cooldown/spell/fire_curtain/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	var/pinned = npc_target_pinned(victim)
	if(!pinned && !npc_target_closing(victim))
		return 0
	var/list/turfs = npc_curtain_turfs(victim)
	if(!length(turfs) || npc_allies_in(turfs))
		return 0
	for(var/turf/T as anything in turfs)
		if(get_dist(owner, T) < 2)
			return 0
	. = pinned ? 50 + pyro_npc_scorch_bonus(victim, 2) : 60
	if(victim.client)
		. *= CURTAIN_VS_PLAYER_WEIGHT

/datum/action/cooldown/spell/fire_curtain/npc_cast_target(atom/target)
	return npc_curtain_center(target)

/datum/action/cooldown/spell/fire_curtain/npc_strafes_while_charging()
	return FALSE

/datum/action/cooldown/spell/fire_curtain/npc_impact_turfs(atom/cast_on)
	var/turf/center = get_turf(cast_on)
	return center ? get_curtain_turfs(center, owner.dir) : list()

/datum/action/cooldown/spell/fire_curtain/proc/npc_curtain_center(atom/target)
	var/facing = npc_face_dir(owner, target)
	var/turf/victim_turf = get_turf(target)
	if(!victim_turf)
		return null
	if(isliving(target) && npc_target_pinned(target) && get_dist(owner, target) >= 3)
		return get_step(victim_turf, turn(facing, 180))
	return get_ranged_target_turf(get_turf(owner), facing, 2)

/datum/action/cooldown/spell/fire_curtain/proc/npc_curtain_turfs(atom/target)
	var/turf/center = npc_curtain_center(target)
	if(!center)
		return list()
	return get_curtain_turfs(center, npc_face_dir(owner, target))

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath
	npc_max_range = 4
	npc_escape = TRUE
	require_target_in_pattern = TRUE
	track_target = TRUE

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	var/list/turfs = get_pattern_turfs(owner, npc_face_dir(owner, victim))
	if(npc_allies_in(turfs) || npc_allies_in(npc_turfs_around(get_turf(victim), 1) - get_turf(owner)))
		return 0
	var/dist = get_dist(owner, victim)
	if(dist <= 2)
		. = 75
	else if(dist == 3)
		. = 60
	else
		. = 40
	if(npc_target_closing(victim))
		. += 10
	. += 15 * max(0, npc_hostiles_in(turfs) - 1)
	. += pyro_npc_scorch_bonus(victim, scorch_stacks)

/datum/action/cooldown/spell/projectile/fireball/barrage
	npc_min_range = 2
	npc_max_range = 9

/datum/action/cooldown/spell/projectile/fireball/barrage/npc_impact_turfs(atom/cast_on)
	var/radius = pillar_radius
	if(!modes[current_mode]["ground"])
		var/obj/projectile/magic/aoe/fireball/rogue/ball = (arc_mode && projectile_type_arc) ? projectile_type_arc : projectile_type
		radius = initial(ball.arcyne_aoe_radius)
	return npc_turfs_around(get_turf(cast_on), radius)

/datum/action/cooldown/spell/projectile/fireball/barrage/set_ai_aim_lock(turf/locked_turf)
	if(modes[current_mode]["ground"])
		aim_locked_turf = null
		return
	return ..()

/datum/action/cooldown/spell/projectile/fireball/barrage/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	var/wanted = WYRMFIRE_MODE_BALL
	if(victim.IsImmobilized() || victim.IsParalyzed() || victim.buckled)
		wanted = WYRMFIRE_MODE_PILLAR
	else if(npc_line_blocked(victim))
		wanted = WYRMFIRE_MODE_ARTILLERY
	if(wanted != current_mode)
		current_mode = wanted
		apply_mode(current_mode)
	var/list/blast = npc_impact_turfs(victim)
	if(npc_allies_in(blast))
		return 0
	var/hostiles = npc_hostiles_in(blast)
	. = 55 + 10 * max(0, hostiles - 1) + pyro_npc_scorch_bonus(victim, 2)
	if(wanted == WYRMFIRE_MODE_ARTILLERY)
		. -= ARCED_SHOT_PENALTY

/datum/action/cooldown/spell/projectile/fireball/barrage/npc_cast_target(atom/target)
	if(modes[current_mode]["ground"])
		return get_turf(target)
	return target

/datum/action/cooldown/spell/projectile/smoke_burst
	npc_min_range = 3
	npc_max_range = 8
	npc_escape = TRUE

/datum/action/cooldown/spell/projectile/smoke_burst/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	if(get_dist(owner, victim) >= 4 && npc_target_shooting(victim))
		return 50
	var/mob/living/caster = owner
	if(caster.health < caster.maxHealth * 0.5)
		return 45
	return 0

#undef WYRMFIRE_MODE_BALL
#undef WYRMFIRE_MODE_ARTILLERY
#undef WYRMFIRE_MODE_PILLAR
#undef SCORCH_CHARRED_AT
#undef SCORCH_FINISHER_BONUS
#undef SCORCH_BUILD_BONUS
#undef ARCED_SHOT_PENALTY
#undef CURTAIN_VS_PLAYER_WEIGHT
