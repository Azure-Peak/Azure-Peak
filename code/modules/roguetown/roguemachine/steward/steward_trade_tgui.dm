/obj/structure/roguemachine/steward/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/steward/ui_status(mob/user, datum/ui_state/state)
	if(locked)
		return UI_CLOSE
	return ..()

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
		ui.set_autoupdate(FALSE)

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
			"subroute" = "[region.subroute]",
			"tribute" = region.tribute_goods.Copy(),
			"gifts" = gift_names(region.gifts),
			"supply" = region.trade_type_rows(region.produces, region.supply_sources),
			"demand" = region.trade_type_rows(region.demands, region.demand_sources, TRUE),
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
	data["is_steward_role"] = (user.job in GLOB.crown_authority_roles) ? TRUE : FALSE

	var/list/commission_catalog = list()
	for(var/datum/royal_commission/C as anything in GLOB.royal_commissions)
		commission_catalog[REF(C)] = list(
			"name" = C.name,
			"desc" = C.desc,
			"daily_stock" = C.daily_stock,
			"contents" = C.content_rows(),
		)
	for(var/datum/crown_import/D as anything in GLOB.crown_imports)
		commission_catalog[REF(D)] = list(
			"name" = D.name,
			"desc" = D.desc,
			"daily_stock" = D.daily_stock,
		)
	data["commission_catalog"] = commission_catalog
	data["commission_lead_minutes"] = round(COMMISSION_LEAD_TIME / (1 MINUTES))
	data["rental_pay"] = CARAVAN_RENTAL_PAY
	data["rental_rate"] = MARKET_DAY_RENTAL_RATE
	data["market_day_base_rate"] = MARKET_DAY_RATE
	data["market_day_floor"] = MARKET_DAY_FLOOR

	return data

