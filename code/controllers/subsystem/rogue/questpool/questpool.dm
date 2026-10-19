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
	var/list/pool_weights = list()
	var/debug_mode = FALSE

/datum/controller/subsystem/questpool/Initialize(mapload)
	for(var/qtype in GLOB.quest_prototypes)
		var/datum/quest/proto = GLOB.quest_prototypes[qtype]
		if(proto.pool_kind && proto.pool_weight > 0)
			if(!pool_weights[proto.pool_kind])
				pool_weights[proto.pool_kind] = list()
			pool_weights[proto.pool_kind][qtype] = proto.pool_weight
	init_quest_factions()
	// Front-load every region to its full target so roundstart has a healthy mix.
	regen_kill_targets(total_kill_target())
	regen_fetch_targets()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death))
	return ..()

/datum/controller/subsystem/questpool/proc/on_mob_death(datum/source, mob/living/dead, gibbed)
	SIGNAL_HANDLER
	if(!istype(dead) || !dead.ckey)
		return
	for(var/datum/quest/Q as anything in get_scroll_quests())
		if(Q.complete)
			continue
		var/mob/living/bearer = Q.quest_receiver_reference?.resolve()
		if(!istype(bearer))
			continue
		if(dead != bearer && !bearer.current_fellowship?.has_member(dead))
			continue
		record_contract_stat(Q, CONTRACT_STAT_DEATHS)

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
	reroll_stale()
	regen_kill_targets(QUEST_KILL_REGEN_PER_TICK)
	regen_fetch_targets()

/// Bumps the region count for Q's kind by delta. Called whenever a quest enters
/// or leaves the pool so count_*_in stays O(1). No-op if Q has no region set.
/datum/controller/subsystem/questpool/proc/adjust_region_count(datum/quest/Q, delta)
	if(!Q?.region || !delta)
		return
	if(Q.pool_kind == QUEST_POOL_KILL)
		var/new_count = (kill_count_by_region[Q.region] || 0) + delta
		if(new_count <= 0)
			kill_count_by_region -= Q.region
		else
			kill_count_by_region[Q.region] = new_count
	else if(Q.pool_kind == QUEST_POOL_EVERGREEN)
		var/new_count = (evergreen_count_by_region[Q.region] || 0) + delta
		if(new_count <= 0)
			evergreen_count_by_region -= Q.region
		else
			evergreen_count_by_region[Q.region] = new_count

/datum/controller/subsystem/questpool/proc/has_landmark_for_region(region)
	for(var/obj/effect/landmark/quest_spawner/landmark as anything in GLOB.quest_landmarks_list)
		if(QDELETED(landmark))
			continue
		if(region && landmark.region != region)
			continue
		return TRUE
	return FALSE

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

/// Returns the region furthest below its kill target by fill ratio, or null if all are at target.
/datum/controller/subsystem/questpool/proc/pick_neediest_kill_region()
	var/pop = GLOB.player_list.len
	var/lowest_ratio = 1
	var/datum/threat_region/chosen
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		var/target = TR.get_kill_target(pop)
		if(!target)
			continue
		if(!region_allows_pool(TR, QUEST_POOL_KILL))
			continue
		var/have = count_kill_quests_in(TR.region_name)
		if(have >= target)
			continue
		var/ratio = have / target
		if(ratio < lowest_ratio)
			lowest_ratio = ratio
			chosen = TR
	return chosen

/proc/region_allows_pool(datum/threat_region/TR, pool_kind)
	for(var/qtype in SSquestpool.pool_weights[pool_kind])
		if(TR.allows_quest_type(qtype))
			return TRUE
	return FALSE

/datum/controller/subsystem/questpool/proc/regen_kill_targets(count)
	for(var/i in 1 to count)
		var/datum/threat_region/TR = pick_neediest_kill_region()
		if(!TR)
			return
		var/type = pick_pool_type_for(TR, QUEST_POOL_KILL)
		if(!type)
			continue
		generate_one(type, TR)

