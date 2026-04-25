/proc/defense_quest_tier_cost(quest_type)
	return GLOB.defense_quest_tier_costs[quest_type] || 0

SUBSYSTEM_DEF(questpool)
	name = "Quest Pool"
	wait = QUEST_POOL_REGEN_INTERVAL
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	init_order = INIT_ORDER_DEFAULT

	var/list/datum/quest/pool = list()
	var/list/recent_takes = list()
	var/list/event_log = list()
	var/list/registered_ledgers = list()
	var/list/kill_count_by_region = list()
	var/list/evergreen_count_by_region = list()
	var/list/landmarks_by_type = list()

/datum/controller/subsystem/questpool/Initialize()
	init_quest_factions()
	for(var/obj/effect/landmark/quest_spawner/landmark as anything in GLOB.quest_landmarks_list)
		register_landmark(landmark)
	// Front-load every region to its full target so roundstart has a healthy mix.
	regen_kill_targets(total_kill_target())
	regen_fetch_targets()
	return ..()

/datum/controller/subsystem/questpool/proc/get_nearest_ledger_turf(turf/reference)
	var/turf/closest
	var/min_dist = INFINITY
	for(var/obj/structure/roguemachine/contractledger/ledger as anything in registered_ledgers)
		var/turf/T = get_turf(ledger)
		if(!T)
			continue
		if(!reference)
			return T
		var/dist = get_dist(reference, T)
		if(dist < min_dist)
			min_dist = dist
			closest = T
	return closest

/datum/controller/subsystem/questpool/fire(resumed)
	// Reset region counts from the current pool state. reroll_stale / regen_kill_targets
	// / regen_fetch_targets then maintain them incrementally through pool adds/removes.
	rebuild_region_counts()
	reroll_stale()
	regen_kill_targets(QUEST_KILL_REGEN_PER_TICK)
	regen_fetch_targets()

/datum/controller/subsystem/questpool/proc/rebuild_region_counts()
	kill_count_by_region.Cut()
	evergreen_count_by_region.Cut()
	for(var/datum/quest/Q as anything in pool)
		adjust_region_count(Q, 1)

/// Bumps the region count for Q's kind by delta. Called whenever a quest enters
/// or leaves the pool so count_*_in stays O(1). No-op if Q has no region set.
/datum/controller/subsystem/questpool/proc/adjust_region_count(datum/quest/Q, delta)
	if(!Q?.region || !delta)
		return
	if(is_kill_type(Q.quest_type))
		var/new_count = (kill_count_by_region[Q.region] || 0) + delta
		if(new_count <= 0)
			kill_count_by_region -= Q.region
		else
			kill_count_by_region[Q.region] = new_count
	else if(is_evergreen_type(Q.quest_type))
		var/new_count = (evergreen_count_by_region[Q.region] || 0) + delta
		if(new_count <= 0)
			evergreen_count_by_region -= Q.region
		else
			evergreen_count_by_region[Q.region] = new_count

/datum/controller/subsystem/questpool/proc/register_landmark(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark?.quest_type)
		return
	for(var/qtype in landmark.quest_type)
		var/list/bucket = landmarks_by_type[qtype]
		if(!bucket)
			bucket = list()
			landmarks_by_type[qtype] = bucket
		bucket |= landmark

/datum/controller/subsystem/questpool/proc/unregister_landmark(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark?.quest_type)
		return
	for(var/qtype in landmark.quest_type)
		var/list/bucket = landmarks_by_type[qtype]
		if(!bucket)
			continue
		bucket -= landmark
		if(!length(bucket))
			landmarks_by_type -= qtype

/// Sum of per-region kill targets across all regions.
/datum/controller/subsystem/questpool/proc/total_kill_target()
	var/pop = GLOB.player_list.len
	var/total = 0
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		total += TR.get_kill_target(pop)
	return total

/datum/controller/subsystem/questpool/proc/count_kill_quests_in(region_name)
	return kill_count_by_region[region_name] || 0

/datum/controller/subsystem/questpool/proc/count_evergreen_quests_in(region_name)
	return evergreen_count_by_region[region_name] || 0

