/obj/structure/roguemachine/stockpile
	name = "stockpile"
	desc = "A magitech device connected to the trade network. Users can buy basic goods, crafting materials, and food for a price from these units, or sell them here for money."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "stockpile_vendor"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/current_category = "Raw Materials"
	var/list/categories = list("Raw Materials", "Refined", "Alchemy", "Fruit", "Vegetable", "Animal", "Seafood", "Precious")
	var/datum/withdraw_tab/withdraw_tab = null

/obj/structure/roguemachine/stockpile/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click with an open hand to check the vomitorium's stockpile. Stored mammons can be used to purchase a wide variety of materials, which're then vended out for use.")
	. += span_info("Left-clicking the machine with an item will load it into the stockpile, rewarding you coinage in turn. Make sure to register an account with the MEISTER, first, or you won't receive any coinage.")
	. += span_info("Right-clicking the machine will automatically load all adjacent items into the stockpile at once.")
	. += span_info("The vomitorium's stockpile naturally refills over time. Loaded items are added to the stockpile's quantities, which can then be vended by others or exported by the Steward for profit.")
	. += span_info("The vomitorium can also accept treasures, gemstones, and many other valuables that're particularly expensive; a portion of it is always taxed and returned to the Steward's treasury.")

/obj/structure/roguemachine/stockpile/Initialize()
	. = ..()
	SSroguemachine.stock_machines += src
	withdraw_tab = new(src)


/obj/structure/roguemachine/stockpile/Destroy()
	SSroguemachine.stock_machines -= src
	return ..()

/obj/structure/roguemachine/stockpile/examine(mob/user)
	. = ..()
	. += span_info("Right click to sell everything in front of the stockpile.")
	if(SStreasury.royal_custom_unlocked)
		. += span_info(SStreasury.royal_custom_active ? "Royal Custom is in force; direct imports pay duty to the Crown." : "Royal Custom is chartered but suspended.")
	else
		var/v = SStreasury.economic_output || 0
		. += span_info("Royal Custom Charter unlocks at [SStreasury.royal_custom_threshold] mammon of stockpile trade ([v] so far).")

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
	check_charter_unlock()
	var/list/data = list()
	data["budget"] = withdraw_tab.budget
	data["compact"] = withdraw_tab.compact ? TRUE : FALSE
	data["categories"] = categories
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

	var/list/rows = list()
	for(var/datum/roguestock/stockpile/R in SStreasury.stockpile_datums)
		R.refresh_auto_price()
		rows += list(list(
			"ref" = "\ref[R]",
			"name" = R.name,
			"desc" = R.desc,
			"category" = R.category,
			"amount" = R.stockpile_amount,
			"limit" = R.stockpile_limit,
			"withdraw_price" = R.withdraw_price,
			"deposit_price" = R.payout_price,
			"import_price" = direct_import_price(R),
			"withdraw_disabled" = R.withdraw_disabled ? TRUE : FALSE,
			"accept_enabled" = R.accept_toggle_enabled ? TRUE : FALSE,
			"event_tag" = R.get_event_label(),
		))
	data["stocks"] = rows

	var/list/bounties = list()
	for(var/datum/roguestock/bounty/B in SStreasury.stockpile_datums)
		bounties += list(list(
			"name" = B.name,
			"payout_price" = B.payout_price,
			"percent" = B.percent_bounty ? TRUE : FALSE,
		))
	data["bounties"] = bounties
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
			do_withdraw(D, usr)
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
			if(withdraw_tab.budget > 0)
				budget2change(withdraw_tab.budget, usr)
				withdraw_tab.budget = 0
				playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
			return TRUE
		if("direct_import")
			var/datum/roguestock/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D)
				return TRUE
			do_direct_import(D, usr)
			return TRUE

/obj/structure/roguemachine/stockpile/proc/check_charter_unlock()
	if(SStreasury.royal_custom_unlocked)
		return
	var/volume = SStreasury.economic_output || 0
	if(volume < SStreasury.royal_custom_threshold)
		return
	SStreasury.royal_custom_unlocked = TRUE
	SStreasury.royal_custom_active = TRUE
	scom_announce("The Stewardry has tallied [SStreasury.royal_custom_threshold] mammons of trade. By ancient charter, the Crown's Right of Customs in Excess is invoked - duties that once paid for the middleman's cut now flow into the Crown's purse instead. The Steward may set the rate at the Stewardry.")
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.client || !H.mind)
			continue
		if(H.mind.assigned_role == "Steward")
			send_ooc_note("<b>Royal Custom unlocked.</b> Import surcharges at every stockpile now flow to the Crown's purse. Adjust the margin at your Trading Interface.", name = H.real_name)

