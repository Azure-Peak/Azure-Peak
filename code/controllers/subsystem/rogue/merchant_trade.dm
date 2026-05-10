SUBSYSTEM_DEF(merchant_trade)
	name = "Merchant Trade"
	flags = SS_NO_FIRE
	var/last_processed_day = -1
	var/list/datum/foreign_nation/nations = list()
	var/list/discovered_nationalities = list()
	var/list/datum/trade_ship/all_ships = list()

/datum/controller/subsystem/merchant_trade/Initialize()
	for(var/path in subtypesof(/datum/foreign_nation))
		var/datum/foreign_nation/N = new path
		if(!N.id)
			qdel(N)
			continue
		nations[N.id] = N
		if(N.auto_discovered)
			discovered_nationalities[N.id] = TRUE
	roll_daily_pool()
	last_processed_day = GLOB.dayspassed
	return ..()

/datum/controller/subsystem/merchant_trade/proc/daily_tick()
	if(GLOB.dayspassed <= last_processed_day)
		return
	last_processed_day = GLOB.dayspassed
	expire_undocked_ships()
	roll_daily_pool()

/datum/controller/subsystem/merchant_trade/proc/roll_daily_pool()
	var/list/all_nat_ids = list()
	for(var/nat_id in nations)
		all_nat_ids += nat_id
	if(!length(all_nat_ids))
		return
	for(var/i in 1 to TRADE_SHIPS_PER_DAY_ROLL)
		var/picked = pick(all_nat_ids)
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
