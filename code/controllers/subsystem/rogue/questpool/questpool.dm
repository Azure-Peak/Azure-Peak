SUBSYSTEM_DEF(questpool)
	name = "Quest Pool"
	wait = QUEST_POOL_REGEN_INTERVAL
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	init_order = INIT_ORDER_DEFAULT

	var/list/datum/quest/pool = list()
	var/list/abandon_cooldowns = list()
	var/list/event_log = list()

/datum/controller/subsystem/questpool/Initialize()
	regen_to_targets(get_total_target())
	return ..()

/datum/controller/subsystem/questpool/fire(resumed)
	reroll_stale()
	regen_to_targets(get_regen_per_tick())

/datum/controller/subsystem/questpool/proc/get_regen_per_tick()
	return max(1, round(GLOB.player_list.len / QUEST_POOL_REGEN_DIVISOR))

/datum/controller/subsystem/questpool/proc/get_target_for(difficulty)
	var/pop = GLOB.player_list.len
	switch(difficulty)
		if(QUEST_DIFFICULTY_EASY)
			return max(QUEST_POOL_FLOOR_EASY, round(pop * QUEST_POOL_FRACTION_EASY))
		if(QUEST_DIFFICULTY_MEDIUM)
			return max(QUEST_POOL_FLOOR_MEDIUM, round(pop * QUEST_POOL_FRACTION_MEDIUM))
		if(QUEST_DIFFICULTY_HARD)
			return max(QUEST_POOL_FLOOR_HARD, round(pop * QUEST_POOL_FRACTION_HARD))
	return 0

/datum/controller/subsystem/questpool/proc/get_total_target()
	return get_target_for(QUEST_DIFFICULTY_EASY) \
		+ get_target_for(QUEST_DIFFICULTY_MEDIUM) \
		+ get_target_for(QUEST_DIFFICULTY_HARD)

/datum/controller/subsystem/questpool/proc/count_for_difficulty(difficulty)
	var/count = 0
	for(var/datum/quest/Q as anything in pool)
		if(Q.quest_difficulty == difficulty)
			count++
	return count

/// Returns the difficulty furthest below its target by fill ratio, or null if all are at/above.
/datum/controller/subsystem/questpool/proc/pick_neediest_difficulty()
	var/list/difficulties = list(
		QUEST_DIFFICULTY_EASY,
		QUEST_DIFFICULTY_MEDIUM,
		QUEST_DIFFICULTY_HARD,
	)
	var/lowest_ratio = 1
	var/chosen = null
	for(var/diff in difficulties)
		var/target = get_target_for(diff)
		if(!target)
			continue
		var/have = count_for_difficulty(diff)
		if(have >= target)
			continue
		var/ratio = have / target
		if(ratio < lowest_ratio)
			lowest_ratio = ratio
			chosen = diff
	return chosen

/datum/controller/subsystem/questpool/proc/regen_to_targets(count)
	for(var/i in 1 to count)
		var/difficulty = pick_neediest_difficulty()
		if(!difficulty)
			return
		generate_one(difficulty)

/datum/controller/subsystem/questpool/proc/reroll_stale()
	var/cutoff = world.time - QUEST_POOL_STALE_THRESHOLD
	for(var/datum/quest/Q as anything in pool)
		if(Q.created_at >= cutoff)
			continue
		pool -= Q
		log_event("reroll", "stale [Q.quest_difficulty] [Q.quest_type]")
		qdel(Q)
		record_round_statistic(STATS_CONTRACTS_REROLLED)
		var/difficulty = pick_neediest_difficulty()
		if(!difficulty)
			continue
		generate_one(difficulty)

/datum/controller/subsystem/questpool/proc/generate_one(difficulty)
	var/type = pick_type_for(difficulty)
	if(!type)
		return null
	var/datum/quest/Q = instantiate_quest_of_type(type)
	if(!Q)
		return null
	Q.quest_difficulty = difficulty
	Q.source = QUEST_SOURCE_POOL
	Q.created_at = world.time
	Q.deposit_amount = Q.calculate_deposit()
	var/obj/effect/landmark/quest_spawner/landmark = find_quest_landmark(difficulty, type)
	if(!landmark)
		qdel(Q)
		return null
	if(!Q.generate(landmark))
		qdel(Q)
		return null
	Q.reward_amount = Q.calculate_reward(get_turf(landmark))
	pool += Q
	record_round_statistic(STATS_CONTRACTS_GENERATED)
	log_event("generate", "[difficulty] [type] at [Q.target_spawn_area || "unknown"] (reward [Q.reward_amount])")
	return Q

/datum/controller/subsystem/questpool/proc/pick_type_for(difficulty)
	switch(difficulty)
		if(QUEST_DIFFICULTY_EASY)
			return pickweight(QUEST_POOL_WEIGHTS_EASY)
		if(QUEST_DIFFICULTY_MEDIUM)
			return pickweight(QUEST_POOL_WEIGHTS_MEDIUM)
		if(QUEST_DIFFICULTY_HARD)
			return pickweight(QUEST_POOL_WEIGHTS_HARD)
	return null

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
		if(QUEST_OUTLAW)
			return new /datum/quest/kill/outlaw()
	return null

/datum/controller/subsystem/questpool/proc/claim(datum/quest/Q, mob/user)
	if(!Q || !(Q in pool))
		return FALSE
	if(!Q.can_claim(user))
		return FALSE
	pool -= Q
	Q.on_claim(user)
	record_round_statistic(STATS_CONTRACTS_TAKEN)
	log_event("claim", "[describe_user(user)] took [Q.quest_difficulty] [Q.quest_type]")
	return TRUE

/datum/controller/subsystem/questpool/proc/is_on_abandon_cooldown(mob/user)
	if(!user?.ckey)
		return FALSE
	var/free_at = abandon_cooldowns[user.ckey]
	return free_at && free_at > world.time

/datum/controller/subsystem/questpool/proc/abandon_cooldown_remaining(mob/user)
	if(!user?.ckey)
		return 0
	var/free_at = abandon_cooldowns[user.ckey]
	return free_at ? max(0, free_at - world.time) : 0

/datum/controller/subsystem/questpool/proc/mark_abandoned(mob/user, datum/quest/Q, forfeited)
	if(user?.ckey)
		abandon_cooldowns[user.ckey] = world.time + QUEST_ABANDON_COOLDOWN
	record_round_statistic(STATS_CONTRACTS_ABANDONED)
	if(forfeited)
		record_round_statistic(STATS_CONTRACT_MAMMONS_FORFEITED, forfeited)
	log_event("abandon", "[describe_user(user)] forfeited [forfeited] on [Q?.quest_difficulty] [Q?.quest_type]")

/datum/controller/subsystem/questpool/proc/record_completion(mob/user, datum/quest/Q, paid, taxed)
	record_round_statistic(STATS_CONTRACTS_COMPLETED)
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
	for(var/obj/item/paper/scroll/quest/scroll in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(!Q || Q.complete)
			continue
		if(Q.quest_receiver_reference == user_ref)
			count++
	return count
