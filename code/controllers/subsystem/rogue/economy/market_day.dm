/datum/controller/subsystem/economy/proc/run_market_day()
	if(GLOB.dayspassed <= MARKET_DAY_GRACE_DAYS)
		return
	for(var/datum/roguestock/D as anything in SStreasury.stockpile_datums)
		D.market_day_step(MARKET_DAY_RATE)
	SStreasury.dirty_market_view()

/proc/seconds_until_market_day()
	var/seconds = seconds_until_dawn()
	var/skipped_dawns = MARKET_DAY_GRACE_DAYS - GLOB.dayspassed
	if(skipped_dawns <= 0)
		return seconds
	var/rate = SSticker?.station_time_rate_multiplier || 1
	if(rate <= 0)
		rate = 1
	return seconds + round((864000 / rate) / 10) * skipped_dawns

/datum/roguestock/proc/market_day_step(rate)
	if(!market_target || get_event_label())
		return
	var/gap = market_target - market_stock
	if(!gap)
		return
	var/open_share = market_open_supply_share()
	if(isnull(open_share))
		if(gap > 0)
			return
		open_share = 1
	var/step = max(abs(gap) * rate / 100, market_target * MARKET_DAY_FLOOR / 100) * open_share
	step = min(round(step, 1), abs(gap))
	market_stock += gap > 0 ? step : -step

/datum/roguestock/proc/market_open_supply_share()
	if(!trade_good_id || market_never_supplies)
		return null
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg?.importable)
		return null
	var/producers = 0
	var/open = 0
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(!region.produces[trade_good_id])
			continue
		producers++
		if(!region.is_region_blockaded || SSeconomy.subroute_escorted(region.subroute, GLOB.dayspassed - 1))
			open++
	if(!producers)
		return null
	return open / producers
