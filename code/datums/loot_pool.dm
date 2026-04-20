GLOBAL_LIST_EMPTY(loot_pools)
GLOBAL_LIST_EMPTY(loot_spawners_pending)
GLOBAL_LIST_EMPTY(loot_chests_pending)
GLOBAL_LIST_EMPTY(loot_spawners_poolless)
/// Set of pool keys whose owning area is loot_pool_deferred. Pools in this set accumulate spawners across multiple InitializeAtoms calls and are only processed when process_deferred_loot_pools(key) is called.
GLOBAL_LIST_EMPTY(loot_pools_deferred_keys)
/// Set of deferred pool keys that have already been finalized. Stragglers loaded after finalization fire normally instead of pooling.
GLOBAL_LIST_EMPTY(loot_pools_deferred_finalized)

/datum/loot_pool
	/// Pool key identifier (area type or shared key string)
	var/pool_key
	/// Total mammon budget available
	var/available_mammons = 0
	/// Whether this pool has already been processed
	var/processed = FALSE
	/// Spawners registered to this pool
	var/list/spawners = list()

/datum/loot_pool/New(pool_key, budget)
	..()
	src.pool_key = pool_key
	src.available_mammons = budget

/datum/loot_pool/Destroy()
	spawners = null
	return ..()

/datum/loot_pool/proc/register(obj/effect/spawner/lootdrop/spawner)
	spawners += spawner

/// Register a loot chest with this pool
/datum/loot_pool/proc/register_chest(obj/structure/closet/crate/chest/loot_chest/chest)
	spawners += chest

/datum/loot_pool/proc/process_pool()
	if(processed)
		return
	processed = TRUE

	var/total_spawners = length(spawners)
	var/funded_count = 0
	var/junk_count = 0
	var/bonus_count = 0
	var/starting_budget = available_mammons

	shuffle_inplace(spawners)

	// Track funded spawner locations + types for bonus re-rolls
	var/list/funded_turfs = list() // turf refs where funded spawners were
	var/list/funded_types = list() // spawner type paths that were funded

	// Main pass - remove refs before qdel to prevent hard deletes
	while(length(spawners))
		var/atom/spawner = spawners[length(spawners)]
		spawners.len--
		if(istype(spawner, /obj/effect/spawner/lootdrop))
			var/obj/effect/spawner/lootdrop/S = spawner
			if(available_mammons >= S.loot_value)
				S.spawn_loot()
				available_mammons -= S.loot_value
				funded_count++
				var/turf/T = get_turf(S)
				if(T)
					funded_turfs += T
					funded_types += S.type
			else
				S.spawn_junk()
				junk_count++
			qdel(S)
		else if(istype(spawner, /obj/structure/closet/crate/chest/loot_chest))
			var/obj/structure/closet/crate/chest/loot_chest/C = spawner
			if(available_mammons >= C.loot_value)
				C.generate_loot()
				available_mammons -= C.loot_value
				funded_count++
			else
				C.spawn_junk()
				junk_count++
		CHECK_TICK

	// Bonus round - spend leftover budget by re-rolling from funded spawner types at funded locations
	// Cap bonus spawns to avoid flooding areas that have few spawners but large budgets
	var/max_bonus = max(funded_count, 1) // can't spawn more bonus items than we funded originally
	if(available_mammons > 0 && length(funded_turfs))
		while(available_mammons > 0 && length(funded_turfs) && bonus_count < max_bonus)
			var/idx = rand(1, length(funded_turfs))
			var/turf/T = funded_turfs[idx]
			var/spawner_type = funded_types[idx]
			var/loot_cost = initial(spawner_type:loot_value)
			if(available_mammons < loot_cost)
				// Can't afford any more of this type, remove it from candidates
				funded_turfs.Cut(idx, idx + 1)
				funded_types.Cut(idx, idx + 1)
				continue
			// Create a temporary spawner, fire it, clean up
			var/obj/effect/spawner/lootdrop/bonus = new spawner_type(T)
			// Bonus spawner inits and adds to pending list - remove it
			GLOB.loot_spawners_pending -= bonus
			bonus.spawn_loot()
			available_mammons -= loot_cost
			bonus_count++
			qdel(bonus)
			CHECK_TICK

	log_game("Loot Pool '[pool_key]': [starting_budget] mammons, [total_spawners] spawners, [funded_count] funded, [junk_count] junk, [bonus_count] bonus, [available_mammons] mammons remaining")

/// Resolves the pool key for a given area. Uses loot_pool_key if set, otherwise falls back to the area type.
/proc/get_area_pool_key(area/rogue/A)
	if(A.loot_pool_key)
		return A.loot_pool_key
	return A.type