/obj/structure/roguemachine/steward/ui_data(mob/user)
	var/list/data = list()
	data["treasury"] = SStreasury?.discretionary_fund?.balance || 0
	data["day"] = ECONOMY_DAY

	var/list/orders = list()
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(O.is_fulfilled)
			continue
		var/datum/economic_region/order_region = GLOB.economic_regions[O.region_id]
		var/is_blockaded = order_region?.is_region_blockaded ? TRUE : FALSE
		var/days_left = max(0, O.day_expires - ECONOMY_DAY)

		var/list/items = list()
		var/has_warehouse = FALSE
		var/has_stockpile = FALSE
		var/list/needs = SSeconomy.order_needs(O)
		for(var/good_id in needs)
			var/needed = needs[good_id]
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
			"crafted" = O.crafted,
			"days_left" = days_left,
			"payout" = SSeconomy.order_needs_payout(O),
			"halved" = is_blockaded,
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
			"units" = SSeconomy.offer_units_now(offer),
			"unit_price" = offer.unit_price,
			"total_price" = SSeconomy.offer_price_now(offer),
			"halved" = SSeconomy.region_raided(offer.region_id) ? TRUE : FALSE,
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
			"escorted" = SSeconomy.subroute_escorted(region.subroute) ? TRUE : FALSE,
		)
	data["region_caravan"] = region_caravan

	var/list/caravan_escorts = list()
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		caravan_escorts["[B.subroute]"] = list(
			"escorted" = SSeconomy.subroute_escorted(B.subroute) ? TRUE : FALSE,
			"fee" = SSeconomy.escort_fee(B.subroute),
			"blocker" = SSeconomy.escort_blocker(B.subroute) || "",
		)
	data["caravan_escorts"] = caravan_escorts

	var/list/commission_rows = list()
	for(var/datum/royal_commission/C as anything in GLOB.royal_commissions)
		commission_rows += list(list(
			"ref" = REF(C),
			"stock" = C.stock,
			"price" = C.get_price(),
			"blocker" = SSeconomy.commission_blocker(C) || "",
		))
	var/list/commission_order_rows = list()
	for(var/datum/commission_order/order as anything in SSeconomy.commission_orders)
		commission_order_rows += list(list(
			"name" = order.commission.name,
			"seconds_left" = max(0, round((order.arrive_at - world.time) / (1 SECONDS))),
		))
	var/list/local_rows = list()
	for(var/datum/crown_import/D as anything in GLOB.crown_imports)
		local_rows += list(list(
			"ref" = REF(D),
			"stock" = D.stock,
			"price" = D.get_import_price(),
			"blocker" = SSeconomy.local_commission_blocker(D) || "",
		))
	data["commissions"] = list(
		"kits" = commission_rows,
		"local" = local_rows,
		"orders" = commission_order_rows,
	)

	var/list/trips = list()
	for(var/datum/caravan_trip/trip as anything in SSeconomy.caravan_trips)
		var/datum/trade_good/offer_good = trip.offer_good_id ? GLOB.trade_goods[trip.offer_good_id] : null
		var/datum/economic_region/tribute_region = trip.tribute_region_id ? GLOB.economic_regions[trip.tribute_region_id] : null
		trips += list(list(
			"route" = get_route_name(trip.route),
			"request" = trip.request_name,
			"offer" = trip.offer_good_id ? "[trip.offer_units] [offer_good ? offer_good.name : trip.offer_good_id]" : null,
			"tribute" = tribute_region?.name,
			"sell_offer" = trip.sell_offer ? TRUE : FALSE,
			"sell_tribute" = trip.sell_tribute ? TRUE : FALSE,
			"return_seconds" = trip.return_at ? max(0, round((trip.return_at - world.time) / (1 SECONDS))) : null,
		))
	data["caravans"] = list(
		"fleet" = SSeconomy.caravan_fleet,
		"home" = SSeconomy.caravans_home(),
		"rented" = SSeconomy.caravan_rentals,
		"return_seconds" = max(0, round(SSeconomy.seconds_until_caravan_tally())),
		"remembered_left" = SSeconomy.remembered_caravans_left,
		"remembered_minutes" = CARAVAN_REMEMBERED_TIME / (1 MINUTES),
		"trips" = trips,
	)
	data["caravan_quote"] = build_caravan_quote(user.ckey)
	var/list/sell = caravan_sell[user.ckey]
	data["caravan_sell"] = list(
		"offer" = sell?["offer"] ? TRUE : FALSE,
		"tribute" = sell?["tribute"] ? TRUE : FALSE,
	)
	data["market_dae"] = list(
		"rate" = SSeconomy.market_day_rate(),
		"rented" = SSeconomy.caravan_rentals,
		"returnable" = SSeconomy.returnable_rentals(),
		"rent_blocker" = SSeconomy.rental_blocker() || "",
		"next_seconds" = max(0, round(seconds_until_market_day())),
		"midday_rate" = SSeconomy.midday_market_rate,
	)

	// Caching more for performance
	if(SStreasury.market_view_dirty || isnull(SStreasury.cached_market_rows))
		rebuild_market_view()
	data["market_rows"] = SStreasury.cached_market_rows

	var/list/petition_state = list()
	var/petitions_remaining = SSeconomy.petitions_remaining_today()
	petition_state["pledge_balance"] = SStreasury.burgher_pledge_fund?.balance || 0
	petition_state["petitions_remaining"] = petitions_remaining
	var/selected_template = petition_view[user.ckey]
	var/list/targets = list()
	var/blocker = ""
	if(selected_template && SSeconomy.petition_category_of(selected_template))
		blocker = SSeconomy.petition_blocker(selected_template) || ""
		for(var/datum/economic_region/region as anything in SSeconomy.petition_target_regions(selected_template))
			var/datum/standing_order/current = SSeconomy.region_request(region.region_id)
			targets += list(list(
				"region_id" = region.region_id,
				"raided" = (region.is_region_blockaded && !SSeconomy.subroute_escorted(region.subroute)) ? TRUE : FALSE,
				"replaces" = current ? current.name : "",
			))
	petition_state["selected_template"] = selected_template ? "[selected_template]" : null
	petition_state["blocker"] = blocker
	petition_state["targets"] = targets
	data["petition"] = petition_state

	data["sequestration"] = sequestration_state()

	return data

