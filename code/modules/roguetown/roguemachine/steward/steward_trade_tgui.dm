/obj/structure/roguemachine/steward/ui_state(mob/user)
	// The sitting Alderman acts remotely from the Notice Board - they cannot physically reach the
	// locked Stewardry. For them, swap adjacency for a conscious-and-alive check; access is gated
	// at every action by alderman_has_access() checking trait + warrant. Everyone else needs to
	// be standing at the Nerve Master itself.
	if(SScity_assembly?.is_alderman(user))
		return GLOB.conscious_state
	return GLOB.human_adjacent_state

/// The sitting Alderman's remote trade access bypasses `/atom/ui_status`'s can_interact clamp
/// (which enforces physical adjacency and would downgrade UI_INTERACTIVE to UI_UPDATE, painting
/// the whole window grey). Authority is already enforced by alderman_has_access() on every
/// ui_act. Pull the status straight from state.can_use_topic without the adjacency filter.
/obj/structure/roguemachine/steward/ui_status(mob/user, datum/ui_state/state)
	if(SScity_assembly?.is_alderman(user))
		. = UI_CLOSE
		if(state)
			. = max(., state.can_use_topic(src, user))
		return
	return ..()

/obj/structure/roguemachine/steward/ui_interact(mob/user, datum/tgui/ui)
	SStgui.try_update_ui(user, src, ui)

/obj/structure/roguemachine/steward/proc/open_trade_tgui(mob/user)
	if(locked && !alderman_has_access(user))
		to_chat(user, span_warning("It's locked. Of course."))
		return
	var/datum/tgui/ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "StewardTrade")
		ui.open()

/obj/structure/roguemachine/steward/proc/alderman_has_access(mob/user)
	if(!user || !SScity_assembly)
		return FALSE
	if(!SScity_assembly.is_alderman(user))
		return FALSE
	if(!SScity_assembly.current_warrant)
		return FALSE
	return (SScity_assembly.current_warrant.trade_remaining > 0)

/// Adjacency/topic check that yields to the Alderman. The Alderman acts remotely from the Notice
/// Board and never stands at the Stewardry; every trade-path callsite should use this instead of
/// calling canUseTopic directly. Returns TRUE if the user may proceed.
/obj/structure/roguemachine/steward/proc/user_can_act(mob/user)
	if(SScity_assembly?.is_alderman(user))
		return TRUE
	return user.canUseTopic(src, BE_CLOSE)

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

	// Alderman-acting view: expose the warrant so the TGUI can render it prominently. Only
	// populated when the viewer is the sitting Alderman - the Steward doesn't need a warrant
	// display in their own machine view.
	data["is_alderman_acting"] = SScity_assembly?.is_alderman(user) ? TRUE : FALSE
	if(data["is_alderman_acting"])
		var/datum/assembly_warrant/W = SScity_assembly.current_warrant
		if(W)
			data["alderman_warrant"] = list(
				"trade_cap" = W.trade_daily_cap,
				"trade_remaining" = W.trade_remaining,
				"defense_cap" = W.defense_daily_cap,
				"defense_remaining" = W.defense_remaining,
			)
		else
			data["alderman_warrant"] = null
	else
		data["alderman_warrant"] = null

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
		var/is_warehouse = (SSeconomy.order_is_equipment(O) || SSeconomy.order_is_alchemical(O)) ? TRUE : FALSE
		var/days_left = max(0, O.day_expires - GLOB.dayspassed)

		var/list/items = list()
		var/can_fulfill = TRUE
		var/shortfall = ""
		for(var/good_id in O.required_items)
			var/needed = O.required_items[good_id]
			var/have = 0
			if(is_warehouse)
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
			"is_equipment" = is_warehouse,
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
			"import_capacity_today" = 0,
			"import_capacity_total" = 0,
			"export_region_id" = null,
			"export_unit_price" = null,
			"export_blockaded" = FALSE,
			"export_capacity_today" = 0,
			"export_capacity_total" = 0,
		)

		if(tg.importable)
			var/list/import_info = SSeconomy.get_best_import_region(good_id, exclude_blockaded = FALSE)
			if(import_info)
				row["import_region_id"] = import_info["region_id"]
				row["import_unit_price"] = import_info["unit_price"]
				row["import_blockaded"] = import_info["is_blockaded"] ? TRUE : FALSE
				var/datum/economic_region/import_region = GLOB.economic_regions[import_info["region_id"]]
				if(import_region)
					row["import_capacity_today"] = import_region.produces_today[good_id] || 0
					row["import_capacity_total"] = import_region.produces[good_id] || 0

		var/list/export_info = SSeconomy.get_best_export_region(good_id, exclude_blockaded = FALSE)
		if(export_info)
			row["export_region_id"] = export_info["region_id"]
			row["export_unit_price"] = export_info["unit_price"]
			row["export_blockaded"] = export_info["is_blockaded"] ? TRUE : FALSE
			var/datum/economic_region/export_region = GLOB.economic_regions[export_info["region_id"]]
			if(export_region)
				row["export_capacity_today"] = export_region.demands_today[good_id] || 0
				row["export_capacity_total"] = export_region.demands[good_id] || 0

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

	data["auto_import"] = build_auto_import_data()

	return data