/proc/is_kill_type(quest_type)
	return quest_type == QUEST_KILL_EASY || quest_type == QUEST_CLEAR_OUT || quest_type == QUEST_RAID || quest_type == QUEST_BOUNTY || quest_type == QUEST_RECOVERY

/proc/is_evergreen_type(quest_type)
	return quest_type == QUEST_COURIER || quest_type == QUEST_RETRIEVAL

/// Returns the region furthest below its kill target by fill ratio, or null if all are at target.
/datum/controller/subsystem/questpool/proc/pick_neediest_kill_region()
	var/pop = GLOB.player_list.len
	var/lowest_ratio = 1
	var/datum/threat_region/chosen
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		var/target = TR.get_kill_target(pop)
		if(!target)
			continue
		if(!region_allows_any_kill_type(TR))
			continue
		var/have = count_kill_quests_in(TR.region_name)
		if(have >= target)
			continue
		var/ratio = have / target
		if(ratio < lowest_ratio)
			lowest_ratio = ratio
			chosen = TR
	return chosen

/proc/region_allows_any_kill_type(datum/threat_region/TR)
	return TR.allows_quest_type(QUEST_KILL_EASY) || TR.allows_quest_type(QUEST_CLEAR_OUT) || TR.allows_quest_type(QUEST_RAID) || TR.allows_quest_type(QUEST_BOUNTY)

/proc/region_allows_any_evergreen_type(datum/threat_region/TR)
	return TR.allows_quest_type(QUEST_COURIER) || TR.allows_quest_type(QUEST_RETRIEVAL)

/datum/controller/subsystem/questpool/proc/regen_kill_targets(count)
	for(var/i in 1 to count)
		var/datum/threat_region/TR = pick_neediest_kill_region()
		if(!TR)
			return
		var/type = pick_kill_type_for(TR)
		if(!type)
			continue
		generate_one(type, TR)

/datum/controller/subsystem/questpool/proc/regen_fetch_targets()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		if(!TR.evergreen_target)
			continue
		if(!region_allows_any_evergreen_type(TR))
			continue
		var/have = count_evergreen_quests_in(TR.region_name)
		var/needed = TR.evergreen_target - have
		for(var/i in 1 to needed)
			var/type = pick_evergreen_type_for(TR)
			if(!type)
				break
			generate_one(type, TR)

/// Weighted pick of a kill quest type the given region allows.
/datum/controller/subsystem/questpool/proc/pick_kill_type_for(datum/threat_region/TR)
	var/list/weights = list()
	for(var/qtype in QUEST_KILL_TYPE_WEIGHTS)
		if(TR.allows_quest_type(qtype))
			weights[qtype] = QUEST_KILL_TYPE_WEIGHTS[qtype]
	if(!length(weights))
		return null
	return pickweight(weights)

/// Weighted pick of an evergreen quest type the given region allows.
/datum/controller/subsystem/questpool/proc/pick_evergreen_type_for(datum/threat_region/TR)
	var/list/weights = list()
	for(var/qtype in QUEST_EVERGREEN_TYPE_WEIGHTS)
		if(TR.allows_quest_type(qtype))
			weights[qtype] = QUEST_EVERGREEN_TYPE_WEIGHTS[qtype]
	if(!length(weights))
		return null
	return pickweight(weights)

/datum/controller/subsystem/questpool/proc/reroll_stale()
	var/cutoff = world.time - QUEST_POOL_STALE_THRESHOLD
	for(var/datum/quest/Q as anything in pool)
		if(Q.created_at >= cutoff)
			continue
		var/was_kill = is_kill_type(Q.quest_type)
		adjust_region_count(Q, -1)
		pool -= Q
		log_event("reroll", "stale [Q.quest_difficulty] [Q.quest_type]")
		qdel(Q)
		record_round_statistic(STATS_CONTRACTS_REROLLED)
		// Only kill quests reroll on the kill schedule. Evergreens get topped up by regen_fetch_targets.
		if(!was_kill)
			continue
		var/datum/threat_region/TR = pick_neediest_kill_region()
		if(!TR)
			continue
		var/type = pick_kill_type_for(TR)
		if(!type)
			continue
		generate_one(type, TR, is_replacement = TRUE)

