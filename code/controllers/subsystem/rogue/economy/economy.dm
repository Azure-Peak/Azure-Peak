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
			/datum/standing_order/kingsfield_surplus,
			/datum/standing_order/general_smith_supply,
		),
		TRADE_REGION_ROSAWOOD = list(
			/datum/standing_order/rosawood_timber,
			/datum/standing_order/general_cloth,
		),
		TRADE_REGION_ROCKHILL = list(
			/datum/standing_order/rockhill_orchard,
			/datum/standing_order/general_cloth,
		),
		TRADE_REGION_DAFTSMARCH = list(
			/datum/standing_order/daftsmarch_ore,
			/datum/standing_order/general_smith_supply,
		),
		TRADE_REGION_BLACKHOLT = list(
			/datum/standing_order/blackholt_exotic,
		),
		TRADE_REGION_SALTWICK = list(
			/datum/standing_order/saltwick_catch,
			/datum/standing_order/general_cloth,
		),
		TRADE_REGION_BLEAKCOAST = list(
			/datum/standing_order/garrison_rations,
			/datum/standing_order/garrison_armaments,
		),
		TRADE_REGION_NORTHFORT = list(
			/datum/standing_order/garrison_rations,
			/datum/standing_order/garrison_armaments,
		),
		TRADE_REGION_HEARTFELT = list(
			/datum/standing_order/garrison_rations,
			/datum/standing_order/garrison_armaments,
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
		O.day_issued = GLOB.dayspassed
		O.day_expires = GLOB.dayspassed + STANDING_ORDER_DURATION
		O.total_payout = compute_order_payout(O, region)
		if(region.is_region_blockaded)
			O.unfulfillable = TRUE
		GLOB.standing_order_pool += O

/datum/controller/subsystem/economy/proc/compute_order_payout(datum/standing_order/order, datum/economic_region/region)
	var/total = 0
	for(var/good_id in order.required_items)
		var/quantity = order.required_items[good_id]
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg)
			continue
		var/daily_pace = region.demands_today[good_id] || region.produces_today[good_id] || 1
		for(var/i in 1 to quantity)
			var/overshoot = max(0, (i - daily_pace) / daily_pace)
			var/unit_price = tg.base_price * (1 - overshoot * TRADE_ESCALATION_SLOPE) * tg.global_price_mod
			unit_price = max(unit_price, tg.low_price)
			total += unit_price
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
		return FALSE
	if(region.is_region_blockaded)
		if(user)
			to_chat(user, span_warning("[region.name] is blockaded. Trade impossible."))
		return FALSE
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg || !tg.importable)
		if(user)
			to_chat(user, span_warning("[good_id] is not importable."))
		return FALSE

	var/daily_pace = region.produces[good_id] || 0
	if(daily_pace <= 0)
		if(user)
			to_chat(user, span_warning("[region.name] does not produce [tg.name]."))
		return FALSE

	var/total_cost = 0
	var/produces_today = region.produces_today[good_id] || 0
	for(var/i in 1 to quantity)
		var/units_past_pace = max(0, (daily_pace - produces_today) - 1)
		var/overshoot_ratio = units_past_pace / max(1, daily_pace)
		var/unit_price = tg.base_price * (1 + overshoot_ratio * TRADE_ESCALATION_SLOPE) * tg.global_price_mod
		total_cost += unit_price
		produces_today = max(0, produces_today - 1)

	total_cost = round(total_cost)
	if(SStreasury.discretionary_fund.balance < total_cost)
		if(user)
			to_chat(user, span_warning("Crown's Purse insufficient: [SStreasury.discretionary_fund.balance]m < [total_cost]m."))
		return FALSE

	SStreasury.burn(SStreasury.discretionary_fund, total_cost, "Manual Import: [quantity] [tg.name] from [region.name]")
	region.produces_today[good_id] = produces_today
	var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
	if(stockpile_entry)
		stockpile_entry.stockpile_amount += quantity

	if(user)
		log_game("MANUAL IMPORT by [user.ckey]: [quantity] [tg.name] from [region.name] (cost [total_cost]m)")
	return TRUE

