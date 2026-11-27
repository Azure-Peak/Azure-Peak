SUBSYSTEM_DEF(economy)
	name = "Economy"
	init_order = INIT_ORDER_ECONOMY
	flags = SS_NO_FIRE
	var/last_processed_day = 0
	var/roundstart_events_fired = FALSE
	var/simulated_player_scalar = 0
	var/list/dawn_digest = null
	var/last_petition_day = -1
	var/petitions_today = 0
	var/blockade_replenish_spent = 0
	var/list/gathering_blockades = list()
	var/list/event_path_cooldowns = list()
	var/caravan_fleet = CARAVAN_FLEET_START
	var/list/caravan_trips = list()
	var/caravan_tally_timer
	var/caravans_used_home = 0
	var/remembered_caravans_left = CARAVAN_REMEMBERED_COUNT
	var/caravan_rentals = 0
	var/fresh_caravan_rentals = 0
	var/midday_market_rate = 0
	var/list/producer_volumes
	var/list/demand_volumes
	var/list/escorted_subroutes = list()
	var/list/commission_orders = list()
	var/list/estates = list()


/datum/controller/subsystem/economy/proc/get_effective_player_count()
	if(simulated_player_scalar > 0)
		return simulated_player_scalar
	return get_active_player_count()

/datum/controller/subsystem/economy/proc/tribute_pop_mult()
	var/progress = (get_effective_player_count() - TRIBUTE_POP_SCALE_START) / (TRIBUTE_POP_SCALE_FULL - TRIBUTE_POP_SCALE_START)
	return 1 + clamp(progress, 0, 1) * (TRIBUTE_POP_MAX_MULT - 1)

/datum/controller/subsystem/economy/Initialize(mapload)
	dawn_digest = list("regular_orders_by_region" = list())
	roundstart_events()
	roundstart_blockades()
	return ..()

/datum/controller/subsystem/economy/proc/daily_tick()
	if(GLOB.dayspassed <= last_processed_day)
		return
	last_processed_day = GLOB.dayspassed
	SStreasury.dirty_market_view()

	if(!dawn_digest)
		dawn_digest = list("regular_orders_by_region" = list())

	var/effective_pop = get_effective_player_count()

	caravan_fleet = min(CARAVAN_FLEET_MAX, caravan_fleet + CARAVAN_FLEET_PER_DAY)
	caravans_used_home = 0
	schedule_caravan_tally()
	restock_crown_imports()
	restock_commissions()

	var/list/expired = list()
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(O.is_fulfilled)
			expired += O
			continue
		if(O.day_expires <= ECONOMY_DAY)
			expired += O
	for(var/datum/standing_order/O as anything in expired)
		if(!O.is_fulfilled)
			record_round_statistic(STATS_STANDING_ORDERS_EXPIRED, 1)
		GLOB.standing_order_pool -= O

	expire_economic_events()
	roll_economic_events()

	// Runs after today's prices/events settle, so active orders track current pop/prices.
	recompute_active_order_payouts()

	tick_blockade_replenish()
	run_market_day()
	tick_banditry_drain()

	if(GLOB.standing_order_pool.len < STANDING_ORDERS_POOL_CAP)
		var/total_to_roll = min(STANDING_ORDERS_MAX_PER_DAY, STANDING_ORDERS_BASE_PER_DAY + round(effective_pop * STANDING_ORDERS_PER_ACTIVE_PLAYER))
		for(var/i in 1 to total_to_roll)
			if(GLOB.standing_order_pool.len >= STANDING_ORDERS_POOL_CAP)
				break
			var/list/eligible_ids = list()
			for(var/region_id in GLOB.economic_regions)
				var/datum/economic_region/region = GLOB.economic_regions[region_id]
				if(region_order_count(region_id) >= STANDING_ORDERS_MAX_PER_REGION)
					continue
				if(!length(region.request_kinds) && !length(stockpile_goods(region.demands)))
					continue
				eligible_ids += region_id
			if(!length(eligible_ids))
				break
			roll_standing_order(GLOB.economic_regions[pick(eligible_ids)])

	tick_offers(effective_pop)

	var/list/relieved_today = dawn_digest["events_relieved"]
	var/list/by_region = dawn_digest["regular_orders_by_region"]
	var/list/dawn_parts = list()
	if(length(by_region))
		var/total_regular = 0
		for(var/region_name in by_region)
			total_regular += by_region[region_name]
		dawn_parts += "[total_regular] new standing order\s"
	if(length(dawn_parts))
		scom_announce("[jointext(dawn_parts, " - ")].")
	if(length(relieved_today))
		scom_announce("<font color='#5cb85c'>RELIEF: [jointext(relieved_today, ", ")] ended. Prices are back to normal.</font>")

	dawn_digest = null

	if(SSmerchant_trade)
		SSmerchant_trade.daily_tick()

	SStreasury.steward_machine?.push_open_windows()

