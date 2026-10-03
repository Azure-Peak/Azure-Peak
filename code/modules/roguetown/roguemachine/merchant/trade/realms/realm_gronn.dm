/datum/foreign_realm/gronn
	id = REALM_GRONN
	name = "Gronn"
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_HEAVY, NAVIGATOR_BUCKET_POTTERY, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_TOOLS, NAVIGATOR_BUCKET_MISCELLANEOUS)
	ship_name_words = list(
		"Fjord", "Iskarn", "Volf", "Beorn", "Ravn",
		"Skuld", "Storm", "Aurora", "Glacier", "Ulfr",
		"Drage", "Frosti", "Hrim", "Norn", "Saiga",
	)
	captain_first_names = list(
		"Oarri", "Niillas", "Aslak", "Mikkel", "Ánte",
		"Heaika", "Sammol", "Ivvár", "Biera", "Hánsa",
		"Risten", "Máret", "Elle", "Sárá", "Inga",
	)
	captain_last_names = list(
		"Iskarn", "Volfsson", "Saigahorn", "Glacierborn", "Stormbringer",
		"Ravnstrid", "Frostbearer", "Drageaette", "Norrsker", "Hrimskogr",
	)
	ship_types = list(
		list("name" = "Knarr", "tonnage" = 30, "weight" = 15),
		list("name" = "Longship", "tonnage" = 80, "weight" = 30),
		list("name" = "Icebreaker Hulk", "tonnage" = 200, "weight" = 30),
		list("name" = "Great Drakkar", "tonnage" = 400, "weight" = 20),
		list("name" = "Fenrir", "tonnage" = 700, "weight" = 5),
	)
	city_tags = list(
		"the Fjall", "Iskarn-By", "Volfshaven", "Saigahold",
		"Ravnskar",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_IRON_ORE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_MEAT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_PORK, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_VISCERA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_GARLICK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CALENDULA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_POPPY, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM),
		list("good" = TRADE_GOOD_BUTTER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CABBAGE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_ROCKNUT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/bear/fried, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FEAST),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/wolf/fried, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/rat/fried, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/mead, "keg_mult" = 3),
		list("recipe" = /datum/brewing_recipe/spidermead),
		list("recipe" = /datum/brewing_recipe/voddena),
		list("recipe" = /datum/brewing_recipe/fermentedcrab),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/food/honey,
		/datum/supply_pack/rogue/merc_weapons/beardedaxe,
		/datum/supply_pack/rogue/merc_weapons/handclaw_iron,
		/datum/supply_pack/rogue/merc_weapons/handclaw_steel,
		/datum/supply_pack/rogue/gronn/battleaxe,
		/datum/supply_pack/rogue/gronn/owl_helmet,
		/datum/supply_pack/rogue/gronn/moose_hood,
		/datum/supply_pack/rogue/gronn/varangian_hauberk,
		/datum/supply_pack/rogue/gronn/shamanic_coat,
		/datum/supply_pack/rogue/gronn/kite_shield,
		/datum/supply_pack/rogue/gronn/fur_gloves,
		/datum/supply_pack/rogue/gronn/bone_gloves,
		/datum/supply_pack/rogue/gronn/beast_claws,
		/datum/supply_pack/rogue/gronn/fur_pants,
		/datum/supply_pack/rogue/gronn/leather_boots,
		/datum/supply_pack/rogue/gronn/atgervi_kit,
		/datum/supply_pack/rogue/gronn/iskarn_kit,
		/datum/supply_pack/rogue/gronn/spider_honey,
		/datum/supply_pack/rogue/gronn/cured_megafauna,
		/datum/supply_pack/rogue/gronn/gronnic_norsii_plate,
		/datum/supply_pack/rogue/gronn/gronnic_norsii_helm,
		/datum/supply_pack/rogue/gronn/gronnic_brigandine,
		/datum/supply_pack/rogue/gronn/norsii_kit,
		/datum/supply_pack/rogue/alcohol/gronnmead,
	)
	hail_lines = list(
		"Finest Gronnic mead and honey! Gives me your best iron and steel - in the form of ingots, please.",
		"Winter is coming. Give me all of your salt so my kin may preserve meat and fish.",
		"Before you ask, no, we did not help any of the raiders on the way here. My family are peaceful traders, and we have traded for four generations in peace with yours. What other tribes does is none of my concern.",
		"Please keep your priests off the pier.",
		"While rounding the Rosawood coast, I saw fire and smoke rising from the hills. Pray tell, do your people worship Elddan too?",
		"I saw three longships wrecked on the shore north of the city, a few ballista bolts sticking out of the hulls. One gronnman was nailed to the mast - unburied. Gruesome sight."
	)
