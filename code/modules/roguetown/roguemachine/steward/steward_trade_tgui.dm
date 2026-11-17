#define LEDGER_PAGE_SIZE 50

/obj/structure/roguemachine/steward/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/steward/ui_interact(mob/user, datum/tgui/ui)
	SStgui.try_update_ui(user, src, ui)

/obj/structure/roguemachine/steward/proc/open_trade_tgui(mob/user)
	if(locked)
		to_chat(user, span_warning("It's locked."))
		return
	var/datum/tgui/ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "StewardTrade")
		ui.open()

/obj/structure/roguemachine/steward/proc/user_can_act(mob/user)
	return user.canUseTopic(src, BE_CLOSE)

/// Catalog data — doesn't change mid-session. Trade good names, region names/descriptions,
/// hardcoded caps. TGUI caches this and doesn't re-ship it per tick.
/obj/structure/roguemachine/steward/ui_static_data(mob/user)
	var/list/data = list()
	data["order_extend_cost"] = STANDING_ORDER_EXTEND_COST
	data["quality_payouts"] = list(
		list("label" = "worn", "pct" = round(ITEM_QUALITY_MULT_WORN * 100)),
		list("label" = "ruined", "pct" = round(ITEM_QUALITY_MULT_RUINED * 100)),
		list("label" = "scavenged", "pct" = round(ITEM_QUALITY_MULT_LOOTED * 100)),
		list("label" = "awful", "pct" = round(ITEM_QUALITY_MULT_AWFUL * 100)),
		list("label" = "crude", "pct" = round(ITEM_QUALITY_MULT_CRUDE * 100)),
		list("label" = "rough", "pct" = round(ITEM_QUALITY_MULT_ROUGH * 100)),
		list("label" = "(standard)", "pct" = round(ITEM_QUALITY_MULT_STANDARD * 100)),
		list("label" = "fine", "pct" = round(ITEM_QUALITY_MULT_FINE * 100)),
		list("label" = "flawless", "pct" = round(ITEM_QUALITY_MULT_FLAWLESS * 100)),
		list("label" = "masterwork", "pct" = round(ITEM_QUALITY_MULT_MASTERWORK * 100)),
	)

	var/list/good_catalog = list()
	for(var/good_id in GLOB.trade_goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg)
			continue
		good_catalog[good_id] = list(
			"name" = tg.name,
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

	var/list/caravan_routes = list()
	for(var/route in subtypesof(/datum/trade_route))
		var/list/subroutes = list()
		for(var/datum/trade_subroute/subroute as anything in subtypesof(/datum/trade_subroute))
			if(initial(subroute.route) != route)
				continue
			var/list/region_ids = list()
			for(var/datum/economic_region/region as anything in get_subroute_regions(subroute))
				region_ids += region.region_id
			subroutes += list(list(
				"id" = "[subroute]",
				"name" = initial(subroute.name),
				"region_ids" = region_ids,
			))
		caravan_routes += list(list(
			"id" = "[route]",
			"name" = get_route_name(route),
			"subroutes" = subroutes,
		))
	data["caravan_routes"] = caravan_routes

	var/list/petition_categories = list()
	for(var/cat_id in GLOB.petition_categories)
		var/list/cat = GLOB.petition_categories[cat_id]
		var/list/templates = list()
		for(var/kind in cat["kinds"])
			var/list/region_ids = list()
			for(var/region_id in GLOB.economic_regions)
				var/datum/economic_region/region = GLOB.economic_regions[region_id]
				if(kind in region.request_kinds)
					region_ids += region_id
			templates += list(list(
				"id" = "[kind]",
				"label" = SSeconomy.petition_kind_label(kind),
				"region_ids" = region_ids,
			))
		petition_categories += list(list(
			"id" = cat_id,
			"label" = cat["label"],
			"description" = cat["description"],
			"cost" = cat["cost"],
			"templates" = templates,
		))
	data["petition_categories"] = petition_categories
	data["petition_tax_pct"] = round((1 - PETITION_TAX_MULT) * 100)
	data["petitions_per_day"] = PETITIONS_PER_DAY

	return data

/obj/structure/roguemachine/steward/proc/build_ledger_page(ckey)
	var/list/lview = ledger_view[ckey]
	var/view_mode = lview ? (lview["view"] || "journal") : "journal"
	var/list/page_data = list("view" = view_mode)
	switch(view_mode)
		if("ledger")
			var/account_id = lview ? (lview["account"] || LEDGER_CROWN_CASH) : LEDGER_CROWN_CASH
			page_data["chart"] = SStreasury.get_chart_listing(LEDGER_BOOK_CROWN)
			page_data["account_ledger"] = SStreasury.get_account_ledger(account_id, 100)
			return page_data
		if("trial")
			page_data["trial_balance"] = SStreasury.get_trial_balance(LEDGER_BOOK_CROWN)
			page_data["reconciliation"] = SStreasury.reconcile_ledger(LEDGER_BOOK_CROWN)
			return page_data
		if("income")
			page_data["income_statement"] = SStreasury.get_income_statement(LEDGER_BOOK_CROWN)
			return page_data
		if("balance")
			page_data["balance_sheet"] = SStreasury.get_balance_sheet(LEDGER_BOOK_CROWN)
			return page_data
		if("subsidiary")
			page_data["subsidiary"] = SStreasury.get_subsidiary_ledgers()
			return page_data

	var/page = max(1, lview ? (lview["page"] || 1) : 1)
	var/filter = lview ? (lview["filter"] || "") : ""
	var/window_start = (page - 1) * LEDGER_PAGE_SIZE + 1
	var/window_end = page * LEDGER_PAGE_SIZE
	var/list/entries = list()
	var/matched = 0
	var/total = length(SStreasury.ledger)
	var/crown_name = SStreasury.discretionary_fund?.name
	for(var/i = total to 1 step -1)
		var/datum/treasury_entry/E = SStreasury.ledger[i]
		if(E.legs)
			if(!E.touches_book(LEDGER_BOOK_CROWN))
				continue
		else if(crown_name && E.from_name != crown_name && E.to_name != crown_name)
			continue
		if(filter && !findtext(E.reason, filter) && !findtext(E.from_name, filter) && !findtext(E.to_name, filter))
			continue
		matched++
		if(matched < window_start)
			continue
		if(matched > window_end)
			break
		entries += list(SStreasury.journal_entry_view(E, LEDGER_BOOK_CROWN))
	page_data["entries"] = entries
	page_data["page"] = page
	page_data["page_size"] = LEDGER_PAGE_SIZE
	page_data["shown"] = length(entries)
	page_data["has_more"] = (matched > window_end) ? TRUE : FALSE
	page_data["filtered"] = filter ? TRUE : FALSE
	return page_data

/obj/structure/roguemachine/steward/ui_data(mob/user)
	var/list/data = list()
	// The ledger page rides on normal updates, sent once after each ledger action. Static data is
	// rate-limited to one full update a second, and tgui swaps the whole window for a "Loading"
	// screen while one is pending - rapid ledger clicks used to kick the Steward back to its base menu.
	var/list/ledger_state = ledger_view[user.ckey]
	if(ledger_state && ledger_state["open"] && ledger_state["dirty"])
		ledger_state["dirty"] = FALSE
		data["ledger_page"] = build_ledger_page(user.ckey)
	data["treasury"] = SStreasury?.discretionary_fund?.balance || 0
	data["day"] = GLOB.dayspassed
	data["expected_rural_revenue"] = SStreasury?.get_rural_tax_amount() || 0
	data["expected_wage_outlay"] = SStreasury?.get_expected_wage_outlay() || 0

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
			"saturation_target" = E.saturation_target,
			"saturation_progress" = E.saturation_progress,
		))
	data["active_events"] = events

	var/list/orders = list()
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(O.is_fulfilled)
			continue
		var/datum/economic_region/order_region = GLOB.economic_regions[O.region_id]
		var/is_blockaded = order_region?.is_region_blockaded ? TRUE : FALSE
		var/days_left = max(0, O.day_expires - GLOB.dayspassed)

		var/list/items = list()
		var/has_warehouse = FALSE
		var/has_stockpile = FALSE
		for(var/good_id in O.required_items)
			var/needed = O.required_items[good_id]
			var/have = 0
			var/route = SSeconomy.get_good_route(good_id)
			if(route == "warehouse")
				has_warehouse = TRUE
				have = needed
			else
				has_stockpile = TRUE
				var/datum/roguestock/entry = SSeconomy.find_stockpile_by_trade_good(good_id)
				have = entry ? entry.royal_stock : 0
			items += list(list(
				"good_id" = good_id,
				"needed" = needed,
				"have" = have,
				"route" = route,
				"unit_pay" = SSeconomy.compute_good_unit_payout(O, good_id),
			))

		orders += list(list(
			"ref" = REF(O),
			"name" = O.name,
			"description" = O.description,
			"region_id" = O.region_id,
			"region_blockaded" = is_blockaded,
			"has_warehouse" = has_warehouse,
			"has_stockpile" = has_stockpile,
			"days_left" = days_left,
			"payout" = O.total_payout,
			"items" = items,
			"petitioned" = O.petitioned ? TRUE : FALSE,
			"extend_blocker" = SSeconomy.extend_blocker(O) || "",
		))
	data["active_orders"] = orders

	var/list/offer_rows = list()
	for(var/datum/region_offer/offer as anything in GLOB.region_offer_pool)
		offer_rows += list(list(
			"ref" = REF(offer),
			"region_id" = offer.region_id,
			"good_id" = offer.good_id,
			"units" = offer.units,
			"unit_price" = offer.unit_price,
			"total_price" = offer.total_price,
		))
	data["active_offers"] = offer_rows

	var/list/region_caravan = list()
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		var/list/tribute = list()
		var/list/tribute_units = region.tribute_units()
		for(var/good_id in tribute_units)
			tribute += list(list("good_id" = good_id, "units" = tribute_units[good_id]))
		region_caravan[region_id] = list(
			"blockaded" = region.is_region_blockaded ? TRUE : FALSE,
			"tribute" = tribute,
			"tribute_blocker" = region.tribute_blocker() || "",
		)
	data["region_caravan"] = region_caravan

	var/list/trips = list()
	for(var/datum/caravan_trip/trip as anything in SSeconomy.caravan_trips)
		var/datum/trade_good/offer_good = trip.offer_good_id ? GLOB.trade_goods[trip.offer_good_id] : null
		var/datum/economic_region/tribute_region = trip.tribute_region_id ? GLOB.economic_regions[trip.tribute_region_id] : null
		trips += list(list(
			"route" = get_route_name(trip.route),
			"request" = trip.request_name,
			"offer" = trip.offer_good_id ? "[trip.offer_units] [offer_good ? offer_good.name : trip.offer_good_id]" : null,
			"tribute" = tribute_region?.name,
		))
	data["caravans"] = list(
		"fleet" = SSeconomy.caravan_fleet,
		"home" = SSeconomy.caravans_home(),
		"return_minutes" = max(1, CEILING(seconds_until_dawn() / 60, 1)),
		"trips" = trips,
	)

	// Caching more for performance
	if(SStreasury.market_view_dirty || isnull(SStreasury.cached_market_rows))
		rebuild_market_view()
	data["market_rows"] = SStreasury.cached_market_rows
	data["region_rows"] = SStreasury.cached_region_rows

	var/list/petition_state = list()
	var/petitions_remaining = SSeconomy.petitions_remaining_today()
	petition_state["pledge_balance"] = SStreasury.burgher_pledge_fund?.balance || 0
	petition_state["petitions_remaining"] = petitions_remaining
	petition_state["is_steward_role"] = (user.job in GLOB.crown_authority_roles) ? TRUE : FALSE
	var/selected_template = petition_view[user.ckey]
	var/list/offers = list()
	if(selected_template && SSeconomy.petition_category_of(selected_template))
		for(var/region_id in GLOB.economic_regions)
			var/datum/economic_region/region = GLOB.economic_regions[region_id]
			if(!(selected_template in region.request_kinds))
				continue
			offers += list(list(
				"region_id" = region_id,
				"blocker" = SSeconomy.petition_blocker(region_id, selected_template) || "",
			))
	petition_state["selected_template"] = selected_template ? "[selected_template]" : null
	petition_state["offers"] = offers
	data["petition"] = petition_state

	data["sequestration"] = list(
		"active" = SStreasury.is_in_receivership() ? TRUE : FALSE,
		"in_arrears" = (SStreasury.treasury_state == TREASURY_IN_ARREARS) ? TRUE : FALSE,
		"debt" = SStreasury.treasury_debt,
		"state_label" = bankruptcy_state_label(SStreasury.treasury_state),
	)

	var/can_draw_loan = (user.job in GLOB.crown_authority_roles)
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