/datum/controller/subsystem/questpool/proc/issue_rumor_quest(type, datum/threat_region/preferred_region, area/override_destination, in_hands = FALSE, mob/living/carbon/human/innkeeper = null)
	if(!type || !(type in GLOB.rumor_point_costs))
		return null
	if(in_hands && !innkeeper)
		return null
	var/datum/quest/Q = instantiate_quest_of_type(type)
	if(!Q)
		return null
	Q.quest_difficulty = difficulty_for_type(type)
	Q.source = QUEST_SOURCE_RUMOR
	Q.created_at = world.time
	Q.issued_day = GLOB.dayspassed
	if(innkeeper)
		Q.quest_giver_name = innkeeper.real_name
	Q.deposit_amount = Q.calculate_deposit()
	if(override_destination && istype(Q, /datum/quest/kill/recovery))
		var/datum/quest/kill/recovery/RQ = Q
		RQ.override_destination = override_destination
	if(!preferred_region)
		preferred_region = SSregionthreat.pick_region_for_quest(type)
	var/region_name = preferred_region?.region_name
	var/obj/effect/landmark/quest_spawner/landmark = find_quest_landmark(type, region_name)
	if(!landmark)
		qdel(Q)
		return null
	if(!Q.preview(landmark))
		qdel(Q)
		return null
	var/turf/landmark_turf = get_turf(landmark)
	var/turf/origin = get_nearest_ledger_turf(landmark_turf) || landmark_turf
	Q.reward_amount = Q.calculate_reward(origin, landmark_turf)

	if(in_hands)
		if(!Q.materialize(landmark))
			qdel(Q)
			return null
		var/obj/item/quest_writ/scroll = new(get_turf(innkeeper))
		scroll.base_icon_state = Q.get_scroll_icon()
		scroll.assigned_quest = Q
		Q.quest_scroll = scroll
		Q.quest_scroll_ref = WEAKREF(scroll)
		scroll.update_quest_text()
		innkeeper.put_in_hands(scroll)
		record_round_statistic(STATS_CONTRACTS_GENERATED)
		record_round_statistic(STATS_CONTRACTS_GENERATED_RUMOR)
		log_event("generate", "rumor-in-hands [Q.quest_difficulty] [type] at [Q.target_spawn_area || "unknown"] (reward [Q.reward_amount])")
		return Q

	pool += Q
	adjust_region_count(Q, 1)
	record_round_statistic(STATS_CONTRACTS_GENERATED)
	record_round_statistic(STATS_CONTRACTS_GENERATED_RUMOR)
	log_event("generate", "rumor-pool [Q.quest_difficulty] [type] at [Q.target_spawn_area || "unknown"] (reward [Q.reward_amount])")
	return Q

/datum/controller/subsystem/questpool/proc/issue_defense_quest(type, datum/threat_region/preferred_region, area/override_destination, in_hands = FALSE, mob/living/carbon/human/steward = null)
	if(!type || !(type in GLOB.defense_quest_tier_costs))
		return null
	if(in_hands && !steward)
		return null
	var/datum/quest/Q = instantiate_quest_of_type(type)
	if(!Q)
		return null
	Q.quest_difficulty = difficulty_for_type(type)
	Q.source = QUEST_SOURCE_DEFENSE
	Q.created_at = world.time
	Q.issued_day = GLOB.dayspassed
	if(steward)
		Q.quest_giver_name = steward.real_name
	Q.deposit_amount = Q.calculate_deposit()
	if(override_destination && istype(Q, /datum/quest/kill/recovery))
		var/datum/quest/kill/recovery/RQ = Q
		RQ.override_destination = override_destination
	if(!preferred_region)
		preferred_region = SSregionthreat.pick_region_for_quest(type)
	var/region_name = preferred_region?.region_name
	var/obj/effect/landmark/quest_spawner/landmark = find_quest_landmark(type, region_name)
	if(!landmark)
		qdel(Q)
		return null
	if(!Q.preview(landmark))
		qdel(Q)
		return null
	var/turf/landmark_turf = get_turf(landmark)
	var/turf/origin = get_nearest_ledger_turf(landmark_turf) || landmark_turf
	Q.reward_amount = Q.calculate_reward(origin, landmark_turf)

	if(in_hands)
		if(!Q.materialize(landmark))
			qdel(Q)
			return null
		var/obj/item/quest_writ/scroll = new(get_turf(steward))
		scroll.base_icon_state = Q.get_scroll_icon()
		scroll.assigned_quest = Q
		Q.quest_scroll = scroll
		Q.quest_scroll_ref = WEAKREF(scroll)
		scroll.update_quest_text()
		steward.put_in_hands(scroll)
	else
		pool += Q
		adjust_region_count(Q, 1)
	record_round_statistic(STATS_CONTRACTS_GENERATED)
	record_round_statistic(STATS_CONTRACTS_GENERATED_DEFENSE)
	log_event("generate", "[in_hands ? "defense-in-hands" : "defense-pool"] [Q.quest_difficulty] [type] at [Q.target_spawn_area || "unknown"] (reward [Q.reward_amount])")
	return Q