/datum/controller/subsystem/economy/proc/roundstart_events()
	if(roundstart_events_fired)
		return
	roundstart_events_fired = TRUE
	roll_economic_events()

/datum/controller/subsystem/economy/proc/roll_economic_events()
	roll_event_kind(TRUE, ECON_EVENT_FISH_CROP_ACTIVE, ECON_EVENT_FISH_CROP_ACTIVE)
	roll_event_kind(FALSE, ECON_EVENT_OTHER_MIN, ECON_EVENT_OTHER_MAX)

/datum/controller/subsystem/economy/proc/roll_event_kind(fish_crops, min_count, max_count)
	var/wanted = rand(min_count, max_count)
	while(count_economic_events(fish_crops) >= wanted)
		if(!displace_oldest_event(fish_crops))
			break
	while(count_economic_events(fish_crops) < wanted)
		if(!roll_single_event(fish_crops))
			break

/datum/controller/subsystem/economy/proc/count_economic_events(fish_crops)
	. = 0
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		if(E.fish_crops == fish_crops)
			.++

/datum/controller/subsystem/economy/proc/displace_oldest_event(fish_crops)
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		if(E.fish_crops != fish_crops || E.day_started >= ECONOMY_DAY)
			continue
		end_economic_event(E)
		return TRUE
	return FALSE

/datum/controller/subsystem/economy/proc/economic_event_clashes(datum/economic_event/E)
	for(var/datum/economic_event/active as anything in GLOB.active_economic_events)
		if(length(E.affected_goods & active.affected_goods))
			return TRUE
		if(length(E.exclusive & active.exclusive))
			return TRUE
	return FALSE

/datum/controller/subsystem/economy/proc/roll_single_event(fish_crops)
	var/list/eligible = list()
	for(var/path in subtypesof(/datum/economic_event))
		var/datum/economic_event/probe = path
		if(!initial(probe.name) || initial(probe.fish_crops) != fish_crops)
			continue
		var/cooled_until = event_path_cooldowns[path]
		if(cooled_until && ECONOMY_DAY < cooled_until)
			continue
		var/datum/economic_event/tentative = new path()
		if(!economic_event_clashes(tentative))
			eligible += path
		qdel(tentative)
	if(!length(eligible))
		return FALSE
	var/chosen_path = pick(eligible)
	var/datum/economic_event/E = new chosen_path()
	E.day_started = ECONOMY_DAY
	E.day_expires = ECONOMY_DAY + E.duration_days
	GLOB.active_economic_events += E
	E.on_apply()
	record_round_statistic(STATS_ECON_EVENTS_FIRED, 1)
	return TRUE

/datum/controller/subsystem/economy/proc/expire_economic_events()
	var/list/expired = list()
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		if(E.day_expires <= ECONOMY_DAY)
			expired += E
	for(var/datum/economic_event/E as anything in expired)
		end_economic_event(E)

/datum/controller/subsystem/economy/proc/end_economic_event(datum/economic_event/E)
	E.on_expire()
	GLOB.active_economic_events -= E
	event_path_cooldowns[E.type] = ECONOMY_DAY + ECON_EVENT_REROLL_COOLDOWN_DAYS
	record_round_statistic(STATS_ECON_EVENTS_EXPIRED, 1)

/datum/controller/subsystem/economy/proc/good_steady_price(good_id)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg)
		return 0
	return (tg.item_type && GLOB.derived_sellprices[tg.item_type]) || tg.base_price

