/datum/roguestock
	var/name = ""
	var/desc = ""
	var/item_type = null
	var/stockpile_amount = 0
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
	var/trade_good_id
	var/accept_toggle_enabled = TRUE
	var/pegged = TRUE

/datum/roguestock/New()
	..()
	if(!stable_price)
		demand = rand(60,140)
	return

/datum/roguestock/proc/get_payout_price(obj/item/I)
	return payout_price

/datum/roguestock/proc/check_item(obj/item/I)
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/food = I
		if(food.eat_effect == /datum/status_effect/debuff/rotfood)
			return FALSE
		if(food.bitecount > 0)
			return FALSE
		if(food.slices_num && food.slices_num < initial(food.slices_num)) // partly-sliced butter etc.
			return FALSE
	return TRUE

// Pegged entries track the market DOWNWARD only. Crown drops its price when the market
// drops (oversupply events, player depositors got cheap), but holds firm when market rises
// (shortage events - players trade peer-to-peer or negotiate with Steward for a manual bump).
/datum/roguestock/proc/refresh_pegged_price()
	if(!pegged || !trade_good_id)
		return
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg)
		return
	var/market_now = max(1, round(tg.base_price * TRADE_STOCKPILE_BUY_DISCOUNT * tg.global_price_mod))
	if(market_now < payout_price)
		payout_price = market_now

/datum/roguestock/proc/get_market_price()
	if(!trade_good_id)
		return payout_price
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg)
		return payout_price
	return max(1, round(tg.base_price * TRADE_STOCKPILE_BUY_DISCOUNT * tg.global_price_mod))

/datum/roguestock/proc/get_market_delta_tag()
	if(pegged)
		return ""
	if(!trade_good_id)
		return ""
	var/market = get_market_price()
	if(market <= 0 || market == payout_price)
		return ""
	var/delta_pct = round(((payout_price - market) / market) * 100)
	if(delta_pct == 0)
		return ""
	if(delta_pct > 0)
		return " <font color='#8a8'>(+[delta_pct]% vs market)</font>"
	else
		return " <font color='#c84'>([delta_pct]% vs market)</font>"

/datum/roguestock/proc/get_export_price()
	if(trade_good_id && SSeconomy)
		var/list/best = SSeconomy.get_best_export_region(trade_good_id)
		if(best && best["unit_price"])
			return round(best["unit_price"] * importexport_amt)
	return payout_price * importexport_amt

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
