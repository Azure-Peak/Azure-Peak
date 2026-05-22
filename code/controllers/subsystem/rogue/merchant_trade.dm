SUBSYSTEM_DEF(merchant_trade)
	name = "Merchant Trade"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_MERCHANT_TRADE
	var/last_processed_day = -1
	var/list/datum/foreign_realm/realms = list()
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
	var/merchant_favor = 0
	var/merchant_favor_high = 0
	var/favor_from_sendoffs = 0
	var/favor_from_navigator = 0
	var/favor_from_goldface = 0
	var/favor_from_silverface = 0
	var/favor_penalties = 0
	var/gnome_margin_collected = 0
	var/silverface_margin_percent = 50
	var/list/merchant_fund_log = list()
	var/list/favor_ledger = list()
	var/gnome_automation_unlocked = FALSE
	var/extra_pier_rented = FALSE
	var/list/hails_by_realm = list()
	var/list/dock_durations_by_realm = list()
	var/list/favor_earned_by_realm = list()
	var/list/market_watchers = list()

/datum/controller/subsystem/merchant_trade/proc/set_merchant_levy(new_percent)
	new_percent = clamp(round(new_percent), 0, TRADE_MERCHANT_LEVY_CAP_PERCENT)
	merchant_levy_percent = new_percent
	return merchant_levy_percent

/datum/controller/subsystem/merchant_trade/proc/set_silverface_margin(new_percent)
	new_percent = clamp(round(new_percent), 0, 100)
	silverface_margin_percent = new_percent
	return silverface_margin_percent

/datum/controller/subsystem/merchant_trade/proc/log_fund_movement(source, amount)
	if(amount == 0)
		return
	merchant_fund_log.Insert(1, list(list(
		"source" = source,
		"amount" = amount,
	)))
	if(length(merchant_fund_log) > 12)
		merchant_fund_log.Cut(13)

/datum/controller/subsystem/merchant_trade/Initialize()
	for(var/path in subtypesof(/datum/foreign_realm))
		var/datum/foreign_realm/R = new path
		if(!R.id)
			qdel(R)
			continue
		realms[R.id] = R
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
	for(var/bucket in all_navigator_buckets())
		var/cap = compute_navigator_bucket_capacity(bucket, pool_pop_snapshot, pool_theme_jitters)
		pool_capacity[bucket] = cap
		pool_consumed[bucket] = 0
		pending_ship_demand[bucket] = 0
		pending_ship_demand_satisfied[bucket] = 0
		var/bm_cap = round(cap * MARKET_BM_POOL_FRACTION)
		bm_pool_capacity[bucket] = bm_cap
		bm_pool_consumed[bucket] = 0
	schedule_pool_resnapshot()

/datum/controller/subsystem/merchant_trade/proc/schedule_pool_resnapshot()
	if(resnapshot_timer_id)
		deltimer(resnapshot_timer_id)
	resnapshot_timer_id = addtimer(CALLBACK(src, PROC_REF(resnapshot_market_pools)), MARKET_POOL_RESNAPSHOT_INTERVAL, TIMER_STOPPABLE)

/datum/controller/subsystem/merchant_trade/proc/resnapshot_market_pools()
	var/new_pop = compute_pop_count_for_pools()
	var/changed = FALSE
	if(new_pop > pool_pop_snapshot)
		pool_pop_snapshot = new_pop
		for(var/bucket in all_navigator_buckets())
			var/new_cap = compute_navigator_bucket_capacity(bucket, pool_pop_snapshot, pool_theme_jitters)
			if(new_cap > pool_capacity[bucket])
				pool_capacity[bucket] = new_cap
				changed = TRUE
			var/new_bm_cap = round(new_cap * MARKET_BM_POOL_FRACTION)
			if(new_bm_cap > bm_pool_capacity[bucket])
				bm_pool_capacity[bucket] = new_bm_cap
				changed = TRUE
	schedule_pool_resnapshot()
	if(changed)
		broadcast_market_change()

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

/datum/controller/subsystem/merchant_trade/proc/build_realm_demand_matrix()
	var/list/out = list()
	for(var/realm_id in realms)
		var/datum/foreign_realm/R = realms[realm_id]
		var/list/buckets = list()
		for(var/cat in R.demanded_categories)
			var/bucket = (cat in all_navigator_buckets()) ? cat : get_navigator_bucket_for_category(cat)
			if(bucket && !(bucket in buckets))
				buckets += bucket
		out += list(list(
			"realm_id" = R.id,
			"name" = R.name,
			"demanded" = buckets,
		))
	return out

/datum/controller/subsystem/merchant_trade/proc/register_market_watcher(atom/A)
	if(A && !(A in market_watchers))
		market_watchers += A

/datum/controller/subsystem/merchant_trade/proc/unregister_market_watcher(atom/A)
	market_watchers -= A