/obj/structure/roguemachine/stockpile/proc/direct_import_price(datum/roguestock/D)
	if(!D)
		return 0
	D.refresh_auto_price()
	var/margin = (SStreasury.royal_custom_active && SStreasury.royal_custom_unlocked) ? SStreasury.royal_custom_margin : ROYAL_CUSTOM_DEFAULT_MARGIN
	return max(1, round(D.withdraw_price * (100 + margin) / 100))

/obj/structure/roguemachine/stockpile/proc/do_direct_import(datum/roguestock/D, mob/user)
	if(!D || !ishuman(user))
		return
	if(D.withdraw_disabled)
		say("Not available.")
		return
	var/price = direct_import_price(D)
	if(withdraw_tab.budget < price)
		say("Insufficient mammon in the coinpouch.")
		return
	withdraw_tab.budget -= price
	SStreasury.economic_output += price
	record_round_statistic(STATS_STOCKPILE_DIRECT_IMPORTS, price)
	var/chartered = SStreasury.royal_custom_active && SStreasury.royal_custom_unlocked
	if(chartered)
		SStreasury.mint(SStreasury.discretionary_fund, price, "Royal Custom: direct import of [D.name]")
		record_round_statistic(STATS_STOCKPILE_REVENUE, price)
	var/obj/item/I = new D.item_type(loc)
	if(!user.put_in_hands(I))
		I.forceMove(get_turf(user))
	playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	var/flavor = chartered ? "Royal Custom duty paid to the Crown." : "Import surcharge consumed by transport."
	to_chat(user, span_notice("[D.name] imported for [price]m. [flavor]"))

