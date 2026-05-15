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
	last_processed_day = GLOB.dayspassed
	return ..()

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
	all_ships -= ship
	qdel(ship)
	return "ok"

/datum/controller/subsystem/merchant_trade/proc/announce_dock(datum/trade_ship/ship)
	var/datum/foreign_realm/realm = realms[ship.realm_id]
	var/realm_name = realm ? realm.name : ship.realm_id
	scom_announce("The [ship.ship_type] [ship.ship_name], flying the colors of [realm_name], has made port at the Azurian Docks.")
