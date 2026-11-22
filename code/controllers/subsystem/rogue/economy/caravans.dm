/datum/caravan_trip
	var/route
	var/sender_name
	var/request_name
	var/request_payout = 0
	var/request_quality_delta = 0
	var/request_finished = FALSE
	var/offer_good_id
	var/offer_units = 0
	var/tribute_region_id
	var/list/tribute_units

/datum/controller/subsystem/economy/proc/caravans_home()
	return max(0, caravan_fleet - length(caravan_trips) - length(caravan_rentals))

/datum/controller/subsystem/economy/proc/region_raided(region_id)
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	return region?.is_region_blockaded

/datum/controller/subsystem/economy/proc/raided_size(units)
	return max(1, CEILING(units * RAID_DEAL_SIZE_PERCENT / 100, 1))

/datum/controller/subsystem/economy/proc/order_needs(datum/standing_order/order)
	var/list/needs = order.required_items.Copy()
	if(region_raided(order.region_id))
		for(var/good_id in needs)
			needs[good_id] = raided_size(needs[good_id])
	return needs

/datum/controller/subsystem/economy/proc/order_needs_payout(datum/standing_order/order)
	var/list/needs = order_needs(order)
	var/total = 0
	for(var/good_id in needs)
		total += compute_good_unit_payout(order, good_id) * needs[good_id]
	return mammon_round(total)

/datum/controller/subsystem/economy/proc/offer_units_now(datum/region_offer/offer)
	return region_raided(offer.region_id) ? raided_size(offer.units) : offer.units

/datum/controller/subsystem/economy/proc/offer_price_now(datum/region_offer/offer)
	return mammon_round(offer.unit_price * offer_units_now(offer))

/datum/controller/subsystem/economy/proc/subroute_escorted(subroute, day = ECONOMY_DAY)
	return escorted_subroutes[subroute] == day

/datum/controller/subsystem/economy/proc/region_reachable(datum/economic_region/region)
	return !region.is_region_blockaded || subroute_escorted(region.subroute)

/datum/controller/subsystem/economy/proc/escort_fee(subroute)
	var/datum/blockade/B = find_blockade_for_subroute(subroute)
	if(!B)
		return 0
	return ESCORT_FEE_BASE + ESCORT_FEE_PER_DAY * max(0, ECONOMY_DAY - B.day_started)

/datum/controller/subsystem/economy/proc/escort_blocker(subroute)
	if(!find_blockade_for_subroute(subroute))
		return "That road is not blockaded."
	if(subroute_escorted(subroute))
		return "That road already has an escort."
	var/fee = escort_fee(subroute)
	if(SStreasury.discretionary_fund.balance < fee)
		return "The Treasury can't afford this. It has [format_mammon(SStreasury.discretionary_fund.balance)]m and needs [format_mammon(fee)]m."
	return null

/datum/controller/subsystem/economy/proc/buy_escort(mob/user, subroute)
	var/blocker = escort_blocker(subroute)
	if(blocker)
		if(user)
			to_chat(user, span_warning(blocker))
		return FALSE
	var/fee = escort_fee(subroute)
	if(!SStreasury.burn(SStreasury.discretionary_fund, fee, "Caravan Escort: [get_subroute_name(subroute)]", LEDGER_CROWN_EXP_ESCORTS))
		if(user)
			to_chat(user, span_warning("The Treasury can't afford this. It has [format_mammon(SStreasury.discretionary_fund.balance)]m and needs [format_mammon(fee)]m."))
		return FALSE
	escorted_subroutes[subroute] = ECONOMY_DAY
	SStreasury.dirty_market_view()
	log_game("CARAVAN ESCORT hired for [get_subroute_name(subroute)] by [user ? key_name(user) : "system"] (-[format_mammon(fee)]m)")
	if(user)
		to_chat(user, span_notice("An escort is hired for [get_subroute_name(subroute)] until dawn."))
	return TRUE

/datum/controller/subsystem/economy/proc/caravan_send_blocker(route, datum/standing_order/request, datum/region_offer/offer, datum/economic_region/tribute_region)
	if(caravans_home() <= 0)
		return "No caravans are home."
	if(!request && !offer && !tribute_region)
		return "The caravan has nothing to carry."
	var/spend = offer ? offer_price_now(offer) : 0
	if(spend > 0 && SStreasury.discretionary_fund.balance < spend)
		return "The Treasury can't afford this. It has [format_mammon(SStreasury.discretionary_fund.balance)]m and needs [format_mammon(spend)]m."
	if(request)
		if(request.is_fulfilled || !(request in GLOB.standing_order_pool))
			return "That order is gone."
		var/datum/economic_region/request_region = GLOB.economic_regions[request.region_id]
		if(!request_region || get_region_route(request_region) != route)
			return "That order is not on this route."
		if(!region_reachable(request_region))
			return "[request_region.name] is blockaded. You can't deliver this order until the road is cleared or escorted."
	if(offer)
		if(!(offer in GLOB.region_offer_pool))
			return "That offer is gone."
		var/datum/economic_region/offer_region = GLOB.economic_regions[offer.region_id]
		if(!offer_region || get_region_route(offer_region) != route)
			return "That offer is not on this route."
		if(!region_reachable(offer_region))
			return "[offer_region.name] is blockaded. You can't take this offer until the road is cleared or escorted."
	if(tribute_region)
		if(get_region_route(tribute_region) != route)
			return "[tribute_region.name] is not on this route."
		var/tribute_reason = tribute_region.tribute_blocker()
		if(tribute_reason)
			return tribute_reason
	return null

