/datum/trade_ship
	var/ship_id
	var/realm_id
	var/ship_name
	var/captain_name
	var/ship_type
	var/tonnage = TRADE_SHIP_DEFAULT_TONNAGE
	var/expected_favor
	var/spawned_at
	var/dock_state = TRADE_SHIP_STATE_AVAILABLE
	var/docked_at = 0
	var/dock_expires_at = 0
	var/dock_expiry_timer_id
	var/favor_earned = 0
	var/list/bulk_demands = list()
	var/list/bulk_supplies = list()
	var/list/cultural_stock = list()

/datum/trade_ship/New(datum/foreign_realm/realm)
	if(!realm)
		return
	src.realm_id = realm.id
	var/list/picked_type = realm.pick_ship_type()
	var/listed_tonnage = TRADE_SHIP_DEFAULT_TONNAGE
	if(picked_type)
		src.ship_type = picked_type["name"]
		listed_tonnage = picked_type["tonnage"] || TRADE_SHIP_DEFAULT_TONNAGE
	var/tonnage_swing = listed_tonnage * TRADE_SHIP_TONNAGE_VARIANCE
	src.tonnage = round(listed_tonnage + rand(-tonnage_swing, tonnage_swing))
	src.ship_name = realm.generate_ship_name()
	src.captain_name = realm.generate_captain_name()
	src.spawned_at = world.time
	src.ship_id = "[world.time]_[ref(src)]"
	src.expected_favor = round(TRADE_SHIP_EXPECTED_FAVOR * src.tonnage / TRADE_SHIP_DEFAULT_TONNAGE)
	roll_bulk_lines(realm)
	roll_cultural_stock(realm)

/datum/trade_ship/proc/roll_bulk_lines(datum/foreign_realm/realm)
	bulk_demands = roll_bulk_pool(realm.bulk_demand_pool)
	bulk_supplies = roll_bulk_pool(realm.bulk_supply_pool)

/datum/trade_ship/proc/roll_bulk_pool(list/pool)
	var/list/result = list()
	if(!length(pool))
		return result
	var/list/always_entries = list()
	var/list/rare_entries = list()
	for(var/list/entry as anything in pool)
		if(entry["always"])
			always_entries += list(entry)
		else
			rare_entries += list(entry)
	for(var/list/entry as anything in always_entries)
		var/list/line = build_bulk_line(entry)
		if(line)
			result += list(line)
	if(length(rare_entries))
		var/n_rare = rand(TRADE_SHIP_BULK_LINES_MIN, min(TRADE_SHIP_BULK_LINES_MAX, length(rare_entries)))
		var/list/picks = rare_entries.Copy()
		for(var/i in 1 to n_rare)
			if(!length(picks))
				break
			var/list/entry = pick(picks)
			picks -= list(entry)
			var/list/line = build_bulk_line(entry)
			if(line)
				result += list(line)
	return result

/datum/trade_ship/proc/build_bulk_line(list/entry)
	var/datum/trade_good/TG = GLOB.trade_goods[entry["good"]]
	if(!TG)
		return null
	var/qty = rand(entry["qty_min"], entry["qty_max"])
	var/jitter = 0.9 + (rand() * 0.2)
	var/offered_price = round(TG.base_price * entry["price_mod"] * jitter)
	return list(
		"good" = entry["good"],
		"good_name" = TG.name,
		"qty_target" = qty,
		"qty_fulfilled" = 0,
		"offered_price" = offered_price,
	)

/datum/trade_ship/proc/roll_cultural_stock(datum/foreign_realm/realm)
	cultural_stock = list()
	for(var/pack_path in realm.cultural_stock_pool)
		var/datum/supply_pack/PA = SSmerchant.supply_packs[pack_path]
		if(!PA)
			continue
		var/qty = rand(PA.ship_qty_min, PA.ship_qty_max)
		if(qty <= 0)
			continue
		cultural_stock += list(list(
			"pack" = "[pack_path]",
			"name" = PA.name,
			"qty" = qty,
			"base_cost" = PA.cost,
		))

/datum/trade_ship/Destroy()
	if(dock_expiry_timer_id)
		deltimer(dock_expiry_timer_id)
		dock_expiry_timer_id = null
	return ..()

/datum/trade_ship/proc/dock()
	if(dock_state == TRADE_SHIP_STATE_DOCKED)
		return FALSE
	dock_state = TRADE_SHIP_STATE_DOCKED
	docked_at = world.time
	dock_expires_at = world.time + TRADE_SHIP_DOCK_DURATION
	dock_expiry_timer_id = addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(trade_ship_expire_dock), src), TRADE_SHIP_DOCK_DURATION, TIMER_STOPPABLE)
	return TRUE

/proc/trade_ship_expire_dock(datum/trade_ship/ship)
	if(!ship || ship.dock_state != TRADE_SHIP_STATE_DOCKED)
		return
	if(SSmerchant_trade)
		SSmerchant_trade.all_ships -= ship
	qdel(ship)
