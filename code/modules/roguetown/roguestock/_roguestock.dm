/datum/roguestock
	var/name = ""
	var/desc = ""
	var/item_type = null
	var/stockpile_amount = 0
	var/payout_price = 1
	var/withdraw_disabled = FALSE
	var/mint_item = FALSE
	var/stockpile_limit = 100
	var/importexport_amt = 10
	var/percent_bounty = FALSE
	var/category = "Raw Materials"
	var/trade_good_id
	var/accept_toggle_enabled = TRUE
	var/pegged = TRUE

/datum/roguestock/New()
	..()
	// Peg payout_price to the trade good catalog at roundstart. Subtypes that need a
	// manual override can still set payout_price directly; most should just inherit.
	if(trade_good_id)
		var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
		if(tg)
			payout_price = max(1, round(tg.base_price * TRADE_STOCKPILE_BUY_DISCOUNT))
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

/// Context-aware variant. `side` is "deposit" or "withdraw".
/// A positive delta is a premium when depositing (you get more than market), markup when withdrawing (Crown charges more than market).
/// A negative delta is a discount when withdrawing (cheaper than market), lowball when depositing.
/datum/roguestock/proc/get_market_delta_tag_for(side)
	if(!trade_good_id)
		return ""
	var/market = get_market_price()
	if(market <= 0 || market == payout_price)
		return ""
	var/delta_pct = round(((payout_price - market) / market) * 100)
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
	return payout_price * importexport_amt


