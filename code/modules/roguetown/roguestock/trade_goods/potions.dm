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
	name = "Health Potion - 30dr bottle"
	base_price = SELLPRICE_HEALTH_POTION
	reagent_type = /datum/reagent/medicine/healthpot
	required_volume = 30

/datum/trade_good/potion/stronghealth
	id = TRADE_GOOD_STRONG_HEALTH_POTION
	name = "Strong Health Potion - 30dr bottle"
	base_price = SELLPRICE_STRONG_HEALTH_POTION
	reagent_type = /datum/reagent/medicine/stronghealth
	required_volume = 30

/datum/trade_good/potion/manapot
	id = TRADE_GOOD_MANA_POTION
	name = "Mana Potion - 30dr bottle"
	base_price = SELLPRICE_MANA_POTION
	reagent_type = /datum/reagent/medicine/manapot
	required_volume = 30

/datum/trade_good/potion/stampot
	id = TRADE_GOOD_STAM_POTION
	name = "Stamina Potion - 30dr bottle"
	base_price = SELLPRICE_STAM_POTION
	reagent_type = /datum/reagent/medicine/stampot
	required_volume = 30

/datum/trade_good/potion/antidote
	id = TRADE_GOOD_ANTIDOTE_POTION
	name = "Antidote - 30dr bottle"
	base_price = SELLPRICE_ANTIDOTE_POTION
	reagent_type = /datum/reagent/medicine/antidote
	required_volume = 30

/datum/trade_good/potion/strongmana
	id = TRADE_GOOD_STRONG_MANA_POTION
	name = "Strong Mana Potion - 30dr bottle"
	base_price = SELLPRICE_STRONG_MANA_POTION
	reagent_type = /datum/reagent/medicine/strongmana
	required_volume = 30

/datum/trade_good/potion/strongstam
	id = TRADE_GOOD_STRONG_STAM_POTION
	name = "Strong Stamina Potion - 30dr bottle"
	base_price = SELLPRICE_STRONG_STAM_POTION
	reagent_type = /datum/reagent/medicine/strongstam
	required_volume = 30

/datum/trade_good/potion/strongantidote
	id = TRADE_GOOD_STRONG_ANTIDOTE_POTION
	name = "Strong Antidote - 30dr bottle"
	base_price = SELLPRICE_STRONG_ANTIDOTE_POTION
	reagent_type = /datum/reagent/medicine/strong_antidote
	required_volume = 30

/datum/trade_good/potion/strength
	id = TRADE_GOOD_STRENGTH_POTION
	name = "Strength Potion - 30dr bottle"
	base_price = SELLPRICE_BUFF_POTION
	reagent_type = /datum/reagent/buff/strength
	required_volume = 30

/datum/trade_good/potion/perception
	id = TRADE_GOOD_PERCEPTION_POTION
	name = "Perception Potion - 30dr bottle"
	base_price = SELLPRICE_BUFF_POTION
	reagent_type = /datum/reagent/buff/perception
	required_volume = 30

/datum/trade_good/potion/intelligence
	id = TRADE_GOOD_INTELLIGENCE_POTION
	name = "Intelligence Potion - 30dr bottle"
	base_price = SELLPRICE_BUFF_POTION
	reagent_type = /datum/reagent/buff/intelligence
	required_volume = 30

/datum/trade_good/potion/speed
	id = TRADE_GOOD_SPEED_POTION
	name = "Speed Potion - 30dr bottle"
	base_price = SELLPRICE_BUFF_POTION
	reagent_type = /datum/reagent/buff/speed
	required_volume = 30
