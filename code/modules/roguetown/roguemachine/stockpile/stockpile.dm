/obj/structure/roguemachine/stockpile
	name = "stockpile"
	desc = "A magickal device connected to the trade network of the city. You can buy and sell basic goods, crafting materials and other things here with the market of the city."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "stockpile_vendor"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/current_category = "Raw Materials"
	var/list/categories = list("Raw Materials", "Refined", "Alchemy", "Fruit", "Vegetable", "Animal", "Seafood")
	var/datum/withdraw_tab/withdraw_tab = null

/obj/structure/roguemachine/stockpile/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click with an open hand to see the stockpile. Put in mammon to buy goods from it.")
	. += span_info("Left-click the machine with an item to sell it into the stockpile. You're paid into your MEISTER account. The machine won't take your goods unless you have an account.")
	. += span_info("Right-clicking the machine will automatically load all adjacent items into the stockpile at once.")
	. += span_info("Goods sold here go into the market or the royal stockpile. This changes the market price.")
/obj/structure/roguemachine/stockpile/Initialize(mapload)
	. = ..()
	SSroguemachine.stock_machines += src
	withdraw_tab = new(src)


/obj/structure/roguemachine/stockpile/Destroy()
	SSroguemachine.stock_machines -= src
	if(withdraw_tab?.budget >= 1)
		refund_pouch(withdraw_tab.budget, custom_turf = get_turf(src))
	return ..()

/obj/structure/roguemachine/stockpile/examine(mob/user)
	. = ..()
	. += span_info("Right-click to sell everything in front of the stockpile.")

/obj/structure/roguemachine/stockpile/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/stockpile/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	ui_interact(user)

/obj/structure/roguemachine/stockpile/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Stockpile", name)
		ui.open()

/obj/structure/roguemachine/stockpile/ui_data(mob/user)
	var/list/data = list()
	data["budget"] = withdraw_tab.budget
	data["compact"] = withdraw_tab.compact ? TRUE : FALSE
	data["categories"] = categories
	data["category"] = withdraw_tab.current_category
	data["food_stipend"] = (ishuman(user) && HAS_TRAIT(user, TRAIT_ROYAL_SUBSIDY)) ? TRUE : FALSE
	data["subsidy_remaining"] = data["food_stipend"] ? SStreasury.royal_subsidy_remaining(user) : 0
	data["treasury_floor"] = SStreasury.stockpile_purchase_floor
	data["below_floor"] = (SStreasury.discretionary_fund.balance < SStreasury.stockpile_purchase_floor) ? TRUE : FALSE
	data["no_deposit"] = FALSE
	data["next_market_day_minutes"] = max(1, CEILING(seconds_until_dawn() / 60, 1))
	data["title"] = ""
	data["subtitle"] = ""

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

	// The treasure-mint bounty was removed; no bounty datums remain. Keep the key so the
	// Stockpile TGUI's bounty section simply stays hidden (it gates on bounties.length).
	data["bounties"] = list()
	return data

/obj/structure/roguemachine/stockpile/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("withdraw")
			var/datum/roguestock/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D)
				return TRUE
			withdraw_tab.do_withdraw(D, usr)
			return TRUE
		if("set_category")
			var/cat = params["category"]
			if(cat == "__conditions__" || (cat in categories))
				withdraw_tab.current_category = cat
				current_category = cat
			return TRUE
		if("toggle_compact")
			withdraw_tab.compact = !withdraw_tab.compact
			return TRUE
		if("refund_budget")
			if(withdraw_tab.refund_budget(usr))
				playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
			return TRUE

