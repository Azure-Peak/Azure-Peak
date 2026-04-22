SUBSYSTEM_DEF(economy)
	name = "Economy"
	init_order = INIT_ORDER_ECONOMY
	flags = SS_NO_FIRE
	var/last_processed_day = 0

/datum/controller/subsystem/economy/Initialize()
	populate_standing_order_templates()
	return ..()

/datum/controller/subsystem/economy/proc/populate_standing_order_templates()
	var/list/mapping = list(
		TRADE_REGION_KINGSFIELD = list(
			/datum/standing_order/demand_rations,
			/datum/standing_order/demand_textile,
			/datum/standing_order/demand_smithing,
			/datum/standing_order/demand_exotic,
			/datum/standing_order/demand_fishery,
			/datum/standing_order/demand_orchard,
		),
		TRADE_REGION_ROSAWOOD = list(
			/datum/standing_order/demand_construction,
			/datum/standing_order/demand_exotic,
		),
		TRADE_REGION_ROCKHILL = list(
			/datum/standing_order/demand_orchard,
			/datum/standing_order/demand_construction,
		),
		TRADE_REGION_DAFTSMARCH = list(
			/datum/standing_order/demand_construction,
			/datum/standing_order/demand_smithing,
		),
		TRADE_REGION_BLACKHOLT = list(
			/datum/standing_order/demand_exotic,
			/datum/standing_order/demand_construction,
		),
		TRADE_REGION_SALTWICK = list(
			/datum/standing_order/demand_fishery,
			/datum/standing_order/demand_construction,
		),
		TRADE_REGION_BLEAKCOAST = list(
			/datum/standing_order/demand_rations,
			/datum/standing_order/demand_armaments,
			/datum/standing_order/demand_fishery,
			/datum/standing_order/demand_construction,
		),
		TRADE_REGION_NORTHFORT = list(
			/datum/standing_order/demand_rations,
			/datum/standing_order/demand_armaments,
			/datum/standing_order/demand_construction,
		),
		TRADE_REGION_HEARTFELT = list(
			/datum/standing_order/demand_rations,
			/datum/standing_order/demand_armaments,
			/datum/standing_order/demand_textile,
			/datum/standing_order/demand_orchard,
		),
	)
	for(var/region_id in mapping)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(!region)
			continue
		region.possible_standing_order_types = mapping[region_id].Copy()

/datum/controller/subsystem/economy/proc/daily_tick()
	if(GLOB.dayspassed <= last_processed_day)
		return
	last_processed_day = GLOB.dayspassed

	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		region.produces_today = region.produces.Copy()
		region.demands_today = region.demands.Copy()

	var/list/expired = list()
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(O.is_fulfilled)
			expired += O
			continue
		if(O.day_expires <= GLOB.dayspassed)
			expired += O
	for(var/datum/standing_order/O as anything in expired)
		if(!O.is_fulfilled)
			record_round_statistic(STATS_STANDING_ORDERS_EXPIRED, 1)
		GLOB.standing_order_pool -= O

	if(GLOB.standing_order_pool.len >= STANDING_ORDERS_POOL_CAP)
		return

	var/total_to_roll = min(STANDING_ORDERS_MAX_PER_DAY, STANDING_ORDERS_BASE_PER_DAY + round(get_active_player_count() * STANDING_ORDERS_PER_ACTIVE_PLAYER))
	for(var/i in 1 to total_to_roll)
		if(GLOB.standing_order_pool.len >= STANDING_ORDERS_POOL_CAP)
			break
		var/list/eligible_ids = list()
		for(var/region_id in GLOB.economic_regions)
			var/datum/economic_region/region = GLOB.economic_regions[region_id]
			if(!length(region.possible_standing_order_types))
				continue
			var/active_count = 0
			for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
				if(O.region_id == region_id)
					active_count++
			if(active_count < STANDING_ORDERS_MAX_PER_REGION)
				eligible_ids += region_id
		if(!length(eligible_ids))
			break
		var/chosen_region_id = pick(eligible_ids)
		var/datum/economic_region/region = GLOB.economic_regions[chosen_region_id]
		var/template = pick(region.possible_standing_order_types)
		var/datum/standing_order/O = new template()
		O.region_id = region.region_id
		O.required_items = O.generate_item_mix()
		O.name = O.generate_name(region)
		O.description = O.generate_description(region)
		O.day_issued = GLOB.dayspassed
		O.day_expires = GLOB.dayspassed + STANDING_ORDER_DURATION
		O.total_payout = compute_order_payout(O, region)
		if(region.is_region_blockaded)
			O.unfulfillable = TRUE
		GLOB.standing_order_pool += O