/// Rebuild SStreasury's cached_market_rows + cached_region_rows
/// from current world state and clear market_view_dirty. Heavy work (~3ms); called only when
/// invalidated by a trade action, stockpile mutation, blockade flip, day reset, or economic
/// event boundary. event_tag_by_good is pre-built by the ui_data caller from the small, hot
/// active_events list.
/obj/structure/roguemachine/steward/proc/rebuild_market_view(list/event_tag_by_good)
	if(isnull(event_tag_by_good))
		event_tag_by_good = list()
		for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
			for(var/gid in E.affected_goods)
				event_tag_by_good[gid] = E.event_type

	var/list/market_rows = list()
	var/list/market_stockpile_entries = SStreasury.stockpile_by_trade_good
	for(var/good_id in market_stockpile_entries)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg)
			continue
		var/datum/roguestock/entry = market_stockpile_entries[good_id]
		if(!entry)
			continue

		var/event_tag = ""
		if(event_tag_by_good[good_id] == ECON_EVENT_SHORTAGE)
			event_tag = "SHORTAGE"
		else if(event_tag_by_good[good_id] == ECON_EVENT_OVERSUPPLY)
			event_tag = "GLUT"

		market_rows += list(list(
			"good_id" = good_id,
			"stock" = entry.royal_stock,
			"market_stock" = entry.market_stock,
			"market_target" = entry.market_target,
			"market_label" = market_step_label(entry.market_step(entry.market_stock)),
			"market_buy" = entry.market_ask(1),
			"market_sell" = entry.market_bid(1),
			"never_supplied" = entry.market_never_supplies ? TRUE : FALSE,
			"market_left" = entry.market_available(),
			"sold_out" = entry.market_available() <= 0 ? TRUE : FALSE,
			"event_tag" = event_tag,
		))

	var/list/region_rows = list()
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		var/list/produces = list()
		for(var/good_id in region.produces)
			if(!GLOB.trade_goods[good_id])
				continue
			produces += list(list(
				"good_id" = good_id,
			))
		var/list/demands = list()
		for(var/good_id in region.demands)
			if(!GLOB.trade_goods[good_id])
				continue
			demands += list(list(
				"good_id" = good_id,
			))
		region_rows += list(list(
			"region_id" = region_id,
			"blockaded" = region.is_region_blockaded ? TRUE : FALSE,
			"produces" = produces,
			"demands" = demands,
		))

	SStreasury.cached_market_rows = market_rows
	SStreasury.cached_region_rows = region_rows
	SStreasury.market_view_dirty = FALSE

