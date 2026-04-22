/datum/roguestock/stockpile/viscera
	name = "Viscera"
	desc = "Fresh organs and offal, valued by alchemists."
	item_type = /obj/item/alch/viscera
	trade_good_id = TRADE_GOOD_VISCERA
	payout_price = SELLPRICE_VISCERA
	importexport_amt = 5
	stockpile_limit = 20
	category = "Alchemy"

/datum/roguestock/stockpile/herbs
	name = "Herbs"
	desc = "Assorted herbs prized by apothecaries."
	item_type = /obj/item/reagent_containers/food/snacks/grown/manabloom
	trade_good_id = TRADE_GOOD_HERBS
	payout_price = SELLPRICE_HERBS
	importexport_amt = 5
	stockpile_limit = 20
	category = "Alchemy"

/datum/roguestock/stockpile/dendor_essence
	name = "Essence of Wilderness"
	desc = "A vial of distilled Dendorian essence."
	item_type = /obj/item/natural/cured/essence
	trade_good_id = TRADE_GOOD_DENDOR_ESSENCE
	payout_price = SELLPRICE_DENDOR_ESSENCE
	importexport_amt = 3
	stockpile_limit = 5
	category = "Alchemy"
