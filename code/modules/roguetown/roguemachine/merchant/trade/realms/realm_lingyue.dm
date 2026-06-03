/datum/foreign_realm/lingyue
	id = REALM_LINGYUE
	name = "Lingyue"
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_LIGHT, NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_POTIONS_REAGENTS, NAVIGATOR_BUCKET_ENCHANTMENTS, NAVIGATOR_BUCKET_INSTRUMENTS, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_MISCELLANEOUS)
	single_word_base = TRUE
	ship_name_words = list(
		"Tianxia", "Fenghuang", "Qilin", "Longwang", "Yuanzhao",
		"Jinqi", "Lingfeng", "Yunhai", "Shanhe", "Chunqiu",
		"Mingyue", "Jianghai", "Tianlong", "Beidou", "Wanli",
	)
	captain_first_names = list(
		"Yunxu", "Tianqi", "Jingming", "Yuanzheng", "Tianyou",
		"Hean", "Yunshu", "Tianlin", "Mingzhao", "Jingwei",
		"Yunzhi", "Mingxia", "Lianhua", "Xiulan", "Chunhua",
	)
	captain_last_names = list(
		"Zou", "Su", "Lei", "Yun", "Shan",
		"Meng", "Jiang", "Mu", "Han", "Tang",
	)
	ship_types = list(
		list("name" = "Junk", "tonnage" = 80, "weight" = 20),
		list("name" = "War Junk", "tonnage" = 200, "weight" = 30),
		list("name" = "Treasure Ship", "tonnage" = 800, "weight" = 30),
	)
	city_tags = list()
	city_tag_chance = 0
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_CINNABAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_PLUM, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CLAY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_ENCHSCROLL_BASIC, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_TIN_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CABBAGE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_ROCKNUT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/ricepork, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/riceporkcuc, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/ricebeef, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/riceeggcheese, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/plum_wine),
		list("recipe" = /datum/brewing_recipe/liquor/ricespirit),
		list("recipe" = /datum/brewing_recipe/whipwine),
		list("recipe" = /datum/brewing_recipe/tangerine_wine),
		list("recipe" = /datum/brewing_recipe/rum),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/jade,
		/datum/supply_pack/rogue/food/pepper,
		/datum/supply_pack/rogue/food/sugar,
		/datum/supply_pack/rogue/lingyue/wodao,
		/datum/supply_pack/rogue/lingyue/iwodao,
		/datum/supply_pack/rogue/lingyue/dadao,
		/datum/supply_pack/rogue/lingyue/idadao,
		/datum/supply_pack/rogue/lingyue/rumahwando,
		/datum/supply_pack/rogue/lingyue/samjeongdo,
		/datum/supply_pack/rogue/merc_weapons/hwando,
		/datum/supply_pack/rogue/merc_weapons/ssangsudo,
		/datum/supply_pack/rogue/kazengun/ssangsudo,
		/datum/supply_pack/rogue/kazengun/mentorhat,
		/datum/supply_pack/rogue/lingyue/ji,
		/datum/supply_pack/rogue/lingyue/iji,
		/datum/supply_pack/rogue/lingyue/zhanmadao,
		/datum/supply_pack/rogue/merc_weapons/glaive,
		/datum/supply_pack/rogue/lingyue/cloudcloak,
		/datum/supply_pack/rogue/lingyue/leathercloak,
		/datum/supply_pack/rogue/lingyue/shirt_black,
		/datum/supply_pack/rogue/lingyue/shirt_white,
		/datum/supply_pack/rogue/lingyue/pants_cutthroat,
		/datum/supply_pack/rogue/lingyue/pants_ripped,
		/datum/supply_pack/rogue/lingyue/gloves_black,
		/datum/supply_pack/rogue/lingyue/gloves_stylish,
		/datum/supply_pack/rogue/luxury/fancyteaset,
		/datum/supply_pack/rogue/alcohol/zhonghuangjiu,
		/datum/supply_pack/rogue/alcohol/baijiu,
		/datum/supply_pack/rogue/alcohol/yaojiu,
		/datum/supply_pack/rogue/alcohol/shejiu,
		/datum/supply_pack/rogue/drugs/whipwine,
		/datum/supply_pack/rogue/alcohol/truewhipwine,
	)
	hail_lines = list(
		"Greetings from the Xinyi court of Shenzhou. My manifest is sealed by the Ministry of Trade. Honor the seal and we shall conclude this with grace.",
		"Silk, tea, and rice in lawful quantity; cinnabar and gold in lesser measure. Inspect what you must - my scribe's brushwork is honest.",
		"By Judicious Ravox and Great Caishen, my weights are true. To insult one is to insult both - I would not advise it.",
		"I am Shizu by examination, factor. Eight characters of literary canon and four schools of magic at the brush. Speak plainly - I have neither time nor inclination for haggling.",
		"My ship bears the chop of the Imperial Court. Lesser seals you may see in my hold - the Huazu prefer that we acknowledge them. Acknowledge me first.",
		"A typhoon caught us off the Asemai - the same storm that struck the islands four yils past, they say. Saidun's blindfold slips sometimes. Pay fairly for what reached you.",
		"My cargo of enchanted scrolls is sealed beneath three locks and one charm. Buy them or do not, but do not ask to inspect them. Saidun watches.",
		"The lucky cat at my prow is Tabaxi, not idol. She earns her wages. Do not let your priests stare too long; she earns her wages from Caishen, who is jealous of attention.",
		"My passenger is a wandering monk of Eora's universal compassion. He pays his own passage in charity & merits, not coin. Mind him as you would any holy beggar - I do.",
		"I bring news from the Chengtian rebellion - the heartland still burns. Trade now, factor; the next ship from Lingyue may not be Xinyi at all.",
		"A scribe in my retinue dreamt of this very harbor before we sighted it. He named your magistrate by his given name. The Undercourt records every utterance - I would have us done quickly.",
		"There is a passenger in white robes who pays in jade and does not eat or sleep. The crew thinks her one of Necra's many aspects. Take her coin first.",
		"Mark me - I am Zou by lineage, and that name still means something on the mainland, even if the eastern overlords would have it otherwise. Trade with my house, not with the hand on its shoulder.",
		"My grandfather's grandfather served Yuanzhao before the Schism. We have outlived two dynasties and an invasion. Your Duchy does not impress me.",
		"I bring with me a masseur trained in the ancient art of medical massage. Did you know your body has twenty-four meridian points, and he can strike the twenty-fifth? For only a zenny he will show his skill with hot stones and cup, for three hours. Pay him and you will experience Saidun's heaven on Psydonia ten thousand yils early. Just remember to send him back before we undock - he has been left behind in two ports already. I would not like to turn my ship back a third time.",
		"Ah! Azurian fishes and crabs! Legendary, I know at least twenty housewives and househusbands who would kill for a taste of them. I have a runic chest from Shenzhou to preserve them for the journey home. Now, excuse me, I would like, uhhh, ...three salmon of twenty catty, and - oh, oh, before I forget - one salmon of forty-five catty, the prettiest one, the one you were saving, yes that one, for Magistrate Chan, who counts cargo with his eyes and his eyes, you understand, can be occupied. And one crab. The biggest crab. Sixty catty, claws bound but not too tightly, Ms. Wen likes a little fight in them, she has prepared a tank. A tank, friend. The woman has prepared a tank. And - wait, wait - six smaller crabs, ten catty each, for the housewives who only think they want the big one, because none of them have a tank, none of them, I have asked. Also ice. Do you have ice? The runic chest is good but ice is better, ice is insurance, and Magistrate Chan's salmon must arrive looking like it leaped fresh out of the river."
	)
