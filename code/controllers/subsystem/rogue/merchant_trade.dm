SUBSYSTEM_DEF(merchant_trade)
	name = "Merchant Trade"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_MERCHANT_TRADE
	var/last_processed_day = -1
	var/list/datum/foreign_realm/realms = list()
	var/list/discovered_realms = list()
	var/list/datum/trade_ship/all_ships = list()
	var/hails_remaining = 0
	var/list/active_conditions = list()
	var/merchant_levy_percent = TRADE_MERCHANT_LEVY_DEFAULT_PERCENT
	var/merchant_levy_collected = 0
	var/merchant_levy_taxed = 0
	var/list/pool_capacity = list()
	var/list/pool_consumed = list()
	var/list/pending_ship_demand = list()
	var/list/pending_ship_demand_satisfied = list()
	var/list/bm_pool_capacity = list()
	var/list/bm_pool_consumed = list()
	var/list/pool_theme_jitters = list()
	var/pool_pop_snapshot = 0
	var/resnapshot_timer_id

/datum/controller/subsystem/merchant_trade/proc/set_merchant_levy(new_percent)
	new_percent = clamp(round(new_percent), 0, TRADE_MERCHANT_LEVY_CAP_PERCENT)
	merchant_levy_percent = new_percent
	return merchant_levy_percent

/datum/controller/subsystem/merchant_trade/Initialize()
	for(var/path in subtypesof(/datum/foreign_realm))
		var/datum/foreign_realm/R = new path
		if(!R.id)
			qdel(R)
			continue
		realms[R.id] = R
		if(R.auto_discovered)
			discovered_realms[R.id] = TRUE
	roll_active_conditions()
	hails_remaining = TRADE_SHIPS_HAIL_PER_DAY
	roll_daily_pool()
	init_market_pools()
	last_processed_day = GLOB.dayspassed
	return ..()

/datum/controller/subsystem/merchant_trade/proc/init_market_pools()
	pool_pop_snapshot = compute_pop_count_for_pools()
	pool_capacity = list()
	pool_consumed = list()
	pending_ship_demand = list()
	pending_ship_demand_satisfied = list()
	bm_pool_capacity = list()
	bm_pool_consumed = list()
	pool_theme_jitters = roll_market_theme_jitters()
	var/dispatch = build_market_theme_dispatch(pool_theme_jitters)
	if(dispatch)
		scom_announce(dispatch)
	for(var/cat in all_market_pool_categories())
		var/cap = compute_market_pool_capacity(cat, pool_pop_snapshot, pool_theme_jitters)
		pool_capacity[cat] = cap
		pool_consumed[cat] = 0
		pending_ship_demand[cat] = 0
		pending_ship_demand_satisfied[cat] = 0
		var/bm_cap = round(cap * MARKET_BM_POOL_FRACTION)
		bm_pool_capacity[cat] = bm_cap
		bm_pool_consumed[cat] = 0
	schedule_pool_resnapshot()

/datum/controller/subsystem/merchant_trade/proc/schedule_pool_resnapshot()
	if(resnapshot_timer_id)
		deltimer(resnapshot_timer_id)
	resnapshot_timer_id = addtimer(CALLBACK(src, PROC_REF(resnapshot_market_pools)), MARKET_POOL_RESNAPSHOT_INTERVAL, TIMER_STOPPABLE)

/datum/controller/subsystem/merchant_trade/proc/resnapshot_market_pools()
	var/new_pop = compute_pop_count_for_pools()
	if(new_pop > pool_pop_snapshot)
		pool_pop_snapshot = new_pop
		for(var/cat in all_market_pool_categories())
			var/new_cap = compute_market_pool_capacity(cat, pool_pop_snapshot, pool_theme_jitters)
			if(new_cap > pool_capacity[cat])
				pool_capacity[cat] = new_cap
			var/new_bm_cap = round(new_cap * MARKET_BM_POOL_FRACTION)
			if(new_bm_cap > bm_pool_capacity[cat])
				bm_pool_capacity[cat] = new_bm_cap
	schedule_pool_resnapshot()

/datum/controller/subsystem/merchant_trade/proc/regen_bm_saturation_daily()
	for(var/cat in bm_pool_capacity)
		var/bm_cap = bm_pool_capacity[cat]
		if(bm_cap <= 0)
			continue
		var/regen = round(bm_cap * MARKET_BM_DAILY_SATURATION_REGEN)
		bm_pool_consumed[cat] = max(0, (bm_pool_consumed[cat] || 0) - regen)