/// Bearer-bond scroll is spawned straight into the Steward's hand. Wave 1 materializes
/// on first scroll-open, not at issue time — see quest_scroll_blockade.attack_self.
/datum/controller/subsystem/questpool/proc/issue_blockade_defense_quest(datum/blockade/B, mob/living/carbon/human/steward, datum/fund/source_fund, cost = 0)
	if(!B || !steward)
		return null
	if(B.has_active_scroll())
		return null
	var/datum/economic_region/ER = B.get_region()
	var/datum/threat_region/TR = B.get_threat_region()
	if(!ER || !TR)
		return null
	var/datum/quest/kill/blockade_defense/Q = new()
	Q.blockade_ref = WEAKREF(B)
	Q.quest_difficulty = QUEST_DIFFICULTY_HARD
	Q.source = QUEST_SOURCE_BLOCKADE
	Q.created_at = world.time
	Q.issued_day = GLOB.dayspassed
	Q.quest_giver_name = steward.real_name
	Q.deposit_amount = 0
	var/obj/effect/landmark/quest_spawner/landmark = find_quest_landmark(QUEST_BLOCKADE_DEFENSE, TR.region_name)
	if(!landmark)
		qdel(Q)
		return null
	if(!Q.preview(landmark))
		qdel(Q)
		return null
	// Reward scales with the region's TP multiplier — far/dangerous regions print more for
	// the same Steward draft cost. The mob count itself stays at the fixed wave budgets.
	Q.reward_amount = round(BLOCKADE_SCROLL_REWARD * TR.tp_budget_multiplier)
	Q.funding_fund = source_fund
	Q.funding_cost = cost
	Q.issued_at = world.time
	var/obj/item/quest_writ/blockade/scroll = new(get_turf(steward))
	scroll.base_icon_state = Q.get_scroll_icon()
	scroll.assigned_quest = Q
	Q.quest_scroll = scroll
	Q.quest_scroll_ref = WEAKREF(scroll)
	scroll.update_quest_text()
	steward.put_in_hands(scroll)
	B.active_scroll_ref = WEAKREF(scroll)
	record_round_statistic(STATS_CONTRACTS_GENERATED)
	log_event("generate", "blockade-defense in-hand for [ER.name] (faction [Q.faction_id], reward [Q.reward_amount])")
	return Q

