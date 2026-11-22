/datum/controller/subsystem/economy/proc/run_market_day()
	pay_caravan_rentals()
	if(ECONOMY_DAY <= MARKET_DAY_GRACE_DAYS)
		return
	var/rate = market_day_rate()
	for(var/datum/roguestock/D as anything in SStreasury.stockpile_datums)
		D.market_stock += D.market_day_change(rate, ECONOMY_DAY - 1)
	SStreasury.dirty_market_view()
	midday_market_rate = max(0, rate - 100)
	if(midday_market_rate)
		addtimer(CALLBACK(src, PROC_REF(run_midday_market)), (seconds_until_dawn() / 2) SECONDS)

/datum/controller/subsystem/economy/proc/run_midday_market()
	var/rate = midday_market_rate
	midday_market_rate = 0
	if(!rate)
		return
	for(var/datum/roguestock/D as anything in SStreasury.stockpile_datums)
		D.market_stock += D.market_day_change(rate, ECONOMY_DAY, FALSE)
	SStreasury.dirty_market_view()
	if(SStreasury.steward_machine)
		SStgui.update_uis(SStreasury.steward_machine)

/datum/controller/subsystem/economy/proc/market_day_rate()
	return MARKET_DAY_RATE + MARKET_DAY_RENTAL_RATE * caravan_rentals

/datum/controller/subsystem/economy/proc/good_producer_volumes(good_id)
	if(!producer_volumes)
		producer_volumes = list()
		for(var/region_id in GLOB.economic_regions)
			var/datum/economic_region/region = GLOB.economic_regions[region_id]
			for(var/gid in region.produces)
				var/volume = region.produces[gid]
				if(volume <= 0)
					continue
				var/list/by_region = producer_volumes[gid]
				if(!by_region)
					by_region = list()
					producer_volumes[gid] = by_region
				by_region[region_id] = volume
	return producer_volumes[good_id] || list()

/datum/controller/subsystem/economy/proc/good_supply_share(good_id, region_id)
	var/list/producers = good_producer_volumes(good_id)
	var/total = 0
	for(var/rid in producers)
		total += producers[rid]
	if(!total)
		return 0
	return round(producers[region_id] / total * 100)

/datum/controller/subsystem/economy/proc/rental_blocker()
	if(caravans_home() <= 0)
		return "No caravans are home."
	return null

/datum/controller/subsystem/economy/proc/rent_caravan(mob/user)
	var/blocker = rental_blocker()
	if(blocker)
		to_chat(user, span_warning(blocker))
		return FALSE
	caravan_rentals++
	fresh_caravan_rentals++
	SStreasury.dirty_market_view()
	log_game("CARAVAN RENTAL: [key_name(user)] rented out a caravan ([caravan_rentals] rented)")
	return TRUE

/datum/controller/subsystem/economy/proc/returnable_rentals()
	return max(0, caravan_rentals - fresh_caravan_rentals)

/datum/controller/subsystem/economy/proc/return_rental(mob/user)
	if(returnable_rentals() <= 0)
		to_chat(user, span_warning("A caravan rented today can't be taken back before dawn."))
		return FALSE
	caravan_rentals--
	SStreasury.dirty_market_view()
	log_game("CARAVAN RENTAL: [key_name(user)] took back a caravan ([caravan_rentals] rented)")
	return TRUE

/datum/controller/subsystem/economy/proc/pay_caravan_rentals()
	fresh_caravan_rentals = 0
	var/count = caravan_rentals
	if(!count)
		return
	SStreasury.mint(SStreasury.discretionary_fund, count * CARAVAN_RENTAL_PAY, "Caravan Rentals: [count] caravan\s", null, LEDGER_CROWN_REV_RENTALS)

/proc/seconds_until_market_day()
	var/seconds = seconds_until_dawn()
	var/skipped_dawns = MARKET_DAY_GRACE_DAYS - ECONOMY_DAY
	if(skipped_dawns <= 0)
		return seconds
	var/rate = SSticker?.station_time_rate_multiplier || 1
	if(rate <= 0)
		rate = 1
	return seconds + round((864000 / rate) / 10) * skipped_dawns

/datum/roguestock/proc/market_day_change(rate, escort_day, use_floor = TRUE)
	if(!market_target || get_event_label())
		return 0
	var/gap = market_target - market_stock
	if(!gap)
		return 0
	var/share = 1
	if(gap > 0)
		share = market_open_supply_share(escort_day)
		if(!share)
			return 0
	var/step = abs(gap) * rate / 100
	if(use_floor)
		step = max(step, market_target * MARKET_DAY_FLOOR / 100)
	step = min(round(step * share, 1), abs(gap))
	return gap > 0 ? step : -step

/datum/roguestock/proc/market_open_supply_share(escort_day = ECONOMY_DAY)
	if(!trade_good_id || market_never_supplies)
		return null
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg?.importable)
		return null
	var/list/producers = SSeconomy.good_producer_volumes(trade_good_id)
	var/total = 0
	var/open = 0
	for(var/region_id in producers)
		var/volume = producers[region_id]
		total += volume
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(!region.is_region_blockaded || SSeconomy.subroute_escorted(region.subroute, escort_day))
			open += volume
	if(!total)
		return null
	return open / total

/datum/roguestock/proc/dawn_forecast()
	var/list/raided = list()
	var/share = null
	if(market_stock < market_target && !get_event_label())
		share = market_open_supply_share()
		if(!isnull(share) && share < 1)
			for(var/region_id in SSeconomy.good_producer_volumes(trade_good_id))
				var/datum/economic_region/region = GLOB.economic_regions[region_id]
				if(region.is_region_blockaded && !SSeconomy.subroute_escorted(region.subroute))
					raided += region.name
	return list(
		"dawn_change" = market_day_change(SSeconomy.market_day_rate(), ECONOMY_DAY),
		"supply_pct" = isnull(share) ? 100 : round(share * 100),
		"raided_by" = raided,
	)
