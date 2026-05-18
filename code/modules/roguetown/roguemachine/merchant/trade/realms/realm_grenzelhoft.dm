/datum/foreign_realm/grenzelhoft
	id = REALM_GRENZELHOFT
	name = "Grenzelhoft"
	auto_discovered = TRUE
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	demanded_categories = list(ITEM_CAT_REAGENT_ARCANE, ITEM_CAT_BOOK_WRIT, ITEM_CAT_FOODSTUFF_FRESH, ITEM_CAT_GARMENT_LUXURY, ITEM_CAT_ARCYNE_GEARS, ITEM_CAT_POTION)
	ship_name_words = list(
		"Eisernen", "Sturm", "Adler", "Wolf", "Drache",
		"Schwert", "Bruder", "Krone", "Burg", "Wappen",
		"Hammer", "Nordlicht", "Falken", "Reiter", "Greif",
	)
	captain_first_names = list(
		"Heinrich", "Konrad", "Dietrich", "Ulrich", "Gerhard",
		"Hartmann", "Albrecht", "Reinhart", "Hermann", "Sigmund",
		"Adelheid", "Mechthild", "Hedwig", "Irmgard", "Kunigunde",
	)
	captain_last_names = list(
		"Faber", "Krummhorn", "Wolfsbein", "Hartwald", "von Apfelweinheim",
		"Eisenberg", "Falkenried", "Sturmwacht", "von Zenitstadt", "von Hochburg",
	)
	ship_types = list(
		list("name" = "Coaster", "tonnage" = 30, "weight" = 15),
		list("name" = "Cog", "tonnage" = 120, "weight" = 50),
		list("name" = "Hulk", "tonnage" = 250, "weight" = 25),
		list("name" = "Carrack", "tonnage" = 500, "weight" = 10),
	)
	city_tags = list(
		"Apfelweinheim", "Zenitstadt", "Eisenhafen", "Silbergrund",
		"Hochburg", "Sterneberg", "Sankt Averial",
	)
	city_tag_chance = 35
	cultural_goods = list()
	bulk_supply_pool = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR, "always" = TRUE),
		list("good" = TRADE_GOOD_CHEESE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_BUTTER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool = list(
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_CLAY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bun_grenz, "qty_min" = 5, "qty_max" = 10, "price" = 18),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/cheesebun, "qty_min" = 4, "qty_max" = 8, "price" = 16),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/sandwich/salami, "qty_min" = 4, "qty_max" = 8, "price" = 22),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/sandwich/cheese, "qty_min" = 4, "qty_max" = 8, "price" = 18),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon, "qty_min" = 3, "qty_max" = 6, "price" = 20),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast, "qty_min" = 3, "qty_max" = 6, "price" = 28),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/raisinbread, "qty_min" = 4, "qty_max" = 7, "price" = 22),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = 8, "qty_max" = 15, "price" = 8),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked, "qty_min" = 5, "qty_max" = 10, "price" = 14),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bread, "qty_min" = 5, "qty_max" = 10, "price" = 12),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/merc_weapons/grenzelstaff,
		/datum/supply_pack/rogue/grenzelhoft/zweihander,
		/datum/supply_pack/rogue/grenzelhoft/kriegmesser,
		/datum/supply_pack/rogue/grenzelhoft/halberd,
		/datum/supply_pack/rogue/grenzelhoft/partizan,
		/datum/supply_pack/rogue/grenzelhoft/seax,
		/datum/supply_pack/rogue/grenzelhoft/kampfmesser,
		/datum/supply_pack/rogue/grenzelhoft/blacksteel_cuirass,
		/datum/supply_pack/rogue/grenzelhoft/heavy_gambeson,
		/datum/supply_pack/rogue/grenzelhoft/plumed_hat,
		/datum/supply_pack/rogue/grenzelhoft/boots,
		/datum/supply_pack/rogue/grenzelhoft/gloves,
		/datum/supply_pack/rogue/grenzelhoft/pants,
		/datum/supply_pack/rogue/grenzelhoft/merc_tabard,
		/datum/supply_pack/rogue/grenzelhoft/magos_mantle,
		/datum/supply_pack/rogue/grenzelhoft/siegebow,
		/datum/supply_pack/rogue/grenzelhoft/heavy_bolts,
		/datum/supply_pack/rogue/grenzelhoft/almain_rivet,
		/datum/supply_pack/rogue/grenzelhoft/coppiette,
		/datum/supply_pack/rogue/grenzelhoft/salami,
		/datum/supply_pack/rogue/grenzelhoft/hardybread,
		/datum/supply_pack/rogue/alcohol/grenzelbeer,
		/datum/supply_pack/rogue/alcohol/winegrenzel,
		/datum/supply_pack/rogue/alcohol/apfelweinheim,
		/datum/supply_pack/rogue/alcohol/jagdtrunk,
		/datum/supply_pack/rogue/alcohol/beer,
		/datum/supply_pack/rogue/alcohol/blackgoat,
		/datum/supply_pack/rogue/alcohol/zagul,
		/datum/supply_pack/rogue/alcohol/onin,
	)
	hail_lines = list(
		"Factor! Have my dues counted in silver, not promises. I sail at the first ebb whether you are ready or not.",
		"Grain from Apfelweinheim, ingots from the foundries of New Celestia. Bring buyers, not browsers.",
		"By the Eleven Cathedrals, my ledgers are honest. See that yours match - the See takes a dim view of cheats, and so do I.",
		"My crew has held mass on every sunsdae of the crossing. We are devout, well-fed, and patient. Two of these three I have brought with me. The third I do not promise.",
		"I want clay, silk, and tangerines. Send anyone who has them to the gangway. Send no one else.",
		"The Crown's tariff is a thief in Astrata's clothing, but I have paid worse. Stamp my papers and let us be done.",
		"A registered magos of the Celestial Academy travels in my aft cabin. His papers are in order, his stipend is paid. Do not detain him; the Emperor's Magi take it personally.",
		"My zweihanders fetch good coin south. I do not care which lord buys them so long as he is not Hammerhold or Gronnic. Verify the purse and verify the flag.",
		"I hold a condotta for three Condottieri companies bound for service abroad. Their pay is sealed under church wax. Do not break the seal; the chaplain watches.",
		"A burgher of Zenitstadt rode with us this voyage and would not stop weeping and vomiting at the masthead. He has paid his fare. I make no apology for him.",
		"You will find my prices fair and my temper short. Do not test the second to bargain the first.",
		"I sailed with one captive raider of the Gronnic coast in chains below decks for the crossing. He is delivered to your magistrate, alive, as the compact requires. Now my real cargo - grain.",
	)