/datum/controller/subsystem/economy/proc/manual_export(mob/user, region_id, good_id, quantity)
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!region)
		return FALSE
	if(region.is_region_blockaded)
		if(user)
			to_chat(user, span_warning("[region.name] is blockaded. Trade impossible."))
		return FALSE
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg)
		if(user)
			to_chat(user, span_warning("[good_id] is not a known trade good."))
		return FALSE

	var/daily_pace = region.demands[good_id] || 0
	if(daily_pace <= 0)
		if(user)
			to_chat(user, span_warning("[region.name] does not demand [tg.name]."))
		return FALSE

	var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
	if(!stockpile_entry || stockpile_entry.stockpile_amount < quantity)
		if(user)
			to_chat(user, span_warning("Insufficient [tg.name] in stockpile: have [stockpile_entry?.stockpile_amount || 0], need [quantity]."))
		return FALSE

	var/total_revenue = 0
	var/demands_today = region.demands_today[good_id] || 0
	for(var/i in 1 to quantity)
		var/units_past_pace = max(0, (daily_pace - demands_today) - 1)
		var/overshoot_ratio = units_past_pace / max(1, daily_pace)
		var/unit_price = tg.base_price * (1 - overshoot_ratio * TRADE_ESCALATION_SLOPE) * tg.global_price_mod
		unit_price = max(unit_price, tg.low_price)
		total_revenue += unit_price
		demands_today = max(0, demands_today - 1)

	total_revenue = round(total_revenue)
	stockpile_entry.stockpile_amount -= quantity
	region.demands_today[good_id] = demands_today
	SStreasury.mint(SStreasury.discretionary_fund, total_revenue, "Manual Export: [quantity] [tg.name] to [region.name]")

	if(user)
		log_game("MANUAL EXPORT by [user.ckey]: [quantity] [tg.name] to [region.name] (revenue [total_revenue]m)")
	return TRUE

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
		var/units_past_pace = max(0, (daily_pace - produces_today) - 1)
		var/overshoot_ratio = units_past_pace / max(1, daily_pace)
		var/unit_price = tg.base_price * (1 + overshoot_ratio * TRADE_ESCALATION_SLOPE) * tg.global_price_mod

		if(unit_price < nominal_price)
			nominal_price = unit_price
			nominal_region_id = region_id

		if(exclude_blockaded && region.is_region_blockaded)
			continue
		if(unit_price < best_price)
			best_price = unit_price
			best_region_id = region_id
			best_blockaded = region.is_region_blockaded

	if(!best_region_id && !nominal_region_id)
		return null

	var/list/result = list(
		"region_id" = best_region_id,
		"unit_price" = (best_region_id ? round(best_price) : null),
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
		var/units_past_pace = max(0, (daily_pace - demands_today) - 1)
		var/overshoot_ratio = units_past_pace / max(1, daily_pace)
		var/unit_price = tg.base_price * (1 - overshoot_ratio * TRADE_ESCALATION_SLOPE) * tg.global_price_mod
		unit_price = max(unit_price, tg.low_price)

		if(unit_price > nominal_price)
			nominal_price = unit_price
			nominal_region_id = region_id

		if(exclude_blockaded && region.is_region_blockaded)
			continue
		if(unit_price > best_price)
			best_price = unit_price
			best_region_id = region_id
			best_blockaded = region.is_region_blockaded

	if(!best_region_id && !nominal_region_id)
		return null

	var/list/result = list(
		"region_id" = best_region_id,
		"unit_price" = (best_region_id ? round(best_price) : null),
		"is_blockaded" = best_blockaded,
		"fallback_region_id" = null,
		"fallback_price" = null,
	)
	if(nominal_region_id && nominal_region_id != best_region_id)
		result["fallback_region_id"] = nominal_region_id
		result["fallback_price"] = round(nominal_price)
	return result