/datum/controller/subsystem/economy/proc/compute_import_unit_price(good_id, datum/economic_region/region, unit_index)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg || !region)
		return 0
	var/daily_pace = max(1, region.produces[good_id] || 0)
	var/overshoot = max(0, (unit_index - daily_pace) / daily_pace)
	var/blockade_mult = region.is_region_blockaded ? BLOCKADE_IMPORT_MULT : 1.0
	var/unit_price = tg.base_price * (1 + overshoot * TRADE_ESCALATION_SLOPE) * tg.global_price_mod * blockade_mult
	return max(1, round(unit_price))

/datum/controller/subsystem/economy/proc/compute_export_unit_price(good_id, datum/economic_region/region, unit_index)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg || !region)
		return 0
	var/daily_pace = max(1, region.demands[good_id] || 0)
	var/overshoot = max(0, (unit_index - daily_pace) / daily_pace)
	var/blockade_mult = region.is_region_blockaded ? BLOCKADE_EXPORT_MULT : 1.0
	var/import_baseline = tg.base_price * (1 + overshoot * TRADE_ESCALATION_SLOPE) * tg.global_price_mod
	var/export_price = import_baseline * (1 - IMPORT_EXPORT_SPREAD) * blockade_mult
	return max(round(export_price), tg.low_price)

/datum/controller/subsystem/economy/proc/compute_order_payout(datum/standing_order/order, datum/economic_region/region)
	var/total = 0
	for(var/good_id in order.required_items)
		var/quantity = order.required_items[good_id]
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg)
			continue
		var/demands_today = region.demands_today[good_id] || region.demands[good_id] || 0
		var/daily_pace = max(1, region.demands[good_id] || region.produces[good_id] || 1)
		var/starting_index = max(0, daily_pace - demands_today)
		for(var/i in 1 to quantity)
			total += compute_export_unit_price(good_id, region, starting_index + i)
	return round(total)

/datum/controller/subsystem/economy/proc/fulfill_order(mob/user, datum/standing_order/order)
	if(!order || order.is_fulfilled)
		return FALSE
	if(order.unfulfillable)
		if(user)
			to_chat(user, span_warning("This order is unfulfillable (region blockaded)."))
		return FALSE

	for(var/good_id in order.required_items)
		var/required = order.required_items[good_id]
		var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
		if(!stockpile_entry || stockpile_entry.stockpile_amount < required)
			if(user)
				to_chat(user, span_warning("Insufficient [good_id]: have [stockpile_entry?.stockpile_amount || 0], need [required]."))
			return FALSE

	for(var/good_id in order.required_items)
		var/required = order.required_items[good_id]
		var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
		stockpile_entry.stockpile_amount -= required

	SStreasury.mint(SStreasury.discretionary_fund, order.total_payout, "Standing Order: [order.name]")
	record_round_statistic(STATS_STANDING_ORDER_REVENUE, order.total_payout)
	record_round_statistic(STATS_STANDING_ORDERS_FULFILLED, 1)
	order.is_fulfilled = TRUE
	GLOB.standing_order_pool -= order
	if(user)
		log_game("STANDING ORDER FULFILLED by [user.ckey]: [order.name] (+[order.total_payout]m)")
	return TRUE

/datum/controller/subsystem/economy/proc/find_stockpile_by_trade_good(good_id)
	if(!good_id)
		return null
	for(var/datum/roguestock/entry as anything in SStreasury.stockpile_datums)
		if(!("trade_good_id" in entry.vars))
			continue
		if(entry.vars["trade_good_id"] == good_id)
			return entry
	return null

/datum/controller/subsystem/economy/proc/manual_import(mob/user, region_id, good_id, quantity)
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!region)
		return 0
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg || !tg.importable)
		if(user)
			to_chat(user, span_warning("[good_id] is not importable."))
		return 0
	if(quantity <= 0)
		return 0

	var/daily_pace = region.produces[good_id] || 0
	if(daily_pace <= 0)
		if(user)
			to_chat(user, span_warning("[region.name] does not produce [tg.name]."))
		return 0

	var/produces_today = region.produces_today[good_id] || 0
	var/starting_index = max(0, daily_pace - produces_today)

	var/total_cost = 0
	for(var/i in 1 to quantity)
		total_cost += compute_import_unit_price(good_id, region, starting_index + i)

	if(SStreasury.discretionary_fund.balance < total_cost)
		if(user)
			to_chat(user, span_warning("Crown's Purse insufficient: [SStreasury.discretionary_fund.balance]m < [total_cost]m."))
		return 0

	SStreasury.burn(SStreasury.discretionary_fund, total_cost, "Manual Import: [quantity] [tg.name] from [region.name]")
	region.produces_today[good_id] = max(0, produces_today - quantity)
	var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
	if(stockpile_entry)
		stockpile_entry.stockpile_amount += quantity
	SStreasury.total_import += total_cost
	record_round_statistic(STATS_STOCKPILE_IMPORTS_VALUE, total_cost)

	if(user)
		log_game("MANUAL IMPORT by [user.ckey]: [quantity] [tg.name] from [region.name] (cost [total_cost]m)")
	return total_cost

