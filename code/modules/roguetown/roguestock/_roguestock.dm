/datum/roguestock
	var/name = ""
	var/desc = ""
	var/item_type = null
	var/stockpile_amount = 0
	var/payout_price = 1
	var/withdraw_price = 1
	var/withdraw_disabled = FALSE
	var/mint_item = FALSE
	var/stockpile_limit = 100
	var/importexport_amt = 10
	var/percent_bounty = FALSE
	var/category = "Raw Materials"
	var/trade_good_id
	var/accept_toggle_enabled = TRUE
	var/automatic_price = TRUE
	var/automatic_limit = TRUE

/datum/roguestock/New()
	..()
	if(trade_good_id)
		var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
		if(tg)
			var/payout_target = tg.base_price * (1 - IMPORT_EXPORT_SPREAD)
			if(tg.global_price_mod < 1.0)
				payout_target *= tg.global_price_mod
			payout_price = max(1, FLOOR(payout_target, 1))
			var/min_margin = max(1, round(tg.base_price * 0.1))
			withdraw_price = max(payout_price + min_margin, round(tg.base_price * tg.global_price_mod))
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

/// Deposit auto-price tracks gluts downward but ignores shortage upticks: the Crown must
/// not chase shortage prices up (it would buy at export parity and earn nothing on the
/// cycle), but during a glut the wider market is paying less, so the Crown should too.
/// Withdraw auto-price keeps a downward-only ratchet against the modulated market so
/// gluts pass through to citizens at the till.
/datum/roguestock/proc/refresh_auto_price()
	if(!automatic_price || !trade_good_id)
		return
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg)
		return
	var/withdraw_market = max(1, round(tg.base_price * tg.global_price_mod))
	var/payout_target = tg.base_price * (1 - IMPORT_EXPORT_SPREAD)
	if(tg.global_price_mod < 1.0)
		payout_target *= tg.global_price_mod
	payout_price = max(1, FLOOR(payout_target, 1))
	// Auto-ratchet must clear payout by a minimum margin, or the Crown earns nothing on
	// the cycle. Stewards can still manually undercut. Margin is 10% of base, min 1.
	var/min_margin = max(1, round(tg.base_price * 0.1))
	var/withdraw_floor = payout_price + min_margin
	if(withdraw_market < withdraw_floor)
		withdraw_market = withdraw_floor
	if(withdraw_market < withdraw_price)
		withdraw_price = withdraw_market

/datum/roguestock/proc/snap_auto_prices()
	if(!trade_good_id)
		return
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg)
		return
	var/payout_target = tg.base_price * (1 - IMPORT_EXPORT_SPREAD)
	if(tg.global_price_mod < 1.0)
		payout_target *= tg.global_price_mod
	payout_price = max(1, FLOOR(payout_target, 1))
	var/min_margin = max(1, round(tg.base_price * 0.1))
	withdraw_price = max(payout_price + min_margin, round(tg.base_price * tg.global_price_mod))

/datum/roguestock/proc/get_market_deposit_price()
	if(!trade_good_id)
		return payout_price
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg)
		return payout_price
	var/payout_target = tg.base_price * (1 - IMPORT_EXPORT_SPREAD)
	if(tg.global_price_mod < 1.0)
		payout_target *= tg.global_price_mod
	return max(1, FLOOR(payout_target, 1))

/// Withdraw anchor is the *auto-target* the ratchet aims at, not the raw modulated
/// market: during a shortage the modulated market is high but auto-withdraw refuses
/// to follow it up, and reporting the inflated number as "market" makes a held-line
/// price look like a discount when it is just the baseline.
/datum/roguestock/proc/get_market_withdraw_price()
	if(!trade_good_id)
		return withdraw_price
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg)
		return withdraw_price
	var/baseline = max(1, round(tg.base_price))
	var/modulated = max(1, round(tg.base_price * tg.global_price_mod))
	return min(baseline, modulated)

/datum/roguestock/proc/get_market_price()
	return get_market_deposit_price()

/datum/roguestock/proc/get_market_delta_tag()
	return get_market_delta_tag_for("deposit")

/// `side` is "deposit" or "withdraw". Compares the active price against its own market anchor.
/datum/roguestock/proc/get_market_delta_tag_for(side)
	if(!trade_good_id)
		return ""
	var/market
	var/active_price
	if(side == "withdraw")
		market = get_market_withdraw_price()
		active_price = withdraw_price
	else
		market = get_market_deposit_price()
		active_price = payout_price
	if(market <= 0 || market == active_price)
		return ""
	var/delta_pct = round(((active_price - market) / market) * 100)
	if(delta_pct == 0)
		return ""
	var/sign_str = delta_pct > 0 ? "+[delta_pct]" : "[delta_pct]"
	var/label
	var/color
	if(side == "withdraw")
		if(delta_pct > 0)
			label = "markup"
			color = "#c84"
		else
			label = "discount"
			color = "#8a8"
	else // deposit
		if(delta_pct > 0)
			label = "premium"
			color = "#8a8"
		else
			label = "underpaid"
			color = "#c84"
	return " <font color='[color]'>([sign_str]% [label])</font>"

/// Returns a span tag naming the active event affecting this good, or "" if none.
/datum/roguestock/proc/get_event_tag()
	if(!trade_good_id)
		return ""
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		if(!(trade_good_id in E.affected_goods))
			continue
		var/label
		var/color
		if(E.event_type == ECON_EVENT_SHORTAGE)
			label = "SHORTAGE"
			color = "#c44"
		else if(E.event_type == ECON_EVENT_OVERSUPPLY)
			label = "GLUT"
			color = "#5cb85c"
		else
			continue
		return " <font color='[color]'><b>([label])</b></font>"
	return ""

/datum/roguestock/proc/get_export_price()
	if(trade_good_id && SSeconomy)
		var/list/best = SSeconomy.get_best_export_region(trade_good_id)
		if(best && best["unit_price"])
			return round(best["unit_price"] * importexport_amt)
	return payout_price * importexport_amt

/datum/roguestock/proc/get_import_price()
	return withdraw_price * importexport_amt


