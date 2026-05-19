/datum/foreign_realm/lirvas
	id = REALM_LIRVAS
	name = "Lirvas"
	auto_discovered = FALSE
	roll_weight = TRADE_REALM_WEIGHT_RARE
	demanded_categories = list(ITEM_CAT_FOODSTUFF_FRESH, ITEM_CAT_FOODSTUFF_PRESERVED, ITEM_CAT_GARMENT_COMMON, ITEM_CAT_GARMENT_LUXURY, ITEM_CAT_RAW_MATERIAL_ORGANIC, ITEM_CAT_WEAPONS_DAGGERS, ITEM_CAT_ARMOR_BELTS, ITEM_CAT_WEAPONS_SHIELDS, ITEM_CAT_ARMOR_LIGHT, ITEM_CAT_SEAFOOD)
	ship_name_words = list(
		"Zarvlor", "Drak", "Aurum", "Mammon", "Debt",
		"Hoard", "Indenture", "Sissean", "Coil", "Scale",
		"Ring", "Vault", "Talon", "Wyrm", "Avarice",
	)
	captain_first_names = list(
		"Zarrak", "Hosk", "Kessith", "Slazri", "Rokzar",
		"Hralz", "Zelkar", "Vossar", "Sirhak", "Kazros",
		"Zessira", "Hsalka", "Rikzira", "Solzra", "Kazinna",
	)
	captain_last_names = list(
		"Goldscale", "Hoardkeeper", "Debtholder", "Coilmaster", "Ringclimber",
		"of-Zarvlor's Ring", "Mammonborn", "Scriphandler", "of the Topmost Ring", "Drake-Sworn",
	)
	ship_types = list(
		list("name" = "Tithebearer Cog", "tonnage" = 100, "weight" = 35),
		list("name" = "Goldscale Hulk", "tonnage" = 220, "weight" = 35),
		list("name" = "Drake Carrack", "tonnage" = 450, "weight" = 25),
		list("name" = "Hoardship", "tonnage" = 700, "weight" = 5),
	)
	city_tags = list()
	city_tag_chance = 0
	cultural_goods = list()
	bulk_supply_pool = list(
		list("good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TOPER, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_BLORTZ, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_DORPEL, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_CINNABAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_GOLD_ORE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/hcake, "qty_min" = 4, "qty_max" = 8, "price" = 26),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick/cucumber, "qty_min" = 3, "qty_max" = 6, "price" = 30),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced, "qty_min" = 3, "qty_max" = 6, "price" = 28),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pepperfish, "qty_min" = 3, "qty_max" = 6, "price" = 24),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/peppersteak, "qty_min" = 3, "qty_max" = 6, "price" = 28),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/menthacake, "qty_min" = 4, "qty_max" = 7, "price" = 24),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = 8, "qty_max" = 15, "price" = 8),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/raisinbread, "qty_min" = 4, "qty_max" = 8, "price" = 18),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/amethyst,
		/datum/supply_pack/rogue/gems/toper,
		/datum/supply_pack/rogue/gems/gemerald,
		/datum/supply_pack/rogue/gems/saffira,
		/datum/supply_pack/rogue/gems/blortz,
		/datum/supply_pack/rogue/gems/diamond,
		/datum/supply_pack/rogue/gems/jade,
		/datum/supply_pack/rogue/gems/onyxa,
		/datum/supply_pack/rogue/gems/amber,
		/datum/supply_pack/rogue/gems/opal,
		/datum/supply_pack/rogue/lirvas/tabard,
		/datum/supply_pack/rogue/lirvas/pauldrons,
		/datum/supply_pack/rogue/lirvas/gold_gorget,
		/datum/supply_pack/rogue/lirvas/gold_kilt,
		/datum/supply_pack/rogue/lirvas/gold_quarterstaff,
		/datum/supply_pack/rogue/lirvas/sabre,
		/datum/supply_pack/rogue/lirvas/tithebound_kit,
		/datum/supply_pack/rogue/alcohol/rtoper,
	)
	hail_lines = list(
		"By the Hoard and the Tithe, Factor, you have kept a faithful ledger. The scales remember.",
		"My grain is short. My gems are not. The Inner Ring sends its compliments and its hunger.",
		"Mammon weighs every transaction, friend, and Zarvlor remembers what Mammon weighs. Give honest measure - or do not, and learn the cost in a quieter season.",
		"The drakes drink deep of gold these days. We bring scales, gems, and a thirst that has never known bottom. Trade.",
		"I am Tithebound. My captain's purse is not mine; it is the Hoard's. Speak prices accordingly.",
		"A coin dropped in Lirvas takes seven years to settle. Yours, here, will be counted in heartbeats. Try to keep up.",
		"The figurehead of my ship is gold leafed over an older carving. The crew swears the under carving smiles when the lamps go out. I have stopped asking what it smiles at.",
		"You burn coin for warmth in your hearths. We do not. Sell us your grain and you will learn why.",
		"A Tithecaster of the Inner Ring rides with me, weighing souls in coin as her line has done for three generations. For one gold sovereign she will tell you the weight your sins would fetch at the Hoard's scales upon your death. She has not been wrong yet. Most of her clients do not ask twice - but those who heed her have died well, and the Hoard remembers a settled debt before it remembers any other thing.",
		"Rumors says that Lord Zarvlor does not eat proper food and only eat gold. Do not let that deters you, the people of the Inner Ring are quite fond of Azurian seafood. Send me anything and everything you have that is quality and worth the space of runic chests home."
	)
