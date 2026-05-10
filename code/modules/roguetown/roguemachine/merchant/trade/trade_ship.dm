/datum/trade_ship
	var/ship_id
	var/nationality_id
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

/datum/trade_ship/New(datum/foreign_nation/nation)
	if(!nation)
		return
	src.nationality_id = nation.id
	var/list/picked_type = nation.pick_ship_type()
	var/listed_tonnage = TRADE_SHIP_DEFAULT_TONNAGE
	if(picked_type)
		src.ship_type = picked_type["name"]
		listed_tonnage = picked_type["tonnage"] || TRADE_SHIP_DEFAULT_TONNAGE
	var/tonnage_swing = listed_tonnage * TRADE_SHIP_TONNAGE_VARIANCE
	src.tonnage = round(listed_tonnage + rand(-tonnage_swing, tonnage_swing))
	src.ship_name = nation.generate_ship_name()
	src.captain_name = nation.generate_captain_name()
	src.spawned_at = world.time
	src.ship_id = "[world.time]_[ref(src)]"
	src.expected_favor = round(TRADE_SHIP_EXPECTED_FAVOR * src.tonnage / TRADE_SHIP_DEFAULT_TONNAGE)

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
