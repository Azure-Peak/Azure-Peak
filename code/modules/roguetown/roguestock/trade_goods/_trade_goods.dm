/datum/trade_good
	var/id
	var/name
	var/category
	var/behavior
	var/base_price
	var/importable = TRUE
	var/source_region_id
	var/item_type
	/// Equipment-behavior only: when TRUE, fulfillment accepts any subtype of item_type
	/// (not just exact matches). Used for goods that have many cosmetic/mechanical variants
	/// that should all count as the same shipment - e.g. enchantment scrolls.
	var/accept_subtypes = FALSE
	var/global_price_mod = 1.0
	var/derive_price = FALSE
	var/crown_accepts = TRUE
	/// Optional override for the market-pool ITEM_CAT_* this good's item_type maps to.
	/// Used for trade goods whose item_type isn't crafted (e.g. fish), so the recipe walker
	/// never tags them. The pricing engine writes this into GLOB.derived_categories during init.
	var/display_category
	// Potion-only: alchemical orders match any reagent container holding at least
	// required_volume units of reagent_type. The container is consumed on fulfillment.
	var/reagent_type
	var/required_volume = 0

GLOBAL_LIST_INIT(trade_goods, init_trade_goods())

/proc/init_trade_goods()
	var/list/result = list()
	for(var/datum/trade_good/tg as anything in subtypesof(/datum/trade_good))
		var/datum/trade_good/instance = new tg()
		if(!instance.id)
			continue
		result[instance.id] = instance
	return result
