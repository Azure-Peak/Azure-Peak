/datum/trade_good/gold_ore
	id = TRADE_GOOD_GOLD_ORE
	name = "Gold Ore"
	category = TRADE_CATEGORY_PRECIOUS_METAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_GOLD_ORE
	source_region_id = TRADE_REGION_DAFTSMARCH
	item_type = /obj/item/rogueore/gold

/datum/trade_good/silver_ore
	id = TRADE_GOOD_SILVER_ORE
	name = "Silver Ore"
	category = TRADE_CATEGORY_PRECIOUS_METAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_SILVER_ORE
	importable = FALSE
	source_region_id = null
	item_type = /obj/item/rogueore/silver