/obj/structure/roguemachine/stockpile/proc/do_withdraw(datum/roguestock/D, mob/user)
	D.refresh_auto_price()
	var/total_price = D.withdraw_price
	if(D.withdraw_disabled)
		say("Not available.")
		return
	if(D.stockpile_amount <= 0)
		say("Insufficient stock.")
		return
	if(total_price > withdraw_tab.budget)
		if(ishuman(user) && HAS_TRAIT(user, TRAIT_FOOD_STIPEND))
			if(SStreasury.burn(SStreasury.discretionary_fund, total_price, "food stipend - vomitorium"))
				D.stockpile_amount--
				var/obj/item/I = new D.item_type(loc)
				to_chat(user, span_info("[src] chitters and squeaks into the treasury ratlines."))
				if(!user.put_in_hands(I))
					I.forceMove(get_turf(user))
				playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				return
			say("The treasury is barren. Please insert coinage.")
			return
		say("Insufficient mammon.")
		return
	D.stockpile_amount--
	withdraw_tab.budget -= total_price
	SStreasury.mint(SStreasury.discretionary_fund, total_price, "stockpile withdraw")
	record_round_statistic(STATS_STOCKPILE_REVENUE, total_price)
	var/obj/item/I = new D.item_type(loc)
	if(!user.put_in_hands(I))
		I.forceMove(get_turf(user))
	playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)

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
		var/datum/component/storage/STR = bin.GetComponent(/datum/component/storage)
		if(STR)
			var/list/bin_contents = STR.contents()
			for(var/obj/item/bin_item in bin_contents) // Process all items inside the bin first
				attemptsell(bin_item, H, message, FALSE)

			for(var/obj/item/remaining_item in bin_contents) // Any items that weren't sold (still exist) go to the ground
				if(!QDELETED(remaining_item))
					STR.remove_from_storage(remaining_item, bin_location)
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

	// Pre-check: Crown's Purse must be solvent enough to pay. Below the Steward-set floor,
	// the Crown refuses purchases entirely - goods stay in the farmer's hands.
	var/treasury_balance = SStreasury.discretionary_fund?.balance || 0
	var/below_floor = treasury_balance < SStreasury.stockpile_purchase_floor

	for(var/datum/roguestock/R in SStreasury.stockpile_datums)
		if(istype(I, /obj/item/natural/bundle))
			var/obj/item/natural/bundle/B = I
			if(B.stacktype == R.item_type)
				if(!R.accept_toggle_enabled)
					if(message)
						say("The Crown has no interest in [R.name] at this time.")
					return
				if(below_floor && !R.mint_item)
					if(message)
						say("The Crown's ledger is thin. No purchases today.")
					return
				if(R.stockpile_amount >= R.stockpile_limit)
					if(message)
						say("The Crown's [R.name] stockpile is full. Take it elsewhere.")
					return
				var/bundle_amt = B.amount
				R.stockpile_amount += bundle_amt
				if(message == TRUE)
					stock_announce("[bundle_amt] units of [R.name] has been stockpiled.")
				qdel(B)
				if(sound == TRUE)
					playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				R.refresh_auto_price()
				var/per_unit = R.payout_price
				var/amt = per_unit * bundle_amt
				SStreasury.economic_output += amt
				SStreasury.give_money_account(amt, H, "+[amt] from [R.name] bounty")
				record_round_statistic(STATS_STOCKPILE_EXPANSES, amt)
				return
			continue
		// Bloc to replace old vault mechanics
		else if(istype(I,R.item_type))
			if(!R.check_item(I))
				continue
			if(R.mint_item && I.unmintable)
				if(message)
					say("This is town property, it cannot be minted here.")
				return
			if(I.atc_sealed)
				if(message)
					say("This bears an Azurian Trading Company seal. The Crown does not buy back Company stock.")
				return
			// Steward-controlled accept toggle.
			// - For mint_eligible goods (gems): falls through to the /bounty/treasure datum later in
			//   the loop, so rejected gems still mint as treasure instead of bouncing back to the player.
			// - For other goods (raw, refined, alchemy): refuses with a message. Item stays in hand.
			if(!R.accept_toggle_enabled)
				var/datum/trade_good/tg_reject = R.trade_good_id ? GLOB.trade_goods[R.trade_good_id] : null
				if(tg_reject && tg_reject.mint_eligible)
					continue
				if(message)
					say("The Crown has no interest in [R.name] at this time.")
				return
			// Treasure / mint items bypass the purchase floor - they generate mammon rather than spending it.
			if(below_floor && !R.mint_item)
				if(message)
					say("The Crown's ledger is thin. No purchases today.")
				return
			// Trade-good overflow mint branch. If this entry is linked to a mint_eligible
			// trade good (gems) and the stockpile is at limit, overflow mints to Crown's Purse
			// using the existing treasure-mint path. Takes precedence over no-pay overflow.
			if(R.trade_good_id && !R.mint_item && R.stockpile_amount >= R.stockpile_limit)
				var/datum/trade_good/tg_overflow = GLOB.trade_goods[R.trade_good_id]
				if(tg_overflow && tg_overflow.mint_eligible)
					var/mint_amt = round(tg_overflow.base_price * SStreasury.mint_multiplier)
					SStreasury.minted += mint_amt
					SStreasury.mint(SStreasury.discretionary_fund, mint_amt, "Gem overflow mint: [tg_overflow.name]")
					record_round_statistic(STATS_MINTED_TREASURE_GROSS, mint_amt)
					qdel(I)
					if(sound == TRUE)
						playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
						playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
					say("[tg_overflow.name] overflow - minted to Crown's Purse.")
					return
			if(!R.mint_item && R.stockpile_amount >= R.stockpile_limit)
				if(message)
					say("The Crown's [R.name] stockpile is full. Take it elsewhere.")
				return
			R.refresh_auto_price()
			var/amt = R.get_payout_price(I)
			var/true_value = I.get_real_price()
			if(!R.mint_item)
				R.stockpile_amount += 1 //stacked logs need to check for multiple
				qdel(I)
				if(message == TRUE)
					stock_announce("[R.name] has been stockpiled.")
				if(sound == TRUE)
					playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
			else
				var/mint_amt = round(SStreasury.mint_multiplier * true_value)
				SStreasury.minted += mint_amt
				SStreasury.mint(SStreasury.discretionary_fund, mint_amt, "Minting - [I.name]")
				record_round_statistic(STATS_MINTED_TREASURE_GROSS, mint_amt)
				record_round_statistic(STATS_MINTED_TREASURE_NET, max(0, mint_amt - amt))
				qdel(I) // Eaten to be minted!
				if(sound == TRUE)
					playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
					playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			if(amt)
				SStreasury.economic_output += true_value
				SStreasury.give_money_account(amt, H, "+[amt] from [R.name] bounty")
			record_round_statistic(STATS_STOCKPILE_EXPANSES, amt) // Unlike deposit, a treasure minting is equal to both expending and profiting at the same time
			record_round_statistic(STATS_STOCKPILE_REVENUE, true_value)
			return

	// Nothing in the stockpile accepted this item
	if(message)
		say("[I.name] is not accepted here.")

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