/// Trade-control actions blocked during sequestration. Petitions and order fulfillment
/// are deliberately excluded so the Steward can still crawl out of debt by petitioning,
/// taxing, and fining.
GLOBAL_LIST_INIT(steward_trade_sequestration_locked_actions, list(
	"sell_to_market",
	"buy_from_market",
))

/obj/structure/roguemachine/steward/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(!user_can_act(usr))
		return TRUE
	if(locked)
		return TRUE
	if(SStreasury.is_in_receivership() && (action in GLOB.steward_trade_sequestration_locked_actions))
		to_chat(usr, span_warning("Trade controls are locked under sequestration. Petitions, taxes and fines still work."))
		return TRUE
	if(action in GLOB.steward_trade_sequestration_locked_actions)
		SStreasury.dirty_market_view()
	switch(action)
		if("sell_to_market")
			var/quantity = text2num("[params["quantity"]]")
			if(quantity)
				SSeconomy.sell_to_market(usr, params["good_id"], quantity)
			SStgui.update_uis(src)
			return TRUE
		if("buy_from_market")
			var/quantity = text2num("[params["quantity"]]")
			if(quantity)
				SSeconomy.buy_from_market(usr, params["good_id"], quantity)
			SStgui.update_uis(src)
			return TRUE
		if("petition_select")
			var/template = text2path(params["template"])
			if(template && SSeconomy.petition_category_of(template))
				petition_view[usr.ckey] = template
			else
				petition_view -= usr.ckey
			SStgui.update_uis(src)
			return TRUE
		if("send_caravan")
			var/route = text2path(params["route"])
			if(!ispath(route, /datum/trade_route))
				return TRUE
			var/datum/standing_order/request
			if(params["request"])
				request = locate(params["request"]) in GLOB.standing_order_pool
				if(!request)
					to_chat(usr, span_warning("That order is gone."))
					SStgui.update_uis(src)
					return TRUE
			var/datum/region_offer/offer
			if(params["offer"])
				offer = locate(params["offer"]) in GLOB.region_offer_pool
				if(!offer)
					to_chat(usr, span_warning("That offer is gone."))
					SStgui.update_uis(src)
					return TRUE
			var/datum/economic_region/tribute_region
			if(params["tribute"])
				tribute_region = GLOB.economic_regions[params["tribute"]]
			if(SSeconomy.send_caravan(usr, route, request, offer, tribute_region))
				playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
			SStgui.update_uis(src)
			return TRUE
		if("extend_order")
			if(!(usr.job in GLOB.crown_authority_roles))
				to_chat(usr, span_warning("Only Crown officials can send a zad."))
				return TRUE
			var/datum/standing_order/O = locate(params["ref"]) in GLOB.standing_order_pool
			if(O)
				SSeconomy.extend_order(usr, O)
			SStgui.update_uis(src)
			return TRUE
		if("petition_for_order")
			if(!(usr.job in GLOB.crown_authority_roles))
				to_chat(usr, span_warning("Only Crown officials can petition regions."))
				return TRUE
			var/region_id = params["region_id"]
			var/template = text2path(params["template"])
			if(SSeconomy.petition_for_order(usr, region_id, template))
				var/datum/economic_region/region = GLOB.economic_regions[region_id]
				playsound(src, 'sound/items/inqslip_sealed.ogg', 70, FALSE, -1)
				visible_message(span_notice("[src] stamps the petition and seals it for [region?.name]."))
			SStgui.update_uis(src)
			return TRUE
		if("take_atc_loan")
			if(!(usr.job in GLOB.crown_authority_roles))
				to_chat(usr, span_warning("Only Crown officials can take loans from the ATC."))
				return TRUE
			var/amount = text2num("[params["amount"]]")
			if(!isnum(amount))
				return TRUE
			if(SStreasury.take_atc_loan(amount, usr))
				playsound(src, 'sound/items/inqslip_sealed.ogg', 70, FALSE, -1)
				visible_message(span_notice("[src] stamps the loan papers with the ATC seal."))
			SStgui.update_uis(src)
			return TRUE
		if("ledger_open")
			SStreasury.revalue_stockpile_inventory()
			ledger_view[usr.ckey] = list("open" = TRUE, "page" = 1, "filter" = "", "dirty" = TRUE)
			return TRUE
		if("ledger_close")
			var/list/lview = ledger_view[usr.ckey]
			if(lview)
				lview["open"] = FALSE
			return TRUE
		if("ledger_page")
			var/list/lview = ledger_view[usr.ckey]
			if(!lview || !lview["open"])
				return TRUE
			lview["page"] = max(1, text2num("[params["page"]]") || 1)
			lview["dirty"] = TRUE
			return TRUE
		if("ledger_filter")
			var/list/lview = ledger_view[usr.ckey]
			if(!lview || !lview["open"])
				return TRUE
			lview["filter"] = trim("[params["filter"]]")
			lview["page"] = 1
			lview["dirty"] = TRUE
			return TRUE
		if("ledger_view")
			var/list/lview = ledger_view[usr.ckey]
			if(!lview || !lview["open"])
				return TRUE
			var/new_view = "[params["view"]]"
			if(!(new_view in list("journal", "ledger", "trial", "income", "balance", "subsidiary")))
				return TRUE
			SStreasury.revalue_stockpile_inventory()
			lview["view"] = new_view
			lview["page"] = 1
			lview["dirty"] = TRUE
			return TRUE
		if("ledger_account")
			var/list/lview = ledger_view[usr.ckey]
			if(!lview || !lview["open"])
				return TRUE
			var/datum/ledger_account/picked = SStreasury.get_ledger_account("[params["id"]]")
			if(!picked || picked.book != LEDGER_BOOK_CROWN)
				return TRUE
			lview["account"] = picked.id
			lview["dirty"] = TRUE
			return TRUE
		if("ledger_refresh")
			var/list/lview = ledger_view[usr.ckey]
			if(!lview || !lview["open"])
				return TRUE
			SStreasury.revalue_stockpile_inventory()
			lview["dirty"] = TRUE
			return TRUE

#undef LEDGER_PAGE_SIZE
