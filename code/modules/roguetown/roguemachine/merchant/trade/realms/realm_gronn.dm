/datum/foreign_realm/gronn
	id = REALM_GRONN
	name = "Gronn"
	auto_discovered = FALSE
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	ship_name_words = list(
		"Fjord", "Iskarn", "Volf", "Beorn", "Ravn",
		"Skuld", "Storm", "Aurora", "Glacier", "Ulfr",
		"Drage", "Frosti", "Hrim", "Norn", "Saiga",
	)
	captain_first_names = list(
		"Oarri", "Niillas", "Aslak", "Mikkel", "Ánte",
		"Heaika", "Sammol", "Ivvár", "Biera", "Hánsa",
		"Risten", "Máret", "Elle", "Sárá", "Inga",
	)
	captain_last_names = list(
		"Iskarn", "Volfsson", "Saigahorn", "Glacierborn", "Stormbringer",
		"Ravnstrid", "Frostbearer", "Drageaette", "Norrsker", "Hrimskogr",
	)
	ship_types = list(
		list("name" = "Knarr", "tonnage" = 30, "weight" = 15),
		list("name" = "Longship", "tonnage" = 80, "weight" = 30),
		list("name" = "Icebreaker Hulk", "tonnage" = 200, "weight" = 30),
		list("name" = "Great Drakkar", "tonnage" = 400, "weight" = 20),
		list("name" = "Fenrir", "tonnage" = 700, "weight" = 5),
	)
	city_tags = list(
		"the Fjall", "Iskarn-By", "Volfshaven", "Saigahold",
		"Ravnskar",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool = list(
		list("good" = TRADE_GOOD_IRON_ORE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_MEAT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_PORK, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_VISCERA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool = list(
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_GARLICK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CALENDULA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_POPPY, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/merc_weapons/beardedaxe,
		/datum/supply_pack/rogue/merc_weapons/handclaw_iron,
		/datum/supply_pack/rogue/merc_weapons/handclaw_steel,
		/datum/supply_pack/rogue/gronn/battleaxe,
		/datum/supply_pack/rogue/gronn/owl_helmet,
		/datum/supply_pack/rogue/gronn/moose_hood,
		/datum/supply_pack/rogue/gronn/varangian_hauberk,
		/datum/supply_pack/rogue/gronn/shamanic_coat,
		/datum/supply_pack/rogue/gronn/kite_shield,
		/datum/supply_pack/rogue/gronn/fur_gloves,
		/datum/supply_pack/rogue/gronn/bone_gloves,
		/datum/supply_pack/rogue/gronn/beast_claws,
		/datum/supply_pack/rogue/gronn/fur_pants,
		/datum/supply_pack/rogue/gronn/leather_boots,
		/datum/supply_pack/rogue/gronn/atgervi_kit,
		/datum/supply_pack/rogue/gronn/iskarn_kit,
		/datum/supply_pack/rogue/gronn/spider_honey,
		/datum/supply_pack/rogue/gronn/cured_megafauna,
		/datum/supply_pack/rogue/gronn/gronnic_norsii_plate,
		/datum/supply_pack/rogue/gronn/gronnic_norsii_helm,
		/datum/supply_pack/rogue/gronn/gronnic_brigandine,
		/datum/supply_pack/rogue/gronn/norsii_kit,
		/datum/supply_pack/rogue/alcohol/gronnmead,
	)
