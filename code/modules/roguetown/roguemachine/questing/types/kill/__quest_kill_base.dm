/datum/quest/kill
	/// TP budget this quest spends composing its warband. Subtypes override.
	var/tp_budget = 0
	/// Minimum mobs the composition must produce, even if budget math would give fewer. Keeps
	/// quests from degenerating into "slay 1 orc." Subtypes override.
	var/min_mobs = 1
	/// How many "bands" of threat this kill quest type clears on completion. Subtypes override.
	var/threat_bands_cleared = 0
	/// Accumulated TP value of spawned mobs; summed from composition for reward scaling.
	var/total_spawned_tp = 0
	/// When TRUE, each guardian death bumps progress_current and spawn_kill_mobs overwrites
	/// progress_required to match spawn count. Recovery sets this FALSE — kills are just the gate,
	/// the parcel delivery is the real progress driver.
	var/kills_count_progress = TRUE

/datum/quest/kill/mark_complete()
	..()
	if(threat_bands_cleared <= 0 || !region)
		return
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	if(!TR)
		return
	TR.reduce_latent_ambush(threat_bands_cleared * THREAT_POINTS_PER_BAND)
	announce_to_bearer("<b>The road breathes easier.</b> This contract has driven [threat_bands_cleared] band(s) of threat from the region.")

/datum/quest/kill/proc/announce_to_bearer(msg)
	var/mob/bearer = quest_receiver_reference?.resolve()
	if(!bearer)
		return
	to_chat(bearer, span_notice(msg))

