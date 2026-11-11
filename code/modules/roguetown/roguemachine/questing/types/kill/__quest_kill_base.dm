/datum/quest/kill
	abstract_type = /datum/quest/kill
	var/tp_budget = 0
	var/max_region_tp_mult
	var/min_mobs = 1
	var/threat_bands_cleared = 0
	var/total_spawned_tp = 0
	var/kills_count_progress = TRUE
	var/objective_verb = "Eliminate"
	var/failed = FALSE
	var/armed = FALSE
	var/hunt_duration = QUEST_KILL_HUNT_TIMER
	var/hunt_timer_id
	var/hunt_warn_2m_id
	var/hunt_warn_30s_id
	var/hunt_timer_label = "Quarry slips away in"
	var/hunt_warn_text = "before your targets scatter"
	var/hunt_timeout_text = "<b>Your targets have scattered.</b> The scroll crumbles to ash in your hand."
	var/hunt_overtime_max = QUEST_KILL_HUNT_OVERTIME_MAX
	var/hunt_overtime_used = 0
	var/last_guardian_kill = 0
	var/leash_tick_id
	var/list/leash_strayed_since = list()

/datum/quest/kill/Destroy()
	clear_hunt_timers()
	stop_leash_tick()
	return ..()

/datum/quest/kill/mark_complete()
	..()
	clear_hunt_timers()
	stop_leash_tick()
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
	start_leash_tick()
	start_hunt_timer(hunt_duration)
	announce_to_bearer("<b>The hunt has begun.</b> You have [DisplayTimeText(hunt_duration)] to kill them before they scatter and the contract fails.")

/datum/quest/kill/proc/start_hunt_timer(duration)
	clear_hunt_timers()
	hunt_overtime_used = 0
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

/datum/quest/kill/proc/on_hunt_timeout(force = FALSE)
	if(complete)
		return
	hunt_timer_id = null
	if(!force && try_hunt_overtime())
		return
	fail_hunt(hunt_timeout_text)

/datum/quest/kill/proc/try_hunt_overtime()
	if(failed || hunt_overtime_used >= hunt_overtime_max)
		return FALSE
	if(!hunt_still_contested())
		return FALSE
	clear_hunt_timers()
	hunt_overtime_used++
	hunt_timer_id = addtimer(CALLBACK(src, PROC_REF(on_hunt_timeout)), QUEST_KILL_HUNT_OVERTIME, TIMER_STOPPABLE)
	hunt_warn_30s_id = addtimer(CALLBACK(src, PROC_REF(warn_hunt_time_left), "[DisplayTimeText(QUEST_KILL_HUNT_WARN_FINAL)]"), QUEST_KILL_HUNT_OVERTIME - QUEST_KILL_HUNT_WARN_FINAL, TIMER_STOPPABLE)
	announce_to_bearer("<b>You're still fighting.</b> You have [DisplayTimeText(QUEST_KILL_HUNT_OVERTIME)] more [hunt_warn_text].")
	quest_scroll?.update_quest_text()
	return TRUE

/datum/quest/kill/proc/hunt_still_contested()
	var/recent_kill = last_guardian_kill && (world.time - last_guardian_kill <= QUEST_KILL_HUNT_OVERTIME_RECENT_KILL)
	for(var/datum/weakref/W in tracked_atoms)
		var/mob/living/M = W.resolve()
		if(!istype(M) || QDELETED(M) || M.stat == DEAD)
			continue
		if(recent_kill || player_watching(get_turf(M), QUEST_KILL_HUNT_OVERTIME_RANGE))
			return TRUE
	return FALSE

/datum/quest/kill/proc/fail_hunt(message)
	if(complete || failed)
		return
	clear_hunt_timers()
	failed = TRUE
	stop_leash_tick()
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
		var/datum/component/quest_object/kill/kill_component = M.GetComponent(/datum/component/quest_object/kill)
		if(kill_component)
			kill_component.counted = TRUE
		if(M.client)
			M.ghostize(FALSE)
		qdel(M)

