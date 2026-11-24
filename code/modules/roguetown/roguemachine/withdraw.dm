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
	var/wage_reserve = data["food_stipend"] ? SStreasury.get_expected_wage_outlay() : 0
	data["wage_reserve"] = wage_reserve
	data["below_reserve"] = (data["food_stipend"] && SStreasury.discretionary_fund.balance < wage_reserve) ? TRUE : FALSE
	data["no_deposit"] = TRUE
	if((user.job in GLOB.atc_positions) && SSmerchant_trade)
		data["export_licence"] = list(
			"left" = SSmerchant_trade.export_licence_left(),
			"total" = SSmerchant_trade.export_licence_allowance(),
		)
	data["next_market_day_minutes"] = max(1, CEILING(seconds_until_market_day() / 60, 1))
	data["title"] = "Vomitorium"
	data["subtitle"] = "Put in mammon, then withdraw goods from the local stockpile."

	withdraw_tab.add_stock_rows(data)
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
