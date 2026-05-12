/datum/foreign_realm/grenzelhoft
	id = REALM_GRENZELHOFT
	name = "Grenzelhoft"
	auto_discovered = TRUE
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	ship_name_words = list(
		"Eisernen", "Sturm", "Adler", "Wolf", "Drache",
		"Schwert", "Bruder", "Krone", "Burg", "Wappen",
		"Hammer", "Nordlicht", "Falken", "Reiter", "Greif",
	)
	captain_first_names = list(
		"Heinrich", "Konrad", "Dietrich", "Ulrich", "Gerhard",
		"Hartmann", "Albrecht", "Reinhart", "Hermann", "Sigmund",
		"Adelheid", "Mechthild", "Hedwig", "Irmgard", "Kunigunde",
	)
	captain_last_names = list(
		"Faber", "Krummhorn", "Wolfsbein", "Hartwald", "von Apfelweinheim",
		"Eisenberg", "Falkenried", "Sturmwacht", "von Zenitstadt", "von Hochburg",
	)
	ship_types = list(
		list("name" = "Coaster", "tonnage" = 30, "weight" = 15),
		list("name" = "Cog", "tonnage" = 120, "weight" = 50),
		list("name" = "Hulk", "tonnage" = 250, "weight" = 25),
		list("name" = "Carrack", "tonnage" = 500, "weight" = 10),
	)
	city_tags = list(
		"Apfelweinheim", "Zenitstadt", "Eisenhafen", "Silbergrund",
		"Hochburg", "Sterneberg", "Sankt Averial",
	)
	city_tag_chance = 35
	cultural_goods = list()
	bulk_supply_pool = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR, "always" = TRUE),
		list("good" = TRADE_GOOD_CHEESE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_BUTTER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool = list(
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_CLAY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/merc_weapons/grenzelstaff,
		/datum/supply_pack/rogue/grenzelhoft/zweihander,
		/datum/supply_pack/rogue/grenzelhoft/kriegmesser,
		/datum/supply_pack/rogue/grenzelhoft/halberd,
		/datum/supply_pack/rogue/grenzelhoft/partizan,
		/datum/supply_pack/rogue/grenzelhoft/seax,
		/datum/supply_pack/rogue/grenzelhoft/kampfmesser,
		/datum/supply_pack/rogue/grenzelhoft/blacksteel_cuirass,
		/datum/supply_pack/rogue/grenzelhoft/heavy_gambeson,
		/datum/supply_pack/rogue/grenzelhoft/plumed_hat,
		/datum/supply_pack/rogue/grenzelhoft/boots,
		/datum/supply_pack/rogue/grenzelhoft/gloves,
		/datum/supply_pack/rogue/grenzelhoft/pants,
		/datum/supply_pack/rogue/grenzelhoft/merc_tabard,
		/datum/supply_pack/rogue/grenzelhoft/magos_mantle,
		/datum/supply_pack/rogue/grenzelhoft/siegebow,
		/datum/supply_pack/rogue/grenzelhoft/heavy_bolts,
		/datum/supply_pack/rogue/grenzelhoft/almain_rivet,
		/datum/supply_pack/rogue/grenzelhoft/coppiette,
		/datum/supply_pack/rogue/grenzelhoft/salami,
		/datum/supply_pack/rogue/grenzelhoft/hardybread,
		/datum/supply_pack/rogue/alcohol/grenzelbeer,
		/datum/supply_pack/rogue/alcohol/winegrenzel,
		/datum/supply_pack/rogue/alcohol/apfelweinheim,
		/datum/supply_pack/rogue/alcohol/jagdtrunk,
		/datum/supply_pack/rogue/alcohol/beer,
		/datum/supply_pack/rogue/alcohol/blackgoat,
		/datum/supply_pack/rogue/alcohol/zagul,
		/datum/supply_pack/rogue/alcohol/onin,
	)
