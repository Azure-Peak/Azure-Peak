/datum/foreign_realm/naledi
	id = REALM_NALEDI
	name = "Naledi"
	auto_discovered = FALSE
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	ship_name_words = list(
		"Psydon", "Bilomari", "Veralun", "Olindar", "Veranda",
		"Repentance", "Mercy", "Vigil", "Pilgrim", "Endurance",
		"Bluebell", "Ocotillo", "Lily", "Ember", "Lantern",
	)
	captain_first_names = list(
		"Arindele", "Nasir", "Tariq", "Yusuf", "Kamau",
		"Jelani", "Hamadi", "Bashir", "Faraj", "Idris",
		"Amalara", "Selima", "Yusra", "Amara", "Nadira",
	)
	captain_last_names = list(
		"Arivale", "Ndalasi", "al-Veranda", "Bilomari", "Olindari",
		"Kamenji", "Ravalan", "Tessanda", "ibn-Asari", "Veshani",
	)
	ship_types = list(
		list("name" = "Dhow", "tonnage" = 60, "weight" = 30),
		list("name" = "Baghlah", "tonnage" = 180, "weight" = 35),
		list("name" = "Sand-Galley", "tonnage" = 350, "weight" = 20),
		list("name" = "Gilded Carrack", "tonnage" = 600, "weight" = 15),
	)
	name_prefixes = list(
		list("text" = "Shah ", "chance" = 8),
		list("text" = "the ", "chance" = 10),
	)
	city_tags = list(
		"Veralun", "Olindar", "Veranda", "the Glass Dunes",
	)
	city_tag_chance = 35
	cultural_goods = list()
	bulk_supply_pool = list(
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_GLASS_BATCH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_GOLD_ORE, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_CINNABAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_TOPER, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_BLORTZ, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool = list(
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_STONE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_TIN_ORE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_COPPER_ORE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SALUMOI, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/merc_weapons/shamshir,
		/datum/supply_pack/rogue/merc_weapons/naledistaff,
		/datum/supply_pack/rogue/steel_weapons/katar,
		/datum/supply_pack/rogue/naledi/hierophant_kit,
		/datum/supply_pack/rogue/naledi/psicross,
		/datum/supply_pack/rogue/naledi/lordmask,
		/datum/supply_pack/rogue/naledi/pashmina,
		/datum/supply_pack/rogue/naledi/sandals,
		/datum/supply_pack/rogue/naledi/treatise,
		/datum/supply_pack/rogue/naledi/glassen_decanters,
		/datum/supply_pack/rogue/naledi/glass_statue,
		/datum/supply_pack/rogue/naledi/gold_finery,
	)
