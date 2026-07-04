/datum/roguestock
	var/name = ""
	var/desc = ""
	var/item_type = null
	var/stockpile_amount = 0
	var/payout_price = 1
	var/withdraw_price = 1
	var/withdraw_disabled = FALSE
	var/stockpile_limit = 100
	var/importexport_amt = 10
	var/category = "Raw Materials"
	var/trade_good_id
	var/accept_toggle_enabled = TRUE
	var/automatic_price = TRUE
	var/automatic_limit = TRUE
	var/cached_market_deposit_price = 0
	var/cached_market_withdraw_price = 0

/datum/roguestock/New()
	..()
	if(trade_good_id)
		var/datum/trade_good/tg = GLOB.trade_goods[trade_good_id]
		if(tg)
			compute_auto_prices(tg)
			recompute_market_reference_prices(tg)
	return

/datum/roguestock/proc/get_payout_price(obj/item/I)
	return payout_price

/datum/roguestock/proc/get_quality_settlement(obj/item/I)
	var/baseline = get_payout_price(I)
	var/list/out = list(
		"seller_payout" = baseline,
		"crown_delta" = 0,
		"baseline" = baseline,
		"q_mult" = 1.0,
	)
	if(!istype(I) || !I.has_item_quality)
		return out
	var/q_mult = ITEM_QUALITY_MULT(I.item_quality)
	if(q_mult == 1.0)
		return out
	var/buy_price = baseline * q_mult
	var/loss = baseline - buy_price
	var/seller_payout = buy_price - (loss * STOCKPILE_QUALITY_LOSS_SELLER_SHARE)
	out["seller_payout"] = max(1, round(seller_payout))
	out["crown_delta"] = round(-loss * (1 - STOCKPILE_QUALITY_LOSS_SELLER_SHARE))
	out["q_mult"] = q_mult
	return out

/datum/roguestock/proc/check_item(obj/item/I)
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/food = I
		if(food.eat_effect == /datum/status_effect/debuff/rotfood)
			return FALSE
		if(food.bitecount > 0)
			return FALSE
		if(food.slices_num && food.slices_num < initial(food.slices_num))
			return FALSE
	return TRUE

/// Sell matches import exactly so auto-pricing doesn't compound shortage spikes
/// (global_price_mod can hit 4-5x). The IMPORT_EXPORT_SPREAD baked into export_ref <
/// import_ref is the only built-in Crown margin; stewards mark up withdraw manually
/// if they want profit on a shortage import.
/datum/roguestock/proc/compute_auto_prices(datum/trade_good/tg)
	if(!tg)
		return
	var/unit_price = (tg.item_type && GLOB.derived_sellprices[tg.item_type]) || tg.base_price
	var/import_ref = max(1, round(unit_price * tg.global_price_mod))
	var/export_ref = max(1, round(unit_price * tg.global_price_mod * (1 - IMPORT_EXPORT_SPREAD)))
	var/buy_target = min(round(export_ref * (1 - IMPORT_EXPORT_SPREAD)), export_ref - 1)
	payout_price = max(1, buy_target)
	withdraw_price = import_ref

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
	return cached_market_deposit_price || payout_price

/datum/roguestock/proc/get_market_withdraw_price()
	if(!trade_good_id)
		return withdraw_price
	return cached_market_withdraw_price || withdraw_price
/datum/roguestock/proc/recompute_market_reference_prices(datum/trade_good/tg)
	if(!trade_good_id)
		return
	if(!tg)
		tg = GLOB.trade_goods[trade_good_id]
	if(!tg)
		return
	var/unit_price = (tg.item_type && GLOB.derived_sellprices[tg.item_type]) || tg.base_price
	var/export_ref = max(1, round(unit_price * tg.global_price_mod * (1 - IMPORT_EXPORT_SPREAD)))
	cached_market_deposit_price = max(1, min(round(export_ref * (1 - IMPORT_EXPORT_SPREAD)), export_ref - 1))
	cached_market_withdraw_price = max(1, round(unit_price * tg.global_price_mod))

/datum/roguestock/proc/get_market_price()
	return get_market_deposit_price()

/datum/roguestock/proc/get_market_delta_tag()
	return get_market_delta_tag_for("deposit")

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
	else
		if(delta_pct > 0)
			label = "premium"
			color = "#8a8"
		else
			label = "underpaid"
			color = "#c84"
	return " <font color='[color]'>([sign_str]% [label])</font>"

/// Returns "SHORTAGE", "GLUT", or "" - the plain event label without HTML.
/datum/roguestock/proc/get_event_label()
	if(!trade_good_id)
		return ""
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		if(!(trade_good_id in E.affected_goods))
			continue
		if(E.event_type == ECON_EVENT_SHORTAGE)
			return "SHORTAGE"
		if(E.event_type == ECON_EVENT_OVERSUPPLY)
			return "GLUT"
	return ""

/datum/roguestock/proc/get_shortage_progress()
	if(!trade_good_id)
		return null
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		if(E.event_type != ECON_EVENT_SHORTAGE)
			continue
		if(!(trade_good_id in E.affected_goods))
			continue
		var/list/good_names = list()
		for(var/good_id in E.affected_goods)
			var/datum/trade_good/tg = GLOB.trade_goods[good_id]
			good_names += (tg && tg.name) ? tg.name : good_id
		return list(
			"progress" = E.saturation_progress,
			"target" = E.saturation_target,
			"affected" = jointext(good_names, ", "),
		)
	return null

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