/obj/structure/roguemachine/steward/proc/build_caravan_quote(ckey)
	var/list/quote = list("request" = null, "offer" = null, "tribute" = null)
	var/list/picked = caravan_view[ckey]
	if(!picked)
		return quote

	var/datum/standing_order/request = picked["request"] ? (locate(picked["request"]) in GLOB.standing_order_pool) : null
	if(request && !request.is_fulfilled)
		var/list/scan = SSeconomy.scan_order(request)
		var/list/plan = SSeconomy.order_fill_plan(request)
		var/list/needs = SSeconomy.order_needs(request)
		var/list/items = list()
		for(var/good_id in needs)
			var/route = SSeconomy.get_good_route(good_id)
			var/loaded = 0
			for(var/list/avail_set in list(scan["equip"], scan["potion"], scan["stock"]))
				var/list/entry = avail_set[good_id]
				if(entry)
					loaded = entry["delivered_units"]
			var/list/item = list(
				"good_id" = good_id,
				"needed" = needs[good_id],
				"route" = route,
				"unit_pay" = SSeconomy.compute_good_unit_payout(request, good_id),
				"loaded" = loaded,
				"have" = loaded,
				"market_closed" = TRUE,
				"market_left" = 0,
				"fill_units" = 0,
				"fill_cost" = 0,
				"ask_first" = 0,
				"ask_last" = 0,
			)
			var/datum/roguestock/D = route == "stockpile" ? SSeconomy.find_stockpile_by_trade_good(good_id) : null
			if(D)
				item["have"] = D.royal_stock
				if(!D.market_never_supplies)
					var/left = D.market_available()
					var/fill_units = plan[good_id] || 0
					item["market_closed"] = FALSE
					item["market_left"] = left
					item["fill_units"] = fill_units
					item["fill_cost"] = fill_units ? D.market_ask(fill_units) : 0
					if(left)
						item["ask_first"] = D.market_unit_ask(D.market_stock - 1)
						item["ask_last"] = D.market_unit_ask(D.market_stock - max(1, fill_units))
			items += list(item)
		quote["request"] = list(
			"ref" = picked["request"],
			"load_units" = scan["units"],
			"load_payout" = scan["payout"],
			"items" = items,
		)

	var/datum/region_offer/offer = picked["offer"] ? (locate(picked["offer"]) in GLOB.region_offer_pool) : null
	var/offer_units = offer ? SSeconomy.offer_units_now(offer) : 0
	if(offer)
		var/datum/roguestock/D = SSeconomy.find_stockpile_by_trade_good(offer.good_id)
		var/closed = !D || D.market_never_supplies
		quote["offer"] = list(
			"ref" = picked["offer"],
			"market_closed" = closed ? TRUE : FALSE,
			"sale_total" = closed ? 0 : D.market_bid(offer_units),
			"bid_first" = closed ? 0 : stockpile_price(D.market_unit_ask(D.market_stock + 1) * STOCKPILE_BID_RATIO),
			"bid_last" = closed ? 0 : stockpile_price(D.market_unit_ask(D.market_stock + offer_units) * STOCKPILE_BID_RATIO),
		)

	var/datum/economic_region/tribute_region = picked["tribute"] ? GLOB.economic_regions[picked["tribute"]] : null
	if(tribute_region)
		var/list/tribute_units = tribute_region.tribute_units()
		var/sale_total = 0
		for(var/good_id in tribute_units)
			var/datum/roguestock/D = SSeconomy.find_stockpile_by_trade_good(good_id)
			if(!D || D.market_never_supplies)
				continue
			var/offset = (offer && offer.good_id == good_id) ? offer_units : 0
			sale_total += D.market_bid(tribute_units[good_id], offset)
		quote["tribute"] = list(
			"region_id" = picked["tribute"],
			"sale_total" = mammon_round(sale_total),
		)
	return quote

/// Rebuild SStreasury's cached_market_rows
/// from current world state and clear market_view_dirty. Heavy work (~3ms); called only when
/// invalidated by a trade action, stockpile mutation, blockade flip, day reset, or economic
/// event boundary. event_tag_by_good is pre-built by the ui_data caller from the small, hot
/// active_events list.
/obj/structure/roguemachine/steward/proc/rebuild_market_view(list/event_tag_by_good)
	if(isnull(event_tag_by_good))
		event_tag_by_good = list()
		for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
			for(var/gid in E.shortage_goods)
				event_tag_by_good[gid] = "SHORTAGE"
			for(var/gid in E.glut_goods)
				event_tag_by_good[gid] = "GLUT"

	var/list/market_rows = list()
	var/list/market_stockpile_entries = SStreasury.stockpile_by_trade_good
	for(var/good_id in market_stockpile_entries)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg)
			continue
		var/datum/roguestock/entry = market_stockpile_entries[good_id]
		if(!entry)
			continue

		var/event_tag = event_tag_by_good[good_id] || ""
		var/list/dawn = entry.dawn_forecast()

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
			"dawn_change" = dawn["dawn_change"],
			"raided_supply" = dawn["raided_supply"],
			"raided_demand" = dawn["raided_demand"],
			"raided_suppliers" = dawn["raided_suppliers"],
			"raided_demanders" = dawn["raided_demanders"],
		))

	SStreasury.cached_market_rows = market_rows
	SStreasury.market_view_dirty = FALSE

