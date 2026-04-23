/obj/structure/roguemachine/steward/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/steward/ui_interact(mob/user, datum/tgui/ui)
	SStgui.try_update_ui(user, src, ui)

/obj/structure/roguemachine/steward/proc/open_trade_tgui(mob/user)
	if(locked)
		to_chat(user, span_warning("It's locked. Of course."))
		return
	var/datum/tgui/ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "StewardTrade")
		ui.open()

/// Catalog data — doesn't change mid-session. Trade good names, region names/descriptions,
/// hardcoded caps, importability flags. TGUI caches this and doesn't re-ship it per tick.
/obj/structure/roguemachine/steward/ui_static_data(mob/user)
	var/list/data = list()
	data["order_pool_cap"] = STANDING_ORDERS_POOL_CAP

	var/list/good_catalog = list()
	for(var/good_id in GLOB.trade_goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg)
			continue
		good_catalog[good_id] = list(
			"name" = tg.name,
			"importable" = tg.importable ? TRUE : FALSE,
			"category" = tg.category || "misc",
		)
	data["good_catalog"] = good_catalog

	var/list/region_catalog = list()
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		region_catalog[region_id] = list(
			"name" = region.name,
			"description" = region.description,
		)
	data["region_catalog"] = region_catalog

	return data

/obj/structure/roguemachine/steward/ui_data(mob/user)
	var/list/data = list()
	data["treasury"] = SStreasury?.discretionary_fund?.balance || 0
	data["day"] = GLOB.dayspassed

	var/list/blockaded = list()
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(region.is_region_blockaded)
			blockaded += region.name
	data["blockaded_regions"] = blockaded

	data["banditry_projection"] = SSeconomy.preview_banditry_drain()

	var/list/events = list()
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		events += list(list(
			"name" = E.name,
			"description" = E.description,
			"event_type" = E.event_type,
			"days_left" = max(0, E.day_expires - GLOB.dayspassed),
			"affected_goods" = E.affected_goods ? E.affected_goods.Copy() : list(),
		))
	data["active_events"] = events

	// Active standing orders. Items carry only good_id + counts; the TSX looks up the
	// good's label/name via the static good_catalog.
	var/list/orders = list()
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(O.is_fulfilled)
			continue
		var/datum/economic_region/order_region = GLOB.economic_regions[O.region_id]
		var/is_blockaded = order_region?.is_region_blockaded ? TRUE : FALSE
		var/is_equipment = SSeconomy.order_is_equipment(O) ? TRUE : FALSE
		var/days_left = max(0, O.day_expires - GLOB.dayspassed)

		var/list/items = list()
		var/can_fulfill = TRUE
		var/shortfall = ""
		for(var/good_id in O.required_items)
			var/needed = O.required_items[good_id]
			var/have = 0
			if(is_equipment)
				// Equipment goods live on the warehouse floor; stockpile count not meaningful.
				have = needed
			else
				var/datum/roguestock/entry = SSeconomy.find_stockpile_by_trade_good(good_id)
				have = entry ? entry.stockpile_amount : 0
				if(have < needed)
					can_fulfill = FALSE
					var/datum/trade_good/tg = GLOB.trade_goods[good_id]
					var/label = tg ? tg.name : good_id
					if(shortfall != "")
						shortfall += ", "
					shortfall += "need [needed - have] more [label]"
			items += list(list(
				"good_id" = good_id,
				"needed" = needed,
				"have" = have,
			))

		orders += list(list(
			"ref" = REF(O),
			"name" = O.name,
			"region_id" = O.region_id,
			"region_blockaded" = is_blockaded,
			"is_equipment" = is_equipment,
			"days_left" = days_left,
			"payout" = O.total_payout,
			"items" = items,
			"can_fulfill" = can_fulfill,
			"shortfall_text" = shortfall,
		))
	data["active_orders"] = orders

	// Market rows — strip static fields (name, importable — come from good_catalog) and
	// keep only mutable state (stock, event tag, best import/export region + prices).
	var/list/event_tag_by_good = list()
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		for(var/gid in E.affected_goods)
			event_tag_by_good[gid] = E.event_type

	var/list/market_rows = list()
	for(var/good_id in GLOB.trade_goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg)
			continue
		var/datum/roguestock/entry = SSeconomy.find_stockpile_by_trade_good(good_id)
		if(!entry)
			continue
		if(!entry.accept_toggle_enabled)
			continue

		var/event_tag = ""
		if(event_tag_by_good[good_id] == ECON_EVENT_SHORTAGE)
			event_tag = "SHORTAGE"
		else if(event_tag_by_good[good_id] == ECON_EVENT_OVERSUPPLY)
			event_tag = "GLUT"

		var/list/row = list(
			"good_id" = good_id,
			"stock" = entry.stockpile_amount,
			"stock_limit" = entry.stockpile_limit,
			"event_tag" = event_tag,
			"import_region_id" = null,
			"import_unit_price" = null,
			"import_blockaded" = FALSE,
			"export_region_id" = null,
			"export_unit_price" = null,
			"export_blockaded" = FALSE,
		)

		if(tg.importable)
			var/list/import_info = SSeconomy.get_best_import_region(good_id, exclude_blockaded = FALSE)
			if(import_info)
				row["import_region_id"] = import_info["region_id"]
				row["import_unit_price"] = import_info["unit_price"]
				row["import_blockaded"] = import_info["is_blockaded"] ? TRUE : FALSE

		var/list/export_info = SSeconomy.get_best_export_region(good_id, exclude_blockaded = FALSE)
		if(export_info)
			row["export_region_id"] = export_info["region_id"]
			row["export_unit_price"] = export_info["unit_price"]
			row["export_blockaded"] = export_info["is_blockaded"] ? TRUE : FALSE

		market_rows += list(row)
	data["market_rows"] = market_rows

	// Region rows — strip static fields (name, description — come from region_catalog)
	// and keep only mutable state (blockade flag, produces_today, demands_today).
	var/list/region_rows = list()
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		var/list/produces = list()
		for(var/good_id in region.produces)
			if(!GLOB.trade_goods[good_id])
				continue
			produces += list(list(
				"good_id" = good_id,
				"total" = region.produces[good_id],
				"today" = region.produces_today[good_id] || 0,
			))
		var/list/demands = list()
		for(var/good_id in region.demands)
			if(!GLOB.trade_goods[good_id])
				continue
			demands += list(list(
				"good_id" = good_id,
				"total" = region.demands[good_id],
				"today" = region.demands_today[good_id] || 0,
			))
		region_rows += list(list(
			"region_id" = region_id,
			"blockaded" = region.is_region_blockaded ? TRUE : FALSE,
			"produces" = produces,
			"demands" = demands,
		))
	data["region_rows"] = region_rows

	return data

/obj/structure/roguemachine/steward/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(!usr.canUseTopic(src, BE_CLOSE) || locked)
		return TRUE
	switch(action)
		if("fulfill_order")
			var/datum/standing_order/O = locate(params["ref"]) in GLOB.standing_order_pool
			if(O)
				if(SSeconomy.fulfill_order(usr, O))
					scom_announce("Standing Order fulfilled: [O.name] (+[O.total_payout]m).")
					playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
			SStgui.update_uis(src)
			return TRUE
		if("trade_import")
			handle_trade_import(usr, params["region_id"], params["good_id"])
			SStgui.update_uis(src)
			return TRUE
		if("trade_export")
			handle_trade_export(usr, params["region_id"], params["good_id"])
			SStgui.update_uis(src)
			return TRUE
		if("trade_region_import")
			handle_trade_region_import(usr, params["region_id"])
			SStgui.update_uis(src)
			return TRUE
		if("trade_region_export")
			handle_trade_region_export(usr, params["region_id"])
			SStgui.update_uis(src)
			return TRUE