/datum/controller/subsystem/economy/proc/compute_good_unit_payout(datum/standing_order/order, good_id)
	if(!GLOB.trade_goods[good_id])
		return 0
	var/unit_mult = order.crafted ? REQUEST_CRAFTED_PAYOUT_MULT : REQUEST_GOODS_PAYOUT_MULT
	if(order.petitioned)
		unit_mult *= PETITION_TAX_MULT
	return mammon_round(good_steady_price(good_id) * unit_mult)

/datum/controller/subsystem/economy/proc/compute_equipment_delivered_value(datum/standing_order/order, list/equip_avail)
	var/total = 0
	for(var/good_id in equip_avail)
		var/list/entry = equip_avail[good_id]
		var/unit_payout = compute_good_unit_payout(order, good_id)
		var/list/payload = entry["payload"]
		var/delivered = entry["delivered_units"]
		var/counted = 0
		for(var/obj/item/I as anything in payload)
			if(counted >= delivered)
				break
			var/qmult = I.has_item_quality ? ITEM_QUALITY_MULT(I.item_quality) : ITEM_QUALITY_MULT_STANDARD
			total += mammon_round(unit_payout * qmult)
			counted++
	return total

/datum/controller/subsystem/economy/proc/compute_order_payout(datum/standing_order/order)
	var/total = 0
	for(var/good_id in order.required_items)
		total += compute_good_unit_payout(order, good_id) * order.required_items[good_id]
	return whole_mammon(total)

/// Payouts used to lock in at roll time and never catch up to later pop/price shifts while an
/// order sat unfulfilled. Recompute daily so active orders stay current.
/datum/controller/subsystem/economy/proc/recompute_active_order_payouts()
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(O.is_fulfilled)
			continue
		O.total_payout = compute_order_payout(O)

/datum/controller/subsystem/economy/proc/region_order_count(region_id)
	var/count = 0
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(O.region_id == region_id)
			count++
	return count

/datum/controller/subsystem/economy/proc/stockpile_goods(list/volumes)
	var/list/goods = list()
	for(var/good_id in volumes)
		if(!SStreasury.stockpile_by_trade_good[good_id])
			continue
		if(get_good_route(good_id) != "stockpile")
			continue
		if(good_steady_price(good_id) <= 0)
			continue
		goods[good_id] = volumes[good_id]
	return goods

/datum/controller/subsystem/economy/proc/crafted_order_count()
	var/count = 0
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(O.crafted && !O.petitioned && !O.is_fulfilled)
			count++
	return count

/datum/controller/subsystem/economy/proc/crafted_order_cap()
	var/progress = (get_effective_player_count() - REQUEST_CRAFTED_POP_SCALE_START) / (REQUEST_CRAFTED_POP_SCALE_FULL - REQUEST_CRAFTED_POP_SCALE_START)
	return round(REQUEST_CRAFTED_MAX_OPEN_MIN + clamp(progress, 0, 1) * (REQUEST_CRAFTED_MAX_OPEN_MAX - REQUEST_CRAFTED_MAX_OPEN_MIN), 1)

/datum/controller/subsystem/economy/proc/roll_standing_order(datum/economic_region/region)
	var/list/goods = stockpile_goods(region.demands)
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		goods -= E.glut_goods
	var/list/kinds = region.request_kinds.Copy()
	if(crafted_order_count() >= crafted_order_cap())
		for(var/kind in kinds.Copy())
			var/datum/request_kind/request_kind = GLOB.request_kinds[kind]
			if(request_kind?.crafted)
				kinds -= kind
	if(length(goods))
		kinds[REQUEST_KIND_GOODS] = REQUEST_WEIGHT_GOODS
	if(!length(kinds))
		return null
	var/kind = pickweight(kinds)
	if(kind == REQUEST_KIND_GOODS)
		return instantiate_request(region, pickweight(goods))
	return instantiate_kind_request(region, kind)

/datum/controller/subsystem/economy/proc/instantiate_kind_request(datum/economic_region/region, kind, petitioned = FALSE)
	var/datum/request_kind/request_kind = GLOB.request_kinds[kind]
	if(!request_kind || !length(request_kind.goods))
		return null
	return instantiate_request(region, pick(request_kind.goods), petitioned, request_kind.crafted)

