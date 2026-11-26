/datum/withdraw_tab
	var/budget = 0
	var/compact = TRUE
	var/current_category = "Raw Materials"
	var/list/categories = list("Raw Materials", "Refined", "Alchemy", "Fruit", "Vegetable", "Animal", "Seafood")
	var/obj/structure/roguemachine/parent_structure = null

/datum/withdraw_tab/New(obj/structure/roguemachine/structure_param)
	. = ..()
	parent_structure = structure_param

/datum/withdraw_tab/proc/insert_coins(obj/item/roguecoin/C)
	budget += C.get_real_price()
	qdel(C)
	parent_structure.update_icon()
	playsound(parent_structure.loc, 'sound/misc/coininsert.ogg', 100, TRUE, -1)

/datum/withdraw_tab/proc/refund_budget(mob/user)
	if(budget <= 0)
		return FALSE
	if(floor(mammon_round(budget)) < 1)
		return FALSE
	budget = refund_pouch(budget, user)
	return TRUE

/datum/withdraw_tab/proc/add_stock_rows(list/data)
	var/list/rows = list()
	var/conditions = 0
	var/conditions_tab = current_category == "__conditions__"
	for(var/datum/roguestock/stockpile/R in SStreasury.stockpile_datums)
		var/list/row = R.market_row()
		var/has_event = row["event_tag"] ? TRUE : FALSE
		if(has_event)
			conditions++
		if(conditions_tab ? has_event : R.category == current_category)
			rows += list(row)
	data["stocks"] = rows
	data["conditions_count"] = conditions

/datum/withdraw_tab/proc/do_withdraw(datum/roguestock/D, mob/user)
	if(!D || !parent_structure)
		return FALSE
	if(get_dist(parent_structure, user) > 1)
		return FALSE
	D.refresh_auto_price()
	if(D.market_never_supplies)
		parent_structure.say("Not available.")
		return FALSE
	var/market_open = D.market_available() > 0
	var/total_price = D.market_ask(1)
	var/subsidy = ishuman(user) && HAS_TRAIT(user, TRAIT_ROYAL_SUBSIDY) && SStreasury.royal_subsidy_remaining(user) >= total_price
	var/from_royal_stock = subsidy && D.royal_stock > 0
	var/treasury_pays = subsidy && !from_royal_stock && market_open && SStreasury.royal_subsidy_treasury_covers(total_price)
	if(from_royal_stock)
		D.royal_stock--
		SStreasury.spend_royal_subsidy(user, total_price)
		SStreasury.log_fund_entry(new /datum/treasury_entry(null, SStreasury.discretionary_fund, SStreasury.discretionary_fund, 0, "Subsidy Withdraw: [D.name] by [user.real_name]"))
	else
		if(!market_open)
			parent_structure.say("Out of stock.")
			return FALSE
		if(treasury_pays)
			if(!SStreasury.burn(SStreasury.discretionary_fund, total_price, "Royal Subsidy: [D.name] for [user.real_name]", LEDGER_CROWN_EXP_STOCKPILE))
				return FALSE
			SStreasury.spend_royal_subsidy(user, total_price)
			record_treasury_expense(TREASURY_FLOW_SUBSIDY, treasury_role_of(user), total_price)
		else
			if(total_price > mammon_round(budget))
				parent_structure.say("You haven't put in enough mammon.")
				return FALSE
			budget = max(0, mammon_round(budget - total_price))
			record_round_statistic(STATS_STOCKPILE_REVENUE, total_price)
		D.market_stock--
		D.check_glut_relief()
		debit_economic_event_saturation(D.trade_good_id, 1)
	SStreasury.dirty_market_view(D)
	var/licensed = !from_royal_stock && !treasury_pays && (user.job in GLOB.atc_positions) && SSmerchant_trade?.export_licence_left() >= total_price
	if(licensed)
		SSmerchant_trade.export_licence_spent += total_price
	var/obj/item/I = new D.item_type(parent_structure.loc)
	I.stockpile_stamped = !licensed
	I.sellprice = max(1, round(total_price))
	I.static_price = TRUE
	if(from_royal_stock)
		to_chat(user, span_info("[parent_structure] chitters and squeaks."))
	else if(treasury_pays)
		to_chat(user, span_info("[parent_structure] chitters and squeaks. Paid from royal subsidy."))
	if(!user.put_in_hands(I))
		I.forceMove(get_turf(user))
	playsound(parent_structure.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	return TRUE

/proc/stock_announce(message)
	for(var/obj/structure/roguemachine/stockpile/S in SSroguemachine.stock_machines)
		S.say(message, spans = list("info"))
