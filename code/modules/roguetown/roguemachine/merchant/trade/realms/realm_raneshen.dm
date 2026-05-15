/datum/foreign_realm/raneshen
	id = REALM_RANESHEN
	name = "Raneshen"
	auto_discovered = FALSE
	roll_weight = TRADE_REALM_WEIGHT_DEFAULT
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
		"Raneshan", "Chorodiaki", "Müccevkabher", "Nshkormh", "Vrdaqnan",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool = list(
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GLASS_BATCH, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GARLICK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool = list(
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/hcake, "qty_min" = 4, "qty_max" = 8, "price" = 26),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced, "qty_min" = 3, "qty_max" = 6, "price" = 28),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal, "qty_min" = 3, "qty_max" = 5, "price" = 36),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/garlickbass, "qty_min" = 3, "qty_max" = 6, "price" = 24),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/peppersteak, "qty_min" = 3, "qty_max" = 6, "price" = 28),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/menthacake, "qty_min" = 4, "qty_max" = 7, "price" = 24),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = 8, "qty_max" = 15, "price" = 8),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/raisinbread, "qty_min" = 4, "qty_max" = 8, "price" = 18),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bun_jamtallow, "qty_min" = 4, "qty_max" = 8, "price" = 16),
	)
	cultural_stock_pool = list(
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
	)