/datum/controller/subsystem/economy/proc/instantiate_request(datum/economic_region/region, good_id, petitioned = FALSE, crafted = FALSE)
	if(!region || good_steady_price(good_id) <= 0)
		return null
	var/datum/standing_order/request/O = new()
	O.region_id = region.region_id
	O.good_id = good_id
	O.petitioned = petitioned
	O.crafted = crafted
	O.required_items[good_id] = deal_units(good_id, crafted ? REQUEST_CRAFTED_MAX_UNITS : 0)
	return post_standing_order(O, region)

/datum/controller/subsystem/economy/proc/deal_units(good_id, max_units = 0)
	var/datum/roguestock/D = find_stockpile_by_trade_good(good_id)
	if(D)
		return max(1, round(D.market_target * rand(DEAL_TARGET_SHARE_MIN, DEAL_TARGET_SHARE_MAX) / 100))
	var/units = max(1, round(rand(STANDING_ORDER_VALUE_MIN, STANDING_ORDER_VALUE_MAX) / good_steady_price(good_id)))
	return max_units ? min(units, max_units) : units

/datum/controller/subsystem/economy/proc/post_standing_order(datum/standing_order/O, datum/economic_region/region)
	O.name = O.generate_name(region)
	O.description = O.generate_description(region)
	O.day_issued = ECONOMY_DAY
	O.day_expires = ECONOMY_DAY + STANDING_ORDER_DURATION
	O.total_payout = compute_order_payout(O)
	GLOB.standing_order_pool += O
	if(dawn_digest && !O.petitioned)
		var/list/by_region = dawn_digest["regular_orders_by_region"]
		by_region[region.name] = (by_region[region.name] || 0) + 1
	return O


/datum/controller/subsystem/economy/proc/scan_order(datum/standing_order/order)
	var/list/equip_goods = list()
	var/list/potion_goods = list()
	var/list/stock_goods = list()
	var/has_dock = length(GLOB.steward_export_machines)
	for(var/good_id in order.required_items)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(tg?.behavior == TRADE_BEHAVIOR_EQUIPMENT)
			if(has_dock)
				equip_goods += good_id
		else if(tg?.behavior == TRADE_BEHAVIOR_POTION)
			if(has_dock)
				potion_goods += good_id
		else
			stock_goods += good_id

	var/list/needs = order_needs(order)
	var/list/equip_avail = length(equip_goods) ? scan_equipment_availability(needs, equip_goods, order.crafted) : list()
	var/list/potion_avail = length(potion_goods) ? scan_potion_availability(needs, potion_goods) : list()
	var/list/stock_avail = length(stock_goods) ? scan_stockpile_availability(needs, stock_goods) : list()

	var/units = 0
	var/payout = compute_equipment_delivered_value(order, equip_avail)
	var/quality_delta = payout
	for(var/good_id in equip_avail)
		var/list/entry = equip_avail[good_id]
		quality_delta -= compute_good_unit_payout(order, good_id) * entry["delivered_units"]
		units += entry["delivered_units"]
	for(var/list/avail_set in list(potion_avail, stock_avail))
		for(var/good_id in avail_set)
			var/list/entry = avail_set[good_id]
			payout += compute_good_unit_payout(order, good_id) * entry["delivered_units"]
			units += entry["delivered_units"]
	return list(
		"equip" = equip_avail,
		"potion" = potion_avail,
		"stock" = stock_avail,
		"units" = units,
		"payout" = max(0, whole_mammon(payout)),
		"quality_delta" = whole_mammon(quality_delta),
	)

/datum/controller/subsystem/economy/proc/load_order(datum/standing_order/order, list/scan)
	var/list/equip_avail = scan["equip"]
	var/list/potion_avail = scan["potion"]
	var/list/stock_avail = scan["stock"]
	consume_equipment_payload(equip_avail)
	consume_potion_payload(potion_avail)
	consume_stockpile_payload(stock_avail)
	order.partly_delivered = TRUE
	for(var/list/avail_set in list(equip_avail, potion_avail, stock_avail))
		for(var/good_id in avail_set)
			var/list/entry = avail_set[good_id]
			order.required_items[good_id] -= entry["delivered_units"]
			if(order.required_items[good_id] <= 0)
				order.required_items -= good_id
	if(length(order.required_items))
		order.total_payout = compute_order_payout(order)
		return FALSE
	order.is_fulfilled = TRUE
	GLOB.standing_order_pool -= order
	return TRUE

