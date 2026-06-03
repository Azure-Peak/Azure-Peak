/obj/structure/roguemachine/ship_fulfillment
	name = "ship fulfillment crate"
	desc = "A wide crate stamped with the seal of the Azurian Trading Company. Goods deposited here are accepted against the demands of foreign vessels in port - the depositor is paid in mammon to their account, less the Crown's export duty and the Merchant's middleman cut."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/list/profit_id = list("Merchant", "Shophand")
	var/duty_suspended = FALSE
	var/duty_collected_here = 0
	var/duty_evaded_here = 0

/obj/structure/roguemachine/ship_fulfillment/proc/can_manage(mob/user)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.job in profit_id)
		return TRUE
	return FALSE

/obj/structure/roguemachine/ship_fulfillment/Initialize()
	. = ..()
	set_light(1, 1, 1, l_color = "#c8a060")
	add_overlay(mutable_appearance(icon, "vendor-merch"))

/obj/structure/roguemachine/ship_fulfillment/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click with an item to deposit it for matching ship demands. You must have a MEISTER account to deposit - the crate will refuse goods otherwise.")
	. += span_info("Right-click to dump everything on your tile into the crate at once.")
	. += span_info("Certain items like kegs can be click dragged or offloaded in hand.")
	. += span_info("Stacks, handcarts, and bins are unloaded automatically.")

/obj/structure/roguemachine/ship_fulfillment/examine(mob/user)
	. = ..()
	if(!SSmerchant_trade)
		return
	var/n_ships = 0
	for(var/datum/trade_ship/ship in SSmerchant_trade.all_ships)
		if(ship.dock_state != TRADE_SHIP_STATE_DOCKED)
			continue
		for(var/list/line in ship.bulk_demands)
			if(line["qty_fulfilled"] < line["qty_target"])
				n_ships++
				break
	if(n_ships == 1)
		. += span_info("1 vessel at the pier seeks goods. Click to inspect the manifest.")
	else if(n_ships > 1)
		. += span_info("[n_ships] vessels at the pier seek goods. Click to inspect the manifest.")
	else
		. += span_info("No vessels currently buying. Click to inspect anyway.")
	if(SSmerchant_trade.current_kinship_realm)
		var/datum/foreign_realm/KR = SSmerchant_trade.realms[SSmerchant_trade.current_kinship_realm]
		if(KR)
			. += span_info("Bulk demand payouts from <b>[KR.name]</b> ships are +[round((KINSHIP_SELL_MULT - 1) * 100)]% due to Kinship.")

/obj/structure/roguemachine/ship_fulfillment/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/ship_fulfillment/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	ui_interact(user)

/obj/structure/roguemachine/ship_fulfillment/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShipFulfillment", name)
		ui.open()

/obj/structure/roguemachine/ship_fulfillment/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	switch(action)
		if("help")
			open_economy_guidebook(usr, "Merchant", /datum/book_entry/treasury_merchant/fulfillment_crate)
			return TRUE
		if("toggle_duty")
			if(!can_manage(usr))
				to_chat(usr, span_warning("Only the Merchant or Shophand may work the crate's underledger."))
				return TRUE
			duty_suspended = !duty_suspended
			to_chat(usr, span_notice("Crown export duty now [duty_suspended ? "DODGED" : "PAID"] at this crate."))
			return TRUE