/// Pushes a full TGUI static-data update to every registered market watcher. Called when
/// market-relevant state (saturation, ship demand, weekly resnapshot) actually mutates.
/datum/controller/subsystem/merchant_trade/proc/broadcast_market_change()
	for(var/atom/A as anything in market_watchers)
		if(!A || QDELETED(A))
			market_watchers -= A
			continue
		A.update_static_data_for_all_viewers()

/datum/controller/subsystem/merchant_trade/proc/add_ship_demand_for_realm(datum/foreign_realm/realm)
	if(!realm || !length(realm.demanded_categories))
		return
	var/list/buckets_seen = list()
	for(var/cat in realm.demanded_categories)
		var/bucket = (cat in all_navigator_buckets()) ? cat : get_navigator_bucket_for_category(cat)
		if(!bucket || (bucket in buckets_seen))
			continue
		buckets_seen += bucket
		var/cap = pool_capacity[bucket] || 0
		if(cap <= 0)
			continue
		var/per_ship = round(cap * MARKET_DEMAND_PER_SHIP_FRACTION)
		var/hard_cap = round(cap * MARKET_DEMAND_MAX_POOL_MULT)
		pending_ship_demand[bucket] = min(hard_cap, (pending_ship_demand[bucket] || 0) + per_ship)
		var/drain = round(cap * MARKET_DEMAND_SHIP_SATURATION_DRAIN)
		pool_consumed[bucket] = max(0, (pool_consumed[bucket] || 0) - drain)

/datum/controller/subsystem/merchant_trade/proc/remove_ship_demand_for_realm(datum/foreign_realm/realm)
	if(!realm || !length(realm.demanded_categories))
		return
	var/list/buckets_seen = list()
	for(var/cat in realm.demanded_categories)
		var/bucket = (cat in all_navigator_buckets()) ? cat : get_navigator_bucket_for_category(cat)
		if(!bucket || (bucket in buckets_seen))
			continue
		buckets_seen += bucket
		var/cap = pool_capacity[bucket] || 0
		if(cap <= 0)
			continue
		var/per_ship = round(cap * MARKET_DEMAND_PER_SHIP_FRACTION)
		var/new_val = (pending_ship_demand[bucket] || 0) - per_ship
		pending_ship_demand[bucket] = max(0, new_val)

/datum/controller/subsystem/merchant_trade/proc/get_demand_multiplier(category)
	var/cap = pool_capacity[category] || 0
	if(cap <= 0)
		return 1.0
	var/demand = pending_ship_demand[category] || 0
	if(demand <= 0)
		// Buckets exempt from the no-ship dampener. Valuables are precious by nature
		// and Seafood is the fishermen's baseline livelihood - neither should crash
		// just because no foreign ship is in port.
		if(category == NAVIGATOR_BUCKET_VALUABLES_CRAFTED || category == NAVIGATOR_BUCKET_VALUABLES_LOOTED || category == NAVIGATOR_BUCKET_SEAFOOD)
			return 1.0
		return MARKET_DEMAND_NO_SHIP_FLOOR
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
	return min(TRADE_SHIP_DOCK_SPOTS_MAX, TRADE_SHIP_DOCK_SPOTS_BASE + (extra_pier_rented ? 1 : 0))

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
	hails_by_realm[ship.realm_id] = (hails_by_realm[ship.realm_id] || 0) + 1
	broadcast_market_change()
	return "ok"

/datum/controller/subsystem/merchant_trade/proc/send_away_ship(ship_id, mob/sender)
	var/datum/trade_ship/ship = find_ship_by_id(ship_id)
	if(!ship)
		return "ship_gone"
	if(ship.dock_state != TRADE_SHIP_STATE_DOCKED)
		return "ship_gone"
	var/honored = ship.expected_favor > 0 && ship.favor_earned >= ship.expected_favor
	if(!honored && world.time < ship.docked_at + TRADE_SHIP_SEND_AWAY_GRACE)
		return "early"
	var/datum/foreign_realm/realm = realms[ship.realm_id]
	var/list/durations = dock_durations_by_realm[ship.realm_id]
	if(!durations)
		durations = list()
		dock_durations_by_realm[ship.realm_id] = durations
	durations += (world.time - ship.docked_at)
	resolve_ship_favor(ship, realm)
	remove_ship_demand_for_realm(realm)
	all_ships -= ship
	qdel(ship)
	broadcast_market_change()
	return "ok"

