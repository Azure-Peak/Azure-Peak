/datum/roguestock
	var/name = ""
	var/desc = ""
	var/item_type = null
	// The amount held by the royal stockpile.
	var/royal_stock = 0
	// The amount held by the market, used for computing market price
	var/market_stock
	var/market_target = MARKET_TARGET_STANDARD
	// Only the stockpile can ever purchase these goods. The market will never supply them
	var/market_never_supplies = FALSE
	var/market_never_buys = FALSE
	var/payout_price = 1
	var/withdraw_price = 1
	var/category = "Raw Materials"
	var/trade_good_id
	var/list/market_row
	var/market_row_stock
	var/market_row_royal
	var/market_row_version
	var/list/market_segments_cache
	var/market_segments_key

/datum/roguestock/New()
	..()
	if(isnull(market_stock))
		market_stock = market_target
	if(trade_good_id)
		var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
		if(tg)
			compute_auto_prices(tg)
	return

/datum/roguestock/proc/get_quality_settlement(obj/item/I, baseline)
	var/list/out = list(
		"seller_payout" = baseline,
		"baseline" = baseline,
		"q_mult" = 1.0,
	)
	if(!istype(I))
		return out
	var/q_mult = I.get_stockpile_quality_mult()
	if(q_mult == 1.0)
		return out
	var/buy_price = baseline * q_mult
	var/loss = baseline - buy_price
	var/seller_payout = buy_price - (loss * STOCKPILE_QUALITY_LOSS_SELLER_SHARE)
	out["seller_payout"] = stockpile_price(seller_payout)
	out["q_mult"] = q_mult
	return out

/datum/roguestock/proc/market_has_supply()
	if(!trade_good_id)
		return FALSE
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg?.importable)
		return FALSE
	for(var/region_id in SSeconomy.good_producer_volumes(trade_good_id))
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(!region.is_region_blockaded)
			return TRUE
	return FALSE

/datum/roguestock/proc/market_out_of_stock_level()
	if(!market_has_supply())
		return 0
	return CEILING(market_target * MARKET_RATIO_OUT_OF_STOCK / 100, 1)

/datum/roguestock/proc/market_available()
	return max(0, market_stock - market_out_of_stock_level())

/datum/roguestock/proc/market_step(stock)
	var/ratio = stock * 100 / market_target
	if(ratio >= MARKET_RATIO_OVERSTOCKED)
		return market_zone_step(MARKET_STEP_OVERSTOCKED)
	if(ratio >= MARKET_RATIO_ABUNDANT)
		return MARKET_STEP_ABUNDANT
	if(ratio >= MARKET_RATIO_PLENTIFUL)
		return MARKET_STEP_PLENTIFUL
	if(ratio >= MARKET_RATIO_STEADY)
		return MARKET_STEP_STEADY
	if(ratio >= MARKET_RATIO_LOW)
		return MARKET_STEP_LOW
	if(ratio >= MARKET_RATIO_SCARCE)
		return MARKET_STEP_SCARCE
	return market_zone_step(MARKET_STEP_VERY_SCARCE)

/datum/roguestock/proc/market_zone_step(step)
	if(step == MARKET_STEP_OVERSTOCKED && get_event_label() == "GLUT")
		return MARKET_STEP_GLUT
	if(step == MARKET_STEP_VERY_SCARCE && get_event_label() == "SHORTAGE")
		return MARKET_STEP_SHORTAGE
	return step

/proc/market_step_above(step)
	switch(step)
		if(MARKET_STEP_SHORTAGE, MARKET_STEP_VERY_SCARCE)
			return MARKET_STEP_SCARCE
		if(MARKET_STEP_SCARCE)
			return MARKET_STEP_LOW
		if(MARKET_STEP_LOW)
			return MARKET_STEP_STEADY
		if(MARKET_STEP_STEADY)
			return MARKET_STEP_PLENTIFUL
		if(MARKET_STEP_PLENTIFUL)
			return MARKET_STEP_ABUNDANT
		if(MARKET_STEP_ABUNDANT)
			return MARKET_STEP_OVERSTOCKED
	return null

/datum/roguestock/proc/check_glut_relief()
	if(!trade_good_id)
		return
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events.Copy())
		if(!(trade_good_id in E.glut_goods))
			continue
		var/still_glutted = FALSE
		for(var/good_id in E.glut_goods)
			var/datum/roguestock/D = SStreasury.stockpile_by_trade_good[good_id]
			if(D && D.market_stock * 100 / D.market_target >= MARKET_RATIO_OVERSTOCKED)
				still_glutted = TRUE
				break
		if(!still_glutted)
			E.relieve_glut()

