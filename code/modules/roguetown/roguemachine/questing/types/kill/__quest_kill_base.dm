/datum/quest/kill
	abstract_type = /datum/quest/kill
	var/tp_budget = 0
	var/min_mobs = 1
	var/threat_bands_cleared = 0
	var/total_spawned_tp = 0
	var/kills_count_progress = TRUE
	var/objective_verb = "Eliminate"
	var/failed = FALSE
	var/hunt_duration = QUEST_KILL_HUNT_TIMER
	var/hunt_timer_id
	var/hunt_warn_2m_id
	var/hunt_warn_30s_id
	var/hunt_timer_label = "Quarry slips away in"
	var/hunt_warn_text = "before your targets scatter"
	var/hunt_timeout_text = "<b>Your targets have scattered.</b> The scroll crumbles to ash in your hand."

/datum/quest/kill/Destroy()
	clear_hunt_timers()
	return ..()

/datum/quest/kill/mark_complete()
	..()
	clear_hunt_timers()
	if(threat_bands_cleared <= 0 || !region)
		return
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	if(!TR)
		return
	TR.reduce_latent_ambush(threat_bands_cleared * THREAT_POINTS_PER_BAND)
	announce_to_bearer("<b>The road is safer.</b> This contract drove [threat_bands_cleared] band(s) of threat out of the region.")

/datum/quest/kill/on_first_pop()
	if(hunt_timer_id || complete)
		return
	start_hunt_timer(hunt_duration)
	announce_to_bearer("<b>The hunt has begun.</b> You have [DisplayTimeText(hunt_duration)] to kill them before they scatter and the contract fails.")

/datum/quest/kill/proc/start_hunt_timer(duration)
	clear_hunt_timers()
	hunt_timer_id = addtimer(CALLBACK(src, PROC_REF(on_hunt_timeout)), duration, TIMER_STOPPABLE)
	hunt_warn_2m_id = addtimer(CALLBACK(src, PROC_REF(warn_hunt_time_left), "[DisplayTimeText(QUEST_KILL_HUNT_WARN_EARLY)]"), duration - QUEST_KILL_HUNT_WARN_EARLY, TIMER_STOPPABLE)
	hunt_warn_30s_id = addtimer(CALLBACK(src, PROC_REF(warn_hunt_time_left), "[DisplayTimeText(QUEST_KILL_HUNT_WARN_FINAL)]"), duration - QUEST_KILL_HUNT_WARN_FINAL, TIMER_STOPPABLE)

/datum/quest/kill/proc/clear_hunt_timers()
	if(hunt_timer_id)
		deltimer(hunt_timer_id)
		hunt_timer_id = null
	if(hunt_warn_2m_id)
		deltimer(hunt_warn_2m_id)
		hunt_warn_2m_id = null
	if(hunt_warn_30s_id)
		deltimer(hunt_warn_30s_id)
		hunt_warn_30s_id = null

/datum/quest/kill/proc/warn_hunt_time_left(label)
	if(complete || !hunt_timer_id)
		return
	announce_to_bearer("<b>[label] left</b> [hunt_warn_text].")

/datum/quest/kill/proc/on_hunt_timeout()
	if(complete)
		return
	hunt_timer_id = null
	fail_hunt(hunt_timeout_text)

/datum/quest/kill/proc/fail_hunt(message)
	if(complete || failed)
		return
	clear_hunt_timers()
	failed = TRUE
	record_contract_stat(src, CONTRACT_STAT_FAILED)
	announce_to_bearer(message)
	SSquestpool.refund_closed_posting(src, QUEST_ISSUE_STATUS_FAILED, REFUND_ON_FAILURE, "Failed posting refund", "failed")
	despawn_live_hunt_mobs()
	var/obj/item/quest_writ/S = quest_scroll
	if(S && !QDELETED(S))
		qdel(S)

/datum/quest/kill/force_complete()
	despawn_live_hunt_mobs()
	return ..()

