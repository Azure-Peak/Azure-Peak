/datum/foreign_realm/otava
	id = REALM_OTAVA
	name = "Otava"
	auto_discovered = TRUE
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	ship_name_words = list(
		"Belle", "Coeur", "Lis", "Rose", "Etoile",
		"Faucon", "Lion", "Couronne", "Dame", "Chevalier",
		"Aurore", "Soleil", "Fleur", "Vent", "Vague",
	)
	proper_names = list(
		list("name" = "Astrata", "gender" = "f"),
		list("name" = "Eora", "gender" = "f"),
		list("name" = "Necra", "gender" = "f"),
		list("name" = "Pestra", "gender" = "f"),
		list("name" = "Noc", "gender" = "m"),
		list("name" = "Abyssor", "gender" = "m"),
		list("name" = "Ravox", "gender" = "m"),
		list("name" = "Malum", "gender" = "m"),
	)
	captain_first_names = list(
		"Henri", "Guillaume", "Charles", "Robert", "Aimery",
		"Jehan", "Thibault", "Gace", "Hugues", "Renaud",
		"Mahaut", "Jehanne", "Alix", "Aelis", "Sybille",
	)
	captain_last_names = list(
		"Lefèvre", "Fournier", "Mercier", "Tisserand", "Chevalier",
		"d'Esperance", "Bouchard", "Chastain", "Marchand", "le Vallouisard",
	)
	ship_types = list(
		list("name" = "Caravel", "tonnage" = 70, "weight" = 20),
		list("name" = "Galley", "tonnage" = 100, "weight" = 15),
		list("name" = "Nef", "tonnage" = 130, "weight" = 35),
		list("name" = "Great Galley", "tonnage" = 300, "weight" = 20),
		list("name" = "Galleon", "tonnage" = 600, "weight" = 10),
	)
	name_prefixes = list(
		list(
			"text_male" = "Saint-",
			"text_female" = "Sainte-",
			"chance" = 55,
			"requires_proper_name" = TRUE,
		),
		list("text_female" = "Notre-Dame de ", "chance" = 10, "requires_proper_name" = TRUE),
	)
	city_tags = list(
		"Esperance-Capitale", "Vallouise-sur-Mer", "Falaises-Rouges", "Verquent", "Noireau",
		"Vates", "Atagne", "Pais-Occitanie", "Lasquennes",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool = list(
		list("good" = TRADE_GOOD_CHEESE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_DRIED_FISH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_COD, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_STRAWBERRY, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_PLUM, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool = list(
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_FAIR, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/otava/morningstar,
		/datum/supply_pack/rogue/otava/lance,
		/datum/supply_pack/rogue/otava/flamberge,
		/datum/supply_pack/rogue/otava/falchion,
		/datum/supply_pack/rogue/otava/lucerne,
		/datum/supply_pack/rogue/otava/half_plate,
		/datum/supply_pack/rogue/otava/full_plate,
		/datum/supply_pack/rogue/otava/heavy_gambeson,
		/datum/supply_pack/rogue/otava/klappvisier,
		/datum/supply_pack/rogue/otava/gloves,
		/datum/supply_pack/rogue/otava/boots,
		/datum/supply_pack/rogue/otava/trousers,
		/datum/supply_pack/rogue/otava/satchel,
		/datum/supply_pack/rogue/otava/chevalier_kit,
		/datum/supply_pack/rogue/otava/sergent_kit,
		/datum/supply_pack/rogue/otava/cheese,
		/datum/supply_pack/rogue/alcohol/winevalorred,
		/datum/supply_pack/rogue/alcohol/winevalorwhite,
	)