/// Called from SSatoms after all atoms LateInitialize. Builds pools from areas, assigns spawners, processes.
/proc/process_all_loot_pools()
	// Phase 1: build pools from areas that have loot_budget set
	for(var/area/A in world)
		if(!istype(A, /area/rogue))
			continue
		var/area/rogue/RA = A
		if(RA.loot_budget <= 0)
			continue
		var/key = get_area_pool_key(RA)
		if(RA.loot_pool_deferred)
			if(GLOB.loot_pools_deferred_finalized[key])
				continue // post-finalization stragglers fall through to poolless and fire normally
			GLOB.loot_pools_deferred_keys[key] = TRUE
		if(GLOB.loot_pools[key])
			continue
		var/datum/loot_pool/pool = new(key, RA.loot_budget)
		GLOB.loot_pools[key] = pool
	CHECK_TICK

	// Phase 2: assign pending spawners to pools. Collect poolless ones separately to avoid hard deletes from list refs during qdel.
	var/list/poolless_spawners = list()
	for(var/obj/effect/spawner/lootdrop/spawner as anything in GLOB.loot_spawners_pending)
		var/area/rogue/A = get_area(spawner)
		if(!istype(A) || A.loot_budget <= 0)
			poolless_spawners += spawner
			continue
		var/key = get_area_pool_key(A)
		var/datum/loot_pool/pool = GLOB.loot_pools[key]
		if(!pool)
			poolless_spawners += spawner
			continue
		pool.register(spawner)
	GLOB.loot_spawners_pending.Cut()

	// Fire poolless spawners normally - clear ref before qdel
	// Skip logging for town/shelter/shop areas since those are intentionally poolless
	while(length(poolless_spawners))
		var/obj/effect/spawner/lootdrop/spawner = poolless_spawners[length(poolless_spawners)]
		poolless_spawners.len--
		var/area/A = get_area(spawner)
		var/turf/T = get_turf(spawner)
		var/area_desc = A ? "[A.type] ([A.name])" : "NO AREA"
		var/coords = T ? "([T.x],[T.y],[T.z])" : "(?,?,?)"
		// Only log spawners in non-town, non-hag areas (those are intentionally poolless)
		var/should_log = TRUE
		if(istype(A, /area/rogue/indoors/town) || istype(A, /area/rogue/under/town) || istype(A, /area/rogue/indoors/shelter/bog_hag))
			should_log = FALSE
		if(should_log)
			GLOB.loot_spawners_poolless += "[spawner.type] at [coords] in [area_desc]"
		spawner.spawn_loot()
		qdel(spawner)
		CHECK_TICK

	// Phase 2b: assign pending loot chests to their area's pool, or spawn normally if poolless
	for(var/obj/structure/closet/crate/chest/loot_chest/chest as anything in GLOB.loot_chests_pending)
		var/area/rogue/A = get_area(chest)
		if(!istype(A) || A.loot_budget <= 0)
			chest.generate_loot()
			CHECK_TICK
			continue
		var/key = get_area_pool_key(A)
		var/datum/loot_pool/pool = GLOB.loot_pools[key]
		if(!pool)
			chest.generate_loot()
			CHECK_TICK
			continue
		pool.register_chest(chest)
	GLOB.loot_chests_pending.Cut()

	// Phase 3: process each pool (skip deferred - those wait for explicit completion signal)
	for(var/pool_key in GLOB.loot_pools)
		if(GLOB.loot_pools_deferred_keys[pool_key])
			continue
		var/datum/loot_pool/pool = GLOB.loot_pools[pool_key]
		pool.process_pool()
		CHECK_TICK

	// Phase 4: diagnostic logging
	log_game("=== LOOT POOL DIAGNOSTICS ===")
	log_game("Pools created: [length(GLOB.loot_pools)]")

	for(var/key in GLOB.loot_pools)
		var/datum/loot_pool/pool = GLOB.loot_pools[key]
		log_game("  Pool '[key]': processed=[pool.processed]")

	if(length(GLOB.loot_spawners_poolless))
		log_game("POOLLESS SPAWNERS: [length(GLOB.loot_spawners_poolless)] total - these need loot_budget on their area:")
		for(var/entry in GLOB.loot_spawners_poolless)
			log_game("    [entry]")
	else
		log_game("All spawners assigned to pools.")
	log_game("=== END LOOT POOL DIAGNOSTICS ===")

/// Process a deferred pool by key once its source generation is complete (e.g. dungeon generator finishing).
/// Removes the pool from GLOB.loot_pools after processing so any straggler spawners fire normally instead of joining an exhausted pool.
/proc/process_deferred_loot_pool(key)
	if(!GLOB.loot_pools_deferred_keys[key])
		return
	var/datum/loot_pool/pool = GLOB.loot_pools[key]
	if(!pool)
		return
	GLOB.loot_pools_deferred_keys -= key
	GLOB.loot_pools_deferred_finalized[key] = TRUE
	pool.process_pool()
	GLOB.loot_pools -= key
	qdel(pool)
