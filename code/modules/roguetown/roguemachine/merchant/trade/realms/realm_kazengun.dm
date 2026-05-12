/datum/foreign_realm/kazengun
	id = REALM_KAZENGUN
	name = "Kazengun"
	auto_discovered = FALSE
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	single_word_base = TRUE
	ship_name_words = list(
		"Tsuru", "Hayabusa", "Akatsuki", "Tsuki", "Ame",
		"Sora", "Kaze", "Yume", "Hoshi", "Suzu",
		"Sakura", "Take", "Yuki", "Nami",
	)
	captain_first_names = list(
		"Masakatsu", "Yoshitaka", "Kagetora", "Tadanaga", "Hidemori",
		"Naomasa", "Tomoe", "Kaoruko", "Chiyo", "Sen",
		"Kikyō", "Tsuneyori", "Sadanobu", "Harukage", "Yorinaga",
	)
	captain_last_names = list(
		"Niwa", "Sakuma", "Kasai", "Asakura", "Andō",
		"Kurogane", "Yamashiro", "Tsukinami", "Koganei", "Akizuki",
	)
	ship_types = list(
		list("name" = "Sekibune", "tonnage" = 90, "weight" = 35),
		list("name" = "Bezaisen", "tonnage" = 120, "weight" = 40),
		list("name" = "Shuinsen", "tonnage" = 400, "weight" = 15),
		list("name" = "Atakebune", "tonnage" = 600, "weight" = 10),
	)
	name_suffixes = list(
		list("text" = "-Maru", "chance" = 75),
	)
	city_tags = list(
		"Iwoto", "Tamiro", "Kukui", "Matsuhama", "Aisataiji",
		"Bijai", "Mitihara", "Tatseshira",
	)
	city_tag_chance = 30
	city_tag_format = "of %CITY%"
	cultural_goods = list()
	bulk_supply_pool = list(
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GOLD_ORE, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_CINNABAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool = list(
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_CLAY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/merc_weapons/katana,
		/datum/supply_pack/rogue/merc_weapons/naginata,
		/datum/supply_pack/rogue/merc_weapons/kazengunhookblade,
		/datum/supply_pack/rogue/merc_weapons/kazengunkodachi,
		/datum/supply_pack/rogue/merc_weapons/kazenguntanto,
		/datum/supply_pack/rogue/merc_weapons/kazengunscabbard,
		/datum/supply_pack/rogue/kazengun/kanabo,
		/datum/supply_pack/rogue/kazengun/ssangsudo,
		/datum/supply_pack/rogue/kazengun/samsibsa,
		/datum/supply_pack/rogue/kazengun/haraate,
		/datum/supply_pack/rogue/kazengun/kabuto,
		/datum/supply_pack/rogue/kazengun/jingasa,
		/datum/supply_pack/rogue/kazengun/mask_full,
		/datum/supply_pack/rogue/kazengun/mask_half,
		/datum/supply_pack/rogue/kazengun/cloak,
		/datum/supply_pack/rogue/kazengun/shirt_black,
		/datum/supply_pack/rogue/kazengun/shirt_white,
		/datum/supply_pack/rogue/kazengun/captainrobe,
		/datum/supply_pack/rogue/kazengun/rice_shrimp,
		/datum/supply_pack/rogue/kazengun/gorget,
		/datum/supply_pack/rogue/kazengun/kote,
		/datum/supply_pack/rogue/kazengun/boots,
		/datum/supply_pack/rogue/kazengun/trousers,
		/datum/supply_pack/rogue/kazengun/chonin_kit,
		/datum/supply_pack/rogue/kazengun/kouken_kit,
		/datum/supply_pack/rogue/luxury/fancyteaset,
		/datum/supply_pack/rogue/alcohol/kgunlager,
		/datum/supply_pack/rogue/alcohol/kgunplum,
		/datum/supply_pack/rogue/alcohol/kgunsake,
		/datum/supply_pack/rogue/alcohol/kgunshochu,
	)
