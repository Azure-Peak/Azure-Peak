/datum/foreign_realm/aavnr
	id = REALM_AAVNR
	name = "Aavnr"
	auto_discovered = TRUE
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	ship_name_words = list(
		"Yarlsnik", "Koprivka", "Diethelm", "Tomorzh", "Khairin",
		"Wardenpact", "Hetman", "Saiga", "Bloodaxe", "Ironmask",
		"Pontinate", "Astrava", "Ravox", "Zogiin", "Khaganur",
	)
	captain_first_names = list(
		"Bjorn", "Yakiv", "Tomasz", "Lubomir", "Radek",
		"Szabolcs", "Aleksy", "Miron", "Branislav", "Kazimir",
		"Yelena", "Magda", "Zofia", "Liliana", "Vasylyna",
	)
	captain_last_names = list(
		"Yakivin", "Trunfelov", "Koprivchak", "Astravich", "Drogomir",
		"Hetmanov", "Szabrik", "Ironwald", "Bloodgrip", "Khairov",
	)
	ship_types = list(
		list("name" = "Koch", "tonnage" = 50, "weight" = 25),
		list("name" = "Lodya", "tonnage" = 120, "weight" = 35),
		list("name" = "Steppe Galley", "tonnage" = 250, "weight" = 25),
		list("name" = "Khaganur Hulk", "tonnage" = 500, "weight" = 15),
	)
	name_prefixes = list(
		list("text" = "Hetman ", "chance" = 10),
		list("text" = "Free ", "chance" = 5),
	)
	city_tags = list(
		"Tomorzurkh", "Dalainkhair", "Enkhjarlgal", "Koprivkolov", "Free Szöréndnížina",
	)
	city_tag_chance = 35
	cultural_goods = list()
	bulk_supply_pool = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_DRIED_FISH, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_MEAT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_CLAM, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool = list(
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GLASS_BATCH, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/aavnr/shashka,
		/datum/supply_pack/rogue/aavnr/recurve_bow,
		/datum/supply_pack/rogue/aavnr/steppe_axe,
		/datum/supply_pack/rogue/aavnr/nagaika,
		/datum/supply_pack/rogue/aavnr/steppe_shield,
		/datum/supply_pack/rogue/aavnr/shishak,
		/datum/supply_pack/rogue/aavnr/papakha,
		/datum/supply_pack/rogue/aavnr/ironmask,
		/datum/supply_pack/rogue/aavnr/chargah,
		/datum/supply_pack/rogue/aavnr/hatanga,
		/datum/supply_pack/rogue/aavnr/steppe_scale,
		/datum/supply_pack/rogue/aavnr/szabrista_kit,
		/datum/supply_pack/rogue/aavnr/druzhina_kit,
		/datum/supply_pack/rogue/aavnr/freifechter_kit,
		/datum/supply_pack/rogue/aavnr/saiga_sausage,
		/datum/supply_pack/rogue/aavnr/coppiette,
		/datum/supply_pack/rogue/alcohol/avarmead,
		/datum/supply_pack/rogue/alcohol/avarrice,
		/datum/supply_pack/rogue/alcohol/saigamilk,
	)
