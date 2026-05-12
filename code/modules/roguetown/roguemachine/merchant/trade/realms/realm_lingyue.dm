/datum/foreign_realm/lingyue
	id = REALM_LINGYUE
	name = "Lingyue"
	auto_discovered = FALSE
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	ship_name_words = list(
		"Tianxia", "Fenghuang", "Qilin", "Longwang", "Yuanzhao",
		"Jinqi", "Lingfeng", "Yunhai", "Shanhe", "Chunqiu",
		"Mingyue", "Jianghai", "Tianlong", "Beidou", "Wanli",
	)
	captain_first_names = list(
		"Yunxu", "Tianqi", "Jingming", "Yuanzheng", "Tianyou",
		"Hean", "Yunshu", "Tianlin", "Mingzhao", "Jingwei",
		"Yunzhi", "Mingxia", "Lianhua", "Xiulan", "Chunhua",
	)
	captain_last_names = list(
		"Zou", "Su", "Lei", "Yun", "Shan",
		"Meng", "Jiang", "Mu", "Han", "Tang",
	)
	ship_types = list(
		list("name" = "Junk", "tonnage" = 80, "weight" = 20),
		list("name" = "War Junk", "tonnage" = 200, "weight" = 30),
		list("name" = "Treasure Ship", "tonnage" = 500, "weight" = 30),
		list("name" = "Imperial Treasure Ship", "tonnage" = 800, "weight" = 20),
	)
	city_tags = list()
	city_tag_chance = 0
	cultural_goods = list()
	bulk_supply_pool = list(
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_CINNABAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_PLUM, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GOLD_ORE, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool = list(
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CLAY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_ENCHSCROLL_BASIC, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/lingyue/wodao,
		/datum/supply_pack/rogue/lingyue/dadao,
		/datum/supply_pack/rogue/lingyue/greatdadao,
		/datum/supply_pack/rogue/merc_weapons/glaive,
		/datum/supply_pack/rogue/luxury/fancyteaset,
		/datum/supply_pack/rogue/alcohol/zhonghuangjiu,
		/datum/supply_pack/rogue/alcohol/baijiu,
		/datum/supply_pack/rogue/alcohol/yaojiu,
		/datum/supply_pack/rogue/alcohol/shejiu,
		/datum/supply_pack/rogue/drugs/whipwine,
		/datum/supply_pack/rogue/alcohol/truewhipwine,
	)