/datum/controller/subsystem/merchant_trade/proc/resolve_ship_favor(datum/trade_ship/ship, datum/foreign_realm/realm)
	if(!ship)
		return
	favor_earned_by_realm[ship.realm_id] = (favor_earned_by_realm[ship.realm_id] || 0) + ship.favor_earned
	var/expected = max(1, ship.expected_favor)
	var/ratio = ship.favor_earned / expected
	var/outcome
	var/awarded = 0
	var/refunded = FALSE
	if(ratio >= FAVOR_SEND_CLEAN_THRESHOLD)
		outcome = FAVOR_OUTCOME_HONORED
		awarded = round(ship.favor_earned * FAVOR_SEND_CLEAN_MULT)
		if(hails_remaining < TRADE_SHIPS_HAIL_PER_DAY)
			hails_remaining++
			refunded = TRUE
	else if(ratio >= FAVOR_SEND_PARTIAL_THRESHOLD)
		outcome = FAVOR_OUTCOME_PARTIAL
		awarded = round(ship.favor_earned * FAVOR_SEND_PARTIAL_MULT)
	else
		outcome = FAVOR_OUTCOME_DISHONORED
		awarded = -round(FAVOR_SEND_FAILURE_PENALTY * ship.tonnage_scale_mult())
	adjust_merchant_favor(awarded)
	if(awarded >= 0)
		favor_from_sendoffs += awarded
	else
		favor_penalties += -awarded
	favor_ledger.Insert(1, list(list(
		"realm_label" = realm ? realm.name : ship.realm_id,
		"ship_name" = ship.ship_name,
		"outcome" = outcome,
		"earned" = ship.favor_earned,
		"expected" = ship.expected_favor,
		"awarded" = awarded,
		"refunded_hail" = refunded,
	)))
	if(length(favor_ledger) > 8)
		favor_ledger.Cut(9)

/datum/controller/subsystem/merchant_trade/proc/adjust_merchant_favor(amt)
	merchant_favor = max(0, merchant_favor + amt)
	if(merchant_favor > merchant_favor_high)
		merchant_favor_high = merchant_favor
	return merchant_favor

/datum/controller/subsystem/merchant_trade/proc/spend_merchant_favor(amt)
	if(amt <= 0 || merchant_favor < amt)
		return FALSE
	merchant_favor -= amt
	return TRUE

/datum/controller/subsystem/merchant_trade/proc/unlock_gnome_automation()
	if(gnome_automation_unlocked)
		return FALSE
	if(!spend_merchant_favor(GNOME_AUTOMATION_FAVOR))
		return FALSE
	gnome_automation_unlocked = TRUE
	return TRUE

/datum/controller/subsystem/merchant_trade/proc/rent_extra_pier()
	if(extra_pier_rented)
		return FALSE
	if(!spend_merchant_favor(ADDITIONAL_PIER_FAVOR))
		return FALSE
	extra_pier_rented = TRUE
	return TRUE

/datum/controller/subsystem/merchant_trade/proc/favor_triumph_bonus()
	var/high = merchant_favor_high
	if(high >= FAVOR_TRIUMPH_BRACKET_6)
		return 6
	if(high >= FAVOR_TRIUMPH_BRACKET_5)
		return 5
	if(high >= FAVOR_TRIUMPH_BRACKET_4)
		return 4
	if(high >= FAVOR_TRIUMPH_BRACKET_3)
		return 3
	if(high >= FAVOR_TRIUMPH_BRACKET_2)
		return 2
	if(high >= FAVOR_TRIUMPH_BRACKET_1)
		return 1
	return 0

/datum/controller/subsystem/merchant_trade/proc/favor_next_bracket()
	var/high = merchant_favor_high
	if(high < FAVOR_TRIUMPH_BRACKET_1)
		return FAVOR_TRIUMPH_BRACKET_1
	if(high < FAVOR_TRIUMPH_BRACKET_2)
		return FAVOR_TRIUMPH_BRACKET_2
	if(high < FAVOR_TRIUMPH_BRACKET_3)
		return FAVOR_TRIUMPH_BRACKET_3
	if(high < FAVOR_TRIUMPH_BRACKET_4)
		return FAVOR_TRIUMPH_BRACKET_4
	if(high < FAVOR_TRIUMPH_BRACKET_5)
		return FAVOR_TRIUMPH_BRACKET_5
	if(high < FAVOR_TRIUMPH_BRACKET_6)
		return FAVOR_TRIUMPH_BRACKET_6
	return 0

/datum/controller/subsystem/merchant_trade/proc/favor_current_bracket_floor()
	var/high = merchant_favor_high
	if(high >= FAVOR_TRIUMPH_BRACKET_6)
		return FAVOR_TRIUMPH_BRACKET_6
	if(high >= FAVOR_TRIUMPH_BRACKET_5)
		return FAVOR_TRIUMPH_BRACKET_5
	if(high >= FAVOR_TRIUMPH_BRACKET_4)
		return FAVOR_TRIUMPH_BRACKET_4
	if(high >= FAVOR_TRIUMPH_BRACKET_3)
		return FAVOR_TRIUMPH_BRACKET_3
	if(high >= FAVOR_TRIUMPH_BRACKET_2)
		return FAVOR_TRIUMPH_BRACKET_2
	if(high >= FAVOR_TRIUMPH_BRACKET_1)
		return FAVOR_TRIUMPH_BRACKET_1
	return 0

/datum/controller/subsystem/merchant_trade/proc/announce_dock(datum/trade_ship/ship)
	var/datum/foreign_realm/realm = realms[ship.realm_id]
	var/realm_name = realm ? realm.name : ship.realm_id
	scom_announce("The [ship.ship_type] [ship.ship_name], flying the colors of [realm_name], has made port at the Azurian Docks.")
