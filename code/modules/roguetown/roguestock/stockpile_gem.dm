// Gem stockpile entries default to accept_toggle_enabled = FALSE. Steward must flip the
// per-item toggle ON to begin accepting. When ON and at stockpile_limit, the overflow
// branch in attemptsell mints at base_price * mint_multiplier to the Crown's Purse.

/datum/roguestock/stockpile/gem_toper
	name = "Toper"
	desc = "A yellow gemstone. Common."
	item_type = /obj/item/roguegem/yellow
	trade_good_id = TRADE_GOOD_TOPER
	payout_price = SELLPRICE_TOPER
	importexport_amt = 1
	stockpile_limit = 4
	accept_toggle_enabled = FALSE
	category = "Precious"

/datum/roguestock/stockpile/gem_gemerald
	name = "Gemerald"
	desc = "A green gemstone. Common."
	item_type = /obj/item/roguegem/green
	trade_good_id = TRADE_GOOD_GEMERALD
	payout_price = SELLPRICE_GEMERALD
	importexport_amt = 1
	stockpile_limit = 4
	accept_toggle_enabled = FALSE
	category = "Precious"

/datum/roguestock/stockpile/gem_saffira
	name = "Saffira"
	desc = "A violet gemstone. Rare."
	item_type = /obj/item/roguegem/violet
	trade_good_id = TRADE_GOOD_SAFFIRA
	payout_price = SELLPRICE_SAFFIRA
	importexport_amt = 1
	stockpile_limit = 3
	accept_toggle_enabled = FALSE
	category = "Precious"

/datum/roguestock/stockpile/gem_blortz
	name = "Blortz"
	desc = "A blue gemstone. Rare."
	item_type = /obj/item/roguegem/blue
	trade_good_id = TRADE_GOOD_BLORTZ
	payout_price = SELLPRICE_BLORTZ
	importexport_amt = 1
	stockpile_limit = 3
	accept_toggle_enabled = FALSE
	category = "Precious"

/datum/roguestock/stockpile/gem_dorpel
	name = "Dorpel"
	desc = "A diamond. Legendary."
	item_type = /obj/item/roguegem/diamond
	trade_good_id = TRADE_GOOD_DORPEL
	payout_price = SELLPRICE_DORPEL
	importexport_amt = 1
	stockpile_limit = 2
	accept_toggle_enabled = FALSE
	category = "Precious"

/datum/roguestock/stockpile/gem_blood_diamond
	name = "Blood Diamond"
	desc = "A crimson gemstone. Legendary."
	item_type = /obj/item/roguegem/blood_diamond
	trade_good_id = TRADE_GOOD_BLOOD_DIAMOND
	payout_price = SELLPRICE_BLOOD_DIAMOND
	importexport_amt = 1
	stockpile_limit = 2
	accept_toggle_enabled = FALSE
	category = "Precious"
