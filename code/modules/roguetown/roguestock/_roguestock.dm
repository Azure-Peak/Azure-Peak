/datum/roguestock
	var/name = ""
	var/desc = ""
	var/item_type = null
	var/stockpile_amount = 0
	/// Single price for both deposit (Crown pays player) and withdraw (player pays Crown).
	/// Crown no longer profits from internal arbitrage - margin comes from external trade.
	var/payout_price = 1
	var/withdraw_disabled = FALSE
	var/demand = 100
	var/mint_item = FALSE
	var/stockpile_limit = 100
	var/importexport_amt = 10
	var/export_only = FALSE
	var/stable_price = FALSE
	var/percent_bounty = FALSE
	var/category = "Raw Materials"
	/// Links this stockpile entry to a /datum/trade_good for region-based pricing and events.
	var/trade_good_id
	/// Steward toggle. When FALSE, stockpile refuses deposits with a say() message.
	var/accept_toggle_enabled = TRUE
	/// When TRUE, payout_price auto-follows trade_good.base_price * TRADE_STOCKPILE_BUY_DISCOUNT * global_price_mod.
	/// When FALSE, payout_price stays at whatever the Steward set. Steward "set price" UI unpegs automatically.
	var/pegged = TRUE

/datum/roguestock/New()
	..()
	if(!stable_price)
		demand = rand(60,140)
	return

/datum/roguestock/proc/get_payout_price(obj/item/I) //treasures modify this based on the price of the treasure
	return payout_price

/datum/roguestock/proc/check_item(obj/item/I) //for checking monster heads if they belong to monsters and other stuff
	//To stop people selling half-eaten food and rotten meat to the stockpile
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/food = I
		if(food.eat_effect == /datum/status_effect/debuff/rotfood)
			return FALSE
		if(food.bitecount > 0)
			return FALSE
		if(food.slices_num && food.slices_num < initial(food.slices_num)) // prevent selling partly-sliced butter
			return FALSE
	return TRUE

/// Refresh payout_price from the trade_good catalog when pegged. Called before every transaction.
/// No-op for unpegged entries or entries without a trade_good_id.
/datum/roguestock/proc/refresh_pegged_price()
	if(!pegged || !trade_good_id)
		return
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg)
		return
	payout_price = max(1, round(tg.base_price * TRADE_STOCKPILE_BUY_DISCOUNT * tg.global_price_mod))

/// Legacy export price, now computed via SSeconomy best-export-region routing if a trade_good is attached.
/// Falls back to payout_price * importexport_amt for entries without trade_good linkage.
/datum/roguestock/proc/get_export_price()
	if(trade_good_id && SSeconomy)
		var/list/best = SSeconomy.get_best_export_region(trade_good_id)
		if(best && best["unit_price"])
			return round(best["unit_price"] * importexport_amt)
	return payout_price * importexport_amt

/// Legacy import price, used by a handful of UIs. Crown imports via region now route through SSeconomy;
/// this remains a fallback reading payout_price directly.
/datum/roguestock/proc/get_import_price()
	return payout_price * importexport_amt

/datum/roguestock/proc/lower_demand()
	if(stable_price)
		return
	demand = max(demand-3,10)

/datum/roguestock/proc/raise_demand()
	if(stable_price)
		return
	demand = min(demand+1,200)

/datum/roguestock/proc/demand2word()
	switch(demand)
		if(160 to 200)
			return "Scarce"
		if(130 to 160)
			return "High"
		if(110 to 130)
			return "Growing"
		if(90 to 110)
			return "Normal"
		if(70 to 90)
			return "Falling"
		if(40 to 70)
			return "Low"
		if(1 to 40)
			return "Excess"
