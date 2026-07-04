/datum/trade_good/fibers
	id = TRADE_GOOD_FIBERS
	name = "Fibers"
	category = TRADE_CATEGORY_CLOTH
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_FIBERS
	source_region_id = TRADE_REGION_ROSAWOOD
	item_type = /obj/item/natural/fibers

/datum/trade_good/cloth
	id = TRADE_GOOD_CLOTH
	name = "Cloth"
	category = TRADE_CATEGORY_CLOTH
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_CLOTH
	source_region_id = TRADE_REGION_KINGSFIELD
	item_type = /obj/item/natural/cloth

/datum/trade_good/silk
	id = TRADE_GOOD_SILK
	name = "Silk"
	category = TRADE_CATEGORY_CLOTH
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_SILK
	source_region_id = TRADE_REGION_BLACKHOLT
	item_type = /obj/item/natural/silk

/datum/trade_good/hide
	id = TRADE_GOOD_HIDE
	name = "Hide"
	category = TRADE_CATEGORY_ANIMAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_HIDE
	source_region_id = TRADE_REGION_ROSAWOOD
	item_type = /obj/item/natural/hide

/datum/trade_good/fur
	id = TRADE_GOOD_FUR
	name = "Fur"
	category = TRADE_CATEGORY_ANIMAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_FUR
	source_region_id = TRADE_REGION_ROSAWOOD
	item_type = /obj/item/natural/fur
	accept_subtypes = TRUE

/datum/trade_good/cured_leather
	id = TRADE_GOOD_CURED_LEATHER
	name = "Cured Leather"
	category = TRADE_CATEGORY_ARTISAN
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_CURED_LEATHER
	source_region_id = TRADE_REGION_ROSAWOOD
	item_type = /obj/item/natural/hide/cured

/datum/trade_good/rope
	id = TRADE_GOOD_ROPE
	name = "Rope"
	category = TRADE_CATEGORY_INTERMEDIARY
	behavior = TRADE_BEHAVIOR_INTERMEDIARY
	base_price = SELLPRICE_ROPE
	importable = FALSE
	source_region_id = null
	item_type = /obj/item/rope
