/datum/foreign_realm/raneshen
	id = REALM_RANESHEN
	name = "Raneshen"
	roll_weight = TRADE_REALM_WEIGHT_DEFAULT
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_ARMOR_LIGHT, NAVIGATOR_BUCKET_ENCHANTMENTS, NAVIGATOR_BUCKET_INSTRUMENTS, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_MISCELLANEOUS)
	single_word_base = TRUE
	ship_name_words = list(
		"Thalassa", "Abyssoros", "Khimaira", "Eos", "Aetos",
		"Astrateios", "Anemos", "Galene", "Drakon", "Pelagos",
		"Astraios", "Noctaios", "Korax", "Boreas", "Aigle",
	)
	captain_first_names = list(
		"Eumelos", "Kallias", "Damaskios", "Hieron", "Polyphron",
		"Andronikos", "Doros", "Aram", "Vartan", "Niyaz",
		"Helike", "Anthousa", "Korinna", "Astrateia", "Nairi",
	)
	captain_last_names = list(
		"Khariotes", "Pelasgos", "Anaktor", "Phaleron", "Abyssoreios",
		"of Chorodiaki", "Vrdaqnani", "Nshkor", "Müccevbey", "Sayyari",
	)
	ship_types = list(
		list("name" = "Akation", "tonnage" = 40, "weight" = 15),
		list("name" = "Dromon", "tonnage" = 130, "weight" = 35),
		list("name" = "Bireme", "tonnage" = 300, "weight" = 30),
		list("name" = "Pamphylos", "tonnage" = 600, "weight" = 20),
	)
	city_tags = list(
		"Raneshen", "Chorodiaki", "Müccevkabher", "Nshkormh", "Vrdaqnan",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GLASS_BATCH, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GARLICK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR, "always" = TRUE),
		list("good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_ONION, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_ROCKNUT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/hcake, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FEAST),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/garlickbass, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/peppersteak, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/menthacake, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/raisinbread, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bun_jamtallow, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/winespiced),
		list("recipe" = /datum/brewing_recipe/mead),
		list("recipe" = /datum/brewing_recipe/liquor),
		list("recipe" = /datum/brewing_recipe/aqua_vitae),
		list("recipe" = /datum/brewing_recipe/limoncello),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/amber,
		/datum/supply_pack/rogue/gems/coral,
		/datum/supply_pack/rogue/food/pepper,
		/datum/supply_pack/rogue/luxury/spice,
		/datum/supply_pack/rogue/food/chocolate,
		/datum/supply_pack/rogue/food/sugar,
		/datum/supply_pack/rogue/raneshen/janissary_kit,
		/datum/supply_pack/rogue/raneshen/desert_rider_kit,
		/datum/supply_pack/rogue/raneshen/megarmach_coat,
		/datum/supply_pack/rogue/raneshen/tower_shield,
		/datum/supply_pack/rogue/raneshen/shamshir,
		/datum/supply_pack/rogue/raneshen/shalal_saber,
		/datum/supply_pack/rogue/raneshen/navaja,
		/datum/supply_pack/rogue/raneshen/grand_mace,
		/datum/supply_pack/rogue/raneshen/spear,
		/datum/supply_pack/rogue/raneshen/whip,
		/datum/supply_pack/rogue/raneshen/recurve_bow,
		/datum/supply_pack/rogue/raneshen/javelins,
		/datum/supply_pack/rogue/raneshen/headscarf,
		/datum/supply_pack/rogue/raneshen/shalal_hood,
		/datum/supply_pack/rogue/raneshen/shalal_scarf,
		/datum/supply_pack/rogue/raneshen/copper_gorget,
		/datum/supply_pack/rogue/raneshen/copper_facemask,
		/datum/supply_pack/rogue/raneshen/copper_bracers,
		/datum/supply_pack/rogue/raneshen/pontifex_trou,
		/datum/supply_pack/rogue/raneshen/shalal_slippers,
		/datum/supply_pack/rogue/raneshen/shalal_belt,
		/datum/supply_pack/rogue/raneshen/gladius,
		/datum/supply_pack/rogue/raneshen/makhaira,
		/datum/supply_pack/rogue/raneshen/bronzekhopesh,
		/datum/supply_pack/rogue/raneshen/spatha,
		/datum/supply_pack/rogue/raneshen/greatkhopesh,
		/datum/supply_pack/rogue/raneshen/bronze_axe,
		/datum/supply_pack/rogue/raneshen/bronze_greataxe,
		/datum/supply_pack/rogue/raneshen/bronze_warclub,
		/datum/supply_pack/rogue/raneshen/bronze_mace,
		/datum/supply_pack/rogue/raneshen/bronze_flail,
		/datum/supply_pack/rogue/raneshen/bronze_spear,
		/datum/supply_pack/rogue/raneshen/bronze_winged_spear,
		/datum/supply_pack/rogue/raneshen/bronze_trident,
		/datum/supply_pack/rogue/raneshen/arbelos,
		/datum/supply_pack/rogue/raneshen/bronze_katar,
		/datum/supply_pack/rogue/raneshen/bronze_knife,
		/datum/supply_pack/rogue/raneshen/dolabra,
		/datum/supply_pack/rogue/raneshen/hoplon_shield,
		/datum/supply_pack/rogue/raneshen/hoplon_greatshield,
		/datum/supply_pack/rogue/raneshen/bronze_javelins,
		/datum/supply_pack/rogue/raneshen/bronze_arrows,
		/datum/supply_pack/rogue/raneshen/bronze_sling_bullets,
		/datum/supply_pack/rogue/raneshen/bronze_mask,
		/datum/supply_pack/rogue/raneshen/bronze_wristguards,
		/datum/supply_pack/rogue/raneshen/bronze_neckguard,
		/datum/supply_pack/rogue/raneshen/bronze_gorgette,
		/datum/supply_pack/rogue/raneshen/bronze_greaves,
		/datum/supply_pack/rogue/raneshen/bronze_murmillo,
		/datum/supply_pack/rogue/raneshen/bronze_illyriahelm,
		/datum/supply_pack/rogue/raneshen/bronze_barbute,
		/datum/supply_pack/rogue/raneshen/bronze_cardiophylax,
		/datum/supply_pack/rogue/raneshen/bronze_cuirass,
		/datum/supply_pack/rogue/raneshen/bronze_panoply_assembly,
		/datum/supply_pack/rogue/raneshen/bronze_panoply,
		/datum/supply_pack/rogue/raneshen/gladiator_harness,
		/datum/supply_pack/rogue/raneshen/hoplite_panoply,
		/datum/supply_pack/rogue/raneshen/bulwark_panoply,
		/datum/supply_pack/rogue/alcohol/wineraneshen,
	)
	hail_lines = list(
		"In the name of the Autarch, and by leave of the Emir who stamped my charter, Raneshen greets the Factor. My hold is long-travelled; do not make it stand idle.",
		"Silk from Chorodiaki, sugar and saffira from Mücevkabher, wine from Nshkormh, geometers' work from Vrdaqnan. One empire, four manifests; the Sheikh's clerks were patient with me.",
		"Sit with me before we tally. In Raneshen no one trades with a stranger - we drink first, eat second, and only then count coin. Your hospitality will be remembered as long as your prices.",
		"Hear that flute from my afterdeck? My mate is from Mücevkabher, and she will not bargain unless the bargaining keeps time. Xylix smiles on her, she says. I find she haggles harder when the song is fast.",
		"You have fur and timber and iron, and Psydon - bless his memory - put none of these on our continent in quantity. So we sail. The arithmetic is older than either of us.",
		"My cousin is a Sheikh of his county and reminds me of it at every supper. Yet here I am at your dock, and there he is at his table. Tell me which of us has truly seen the world.",
		"My grandmother taught that you cannot know a person until you have spoken with them alone. So when we have finished the public price, share a cup with me below. The honest number lives there.",
		"The Emir of Vrdaqnan sent a janissary aboard to keep the peace among my crew. He has, by dancing with two of them and drinking with the third. I will commend him in my report.",
		"There is a dervish in the third hold who has not stopped spinning since we sighted your cape. He says Günay's blade still turns in the heavens and so must he. Pay him no mind; pay me promptly.",
		"A geometer of the Vrdaqnan houses rides at my prow, reader of palms by the first light of Astrata. He charges in questions, not coin - one question for one reading, no exceptions. He sails to teach what he has learned before the dervish houses no longer commission his work. Bring him a true question and he will not refuse you. Bring him a flattery and he will not refuse you either, but you will not like the answer.",
		"Salt cured mackeral and herring for the long caravan trip to land, chests of ice-bound fishes of all varieties. The Sheikhs of the interior have never seen the sea. My partner will bring it to them."
	)