/datum/quest/kill/proc/start_leash_tick()
	if(leash_tick_id)
		return
	leash_tick_id = addtimer(CALLBACK(src, PROC_REF(leash_tick)), QUEST_GUARDIAN_LEASH_TICK, TIMER_STOPPABLE | TIMER_LOOP)

/datum/quest/kill/proc/stop_leash_tick()
	if(leash_tick_id)
		deltimer(leash_tick_id)
		leash_tick_id = null
	leash_strayed_since.Cut()

/datum/quest/kill/proc/leash_tick()
	if(complete || failed)
		stop_leash_tick()
		return
	var/obj/effect/landmark/quest_spawner/landmark = pending_landmark_ref?.resolve()
	var/turf/home = get_turf(landmark)
	if(!home)
		return
	for(var/datum/weakref/W in tracked_atoms)
		var/mob/living/M = W.resolve()
		if(!istype(M) || M.stat == DEAD || M.client)
			leash_strayed_since -= W
			continue
		var/turf/T = get_turf(M)
		if(T && T.z == home.z && get_dist(T, home) <= QUEST_GUARDIAN_LEASH_RANGE)
			leash_strayed_since -= W
			continue
		if(!leash_strayed_since[W])
			leash_strayed_since[W] = world.time
			continue
		if(world.time - leash_strayed_since[W] < QUEST_GUARDIAN_LEASH_GRACE)
			continue
		if(player_watching(T))
			continue
		leash_strayed_since -= W
		return_guardian_home(M, landmark)

/datum/quest/kill/proc/player_watching(turf/T, range = QUEST_GUARDIAN_LEASH_WATCH_RANGE)
	if(!T)
		return FALSE
	for(var/mob/living/L in GLOB.player_list)
		if(L.stat == DEAD)
			continue
		var/turf/LT = get_turf(L)
		if(LT && LT.z == T.z && get_dist(LT, T) <= range)
			return TRUE
	return FALSE

/datum/quest/kill/proc/return_guardian_home(mob/living/M, obj/effect/landmark/quest_spawner/landmark)
	var/turf/dest = landmark.get_safe_spawn_turf() || get_turf(landmark)
	M.forceMove(dest)
	if(M.ai_controller)
		M.ai_controller.CancelActions()
		M.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)

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
	data["armed"] = armed
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

/datum/quest/kill/project_fellowship_objective(mob/living/user)
	var/extras = count_fellowship_extras(user)
	var/missing = count_fellowship_missing(user)
	if(!kills_count_progress || (!veteran && ((!extras && !missing) || !fellowship_threat_rate)))
		return get_objective_text()
	var/saved_required = progress_required
	var/scaled = estimate_mob_count(round(tp_budget * group_threat_mult(extras - missing) * veteran_threat_mult()))
	progress_required = missing ? scaled : min(max(scaled, estimate_mob_count() + extras), QUEST_KILL_MAX_MOBS)
	. = get_objective_text()
	progress_required = saved_required

