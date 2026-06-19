/datum/withdraw_tab
	var/budget = 0
	var/compact = TRUE
	var/current_category = "Raw Materials"
	var/list/categories = list("Raw Materials", "Refined", "Alchemy", "Fruit", "Vegetable", "Animal", "Seafood", "Precious")
	var/obj/structure/roguemachine/parent_structure = null

/datum/withdraw_tab/New(obj/structure/roguemachine/structure_param)
	. = ..()
	parent_structure = structure_param

/datum/withdraw_tab/proc/insert_coins(obj/item/roguecoin/C)
	budget += C.get_real_price()
	qdel(C)
	parent_structure.update_icon()
	playsound(parent_structure.loc, 'sound/misc/coininsert.ogg', 100, TRUE, -1)

/datum/withdraw_tab/proc/get_direct_import_quote(datum/roguestock/D)
	if(!D || !D.trade_good_id)
		return null
	var/list/best = SSeconomy.get_best_import_region(D.trade_good_id)
	if(!best || !best["region_id"])
		return null
	var/datum/economic_region/region = GLOB.economic_regions[best["region_id"]]
	if(!region)
		return null
	var/daily_pace = region.produces[D.trade_good_id] || 0
	var/produces_today = region.produces_today[D.trade_good_id] || 0
	if(daily_pace <= 0 || produces_today <= 0)
		return null
	var/starting_index = max(0, daily_pace - produces_today)
	var/unit_cost = SSeconomy.compute_import_unit_price(D.trade_good_id, region, starting_index + 1)
	var/margin = (SStreasury.royal_custom_active && SStreasury.royal_custom_unlocked) ? SStreasury.royal_custom_margin : ROYAL_CUSTOM_DEFAULT_MARGIN
	var/price = max(1, round(unit_cost * (100 + margin) / 100))
	return list("region" = region, "unit_cost" = unit_cost, "price" = price)

/datum/withdraw_tab/proc/direct_import_price(datum/roguestock/D)
	var/list/quote = get_direct_import_quote(D)
	return quote ? quote["price"] : 0

/datum/withdraw_tab/proc/do_withdraw(datum/roguestock/D, mob/user)
	if(!D || !parent_structure)
		return FALSE
	D.refresh_auto_price()
	var/total_price = D.withdraw_price
	if(D.withdraw_disabled)
		parent_structure.say("Not available.")
		return FALSE
	if(D.stockpile_amount <= 0)
		parent_structure.say("Insufficient stock.")
		return FALSE
	if(total_price > budget)
		if(ishuman(user) && HAS_TRAIT(user, TRAIT_FOOD_STIPEND))
			if(SStreasury.burn(SStreasury.discretionary_fund, total_price, "food stipend - vomitorium"))
				D.stockpile_amount--
				SStreasury.dirty_market_view()
				var/obj/item/I = new D.item_type(parent_structure.loc)
				to_chat(user, span_info("[parent_structure] chitters and squeaks into the treasury ratlines."))
				if(!user.put_in_hands(I))
					I.forceMove(get_turf(user))
				playsound(parent_structure.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				return TRUE
			parent_structure.say("The treasury is barren. Please insert coinage.")
			return FALSE
		parent_structure.say("Insufficient mammon.")
		return FALSE
	D.stockpile_amount--
	SStreasury.dirty_market_view()
	budget -= total_price
	SStreasury.mint(SStreasury.discretionary_fund, total_price, "stockpile withdraw")
	record_round_statistic(STATS_STOCKPILE_REVENUE, total_price)
	var/obj/item/I = new D.item_type(parent_structure.loc)
	if(!user.put_in_hands(I))
		I.forceMove(get_turf(user))
	playsound(parent_structure.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	return TRUE

/datum/withdraw_tab/proc/do_direct_import(datum/roguestock/D, mob/user)
	if(!D || !ishuman(user) || !parent_structure)
		return FALSE
	if(D.withdraw_disabled)
		parent_structure.say("Not available.")
		return FALSE
	if(!D.trade_good_id)
		parent_structure.say("Not available.")
		return FALSE
	var/list/quote = get_direct_import_quote(D)
	if(!quote)
		parent_structure.say("No region currently supplies [D.name].")
		return FALSE
	var/datum/economic_region/region = quote["region"]
	var/unit_cost = quote["unit_cost"]
	var/price = quote["price"]
	var/surcharge = max(0, price - unit_cost)
	if(budget < price)
		parent_structure.say("Insufficient mammon in the coinpouch.")
		return FALSE
	if(SStreasury.discretionary_fund.balance < unit_cost)
		parent_structure.say("The Crown's Purse cannot front the import cost.")
		return FALSE
	var/spent = SSeconomy.manual_import(user, region.region_id, D.trade_good_id, 1)
	if(!spent)
		return FALSE
	D.stockpile_amount = max(0, D.stockpile_amount - 1)
	budget -= price
	SStreasury.mint(SStreasury.discretionary_fund, unit_cost, "Direct import reimbursement: [D.name] from [region.name]")
	SStreasury.economic_output += surcharge
	record_round_statistic(STATS_STOCKPILE_DIRECT_IMPORTS, price)
	var/chartered = SStreasury.royal_custom_active && SStreasury.royal_custom_unlocked
	if(chartered && surcharge > 0)
		SStreasury.mint(SStreasury.discretionary_fund, surcharge, "Royal Custom: direct import of [D.name]")
		record_round_statistic(STATS_STOCKPILE_REVENUE, surcharge)
	var/obj/item/I = new D.item_type(parent_structure.loc)
	if(!user.put_in_hands(I))
		I.forceMove(get_turf(user))
	playsound(parent_structure.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	var/flavor = chartered ? "Royal Custom duty paid to the Crown." : "Import surcharge consumed by transport."
	to_chat(user, span_notice("[D.name] imported from [region.name] for [price]m. [flavor]"))
	return TRUE

/proc/stock_announce(message)
	for(var/obj/structure/roguemachine/stockpile/S in SSroguemachine.stock_machines)
		S.say(message, spans = list("info"))