/datum/controller/subsystem/questpool/proc/regen_fetch_targets()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		if(!TR.evergreen_target)
			continue
		if(!region_allows_pool(TR, QUEST_POOL_EVERGREEN))
			continue
		var/have = count_evergreen_quests_in(TR.region_name)
		var/needed = TR.evergreen_target - have
		for(var/i in 1 to needed)
			var/type = pick_pool_type_for(TR, QUEST_POOL_EVERGREEN)
			if(!type)
				break
			generate_one(type, TR)

/datum/controller/subsystem/questpool/proc/pick_pool_type_for(datum/threat_region/TR, pool_kind)
	var/list/weights = list()
	for(var/qtype in pool_weights[pool_kind])
		if(TR.allows_quest_type(qtype))
			weights[qtype] = pool_weights[pool_kind][qtype]
	if(!length(weights))
		return null
	return pickweight(weights)

/datum/controller/subsystem/questpool/proc/reroll_stale()
	var/list/stale = list()
	var/kill_replacements_needed = 0
	for(var/datum/quest/Q as anything in pool)
		if(!Q.lapses || Q.get_lapse_time() >= world.time)
			continue
		stale += Q
		if(Q.pool_kind == QUEST_POOL_KILL)
			kill_replacements_needed++
	if(!length(stale))
		return
	// Batch removal: one pool -= list shifts the array once instead of N times.
	pool -= stale
	for(var/datum/quest/Q as anything in stale)
		adjust_region_count(Q, -1)
		log_event("reroll", "stale [Q.quest_difficulty] [Q.quest_type]")
		record_contract_stat(Q, CONTRACT_STAT_LAPSED)
		record_source_statistic(Q, CONTRACT_STAT_LAPSED)
		if(refund_closed_posting(Q, QUEST_ISSUE_STATUS_LAPSED, REFUND_ON_NOT_TAKEN, "Lapsed posting refund", "lapsed untaken"))
			record_round_statistic(STATS_CONTRACTS_LAPSE_REFUNDED)
		qdel(Q)
		record_round_statistic(STATS_CONTRACTS_REROLLED)
	for(var/i in 1 to kill_replacements_needed)
		var/datum/threat_region/TR = pick_neediest_kill_region()
		if(!TR)
			break
		var/type = pick_pool_type_for(TR, QUEST_POOL_KILL)
		if(!type)
			continue
		generate_one(type, TR, is_replacement = TRUE)

/datum/controller/subsystem/questpool/proc/refund_closed_posting(datum/quest/Q, status, fraction, reason, outcome)
	var/label = Q.get_title() || Q.quest_type
	var/refund_text = Q.refund_issuer_funding(reason, null, fraction)
	Q.mark_issue_log(status, refund_text)
	if(!refund_text)
		return
	log_event("[status]_refund", "[Q.source] [Q.quest_type] \"[label]\" by [Q.quest_giver_name || "unknown"] refunded [refund_text]")
	log_game("Contract posting \"[label]\" ([Q.source], issued by [Q.quest_giver_name || "unknown"]) [outcome] - refunded [refund_text].")
	var/mob/poster = Q.quest_giver_reference?.resolve()
	if(poster)
		to_chat(poster, span_notice("Your posting <b>[label]</b> [outcome]. Refunded [refund_text]."))
	return refund_text

/datum/controller/subsystem/questpool/proc/remove_from_pool(datum/quest/Q)
	if(!(Q in pool))
		return FALSE
	pool -= Q
	adjust_region_count(Q, -1)
	return TRUE

/datum/controller/subsystem/questpool/proc/create_issued_quest(type, source, mob/giver)
	var/datum/quest/Q = instantiate_quest_of_type(type)
	if(!Q)
		return null
	Q.source = source
	Q.created_at = world.time
	Q.issued_day = GLOB.dayspassed
	if(giver)
		Q.quest_giver_name = giver.real_name
		Q.quest_giver_reference = WEAKREF(giver)
	Q.deposit_amount = Q.calculate_deposit()
	return Q

