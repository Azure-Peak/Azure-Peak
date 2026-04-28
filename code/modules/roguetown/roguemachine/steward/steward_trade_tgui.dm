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

	var/list/petition_categories = list()
	for(var/cat_id in GLOB.petition_categories)
		var/list/cat = GLOB.petition_categories[cat_id]
		petition_categories += list(list(
			"id" = cat_id,
			"label" = cat["label"],
			"description" = cat["description"],
			"cost" = cat["cost"],
		))
	data["petition_categories"] = petition_categories
	data["petition_tax_pct"] = round((1 - PETITION_TAX_MULT) * 100)
	data["petitions_per_day"] = PETITIONS_PER_DAY

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

	// Per-user quote response for the trade modal, populated by trade_quote act.
	data["trade_quote"] = last_trade_quote[user.ckey]

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
			"description" = O.description,
			"region_id" = O.region_id,
			"region_blockaded" = is_blockaded,
			"is_equipment" = is_warehouse,
			"days_left" = days_left,
			"payout" = O.total_payout,
			"items" = items,
			"can_fulfill" = can_fulfill,
			"shortfall_text" = shortfall,
			"petitioned" = O.petitioned ? TRUE : FALSE,
		))
	data["active_orders"] = orders

	// Market rows — strip static fields (name, importable — come from good_catalog) and
	// keep only mutable state (stock, event tag, best import/export region + prices).
	var/list/event_tag_by_good = list()
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		for(var/gid in E.affected_goods)
			event_tag_by_good[gid] = E.event_type

	var/list/market_rows = list()
	var/total_arbitrage_potential = 0
	for(var/good_id in GLOB.trade_goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg)
			continue
		var/datum/roguestock/entry = SSeconomy.find_stockpile_by_trade_good(good_id)
		if(!entry)
			continue
		entry.refresh_auto_price()

		var/event_tag = ""
		if(event_tag_by_good[good_id] == ECON_EVENT_SHORTAGE)
			event_tag = "SHORTAGE"
		else if(event_tag_by_good[good_id] == ECON_EVENT_OVERSUPPLY)
			event_tag = "GLUT"

		var/margin_per_unit = max(0, entry.withdraw_price - entry.payout_price)
		var/arbitrage_potential = margin_per_unit * entry.stockpile_amount
		total_arbitrage_potential += arbitrage_potential

		var/list/row = list(
			"good_id" = good_id,
			"stock" = entry.stockpile_amount,
			"stock_limit" = entry.stockpile_limit,
			"event_tag" = event_tag,
			"import_regions" = tg.importable ? build_market_import_regions(good_id) : list(),
			"export_regions" = build_market_export_regions(good_id),
			// Stockpile management state (read by Steward; visible-only to Alderman).
			"buy_price" = entry.payout_price,
			"sell_price" = entry.withdraw_price,
			"market_buy_price" = entry.get_market_deposit_price(),
			"market_sell_price" = entry.get_market_withdraw_price(),
			"automatic_price" = entry.automatic_price ? TRUE : FALSE,
			"automatic_limit" = entry.automatic_limit ? TRUE : FALSE,
			"accepting" = entry.accept_toggle_enabled ? TRUE : FALSE,
			"withdraw_disabled" = entry.withdraw_disabled ? TRUE : FALSE,
			"margin_per_unit" = margin_per_unit,
			"arbitrage_potential" = arbitrage_potential,
		)

		market_rows += list(row)
	data["market_rows"] = market_rows
	data["total_arbitrage_potential"] = total_arbitrage_potential
	data["autoexport_percentage"] = round(SStreasury.autoexport_percentage * 100)

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

	var/list/petition_state = list()
	petition_state["pledge_balance"] = SStreasury.burgher_pledge_fund?.balance || 0
	petition_state["petitions_remaining"] = SSeconomy.petitions_remaining_today()
	petition_state["is_steward_role"] = (user.job in list("Steward", "Clerk", "Grand Duke")) ? TRUE : FALSE
	petition_state["is_alderman_acting"] = SScity_assembly?.is_alderman(user) ? TRUE : FALSE
	var/list/eligibility = list()
	for(var/cat_id in GLOB.petition_categories)
		eligibility[cat_id] = list()
		for(var/region_id in GLOB.economic_regions)
			eligibility[cat_id][region_id] = SSeconomy.petition_blocker(region_id, cat_id) || ""
	petition_state["eligibility"] = eligibility
	data["petition"] = petition_state

	data["sequestration"] = list(
		"active" = SStreasury.is_in_receivership() ? TRUE : FALSE,
		"in_arrears" = (SStreasury.treasury_state == TREASURY_IN_ARREARS) ? TRUE : FALSE,
		"debt" = SStreasury.treasury_debt,
		"state_label" = bankruptcy_state_label(SStreasury.treasury_state),
	)

	var/can_draw_loan = (user.job in list("Steward", "Clerk", "Grand Duke", "Hand")) && !SScity_assembly?.is_alderman(user)
	data["atc_loan"] = list(
		"available" = (can_draw_loan && SStreasury.atc_loan_available()) ? TRUE : FALSE,
		"can_view" = can_draw_loan ? TRUE : FALSE,
		"min" = ATC_LOAN_MIN_AMOUNT,
		"max" = ATC_LOAN_MAX_AMOUNT,
		"closed_day" = ATC_LOAN_CLOSED_DAY,
		"interest_pct" = round(ATC_LOAN_INTEREST_RATE * 100),
		"blocker" = SStreasury.atc_loan_blocker_reason() || "",
		"arrears_consumed" = SStreasury.atc_loan_arrears_consumed ? TRUE : FALSE,
		"loans_drawn" = SStreasury.atc_loans_drawn_this_round,
		"outstanding" = SStreasury.atc_loan_arrears_consumed ? SStreasury.treasury_debt : 0,
	)

	return data

