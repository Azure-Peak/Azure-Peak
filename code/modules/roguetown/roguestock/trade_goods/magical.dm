/datum/trade_good/magical
	behavior = TRADE_BEHAVIOR_EQUIPMENT
	importable = FALSE
	crown_accepts = TRUE
	category = ITEM_CAT_MAGICAL
	display_category = ITEM_CAT_MAGICAL

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

// Summon loot and the arcane resources that feed arcana crafting drop uncrafted, so the
// recipe walker never tags them and they default to Miscellaneous at the navigator. These
// id-less protos route the whole family to the Potions & Reagents market instead.
/datum/trade_good/arcane_reagent
	behavior = TRADE_BEHAVIOR_EQUIPMENT
	importable = FALSE
	crown_accepts = TRUE
	category = ITEM_CAT_REAGENT_ARCANE
	display_category = ITEM_CAT_REAGENT_ARCANE

/datum/trade_good/arcane_reagent/infernal
	item_type = /obj/item/magic/infernal

/datum/trade_good/arcane_reagent/fae
	item_type = /obj/item/magic/fae

/datum/trade_good/arcane_reagent/elemental
	item_type = /obj/item/magic/elemental

/datum/trade_good/arcane_reagent/leyline
	item_type = /obj/item/magic/leyline

/datum/trade_good/arcane_reagent/voidstone
	item_type = /obj/item/magic/voidstone

/datum/trade_good/arcane_reagent/manacrystal
	item_type = /obj/item/magic/manacrystal