/datum/controller/subsystem/questpool/proc/generate_one(type, datum/threat_region/preferred_region, is_replacement = FALSE)
	var/datum/quest/Q = instantiate_quest_of_type(type)
	if(!Q)
		return null
	Q.quest_difficulty = difficulty_for_type(type)
	Q.source = QUEST_SOURCE_POOL
	Q.created_at = world.time
	Q.issued_day = GLOB.dayspassed
	Q.deposit_amount = Q.calculate_deposit()
	// If caller didn't specify a region, pick one weighted by threat (kill) or any eligible (evergreen).
	if(!preferred_region)
		preferred_region = SSregionthreat.pick_region_for_quest(type)
	var/region_name = preferred_region?.region_name
	var/obj/effect/landmark/quest_spawner/landmark = find_quest_landmark(type, region_name)
	if(!landmark)
		qdel(Q)
		return null
	if(!Q.preview(landmark))
		qdel(Q)
		return null
	var/turf/landmark_turf = get_turf(landmark)
	var/turf/origin = get_nearest_ledger_turf(landmark_turf) || landmark_turf
	Q.reward_amount = Q.calculate_reward(origin, landmark_turf)
	pool += Q
	adjust_region_count(Q, 1)
	// Skip the generation counter when this is a stale-reroll replacement - reroll already bumped STATS_CONTRACTS_REROLLED.
	if(!is_replacement)
		record_round_statistic(STATS_CONTRACTS_GENERATED)
		record_round_statistic(STATS_CONTRACTS_GENERATED_POOL)
	log_event("generate", "[Q.quest_difficulty] [type] at [Q.target_spawn_area || "unknown"] (reward [Q.reward_amount])")
	return Q

/// Map quest type to a legacy difficulty tier (still used for deposit tier and scroll icon).
/proc/difficulty_for_type(type)
	switch(type)
		if(QUEST_KILL_EASY)
			return QUEST_DIFFICULTY_EASY
		if(QUEST_RETRIEVAL, QUEST_COURIER)
			return QUEST_DIFFICULTY_EASY
		if(QUEST_CLEAR_OUT, QUEST_RECOVERY)
			return QUEST_DIFFICULTY_MEDIUM
		if(QUEST_RAID, QUEST_BOUNTY)
			return QUEST_DIFFICULTY_HARD
	return QUEST_DIFFICULTY_EASY

/datum/controller/subsystem/questpool/proc/instantiate_quest_of_type(type)
	switch(type)
		if(QUEST_RETRIEVAL)
			return new /datum/quest/retrieval()
		if(QUEST_COURIER)
			return new /datum/quest/courier()
		if(QUEST_KILL_EASY)
			return new /datum/quest/kill/easy()
		if(QUEST_CLEAR_OUT)
			return new /datum/quest/kill/clearout()
		if(QUEST_RAID)
			return new /datum/quest/kill/raid()
		if(QUEST_BOUNTY)
			return new /datum/quest/kill/bounty()
		if(QUEST_RECOVERY)
			return new /datum/quest/kill/recovery()
		if(QUEST_BLOCKADE_DEFENSE)
			return new /datum/quest/kill/blockade_defense()
	return null

/datum/controller/subsystem/questpool/proc/claim(datum/quest/Q, mob/user)
	if(!Q || !(Q in pool))
		return FALSE
	if(!Q.can_claim(user))
		return FALSE
	var/obj/effect/landmark/quest_spawner/landmark = resolve_or_repick_landmark(Q)
	if(!landmark)
		log_event("claim_failed", "no landmark available for [Q.quest_difficulty] [Q.quest_type]")
		return FALSE
	// Remove from pool BEFORE materialize — materialize can sleep (spawn_kill_mobs contains
	// sleep(1) per spawn), and a double-click ui_act can otherwise re-enter this proc, pass the
	// `Q in pool` check, and materialize the same quest twice (double scrolls, double mob waves).
	pool -= Q
	adjust_region_count(Q, -1)
	if(!Q.materialize(landmark))
		// Materialize failed during setup — put it back so someone else (or a retry) can take it.
		if(!(Q in pool))
			pool += Q
			adjust_region_count(Q, 1)
		log_event("claim_failed", "materialize failed for [Q.quest_difficulty] [Q.quest_type]")
		return FALSE
	Q.on_claim(user)
	record_round_statistic(STATS_CONTRACTS_TAKEN)
	switch(Q.source)
		if(QUEST_SOURCE_POOL)
			record_round_statistic(STATS_CONTRACTS_TAKEN_POOL)
		if(QUEST_SOURCE_RUMOR)
			record_round_statistic(STATS_CONTRACTS_TAKEN_RUMOR)
		if(QUEST_SOURCE_DEFENSE)
			record_round_statistic(STATS_CONTRACTS_TAKEN_DEFENSE)
	log_event("claim", "[describe_user(user)] took [Q.quest_difficulty] [Q.quest_type]")
	return TRUE

