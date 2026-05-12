/datum/foreign_realm/raneshen
	id = REALM_RANESHEN
	name = "Raneshen"
	auto_discovered = TRUE
	roll_weight = TRADE_REALM_WEIGHT_DEFAULT
	ship_name_words = list(
		"Thalassa", "Abyssoros", "Khimaira", "Eos", "Aetos",
		"Astrateios", "Anemos", "Galene", "Drakon", "Pelagos",
		"Astraios", "Noctaios", "Korax", "Boreas", "Aigle",
	)
	captain_first_names = list(
		"Eumelos", "Kallias", "Damaskios", "Hieron", "Polyphron",
		"Andronikos", "Doros", "Aram", "Vartan", "Niyaz",
		"Helike", "Anthousa", "Korinna", "Astrateia", "Nairi",
	)
	captain_last_names = list(
		"Khariotes", "Pelasgos", "Anaktor", "Phaleron", "Abyssoreios",
		"of Chorodiaki", "Vrdaqnani", "Nshkor", "Müccevbey", "Sayyari",
	)
	ship_types = list(
		list("name" = "Akation", "tonnage" = 40, "weight" = 15),
		list("name" = "Dromon", "tonnage" = 130, "weight" = 35),
		list("name" = "Bireme", "tonnage" = 300, "weight" = 30),
		list("name" = "Pamphylos", "tonnage" = 600, "weight" = 20),
	)
	city_tags = list(
		"Raneshan", "Chorodiaki", "Müccevkabher", "Nshkormh", "Vrdaqnan",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool = list(
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GLASS_BATCH, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GARLICK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool = list(
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/raneshen/janissary_kit,
		/datum/supply_pack/rogue/raneshen/desert_rider_kit,
		/datum/supply_pack/rogue/raneshen/megarmach_coat,
		/datum/supply_pack/rogue/raneshen/tower_shield,
		/datum/supply_pack/rogue/raneshen/shamshir,
		/datum/supply_pack/rogue/raneshen/shalal_saber,
		/datum/supply_pack/rogue/raneshen/navaja,
		/datum/supply_pack/rogue/raneshen/grand_mace,
		/datum/supply_pack/rogue/raneshen/spear,
		/datum/supply_pack/rogue/raneshen/whip,
		/datum/supply_pack/rogue/raneshen/recurve_bow,
		/datum/supply_pack/rogue/raneshen/javelins,
		/datum/supply_pack/rogue/raneshen/headscarf,
		/datum/supply_pack/rogue/raneshen/shalal_hood,
		/datum/supply_pack/rogue/raneshen/shalal_scarf,
		/datum/supply_pack/rogue/raneshen/copper_gorget,
		/datum/supply_pack/rogue/raneshen/copper_facemask,
		/datum/supply_pack/rogue/raneshen/copper_bracers,
		/datum/supply_pack/rogue/raneshen/pontifex_trou,
		/datum/supply_pack/rogue/raneshen/shalal_slippers,
		/datum/supply_pack/rogue/raneshen/shalal_belt,
		/datum/supply_pack/rogue/alcohol/wineraneshen,
	)
