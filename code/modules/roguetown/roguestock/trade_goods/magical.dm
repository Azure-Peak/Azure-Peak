/datum/trade_good/magical
	behavior = TRADE_BEHAVIOR_EQUIPMENT
	importable = FALSE
	crown_accepts = TRUE
	category = "Magical"

/datum/trade_good/magical/enchantment_scroll_basic
	id = TRADE_GOOD_ENCHSCROLL_BASIC
	name = "basic enchantment scroll"
	base_price = SELLPRICE_ENCHSCROLL_BASIC
	item_type = /obj/item/enchantmentscroll/basic
	accept_subtypes = TRUE

/datum/trade_good/magical/enchantment_scroll_superior
	id = TRADE_GOOD_ENCHSCROLL_SUPERIOR
	name = "superior enchantment scroll"
	base_price = SELLPRICE_ENCHSCROLL_SUPERIOR
	item_type = /obj/item/enchantmentscroll/superior
	accept_subtypes = TRUE

/datum/trade_good/magical/enchantment_scroll_greater
	id = TRADE_GOOD_ENCHSCROLL_GREATER
	name = "greater enchantment scroll"
	base_price = SELLPRICE_ENCHSCROLL_GREATER
	item_type = /obj/item/enchantmentscroll/greater
	accept_subtypes = TRUE
