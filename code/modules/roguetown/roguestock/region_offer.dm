GLOBAL_LIST_EMPTY(region_offer_pool)

/datum/region_offer
	var/name
	var/region_id
	var/good_id
	var/units = 0
	var/unit_price = 0
	var/total_price = 0
	var/day_issued = 0
	var/day_expires = 0

/datum/controller/subsystem/economy/proc/region_offer_count(region_id)
	var/count = 0
	for(var/datum/region_offer/offer as anything in GLOB.region_offer_pool)
		if(offer.region_id == region_id)
			count++
	return count

/datum/controller/subsystem/economy/proc/tick_offers(effective_pop)
	for(var/datum/region_offer/offer as anything in GLOB.region_offer_pool.Copy())
		if(offer.day_expires <= GLOB.dayspassed)
			GLOB.region_offer_pool -= offer
	var/total_to_roll = min(OFFERS_MAX_PER_DAY, OFFERS_BASE_PER_DAY + round(effective_pop * OFFERS_PER_ACTIVE_PLAYER))
	for(var/i in 1 to total_to_roll)
		if(GLOB.region_offer_pool.len >= OFFERS_POOL_CAP)
			break
		var/list/eligible_ids = list()
		for(var/region_id in GLOB.economic_regions)
			var/datum/economic_region/region = GLOB.economic_regions[region_id]
			if(region_offer_count(region_id) >= OFFERS_MAX_PER_REGION)
				continue
			if(!length(stockpile_goods(region.produces)))
				continue
			eligible_ids += region_id
		if(!length(eligible_ids))
			break
		var/datum/economic_region/region = GLOB.economic_regions[pick(eligible_ids)]
		instantiate_offer(region, pickweight(stockpile_goods(region.produces)))

/datum/controller/subsystem/economy/proc/instantiate_offer(datum/economic_region/region, good_id)
	var/price = good_steady_price(good_id)
	if(!region || price <= 0)
		return null
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	var/datum/region_offer/offer = new()
	offer.region_id = region.region_id
	offer.good_id = good_id
	offer.name = "[uppertext(region.name)] - [uppertext(tg ? tg.name : good_id)]"
	offer.units = max(1, round(rand(OFFER_VALUE_MIN, OFFER_VALUE_MAX) / price))
	offer.unit_price = mammon_round(price * OFFER_PRICE_MULT)
	offer.total_price = mammon_round(offer.unit_price * offer.units)
	offer.day_issued = GLOB.dayspassed
	offer.day_expires = GLOB.dayspassed + OFFER_DURATION
	GLOB.region_offer_pool += offer
	if(daily_report_diff)
		daily_report_diff["offers_rolled"] = (daily_report_diff["offers_rolled"] || 0) + 1
	return offer

/datum/controller/subsystem/economy/proc/take_offer(mob/user, datum/region_offer/offer)
	if(!offer || !(offer in GLOB.region_offer_pool))
		return FALSE
	var/datum/economic_region/region = GLOB.economic_regions[offer.region_id]
	if(!region)
		return FALSE
	if(region.is_region_blockaded)
		if(user)
			to_chat(user, span_warning("[region.name] is blockaded. You can't take this offer until the road is cleared."))
		return FALSE
	var/datum/roguestock/D = find_stockpile_by_trade_good(offer.good_id)
	if(!D)
		return FALSE
	if(!SStreasury.burn(SStreasury.discretionary_fund, offer.total_price, "Regional Offer: [offer.units] [D.name] from [region.name]", LEDGER_CROWN_EXP_IMPORTS))
		if(user)
			to_chat(user, span_warning("The Treasury can't afford this. It has [format_mammon(SStreasury.discretionary_fund.balance)]m and needs [format_mammon(offer.total_price)]m."))
		return FALSE
	D.royal_stock += offer.units
	record_material_flow(MATERIAL_FLOW_IN, MATERIAL_SOURCE_LOCAL_IMPORT, D.item_type, offer.units)
	GLOB.region_offer_pool -= offer
	SStreasury.dirty_market_view()
	log_game("REGIONAL OFFER taken by [user ? key_name(user) : "system"]: [offer.units] [D.name] from [region.name] (-[format_mammon(offer.total_price)]m)")
	return TRUE
