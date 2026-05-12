/datum/foreign_realm/etrusca
	id = REALM_ETRUSCA
	name = "Etrusca"
	auto_discovered = TRUE
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	ship_name_words = list(
		"Aurelia", "Mirella", "Esperanza", "Fortuna", "Vittoria",
		"Stella", "Corona", "Leone", "Tormenta", "Onore",
		"Armada", "Caravelle", "Sirena", "Falco", "Orso",
	)
	captain_first_names = list(
		"Rodrigo", "Esteban", "Lorenzo", "Diego", "Matteo",
		"Cesare", "Alvaro", "Hernando", "Salvatore", "Vincenzo",
		"Isabela", "Catalina", "Bianca", "Elena", "Lucrezia",
	)
	captain_last_names = list(
		"Zaragoza", "del Mar", "Velasquez", "Aldobrandi", "Cortes",
		"di Montecarina", "de Navarno", "Vellano", "Castellanos", "Lazaretto",
	)
	ship_types = list(
		list("name" = "Caravel", "tonnage" = 70, "weight" = 25),
		list("name" = "Galleon", "tonnage" = 200, "weight" = 35),
		list("name" = "Carrack", "tonnage" = 400, "weight" = 25),
		list("name" = "Armada Galleon", "tonnage" = 700, "weight" = 15),
	)
	name_prefixes = list(
		list("text" = "Don ", "chance" = 5, "requires_proper_name" = FALSE),
		list("text" = "Santa ", "chance" = 10),
	)
	city_tags = list(
		"Gran Zafiro", "Porto del Re", "Portosegreto", "San Vellano",
		"Santa Mirella", "Marenova", "Velasca", "Portavigna",
		"San Rodrigo", "Santa Aurelia", "Puerto Leon", "Miralago",
		"Montejaral", "Alcazora",
	)
	city_tag_chance = 35
	cultural_goods = list()
	bulk_supply_pool = list(
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_FISH_FILET, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_DRIED_FISH, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_LIME, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GARLICK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_TOMATO, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_EGGPLANT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool = list(
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/merc_weapons/etruscanlongsword,
		/datum/supply_pack/rogue/merc_weapons/erapier,
		/datum/supply_pack/rogue/merc_weapons/navaja,
		/datum/supply_pack/rogue/merc_weapons/saildagger,
		/datum/supply_pack/rogue/etrusca/falchion,
		/datum/supply_pack/rogue/etrusca/crossbow,
		/datum/supply_pack/rogue/etrusca/heavy_bolts,
		/datum/supply_pack/rogue/etrusca/pike,
		/datum/supply_pack/rogue/etrusca/etruscan_bascinet,
		/datum/supply_pack/rogue/etrusca/condottieri_kit,
		/datum/supply_pack/rogue/etrusca/vaquero_kit,
		/datum/supply_pack/rogue/etrusca/jamon,
		/datum/supply_pack/rogue/etrusca/coppiette,
		/datum/supply_pack/rogue/etrusca/salami,
		/datum/supply_pack/rogue/etrusca/cheese,
		/datum/supply_pack/rogue/etrusca/vaquero_ring,
		/datum/supply_pack/rogue/alcohol/limoncello,
		/datum/supply_pack/rogue/alcohol/winevalorred,
		/datum/supply_pack/rogue/alcohol/winevalorwhite,
		/datum/supply_pack/rogue/alcohol/wineraneshen,
		/datum/supply_pack/rogue/alcohol/beer,
	)