/obj/structure/roguemachine/ship_fulfillment/ui_data(mob/user)
	var/list/data = list()
	var/list/manifests = list()
	var/kin_realm = SSmerchant_trade ? SSmerchant_trade.current_kinship_realm : null
	var/kin_sell_mult = SSmerchant_trade ? SSmerchant_trade.get_kinship_sell_mult(kin_realm) : 1
	if(SSmerchant_trade)
		for(var/datum/trade_ship/ship in SSmerchant_trade.all_ships)
			if(ship.dock_state != TRADE_SHIP_STATE_DOCKED)
				continue
			var/is_kin = (kin_realm && ship.realm_id == kin_realm) ? TRUE : FALSE
			var/list/lines = list()
			for(var/list/line in ship.bulk_demands)
				var/op = line["offered_price"]
				lines += list(list(
					"good" = line["good"] || line["typepath"] || "",
					"good_name" = line["good_name"],
					"qty_target" = line["qty_target"],
					"qty_fulfilled" = line["qty_fulfilled"],
					"offered_price" = op,
					"kin_offered_price" = is_kin ? round(op * kin_sell_mult) : op,
					"tag" = line["tag"] || "",
				))
			if(length(lines))
				var/datum/foreign_realm/realm = SSmerchant_trade.get_realm(ship.realm_id)
				manifests += list(list(
					"ship_id" = ship.ship_id,
					"ship_name" = ship.ship_name,
					"realm_id" = ship.realm_id,
					"is_kin" = is_kin,
					"typical_provisions" = realm ? realm.typical_provisions() : "",
					"lines" = lines,
				))
	data["manifests"] = manifests
	data["middleman_cut_percent"] = SSmerchant_trade ? SSmerchant_trade.merchant_levy_percent : TRADE_MERCHANT_LEVY_DEFAULT_PERCENT
	data["kinship_sell_pct"] = round((KINSHIP_SELL_MULT - 1) * 100)
	data["can_manage"] = can_manage(user) ? TRUE : FALSE
	data["duty_suspended"] = duty_suspended
	data["duty_rate_pct"] = round(SStreasury.get_tax_rate(TAX_CATEGORY_EXPORT_DUTY) * 100)
	data["duty_collected_here"] = duty_collected_here
	data["duty_evaded_here"] = duty_evaded_here
	return data

/obj/structure/roguemachine/ship_fulfillment/attackby(obj/item/P, mob/user, params)
	if(!ishuman(user))
		return ..()
	attempt_deposit(P, user, TRUE, TRUE)

/obj/structure/roguemachine/ship_fulfillment/MouseDrop_T(atom/dropped, mob/living/user)
	if(!ishuman(user))
		return
	if(!istype(dropped, /obj/structure/fermentation_keg))
		return ..()
	if(!user.Adjacent(src) || !user.Adjacent(dropped))
		return
	attempt_deposit_keg(dropped, user)

/obj/structure/roguemachine/ship_fulfillment/attack_right(mob/user)
	if(!ishuman(user))
		return
	if(!SSmerchant_trade)
		return
	if(!SStreasury.has_account(user))
		say("No account found for [user]. Submit your fingers to a Meister for inspection.")
		return
	var/list/tally = list("total_producer" = 0, "total_gross" = 0, "total_duty" = 0, "total_cut" = 0, "total_kin_bonus" = 0, "total_quality_delta" = 0, "lines" = list())
	for(var/obj/item/I in get_turf(user))
		attempt_deposit(I, user, FALSE, FALSE, tally)
	for(var/obj/structure/fermentation_keg/keg in get_turf(user))
		attempt_deposit_keg(keg, user)
	flush_tally(tally, user)
	say("Bulk fulfillment in progress...")
	playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/ship_fulfillment/proc/flush_tally(list/tally, mob/user)
	if(!tally || tally["total_producer"] <= 0)
		return
	var/list/line_summaries = list()
	var/list/ship_names = list()
	for(var/key in tally["lines"])
		var/list/info = tally["lines"][key]
		line_summaries += "[info["qty"]] [info["good_name"]] -> [info["ship_name"]]"
		ship_names |= info["ship_name"]
	var/mint_label = (length(ship_names) == 1) ? ship_names[1] : "foreign vessels"
	var/kin_total = tally["total_kin_bonus"] || 0
	var/quality_delta = tally["total_quality_delta"] || 0
	var/quality_str = ""
	if(quality_delta != 0)
		var/sign_str = quality_delta > 0 ? "+" : ""
		quality_str = ", quality [sign_str][quality_delta]m"
	var/breakdown = "[english_list(line_summaries)]: gross [tally["total_gross"]]m, Crown [tally["total_duty"]]m, Merchant [tally["total_cut"]]m[kin_total > 0 ? ", Kinship +[kin_total]m" : ""][quality_str]"
	SStreasury.give_money_account(tally["total_producer"], user, breakdown, mint_new = TRUE, mint_label = mint_label)
	if(quality_delta != 0)
		var/representative_quality = quality_delta > 0 ? ITEM_QUALITY_MASTERWORK : ITEM_QUALITY_CRUDE
		var/jab = navigator_quality_jab(representative_quality)
		if(jab)
			say(jab)
			to_chat(user, span_info("[src] says, \"[jab]\""))

