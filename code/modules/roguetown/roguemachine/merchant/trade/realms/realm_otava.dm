/datum/foreign_realm/otava
	id = REALM_OTAVA
	name = "Otava"
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	demanded_categories = list(NAVIGATOR_BUCKET_POTIONS_REAGENTS, NAVIGATOR_BUCKET_INSTRUMENTS, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_VALUABLES_LOOTED, NAVIGATOR_BUCKET_CARVED, NAVIGATOR_BUCKET_TROPHIES, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_MISCELLANEOUS)
	single_word_base = TRUE
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
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_CHEESE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_DRIED_FISH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_COD, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_STRAWBERRY, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_PLUM, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_FAIR, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CABBAGE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_PEAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_BUTTER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/peppersteak, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FEAST),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FEAST),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/apple, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/buttersole, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/applecake, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bun_raston, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/jack_wine),
		list("recipe" = /datum/brewing_recipe/cider),
		list("recipe" = /datum/brewing_recipe/aqua_vitae),
		list("recipe" = /datum/brewing_recipe/brandy/pear),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/amber,
		/datum/supply_pack/rogue/gems/rose,
		/datum/supply_pack/rogue/food/rosa,
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
	hail_lines = list(
		"Last time I docked, your Factor accused me of cheating them on my weight. I swear by Psydon I'm honest merchant and if your men mistreat me again, I will be complaining to the Otavais Inquisition!",
		"I have the finest wine from País-Occitanie, fit for consumption by royalty.",
		"Notre Dieu, Qui Es Aux Cieux! Sauvez-Les, S'il Vous Plaitez. Oh. The SCOM was on.",
		"I need sole in white wines for the royalties of Otava. Please make haste."
	)
