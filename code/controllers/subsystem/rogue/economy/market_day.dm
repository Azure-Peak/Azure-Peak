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
		producer_volumes = build_volume_index(TRUE)
	return producer_volumes[good_id] || list()

/datum/controller/subsystem/economy/proc/good_demand_volumes(good_id)
	if(!demand_volumes)
		demand_volumes = build_volume_index(FALSE)
	return demand_volumes[good_id] || list()

/datum/controller/subsystem/economy/proc/build_volume_index(produced)
	var/list/index = list()
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		var/list/volumes = produced ? region.produces : region.demands
		for(var/gid in volumes)
			var/volume = volumes[gid]
			if(volume <= 0)
				continue
			var/list/by_region = index[gid]
			if(!by_region)
				by_region = list()
				index[gid] = by_region
			by_region[region_id] = volume
	return index

/proc/open_volume_share(list/volumes, escort_day = ECONOMY_DAY)
	var/total = 0
	var/open = 0
	for(var/region_id in volumes)
		var/volume = volumes[region_id]
		total += volume
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(!region.is_region_blockaded || SSeconomy.subroute_escorted(region.subroute, escort_day))
			open += volume
	if(!total)
		return null
	return open / total

/proc/raided_region_names(list/volumes)
	var/list/names = list()
	for(var/region_id in volumes)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(region.is_region_blockaded && !SSeconomy.subroute_escorted(region.subroute))
			names += region.name
	return names

/datum/controller/subsystem/economy/proc/good_supply_share(good_id, region_id)
	return volume_share_pct(good_producer_volumes(good_id), region_id)

/datum/controller/subsystem/economy/proc/good_demand_share(good_id, region_id)
	return volume_share_pct(good_demand_volumes(good_id), region_id)

/proc/volume_share_pct(list/volumes, region_id)
	var/total = 0
	for(var/rid in volumes)
		total += volumes[rid]
	if(!total)
		return 0
	return round(volumes[region_id] / total * 100)

/datum/controller/subsystem/economy/proc/rental_blocker()
	if(caravans_home() <= 0)
		return "No caravans are home."
	if(caravans_home() <= caravans_used_home)
		return "Caravans back from the road today can't be rented out before dawn."
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
	var/share
	if(gap > 0)
		share = market_open_supply_share(escort_day)
	else
		share = market_open_demand_share(escort_day)
		if(isnull(share))
			share = 1
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
	return open_volume_share(SSeconomy.good_producer_volumes(trade_good_id), escort_day)

/datum/roguestock/proc/market_open_demand_share(escort_day = ECONOMY_DAY)
	if(!trade_good_id)
		return null
	return open_volume_share(SSeconomy.good_demand_volumes(trade_good_id), escort_day)

/datum/roguestock/proc/dawn_forecast()
	var/supply_share = market_open_supply_share()
	var/demand_share = market_open_demand_share()
	var/supply_raided = !isnull(supply_share) && supply_share < 1
	var/demand_raided = !isnull(demand_share) && demand_share < 1
	return list(
		"dawn_change" = market_day_change(SSeconomy.market_day_rate(), ECONOMY_DAY),
		"raided_supply" = supply_raided ? 100 - round(supply_share * 100) : 0,
		"raided_demand" = demand_raided ? 100 - round(demand_share * 100) : 0,
		"raided_suppliers" = supply_raided ? raided_region_names(SSeconomy.good_producer_volumes(trade_good_id)) : list(),
		"raided_demanders" = demand_raided ? raided_region_names(SSeconomy.good_demand_volumes(trade_good_id)) : list(),
	)
