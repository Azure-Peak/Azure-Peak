#define SB_MOMENTUM_STALL (5 SECONDS)
#define SB_ULT_WAIT (6 SECONDS)
#define SB_HOLD_PENALTY 40
#define SB_DUMP_BONUS 25
#define SB_ULT_MAX_BONUS 20
#define SB_ULT_STRAIN_BONUS 50
#define SB_RECALL_SCORE 85
#define SB_EMPOWER_SCORE 45
#define SB_EMPOWER_SHIELD_BONUS 20

/datum/spellblade_chant/proc/apply_npc_chant(mob/living/carbon/human/H)
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M)
		M = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M)
		return
	M.chant = name
	for(var/spell_path in subclass_spells + base_spells)
		if((spell_path in GLOB.utility_spells) || (spell_path in GLOB.npc_skipped_spells))
			continue
		var/datum/action/cooldown/spell/new_spell = new spell_path(H)
		new_spell.Grant(H)
	for(var/obj/item/held in list(H.get_active_held_item(), H.get_inactive_held_item()))
		if(M.weapon_fits_chant(held))
			M.bind_conduit(held)
			return

/datum/action/cooldown/spell/proc/npc_momentum_status()
	var/mob/living/L = owner
	if(!istype(L))
		return null
	return L.has_status_effect(/datum/status_effect/buff/arcyne_momentum)

/datum/action/cooldown/spell/proc/npc_min_momentum()
	return 0

/datum/action/cooldown/spell/proc/npc_momentum_spend()
	return 0

/datum/action/cooldown/spell/proc/npc_momentum_ult(datum/status_effect/buff/arcyne_momentum/M)
	for(var/datum/action/cooldown/spell/spell in owner.actions)
		if(spell.npc_min_momentum() >= M.overcharge_threshold)
			return spell
	return null

/datum/action/cooldown/spell/proc/npc_momentum_adjust()
	var/datum/status_effect/buff/arcyne_momentum/M = npc_momentum_status()
	if(!M)
		return 0
	var/stalled = world.time - M.last_stack_time >= SB_MOMENTUM_STALL
	var/straining = stalled && M.stacks >= M.overcharge_threshold
	if(npc_min_momentum() >= M.overcharge_threshold)
		. = 0
		if(M.stacks >= M.max_stacks)
			. += SB_ULT_MAX_BONUS
		if(straining)
			. += SB_ULT_STRAIN_BONUS
		return
	var/spend = npc_momentum_spend()
	if(spend <= 0 || M.stacks < spend)
		return 0
	if(straining)
		return SB_DUMP_BONUS
	if(stalled || M.stacks - spend >= M.overcharge_threshold)
		return 0
	var/datum/action/cooldown/spell/ult = npc_momentum_ult(M)
	if(ult && ult.next_use_time - world.time <= SB_ULT_WAIT)
		return -SB_HOLD_PENALTY
	return 0

/datum/action/cooldown/spell/telegraphed_strike/spellblade
	npc_requires_bound_weapon = TRUE

/datum/action/cooldown/spell/telegraphed_strike/spellblade/npc_momentum_spend()
	return momentum_cost

/datum/action/cooldown/spell/air_strike
	npc_requires_bound_weapon = TRUE

/datum/action/cooldown/spell/air_strike/npc_momentum_spend()
	return momentum_cost

/datum/action/cooldown/spell/advance
	npc_requires_bound_weapon = TRUE

/datum/action/cooldown/spell/advance/npc_momentum_spend()
	return momentum_cost

/datum/action/cooldown/spell/projectile/azurean_pilum
	npc_requires_bound_weapon = TRUE

/datum/action/cooldown/spell/projectile/azurean_pilum/npc_momentum_spend()
	return momentum_cost

/datum/action/cooldown/spell/azurean_phalanx
	npc_requires_bound_weapon = TRUE

/datum/action/cooldown/spell/azurean_phalanx/npc_momentum_spend()
	return momentum_cost

/datum/action/cooldown/spell/caedo
	npc_requires_bound_weapon = TRUE

/datum/action/cooldown/spell/caedo/npc_momentum_spend()
	return empower_cost

/datum/action/cooldown/spell/blade_storm
	npc_requires_bound_weapon = TRUE

/datum/action/cooldown/spell/blade_storm/npc_min_momentum()
	return min_momentum

/datum/action/cooldown/spell/gate_of_reckoning
	npc_requires_bound_weapon = TRUE

/datum/action/cooldown/spell/gate_of_reckoning/npc_min_momentum()
	return min_momentum

/datum/action/cooldown/spell/cataclysm
	npc_requires_bound_weapon = TRUE

/datum/action/cooldown/spell/cataclysm/npc_min_momentum()
	return min_momentum

/datum/action/cooldown/spell/recall_weapon/can_use(atom/target)
	return isliving(owner)

/datum/action/cooldown/spell/recall_weapon/npc_cast_target(atom/target)
	return owner

/datum/action/cooldown/spell/recall_weapon/npc_use_chance(atom/target)
	var/mob/living/carbon/human/H = owner
	if(!istype(H) || !H.get_empty_held_indexes())
		return 0
	var/datum/status_effect/buff/arcyne_momentum/M = npc_momentum_status()
	if(!M?.bound_weapon || QDELETED(M.bound_weapon) || H.is_holding(M.bound_weapon))
		return 0
	return SB_RECALL_SCORE

/datum/action/cooldown/spell/empower_weapon/npc_min_momentum()
	return min_momentum

/datum/action/cooldown/spell/empower_weapon/npc_momentum_spend()
	var/datum/status_effect/buff/arcyne_momentum/M = npc_momentum_status()
	return M ? M.stacks : 0

/datum/action/cooldown/spell/empower_weapon/npc_cast_target(atom/target)
	return owner

/datum/action/cooldown/spell/empower_weapon/npc_use_chance(atom/target)
	var/mob/living/L = owner
	if(!istype(L) || L.has_status_effect(/datum/status_effect/buff/empowered_strike))
		return 0
	. = SB_EMPOWER_SCORE
	var/mob/living/victim = target
	if(isliving(victim) && (locate(/obj/item/rogueweapon/shield) in victim.held_items))
		. += SB_EMPOWER_SHIELD_BONUS

#undef SB_MOMENTUM_STALL
#undef SB_ULT_WAIT
#undef SB_HOLD_PENALTY
#undef SB_DUMP_BONUS
#undef SB_ULT_MAX_BONUS
#undef SB_ULT_STRAIN_BONUS
#undef SB_RECALL_SCORE
#undef SB_EMPOWER_SCORE
#undef SB_EMPOWER_SHIELD_BONUS
