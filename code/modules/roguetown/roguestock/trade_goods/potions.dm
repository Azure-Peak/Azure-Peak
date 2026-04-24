/datum/trade_good/potion
	behavior = TRADE_BEHAVIOR_POTION
	importable = FALSE
	crown_accepts = TRUE
	category = TRADE_CATEGORY_POTION

// Each bottle of a standard potion holds 50u. The alchemical fulfillment path counts
// the delivered reagent by TOTAL volume across all containers at the warehouse (any
// container type works), then consumes matched containers once the required volume
// is met. required_volume is the per-unit ledger quantity — "one unit" = one 50u bottle.

/datum/trade_good/potion/healthpot
	id = TRADE_GOOD_HEALTH_POTION
	name = "Health Potion - 50dr bottle"
	base_price = SELLPRICE_HEALTH_POTION
	reagent_type = /datum/reagent/medicine/healthpot
	required_volume = 50

/datum/trade_good/potion/stronghealth
	id = TRADE_GOOD_STRONG_HEALTH_POTION
	name = "Strong Health Potion - 50dr bottle"
	base_price = SELLPRICE_STRONG_HEALTH_POTION
	reagent_type = /datum/reagent/medicine/stronghealth
	required_volume = 50

/datum/trade_good/potion/manapot
	id = TRADE_GOOD_MANA_POTION
	name = "Mana Potion - 50dr bottle"
	base_price = SELLPRICE_MANA_POTION
	reagent_type = /datum/reagent/medicine/manapot
	required_volume = 50

/datum/trade_good/potion/stampot
	id = TRADE_GOOD_STAM_POTION
	name = "Stamina Potion - 50dr bottle"
	base_price = SELLPRICE_STAM_POTION
	reagent_type = /datum/reagent/medicine/stampot
	required_volume = 50

/datum/trade_good/potion/antidote
	id = TRADE_GOOD_ANTIDOTE_POTION
	name = "Antidote - 50dr bottle"
	base_price = SELLPRICE_ANTIDOTE_POTION
	reagent_type = /datum/reagent/medicine/antidote
	required_volume = 50
