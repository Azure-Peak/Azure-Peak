#define PHAL_GATE_SCORE 90
#define PHAL_PHALANX_SCORE 40
#define PHAL_EXTRA_HOSTILE_BONUS 15
#define PHAL_PILUM_SCORE 35
#define PHAL_PILUM_FROST_BONUS 20
#define PHAL_ADVANCE_SCORE 45
#define PHAL_ADVANCE_STILL_BONUS 15

/datum/action/cooldown/spell/gate_of_reckoning
	npc_max_range = 3

/datum/action/cooldown/spell/gate_of_reckoning/npc_cast_target(atom/target)
	return owner

/datum/action/cooldown/spell/gate_of_reckoning/npc_use_chance(atom/target)
	var/mob/living/L = owner
	if(!istype(L) || L.has_status_effect(/datum/status_effect/buff/gate_phalanx))
		return 0
	return PHAL_GATE_SCORE

/datum/action/cooldown/spell/gate_of_reckoning/npc_after_cast(datum/ai_controller/controller)
	var/mob/living/L = owner
	if(!istype(L))
		return
	var/datum/status_effect/buff/gate_phalanx/gate = L.has_status_effect(/datum/status_effect/buff/gate_phalanx)
	if(gate)
		controller.set_blackboard_key(BB_MELEE_CLOSE_IN_UNTIL, gate.duration)

/datum/action/cooldown/spell/azurean_phalanx
	npc_max_range = 2

/datum/action/cooldown/spell/azurean_phalanx/npc_cast_target(atom/target)
	return owner

/datum/action/cooldown/spell/azurean_phalanx/proc/npc_pierce_turfs(mob/living/victim)
	. = list()
	var/turf/current = get_turf(victim)
	var/pierce_dir = get_dir(owner, victim)
	if(!current || !pierce_dir)
		return
	var/datum/status_effect/buff/arcyne_momentum/M = npc_momentum_status()
	var/length = (M && M.stacks >= momentum_cost) ? empowered_pierce_length : pierce_length
	for(var/i in 1 to length)
		current = get_step(current, pierce_dir)
		if(!current || current.density)
			return
		for(var/obj/structure/S in current.contents)
			if(S.density && !S.climbable)
				return
		. += current

/datum/action/cooldown/spell/azurean_phalanx/npc_use_chance(atom/target)
	var/mob/living/L = owner
	var/mob/living/victim = target
	if(!istype(L) || !isliving(victim) || L.has_status_effect(/datum/status_effect/buff/phalanx_ready))
		return 0
	var/list/line = npc_pierce_turfs(victim)
	if(npc_allies_in(line))
		return 0
	return PHAL_PHALANX_SCORE + PHAL_EXTRA_HOSTILE_BONUS * npc_hostiles_in(line)

/datum/action/cooldown/spell/projectile/azurean_pilum
	npc_min_range = 3
	npc_max_range = 7

/datum/action/cooldown/spell/projectile/azurean_pilum/npc_use_chance(atom/target)
	var/mob/living/L = owner
	var/mob/living/victim = target
	if(!istype(L) || !isliving(victim) || L.has_status_effect(/datum/status_effect/buff/gate_phalanx))
		return 0
	. = PHAL_PILUM_SCORE
	var/datum/status_effect/buff/arcyne_momentum/M = npc_momentum_status()
	if(!M || M.stacks < momentum_cost)
		return
	if(victim.has_status_effect(/datum/status_effect/debuff/frosted1) || victim.has_status_effect(/datum/status_effect/debuff/frosted2) || victim.has_status_effect(/datum/status_effect/debuff/frosted3))
		. += PHAL_PILUM_FROST_BONUS

/datum/action/cooldown/spell/advance
	npc_min_range = 2
	npc_max_range = 5

/datum/action/cooldown/spell/advance/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	var/list/strike = get_impact_turfs(victim)
	if(!(get_turf(victim) in strike) || npc_allies_in(strike))
		return 0
	. = PHAL_ADVANCE_SCORE
	if(npc_target_stationary(victim))
		. += PHAL_ADVANCE_STILL_BONUS

#undef PHAL_GATE_SCORE
#undef PHAL_PHALANX_SCORE
#undef PHAL_EXTRA_HOSTILE_BONUS
#undef PHAL_PILUM_SCORE
#undef PHAL_PILUM_FROST_BONUS
#undef PHAL_ADVANCE_SCORE
#undef PHAL_ADVANCE_STILL_BONUS
