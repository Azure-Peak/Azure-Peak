/datum/foreign_realm/naledi
	id = REALM_NALEDI
	name = "Naledi"
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_LIGHT, NAVIGATOR_BUCKET_GARMENT_COMMON, NAVIGATOR_BUCKET_ENCHANTMENTS, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_TROPHIES, NAVIGATOR_BUCKET_VALUABLES_LOOTED, NAVIGATOR_BUCKET_MISCELLANEOUS)
	ship_name_words = list(
		"Psydon", "Bilomari", "Veralun", "Olindar", "Veranda",
		"Repentance", "Mercy", "Vigil", "Pilgrim", "Endurance",
		"Bluebell", "Ocotillo", "Lily", "Ember", "Lantern",
	)
	captain_first_names = list(
		"Arindele", "Nasir", "Tariq", "Yusuf", "Kamau",
		"Jelani", "Hamadi", "Bashir", "Faraj", "Idris",
		"Amalara", "Selima", "Yusra", "Amara", "Nadira",
	)
	captain_last_names = list(
		"Arivale", "Ndalasi", "al-Veranda", "Bilomari", "Olindari",
		"Kamenji", "Ravalan", "Tessanda", "ibn-Asari", "Veshani",
	)
	ship_types = list(
		list("name" = "Dhow", "tonnage" = 60, "weight" = 30),
		list("name" = "Baghlah", "tonnage" = 180, "weight" = 35),
		list("name" = "Sand-Galley", "tonnage" = 350, "weight" = 20),
		list("name" = "Gilded Carrack", "tonnage" = 600, "weight" = 15),
	)
	name_prefixes = list(
		list("text" = "Shah ", "chance" = 8),
		list("text" = "the ", "chance" = 10),
	)
	city_tags = list(
		"Veralun", "Olindar", "Veranda", "the Glass Dunes",
	)
	city_tag_chance = 35
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_GLASS_BATCH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_GOLD_ORE, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_CINNABAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TOPER, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_BLORTZ, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_STONE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_TIN_ORE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_COPPER_ORE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM),
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM),
		list("good" = TRADE_GOOD_SALUMOI, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CALENDULA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_TURNIP, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_PEAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_RASPBERRY, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pepperfish, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/wienercabbage, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/frybread, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffed, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/roastseeds, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/tangerine_wine),
		list("recipe" = /datum/brewing_recipe/golden_calendula_tea),
		list("recipe" = /datum/brewing_recipe/soothing_valerian_tea),
		list("recipe" = /datum/brewing_recipe/fermentedcrab),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/turq,
		/datum/supply_pack/rogue/gems/amethyst,
		/datum/supply_pack/rogue/food/pepper,
		/datum/supply_pack/rogue/luxury/spice,
		/datum/supply_pack/rogue/merc_weapons/shamshir,
		/datum/supply_pack/rogue/merc_weapons/naledistaff,
		/datum/supply_pack/rogue/steel_weapons/katar,
		/datum/supply_pack/rogue/naledi/hierophant_kit,
		/datum/supply_pack/rogue/naledi/psicross,
		/datum/supply_pack/rogue/naledi/lordmask,
		/datum/supply_pack/rogue/naledi/pashmina,
		/datum/supply_pack/rogue/naledi/sandals,
		/datum/supply_pack/rogue/naledi/treatise,
		/datum/supply_pack/rogue/naledi/glassen_decanters,
		/datum/supply_pack/rogue/naledi/glass_statue,
		/datum/supply_pack/rogue/naledi/gold_finery,
	)
	hail_lines = list(
		"Peace upon the Company. Naledi greets the factor, in Psydon's name, with the respect owed between honest houses.",
		"I bring glass from the Dunes, gold from Veranda, the finest coffee and tea in Psydonia. A thirst for iron that no caravan can slake.",
		"Every time we sell you coffee and tea, the finest in Psydonia, one of your stevedores would offer us wines and drinks. Know that us in Naledi do not indulge in such spirits nor bring them to court. We follow that very strictly. Now - do you happen to have some Kazengunese plum wine on hand?",
		"We know in Azuria you tolerate Tieflings and Goblins amongst your people, yet fight and slay them by the hundreds every dae. Do not bring them near the dock - my crew might suddenly remember their Warscholar heritage.",
		"Do not point at my crew when you address them, factor. To do so is rude - and rudeness is how Djinn slip into a man's manners first, before all else.",
		"Bring me no gifts of gold; we mine more than the daimyos can swallow. Bring exotic spice, ore foreign to my dunes, or do not bring me anything at all.",
		"My weights are true under the gaze of Astrata - whom you call goddess and we call merely one of His aspects. Inspect them. Inspect them again if it pleases you.",
		"I sailed under royal license of the Malikat Amalara herself. The seal you see at my prow is hers. Show it the respect you would show your own Duchess.",
		"Two of my passengers travel veiled head to toe. They are Warscholars returning from the Otavan houses. Do not address them. Do not stare. They have killed more than thirty Djinn each, and the habit of vigilance does not lift at a friendly pier.",
		"My hold smells of sand and hibiscus. I will not apologize for either. Pay fair and you may take a cup of the second before I depart.",
		"You will hear no priests of the Ten preaching from my deck. If you wish to bring symbols of them aboard, leave them at the gangway - my crew will not pass them, and neither shall I.",
		"My helmsman is Bilamak, sworn to the Crown, returning home after service abroad. His saber is sheathed in gilded silk; do not test him into drawing it. His blade dances faster than your eye, I promise you.",
		"The Arisole sandstorms have closed three southern passes. My route was thirty days longer than last season. The fee should reflect the dunes' temper - not mine.",
		"We are a welcoming people, factor. We will share bread and tea with anyone who asks honestly. But know that we do not share court with those who came here to convert us. Trade openly, drink openly, pray quietly.",
		"A wandering Vizier-scholar rides with me, bound for your Avisa boards to study how foreign justice is recorded. She pays in knowledge, not coin. Direct her kindly when she asks, and she will write your magistrate's name well in her journals.",
		"My grandmother saw the Otavan expedition return from the Dunes with the Pope's confession hanging from their saddles. She lived to a hundred and seven and never trusted a priest of the Ten again. I follow her in this.",
		"A Vizier-scholar of the Olindar houses rides with me, returning from her tutoring at the Otavan abbeys. For one zenny she will read a passage of the Treatise of Endurance and explain it for as long as you will listen. She has lectured for nine hours without rest at the Hierophant houses. Pay her and you will know why the Warscholars endure where lesser men kneel.",
		"The Dunes are beautiful two months past now. It is beautiful, and our architecture are most impressive. I would invite you on a trip, and then make a hefty profit by selling you the services of Warscholars to escort you from the Djinn of the sand. What say you, Factor? Do you want to see the Dunes with your own eyes?",
		"Olindar is holding another conclave of the Warscholars. And us Naledi knows to partake moderately in joys and pleasures of the world, as is right under the gaze of Psydon. So, give me the finest of your wines, the most succulent of your shrimps, lobsters and crabs from the sea, and a platter of your best cheeses. Spices? Do not bother, ours are the best in the world, I have some in the hold for you.",
		"My ship's surgeon ran out of aqua vitae at the second crossing of the dunes - the Warscholars cauterise their wounds with it, and the desert is not generous with wounds. If your distillers have bottles to spare, the Malikat's healers will repay you in iron-clean stitches and quiet recoveries. We do not drink it. We pour it on what should not have opened.",
	)
