/datum/foreign_realm/lirvas
	id = REALM_LIRVAS
	name = "Lirvas"
	auto_discovered = FALSE
	roll_weight = TRADE_REALM_WEIGHT_RARE
	ship_name_words = list(
		"Zarvlor", "Vyrn", "Drak", "Aurum", "Tithe",
		"Hoard", "Mammon", "Sissean", "Coil", "Scale",
		"Ring", "Vault", "Talon", "Wyrm", "Avarice",
	)
	captain_first_names = list(
		"Zarrak", "Hosk", "Kessith", "Slazri", "Rokzar",
		"Hralz", "Zelkar", "Vossar", "Sirhak", "Kazros",
		"Zessira", "Hsalka", "Rikzira", "Solzra", "Kazinna",
	)
	captain_last_names = list(
		"Goldscale", "Hoardkeeper", "Tithebound", "Coilmaster", "Ringclimber",
		"Vyrn-Heir", "Mammonborn", "Scriphandler", "of the Inner Ring", "of Zarvlor",
	)
	ship_types = list(
		list("name" = "Tithebearer Cog", "tonnage" = 100, "weight" = 35),
		list("name" = "Goldscale Hulk", "tonnage" = 220, "weight" = 35),
		list("name" = "Vyrn Carrack", "tonnage" = 450, "weight" = 25),
		list("name" = "Hoardship", "tonnage" = 700, "weight" = 5),
	)
	city_tags = list()
	city_tag_chance = 0
	cultural_goods = list()
	bulk_supply_pool = list(
		list("good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TOPER, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_BLORTZ, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_DORPEL, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_CINNABAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_GOLD_ORE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/amethyst,
		/datum/supply_pack/rogue/gems/toper,
		/datum/supply_pack/rogue/gems/gemerald,
		/datum/supply_pack/rogue/gems/saffira,
		/datum/supply_pack/rogue/gems/blortz,
		/datum/supply_pack/rogue/gems/diamond,
		/datum/supply_pack/rogue/gems/jade,
		/datum/supply_pack/rogue/gems/onyxa,
		/datum/supply_pack/rogue/gems/amber,
		/datum/supply_pack/rogue/gems/opal,
		/datum/supply_pack/rogue/lirvas/tabard,
		/datum/supply_pack/rogue/lirvas/pauldrons,
		/datum/supply_pack/rogue/lirvas/gold_gorget,
		/datum/supply_pack/rogue/lirvas/gold_kilt,
		/datum/supply_pack/rogue/lirvas/gold_quarterstaff,
		/datum/supply_pack/rogue/lirvas/sabre,
		/datum/supply_pack/rogue/lirvas/tithebound_kit,
		/datum/supply_pack/rogue/alcohol/rtoper,
	)