/datum/quest/kill/proc/despawn_live_hunt_mobs()
	for(var/datum/weakref/W in tracked_atoms)
		var/atom/A = W.resolve()
		if(QDELETED(A))
			continue
		if(!isliving(A))
			continue
		var/mob/living/M = A
		if(M.stat == DEAD)
			continue
		if(M.client)
			M.ghostize(FALSE)
		qdel(M)

/datum/quest/kill/proc/any_guardians_alive()
	for(var/datum/weakref/W in tracked_atoms)
		var/atom/A = W.resolve()
		if(QDELETED(A))
			continue
		if(!isliving(A))
			continue
		var/mob/living/M = A
		if(M.stat == DEAD)
			continue
		return TRUE
	return FALSE

/datum/quest/kill/proc/on_guardian_killed()
	return

/datum/quest/kill/populate_scroll_ui_data(list/data)
	if(!hunt_timer_id)
		return
	var/left = timeleft(hunt_timer_id)
	if(left <= 0)
		return
	data["hunt_timer_label"] = hunt_timer_label
	data["hunt_timer_seconds"] = round(left / 10)

/datum/quest/kill/get_objective_text()
	if(!faction)
		return "[objective_verb] ~[progress_required] [initial(target_mob_type.name)]."
	return "[objective_verb] ~[progress_required] [faction.name_plural]."

/datum/quest/kill/materialize(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	spawn_kill_mobs(landmark)
	return TRUE

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
		if(!F || !faction_fits(F))
			continue
		weights[id] = TR.faction_weights[id]
	if(!length(weights))
		return null
	return get_quest_faction(pickweight(weights))

/datum/quest/kill/proc/faction_fits(datum/quest_faction/F)
	return TRUE

/datum/quest/kill/fits_region(datum/threat_region/TR)
	return !!pick_region_faction_for(TR)

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
		var/mob/living/new_mob = spawn_hidden_mob(landmark, mob_path)
		if(!new_mob)
			continue
		total_spawned_tp += initial(new_mob.threat_point) || 0
		spawned++
		sleep(1)
	if(spawned > 0 && kills_count_progress)
		progress_required = spawned

/datum/quest/kill/proc/spawn_hidden_mob(obj/effect/landmark/quest_spawner/landmark, mob_path, is_target = TRUE, tag_faction = TRUE, effect_type = /obj/effect/quest_spawn, dust_corpse = TRUE)
	var/turf/spawn_turf = landmark.get_safe_spawn_turf()
	if(!spawn_turf)
		return null
	var/obj/effect/quest_spawn/spawn_effect = effect_type ? new effect_type(spawn_turf) : null
	var/mob/living/new_mob = new mob_path(spawn_effect || spawn_turf)
	new_mob.faction |= "quest"
	if(tag_faction && faction?.faction_tag)
		new_mob.faction |= faction.faction_tag
	new_mob.mark_contract_spawned(dust_corpse)
	if(is_target)
		new_mob.AddComponent(/datum/component/quest_object/kill, src)
		add_tracked_atom(new_mob)
	ADD_TRAIT(new_mob, TRAIT_FRESHSPAWN, "[type]")
	addtimer(TRAIT_CALLBACK_REMOVE(new_mob, TRAIT_FRESHSPAWN, "[type]"), QUEST_MOB_FRESHSPAWN_TIME)
	if(spawn_effect)
		spawn_effect.contained_atom = new_mob
		spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
		register_spawner(spawn_effect)
	return new_mob

/datum/quest/kill/proc/compose_candidates()
	return faction.mob_types.Copy()

/datum/quest/kill/proc/compose_warband()
	var/list/result = list()
	if(!faction || !length(faction.mob_types) || tp_budget <= 0)
		return result
	var/budget = tp_budget
	var/list/candidates = compose_candidates()
	if(!length(candidates))
		return result
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
	if(total_spawned_tp > 0)
		return total_spawned_tp * QUEST_KILL_THREAT_MULT
	// Preview-time estimate: assume we'll spend the full budget.
	return tp_budget * QUEST_KILL_THREAT_MULT