/datum/controller/subsystem/questpool/proc/resolve_or_repick_landmark(datum/quest/Q)
	var/obj/effect/landmark/quest_spawner/landmark = Q.pending_landmark_ref?.resolve()
	if(landmark && !QDELETED(landmark))
		return landmark
	landmark = find_quest_landmark(Q.quest_type, Q.region)
	if(landmark)
		Q.pending_landmark_ref = WEAKREF(landmark)
		Q.target_spawn_area = get_area_name(get_turf(landmark))
	return landmark

/datum/controller/subsystem/questpool/proc/prune_recent_takes(ckey)
	var/list/takes = recent_takes[ckey]
	if(!takes)
		return null
	var/cutoff = world.time - QUEST_TAKE_COOLDOWN
	while(length(takes) && takes[1] < cutoff)
		takes.Cut(1, 2)
	if(!length(takes))
		recent_takes -= ckey
		return null
	return takes

/datum/controller/subsystem/questpool/proc/is_on_take_cooldown(mob/user)
	if(!user?.ckey)
		return FALSE
	var/list/takes = prune_recent_takes(user.ckey)
	return takes && length(takes) >= QUEST_TAKE_COOLDOWN_SLOTS

/datum/controller/subsystem/questpool/proc/take_cooldown_remaining(mob/user)
	if(!user?.ckey)
		return 0
	var/list/takes = prune_recent_takes(user.ckey)
	if(!takes || length(takes) < QUEST_TAKE_COOLDOWN_SLOTS)
		return 0
	return max(0, takes[1] + QUEST_TAKE_COOLDOWN - world.time)

/datum/controller/subsystem/questpool/proc/mark_taken(mob/user)
	if(!user?.ckey)
		return
	var/list/takes = recent_takes[user.ckey]
	if(!takes)
		takes = list()
		recent_takes[user.ckey] = takes
	takes += world.time

/datum/controller/subsystem/questpool/proc/mark_abandoned(mob/user, datum/quest/Q, forfeited)
	record_round_statistic(STATS_CONTRACTS_ABANDONED)
	if(forfeited)
		record_round_statistic(STATS_CONTRACT_MAMMONS_FORFEITED, forfeited)
	log_event("abandon", "[describe_user(user)] forfeited [forfeited] on [Q?.quest_difficulty] [Q?.quest_type]")

/datum/controller/subsystem/questpool/proc/record_completion(mob/user, datum/quest/Q, paid, taxed)
	record_round_statistic(STATS_CONTRACTS_COMPLETED)
	switch(Q?.source)
		if(QUEST_SOURCE_POOL)
			record_round_statistic(STATS_CONTRACTS_COMPLETED_POOL)
		if(QUEST_SOURCE_RUMOR)
			record_round_statistic(STATS_CONTRACTS_COMPLETED_RUMOR)
		if(QUEST_SOURCE_DEFENSE)
			record_round_statistic(STATS_CONTRACTS_COMPLETED_DEFENSE)
	if(paid)
		record_round_statistic(STATS_CONTRACT_MAMMONS_PAID, paid)
	if(taxed)
		record_round_statistic(STATS_CONTRACT_MAMMONS_TAXED, taxed)
	log_event("complete", "[describe_user(user)] finished [Q?.quest_difficulty] [Q?.quest_type] (paid [paid], taxed [taxed])")

/datum/controller/subsystem/questpool/proc/describe_user(mob/user)
	if(!user)
		return "unknown"
	var/name = user.real_name || "unknown"
	var/role = user.job || "no role"
	return "[user.ckey] ([name], [role])"

/datum/controller/subsystem/questpool/proc/log_event(category, msg)
	event_log += "[station_time_timestamp()] [category]: [msg]"

/datum/controller/subsystem/questpool/proc/count_active_for(mob/user)
	if(!user)
		return 0
	var/datum/weakref/user_ref = WEAKREF(user)
	var/count = 0
	for(var/obj/item/quest_writ/scroll in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(!Q || Q.complete)
			continue
		if(Q.quest_receiver_reference == user_ref)
			count++
	return count
