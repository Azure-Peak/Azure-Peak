/datum/controller/subsystem/economy/proc/region_offer_count(region_id)
	var/count = 0
	for(var/datum/region_offer/offer as anything in GLOB.region_offer_pool)
		if(offer.region_id == region_id)
			count++
	return count

/datum/controller/subsystem/economy/proc/tick_offers(effective_pop)
	for(var/datum/region_offer/offer as anything in GLOB.region_offer_pool.Copy())
		if(offer.day_expires <= ECONOMY_DAY)
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
	offer.units = deal_units(good_id)
	offer.unit_price = mammon_round(price * OFFER_PRICE_MULT)
	offer.total_price = whole_mammon(offer.unit_price * offer.units)
	offer.day_issued = ECONOMY_DAY
	offer.day_expires = ECONOMY_DAY + OFFER_DURATION
	GLOB.region_offer_pool += offer
	return offer

/datum/controller/subsystem/economy/proc/deliver_offer(good_id, units)
	var/datum/roguestock/D = find_stockpile_by_trade_good(good_id)
	if(!D)
		return
	D.royal_stock += units
	record_material_flow(MATERIAL_FLOW_IN, MATERIAL_SOURCE_LOCAL_IMPORT, D.item_type, units)
