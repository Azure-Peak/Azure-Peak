/**
 * Passive contract pool.
 *
 * Pre-generates a set of unclaimed contracts (/datum/quest instances without a receiver) that
 * the Grand Contract Ledger surfaces to players. Pool size is scaled to the current population
 * and replenished on a cadence controlled by QUEST_POOL_* defines in __DEFINES/questing.dm.
 *
 * Claiming a pool contract is done via claim(quest, user) - this hands off ownership, sets the
 * receiver, and removes it from the pool. Deposits, scroll creation, and refunds stay the
 * responsibility of the caller (the ledger obj).
 */
SUBSYSTEM_DEF(questpool)
	name = "Quest Pool"
	wait = QUEST_POOL_REGEN_INTERVAL
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	init_order = INIT_ORDER_DEFAULT

	/// Unclaimed /datum/quest instances awaiting pickup from the ledger.
	var/list/datum/quest/pool = list()

/datum/controller/subsystem/questpool/Initialize()
	// Prime the pool so the first player to open the ledger has something to take.
	top_up_pool(get_desired_pool_size())
	return ..()

/datum/controller/subsystem/questpool/fire(resumed)
	expire_stale()
	var/desired = get_desired_pool_size()
	var/shortfall = desired - length(pool)
	if(shortfall <= 0)
		return
	top_up_pool(min(shortfall, QUEST_POOL_REGEN_PER_TICK))

/datum/controller/subsystem/questpool/proc/get_desired_pool_size()
	var/population = GLOB.player_list.len
	var/size = QUEST_POOL_BASELINE + round(population / QUEST_POOL_PER_PLAYERS)
	return min(size, QUEST_POOL_MAX)

/datum/controller/subsystem/questpool/proc/top_up_pool(count)
	for(var/i in 1 to count)
		if(length(pool) >= QUEST_POOL_MAX)
			break
		generate_one()

/datum/controller/subsystem/questpool/proc/expire_stale()
	var/cutoff = world.time - QUEST_POOL_CONTRACT_TTL
	for(var/datum/quest/Q as anything in pool)
		if(Q.created_at < cutoff)
			pool -= Q
			qdel(Q)

/datum/controller/subsystem/questpool/proc/generate_one()
	var/difficulty = pickweight(list(
		QUEST_DIFFICULTY_EASY = QUEST_POOL_WEIGHT_EASY,
		QUEST_DIFFICULTY_MEDIUM = QUEST_POOL_WEIGHT_MEDIUM,
		QUEST_DIFFICULTY_HARD = QUEST_POOL_WEIGHT_HARD,
	))
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

/**
 * Hand a pooled contract to a claimant. Returns TRUE on success; the caller is responsible for
 * charging the deposit, spawning the scroll, and otherwise finishing the handoff.
 */
/datum/controller/subsystem/questpool/proc/claim(datum/quest/Q, mob/user)
	if(!Q || !(Q in pool))
		return FALSE
	if(!Q.can_claim(user))
		return FALSE
	pool -= Q
	Q.on_claim(user)
	return TRUE

/// Count of currently-active pool contracts assigned to a given user.
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
