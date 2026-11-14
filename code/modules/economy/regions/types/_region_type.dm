/datum/region_type
	var/name
	var/description = ""
	var/list/produces = list()
	var/list/demands = list()
	var/list/seasonal_produces = list()
	var/list/seasonal_demands = list()
	var/list/standing_orders = list()

/datum/region_type/New()
	. = ..()
	produces = expand_trade_good_groups(produces)
	demands = expand_trade_good_groups(demands)
	for(var/season in seasonal_produces)
		if(islist(seasonal_produces[season]))
			seasonal_produces[season] = expand_trade_good_groups(seasonal_produces[season])
	for(var/season in seasonal_demands)
		if(islist(seasonal_demands[season]))
			seasonal_demands[season] = expand_trade_good_groups(seasonal_demands[season])

/proc/expand_trade_good_groups(list/entries)
	var/list/expanded = list()
	for(var/key in entries)
		if(!ispath(key, /datum/trade_good_group))
			continue
		var/datum/trade_good_group/group = new key()
		for(var/good_id in group.goods)
			expanded[good_id] = entries[key]
	for(var/key in entries)
		if(!ispath(key, /datum/trade_good_group))
			expanded[key] = entries[key]
	return expanded

/datum/region_type/proc/season_multiplier(list/seasonal, good_id, season)
	var/entry = seasonal[season]
	if(isnull(entry))
		return 1
	if(islist(entry))
		var/list/per_good = entry
		return isnull(per_good[good_id]) ? 1 : per_good[good_id]
	return entry