/datum/quest/kill/materialize(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	var/turf/T = get_turf(landmark)
	if(!T)
		return FALSE
	var/obj/effect/quest_spawn/sentinel/S = new(T)
	S.quest_ref = WEAKREF(src)
	register_spawner(S)
	armed = TRUE
	return TRUE

/datum/quest/kill/proc/check_arrival()
	if(!armed || failed || complete)
		return
	var/obj/effect/landmark/quest_spawner/landmark = SSquestpool.resolve_or_repick_landmark(src)
	if(!landmark)
		return
	armed = FALSE
	for(var/datum/weakref/ref in spawners.Copy())
		var/obj/effect/quest_spawn/sentinel/S = ref.resolve()
		if(istype(S))
			spawners -= ref
			qdel(S)
	on_arrival(landmark)

/datum/quest/kill/proc/on_arrival(obj/effect/landmark/quest_spawner/landmark)
	settle_fellowship_arrival(landmark)
	spawn_kill_mobs(landmark)
	quest_scroll?.update_quest_text()

/datum/quest/kill/proc/settle_fellowship_arrival(obj/effect/landmark/quest_spawner/landmark)
	if(!fellowship_threat_rate && !fellowship_reward_rate && !(signed_at_ledger && required_fellowship_size > 1))
		return
	var/mob/living/bearer = quest_receiver_reference?.resolve()
	if(!istype(bearer))
		return
	var/list/present = present_fellowship_members(bearer, landmark)
	var/before = fellowship_extras
	fellowship_roster = list()
	for(var/mob/living/M as anything in present)
		fellowship_roster += WEAKREF(M)
	roster_fellowship_ref = WEAKREF(bearer.current_fellowship)
	fellowship_extras = max(0, length(present) - max(1, required_fellowship_size))
	fellowship_missing = signed_at_ledger ? max(0, required_fellowship_size - length(present)) : 0
	if(fellowship_missing)
		fellowship_threat_mult = group_threat_mult(-fellowship_missing)
		fellowship_reward_mult = 1
		if(!is_directive && (fellowship_threat_rate || fellowship_reward_rate))
			reward_amount = calculate_reward(reward_origin_turf, reward_target_turf)
		scale_for_missing_crew(length(present))
		return
	if(fellowship_extras == before || (!fellowship_threat_rate && !fellowship_reward_rate))
		return
	fellowship_threat_mult = group_threat_mult(fellowship_extras)
	fellowship_reward_mult = group_reward_mult(fellowship_extras)
	if(!is_directive)
		reward_amount = calculate_reward(reward_origin_turf, reward_target_turf)
	var/diff = abs(fellowship_extras - before)
	if(fellowship_extras < before)
		announce_to_bearer("<b>[diff] of your fellowship member\s [diff == 1 ? "was" : "were"] absent.</b> The contract has been scaled down.")
	else
		announce_to_bearer("<b>[diff] more members than expected were in your fellowship.</b> The contract has been scaled up.")

/datum/quest/kill/proc/scale_for_missing_crew(present_count)
	reward_amount = round(reward_amount * present_count / required_fellowship_size)
	announce_to_bearer("<b>[fellowship_missing] of the [required_fellowship_size] members this contract needs [fellowship_missing == 1 ? "was" : "were"] absent.</b> The threat and reward has been scaled down.")

/datum/quest/kill/proc/present_fellowship_members(mob/living/bearer, obj/effect/landmark/quest_spawner/landmark)
	. = list(bearer)
	var/turf/center = get_turf(quest_scroll_ref?.resolve()) || get_turf(landmark)
	if(!center)
		return
	for(var/mob/living/M as anything in available_fellowship_members(bearer))
		if(M == bearer || M.stat == DEAD)
			continue
		var/turf/T = get_turf(M)
		if(!T || T.z != center.z || get_dist(T, center) > QUEST_ARRIVAL_SCAN_RANGE)
			continue
		. += M

/datum/quest/kill/get_target_location()
	. = ..()
	if(.)
		return
	var/obj/effect/landmark/quest_spawner/landmark = pending_landmark_ref?.resolve()
	return landmark ? get_turf(landmark) : null

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
	tp_budget = roll_tp_budget(tp_budget, region_scale(TR))
	target_mob_type = faction.pick_mob_type()
	if(!target_mob_type)
		return FALSE
	progress_required = estimate_mob_count()
	if(faction.boss_name_file)
		band_leader_name = faction.generate_boss_name()
	finalize_preview_title()
	return TRUE

/datum/quest/kill/region_scale(datum/threat_region/TR)
	if(max_region_tp_mult)
		return min(TR.tp_budget_multiplier, max_region_tp_mult)
	return TR.tp_budget_multiplier

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
		if(!F || !faction_fits(F, TR))
			continue
		weights[id] = TR.faction_weights[id]
	if(!length(weights))
		return null
	return get_quest_faction(pickweight(weights))

/datum/quest/kill/proc/faction_fits(datum/quest_faction/F, datum/threat_region/TR)
	return TRUE

/datum/quest/kill/fits_region(datum/threat_region/TR)
	return ..() && !!pick_region_faction_for(TR)

/datum/quest/kill/proc/average_threat_point()
	return faction ? faction.average_threat_point() : 0

/datum/quest/kill/can_be_veteran()
	return !is_directive && (source == QUEST_SOURCE_POOL || source == QUEST_SOURCE_RUMOR)

/datum/quest/kill/proc/scaled_threat_budget(budget = tp_budget)
	. = round(budget * fellowship_threat_mult * veteran_threat_mult())
	var/max_tp = faction?.max_threat_point()
	if(max_tp > 0)
		. = min(., round(QUEST_KILL_MAX_MOBS * max_tp))

/datum/quest/kill/proc/estimate_mob_count(budget = tp_budget)
	if(budget <= 0)
		return 1
	var/avg_tp = average_threat_point()
	if(avg_tp <= 0)
		return 1
	// Match compose_warband's min/max so the preview count and the actual spawn agree.
	return clamp(round(budget / avg_tp), min_mobs, QUEST_KILL_MAX_MOBS)

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
	var/list/base = faction.mob_types.Copy()
	if(!veteran)
		return base
	var/avg_tp = average_threat_point()
	var/list/out = list()
	for(var/path in base)
		var/weight = base[path]
		if(avg_tp > 0)
			weight *= (max(initial_threat_point(path), 1) / avg_tp) ** QUEST_VETERAN_ELITE_BIAS
		if(is_ranged_mob_type(path))
			weight *= QUEST_VETERAN_RANGED_WEIGHT_MULT
		out[path] = max(1, round(weight))
	return out

/proc/is_ranged_mob_type(mob_path)
	if(ispath(mob_path, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/hostile_path = mob_path
		return initial(hostile_path.ranged)
	var/mob/living/living_path = mob_path
	var/datum/npc_archetype/archetype = initial(living_path.npc_archetype)
	return ispath(archetype) && ispath(initial(archetype.ai_controller), /datum/ai_controller/human_npc/archer)

/datum/quest/kill/proc/compose_warband()
	var/list/result = list()
	if(!faction || !length(faction.mob_types) || tp_budget <= 0)
		return result
	var/budget = scaled_threat_budget()
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
	if(budget > 0 && length(result) >= QUEST_KILL_MAX_MOBS)
		upgrade_warband(result, candidates, budget)
	// Top up to min_mobs even if budget is spent — ensures e.g. Easy Kill always has ≥2 targets.
	while(length(result) < min_mobs && length(result) < QUEST_KILL_MAX_MOBS)
		var/picked = pickweight(candidates)
		if(!picked)
			break
		result += picked
	if(fellowship_extras && fellowship_threat_mult > 1)
		var/floor_count = min(estimate_mob_count() + fellowship_extras, QUEST_KILL_MAX_MOBS)
		while(length(result) < floor_count)
			result += pickweight(candidates)
	return result

/datum/quest/kill/proc/upgrade_warband(list/result, list/candidates, budget)
	while(budget > 0)
		var/cheapest_index = 0
		var/cheapest_cost = INFINITY
		for(var/i in 1 to length(result))
			var/cost = initial_threat_point(result[i])
			if(cost < cheapest_cost)
				cheapest_cost = cost
				cheapest_index = i
		var/list/upgrades = list()
		for(var/path in candidates)
			var/cost = initial_threat_point(path)
			if(cost > cheapest_cost && cost - cheapest_cost <= budget)
				upgrades[path] = candidates[path]
		if(!length(upgrades))
			return
		var/picked = pickweight(upgrades)
		budget -= initial_threat_point(picked) - cheapest_cost
		result[cheapest_index] = picked

/datum/quest/kill/get_additional_reward(turf/origin_turf, turf/target_turf)
	if(total_spawned_tp > 0)
		return kill_tp_reward(total_spawned_tp)
	// Preview-time estimate: assume we'll spend the full budget.
	return kill_tp_reward(scaled_threat_budget())

/datum/quest/kill/proc/kill_tp_reward(tp)
	if(!veteran)
		return tp * QUEST_KILL_THREAT_MULT
	var/standard_tp = tp / QUEST_VETERAN_THREAT_MULT
	return standard_tp * QUEST_KILL_THREAT_MULT + (tp - standard_tp) * QUEST_VETERAN_THREAT_REWARD_MULT
