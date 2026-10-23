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

		"The FINEST bitters and wines from Etrusca! Have any sea-food of your own? My first-mate is craving some Azurian clams...",

		"Need any hire hands? I've got saigas and their vaquero riders on my ship. Fine blades... just don't question their past.",

		"Fancy any marksmen? I've got Condottieri on board! Rowdy, but the most accurate bastards in Etrusca. Pay them in zenar, \
		good wines, or some company. I hear the Peak has an abundance of the latter!",

		"Buy and sell something swell, factor. Abyssor must be stirring, we lost two deckhands to a water spout half-way here.",

		"Ever had chocolate? We'll trade you for some produce.",
	)
