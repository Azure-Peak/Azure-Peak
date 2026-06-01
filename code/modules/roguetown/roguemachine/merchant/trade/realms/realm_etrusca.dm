/datum/foreign_realm/etrusca
	id = REALM_ETRUSCA
	name = "Etrusca"
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_HEAVY, NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_VALUABLES_LOOTED, NAVIGATOR_BUCKET_CARVED, NAVIGATOR_BUCKET_TROPHIES, NAVIGATOR_BUCKET_INSTRUMENTS, NAVIGATOR_BUCKET_MISCELLANEOUS)
	ship_name_words = list(
		"Aurelia", "Mirella", "Esperanza", "Fortuna", "Vittoria",
		"Stella", "Corona", "Leone", "Tormenta", "Onore",
		"Armada", "Caravelle", "Sirena", "Falco", "Orso",
	)
	captain_first_names = list(
		"Rodrigo", "Esteban", "Lorenzo", "Diego", "Matteo",
		"Cesare", "Alvaro", "Hernando", "Salvatore", "Vincenzo",
		"Isabela", "Catalina", "Bianca", "Elena", "Lucrezia",
	)
	captain_last_names = list(
		"Zaragoza", "del Mar", "Velasquez", "Aldobrandi", "Cortes",
		"di Montecarina", "de Navarno", "Vellano", "Castellanos", "Lazaretto",
	)
	ship_types = list(
		list("name" = "Caravel", "tonnage" = 70, "weight" = 25),
		list("name" = "Galleon", "tonnage" = 200, "weight" = 35),
		list("name" = "Carrack", "tonnage" = 400, "weight" = 25),
		list("name" = "Armada Galleon", "tonnage" = 700, "weight" = 15),
	)
	name_prefixes = list(
		list("text" = "Don ", "chance" = 5, "requires_proper_name" = FALSE),
		list("text" = "Santa ", "chance" = 10),
	)
	city_tags = list(
		"Gran Zafiro", "Porto del Re", "Portosegreto", "San Vellano",
		"Santa Mirella", "Marenova", "Velasca", "Portavigna",
		"San Rodrigo", "Santa Aurelia", "Puerto Leon", "Miralago",
		"Montejaral", "Alcazora",
	)
	city_tag_chance = 35
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_FISH_FILET, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_DRIED_FISH, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_LIME, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GARLICK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_TOMATO, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_EGGPLANT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_APPLE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_BLACKBERRY, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/tomatoplate, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meattomatoplate, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/fishtomatoplate, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/crab, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffedcheese, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/ccake, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/cheesebun, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/applebread, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/beer, "keg_mult" = 2),
		list("recipe" = /datum/brewing_recipe/brandy/plum),
		list("recipe" = /datum/brewing_recipe/brandy),
		list("recipe" = /datum/brewing_recipe/rum),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/coral,
		/datum/supply_pack/rogue/gems/rose,
		/datum/supply_pack/rogue/food/sugar,
		/datum/supply_pack/rogue/food/chocolate,
		/datum/supply_pack/rogue/merc_weapons/etruscanlongsword,
		/datum/supply_pack/rogue/merc_weapons/erapier,
		/datum/supply_pack/rogue/merc_weapons/navaja,
		/datum/supply_pack/rogue/merc_weapons/saildagger,
		/datum/supply_pack/rogue/etrusca/falchion,
		/datum/supply_pack/rogue/etrusca/crossbow,
		/datum/supply_pack/rogue/etrusca/heavy_bolts,
		/datum/supply_pack/rogue/etrusca/pike,
		/datum/supply_pack/rogue/etrusca/etruscan_bascinet,
		/datum/supply_pack/rogue/etrusca/condottieri_kit,
		/datum/supply_pack/rogue/etrusca/vaquero_kit,
		/datum/supply_pack/rogue/etrusca/jamon,
		/datum/supply_pack/rogue/etrusca/coppiette,
		/datum/supply_pack/rogue/etrusca/salami,
		/datum/supply_pack/rogue/etrusca/cheese,
		/datum/supply_pack/rogue/etrusca/vaquero_ring,
		/datum/supply_pack/rogue/alcohol/limoncello,
		/datum/supply_pack/rogue/alcohol/winevalorred,
		/datum/supply_pack/rogue/alcohol/winevalorwhite,
		/datum/supply_pack/rogue/alcohol/wineraneshen,
		/datum/supply_pack/rogue/alcohol/beer,
	)
	hail_lines = list(
		"Ah, the Azurian shore at last! Por favor, have my tariff men ready - I am not a patient man when the sun is high.",
		"By Abissoro, we have crossed two storms to reach this pier. I trust your purse is as wide as my hold.",
		"Greetings, signore. My wine is the best in Psydonia, and my crew has been told not to spit on your stones. See that you give them no reason.",
		"My chaplain has held sermon every sunsdae since we cleared Porto del Re. Ravox watches over honest weights at this gangway - bear that in mind.",
		"Gran Zafiro sends greetings under the seal of House Zaragoza. My hold sends lemons. Take both with the respect they are owed.",
		"I sailed from the southern isle, signore - Montecarina born, navy trained, no smuggler. Should any Navarno cousin tell you otherwise upon making port, do not believe them.",
		"Open the chain and have a notary at the gangway. I trade in coin, not in promises - Heathen temptations have ruined cleaner pursers than yours.",
		"Salve. I have lemons enough to drown your fevers and salt enough to bury your dead - which would you like first?",
		"My cousin sailed this run last spring and was paid in clipped coin. I will be weighing every piece.",
		"A Vaquero of the Montejaral hills rides with us, returning from a contract abroad. The crown calls him outlaw. My grandfather called him kin. Treat him as the latter and we will have no quarrel.",
		"I carry a Condottieri captain bound for sellsword work in Otavan service. His arms are stowed, his crossbow is oiled, and his pay is none of our concern until we make port.",
		"The crossing was kind. The Factor, I am told, is less so. Let us see if both rumors hold.",
		"A priest aboard swears the figurehead wept blood off the Bleak Coast. I have him locked in the hold. Buy quickly so I may sail before the rest of the crew gets ideas.",
		"My second cousin Federico travels with the cargo. He is - how shall I put this - acquainted with men who can move things quietly and quickly between Porto del Re and your Goldface, when official channels prove inconvenient. His fee is modest. His memory is shorter. Ask for him by name and not by trade, signore.",
	)