/datum/controller/subsystem/economy/proc/scan_equipment_availability(list/needs, list/goods, crafted_only = FALSE)
	var/list/out = list()
	var/list/matched_by_good = list()
	var/list/found_by_good = list()
	for(var/good_id in goods)
		matched_by_good[good_id] = list()
		found_by_good[good_id] = 0

	for(var/obj/structure/roguemachine/steward_export/M as anything in GLOB.steward_export_machines)
		if(QDELETED(M))
			continue
		for(var/obj/item/I in view(1, M))
			if(crafted_only && !I.was_crafted)
				continue
			for(var/good_id in goods)
				var/datum/trade_good/tg = GLOB.trade_goods[good_id]
				if(!tg || !tg.item_type || !istype(I, tg.item_type))
					continue
				// Exact-type match by default — avoids counting donator/unique subtypes
				// against Crown manifest orders. Goods with accept_subtypes set opt out
				// (e.g. enchantment scrolls — every spell is a distinct subtype, but the
				// Crown treats each tier as one fungible commodity).
				if(!tg.accept_subtypes && I.type != tg.item_type)
					continue
				if(found_by_good[good_id] >= needs[good_id])
					continue
				found_by_good[good_id]++
				matched_by_good[good_id] += I
				break

	for(var/good_id in goods)
		var/need = needs[good_id]
		var/have = found_by_good[good_id]
		out[good_id] = list(
			"payload" = matched_by_good[good_id],
			"delivered_units" = min(have, need),
			"need_units" = need,
			"satisfied" = (have >= need),
		)
	return out