/obj/structure/roguemachine/ship_fulfillment/proc/attempt_deposit(obj/item/I, mob/user, message = TRUE, sound = TRUE, list/tally)
	if(!SSmerchant_trade)
		return
	if(istype(I, /obj/structure/handcart))
		var/obj/structure/handcart/cart = I
		var/turf/cart_loc = get_turf(cart)
		var/list/cart_contents = cart.contained_items.Copy()
		for(var/atom/movable/cart_content in cart_contents)
			if(isitem(cart_content))
				attempt_deposit(cart_content, user, message, FALSE, tally)
		for(var/atom/movable/remaining in cart_contents)
			if(!QDELETED(remaining))
				cart.remove_from(remaining)
				remaining.forceMove(cart_loc)
		cart.contained_items = list()
		cart.current_capacity = 0
		cart.update_icon()
		if(sound)
			playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		return
	if(istype(I, /obj/item/roguebin))
		var/obj/item/roguebin/bin = I
		var/turf/bin_loc = get_turf(bin)
		var/datum/component/storage/STR = bin.GetComponent(/datum/component/storage)
		if(STR)
			var/list/bin_contents = STR.contents()
			for(var/obj/item/bin_item in bin_contents)
				attempt_deposit(bin_item, user, message, FALSE, tally)
			for(var/obj/item/remaining in bin_contents)
				if(!QDELETED(remaining))
					STR.remove_from_storage(remaining, bin_loc)
		if(sound)
			playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		return
	if(!SStreasury.has_account(user))
		if(message)
			say("No account found for [user]. Submit your fingers to a Meister for inspection.")
		return
	if(I.atc_sealed)
		if(message)
			to_chat(user, span_warning("[I] bears an Azurian Trading Company seal - foreign captains will not buy Company stock back."))
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/F = I
		if(F.eat_effect == /datum/status_effect/debuff/rotfood)
			if(message)
				to_chat(user, span_warning("[I] is rotten. No captain will load spoiled stores aboard."))
			return
	var/list/dish_match = find_dish_match(I.type)
	if(dish_match)
		var/list/dish_line = dish_match["line"]
		if(dish_line["tag"] == TRADE_VICTUALLING_TAG_DRINKS && !dish_line["by_bottle"])
			if(message)
				to_chat(user, span_warning("Captains buy drinks by the barrel - drag a full keg onto [src], not loose bottles."))
			return
		if(istype(I, /obj/item/reagent_containers/glass/bottle/brewing_bottle))
			var/obj/item/reagent_containers/glass/bottle/brewing_bottle/BB = I
			if(!BB.sealed)
				if(message)
					to_chat(user, span_warning("[I] has been unsealed - no captain will load an opened bottle."))
				return
		var/datum/trade_ship/dish_ship = dish_match["ship"]
		dish_line["qty_fulfilled"]++
		var/dish_q_mult = I.has_item_quality ? ITEM_QUALITY_MULT(I.item_quality) : 1.0
		var/dish_unit_price = round(dish_line["offered_price"] * dish_q_mult)
		var/dish_quality_delta = dish_unit_price - dish_line["offered_price"]
		if(message && I.has_item_quality && I.item_quality != ITEM_QUALITY_STANDARD)
			var/jab = navigator_quality_jab(I.item_quality)
			if(jab)
				say(jab)
				to_chat(user, span_info("[src] says, \"[jab]\""))
		qdel(I)
		settle_payout(dish_unit_price, user, dish_ship, dish_line["good_name"], 1, message, sound, tally, dish_quality_delta)
		return
	if(istype(I, /obj/item/natural/bundle))
		var/obj/item/natural/bundle/B = I
		var/good_id = identify_trade_good_for_type(B.stacktype)
		if(!good_id)
			if(message)
				to_chat(user, span_warning("No vessel here is buying [B]."))
			return
		var/list/match = find_demand_match(good_id)
		if(!match)
			if(message)
				to_chat(user, span_warning("No vessel here is buying [B.name]."))
			return
		var/datum/trade_ship/ship = match["ship"]
		var/list/line = match["line"]
		var/remaining = line["qty_target"] - line["qty_fulfilled"]
		var/take = min(B.amount, remaining)
		if(take <= 0)
			return
		line["qty_fulfilled"] += take
		B.amount -= take
		if(B.amount <= 0)
			qdel(B)
		else
			B.update_icon()
		settle_payout(line["offered_price"] * take, user, ship, line["good_name"], take, message, sound, tally)
		return
	var/good_id = identify_trade_good(I)
	if(!good_id)
		if(message)
			to_chat(user, span_warning("[I] is not something a foreign vessel would buy in bulk."))
		return
	var/list/match = find_demand_match(good_id)
	if(!match)
		if(message)
			to_chat(user, span_warning("No vessel here is buying [I]."))
		return
	var/datum/trade_ship/ship = match["ship"]
	var/list/line = match["line"]
	if(line["qty_fulfilled"] >= line["qty_target"])
		if(message)
			to_chat(user, span_warning("That vessel's hold is full of [line["good_name"]]."))
		return
	line["qty_fulfilled"]++
	var/q_mult = I.has_item_quality ? ITEM_QUALITY_MULT(I.item_quality) : 1.0
	var/unit_price = round(line["offered_price"] * q_mult)
	var/quality_delta = unit_price - line["offered_price"]
	if(message && I.has_item_quality && I.item_quality != ITEM_QUALITY_STANDARD)
		var/jab = navigator_quality_jab(I.item_quality)
		if(jab)
			say(jab)
			to_chat(user, span_info("[src] says, \"[jab]\""))
	qdel(I)
	settle_payout(unit_price, user, ship, line["good_name"], 1, message, sound, tally, quality_delta)