/datum/controller/subsystem/merchant_trade/proc/get_bm_saturation_factor(category)
	var/cap = bm_pool_capacity[category] || 0
	if(cap <= 0)
		return 1.0
	var/consumed = bm_pool_consumed[category] || 0
	return consumed >= cap ? 0 : 1.0


/datum/controller/subsystem/merchant_trade/proc/get_bm_demand_multiplier(category)
	return 1.0

/datum/controller/subsystem/merchant_trade/proc/add_ship_demand_for_realm(datum/foreign_realm/realm)
	if(!realm || !length(realm.demanded_categories))
		return
	for(var/cat in realm.demanded_categories)
		var/cap = pool_capacity[cat] || 0
		if(cap <= 0)
			continue
		var/per_ship = round(cap * MARKET_DEMAND_PER_SHIP_FRACTION)
		var/hard_cap = round(cap * MARKET_DEMAND_MAX_POOL_MULT)
		pending_ship_demand[cat] = min(hard_cap, (pending_ship_demand[cat] || 0) + per_ship)
		var/drain = round(cap * MARKET_DEMAND_SHIP_SATURATION_DRAIN)
		pool_consumed[cat] = max(0, (pool_consumed[cat] || 0) - drain)

/datum/controller/subsystem/merchant_trade/proc/remove_ship_demand_for_realm(datum/foreign_realm/realm)
	if(!realm || !length(realm.demanded_categories))
		return
	for(var/cat in realm.demanded_categories)
		var/cap = pool_capacity[cat] || 0
		if(cap <= 0)
			continue
		var/per_ship = round(cap * MARKET_DEMAND_PER_SHIP_FRACTION)
		var/new_val = (pending_ship_demand[cat] || 0) - per_ship
		pending_ship_demand[cat] = max(0, new_val)

/datum/controller/subsystem/merchant_trade/proc/get_demand_multiplier(category)
	var/cap = pool_capacity[category] || 0
	if(cap <= 0)
		return 1.0
	var/demand = pending_ship_demand[category] || 0
	var/ratio = demand / cap
	var/mult = 1 + ratio * (MARKET_DEMAND_PAYOUT_MAX_MULT - 1) / MARKET_DEMAND_MAX_POOL_MULT
	return min(MARKET_DEMAND_PAYOUT_MAX_MULT, mult)

/datum/controller/subsystem/merchant_trade/proc/get_saturation_factor(category)
	var/cap = pool_capacity[category] || 0
	if(cap <= 0)
		return 1.0
	var/consumed = pool_consumed[category] || 0
	return consumed >= cap ? 0 : 1.0

/datum/controller/subsystem/merchant_trade/proc/roll_active_conditions()
	for(var/realm_id in realms)
		active_conditions[realm_id] = list()
	var/list/single_realm_pool = list()
	var/list/cross_realm_pool = list()
	for(var/path in subtypesof(/datum/realm_condition))
		var/datum/realm_condition/C = new path
		if(!C.id || !length(C.affected_realms))
			qdel(C)
			continue
		if(C.cross_realm)
			cross_realm_pool += C
		else
			single_realm_pool += C
	for(var/datum/realm_condition/C as anything in cross_realm_pool)
		if(!prob(40))
			qdel(C)
			continue
		for(var/realm_id in C.affected_realms)
			var/datum/foreign_realm/R = realms[realm_id]
			if(!R)
				continue
			C.apply_to(R)
			active_conditions[realm_id] += C
	for(var/realm_id in realms)
		if(!prob(50))
			continue
		var/datum/foreign_realm/R = realms[realm_id]
		if(!R)
			continue
		var/list/eligible = list()
		for(var/datum/realm_condition/C as anything in single_realm_pool)
			if(realm_id in C.affected_realms)
				eligible[C] = max(1, C.weight)
		if(!length(eligible))
			continue
		var/datum/realm_condition/picked = pickweight(eligible)
		if(!picked)
			continue
		picked.apply_to(R)
		active_conditions[realm_id] += picked

/datum/controller/subsystem/merchant_trade/proc/active_conditions_for(realm_id)
	return active_conditions[realm_id] || list()

/datum/controller/subsystem/merchant_trade/proc/daily_tick()
	if(GLOB.dayspassed <= last_processed_day)
		return
	last_processed_day = GLOB.dayspassed
	hails_remaining = TRADE_SHIPS_HAIL_PER_DAY
	expire_undocked_ships()
	roll_daily_pool()
	regen_bm_saturation_daily()