/// Trade-control actions blocked during sequestration. Petitions and order fulfillment
/// are deliberately excluded so the Steward can still crawl out of debt by petitioning,
/// taxing, and fining.
GLOBAL_LIST_INIT(steward_trade_sequestration_locked_actions, list(
	"sell_to_market",
	"buy_from_market",
))

/obj/structure/roguemachine/steward/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(locked || !user_can_act(usr))
		return
	if(SStreasury.is_in_receivership() && (action in GLOB.steward_trade_sequestration_locked_actions))
		to_chat(usr, span_warning("Trade controls are locked under sequestration. Petitions, taxes and fines still work."))
		ui.send_update()
		return
	if(action in GLOB.steward_trade_sequestration_locked_actions)
		SStreasury.dirty_market_view()
	switch(action)
		if("open_window")
			open_steward_window(usr, params["window"])
			return
		if("sell_to_market")
			var/quantity = text2num("[params["quantity"]]")
			if(quantity)
				SSeconomy.sell_to_market(usr, params["good_id"], quantity)
			return TRUE
		if("buy_from_market")
			var/quantity = text2num("[params["quantity"]]")
			if(quantity)
				SSeconomy.buy_from_market(usr, params["good_id"], quantity)
			return TRUE
		if("petition_select")
			var/template = text2path(params["template"])
			if(template && SSeconomy.petition_category_of(template))
				petition_view[usr.ckey] = template
			else
				petition_view -= usr.ckey
			ui.send_update()
			return
		if("caravan_select")
			caravan_view[usr.ckey] = list("request" = "[params["request"]]", "offer" = "[params["offer"]]", "tribute" = "[params["tribute"]]")
			ui.send_update()
			return
		if("caravan_sell_toggle")
			var/kind = params["kind"]
			if(kind != "offer" && kind != "tribute")
				return
			var/list/sell = caravan_sell[usr.ckey]
			if(!sell)
				sell = list("offer" = FALSE, "tribute" = FALSE)
				caravan_sell[usr.ckey] = sell
			sell[kind] = !sell[kind]
			ui.send_update()
			return
		if("buy_escort")
			var/subroute = text2path(params["subroute"])
			if(ispath(subroute, /datum/trade_subroute) && SSeconomy.buy_escort(usr, subroute))
				playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
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
					return TRUE
			var/datum/region_offer/offer
			if(params["offer"])
				offer = locate(params["offer"]) in GLOB.region_offer_pool
				if(!offer)
					to_chat(usr, span_warning("That offer is gone."))
					return TRUE
			var/datum/economic_region/tribute_region
			if(params["tribute"])
				tribute_region = GLOB.economic_regions[params["tribute"]]
			var/list/sell = caravan_sell[usr.ckey]
			if(SSeconomy.send_caravan(usr, route, request, offer, tribute_region, params["fill"] ? TRUE : FALSE, sell?["offer"] ? TRUE : FALSE, sell?["tribute"] ? TRUE : FALSE))
				playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
			return TRUE
		if("place_commission")
			var/datum/royal_commission/C = locate(params["ref"]) in GLOB.royal_commissions
			if(C && SSeconomy.place_commission(usr, C))
				playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
			return TRUE
		if("place_local_commission")
			var/datum/crown_import/D = locate(params["ref"]) in GLOB.crown_imports
			if(D && SSeconomy.place_local_commission(usr, D))
				playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
			return TRUE
		if("rent_caravan")
			if(!(usr.job in GLOB.crown_authority_roles))
				to_chat(usr, span_warning("Only Crown officials can rent out caravans."))
				return
			SSeconomy.rent_caravan(usr)
			return TRUE
		if("return_rental")
			if(!(usr.job in GLOB.crown_authority_roles))
				to_chat(usr, span_warning("Only Crown officials can take back caravans."))
				return
			SSeconomy.return_rental(usr)
			return TRUE
		if("extend_order")
			if(!(usr.job in GLOB.crown_authority_roles))
				to_chat(usr, span_warning("Only Crown officials can send a zad."))
				return TRUE
			var/datum/standing_order/O = locate(params["ref"]) in GLOB.standing_order_pool
			if(O)
				SSeconomy.extend_order(usr, O)
			return TRUE
		if("petition_for_order")
			if(!(usr.job in GLOB.crown_authority_roles))
				to_chat(usr, span_warning("Only Crown officials can petition regions."))
				return TRUE
			var/template = text2path(params["template"])
			if(SSeconomy.petition_for_order(usr, template))
				playsound(src, 'sound/items/inqslip_sealed.ogg', 70, FALSE, -1)
			return TRUE
