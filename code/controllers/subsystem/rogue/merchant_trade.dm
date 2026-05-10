SUBSYSTEM_DEF(merchant_trade)
	name = "Merchant Trade"
	flags = SS_NO_FIRE
	var/last_processed_day = -1
	var/list/datum/foreign_nation/nations = list()
	var/list/discovered_nationalities = list()
	var/list/datum/trade_ship/all_ships = list()
	var/hails_remaining = 0

/datum/controller/subsystem/merchant_trade/Initialize()
	for(var/path in subtypesof(/datum/foreign_nation))
		var/datum/foreign_nation/N = new path
		if(!N.id)
			qdel(N)
			continue
		nations[N.id] = N
		if(N.auto_discovered)
			discovered_nationalities[N.id] = TRUE
	hails_remaining = TRADE_SHIPS_HAIL_PER_DAY
	roll_daily_pool()
	last_processed_day = GLOB.dayspassed
	return ..()

/datum/controller/subsystem/merchant_trade/proc/daily_tick()
	if(GLOB.dayspassed <= last_processed_day)
		return
	last_processed_day = GLOB.dayspassed
	hails_remaining = TRADE_SHIPS_HAIL_PER_DAY
	expire_undocked_ships()
	roll_daily_pool()

/datum/controller/subsystem/merchant_trade/proc/roll_daily_pool()
	var/list/weighted = list()
	for(var/nat_id in nations)
		var/datum/foreign_nation/N = nations[nat_id]
		weighted[nat_id] = max(1, N.roll_weight)
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

/datum/controller/subsystem/merchant_trade/proc/get_nation(nationality_id)
	return nations[nationality_id]

/datum/controller/subsystem/merchant_trade/proc/is_discovered(nationality_id)
	return !!discovered_nationalities[nationality_id]

/datum/controller/subsystem/merchant_trade/proc/discover_nationality(nationality_id)
	if(!nations[nationality_id])
		return FALSE
	if(discovered_nationalities[nationality_id])
		return FALSE
	discovered_nationalities[nationality_id] = TRUE
	return TRUE

/datum/controller/subsystem/merchant_trade/proc/generate_ship(nationality_id)
	var/datum/foreign_nation/nation = nations[nationality_id]
	if(!nation)
		return null
	var/datum/trade_ship/ship = new(nation)
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
	var/datum/foreign_nation/nation = nations[ship.nationality_id]
	var/first_of_nation = nation && !is_discovered(nation.id)
	if(first_of_nation)
		discover_nationality(nation.id)
	return first_of_nation ? "ok_first" : "ok"

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
	var/datum/foreign_nation/nation = nations[ship.nationality_id]
	var/nation_name = nation ? nation.name : ship.nationality_id
	scom_announce("The [ship.ship_type] [ship.ship_name], flying the colors of [nation_name], has made port at the Azurian Docks.")
