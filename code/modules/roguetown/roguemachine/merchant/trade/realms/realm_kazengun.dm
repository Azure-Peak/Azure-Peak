/datum/foreign_realm/kazengun
	id = REALM_KAZENGUN
	name = "Kazengun"
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_INSTRUMENTS, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_MISCELLANEOUS)
	single_word_base = TRUE
	ship_name_words = list(
		"Tsuru", "Hayabusa", "Akatsuki", "Tsuki", "Ame",
		"Sora", "Kaze", "Yume", "Hoshi", "Suzu",
		"Sakura", "Take", "Yuki", "Nami",
	)
	captain_first_names = list(
		"Masakatsu", "Yoshitaka", "Kagetora", "Tadanaga", "Hidemori",
		"Naomasa", "Tomoe", "Kaoruko", "Chiyo", "Sen",
		"Kikyō", "Tsuneyori", "Sadanobu", "Harukage", "Yorinaga",
	)
	captain_last_names = list(
		"Niwa", "Sakuma", "Kasai", "Asakura", "Andō",
		"Kurogane", "Yamashiro", "Tsukinami", "Koganei", "Akizuki",
	)
	ship_types = list(
		list("name" = "Sekibune", "tonnage" = 90, "weight" = 35),
		list("name" = "Bezaisen", "tonnage" = 120, "weight" = 40),
		list("name" = "Shuinsen", "tonnage" = 400, "weight" = 15),
		list("name" = "Atakebune", "tonnage" = 600, "weight" = 10),
	)
	name_suffixes = list(
		list("text" = "-Maru", "chance" = 75),
	)
	city_tags = list(
		"Iwoto", "Tamiro", "Kukui", "Matsuhama", "Aisataiji",
		"Bijai", "Mitihara", "Tatseshira",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_CINNABAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_CLAY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_POPPY, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_POTATO, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_ONION, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_TURNIP, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/riceshrimp, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/riceshrimpcar, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/riceegg, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/ricebird, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/cod, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/plum_wine),
		list("recipe" = /datum/brewing_recipe/liquor/ricespirit),
		list("recipe" = /datum/brewing_recipe/jack_wine),
		list("recipe" = /datum/brewing_recipe/brandy),
		list("recipe" = /datum/brewing_recipe/liquor),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/jade,
		/datum/supply_pack/rogue/merc_weapons/naginata,
		/datum/supply_pack/rogue/merc_weapons/hookblade,
		/datum/supply_pack/rogue/merc_weapons/kodachi,
		/datum/supply_pack/rogue/merc_weapons/tanto,
		
		/datum/supply_pack/rogue/kazengun/kanabo,
		/datum/supply_pack/rogue/kazengun/samsibsa,
		/datum/supply_pack/rogue/kazengun/haraate,
		/datum/supply_pack/rogue/kazengun/kabuto,
		/datum/supply_pack/rogue/kazengun/jingasa,
		/datum/supply_pack/rogue/kazengun/mentorhat,
		/datum/supply_pack/rogue/kazengun/mask_full,
		/datum/supply_pack/rogue/kazengun/mask_half,
		/datum/supply_pack/rogue/kazengun/cloak,
		/datum/supply_pack/rogue/kazengun/captainrobe,
		/datum/supply_pack/rogue/kazengun/gorget,
		/datum/supply_pack/rogue/kazengun/kote,
		/datum/supply_pack/rogue/kazengun/boots,
		/datum/supply_pack/rogue/kazengun/trousers,
		/datum/supply_pack/rogue/kazengun/chonin_kit,
		/datum/supply_pack/rogue/kazengun/kouken_kit,
		/datum/supply_pack/rogue/luxury/fancyteaset,
		/datum/supply_pack/rogue/alcohol/kgunlager,
		/datum/supply_pack/rogue/alcohol/kgunplum,
		/datum/supply_pack/rogue/alcohol/kgunsake,
		/datum/supply_pack/rogue/alcohol/kgunshochu,
	)
	hail_lines = list(
		"Kazengun greets the factor. Tea, silk, and rice are in the hold. The terms are simple; the courtesies are not.",
		"My ship is licensed by the Mita Clan of Tamiro. Read the seal before you read the manifest - the order is not optional.",
		"A Chonin of Tatseshira does not haggle in the street like a westerner. Speak your offer once, with respect, and we shall conclude this with dignity.",
		"By Aisata's Order, my weights are true. Verify them if you must. To accuse without verifying is a different matter.",
		"We crossed the Asemai calm as the proverb. We crossed your western waters less so. The fee should reflect the difference.",
		"My crew has been told the foreign chaos is not their concern. Keep them on the pier and they will keep your stevedores breathing.",
		"I sail with a Kouken aboard, returning from service abroad. He has not spoken since we cleared Kukui. Do not address him - he is not a guest of your house, only of mine.",
		"Aisata rises in the east and sets beyond your Otavan capes. I follow her path. one month out, one month back, and the sums must justify both.",
		"A typhoon caught us off Mitihara on the outward leg - the city still rebuilds even ten yils after the last. We brought what was salvaged. Pay fairly for it.",
		"Mamuke's iron, Matoko's coin. The trade is blessed; do not curse it with delay.",
		"My passenger of Aisataiji travels under the seal of the temples. He will disembark, pay his harbor fee, and be gone before the bell. You will not have seen him.",
		"A lacquered chest in my hold is sealed by the Tsukita Clan. It is not for sale. It is not for inspection. It is not for your magistrate's curiosity. Trade my open cargo and let the rest be.",
		"My grandfather signed the first compact with your factor in his eighteenth yil. I am here to honor it in my forty-third. Let us not waste either lifetime.",
		"I am told a Hangyaku of the southern fiefs walks your streets, dishonored and selling his blade. If you see him, factor, do not feed him - the dishonored eat their shame, not your bread.",
		"My silk is from the looms of Tamiro itself, not the mainland imitations. Pay the difference; you will know it on the touch.",
		"The tariff at home does not negotiate. Yours, I trust, has more grace. Demonstrate it.",
		"My tea master is from Aisataiji - trained at the foothill temples. For one zenny they will perform the Calm-as-the-Asemai ceremony, three hours, full silence, and seven different leaves from the islands. They have rejected the offers of clans richer than yours. They sail with me, to pass on our ancient arts. Do a favor to an old man and old master. Pay them and record his arts in your journals.",
		"One question, before we trade. Who is Alotheos, and why does your people keep robbing his tomb?",
		"I have heard of the fame of Azurian fishes. Big! Long! Fat, tasty and succulent. Full of umami. We have Lingyuese runic chest to preserve it for the journey home. Now, summon your best fisherman and sell me your best price for a catch of Azurian cod, salmon, and crabs. I only want the expensive, truly good ones, not the cheap one - these are not worth the space on my ship. Please, do not be like the less Factor who tried to offer me cheap fishes and pass them off. Us Kazengunese know the difference, and I will not be fooled.",
	)
