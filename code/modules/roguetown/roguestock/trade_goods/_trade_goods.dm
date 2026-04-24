/datum/trade_good
	var/id
	var/name
	var/category
	var/behavior
	var/base_price
	var/low_price
	var/high_price
	var/importable = TRUE
	var/source_region_id
	var/item_type
	var/global_price_mod = 1.0
	var/mint_eligible = FALSE
	var/crown_accepts = TRUE
	// Potion-only: alchemical orders match any reagent container holding at least
	// required_volume units of reagent_type. The container is consumed on fulfillment.
	var/reagent_type
	var/required_volume = 0

/datum/trade_good/New()
	. = ..()
	if(isnull(low_price) && !isnull(base_price))
		low_price = round(base_price * 0.6)
	if(isnull(high_price) && !isnull(base_price))
		high_price = base_price * 2

GLOBAL_LIST_INIT(trade_goods, init_trade_goods())

/proc/init_trade_goods()
	var/list/result = list()
	for(var/datum/trade_good/tg as anything in subtypesof(/datum/trade_good))
		var/datum/trade_good/instance = new tg()
		if(!instance.id)
			continue
		result[instance.id] = instance
	return result