/// Enumerates every region producing good_id, with current next-unit import price and
/// capacity. Sorted ascending by price so entry 1 is the "best buy." Blockade multiplier
/// is baked into unit_price (no separate flag needed for ranking), but is_blockaded is
/// still exposed so the UI can badge it.
/obj/structure/roguemachine/steward/proc/build_market_import_regions(good_id)
	var/list/out = list()
	for(var/rid in GLOB.economic_regions)
		var/datum/economic_region/r = GLOB.economic_regions[rid]
		var/pace = r.produces[good_id] || 0
		if(pace <= 0)
			continue
		var/today = r.produces_today[good_id] || 0
		var/starting_index = max(0, pace - today)
		var/price = SSeconomy.compute_import_unit_price(good_id, r, starting_index + 1)
		out += list(list(
			"region_id" = rid,
			"unit_price" = price,
			"capacity_today" = today,
			"capacity_total" = pace,
			"is_blockaded" = r.is_region_blockaded ? TRUE : FALSE,
		))
	// Insertion sort by unit_price ascending. At most ~9 entries so O(n^2) is negligible.
	for(var/i in 1 to length(out) - 1)
		for(var/j in (i + 1) to length(out))
			if(out[j]["unit_price"] < out[i]["unit_price"])
				var/list/swap = out[i]
				out[i] = out[j]
				out[j] = swap
	return out