/datum/controller/subsystem/economy/proc/manual_export(mob/user, region_id, good_id, quantity)
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!region)
		return 0
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg)
		if(user)
			to_chat(user, span_warning("[good_id] is not a known trade good."))
		return 0
	if(quantity <= 0)
		return 0

	var/daily_pace = region.demands[good_id] || 0
	if(daily_pace <= 0)
		if(user)
			to_chat(user, span_warning("[region.name] does not demand [tg.name]."))
		return 0

	var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
	if(!stockpile_entry || stockpile_entry.stockpile_amount < quantity)
		if(user)
			to_chat(user, span_warning("Insufficient [tg.name] in stockpile: have [stockpile_entry?.stockpile_amount || 0], need [quantity]."))
		return 0

	var/demands_today = region.demands_today[good_id] || 0
	var/starting_index = max(0, daily_pace - demands_today)

	var/total_revenue = 0
	for(var/i in 1 to quantity)
		total_revenue += compute_export_unit_price(good_id, region, starting_index + i)

	stockpile_entry.stockpile_amount -= quantity
	region.demands_today[good_id] = max(0, demands_today - quantity)
	SStreasury.mint(SStreasury.discretionary_fund, total_revenue, "Manual Export: [quantity] [tg.name] to [region.name]")
	SStreasury.total_export += total_revenue

	if(user)
		log_game("MANUAL EXPORT by [user.ckey]: [quantity] [tg.name] to [region.name] (revenue [total_revenue]m)")
	return total_revenue

/datum/controller/subsystem/economy/proc/cancel_orders_for_region(region_id)
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(O.region_id == region_id)
			O.unfulfillable = TRUE

/datum/controller/subsystem/economy/proc/get_best_import_region(good_id, exclude_blockaded = TRUE)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg || !tg.importable)
		return null

	var/best_region_id = null
	var/best_price = INFINITY
	var/best_blockaded = FALSE
	var/nominal_region_id = null
	var/nominal_price = INFINITY

	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		var/daily_pace = region.produces[good_id] || 0
		if(daily_pace <= 0)
			continue
		var/produces_today = region.produces_today[good_id] || 0
		var/starting_index = max(0, daily_pace - produces_today)
		var/unit_price = compute_import_unit_price(good_id, region, starting_index + 1)

		if(unit_price < nominal_price)
			nominal_price = unit_price
			nominal_region_id = region_id

		if(exclude_blockaded && region.is_region_blockaded)
			continue
		if(unit_price < best_price)
			best_price = unit_price
			best_region_id = region_id
			best_blockaded = region.is_region_blockaded

	// Fallback: cheapest blockaded region if no non-blockaded producer exists.
	if(!best_region_id && nominal_region_id)
		best_region_id = nominal_region_id
		best_price = nominal_price
		best_blockaded = TRUE

	if(!best_region_id)
		return null

	var/list/result = list(
		"region_id" = best_region_id,
		"unit_price" = round(best_price),
		"is_blockaded" = best_blockaded,
		"fallback_region_id" = null,
		"fallback_price" = null,
	)
	if(nominal_region_id && nominal_region_id != best_region_id)
		result["fallback_region_id"] = nominal_region_id
		result["fallback_price"] = round(nominal_price)
	return result

/datum/controller/subsystem/economy/proc/get_best_export_region(good_id, exclude_blockaded = TRUE)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg)
		return null

	var/best_region_id = null
	var/best_price = -1
	var/best_blockaded = FALSE
	var/nominal_region_id = null
	var/nominal_price = -1

	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		var/daily_pace = region.demands[good_id] || 0
		if(daily_pace <= 0)
			continue
		var/demands_today = region.demands_today[good_id] || 0
		var/starting_index = max(0, daily_pace - demands_today)
		var/unit_price = compute_export_unit_price(good_id, region, starting_index + 1)

		if(unit_price > nominal_price)
			nominal_price = unit_price
			nominal_region_id = region_id

		if(exclude_blockaded && region.is_region_blockaded)
			continue
		if(unit_price > best_price)
			best_price = unit_price
			best_region_id = region_id
			best_blockaded = region.is_region_blockaded

	if(!best_region_id && nominal_region_id)
		best_region_id = nominal_region_id
		best_price = nominal_price
		best_blockaded = TRUE

	if(!best_region_id)
		return null

	var/list/result = list(
		"region_id" = best_region_id,
		"unit_price" = round(best_price),
		"is_blockaded" = best_blockaded,
		"fallback_region_id" = null,
		"fallback_price" = null,
	)
	if(nominal_region_id && nominal_region_id != best_region_id)
		result["fallback_region_id"] = nominal_region_id
		result["fallback_price"] = round(nominal_price)
	return result