/datum/controller/subsystem/questpool/proc/place_quest(datum/quest/Q, datum/threat_region/TR)
	if(!TR)
		TR = SSregionthreat.pick_region_for_quest(Q.quest_type)
	var/obj/effect/landmark/quest_spawner/landmark = find_quest_landmark(Q.quest_type, TR?.region_name, Q)
	if(!landmark || !Q.preview(landmark))
		qdel(Q)
		return null
	var/turf/landmark_turf = get_turf(landmark)
	var/turf/origin = get_nearest_ledger_turf(landmark_turf) || landmark_turf
	Q.reward_amount = Q.calculate_reward(origin, landmark_turf)
	return landmark

/datum/controller/subsystem/questpool/proc/add_to_pool(datum/quest/Q)
	pool += Q
	adjust_region_count(Q, 1)

/datum/controller/subsystem/questpool/proc/record_issued(datum/quest/Q, count_generated = TRUE)
	if(count_generated)
		record_round_statistic(STATS_CONTRACTS_GENERATED)
		record_source_statistic(Q, CONTRACT_STAT_POSTED)
	record_contract_stat(Q, CONTRACT_STAT_POSTED)

/datum/controller/subsystem/questpool/proc/issue_player_quest(type, source, datum/threat_region/TR, area/override_destination, in_hands = FALSE, mob/living/carbon/human/issuer = null)
	if(in_hands && !issuer)
		return null
	var/datum/quest/Q = create_issued_quest(type, source, issuer)
	if(!Q)
		return null
	if(Q.takes_destination)
		Q.override_destination = override_destination
	var/obj/effect/landmark/quest_spawner/landmark = place_quest(Q, TR)
	if(!landmark)
		return null
	if(in_hands)
		if(!Q.materialize(landmark))
			qdel(Q)
			return null
		Q.materialized = TRUE
		Q.bind_new_scroll(issuer)
	else
		add_to_pool(Q)
	record_issued(Q)
	log_event("generate", "[source]-[in_hands ? "in-hands" : "pool"] [Q.quest_difficulty] [type] at [Q.target_spawn_area || "unknown"] (reward [Q.reward_amount])")
	return Q

/// Bearer-bond scroll is spawned straight into the Steward's hand. Wave 1 materializes
/// on first scroll-open, not at issue time — see quest_scroll_blockade.attack_self.
/datum/controller/subsystem/questpool/proc/issue_blockade_defense_quest(datum/blockade/B, mob/living/carbon/human/steward)
	if(!B || !steward)
		return null
	if(B.has_active_scroll())
		return null
	var/datum/economic_region/ER = B.get_region()
	var/datum/threat_region/TR = B.get_threat_region()
	if(!ER || !TR)
		return null
	var/datum/quest/kill/blockade_defense/Q = create_issued_quest(QUEST_BLOCKADE_DEFENSE, QUEST_SOURCE_BLOCKADE, steward)
	if(!Q)
		return null
	Q.blockade_ref = WEAKREF(B)
	Q.reward_amount = BLOCKADE_SCROLL_REWARD + TR.blockade_travel_fee
	if(!place_quest(Q, TR))
		return null
	var/obj/item/quest_writ/scroll = Q.bind_new_scroll(steward)
	B.active_scroll_ref = WEAKREF(scroll)
	B.active_quest_ref = WEAKREF(Q)
	record_issued(Q)
	log_event("generate", "blockade-defense in-hand for [ER.name] (faction [Q.faction_id], reward [Q.reward_amount])")
	return Q