/datum/controller/subsystem/economy/proc/order_fill_plan(datum/standing_order/order)
	var/list/plan = list()
	var/list/needs = order_needs(order)
	for(var/good_id in needs)
		if(get_good_route(good_id) != "stockpile")
			continue
		var/datum/roguestock/D = find_stockpile_by_trade_good(good_id)
		if(!D || D.market_never_supplies)
			continue
		var/units = min(needs[good_id] - max(0, D.royal_stock), D.market_available())
		if(units > 0)
			plan[good_id] = units
	return plan

/datum/controller/subsystem/economy/proc/fill_plan_cost(list/plan)
	var/total = 0
	for(var/good_id in plan)
		var/datum/roguestock/D = find_stockpile_by_trade_good(good_id)
		total += D.market_ask(plan[good_id])
	return mammon_round(total)

/datum/controller/subsystem/economy/proc/send_caravan(mob/user, route, datum/standing_order/request, datum/region_offer/offer, datum/economic_region/tribute_region, fill = FALSE)
	var/blocker = caravan_send_blocker(route, request, offer, tribute_region)
	if(blocker)
		if(user)
			to_chat(user, span_warning(blocker))
		return FALSE
	if(request && fill)
		if(SStreasury.is_in_receivership())
			if(user)
				to_chat(user, span_warning("Trade controls are locked under sequestration. Petitions, taxes and fines still work."))
			return FALSE
		var/list/plan = order_fill_plan(request)
		if(length(plan))
			var/needed = fill_plan_cost(plan) + (offer ? offer_price_now(offer) : 0)
			if(SStreasury.discretionary_fund.balance < needed)
				if(user)
					to_chat(user, span_warning("The Treasury can't afford this. It has [format_mammon(SStreasury.discretionary_fund.balance)]m and needs [format_mammon(needed)]m."))
				return FALSE
			for(var/good_id in plan)
				buy_from_market(user, good_id, plan[good_id], FALSE)
	var/list/scan
	if(request)
		scan = scan_order(request)
		if(!scan["units"])
			if(user)
				to_chat(user, span_warning("You have none of the goods for this order."))
			return FALSE
	var/offer_units = 0
	if(offer)
		var/datum/economic_region/offer_region = GLOB.economic_regions[offer.region_id]
		var/datum/trade_good/offer_good = GLOB.trade_goods[offer.good_id]
		offer_units = offer_units_now(offer)
		var/offer_price = offer_price_now(offer)
		if(!SStreasury.burn(SStreasury.discretionary_fund, offer_price, "Regional Offer: [offer_units] [offer_good ? offer_good.name : offer.good_id] from [offer_region.name]", LEDGER_CROWN_EXP_IMPORTS))
			if(user)
				to_chat(user, span_warning("The Treasury can't afford this. It has [format_mammon(SStreasury.discretionary_fund.balance)]m and needs [format_mammon(offer_price)]m."))
			return FALSE
	var/datum/caravan_trip/trip = new()
	trip.route = route
	trip.sender_name = user?.real_name
	if(request)
		trip.request_name = request.name
		trip.request_payout = scan["payout"]
		trip.request_quality_delta = scan["quality_delta"]
		trip.request_finished = load_order(request, scan)
	if(offer)
		trip.offer_good_id = offer.good_id
		trip.offer_units = offer_units
		GLOB.region_offer_pool -= offer
	if(tribute_region)
		trip.tribute_region_id = tribute_region.region_id
		trip.tribute_units = tribute_region.take_tribute()
	caravan_trips += trip
	SStreasury.dirty_market_view()
	log_game("CARAVAN sent on [get_route_name(route)] by [user ? key_name(user) : "system"]: request [trip.request_name || "none"], offer [trip.offer_good_id || "none"], tribute [trip.tribute_region_id || "none"]")
	if(user)
		to_chat(user, span_notice("A caravan sets out toward [get_route_name(route)]. It returns the next dawn."))
	return TRUE

/datum/controller/subsystem/economy/proc/resolve_caravans()
	for(var/datum/caravan_trip/trip as anything in caravan_trips)
		if(trip.request_name)
			SStreasury.mint(SStreasury.discretionary_fund, trip.request_payout, "Standing Order: [trip.request_name]", null, LEDGER_CROWN_REV_STANDING_ORDERS)
			record_round_statistic(STATS_STANDING_ORDER_REVENUE, trip.request_payout)
			var/quality_suffix = ""
			if(trip.request_quality_delta > 0)
				quality_suffix = " (quality bonus: +[format_mammon(trip.request_quality_delta)]m)"
			else if(trip.request_quality_delta < 0)
				quality_suffix = " (quality penalty: [format_mammon(trip.request_quality_delta)]m)"
			if(trip.request_finished)
				record_round_statistic(STATS_STANDING_ORDERS_FULFILLED, 1)
				scom_announce("Standing Order fulfilled: [trip.request_name] (+[format_mammon(trip.request_payout)]m)[quality_suffix].")
			else
				scom_announce("Standing Order part delivered: [trip.request_name] (+[format_mammon(trip.request_payout)]m)[quality_suffix].")
		if(trip.offer_good_id)
			deliver_offer(trip.offer_good_id, trip.offer_units)
		if(trip.tribute_region_id)
			var/datum/economic_region/tribute_region = GLOB.economic_regions[trip.tribute_region_id]
			tribute_region?.deliver_tribute(trip.tribute_units)
	caravan_trips.Cut()
	caravan_fleet = min(CARAVAN_FLEET_MAX, caravan_fleet + CARAVAN_FLEET_PER_DAY)
	SStreasury.dirty_market_view()

/datum/controller/subsystem/economy/proc/restock_crown_imports()
	for(var/datum/crown_import/D as anything in GLOB.crown_imports)
		D.restock()
