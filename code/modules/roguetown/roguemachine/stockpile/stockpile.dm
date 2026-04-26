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

/obj/structure/roguemachine/stockpile/Topic(href, href_list)
	. = ..()
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	if(href_list["navigate"])
		return attack_hand(usr, href_list["navigate"])
	if(href_list["stockpilechangecat"])
		current_category = href_list["stockpilechangecat"]
		return attack_hand(usr, "deposit")

	if(withdraw_tab.perform_action(href, href_list))
		if(href_list["remote"])
			playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		return attack_hand(usr, "withdraw")

	// If we don't get a valid option, default to returning to the directory
	return attack_hand(usr, "directory")


/obj/structure/roguemachine/stockpile/proc/get_directory_contents()
	var/contents = "<center>TOWN STOCKPILE<BR>"
	contents += "--------------<BR>"

	contents += "<a href='?src=[REF(src)];navigate=withdraw'>EXTRACT</a><BR>"
	contents += "<a href='?src=[REF(src)];navigate=deposit'>FEED</a></center><BR><BR>"

	return contents

/obj/structure/roguemachine/stockpile/proc/get_withdraw_contents()
	return withdraw_tab.get_contents("EXTRACT FROM THE STOCKPILE", TRUE)

/obj/structure/roguemachine/stockpile/proc/get_deposit_contents()
	var/contents = "<center>FEED THE STOCKPILE<BR>"
	contents += "<a href='?src=[REF(src)];navigate=directory'>(back)</a><BR>"
	contents += "----------<BR>"
	contents += "</center>"
	var/selection = "Categories: "
	for(var/category in categories)
		if(category == current_category)
			selection += "<b>[current_category]</b> "
		else
			// Force call navigate so the UI actually updates fml
			selection += "<a href='?src=[REF(src)];stockpilechangecat=[category]'>[category]</a> "
	contents += selection + "<BR>"
	contents += "--------------<BR>"

	for(var/datum/roguestock/bounty/R in SStreasury.stockpile_datums)
		contents += "[R.name] - [R.payout_price][R.percent_bounty ? "%" : ""]"
		contents += "<BR>"

	contents += "<BR>"

	for(var/datum/roguestock/stockpile/R in SStreasury.stockpile_datums)
		if(R.category != current_category)
			continue
		R.refresh_auto_price()
		if(!R.accept_toggle_enabled)
			contents += "<font color='#888'>[R.name][R.get_event_tag()] - NOT ACCEPTING - ([R.stockpile_amount]/[R.stockpile_limit])</font>"
		else
			contents += "[R.name][R.get_event_tag()] - [R.payout_price][R.get_market_delta_tag_for("deposit")] - ([R.stockpile_amount]/[R.stockpile_limit])"
		contents += "<BR>"

	return contents

/obj/structure/roguemachine/stockpile/attack_hand(mob/living/user, menu_name)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)

	var/contents
	if(menu_name == "withdraw")
		contents = get_withdraw_contents()
	else if(menu_name == "deposit")
		contents = get_deposit_contents()
	else
		contents = get_directory_contents()

	var/datum/browser/popup = new(user, "VENDORTHING", "", 700, 800)
	popup.set_content(contents)
	popup.open()

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