/// Hoard Recovery: a writ against a region's brigands to reclaim the banditry hoard.
/// No /datum/blockade is involved - the writ binds to the threat region alone, so
/// hoard-bearing regions without an economic region (Terrorbog) work. Raised either by a
/// fellowship's own pledge (is_commission = FALSE, fellowship-gated at issue) or drafted
/// by the Steward like any defense writ (is_commission = TRUE, fellowship-gated only when
/// pinned to the ledger).
/datum/controller/subsystem/questpool/proc/issue_hoard_recovery_request(datum/threat_region/TR, mob/living/carbon/human/requester, is_commission = FALSE)
	if(!TR || !requester)
		return null
	var/fid = SSeconomy.pick_blockade_faction_for(TR)
	if(!fid)
		return null
	var/datum/quest/kill/blockade_defense/hoard_recovery/Q = create_issued_quest(QUEST_HOARD_RECOVERY, QUEST_SOURCE_BLOCKADE, requester)
	if(!Q)
		return null
	Q.faction_id = fid
	Q.reward_amount = BLOCKADE_SCROLL_REWARD + TR.blockade_travel_fee
	Q.required_fellowship_size = is_commission ? 0 : BLOCKADE_FELLOWSHIP_REQUIREMENT
	Q.raised_by_fellowship = !is_commission
	Q.issuer_may_claim = !is_commission
	if(!place_quest(Q, TR))
		return null
	Q.bind_new_scroll(requester)
	TR.active_hoard_recovery_ref = WEAKREF(Q)
	record_issued(Q)
	log_event("generate", "hoard-recovery [is_commission ? "commission" : "request"] in-hand for [TR.region_name] (faction [Q.faction_id], hoard [TR.banditry_hoard])")
	return Q

/datum/controller/subsystem/questpool/proc/issue_towner_quest(type, mob/living/carbon/human/poster, posting_tier = TOWNER_POSTING_TIER_MEDIUM, to_hand = FALSE, loadout_variety = null)
	if(!type || !poster)
		return null
	var/datum/quest/kill/recovery/towner/TQ = create_issued_quest(type, QUEST_SOURCE_TOWNER, poster)
	if(!istype(TQ))
		qdel(TQ)
		return null
	TQ.posting_tier = posting_tier
	TQ.loadout_variety = loadout_variety
	TQ.quest_difficulty = get_towner_tier_term(posting_tier, "difficulty") || QUEST_DIFFICULTY_EASY
	if(!place_quest(TQ, null))
		return null
	if(to_hand)
		TQ.bind_new_scroll(poster)
	else
		add_to_pool(TQ)
	record_issued(TQ)
	log_event("generate", "towner-[to_hand ? "hand" : "pool"] [TQ.quest_difficulty] [type] at [TQ.target_spawn_area || "unknown"] (poster [poster.real_name], tier [posting_tier], variety [TQ.effective_variety() || "none"], reward [TQ.reward_amount])")
	return TQ

/datum/controller/subsystem/questpool/proc/issue_gm_quest(datum/quest/Q, datum/threat_region/TR, reward, turf/floor_turf, mob/admin)
	if(!Q || !TR)
		qdel(Q)
		return null
	if(!Q.quest_giver_name)
		Q.quest_giver_name = "The [SSticker.realm_type] of [SSticker.realm_name]"
	if(!place_quest(Q, TR))
		return null
	Q.reward_amount = reward
	if(floor_turf)
		Q.bind_new_scroll(null, floor_turf)
	else
		add_to_pool(Q)
	record_issued(Q)
	log_event("generate", "gm-[floor_turf ? "floor" : "pool"] [Q.quest_type] at [Q.target_spawn_area || "unknown"] (reward [Q.reward_amount])")
	var/placement = floor_turf ? "the scroll has been dropped on the floor" : "has been added to the ledger"
	log_admin("[key_name(admin)]: A custom quest ([Q.title]) has been created for [TR.region_name] and [placement]. (reward [reward])")
	message_admins("[key_name_admin(admin)]: A custom quest ([Q.title]) has been created for [TR.region_name] and [placement]. (reward [reward])")
	return Q

/datum/controller/subsystem/questpool/proc/withdraw_gm_quest(datum/quest/Q, mob/admin)
	if(!Q || Q.source != QUEST_SOURCE_GM)
		return FALSE
	var/label = Q.get_title() || Q.quest_type
	var/mob/bearer = Q.quest_receiver_reference?.resolve()
	if(bearer)
		to_chat(bearer, span_warning("The contract <b>[label]</b> has been withdrawn by its issuer. The scroll crumbles to dust."))
	var/obj/item/quest_writ/writ = Q.quest_scroll_ref?.resolve()
	var/mob/holder = writ ? get(writ, /mob) : null
	if(holder && holder != bearer)
		to_chat(holder, span_warning("\The [writ] you carry crumbles to dust. Its issuer has withdrawn the contract."))
	if(istype(Q, /datum/quest/kill))
		var/datum/quest/kill/KQ = Q
		KQ.despawn_live_hunt_mobs()
	remove_from_pool(Q)
	record_round_statistic(STATS_CONTRACTS_WITHDRAWN)
	if(Q.quest_receiver_reference)
		record_contract_stat(Q, CONTRACT_STAT_WITHDRAWN)
	log_event("withdraw", "[describe_user(admin)] withdrew [Q.source] [Q.quest_type] \"[label]\"")
	qdel(Q)
	return TRUE

