/datum/foreign_realm/hammerhold
	id = REALM_HAMMERHOLD
	name = "Hammerhold"
	auto_discovered = FALSE
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	ship_name_words = list(
		"Æthel", "Beorht", "Hammer", "Anvil", "Grim",
		"Wulf", "Stan", "Hild", "Mæst",
		"Fyr", "Dæg", "Gold",
	)
	captain_first_names = list(
		"Wulfstan", "Godric", "Leofric", "Beorn", "Cuthwine",
		"Oswin", "Eadwulf", "Cynehelm", "Beornræd", "Deorwine",
		"Wynflæd", "Eadgyth", "Mildþryth", "Beorhtflæd", "Cyneburg",
	)
	captain_last_names = list(
		"Hammerson", "Stanforge", "Grimaxe", "Coldhammer", "Ironbeard",
		"Ætheling", "Wulfing", "se Reada", "Eorling", "Stoneward",
	)
	ship_types = list(
		list("name" = "Knarr", "tonnage" = 25, "weight" = 10),
		list("name" = "Ballinger", "tonnage" = 50, "weight" = 25),
		list("name" = "Cog", "tonnage" = 120, "weight" = 35),
		list("name" = "Hulk", "tonnage" = 250, "weight" = 20),
		list("name" = "Great Ship", "tonnage" = 700, "weight" = 10),
	)
	name_prefixes = list(
		list("text" = "Eorl ", "chance" = 4),
		list("text" = "Cyne ", "chance" = 3),
		list("text" = "the ", "chance" = 60),
	)
	city_tags = list(
		"Norwardine", "Quicksilver Hold", "Granite Fort", "Walnut Grove",
		"the Bán", "the Mountainhomes",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool = list(
		list("good" = TRADE_GOOD_COPPER_ORE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COPPER_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_STONE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_ORE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_TOPER, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CHEESE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SALUMOI, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/hammerhold/dwarven_maul,
		/datum/supply_pack/rogue/hammerhold/spiked_maul,
		/datum/supply_pack/rogue/hammerhold/longbow,
		/datum/supply_pack/rogue/hammerhold/iron_fullplate,
		/datum/supply_pack/rogue/hammerhold/snow_cloak,
		/datum/supply_pack/rogue/hammerhold/ironclad_kit,
		/datum/supply_pack/rogue/hammerhold/smoked_sausage,
		/datum/supply_pack/rogue/hammerhold/bacon,
		/datum/supply_pack/rogue/alcohol/voddena,
		/datum/supply_pack/rogue/alcohol/sazdistal,
		/datum/supply_pack/rogue/alcohol/nred,
		/datum/supply_pack/rogue/alcohol/butterhair,
		/datum/supply_pack/rogue/alcohol/stonebeard,
	)
