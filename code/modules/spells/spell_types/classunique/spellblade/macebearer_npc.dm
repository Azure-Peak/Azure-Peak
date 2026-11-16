#define MACE_SHATTER_SCORE 45
#define MACE_TREMOR_SCORE 40
#define MACE_CHARGE_SCORE 40
#define MACE_CHARGE_MIN_GAIN 3
#define MACE_CATACLYSM_SCORE 70
#define MACE_EXTRA_HOSTILE_BONUS 15
#define MACE_STILL_BONUS 15
#define MACE_TRACK_CUTOFF 4

/datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter
	npc_max_range = 3
	require_target_in_pattern = TRUE
	track_target = TRUE
	track_cutoff = MACE_TRACK_CUTOFF

/datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter/npc_use_chance(atom/target)
	return npc_strike_score(target, MACE_SHATTER_SCORE, MACE_EXTRA_HOSTILE_BONUS)

/datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor
	npc_max_range = 1
	require_target_in_pattern = TRUE
	track_target = TRUE
	track_cutoff = MACE_TRACK_CUTOFF

/datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor/npc_use_chance(atom/target)
	return npc_strike_score(target, MACE_TREMOR_SCORE, MACE_EXTRA_HOSTILE_BONUS)

/datum/action/cooldown/spell/charge
	npc_min_range = 5
	npc_max_range = 9

/datum/action/cooldown/spell/charge/proc/npc_charge_end(facing)
	var/turf/current = get_turf(owner)
	for(var/i in 1 to charge_steps)
		var/turf/next = get_step(current, facing)
		if(!next || next.density)
			return current
		for(var/obj/structure/S in next.contents)
			if(S.density)
				return current
		current = next
	return current

/datum/action/cooldown/spell/charge/npc_use_chance(atom/target)
	if(!isliving(target))
		return 0
	var/turf/end = npc_charge_end(npc_face_dir(owner, target))
	if(get_dist(end, target) > get_dist(owner, target) - MACE_CHARGE_MIN_GAIN)
		return 0
	return MACE_CHARGE_SCORE

/datum/action/cooldown/spell/charge/npc_cast_target(atom/target)
	owner.setDir(npc_face_dir(owner, target))
	return owner

/datum/action/cooldown/spell/cataclysm
	npc_max_range = 7

/datum/action/cooldown/spell/cataclysm/npc_use_chance(atom/target)
	if(!isliving(target))
		return 0
	var/list/footprint = get_impact_turfs(target)
	if(npc_allies_in(footprint))
		return 0
	. = MACE_CATACLYSM_SCORE + MACE_EXTRA_HOSTILE_BONUS * max(0, npc_hostiles_in(footprint) - 1)
	if(npc_target_stationary(target))
		. += MACE_STILL_BONUS

/datum/action/cooldown/spell/cataclysm/npc_cast_target(atom/target)
	return npc_lead_turf(target, charge_time + delay)

#undef MACE_SHATTER_SCORE
#undef MACE_TREMOR_SCORE
#undef MACE_CHARGE_SCORE
#undef MACE_CHARGE_MIN_GAIN
#undef MACE_CATACLYSM_SCORE
#undef MACE_EXTRA_HOSTILE_BONUS
#undef MACE_STILL_BONUS
#undef MACE_TRACK_CUTOFF
