// Keep all ingots as market_never_buys to avoid 1 level exploits with buying ores and instantly reselling
/datum/roguestock/stockpile/iron_ingot
	name = "Iron Ingot"
	desc = "A smelted bar of iron for forging."
	item_type = /obj/item/ingot/iron
	trade_good_id = TRADE_GOOD_IRON_INGOT
	market_never_buys = TRUE
	market_stock = 0
	category = "Refined"

/datum/roguestock/stockpile/copper_ingot
	name = "Copper Ingot"
	desc = "A smelted bar of copper for alloying."
	item_type = /obj/item/ingot/copper
	trade_good_id = TRADE_GOOD_COPPER_INGOT
	market_never_buys = TRUE
	market_stock = 0
	category = "Refined"

/datum/roguestock/stockpile/tin_ingot
	name = "Tin Ingot"
	desc = "A smelted bar of tin for alloying."
	item_type = /obj/item/ingot/tin
	trade_good_id = TRADE_GOOD_TIN_INGOT
	market_never_buys = TRUE
	market_stock = 0
	category = "Refined"

/datum/roguestock/stockpile/steel_ingot
	name = "Steel Ingot"
	desc = "A smelted bar of steel for forging fine weapons and armor."
	item_type = /obj/item/ingot/steel
	trade_good_id = TRADE_GOOD_STEEL_INGOT
	market_never_buys = TRUE
	market_stock = 0
	category = "Refined"

/datum/roguestock/stockpile/gold_ingot
	name = "Gold Ingot"
	desc = "A bar of refined gold."
	item_type = /obj/item/ingot/gold
	trade_good_id = TRADE_GOOD_GOLD_INGOT
	market_never_buys = TRUE
	market_stock = 0
	market_target = MARKET_TARGET_RARE
	category = "Refined"

/datum/roguestock/stockpile/silver_ingot
	name = "Silver Ingot"
	desc = "A bar of refined silver."
	item_type = /obj/item/ingot/silver
	trade_good_id = TRADE_GOOD_SILVER_INGOT
	market_stock = 0
	market_target = MARKET_TARGET_RARE
	category = "Refined"
	market_never_supplies = TRUE

/datum/roguestock/stockpile/bronze_ingot
	name = "Bronze Ingot"
	desc = "A smelted bar of bronze for making gadgets and contraptions."
	item_type = /obj/item/ingot/bronze
	trade_good_id = TRADE_GOOD_BRONZE_INGOT
	market_never_buys = TRUE
	market_stock = 0
	category = "Refined"
