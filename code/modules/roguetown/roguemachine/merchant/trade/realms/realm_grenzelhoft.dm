/datum/foreign_realm/grenzelhoft
	id = REALM_GRENZELHOFT
	name = "Grenzelhoft"
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	demanded_categories = list(NAVIGATOR_BUCKET_POTIONS_REAGENTS, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_CARVED, NAVIGATOR_BUCKET_POTTERY, NAVIGATOR_BUCKET_MISCELLANEOUS)
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
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR, "always" = TRUE),
		list("good" = TRADE_GOOD_CHEESE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_BUTTER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR, "always" = TRUE),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_CLAY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bun_grenz, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/cheesebun, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/sandwich/salami, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/sandwich/cheese, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/raisinbread, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bread, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/beer),
		list("recipe" = /datum/brewing_recipe/jack_wine),
		list("recipe" = /datum/brewing_recipe/cider),
		list("recipe" = /datum/brewing_recipe/aqua_vitae),
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
		"Give me smoked eels by the barrel. Unjellied, please, that thing is an abomination upon humenity. I've heard the Celestial Academy's students have gotten tired of eating salmon everydaes. So eels from your river would be a nice change of pace."	
	)
