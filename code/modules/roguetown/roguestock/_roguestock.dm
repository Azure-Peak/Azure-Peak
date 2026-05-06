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
			compute_auto_prices(tg)
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

/// Auto-pricing pegs to the global pre-blockade reference for each side, so the Crown
/// always profits at least 1m on any single transaction cycle:
///   buy  = min(0.75 * export_ref, export_ref - 1m), floored at 1m
///   sell = max(1.25 * import_ref, import_ref + 1m), floored at 1m
/// where import_ref = base * global_price_mod and export_ref = import_ref * (1 - SPREAD).
/// Buy uses min so the Crown skims at least 25% off export at scale; sell uses max so the
/// Crown marks up at least 25% over import at scale. At small base prices the +/-1m bound
/// dominates; at larger base prices the 25% bound takes over. No regional lookup, no
/// blockade dependency - stewards manually intervene during regional shortages or
/// blockades if they want to fine-tune.
/datum/roguestock/proc/compute_auto_prices(datum/trade_good/tg)
	if(!tg)
		return
	var/import_ref = max(1, round(tg.base_price * tg.global_price_mod))
	var/export_ref = max(1, round(tg.base_price * tg.global_price_mod * (1 - IMPORT_EXPORT_SPREAD)))
	var/buy_target = min(round(export_ref * (1 - IMPORT_EXPORT_SPREAD)), export_ref - 1)
	payout_price = max(1, buy_target)
	var/sell_target = max(round(import_ref * (1 + IMPORT_EXPORT_SPREAD)), import_ref + 1)
	withdraw_price = max(1, sell_target)

/datum/roguestock/proc/refresh_auto_price()
	if(!automatic_price || !trade_good_id)
		return
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg)
		return
	compute_auto_prices(tg)

/datum/roguestock/proc/snap_auto_prices()
	if(!trade_good_id)
		return
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg)
		return
	compute_auto_prices(tg)

/datum/roguestock/proc/get_market_deposit_price()
	if(!trade_good_id)
		return payout_price
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg)
		return payout_price
	var/export_ref = max(1, round(tg.base_price * tg.global_price_mod * (1 - IMPORT_EXPORT_SPREAD)))
	return max(1, min(round(export_ref * (1 - IMPORT_EXPORT_SPREAD)), export_ref - 1))

/datum/roguestock/proc/get_market_withdraw_price()
	if(!trade_good_id)
		return withdraw_price
	var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
	if(!tg)
		return withdraw_price
	var/import_ref = max(1, round(tg.base_price * tg.global_price_mod))
	return max(1, max(round(import_ref * (1 + IMPORT_EXPORT_SPREAD)), import_ref + 1))

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


