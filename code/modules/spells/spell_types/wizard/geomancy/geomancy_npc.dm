#define MENHIR_NPC_HEAVE_REACH 4
#define GEAS_NPC_ROOT_REACH 5

/datum/action/cooldown/spell/projectile/gravel_blast
	npc_min_range = 1
	npc_max_range = 6

/datum/action/cooldown/spell/projectile/gravel_blast/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	if(npc_allies_in(get_impact_turfs(victim)))
		return 0
	. = 45
	if(victim.has_status_effect(/datum/status_effect/debuff/vulnerable))
		. += 15

/datum/action/cooldown/spell/tumult
	npc_min_range = 2
	npc_max_range = 7

/datum/action/cooldown/spell/tumult/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	var/list/area = get_impact_turfs(victim)
	if(!length(area) || npc_allies_in(area))
		return 0
	. = 45 + 10 * max(0, npc_hostiles_in(area) - 1)
	if(npc_target_stationary(victim))
		. += 25

/datum/action/cooldown/spell/menhir
	npc_min_range = 2
	npc_max_range = 7

/datum/action/cooldown/spell/menhir/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	var/sure_hit = npc_target_stationary(victim)
	var/heave_viable = !npc_line_blocked(victim) && !npc_line_obstructed(victim) && get_dist(owner, victim) <= MENHIR_NPC_HEAVE_REACH
	set_drop_mode(TRUE)
	var/list/drop_area = get_impact_turfs(victim)
	if(!npc_allies_in(drop_area) && (sure_hit || !heave_viable))
		return 50 + 10 * max(0, npc_hostiles_in(drop_area) - 1) + (sure_hit ? 25 : 0)
	if(!heave_viable)
		return 0
	set_drop_mode(FALSE)
	return 40

/datum/action/cooldown/spell/menhir/npc_cast_safe(atom/cast_on)
	if(!is_drop_mode() && (npc_line_blocked(cast_on) || npc_line_obstructed(cast_on)))
		return FALSE
	return ..()

/datum/action/cooldown/spell/geas
	npc_min_range = 2
	npc_max_range = 7
	npc_escape = TRUE

/datum/action/cooldown/spell/geas/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim) || npc_target_pinned(victim))
		return 0
	var/list/area = get_impact_turfs(victim)
	if(npc_allies_in(area))
		return 0
	var/hostiles = npc_hostiles_in(area)
	if(npc_target_closing(victim) && get_dist(owner, victim) <= GEAS_NPC_ROOT_REACH)
		return 55 + 10 * max(0, hostiles - 1)
	if(hostiles >= 2)
		return 45 + 10 * (hostiles - 2)
	return 0

#undef MENHIR_NPC_HEAVE_REACH
#undef GEAS_NPC_ROOT_REACH
