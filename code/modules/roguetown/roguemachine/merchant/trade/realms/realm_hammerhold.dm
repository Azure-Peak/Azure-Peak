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
		"Hail, factor. Copper from the Mountainhomes, stone from the Bán. Bring grain, bring cloth, bring cheese - or do not waste my tide.",
		"Six months out from Norwardine. Six months, factor. Spare me your haggling and I will spare you my temper.",
		"You would not believe what the Grenzel collectors charge on the Eisenhafen river-locks now. Highway robbery, if rivers had highways. We rounded the cape instead - it was cheaper, and that is no exaggeration.",
		"Either the long route around the continent, or the Grenzelhoftian river tolls. Both are worse than they used to be. I picked the one without their priests at every chain.",
		"My salt is two months past brined. My crew is three weeks past patient. Trade kindly.",
		"We slipped a Grenzel patrol off the Eisenhafen banks two weeks past. The Imperate calls us robber-lords; here we will call ourselves traders. Let your magistrate do the same.",
		"The hammers of Quicksilver Hold sound from this voyage's keel - hold and humen, working as one. Treat her gently at the pier.",
		"I am told your tariff men weigh light and tax heavy. We shall see.",
		"My helmsman is a thane's heir-apparent, finishing his yil and his ten raids before he may inherit. Do not provoke him - the Atgervi do not start fights, but they do finish them.",
		"By PSYDON who slumbers and stirs, the wind held all the way past the Otavan capes. I will pay my chaplain a bonus and you will pay a fair price. Let it be a good day.",
		"I bear word from a Greycoat warden of the Granite Fort: the dwarf-kings honor the old pact, the underdeep is quiet this season. Trade with us as Harlond traded with them.",
		"Look at the gilbronze fittings of my hold and tell me my craftsmen lie. Norwardine guild work, every plate. Worth the long crossing to bring them south.",
		"My grandfather sailed this run before the harbor was dredged. He lost two teeth to your magistrate. I have come for the rest of his coin.",
		"A pilgrim of the Bán rides with us. He has not spoken since Walnut Grove. The forest there has a way with quiet men - do not ask after him.",
		"There is a tale on the Mountainhomes road - a man in Ravoxian plate, fighting alone, walking out of his own grave. The crew thinks it nonsense. I am less certain. Pay quickly and let me sail before I must think on it longer.",
		"Three of my deckhands are bull-marked beneath the eyes - pardoned in the Hearth's tradition. They lift cargo, not coin. Mind your stevedores.",
		"My factor at Norwardine warned me the southern markets had soured. I came anyway. Let us see who was right.",
		"My ship carries an old Atgervi veteran, his last voyage before the abbey takes his sword. For three zennies he will sit with you and tell the true account of the Brazen Bull, the Greycoat war, and the night the gates of Granite Fort first opened to humen. He drinks more than he eats. Pay him and listen well - in Norwardine the songs live in the men who sing them, and there are not many old men left who remember the early daes.",
		"Factor! Give me the biggest barrel of sturgeon and caviar I have ever seen! I shall trade the finest armor of gilbranze and steel! True dwarven crafts from Hammerhold. It will even take three siegebolts to the chest for your trouble. It is marked and proofed, you can even see the dent and a seal of the craftsman on the inside. And for your troubles, I shall give you four bottles of our finest voddena and ingots. My Hold hungers for the finest southern delicacies. Please deliver them unto me with haste. I'd like a taste before we set sail."
	)