/proc/market_step_multiplier(step)
	switch(step)
		if(MARKET_STEP_GLUT)
			return MARKET_MULT_GLUT
		if(MARKET_STEP_OVERSTOCKED)
			return MARKET_MULT_OVERSTOCKED
		if(MARKET_STEP_ABUNDANT)
			return MARKET_MULT_ABUNDANT
		if(MARKET_STEP_PLENTIFUL)
			return MARKET_MULT_PLENTIFUL
		if(MARKET_STEP_LOW)
			return MARKET_MULT_LOW
		if(MARKET_STEP_SCARCE)
			return MARKET_MULT_SCARCE
		if(MARKET_STEP_VERY_SCARCE)
			return MARKET_MULT_VERY_SCARCE
		if(MARKET_STEP_SHORTAGE)
			return MARKET_MULT_SHORTAGE
	return MARKET_MULT_STEADY

/proc/market_step_label(step)
	switch(step)
		if(MARKET_STEP_GLUT)
			return "Glut"
		if(MARKET_STEP_OVERSTOCKED)
			return "Overstocked"
		if(MARKET_STEP_ABUNDANT)
			return "Abundant"
		if(MARKET_STEP_PLENTIFUL)
			return "Plentiful"
		if(MARKET_STEP_LOW)
			return "Low"
		if(MARKET_STEP_SCARCE)
			return "Scarce"
		if(MARKET_STEP_VERY_SCARCE)
			return "Very Scarce"
		if(MARKET_STEP_SHORTAGE)
			return "Shortage"
	return "Steady"

/proc/market_step_ratio(step)
	switch(step)
		if(MARKET_STEP_GLUT, MARKET_STEP_OVERSTOCKED)
			return MARKET_RATIO_OVERSTOCKED
		if(MARKET_STEP_ABUNDANT)
			return MARKET_RATIO_ABUNDANT
		if(MARKET_STEP_PLENTIFUL)
			return MARKET_RATIO_PLENTIFUL
		if(MARKET_STEP_STEADY)
			return MARKET_RATIO_STEADY
		if(MARKET_STEP_LOW)
			return MARKET_RATIO_LOW
		if(MARKET_STEP_SCARCE)
			return MARKET_RATIO_SCARCE
	return 0

/datum/roguestock/proc/market_step_min_stock(step)
	return CEILING(market_step_ratio(step) * market_target / 100, 1)

/datum/roguestock/proc/market_step_unit_ask(step)
	return stockpile_price(market_base_price() * market_step_multiplier(step) / 100)

/datum/roguestock/proc/market_next_buy_change()
	var/out_of_stock = market_out_of_stock_level()
	if(market_stock <= out_of_stock)
		return null
	var/stock = market_stock - 1
	var/step = market_step(stock)
	var/price = market_step_unit_ask(step)
	var/count = 0
	while(market_step_ratio(step) > 0)
		var/zone_min = market_step_min_stock(step)
		count += stock - zone_min + 1
		stock = zone_min - 1
		step = market_step(stock)
		var/next_price = market_step_unit_ask(step)
		if(next_price != price)
			return list("count" = count, "price" = next_price)
	count += stock - out_of_stock + 1
	if(count <= 0)
		return null
	return list("count" = count, "price" = null)

/datum/roguestock/proc/market_next_sell_change()
	var/stock = market_stock + 1
	var/step = market_step(stock)
	var/price = stockpile_price(market_step_unit_ask(step) * STOCKPILE_BID_RATIO)
	var/count = 0
	while(market_step_above(step))
		var/next_min = market_step_min_stock(market_step_above(step))
		count += next_min - stock
		stock = next_min
		step = market_step(stock)
		var/next_price = stockpile_price(market_step_unit_ask(step) * STOCKPILE_BID_RATIO)
		if(next_price != price)
			return list("count" = count, "price" = next_price)
	return null

/datum/roguestock/proc/market_segments()
	var/key = "[get_event_label()][market_has_supply()]"
	if(market_segments_cache && market_segments_key == key)
		return market_segments_cache
	var/list/segments = list()
	for(var/step = MARKET_STEP_VERY_SCARCE, step >= MARKET_STEP_OVERSTOCKED, step--)
		var/shown = market_zone_step(step)
		segments += list(list(
			"label" = market_step_label(shown),
			"from" = step == MARKET_STEP_VERY_SCARCE ? market_out_of_stock_level() : market_step_min_stock(step),
			"to" = step == MARKET_STEP_OVERSTOCKED ? null : market_step_min_stock(step - 1) - 1,
			"price" = market_step_unit_ask(shown),
		))
	market_segments_key = key
	market_segments_cache = segments
	return segments

/datum/roguestock/proc/market_base_price()
	if(trade_good_id)
		var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
		if(tg)
			return (tg.item_type && GLOB.derived_sellprices[tg.item_type]) || tg.base_price
	return withdraw_price