/// As above, but for export destinations. Sorted descending by price (best sell first).
/obj/structure/roguemachine/steward/proc/build_market_export_regions(good_id)
	var/list/out = list()
	for(var/rid in GLOB.economic_regions)
		var/datum/economic_region/r = GLOB.economic_regions[rid]
		var/pace = r.demands[good_id] || 0
		if(pace <= 0)
			continue
		var/today = r.demands_today[good_id] || 0
		var/starting_index = max(0, pace - today)
		var/price = SSeconomy.compute_export_unit_price(good_id, r, starting_index + 1)
		out += list(list(
			"region_id" = rid,
			"unit_price" = price,
			"capacity_today" = today,
			"capacity_total" = pace,
			"is_blockaded" = r.is_region_blockaded ? TRUE : FALSE,
		))
	// Descending by unit_price (highest = best sell).
	for(var/i in 1 to length(out) - 1)
		for(var/j in (i + 1) to length(out))
			if(out[j]["unit_price"] > out[i]["unit_price"])
				var/list/swap = out[i]
				out[i] = out[j]
				out[j] = swap
	return out

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
	var/list/history = list()
	for(var/list/entry as anything in SStreasury.auto_import_daily_history)
		var/list/lines = entry["lines"]
		history += list(list(
			"day" = entry["day"],
			"spent" = entry["spent"],
			"lines" = lines || list(),
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

/// Trade-control actions blocked during sequestration. Petitions, order fulfillment,
/// and read-only quote actions are deliberately excluded so the Steward can still
/// crawl out of debt by petitioning, taxing, and fining.
GLOBAL_LIST_INIT(steward_trade_sequestration_locked_actions, list(
	"trade_import",
	"trade_export",
	"trade_region_import",
	"trade_region_export",
	"toggle_auto_import",
	"kill_switch_auto_import",
	"set_auto_import_purse_floor",
	"toggle_auto_price",
	"toggle_auto_limit",
	"toggle_stockpile_accept",
	"toggle_withdraw_disabled",
	"set_buy_price",
	"set_sell_price",
	"set_stockpile_limit",
	"autoprice_all",
	"autolimit_all",
	"autoprice_category",
	"autolimit_category",
	"accept_category",
	"reject_category",
	"multiply_all_buy",
	"multiply_all_sell",
	"multiply_category_buy",
	"multiply_category_sell",
	"set_autoexport_percentage",
	"export_surplus_all",
	"export_surplus_category",
))

/obj/structure/roguemachine/steward/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(!user_can_act(usr))
		return TRUE
	if(locked && !alderman_has_access(usr))
		return TRUE
	if(SStreasury.is_in_receivership() && (action in GLOB.steward_trade_sequestration_locked_actions))
		to_chat(usr, span_warning("The Azurian Trading Company holds the Crown's commerce in sequestration. Petition, tax, and fine are your remaining instruments."))
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
			handle_trade_import(usr, params["region_id"], params["good_id"], params["quantity"])
			last_trade_quote -= usr.ckey
			SStgui.update_uis(src)
			return TRUE
		if("trade_export")
			handle_trade_export(usr, params["region_id"], params["good_id"], params["quantity"])
			last_trade_quote -= usr.ckey
			SStgui.update_uis(src)
			return TRUE
		if("trade_quote")
			last_trade_quote[usr.ckey] = quote_trade(usr, params["side"], params["region_id"], params["good_id"], params["quantity"])
			SStgui.update_uis(src)
			return TRUE
		if("trade_quote_close")
			last_trade_quote -= usr.ckey
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
		// ── Stockpile management. Steward-only — Aldermen see the data but can't edit. ──
		if("toggle_auto_price")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/datum/roguestock/D = SSeconomy.find_stockpile_by_trade_good(params["good_id"])
			if(D)
				D.automatic_price = !D.automatic_price
				if(D.automatic_price)
					D.snap_auto_prices()
			SStgui.update_uis(src)
			return TRUE
		if("toggle_auto_limit")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/datum/roguestock/D = SSeconomy.find_stockpile_by_trade_good(params["good_id"])
			if(D)
				D.automatic_limit = !D.automatic_limit
				if(D.automatic_limit)
					// Recompute this one entry from the auto formula.
					var/effective_pop = (SSeconomy && SSeconomy.simulated_player_scalar > 0) ? SSeconomy.simulated_player_scalar : get_active_player_count()
					var/pop_mult = min(REGION_POP_SCALE_MAX, 1.0 + (effective_pop * REGION_POP_SCALE_PER_PLAYER))
					var/total_demand = 0
					for(var/region_id in GLOB.economic_regions)
						var/datum/economic_region/region = GLOB.economic_regions[region_id]
						total_demand += region.demands[D.trade_good_id] || 0
					if(total_demand > 0)
						D.stockpile_limit = max(STOCKPILE_LIMIT_MIN, ceil(total_demand * pop_mult * STOCKPILE_AUTO_LIMIT_DAYS))
					else
						D.stockpile_limit = max(STOCKPILE_LIMIT_MIN, D.stockpile_limit)
			SStgui.update_uis(src)
			return TRUE
		if("toggle_stockpile_accept")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/datum/roguestock/D = SSeconomy.find_stockpile_by_trade_good(params["good_id"])
			if(D)
				D.accept_toggle_enabled = !D.accept_toggle_enabled
			SStgui.update_uis(src)
			return TRUE
		if("toggle_withdraw_disabled")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/datum/roguestock/D = SSeconomy.find_stockpile_by_trade_good(params["good_id"])
			if(D)
				D.withdraw_disabled = !D.withdraw_disabled
			SStgui.update_uis(src)
			return TRUE
		if("set_buy_price")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/datum/roguestock/D = SSeconomy.find_stockpile_by_trade_good(params["good_id"])
			var/price = text2num("[params["price"]]")
			if(D && !isnull(price))
				D.payout_price = clamp(round(price), 0, 9999)
				D.automatic_price = FALSE
			SStgui.update_uis(src)
			return TRUE
		if("set_sell_price")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/datum/roguestock/D = SSeconomy.find_stockpile_by_trade_good(params["good_id"])
			var/price = text2num("[params["price"]]")
			if(D && !isnull(price))
				D.withdraw_price = clamp(round(price), 0, 9999)
				D.automatic_price = FALSE
			SStgui.update_uis(src)
			return TRUE
		if("set_stockpile_limit")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/datum/roguestock/D = SSeconomy.find_stockpile_by_trade_good(params["good_id"])
			var/lim = text2num("[params["limit"]]")
			if(D && !isnull(lim))
				D.stockpile_limit = clamp(round(lim), 0, 9999)
				D.automatic_limit = FALSE
			SStgui.update_uis(src)
			return TRUE
		if("autoprice_all")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
				A.automatic_price = TRUE
				A.snap_auto_prices()
			SStgui.update_uis(src)
			return TRUE
		if("autolimit_all")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			for(var/datum/roguestock/A in SStreasury.stockpile_datums)
				A.automatic_limit = TRUE
			SStreasury.autoset_stockpile_limits()
			SStgui.update_uis(src)
			return TRUE
		if("autoprice_category")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/category = params["category"]
			if(!category)
				return TRUE
			for(var/datum/roguestock/A in SStreasury.stockpile_datums)
				if(!A.trade_good_id)
					continue
				var/datum/trade_good/tg = GLOB.trade_goods[A.trade_good_id]
				if(!tg || tg.category != category)
					continue
				A.automatic_price = TRUE
				A.snap_auto_prices()
			SStgui.update_uis(src)
			return TRUE
		if("autolimit_category")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/category = params["category"]
			if(!category)
				return TRUE
			for(var/datum/roguestock/A in SStreasury.stockpile_datums)
				if(!A.trade_good_id)
					continue
				var/datum/trade_good/tg = GLOB.trade_goods[A.trade_good_id]
				if(!tg || tg.category != category)
					continue
				A.automatic_limit = TRUE
			SStreasury.autoset_stockpile_limits()
			SStgui.update_uis(src)
			return TRUE
		if("accept_category")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/category = params["category"]
			if(!category)
				return TRUE
			for(var/datum/roguestock/A in SStreasury.stockpile_datums)
				if(!A.trade_good_id)
					continue
				var/datum/trade_good/tg = GLOB.trade_goods[A.trade_good_id]
				if(!tg || tg.category != category)
					continue
				A.accept_toggle_enabled = TRUE
			SStgui.update_uis(src)
			return TRUE
		if("reject_category")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/category = params["category"]
			if(!category)
				return TRUE
			for(var/datum/roguestock/A in SStreasury.stockpile_datums)
				if(!A.trade_good_id)
					continue
				var/datum/trade_good/tg = GLOB.trade_goods[A.trade_good_id]
				if(!tg || tg.category != category)
					continue
				A.accept_toggle_enabled = FALSE
			SStgui.update_uis(src)
			return TRUE
		if("multiply_all_buy")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/mult = text2num("[params["multiplier"]]")
			if(isnull(mult) || mult <= 0)
				return TRUE
			for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
				A.refresh_auto_price()
				A.payout_price = max(1, round(A.payout_price * mult))
				A.automatic_price = FALSE
			SStgui.update_uis(src)
			return TRUE
		if("multiply_all_sell")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/mult = text2num("[params["multiplier"]]")
			if(isnull(mult) || mult <= 0)
				return TRUE
			for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
				A.refresh_auto_price()
				A.withdraw_price = max(1, round(A.withdraw_price * mult))
				A.automatic_price = FALSE
			SStgui.update_uis(src)
			return TRUE
		if("multiply_category_buy")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/category = params["category"]
			var/mult = text2num("[params["multiplier"]]")
			if(!category || isnull(mult) || mult <= 0)
				return TRUE
			for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
				if(!A.trade_good_id)
					continue
				var/datum/trade_good/tg = GLOB.trade_goods[A.trade_good_id]
				if(!tg || tg.category != category)
					continue
				A.refresh_auto_price()
				A.payout_price = max(1, round(A.payout_price * mult))
				A.automatic_price = FALSE
			SStgui.update_uis(src)
			return TRUE
		if("multiply_category_sell")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/category = params["category"]
			var/mult = text2num("[params["multiplier"]]")
			if(!category || isnull(mult) || mult <= 0)
				return TRUE
			for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
				if(!A.trade_good_id)
					continue
				var/datum/trade_good/tg = GLOB.trade_goods[A.trade_good_id]
				if(!tg || tg.category != category)
					continue
				A.refresh_auto_price()
				A.withdraw_price = max(1, round(A.withdraw_price * mult))
				A.automatic_price = FALSE
			SStgui.update_uis(src)
			return TRUE
		if("set_autoexport_percentage")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/pct = text2num("[params["pct"]]")
			if(isnull(pct))
				return TRUE
			pct = clamp(round(pct), 0, 100)
			SStreasury.autoexport_percentage = pct * 0.01
			SStgui.update_uis(src)
			return TRUE
		if("export_surplus_all")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/list/result = SStreasury.mass_export_surplus(silent = FALSE)
			var/units = result["units"]
			var/revenue = result["revenue"]
			if(units <= 0)
				to_chat(usr, span_warning("No surplus to export - either no entry is over its threshold, or every demanding region is saturated for the day."))
				return TRUE
			scom_announce("Crown clears surplus stockpile: [units] units exported for [revenue] mammon.")
			for(var/line in result["lines"])
				to_chat(usr, span_notice(line))
			to_chat(usr, span_notice("<b>Total: [units] units exported for [revenue]m.</b>"))
			playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
			SStgui.update_uis(src)
			return TRUE
		if("export_surplus_category")
			if(SScity_assembly?.is_alderman(usr))
				return TRUE
			var/category = params["category"]
			if(!category)
				return TRUE
			// Per-category mass export: identical surplus rules, filtered to one trade-good category.
			var/total_revenue = 0
			var/total_units = 0
			var/list/lines = list()
			for(var/datum/roguestock/D in SStreasury.stockpile_datums)
				if(!D.trade_good_id || !D.automatic_price || !D.importexport_amt)
					continue
				var/datum/trade_good/tg = GLOB.trade_goods[D.trade_good_id]
				if(!tg || tg.category != category)
					continue
				var/keep = round(SStreasury.autoexport_percentage * D.stockpile_limit)
				if(SStreasury.is_auto_import_active(D.trade_good_id))
					keep = max(keep, AUTO_IMPORT_FLOOR)
				var/surplus = D.stockpile_amount - keep
				if(surplus <= 0)
					continue
				var/list/best = SSeconomy.get_best_export_region(D.trade_good_id)
				if(!best || !best["region_id"])
					continue
				var/datum/economic_region/region = GLOB.economic_regions[best["region_id"]]
				if(!region)
					continue
				var/remaining_demand = region.demands_today[D.trade_good_id] || 0
				if(remaining_demand <= 0)
					continue
				var/export_qty = min(surplus, remaining_demand)
				var/revenue = SSeconomy.manual_export(null, region.region_id, D.trade_good_id, export_qty)
				if(!revenue)
					continue
				total_revenue += revenue
				total_units += export_qty
				lines += "[export_qty] [D.name] to [region.name] for [revenue]m"
			if(total_units <= 0)
				to_chat(usr, span_warning("No [category] surplus to export."))
				return TRUE
			scom_announce("Crown clears [category] surplus: [total_units] units exported for [total_revenue] mammon.")
			for(var/line in lines)
				to_chat(usr, span_notice(line))
			to_chat(usr, span_notice("<b>Total: [total_units] units exported for [total_revenue]m.</b>"))
			playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
			SStgui.update_uis(src)
			return TRUE
		if("petition_for_order")
			if(SScity_assembly?.is_alderman(usr))
				to_chat(usr, span_warning("The Alderman's writ does not extend to petitioning the trade hall."))
				return TRUE
			if(!(usr.job in list("Steward", "Clerk", "Grand Duke")))
				to_chat(usr, span_warning("Only the Steward's office may petition the trade hall."))
				return TRUE
			var/region_id = params["region_id"]
			var/category_id = params["category_id"]
			if(SSeconomy.petition_for_order(usr, region_id, category_id))
				var/datum/economic_region/region = GLOB.economic_regions[region_id]
				playsound(src, 'sound/items/inqslip_sealed.ogg', 70, FALSE, -1)
				visible_message(span_notice("[src] stamps a freshly sealed writ. The wax bears the mark of the [region?.name] trade hall."))
			SStgui.update_uis(src)
			return TRUE
		if("take_atc_loan")
			if(SScity_assembly?.is_alderman(usr))
				to_chat(usr, span_warning("The Alderman's writ does not extend to drawing loans against the Crown."))
				return TRUE
			if(!(usr.job in list("Steward", "Clerk", "Grand Duke", "Hand")))
				to_chat(usr, span_warning("Only the Crown's office may approach the Guilds clerk."))
				return TRUE
			var/amount = text2num("[params["amount"]]")
			if(!isnum(amount))
				return TRUE
			if(SStreasury.take_atc_loan(amount, usr))
				playsound(src, 'sound/items/inqslip_sealed.ogg', 70, FALSE, -1)
				visible_message(span_notice("[src] stamps a sealed writ. The wax bears the mark of the Azurian Trading Company."))
			SStgui.update_uis(src)
			return TRUE
