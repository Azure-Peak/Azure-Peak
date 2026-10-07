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
		list("good" = TRADE_GOOD_BRONZE_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
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
	"We're out of rice",
	"Can you help me find our lucky tabaxi? Yellow fur, long fluffy tail. I think he went to the market and followed another yellow-tailed tabaxi lady. I will offer thirty zenars for his return before we leave port. It is essential for the journey back home.",
	"Please keep the Inquisition away from our ship.",
	"I have a few Shizu, trained Scholar Mages who can help you with your magical needs. Is the University hiring? If not, perhaps one of your band of adventurers?",
	"I carries four families in the hold who is escaping the Chengtian rebellion. If you would be so kind, show them Eora's compassion and help them find a new home.",
	"I bring with me a skilled masseur trained in the ancient art of Lingyuese medical massage. He evens know of Pyromantic and Cryomantic magic and can warm and chill your body to help you recover from injuries and illness. If you pay him enough, he will settle here for the next yil or two. Otherwise, I'll bring him over to Grenzelhoft.",
	"Tis dire, I'm out of rice wine. Do you have any local rice wine to trade?",
		"Ah! Azurian fishes and crabs! Legendary, I know at least twenty housewives and househusbands who would kill for a taste of them. I have a runic chest from Shenzhou to preserve them for the journey home. Now, excuse me, I would like, uhhh, ...three salmon of twenty catty, and - oh, oh, before I forget - one salmon of forty-five catty, the prettiest one, the one you were saving, yes that one, for Magistrate Chan, who counts cargo with his eyes and his eyes, you understand, can be occupied. And one crab. The biggest crab. Sixty catty, claws bound but not too tightly, Ms. Wen likes a little fight in them, she has prepared a tank. A tank, friend. The woman has prepared a tank. And - wait, wait - six smaller crabs, ten catty each, for the housewives who only think they want the big one, because none of them have a tank, none of them, I have asked. Also ice. Do you have ice? The runic chest is good but ice is better, ice is insurance, and Magistrate Chan's salmon must arrive looking like it leaped fresh out of the river.",
	)