/datum/roguestock/proc/market_unit_ask(stock)
	return stockpile_price(market_base_price() * market_step_multiplier(market_step(stock)) / 100)

/datum/roguestock/proc/market_ask(units = 1)
	var/total = 0
	for(var/i in 1 to units)
		total += market_unit_ask(market_stock - i)
	return mammon_round(total)

/datum/roguestock/proc/market_bid(units = 1, offset = 0)
	var/total = 0
	for(var/i in 1 to units)
		total += stockpile_price(market_unit_ask(market_stock + offset + i) * STOCKPILE_BID_RATIO)
	return mammon_round(total)

/datum/roguestock/proc/check_item(obj/item/I)
	if(I.GetComponent(/datum/component/unsellable))
		return FALSE
	if(I.item_quality == ITEM_QUALITY_GIFT)
		return FALSE
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/food = I
		if(food.eat_effect == /datum/status_effect/debuff/rotfood)
			return FALSE
		if(food.bitecount > 0)
			return FALSE
		if(food.slices_num && food.slices_num < initial(food.slices_num) && !istype(food, /obj/item/reagent_containers/food/snacks/fish))
			return FALSE
	return TRUE

/proc/stockpile_price(raw)
	return max(STOCKPILE_PRICE_STEP, round(raw, STOCKPILE_PRICE_STEP))

/proc/stockpile_auto_prices(datum/trade_good/tg)
	var/unit_price = (tg.item_type && GLOB.derived_sellprices[tg.item_type]) || tg.base_price
	var/ask = stockpile_price(unit_price)
	var/bid = stockpile_price(ask * STOCKPILE_BID_RATIO)
	if(bid >= ask)
		bid = max(STOCKPILE_PRICE_STEP, ask - STOCKPILE_PRICE_STEP)
	return list(bid, ask)

/datum/roguestock/proc/compute_auto_prices(datum/trade_good/tg)
	if(!tg)
		return
	var/list/prices = stockpile_auto_prices(tg)
	payout_price = prices[1]
	withdraw_price = prices[2]

/datum/roguestock/proc/refresh_auto_price()
	if(!trade_good_id)
		return
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg)
		return
	compute_auto_prices(tg)

/// Returns "SHORTAGE", "GLUT", or "" - the plain event label without HTML.
/datum/roguestock/proc/get_event_label()
	if(!trade_good_id)
		return ""
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		if(trade_good_id in E.shortage_goods)
			return "SHORTAGE"
		if(trade_good_id in E.glut_goods)
			return "GLUT"
	return ""

/datum/roguestock/proc/get_shortage_progress()
	if(!trade_good_id)
		return null
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		if(!(trade_good_id in E.shortage_goods))
			continue
		var/list/good_names = list()
		for(var/good_id in E.shortage_goods)
			var/datum/trade_good/tg = GLOB.trade_goods[good_id]
			good_names += (tg && tg.name) ? tg.name : good_id
		return list(
			"progress" = E.saturation_progress,
			"target" = E.saturation_target,
			"affected" = jointext(good_names, ", "),
		)
	return null

/datum/roguestock/proc/market_row()
	if(market_row && market_row_stock == market_stock && market_row_royal == royal_stock && market_row_version == SStreasury.market_view_version)
		return market_row
	var/list/shortage = get_shortage_progress()
	var/list/dawn = dawn_forecast()
	market_row = list(
		"ref" = "\ref[src]",
		"name" = name,
		"desc" = desc,
		"category" = category,
		"amount" = market_stock,
		"limit" = market_target,
		"royal_amount" = royal_stock,
		"never_supplied" = market_never_supplies ? TRUE : FALSE,
		"never_bought" = market_never_buys ? TRUE : FALSE,
		"sold_out" = market_available() <= 0 ? TRUE : FALSE,
		"next_buy" = market_next_buy_change(),
		"next_sell" = market_next_sell_change(),
		"segments" = market_segments(),
		"market_label" = market_step_label(market_step(market_stock)),
		"withdraw_price" = market_ask(1),
		"deposit_price" = market_bid(1),
		"event_tag" = get_event_label(),
		"shortage_progress" = shortage ? shortage["progress"] : 0,
		"shortage_target" = shortage ? shortage["target"] : 0,
		"shortage_affected" = shortage ? shortage["affected"] : "",
		"dawn_change" = dawn["dawn_change"],
		"raided_supply" = dawn["raided_supply"],
		"raided_demand" = dawn["raided_demand"],
		"raided_suppliers" = dawn["raided_suppliers"],
		"raided_demanders" = dawn["raided_demanders"],
	)
	market_row_stock = market_stock
	market_row_royal = royal_stock
	market_row_version = SStreasury.market_view_version
	return market_row
