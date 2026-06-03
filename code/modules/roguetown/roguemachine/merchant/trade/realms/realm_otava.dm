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
		"Salutations, factor. Saint-Astrata watch over honest weights, Sainte-Necra over dishonest ones - I leave the choice to you.",
		"Notre Dieu qui es aux cieux - sauvez-les, s'il vous plaitez. The crossing was kind, the wind devout, and the chaplain less seasick than usual. Ayat.",
		"In the name of the Ten, by writ of the High Council at Esperance-Capitale, I come to barter. My wine is from the País-Occitanie - do not insult it with a low offer.",
		"I am no pirate, monsieur. I have papers, a chaplain, and a spouse in Verquent - that last being the most expensive of the three.",
		"Cheese from Falaises-Rouges, wines from Val-du-Lac, smoked fish from Vallouise-sur-Mer. The Accords entitles me to fair price on all three. Pay accordingly.",
		"Bring out your iron and your hides. My hold has room and my purse has coin, and the tide does not wait on civility.",
		"The cliffs of Falaises-Rouges were red with sunset when we set out. An omen, the chaplain refused to interpret. I have not asked again.",
		"My cousin lost his ship to your reefs two summers past. I have brought a token of Sainte-Necra to drop in the harbor before we tie up. Do not be offended; it is custom.",
		"By Sainte-Abyssor, the wind was merciful. Let us see if your Crown's tariff is the same.",
		"My helmsman served three yils with the militari-du-pais before turning to honest trade. He has the patience of a saint and the temper of a saigaback lancer - test only the first.",
		"The Inquisition has an Office outside Kingsfield, factor. I am not of their detachment, but I am known to their Magistrate. Trade fairly; word travels back to Otava as quickly as my ship does.",
		"I sailed past the pilgrim road from Vates to the Ranesheni dunes. Three priests boarded at Verquent, three priests disembarked at Mücevkabher. None of them spoke to me. Holy folk are like that.",
		"For three zennies, my Routier-corporal will guard your shipment from gangway to warehouse, bonded by writ and blessed by the Red Priests of Noireau. He is the last of his company; the rest fell in the Pais-Occitanie wars. Engage him before he takes his pension at Verquent and his sword goes to the abbey wall, where it will not see use again.",
		"A passenger from Pais-Occitanie has been staring at the same patch of water since we sighted your cliffs. Take them ashore quickly - I will not have them die in my cabin.",
		"A masked Confessor sailed with me from Vallouise. I asked no questions; they paid in full and disembarked at first light without a word. I record their fare as 'goods, unspecified.' I trust you will record their passage the same.",
		"Sole in white wine for the Inquisition and the Royalty of Otava. Do not haggle, Factor."
	)