/datum/quest/kill/preview(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	if(!.)
		return FALSE
	if(!region)
		return FALSE
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	if(!TR)
		return FALSE
	faction = pick_region_faction_for(TR)
	if(!faction)
		return FALSE
	faction_id = faction.id
	// Scale by regional danger, then roll per-quest variance so two same-difficulty quests differ.
	tp_budget = roll_tp_budget(tp_budget, TR.tp_budget_multiplier)
	// target_mob_type is picked here for display purposes only — the actual composition is
	// computed at materialize time via TP budget spending.
	target_mob_type = faction.pick_mob_type()
	if(!target_mob_type)
		return FALSE
	progress_required = estimate_mob_count()
	if(faction.boss_name_file)
		band_leader_name = faction.generate_boss_name()
	finalize_preview_title()
	return TRUE

/datum/quest/kill/proc/roll_tp_budget(base_budget, region_mult = 1.0)
	if(base_budget <= 0)
		return base_budget
	var/scaled = base_budget * region_mult
	var/variance = scaled * QUEST_TP_BUDGET_VARIANCE
	return round(scaled + rand(-variance, variance))

/datum/quest/kill/proc/pick_region_faction_for(datum/threat_region/TR)
	var/list/weights = list()
	for(var/id in TR.faction_weights)
		var/datum/quest_faction/F = get_quest_faction(id)
		if(!F)
			continue
		if(!F.allows_quest_type(quest_type))
			continue
		weights[id] = TR.faction_weights[id]
	if(!length(weights))
		return null
	var/picked_id = pickweight(weights)
	return get_quest_faction(picked_id)

/// Approximate how many mobs this quest's TP budget will spawn. Used for progress_required and
/// UI display. Uses the faction's weighted-mean mob threat so a wolf faction estimates 2.5 mobs
/// for a 25 TP budget, bogman faction estimates < 1 for the same.
/datum/quest/kill/proc/estimate_mob_count()
	if(!faction || !length(faction.mob_types) || tp_budget <= 0)
		return 1
	var/total_weight = 0
	var/weighted_tp = 0
	for(var/mob_path in faction.mob_types)
		var/weight = faction.mob_types[mob_path]
		var/tp = initial_threat_point(mob_path)
		total_weight += weight
		weighted_tp += weight * tp
	if(total_weight <= 0 || weighted_tp <= 0)
		return 1
	var/avg_tp = weighted_tp / total_weight
	// Match compose_warband's min/max so the preview count and the actual spawn agree.
	return clamp(round(tp_budget / avg_tp), min_mobs, QUEST_KILL_MAX_MOBS)

/proc/initial_threat_point(mob_path)
	var/mob/living/M = mob_path
	var/tp = initial(M.threat_point)
	return max(tp, QUEST_MOB_MIN_TP)

/datum/quest/kill/proc/spawn_kill_mobs(obj/effect/landmark/quest_spawner/landmark)
	var/list/to_spawn = compose_warband()
	var/spawned = 0
	total_spawned_tp = 0
	for(var/mob_path in to_spawn)
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue

		var/obj/effect/quest_spawn/spawn_effect = new /obj/effect/quest_spawn(spawn_turf)
		var/mob/living/new_mob = new mob_path(spawn_effect)
		new_mob.faction |= "quest"
		if(faction?.faction_tag)
			new_mob.faction |= faction.faction_tag
		new_mob.AddComponent(/datum/component/quest_object/kill, src)
		// Suppress AI scanning while dormant inside the spawn_effect — without this the AI tries
		// to build a proximity field while not on a turf, fails, and stays catatonic forever.
		ADD_TRAIT(new_mob, TRAIT_FRESHSPAWN, "[type]")
		addtimer(TRAIT_CALLBACK_REMOVE(new_mob, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
		spawn_effect.contained_atom = new_mob
		spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
		register_spawner(spawn_effect)
		add_tracked_atom(new_mob)
		landmark.add_quest_faction_to_nearby_mobs(spawn_turf)
		total_spawned_tp += initial(new_mob.threat_point) || 0
		spawned++
		sleep(1)
	// Rewrite progress_required to match what actually spawned. Kill-any-faction tracking means
	// this is the true completion count — but only for quests where kills ARE the objective.
	// Recovery keeps its preview-set progress_required (= 1 for the parcel delivery).
	if(spawned > 0 && kills_count_progress)
		progress_required = spawned

/// Spend tp_budget picking weighted mob types from faction.mob_types. Returns flat list of mob
/// type paths to spawn. Mirrors ambush.dm purchase loop (first-pick sets tone, subsequent picks
/// may go cheaper to stay under budget). Hard cap of 15 spawns.
/datum/quest/kill/proc/compose_warband()
	var/list/result = list()
	if(!faction || !length(faction.mob_types) || tp_budget <= 0)
		return result
	var/budget = tp_budget
	var/list/candidates = faction.mob_types.Copy()
	// First purchase.
	var/first_pick = pickweight(candidates)
	result += first_pick
	budget -= max(initial_threat_point(first_pick), 1)
	// Continue until budget runs dry or hard cap.
	while(budget > 0 && length(result) < QUEST_KILL_MAX_MOBS)
		var/picked = pickweight(candidates)
		if(!picked)
			break
		var/cost = max(initial_threat_point(picked), 1)
		// If this pick overshoots, try one re-roll for a cheaper pick.
		if(cost > budget)
			picked = pickweight(candidates)
			cost = max(initial_threat_point(picked), 1)
			if(cost > budget)
				break
		result += picked
		budget -= cost
	// Top up to min_mobs even if budget is spent — ensures e.g. Easy Kill always has ≥2 targets.
	while(length(result) < min_mobs && length(result) < QUEST_KILL_MAX_MOBS)
		var/picked = pickweight(candidates)
		if(!picked)
			break
		result += picked
	return result

/datum/quest/kill/get_additional_reward(turf/origin_turf, turf/target_turf)
	// Reward uses actual spawned composition if available (post-materialize); otherwise falls
	// back to an estimate from tp_budget (used during pool display / preview).
	if(total_spawned_tp > 0)
		return total_spawned_tp * QUEST_KILL_THREAT_MULT
	// Preview-time estimate: assume we'll spend the full budget.
	return tp_budget * QUEST_KILL_THREAT_MULT
