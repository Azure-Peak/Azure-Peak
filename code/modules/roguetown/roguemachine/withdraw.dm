/obj/structure/roguemachine/withdraw
	name = "vomitorium"
	desc = "A magitech wall device connected to the local trade network. Users can buy basic goods, crafting materials, and food for a price from these units, either from in-town or imported for a heftier price."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "submit"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/datum/withdraw_tab/withdraw_tab = null

/obj/structure/roguemachine/withdraw/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click with an open hand to open the vomitorium. Insert mammons to fund purchases, then buy or import goods from the local stockpile.")
	. += span_info("Withdrawals are cheapest. Direct imports pay a surcharge - duty flows to the Crown once Royal Custom is invoked.")
	. += span_info("The vomitorium does not buy goods. Take deposits to a stockpile instead.")

/obj/structure/roguemachine/withdraw/Initialize()
	. = ..()
	SSroguemachine.stock_machines += src
	withdraw_tab = new(src)

/obj/structure/roguemachine/withdraw/Destroy()
	SSroguemachine.stock_machines -= src
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
	data["food_stipend"] = (ishuman(user) && HAS_TRAIT(user, TRAIT_FOOD_STIPEND)) ? TRUE : FALSE
	var/treasury_balance = SStreasury.discretionary_fund?.balance || 0
	data["treasury_floor"] = SStreasury.stockpile_purchase_floor
	data["below_floor"] = treasury_balance < SStreasury.stockpile_purchase_floor
	data["charter_unlocked"] = SStreasury.royal_custom_unlocked ? TRUE : FALSE
	data["charter_active"] = SStreasury.royal_custom_active ? TRUE : FALSE
	data["charter_margin"] = SStreasury.royal_custom_margin
	data["charter_volume"] = SStreasury.economic_output || 0
	data["charter_threshold"] = SStreasury.royal_custom_threshold
	data["no_deposit"] = TRUE
	data["title"] = "Vomitorium"
	data["subtitle"] = "Insert mammons, then withdraw goods from the local stockpile or import from afar."

	var/list/rows = list()
	for(var/datum/roguestock/stockpile/R in SStreasury.stockpile_datums)
		R.refresh_auto_price()
		var/list/shortage = R.get_shortage_progress()
		var/export_unit_price = 0
		if(R.importexport_amt > 0)
			export_unit_price = round(R.get_export_price() / R.importexport_amt)
		rows += list(list(
			"ref" = "\ref[R]",
			"name" = R.name,
			"desc" = R.desc,
			"category" = R.category,
			"amount" = R.stockpile_amount,
			"limit" = R.stockpile_limit,
			"withdraw_price" = R.withdraw_price,
			"deposit_price" = R.payout_price,
			"export_price" = export_unit_price,
			"import_price" = withdraw_tab.direct_import_price(R),
			"withdraw_disabled" = R.withdraw_disabled ? TRUE : FALSE,
			"accept_enabled" = R.accept_toggle_enabled ? TRUE : FALSE,
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
			if(withdraw_tab.budget > 0)
				budget2change(withdraw_tab.budget, usr)
				withdraw_tab.budget = 0
				playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
			return TRUE
		if("direct_import")
			var/datum/roguestock/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D)
				return TRUE
			if(withdraw_tab.do_direct_import(D, usr))
				flick("submit_anim", src)
			return TRUE
