#define SPELLFIST_EXTRA_HOSTILE_BONUS 15
#define FIST_SCORE 40
#define FIST_STILL_BONUS 20
#define GRASP_SCORE 35
#define GRASP_SHOOTER_BONUS 25
#define GRASP_STILL_BONUS 15
#define STORM_FULL_SCORE 70
#define STORM_WEAK_SCORE 10
#define SHADOWSTEP_SCORE 35
#define SHADOWSTEP_SHOOTER_BONUS 25

/datum/spellblade_chant/unarmed
	name = "unarmed"
	npc_only = TRUE

/datum/spellblade_chant/unarmed/chant_spells()
	return list(
		/datum/action/cooldown/spell/fist_of_psydon,
		/datum/action/cooldown/spell/grasp_of_psydon,
		/datum/action/cooldown/spell/blink/shadowstep,
		/datum/action/cooldown/spell/storm_of_psydon,
		/datum/action/cooldown/spell/empower_weapon,
		/datum/action/cooldown/spell/mending,
	)

/datum/action/cooldown/spell/fist_of_psydon
	npc_min_range = 1
	npc_max_range = 5

/datum/action/cooldown/spell/fist_of_psydon/npc_momentum_spend()
	return momentum_cost

/datum/action/cooldown/spell/fist_of_psydon/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	var/list/footprint = get_impact_turfs(victim)
	if(npc_allies_in(footprint))
		return 0
	. = FIST_SCORE + SPELLFIST_EXTRA_HOSTILE_BONUS * max(0, npc_hostiles_in(footprint) - 1)
	if(npc_target_stationary(victim))
		. += FIST_STILL_BONUS

/datum/action/cooldown/spell/grasp_of_psydon
	npc_min_range = 2
	npc_max_range = 5

/datum/action/cooldown/spell/grasp_of_psydon/npc_momentum_spend()
	return momentum_cost

/datum/action/cooldown/spell/grasp_of_psydon/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim) || npc_line_blocked(victim) || npc_line_obstructed(victim))
		return 0
	var/list/footprint = get_impact_turfs(victim)
	if(npc_allies_in(footprint))
		return 0
	. = GRASP_SCORE + SPELLFIST_EXTRA_HOSTILE_BONUS * max(0, npc_hostiles_in(footprint) - 1)
	if(npc_target_shooting(victim))
		. += GRASP_SHOOTER_BONUS
	if(npc_target_stationary(victim))
		. += GRASP_STILL_BONUS

/datum/action/cooldown/spell/storm_of_psydon
	npc_max_range = 7

/datum/action/cooldown/spell/storm_of_psydon/npc_min_momentum()
	return min_momentum

/datum/action/cooldown/spell/storm_of_psydon/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim) || victim.anti_magic_check(chargecost = 0) || !dash_reaches(victim))
		return 0
	var/datum/status_effect/buff/arcyne_momentum/M = npc_momentum_status()
	if(!M)
		return 0
	return M.stacks >= empowered_momentum ? STORM_FULL_SCORE : STORM_WEAK_SCORE

/datum/action/cooldown/spell/blink/shadowstep
	npc_min_range = 3
	npc_max_range = 6
	var/turf/npc_landing

/datum/action/cooldown/spell/blink/shadowstep/proc/npc_landing_ok(turf/T)
	var/turf/start = get_turf(owner)
	if(!T || !start || T == start || get_dist(start, T) > max_range)
		return FALSE
	if(locate(/mob/living) in T)
		return FALSE
	return !arcyne_validate_blink_dest(T, owner) && !arcyne_validate_blink_path(start, T)

/datum/action/cooldown/spell/blink/shadowstep/npc_use_chance(atom/target)
	npc_landing = null
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	for(var/step_dir in shuffle(GLOB.cardinals))
		var/turf/T = get_step(victim, step_dir)
		if(npc_landing_ok(T))
			npc_landing = T
			break
	if(!npc_landing)
		return 0
	. = SHADOWSTEP_SCORE
	if(npc_target_shooting(victim))
		. += SHADOWSTEP_SHOOTER_BONUS

/datum/action/cooldown/spell/blink/shadowstep/npc_cast_target(atom/target)
	var/turf/landing = npc_landing
	npc_landing = null
	return landing || get_turf(owner)

/datum/action/cooldown/spell/blink/shadowstep/npc_cast_safe(atom/cast_on)
	if(!npc_landing_ok(get_turf(cast_on)))
		return FALSE
	return ..()

#undef SPELLFIST_EXTRA_HOSTILE_BONUS
#undef FIST_SCORE
#undef FIST_STILL_BONUS
#undef GRASP_SCORE
#undef GRASP_SHOOTER_BONUS
#undef GRASP_STILL_BONUS
#undef STORM_FULL_SCORE
#undef STORM_WEAK_SCORE
#undef SHADOWSTEP_SCORE
#undef SHADOWSTEP_SHOOTER_BONUS
