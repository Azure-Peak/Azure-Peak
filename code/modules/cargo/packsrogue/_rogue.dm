/datum/supply_pack/rogue
	var/static_cost = FALSE
	var/randomprice_factor = 0.07
	var/derive_cost = FALSE
	var/silverface_markup = 1

/datum/supply_pack/rogue/New()
	if(derive_cost)
		cost = derive_pack_cost() || cost
	. = ..()
#ifdef TESTSERVER
	cost = 1
#else
	if(cost)
		if(cost == initial(cost) && !static_cost)
			var/na = max(round(cost * randomprice_factor, 1), 1)
			cost = max(rand(cost-na, cost+na), 1)
#endif

/datum/supply_pack/rogue/proc/derive_pack_cost()
	var/total = 0
	for(var/atom/movable/path as anything in contains)
		if(initial(path.sellprice))
			return 0
		var/price = GLOB.derived_sellprices[path]
		if(!price)
			return 0
		total += price
	return round(total * SUPPLY_PACK_DERIVED_MARKUP)
