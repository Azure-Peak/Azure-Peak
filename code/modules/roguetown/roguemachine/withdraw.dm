/obj/structure/roguemachine/withdraw
	name = "vomitorium"
	desc = "A magitech wall device connected to the local trade network. Buy basic goods, crafting materials, and food here from the town's stock. Imports cost more."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "submit"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/datum/withdraw_tab/withdraw_tab = null

/obj/structure/roguemachine/withdraw/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click with an open hand to open the vomitorium. Put in mammon to fund purchases, then buy goods from the local stockpile.")
	. += span_info("The vomitorium does not buy goods. Take deposits to a stockpile instead.")

/obj/structure/roguemachine/withdraw/Initialize(mapload)
	. = ..()
	SSroguemachine.stock_machines += src
	withdraw_tab = new(src)

/obj/structure/roguemachine/withdraw/Destroy()
	SSroguemachine.stock_machines -= src
	if(withdraw_tab?.budget >= 1)
		refund_pouch(withdraw_tab.budget, custom_turf = get_turf(src))
	return ..()

/obj/structure/roguemachine/withdraw/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/withdraw/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguecoin/aalloy))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		withdraw_tab.insert_coins(P)
		return attack_hand(user)
	..()

/obj/structure/roguemachine/withdraw/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	ui_interact(user)

/obj/structure/roguemachine/withdraw/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Stockpile", name)
		ui.open()

/obj/structure/roguemachine/withdraw/ui_data(mob/user)
	var/list/data = list()
	data["budget"] = withdraw_tab.budget
	data["compact"] = withdraw_tab.compact ? TRUE : FALSE
	data["categories"] = withdraw_tab.categories
	data["category"] = withdraw_tab.current_category
	data["food_stipend"] = (ishuman(user) && HAS_TRAIT(user, TRAIT_ROYAL_SUBSIDY)) ? TRUE : FALSE
	data["subsidy_remaining"] = data["food_stipend"] ? SStreasury.royal_subsidy_remaining(user) : 0
	data["treasury_floor"] = SStreasury.stockpile_purchase_floor
	data["below_floor"] = (SStreasury.discretionary_fund.balance < SStreasury.stockpile_purchase_floor) ? TRUE : FALSE
	data["no_deposit"] = TRUE
	data["next_market_day_minutes"] = max(1, CEILING(seconds_until_dawn() / 60, 1))
	data["title"] = "Vomitorium"
	data["subtitle"] = "Put in mammon, then withdraw goods from the local stockpile."

	var/list/rows = list()
	for(var/datum/roguestock/stockpile/R in SStreasury.stockpile_datums)
		R.refresh_auto_price()
		var/list/shortage = R.get_shortage_progress()
		rows += list(list(
			"ref" = "\ref[R]",
			"name" = R.name,
			"desc" = R.desc,
			"category" = R.category,
			"amount" = R.market_stock,
			"limit" = R.market_target,
			"royal_amount" = R.royal_stock,
			"never_supplied" = R.market_never_supplies ? TRUE : FALSE,
			"sold_out" = (R.market_stock <= 0 && !R.market_has_supply()) ? TRUE : FALSE,
			"next_buy" = R.market_next_buy_change(),
			"next_sell" = R.market_next_sell_change(),
			"segments" = R.market_segments(),
			"market_label" = market_step_label(R.market_step(R.market_stock)),
			"withdraw_price" = R.market_ask(1),
			"deposit_price" = R.market_bid(1),
			"event_tag" = R.get_event_label(),
			"shortage_progress" = shortage ? shortage["progress"] : 0,
			"shortage_target" = shortage ? shortage["target"] : 0,
			"shortage_affected" = shortage ? shortage["affected"] : "",
		))
	data["stocks"] = rows
	data["bounties"] = list()
	return data

/obj/structure/roguemachine/withdraw/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("withdraw")
			var/datum/roguestock/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D)
				return TRUE
			if(withdraw_tab.do_withdraw(D, usr))
				flick("submit_anim", src)
			return TRUE
		if("set_category")
			var/cat = params["category"]
			if(cat == "__conditions__" || (cat in withdraw_tab.categories))
				withdraw_tab.current_category = cat
			return TRUE
		if("toggle_compact")
			withdraw_tab.compact = !withdraw_tab.compact
			return TRUE
		if("refund_budget")
			if(withdraw_tab.refund_budget(usr))
				playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
			return TRUE