/obj/structure/roguemachine/ship_fulfillment/proc/attempt_deposit_keg(obj/structure/fermentation_keg/keg, mob/user)
	if(!SSmerchant_trade)
		return
	if(!SStreasury.has_account(user))
		say("No account found for [user]. Submit your fingers to a Meister for inspection.")
		return
	if(keg.anchored)
		to_chat(user, span_warning("[keg] is fixed in place - bottle its spirits and deposit those instead."))
		return
	if(keg.brewing || !keg.ready_to_bottle || keg.tapped || !keg.selected_recipe)
		to_chat(user, span_warning("[keg] holds no finished, sealed batch the captains would buy."))
		return
	var/bottle_type = keg.selected_recipe.output_bottle_type
	if(!bottle_type)
		to_chat(user, span_warning("No vessel here is buying [keg]."))
		return
	var/list/match = find_dish_match(bottle_type)
	if(!match)
		to_chat(user, span_warning("No vessel here is buying [keg.selected_recipe.bottle_name]."))
		return
	var/datum/trade_ship/ship = match["ship"]
	var/list/line = match["line"]
	if(line["qty_fulfilled"] >= line["qty_target"])
		to_chat(user, span_warning("That vessel's hold is full of [line["good_name"]]."))
		return
	line["qty_fulfilled"]++
	qdel(keg)
	settle_payout(line["offered_price"], user, ship, line["good_name"], 1, TRUE, TRUE)