/obj/structure/roguemachine/steward/proc/build_auto_import_data()
	var/list/essentials = list()
	for(var/good_id in AUTO_IMPORT_ESSENTIALS)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg)
			continue
		var/datum/roguestock/entry = SSeconomy.find_stockpile_by_trade_good(good_id)
		essentials += list(list(
			"good_id" = good_id,
			"active" = SStreasury.is_auto_import_active(good_id) ? TRUE : FALSE,
			"stock" = entry ? entry.stockpile_amount : 0,
		))

	// "Other goods" shown in the tab: importable trade goods the Crown can actually deposit
	// (has a stockpile entry that accepts them) and that have at least one producing region.
	// Essentials are filtered out because they appear in the top panel.
	var/list/others = list()
	for(var/good_id in GLOB.trade_goods)
		if(good_id in AUTO_IMPORT_ESSENTIALS)
			continue
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg || !tg.importable)
			continue
		var/datum/roguestock/entry = SSeconomy.find_stockpile_by_trade_good(good_id)
		if(!entry || !entry.accept_toggle_enabled)
			continue
		var/has_producer = FALSE
		for(var/region_id in GLOB.economic_regions)
			var/datum/economic_region/region = GLOB.economic_regions[region_id]
			if(region.produces[good_id])
				has_producer = TRUE
				break
		if(!has_producer)
			continue
		others += list(list(
			"good_id" = good_id,
			"active" = SStreasury.is_auto_import_active(good_id) ? TRUE : FALSE,
			"stock" = entry.stockpile_amount,
		))

	// Shape the history list so the TGUI doesn't need to Copy() nested lists itself.
	var/list/history = list()
	for(var/list/entry as anything in SStreasury.auto_import_daily_history)
		history += list(list(
			"day" = entry["day"],
			"spent" = entry["spent"],
			"lines" = (entry["lines"] || list()).Copy(),
		))

	return list(
		"today_spent" = SStreasury.auto_import_daily_spent,
		"purse_floor" = SStreasury.auto_import_purse_floor,
		"floor_target" = AUTO_IMPORT_FLOOR,
		"batch_size" = AUTO_IMPORT_BATCH,
		"max_price_mult" = AUTO_IMPORT_MAX_PRICE_MULT,
		"essentials" = essentials,
		"others" = others,
		"history" = history,
	)

/obj/structure/roguemachine/steward/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	// Adjacency gate yields to the Alderman - they act remotely from the Notice Board. All trade
	// actions still re-check alderman_has_access() (trait + warrant) below.
	if(!user_can_act(usr))
		return TRUE
	if(locked && !alderman_has_access(usr))
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
		if("toggle_auto_import")
			var/good_id = params["good_id"]
			if(good_id)
				SStreasury.set_auto_import(good_id, !SStreasury.is_auto_import_active(good_id))
			SStgui.update_uis(src)
			return TRUE
		if("kill_switch_auto_import")
			SStreasury.kill_switch_auto_import()
			SStgui.update_uis(src)
			return TRUE
		if("set_auto_import_purse_floor")
			var/amount = text2num("[params["amount"]]")
			if(!isnull(amount))
				SStreasury.set_auto_import_purse_floor(amount)
			SStgui.update_uis(src)
			return TRUE