/datum/controller/subsystem/merchant_trade/proc/roll_daily_pool()
	var/list/weighted = list()
	for(var/realm_id in realms)
		var/datum/foreign_realm/R = realms[realm_id]
		weighted[realm_id] = max(1, R.roll_weight)
	if(!length(weighted))
		return
	for(var/i in 1 to TRADE_SHIPS_PER_DAY_ROLL)
		var/picked = pickweight(weighted)
		generate_ship(picked)

/datum/controller/subsystem/merchant_trade/proc/expire_undocked_ships()
	for(var/datum/trade_ship/ship in all_ships)
		if(ship.dock_state == TRADE_SHIP_STATE_AVAILABLE)
			all_ships -= ship
			qdel(ship)

/datum/controller/subsystem/merchant_trade/proc/get_realm(realm_id)
	return realms[realm_id]

/datum/controller/subsystem/merchant_trade/proc/is_discovered(realm_id)
	return !!discovered_realms[realm_id]

/datum/controller/subsystem/merchant_trade/proc/discover_realm(realm_id)
	if(!realms[realm_id])
		return FALSE
	if(discovered_realms[realm_id])
		return FALSE
	discovered_realms[realm_id] = TRUE
	return TRUE

/datum/controller/subsystem/merchant_trade/proc/generate_ship(realm_id)
	var/datum/foreign_realm/realm = realms[realm_id]
	if(!realm)
		return null
	var/datum/trade_ship/ship = new(realm)
	all_ships += ship
	return ship

/datum/controller/subsystem/merchant_trade/proc/get_docked_ships()
	var/list/docked = list()
	for(var/datum/trade_ship/ship in all_ships)
		if(ship.dock_state == TRADE_SHIP_STATE_DOCKED)
			docked += ship
	return docked

/datum/controller/subsystem/merchant_trade/proc/get_dock_spots_max()
	return TRADE_SHIP_DOCK_SPOTS_BASE

/datum/controller/subsystem/merchant_trade/proc/find_ship_by_id(ship_id)
	for(var/datum/trade_ship/ship in all_ships)
		if(ship.ship_id == ship_id)
			return ship
	return null

/datum/controller/subsystem/merchant_trade/proc/consume_cultural_stock(datum/trade_ship/ship, pack_path)
	if(!ship)
		return FALSE
	var/key = "[pack_path]"
	for(var/list/entry in ship.cultural_stock)
		if(entry["pack"] == key && entry["qty"] > 0)
			entry["qty"]--
			return TRUE
	return FALSE

/datum/controller/subsystem/merchant_trade/proc/hail_ship(ship_id, mob/hailer)
	var/datum/trade_ship/ship = find_ship_by_id(ship_id)
	if(!ship)
		return "ship_gone"
	if(ship.dock_state != TRADE_SHIP_STATE_AVAILABLE)
		return "ship_gone"
	if(hails_remaining <= 0)
		return "no_hails"
	if(length(get_docked_ships()) >= get_dock_spots_max())
		return "no_dock_spots"
	hails_remaining--
	ship.dock()
	announce_dock(ship)
	var/datum/foreign_realm/realm = realms[ship.realm_id]
	var/first_of_realm = realm && !is_discovered(realm.id)
	if(first_of_realm)
		discover_realm(realm.id)
	return first_of_realm ? "ok_first" : "ok"

/datum/controller/subsystem/merchant_trade/proc/send_away_ship(ship_id, mob/sender)
	var/datum/trade_ship/ship = find_ship_by_id(ship_id)
	if(!ship)
		return "ship_gone"
	if(ship.dock_state != TRADE_SHIP_STATE_DOCKED)
		return "ship_gone"
	if(world.time < ship.docked_at + TRADE_SHIP_SEND_AWAY_GRACE)
		return "early"
	var/datum/foreign_realm/realm = realms[ship.realm_id]
	remove_ship_demand_for_realm(realm)
	all_ships -= ship
	qdel(ship)
	return "ok"

/datum/controller/subsystem/merchant_trade/proc/announce_dock(datum/trade_ship/ship)
	var/datum/foreign_realm/realm = realms[ship.realm_id]
	var/realm_name = realm ? realm.name : ship.realm_id
	scom_announce("The [ship.ship_type] [ship.ship_name], flying the colors of [realm_name], has made port at the Azurian Docks.")