/obj/structure/roguemachine/ship_fulfillment/proc/settle_payout(gross, mob/user, datum/trade_ship/ship, good_name, qty, message, sound, list/tally, quality_delta = 0)
	if(gross <= 0)
		return
	var/kin_bonus = 0
	if(ship && SSmerchant_trade)
		var/kin_mult = SSmerchant_trade.get_kinship_sell_mult(ship.realm_id)
		if(kin_mult > 1)
			var/pre_kin = gross
			gross = round(gross * kin_mult)
			kin_bonus = gross - pre_kin
	var/duty_rate = SStreasury.get_tax_rate(TAX_CATEGORY_EXPORT_DUTY)
	var/levy_pct = SSmerchant_trade ? SSmerchant_trade.merchant_levy_percent : 0
	var/levy_float = gross * levy_pct / 100
	var/duty_on_gross_float = gross * duty_rate
	var/duty_on_levy_float = levy_float * duty_rate
	var/duty_remitted = 0
	var/levy_tax_remitted = 0
	var/levy_remitted = 0
	var/total_duty = 0
	if(duty_suspended)
		var/evaded = round(duty_on_gross_float) + round(duty_on_levy_float)
		if(evaded > 0)
			record_round_statistic(STATS_TAXES_EVADED, evaded)
			duty_evaded_here += evaded
	else
		if(duty_on_gross_float > 0)
			duty_remitted = SStreasury.mint_fractional(SStreasury.discretionary_fund, duty_on_gross_float, "[TAX_CATEGORY_EXPORT_DUTY] (ship fulfillment)")
			SStreasury.apply_concordat_tithe(gross, TAX_CATEGORY_EXPORT_DUTY, "ship fulfillment")
		if(duty_on_levy_float > 0)
			levy_tax_remitted = SStreasury.mint_fractional(SStreasury.discretionary_fund, duty_on_levy_float, "[TAX_CATEGORY_EXPORT_DUTY] (levy income, ship fulfillment)")
			SStreasury.apply_concordat_tithe(levy_float, TAX_CATEGORY_EXPORT_DUTY, "levy income (ship fulfillment)")
		total_duty = duty_remitted + levy_tax_remitted
		if(total_duty > 0)
			record_round_statistic(STATS_TAXES_COLLECTED, total_duty)
			record_round_statistic(STATS_REVENUE_EXPORT_DUTY, total_duty)
			duty_collected_here += total_duty
			if(SSmerchant_trade)
				SSmerchant_trade.merchant_levy_taxed += levy_tax_remitted
	var/merchant_net_float = levy_float - (duty_suspended ? 0 : duty_on_levy_float)
	if(merchant_net_float > 0)
		levy_remitted = SStreasury.mint_fractional(SStreasury.merchant_fund, merchant_net_float, "Merchant's levy: [qty] [good_name] -> [ship.ship_name]")
		if(SSmerchant_trade)
			SSmerchant_trade.merchant_levy_collected += levy_remitted
			SSmerchant_trade.log_fund_movement("Fulfillment levy ([ship.ship_name])", levy_remitted)
	var/producer_payout = gross - duty_remitted - round(levy_float)
	if(producer_payout < 0)
		producer_payout = 0
	record_round_statistic(STATS_TRADE_VALUE_EXPORTED, gross)
	ship.favor_earned += gross
	if(sound)
		playsound(loc, 'sound/misc/hiss.ogg', 70, TRUE, -1)
	if(tally)
		tally["total_producer"] += producer_payout
		tally["total_gross"] += gross
		tally["total_duty"] += total_duty
		tally["total_cut"] += levy_remitted
		tally["total_kin_bonus"] = (tally["total_kin_bonus"] || 0) + kin_bonus
		tally["total_quality_delta"] = (tally["total_quality_delta"] || 0) + quality_delta
		var/key = "[ship.ship_id]|[good_name]"
		var/list/info = tally["lines"][key]
		if(info)
			info["qty"] += qty
		else
			tally["lines"][key] = list("qty" = qty, "good_name" = good_name, "ship_name" = ship.ship_name)
		return
	var/quality_str = ""
	if(quality_delta != 0)
		var/q_sign = quality_delta > 0 ? "+" : ""
		quality_str = ", quality [q_sign][quality_delta]m"
	var/breakdown = "[qty] [good_name] for [ship.ship_name]: gross [gross]m, Crown [total_duty]m, Merchant [levy_remitted]m[kin_bonus > 0 ? ", Kinship +[kin_bonus]m" : ""][quality_str]"
	if(producer_payout > 0)
		SStreasury.give_money_account(producer_payout, user, breakdown, mint_new = TRUE, mint_label = ship ? ship.ship_name : "foreign vessels")

/obj/structure/roguemachine/ship_fulfillment/proc/identify_trade_good(obj/item/P)
	for(var/id in GLOB.trade_goods)
		var/datum/trade_good/TG = GLOB.trade_goods[id]
		if(!TG.item_type)
			continue
		if(TG.accept_subtypes ? istype(P, TG.item_type) : P.type == TG.item_type)
			return id
	return null

/obj/structure/roguemachine/ship_fulfillment/proc/identify_trade_good_for_type(item_type)
	for(var/id in GLOB.trade_goods)
		var/datum/trade_good/TG = GLOB.trade_goods[id]
		if(TG.item_type == item_type)
			return id
	return null

/obj/structure/roguemachine/ship_fulfillment/proc/find_dish_match(item_type)
	if(!item_type)
		return null
	var/type_str = "[item_type]"
	for(var/datum/trade_ship/ship in SSmerchant_trade.all_ships)
		if(ship.dock_state != TRADE_SHIP_STATE_DOCKED)
			continue
		for(var/list/line in ship.bulk_demands)
			if(line["typepath"] != type_str)
				continue
			if(line["qty_fulfilled"] >= line["qty_target"])
				continue
			return list("ship" = ship, "line" = line)
	return null

/obj/structure/roguemachine/ship_fulfillment/proc/find_demand_match(good_id)
	for(var/datum/trade_ship/ship in SSmerchant_trade.all_ships)
		if(ship.dock_state != TRADE_SHIP_STATE_DOCKED)
			continue
		for(var/list/line in ship.bulk_demands)
			if(line["good"] != good_id)
				continue
			if(line["qty_fulfilled"] >= line["qty_target"])
				continue
			return list("ship" = ship, "line" = line)
	return null