/datum/controller/subsystem/economy/proc/scan_potion_availability(list/needs, list/goods)
	var/list/out = list()
	var/list/required_volume_by_good = list()
	var/list/found_volume_by_good = list()
	var/list/matched_containers_by_good = list()
	for(var/good_id in goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		required_volume_by_good[good_id] = needs[good_id] * tg.required_volume
		found_volume_by_good[good_id] = 0
		matched_containers_by_good[good_id] = list()

	for(var/obj/structure/roguemachine/steward_export/M as anything in GLOB.steward_export_machines)
		if(QDELETED(M))
			continue
		for(var/obj/item/reagent_containers/RC in view(1, M))
			if(!RC.reagents)
				continue
			for(var/good_id in required_volume_by_good)
				if(found_volume_by_good[good_id] >= required_volume_by_good[good_id])
					continue
				var/datum/trade_good/tg = GLOB.trade_goods[good_id]
				var/contained = RC.reagents.get_reagent_amount(tg.reagent_type)
				if(contained <= 0)
					continue
				found_volume_by_good[good_id] += contained
				matched_containers_by_good[good_id] += RC
				break

	for(var/good_id in goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		var/need_units = needs[good_id]
		var/found_volume = found_volume_by_good[good_id]
		var/delivered_units = min(need_units, round(found_volume / tg.required_volume))
		out[good_id] = list(
			"payload" = matched_containers_by_good[good_id],
			"delivered_units" = delivered_units,
			"need_units" = need_units,
			"satisfied" = (delivered_units >= need_units),
		)
	return out

/datum/controller/subsystem/economy/proc/scan_stockpile_availability(list/needs, list/goods)
	var/list/out = list()
	for(var/good_id in goods)
		var/need = needs[good_id]
		var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
		var/have = stockpile_entry ? stockpile_entry.royal_stock : 0
		out[good_id] = list(
			"payload" = null,
			"delivered_units" = min(have, need),
			"need_units" = need,
			"satisfied" = (have >= need),
		)
	return out

/datum/controller/subsystem/economy/proc/consume_equipment_payload(list/avail)
	for(var/good_id in avail)
		var/list/entry = avail[good_id]
		for(var/obj/item/I as anything in entry["payload"])
			qdel(I)

/datum/controller/subsystem/economy/proc/consume_potion_payload(list/avail)
	for(var/good_id in avail)
		var/list/entry = avail[good_id]
		for(var/obj/item/I as anything in entry["payload"])
			qdel(I)

/datum/controller/subsystem/economy/proc/consume_stockpile_payload(list/avail)
	for(var/good_id in avail)
		var/list/entry = avail[good_id]
		var/delivered = entry["delivered_units"]
		var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
		if(stockpile_entry)
			stockpile_entry.royal_stock -= delivered
			record_material_flow(MATERIAL_FLOW_OUT, MATERIAL_SOURCE_STANDING_ORDER, stockpile_entry.item_type, delivered)
	SStreasury.dirty_market_view()

/datum/controller/subsystem/economy/proc/get_good_route(good_id)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(tg?.behavior == TRADE_BEHAVIOR_EQUIPMENT || tg?.behavior == TRADE_BEHAVIOR_POTION)
		return "warehouse"
	return "stockpile"

/datum/controller/subsystem/economy/proc/find_stockpile_by_trade_good(good_id)
	if(!good_id)
		return null
	return SStreasury.stockpile_by_trade_good[good_id]

/datum/controller/subsystem/economy/proc/release_to_market(datum/roguestock/D, quantity, ledger_label)
	D.refresh_auto_price()
	var/revenue = D.market_bid(quantity)
	D.royal_stock -= quantity
	D.market_stock += quantity
	credit_economic_event_saturation(D.trade_good_id, quantity)
	SStreasury.dirty_market_view(D)
	SStreasury.mint(SStreasury.discretionary_fund, revenue, ledger_label, null, LEDGER_CROWN_REV_STOCKPILE_SALES)
	return revenue

/datum/controller/subsystem/economy/proc/sell_to_market(mob/user, good_id, quantity)
	var/datum/roguestock/D = find_stockpile_by_trade_good(good_id)
	if(!D)
		return 0
	if(D.market_never_supplies)
		to_chat(user, span_warning("The market is closed."))
		return 0
	if(D.royal_stock <= 0)
		to_chat(user, span_warning("There is no [D.name] in the royal stockpile."))
		return 0
	quantity = min(round(quantity), TRADE_MAX_BULK_UNITS, D.royal_stock)
	if(quantity <= 0)
		return 0
	var/revenue = release_to_market(D, quantity, "Market Sale: [quantity] [D.name] by [user.real_name]")
	log_game("MARKET SALE by [user.ckey]: [quantity] [D.name] (revenue [revenue]m)")
	to_chat(user, span_notice("Sold [quantity] [D.name] to the market for [format_mammon(revenue)]m."))
	return revenue

/datum/controller/subsystem/economy/proc/buy_from_market(mob/user, good_id, quantity, bulk_capped = TRUE)
	var/datum/roguestock/D = find_stockpile_by_trade_good(good_id)
	if(!D)
		return 0
	if(D.market_never_supplies)
		to_chat(user, span_warning("The market is closed."))
		return 0
	D.refresh_auto_price()
	quantity = min(round(quantity), D.market_available())
	if(bulk_capped)
		quantity = min(quantity, TRADE_MAX_BULK_UNITS)
	if(quantity <= 0)
		to_chat(user, span_warning("[D.name] is out of stock."))
		return 0
	var/cost = D.market_ask(quantity)
	if(!SStreasury.burn(SStreasury.discretionary_fund, cost, "Market Purchase: [quantity] [D.name] by [user.real_name]", LEDGER_CROWN_EXP_STOCKPILE))
		to_chat(user, span_warning("The Treasury can't afford this. It has [format_mammon(SStreasury.discretionary_fund.balance)]m and needs [format_mammon(cost)]m."))
		return 0
	D.market_stock -= quantity
	D.royal_stock += quantity
	D.check_glut_relief()
	debit_economic_event_saturation(good_id, quantity)
	SStreasury.dirty_market_view(D)
	log_game("MARKET PURCHASE by [user.ckey]: [quantity] [D.name] (cost [cost]m)")
	to_chat(user, span_notice("Bought [quantity] [D.name] from the market for [format_mammon(cost)]m."))
	return cost