/datum/controller/subsystem/questpool/proc/generate_one(type, datum/threat_region/preferred_region, is_replacement = FALSE)
	var/datum/quest/Q = create_issued_quest(type, QUEST_SOURCE_POOL)
	if(!Q)
		return null
	Q.created_at = world.time + rand(0, QUEST_POOL_STALE_JITTER)
	if(!place_quest(Q, preferred_region))
		return null
	add_to_pool(Q)
	// Skip the generation counter when this is a stale-reroll replacement - reroll already bumped STATS_CONTRACTS_REROLLED.
	record_issued(Q, count_generated = !is_replacement)
	log_event("generate", "[Q.quest_difficulty] [type] at [Q.target_spawn_area || "unknown"] (reward [Q.reward_amount])")
	return Q

/datum/controller/subsystem/questpool/proc/instantiate_quest_of_type(type)
	var/datum/quest/proto = GLOB.quest_prototypes[type]
	if(!proto)
		return null
	return new proto.type()

/datum/controller/subsystem/questpool/proc/claim(datum/quest/Q, mob/user)
	if(!Q || !(Q in pool))
		return FALSE
	if(!Q.can_claim(user))
		return FALSE
	var/obj/effect/landmark/quest_spawner/landmark = resolve_or_repick_landmark(Q)
	if(!landmark)
		log_event("claim_failed", "no landmark available for [Q.quest_difficulty] [Q.quest_type]")
		return FALSE
	pool -= Q
	adjust_region_count(Q, -1)
	if(!Q.materialize(landmark))
		if(!(Q in pool))
			pool += Q
			adjust_region_count(Q, 1)
		log_event("claim_failed", "materialize failed for [Q.quest_difficulty] [Q.quest_type]")
		return FALSE
	Q.materialized = TRUE
	Q.on_claim(user)
	record_round_statistic(STATS_CONTRACTS_TAKEN)
	record_source_statistic(Q, CONTRACT_STAT_TAKEN)
	log_event("claim", "[describe_user(user)] took [Q.quest_difficulty] [Q.quest_type]")
	return TRUE

/datum/controller/subsystem/questpool/proc/resolve_or_repick_landmark(datum/quest/Q)
	var/obj/effect/landmark/quest_spawner/landmark = Q.pending_landmark_ref?.resolve()
	if(landmark && !QDELETED(landmark))
		return landmark
	landmark = find_quest_landmark(Q.quest_type, Q.region, Q)
	if(!landmark)
		landmark = find_quest_landmark(Q.quest_type, null, Q)
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
	return takes && length(takes) >= get_active_quest_cap(user)

/datum/controller/subsystem/questpool/proc/take_cooldown_remaining(mob/user)
	if(!user?.ckey)
		return 0
	var/list/takes = prune_recent_takes(user.ckey)
	if(!takes || length(takes) < get_active_quest_cap(user))
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
	record_contract_stat(Q, CONTRACT_STAT_ABANDONED)
	if(forfeited)
		record_round_statistic(STATS_CONTRACT_MAMMONS_FORFEITED, forfeited)
	log_event("abandon", "[describe_user(user)] forfeited [forfeited] on [Q?.quest_difficulty] [Q?.quest_type]")

/datum/controller/subsystem/questpool/proc/record_completion(mob/user, datum/quest/Q, paid, taxed)
	record_round_statistic(STATS_CONTRACTS_COMPLETED)
	record_source_statistic(Q, CONTRACT_STAT_COMPLETED)
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