/obj/structure/roguemachine/stockpile/proc/attemptsell(obj/item/I, mob/H, message = TRUE, sound = TRUE)
	if(istype(I, /obj/structure/handcart)) // Handle carts specially - sell their contents, leave the empty cart
		var/obj/structure/handcart/cart = I
		var/turf/cart_location = get_turf(cart)
		var/list/cart_contents = cart.contained_items.Copy()
		for(var/atom/movable/cart_content in cart_contents) // Process all items inside the cart first
			if(isitem(cart_content))
				attemptsell(cart_content, H, message, FALSE)

		for(var/atom/movable/remaining_item in cart_contents) // Any items that weren't sold (still exist) go to the ground
			if(!QDELETED(remaining_item))
				cart.remove_from(remaining_item)
				remaining_item.forceMove(cart_location)
		// Setting cart back to square 1
		cart.contained_items = list()
		cart.current_capacity = 0
		cart.update_icon()
		if(sound == TRUE)
			playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		return

	if(istype(I, /obj/item/roguebin)) // Handle roguebins specially - sell their contents, leave the empty bin
		var/obj/item/roguebin/bin = I
		var/turf/bin_location = get_turf(bin)
		var/list/bin_contents = bin.held_contents()
		for(var/obj/item/bin_item in bin_contents) // Process all items inside the bin first
			attemptsell(bin_item, H, message, FALSE)

		for(var/obj/item/remaining_item in bin_contents) // Any items that weren't sold (still exist) go to the ground
			if(!QDELETED(remaining_item))
				bin.release_held(remaining_item, bin_location)
		if(sound == TRUE)
			playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		return

	// Pre-check: farmer must have a Meister account. Otherwise the stockpile would silently
	// eat their goods for no payment - do not scam walk-ins.
	var/has_account = SStreasury.has_account(H)
	if(!has_account)
		if(message)
			say("No account found for [H]. Submit your fingers to a Meister for inspection.")
		return

	for(var/datum/roguestock/R in SStreasury.stockpile_datums)
		if(istype(I, /obj/item/natural/bundle))
			var/obj/item/natural/bundle/B = I
			if(B.stacktype != R.item_type)
				continue
			var/bundle_amt = B.amount
			R.refresh_auto_price()
			qdel(B)
			SStreasury.dirty_market_view()
			if(message == TRUE)
				stock_announce("[bundle_amt] units of [R.name] have been stockpiled.")
			if(sound == TRUE)
				playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
			credit_economic_event_saturation(R.trade_good_id, bundle_amt)
			if(HAS_TRAIT(H, TRAIT_ROYAL_SUBSIDY))
				deposit_to_royal_stock(R, bundle_amt, H)
				return
			var/amt = R.market_bid(bundle_amt)
			R.market_stock += bundle_amt
			var/paid = pay_seller(H, amt, "from selling [bundle_amt] [R.name]")
			SStreasury.economic_output += paid
			return
		else if(istype(I,R.item_type))
			if(!R.check_item(I))
				continue
			R.refresh_auto_price()
			var/list/settlement = R.get_quality_settlement(I, R.market_bid(1))
			var/amt = settlement["seller_payout"]
			var/quality_baseline = settlement["baseline"]
			var/true_value = I.get_real_price()
			if(message && I.has_item_quality && I.item_quality != ITEM_QUALITY_STANDARD)
				var/flavor = quality_delta_flavor(I.item_quality)
				if(flavor)
					say(flavor)
					to_chat(H, span_info("[src] says, \"[flavor]\""))
			qdel(I)
			SStreasury.dirty_market_view()
			if(message == TRUE)
				stock_announce("[R.name] has been stockpiled.")
			if(sound == TRUE)
				playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
			credit_economic_event_saturation(R.trade_good_id, 1)
			if(HAS_TRAIT(H, TRAIT_ROYAL_SUBSIDY))
				deposit_to_royal_stock(R, 1, H)
				return
			R.market_stock += 1
			SStreasury.economic_output += true_value
			var/reason = "from selling [R.name]"
			var/seller_delta = mammon_round(amt - quality_baseline)
			if(seller_delta)
				reason = "from selling [R.name] (quality [seller_delta > 0 ? "+" : ""][format_mammon(seller_delta)]m against the usual [format_mammon(quality_baseline)]m)"
			pay_seller(H, amt, reason)
			record_round_statistic(STATS_STOCKPILE_REVENUE, true_value)
			return

	// Nothing in the stockpile accepted this item
	if(message)
		say("[I.name] isn't accepted here.")

/obj/structure/roguemachine/stockpile/proc/pay_seller(mob/H, amount, reason)
	amount = mammon_round(amount)
	if(amount <= 0)
		return 0
	SStreasury.give_money_account(amount, H, "+[format_mammon(amount)]m [reason]", mint_new = TRUE, mint_label = "the market", income_acct = LEDGER_CITIZEN_SALES)
	record_round_statistic(STATS_STOCKPILE_EXPANSES, amount)
	return amount

/obj/structure/roguemachine/stockpile/proc/deposit_to_royal_stock(datum/roguestock/R, units, mob/H)
	R.royal_stock += units
	SStreasury.log_fund_entry(new /datum/treasury_entry(null, SStreasury.discretionary_fund, SStreasury.discretionary_fund, 0, "Subsidy Deposit: [units] [R.name] by [H.real_name]"))
	send_ooc_note("<b>MEISTER:</b> Your [R.name] goes into the royal stockpile.", name = H.real_name)

/obj/structure/roguemachine/stockpile/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguecoin/aalloy))
		return

	if(istype(P, /obj/item/roguecoin/inqcoin))
		return

	if(istype(P, /obj/item/roguecoin))
		withdraw_tab.insert_coins(P)
		return attack_hand(user)
	else if (ishuman(user))
		attemptsell(P, user, TRUE, TRUE)

/obj/structure/roguemachine/stockpile/attack_right(mob/user)
	if(ishuman(user))
		for(var/obj/I in get_turf(src))
			attemptsell(I, user, FALSE, FALSE)
		say("Bulk selling in progress...")
		playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)


