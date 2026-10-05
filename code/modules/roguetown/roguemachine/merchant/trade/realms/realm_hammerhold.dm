/datum/foreign_realm/hammerhold
	id = REALM_HAMMERHOLD
	name = "Hammerhold"
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	demanded_categories = list(NAVIGATOR_BUCKET_GARMENT_COMMON, NAVIGATOR_BUCKET_ARMOR_HEAVY, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_POTTERY, NAVIGATOR_BUCKET_MISCELLANEOUS)
	single_word_base = TRUE
	ship_name_words = list(
		"Æthel", "Beorht", "Hammer", "Anvil", "Grim",
		"Wulf", "Stan", "Hild", "Mæst",
		"Fyr", "Dæg", "Gold",
	)
	captain_first_names = list(
		"Wulfstan", "Godric", "Leofric", "Beorn", "Cuthwine",
		"Oswin", "Eadwulf", "Cynehelm", "Beornræd", "Deorwine",
		"Wynflæd", "Eadgyth", "Mildþryth", "Beorhtflæd", "Cyneburg",
	)
	captain_last_names = list(
		"Hammerson", "Stanforge", "Grimaxe", "Coldhammer", "Ironbeard",
		"Ætheling", "Wulfing", "se Reada", "Eorling", "Stoneward",
	)
	ship_types = list(
		list("name" = "Knarr", "tonnage" = 25, "weight" = 10),
		list("name" = "Ballinger", "tonnage" = 50, "weight" = 25),
		list("name" = "Cog", "tonnage" = 120, "weight" = 35),
		list("name" = "Hulk", "tonnage" = 250, "weight" = 20),
		list("name" = "Great Ship", "tonnage" = 700, "weight" = 10),
	)
	name_prefixes = list(
		list("text" = "Eorl ", "chance" = 4),
		list("text" = "Cyne ", "chance" = 3),
		list("text" = "the ", "chance" = 60),
	)
	city_tags = list(
		"Norwardine", "Quicksilver Hold", "Granite Fort", "Walnut Grove",
		"the Bán", "the Mountainhomes",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_COPPER_ORE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COPPER_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_STONE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_ORE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_TOPER, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_STAPLE_EAGER, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CHEESE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SALUMOI, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/bear/fried, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FEAST),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/pot, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/sandwich/ham, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/cheesebun, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/beer, "keg_mult" = 2),
		list("recipe" = /datum/brewing_recipe/beer/oat),
		list("recipe" = /datum/brewing_recipe/mead),
		list("recipe" = /datum/brewing_recipe/cider),
		list("recipe" = /datum/brewing_recipe/voddena),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/hammerhold/dwarven_maul,
		/datum/supply_pack/rogue/hammerhold/spiked_maul,
		/datum/supply_pack/rogue/hammerhold/longbow,
		/datum/supply_pack/rogue/hammerhold/iron_fullplate,
		/datum/supply_pack/rogue/hammerhold/snow_cloak,
		/datum/supply_pack/rogue/hammerhold/ironclad_kit,
		/datum/supply_pack/rogue/hammerhold/smoked_sausage,
		/datum/supply_pack/rogue/hammerhold/bacon,
		/datum/supply_pack/rogue/hammerhold/slayer_axe,
		/datum/supply_pack/rogue/hammerhold/slayer_greataxe,
		/datum/supply_pack/rogue/hammerhold/slayer_belt,
		/datum/supply_pack/rogue/hammerhold/dwarven_warpick,
		/datum/supply_pack/rogue/hammerhold/grudgebearer_smith_kit,
		/datum/supply_pack/rogue/hammerhold/grudgebearer_soldier_kit,
		/datum/supply_pack/rogue/alcohol/voddena,
		/datum/supply_pack/rogue/alcohol/sazdistal,
		/datum/supply_pack/rogue/alcohol/nred,
		/datum/supply_pack/rogue/alcohol/butterhair,
		/datum/supply_pack/rogue/alcohol/stonebeard,
	)
	hail_lines = list(
		"Finest arms, armor, and dwarven crafts from Hammerhold! Second to none!",
		"Have you a taste for caviar or sturgeon? I have brought some live one to sell to the nobles of your land",
		"The damned Grenzelhoftian has been charging me a quarter of my cargo in toll for the last yil. So I rounded the cape. Took me six months, but at least I will make a profit. Now, please, do not waste my time.",
		"I brought along three Atgervi whom have served their time north and wishes to adventure here. Know of any employers? I hear Azuria is full of strife and opportunities.",
		"Voddena! Voddena! Best Voddena in the world! Pure water from the mountains of Hammerhold! I even have one flavored with fruits, if you have stranger tastes!",
		"One of your templar had me terrified when he walked near me on the pier. He was clad in full Ravoxian plate, and moved with unusual speed. I thought he was the notorious Brazen Bull, but I looked behind him, and saw a catte's tail, and I remembered there are not many catte half-kin in Hammerhold. Phew."
	)
