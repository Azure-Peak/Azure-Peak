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

/datum/trade_good/arcane_reagent/infernal_ash
	id = TRADE_GOOD_INFERNAL_ASH
	name = "infernal ash"
	base_price = SELLPRICE_MAGIC_TIER1
	item_type = /obj/item/magic/infernal/ash

/datum/trade_good/arcane_reagent/hellhound_fang
	id = TRADE_GOOD_HELLHOUND_FANG
	name = "hellhound fang"
	base_price = SELLPRICE_MAGIC_TIER2
	item_type = /obj/item/magic/infernal/fang

/datum/trade_good/arcane_reagent/infernal_core
	id = TRADE_GOOD_INFERNAL_CORE
	name = "infernal core"
	base_price = SELLPRICE_MAGIC_TIER3
	item_type = /obj/item/magic/infernal/core

/datum/trade_good/arcane_reagent/abyssal_flame
	id = TRADE_GOOD_ABYSSAL_FLAME
	name = "abyssal flame"
	base_price = SELLPRICE_MAGIC_TIER4
	item_type = /obj/item/magic/infernal/flame

/datum/trade_good/arcane_reagent/fairy_dust
	id = TRADE_GOOD_FAIRY_DUST
	name = "fairy dust"
	base_price = SELLPRICE_MAGIC_TIER1
	item_type = /obj/item/magic/fae/fairydust

/datum/trade_good/arcane_reagent/iridescent_scale
	id = TRADE_GOOD_IRIDESCENT_SCALE
	name = "iridescent scales"
	base_price = SELLPRICE_MAGIC_TIER2
	item_type = /obj/item/magic/fae/iridescentscale

/datum/trade_good/arcane_reagent/heartwood_core
	id = TRADE_GOOD_HEARTWOOD_CORE
	name = "heartwood core"
	base_price = SELLPRICE_MAGIC_TIER3
	item_type = /obj/item/magic/fae/heartwoodcore

/datum/trade_good/arcane_reagent/sylvan_essence
	id = TRADE_GOOD_SYLVAN_ESSENCE
	name = "sylvan essence"
	base_price = SELLPRICE_MAGIC_TIER4
	item_type = /obj/item/magic/fae/sylvanessence

/datum/trade_good/arcane_reagent/elemental_mote
	id = TRADE_GOOD_ELEMENTAL_MOTE
	name = "elemental mote"
	base_price = SELLPRICE_MAGIC_TIER1
	item_type = /obj/item/magic/elemental/mote

/datum/trade_good/arcane_reagent/elemental_shard
	id = TRADE_GOOD_ELEMENTAL_SHARD
	name = "elemental shard"
	base_price = SELLPRICE_MAGIC_TIER2
	item_type = /obj/item/magic/elemental/shard

/datum/trade_good/arcane_reagent/elemental_fragment
	id = TRADE_GOOD_ELEMENTAL_FRAGMENT
	name = "elemental fragment"
	base_price = SELLPRICE_MAGIC_TIER3
	item_type = /obj/item/magic/elemental/fragment

/datum/trade_good/arcane_reagent/elemental_relic
	id = TRADE_GOOD_ELEMENTAL_RELIC
	name = "elemental relic"
	base_price = SELLPRICE_MAGIC_TIER4
	item_type = /obj/item/magic/elemental/relic
