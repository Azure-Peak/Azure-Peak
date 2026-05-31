/datum/foreign_realm/aavnr
	id = REALM_AAVNR
	name = "Aavnr"
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_LIGHT, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_POTTERY, NAVIGATOR_BUCKET_VALUABLES_LOOTED, NAVIGATOR_BUCKET_MISCELLANEOUS)
	ship_name_words = list(
		"Yarlsnik", "Koprivka", "Diethelm", "Tomorzh", "Khairin",
		"Wardenpact", "Hetman", "Saiga", "Bloodaxe", "Ironmask",
		"Potentate", "Astrava", "Ravox", "Zogiin", "Hussar",
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
		list("name" = "Aavnic Galley", "tonnage" = 250, "weight" = 25),
		list("name" = "Potentate Hulk", "tonnage" = 500, "weight" = 15),
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
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_DRIED_FISH, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_MEAT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_CLAM, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR, "always" = TRUE),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GLASS_BATCH, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/cod, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/alecod, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pepperlobsta, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bread, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/mead),
		list("recipe" = /datum/brewing_recipe/jack_wine),
		list("recipe" = /datum/brewing_recipe/voddena),
		list("recipe" = /datum/brewing_recipe/winespiced),
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
	hail_lines = list(
		"Greetings, Factor. Hide, grain, fish and fur. Of the finest quality from the Steppes of Aavnr. Bring me silk and gemerald or do not bring me anything at all.",
		"The Hetman of Tomorzurkh sends his regards and his demand for lemons. The second is not optional.",
		"My crossing was peaceful. The four crossings before were not. I would speak to your Bleakisles watch about that.",
		"Trade quickly, friend. The steppes do not wait, and neither do the wolves on my home road.",
		"A saiga priest of Dalainkhair is in my hold blessing the cargo. He will not come out. He has been there three days. The cargo seems content.",
		"The saiga milk is for selling, not for drinking on duty. Tell your stevedores. I have already told mine.",
		"The Potentate weighs heavy on the keel and heavier on my purse. Lighten one and the other follows.",
		"A saiga-binder of the Astrava-line rides with me, last of his teaching. For two zennies he will lay hands on a fogbeast and the creature will know your name without it ever being told. He sails because his sons cannot learn what he knows, and the line will end with him on this voyage or the next. Pay him while you can.",
		"Pickled herrings for the sons and daughters of the steppes. Mare's milk and saiga sausage are great, but our warriors do like to have something foreign to chew on on their march."
	)
