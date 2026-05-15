/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

// DESIGN NOTE
// Merchants need to be able to sell nearly all items that adventurers and combat roles need.
// At a price designed to be undercuttable by economic roles
// But also keep them honest so producer cannot charge a 2x margin and still be competitive
// Merchant provides the primary source of money sinks in the economy, an alternative to producer roles

#define UPGRADE_NOTAX		(1<<0)

/obj/structure/roguemachine/goldface
	name = "GOLDFACE"
	desc = "Gilded tombs do worms enfold."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/locked = FALSE
	var/budget = 0
	var/upgrade_flags
	var/current_cat = ""
	var/search_query = ""
	var/static/search_result_cap = 30
	/// When TRUE, the TGUI exposes the Harbor tab (foreign trade ledger). Goldface only.
	var/is_command_center = TRUE
	// Motto displayed at the top of the vendor interface
	var/motto = "GOLDFACE - In the name of greed."
	var/lockid = "merchant"
	// Which job can access profit from this vendor
	var/profit_id = list("Merchant", "Shophand")
	// Where to record value spent
	var/value_record_key = STATS_GOLDFACE_VALUE_SPENT
	// True to make sure it bypass all taxes no matter what
	var/bypass_tax = FALSE
	var/list/categories = list(
		"Alcohols",
		"Apparel",
		"Consumable",
		"Gems",
		"Instruments",
		"Luxury",
		"Livestock",
		"Cosmetics",
		"Raw Materials",
		"Seeds",
		"Tools",
		"Wardrobe",
	)
	var/list/categories_gamer = list(
		"Adventuring Supplies",
		"Armor (Light)",
		"Armor (Iron)",
		"Armor (Steel)",
		"Armor (Exotic)",
		"Potions",
		"Weapons (Ranged)",
		"Weapons (Iron and Shields)",
		"Weapons (Steel)",
		"Weapons (Foreign)",
	)
	var/is_public = FALSE // Whether it is a public access vendor.
	var/extra_fee = 0 // Extra Guild Fees on purchases. Meant to make publicface very unprofitable.
	/// Running tally of Crown import tariff actually collected via this specific machine.
	var/tariff_collected_here = 0
	/// Running tally of Crown import tariff that WOULD have been owed but was dodged
	/// via the NOTAX flag. Surfaced in-UI for audit transparency.
	var/tariff_evaded_here = 0

/obj/structure/roguemachine/goldface/public
	name = "SILVERFACE"
	extra_fee = 0.5
	is_public = TRUE
	locked = FALSE
	is_command_center = FALSE
	motto = "SILVERFACE - Commerce for all."
	// There's no profit but this is for futureproofing
	profit_id = list("Merchant", "Shophand")
	value_record_key = STATS_SILVERFACE_VALUE_SPENT
	categories = list(
		"Adventuring Supplies",
		"Alcohols",
		"Consumable",
		"Gems",
		"Instruments",
		"Luxury",
		"Livestock",
		"Cosmetics",
		"Raw Materials",
		"Seeds",
		"Tools",
		"Weapons (Foreign)",
	)
	categories_gamer = list()

/obj/structure/roguemachine/goldface/public/examine()
	. = ..()
	. += "<span class='info'>A public version of the GOLDFACE. The guild charges a hefty fee for its usage. When locked, can be used to browse the inventory a merchant has.</span>"
	. += "<span class='info'>An agreement between the Guild of Craft and the Merchant's Guild mandates that certain protected goods are sold in a separate vendor that can be locked by the guildmembers.</span>"
	. += "<span class='info'>The vendor can be locked by a key. The merchant make no profit whatsoever from the public vendor as the guild charges an exorbitant markup for automated handling.</span>"

/obj/structure/roguemachine/goldface/public/smith
	name = "Smithy's SILVERFACE"
	lockid = "crafterguild"
	profit_id = list("Guildsman", "Guildmaster", "Tailor")
	categories = list(
		"Armor (Iron)",
		"Armor (Steel)",
		"Armor (Exotic)",
		"Weapons (Ranged)",
		"Weapons (Iron and Shields)",
		"Weapons (Steel)",
	)
	categories_gamer = list()

/obj/structure/roguemachine/goldface/public/smith/examine()
	. = ..()
	. += span_info("This can be locked by a guild's key")

/obj/structure/roguemachine/goldface/public/tailor
	name = "Tailor's SILVERFACE"
	lockid = "tailor"
	profit_id = list("Guildsman", "Guildmaster", "Tailor")
	categories = list(
		"Apparel",
		"Wardrobe",
		"Armor (Light)",
	)
	categories_gamer = list()

/obj/structure/roguemachine/goldface/public/tailor/examine()
	. = ..()
	. += span_info("This can be locked by a tailor's key")

/obj/structure/roguemachine/goldface/public/apothecary
	name = "Apothecary's SILVERFACE"
	lockid = "apothecary"
	profit_id = list("Head Physician","Apothecary")
	categories = list(
		"Potions",
	)
	categories_gamer = list()

/obj/structure/roguemachine/goldface/public/apothecary/examine()
	. = ..()
	. += span_info("This can be locked by a physician's key")

/obj/structure/roguemachine/goldface/public/wretch_cat
	name = "Vile Vheslie"
	desc = "A ferocious little beast that hoards a mountain of goods under its home. The dreaded creechur is willing to part waes with its lower quality items..for a price."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "vheslie"
	lockid = "Vheslie"
	profit_id = list("Guildsman", "Guildmaster", "Tailor")
	categories = list(
		"Apparel",
		"Adventuring Supplies",
		"Armor (Iron)",
		"Alcohols",
		"Consumable",
		"Drugs",
		"Potions",
		"Weapons (Ranged)",
		"Weapons (Iron and Shields)",
		"Wardrobe"
	)
	categories_gamer = list()

/obj/structure/roguemachine/goldface/Initialize()
	. = ..()
	update_icon()

/obj/structure/roguemachine/goldface/proc/compute_pack_price(datum/supply_pack/PA)
	var/cost = PA.cost + PA.cost * extra_fee
	if(!(upgrade_flags & UPGRADE_NOTAX) && !bypass_tax)
		cost += compute_pack_tax(PA)
	return round(cost)

/obj/structure/roguemachine/goldface/proc/compute_pack_tax(datum/supply_pack/PA)
	return round(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * PA.cost)

/obj/structure/roguemachine/goldface/proc/serialize_pack(datum/supply_pack/PA, tariff_active)
	var/base = round(PA.cost + PA.cost * extra_fee)
	var/tariff = tariff_active ? compute_pack_tax(PA) : 0
	return list(
		"ref" = "[PA.type]",
		"name" = PA.name,
		"category" = PA.group,
		"qty" = PA.no_name_quantity ? 1 : PA.contains.len,
		"price_base" = base,
		"price_tariff" = tariff,
		"price" = base + tariff,
	)

/obj/structure/roguemachine/goldface/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	set_light(1, 1, 1, l_color = "#1b7bf1")
	add_overlay(mutable_appearance(icon, "vendor-merch"))


/obj/structure/roguemachine/goldface/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == lockid || istype(K, /obj/item/roguekey/lord) || istype(K, /obj/item/roguekey/skeleton))
			locked = !locked
			playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
			update_icon()
			return attack_hand(user)
		else
			to_chat(user, span_warning("Wrong key."))
			return
	else if(istype(P, /obj/item/storage/keyring))
		var/right_key = FALSE
		for(var/obj/item/roguekey/KE in P.contents)
			if(KE.lockid == lockid || istype(KE, /obj/item/roguekey/lord) || istype(KE, /obj/item/roguekey/skeleton))
				right_key = TRUE
				locked = !locked
				playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
				update_icon()
				return attack_hand(user)
		if(!right_key)
			to_chat(user, span_warning("Wrong key."))
			return
	if(istype(P, /obj/item/roguecoin/aalloy))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))	
		return			
	if(istype(P, /obj/item/roguecoin))
		budget += P.get_real_price()
		qdel(P)
		update_icon()
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)
	..()

/obj/structure/roguemachine/goldface/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/goldface/ui_interact(mob/user, datum/tgui/ui)
	if(!ishuman(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		playsound(loc, 'sound/misc/gold_menu.ogg', 100, FALSE, -1)
		ui = new(user, src, "Goldface", name)
		ui.open()

/obj/structure/roguemachine/goldface/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	ui_interact(user)

/obj/structure/roguemachine/goldface/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/carbon/human/H = user
	var/can_read = istype(H) ? H.can_read(src, TRUE) : FALSE
	var/is_proprietor = istype(H) && (H.job in profit_id)
	var/dodging = (upgrade_flags & UPGRADE_NOTAX) || bypass_tax
	data["motto"] = motto
	data["budget"] = budget
	data["locked"] = locked ? TRUE : FALSE
	data["is_public"] = is_public ? TRUE : FALSE
	data["is_proprietor"] = is_proprietor ? TRUE : FALSE
	data["can_read"] = can_read ? TRUE : FALSE
	data["tariff_rate_pct"] = round(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * 100)
	data["tariff_paid"] = tariff_collected_here
	data["tariff_evaded"] = tariff_evaded_here
	data["dodging"] = dodging ? TRUE : FALSE
	var/list/all_cats = list()
	for(var/c in categories)
		all_cats += c
	for(var/c in categories_gamer)
		all_cats += c
	data["categories"] = all_cats
	data["current_category"] = current_cat
	data["search"] = search_query
	data["search_mode"] = (search_query != "") ? TRUE : FALSE
	data["result_cap"] = search_result_cap
	var/list/packs_data = list()
	var/total_matches = 0
	var/tariff_active = !(upgrade_flags & UPGRADE_NOTAX) && !bypass_tax
	if(search_query != "")
		var/needle = lowertext(search_query)
		var/list/matches = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(PA.not_in_public && is_public)
				continue
			if(!(PA.group in all_cats))
				continue
			if(findtext(lowertext(PA.name), needle) || findtext(lowertext(PA.group), needle))
				matches += PA
		total_matches = length(matches)
		var/shown = 0
		for(var/datum/supply_pack/PA in sortNames(matches))
			if(shown >= search_result_cap)
				break
			shown++
			packs_data += list(serialize_pack(PA, tariff_active))
	else if(current_cat)
		var/list/pax = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(PA.not_in_public && is_public)
				continue
			if(PA.group == current_cat)
				pax += PA
		total_matches = length(pax)
		for(var/datum/supply_pack/PA in sortNames(pax))
			packs_data += list(serialize_pack(PA, tariff_active))
	data["packs"] = packs_data
	data["total_matches"] = total_matches
	data["is_command_center"] = is_command_center ? TRUE : FALSE
	if(is_command_center && SSmerchant_trade)
		data["harbor"] = build_harbor_data()
	return data

/obj/structure/roguemachine/goldface/proc/build_harbor_data()
	var/list/docked = list()
	var/list/pool = list()
	for(var/datum/trade_ship/ship in SSmerchant_trade.all_ships)
		var/is_docked = ship.dock_state == TRADE_SHIP_STATE_DOCKED
		var/list/row = list(
			"ship_id" = ship.ship_id,
			"ship_name" = ship.ship_name,
			"captain_name" = is_docked ? ship.captain_name : null,
			"port_of_origin" = ship.port_of_origin,
			"realm_id" = ship.realm_id,
			"ship_type" = ship.ship_type,
			"tonnage" = ship.tonnage,
		)
		if(is_docked)
			var/seconds_left = max(0, round((ship.dock_expires_at - world.time) / 10))
			row["seconds_until_departure"] = seconds_left
			row["can_send_away"] = (world.time >= ship.docked_at + TRADE_SHIP_SEND_AWAY_GRACE) ? TRUE : FALSE
			row["bulk_demands"] = ship.bulk_demands.Copy()
			row["bulk_supplies"] = ship.bulk_supplies.Copy()
			docked += list(row)
		else
			pool += list(row)
	var/list/realms = list()
	for(var/realm_id in SSmerchant_trade.realms)
		var/datum/foreign_realm/R = SSmerchant_trade.realms[realm_id]
		var/discovered = SSmerchant_trade.is_discovered(R.id)
		var/list/rrow = list(
			"id" = R.id,
			"name" = R.name,
			"discovered" = discovered ? TRUE : FALSE,
			"cultural_goods" = R.cultural_goods ? R.cultural_goods.Copy() : list(),
			"basic_buys" = pool_good_names(R.bulk_demand_pool, TRUE),
			"rare_buys" = pool_good_names(R.bulk_demand_pool, FALSE),
			"basic_sells" = pool_good_names(R.bulk_supply_pool, TRUE),
			"rare_sells" = pool_good_names(R.bulk_supply_pool, FALSE),
		)
		if(discovered)
			var/list/condition_entries = list()
			for(var/datum/realm_condition/C as anything in SSmerchant_trade.active_conditions_for(R.id))
				condition_entries += list(list(
					"name" = C.name,
					"description" = C.description,
				))
			rrow["market_conditions"] = condition_entries
		realms += list(rrow)
	return list(
		"ships_docked" = docked,
		"ships_pool" = pool,
		"realms" = realms,
		"hails_remaining" = SSmerchant_trade.hails_remaining,
		"hails_per_day" = TRADE_SHIPS_HAIL_PER_DAY,
		"dock_spots_used" = length(docked),
		"dock_spots_max" = SSmerchant_trade.get_dock_spots_max(),
		"cultural_stock" = build_cultural_stock_data(),
	)

/obj/structure/roguemachine/goldface/proc/pool_good_names(list/pool, want_always)
	var/list/result = list()
	for(var/list/entry in pool)
		if(want_always && !entry["always"])
			continue
		if(!want_always && entry["always"])
			continue
		var/datum/trade_good/TG = GLOB.trade_goods[entry["good"]]
		if(TG)
			result += TG.name
	return result

/obj/structure/roguemachine/goldface/proc/build_cultural_stock_data()
	var/list/result = list()
	for(var/datum/trade_ship/ship in SSmerchant_trade.all_ships)
		if(ship.dock_state != TRADE_SHIP_STATE_DOCKED)
			continue
		for(var/list/entry in ship.cultural_stock)
			if(entry["qty"] <= 0)
				continue
			var/discounted = round(entry["base_cost"] * (100 - TRADE_CULTURAL_SHIP_DISCOUNT_PERCENT) / 100)
			result += list(list(
				"pack" = entry["pack"],
				"name" = entry["name"],
				"qty" = entry["qty"],
				"pack_qty" = entry["pack_qty"],
				"base_cost" = entry["base_cost"],
				"price" = discounted,
				"ship_id" = ship.ship_id,
				"ship_name" = ship.ship_name,
			))
	return result

/obj/structure/roguemachine/goldface/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	if(locked && !is_public)
		return
	var/mob/living/carbon/human/H = usr
	switch(action)
		if("changecat")
			var/cat = "[params["category"]]"
			if(cat in categories)
				current_cat = cat
			else if(cat in categories_gamer)
				current_cat = cat
			search_query = ""
			return TRUE
		if("set_search")
			search_query = "[params["search"]]"
			return TRUE
		if("clear_search")
			search_query = ""
			return TRUE
		if("change")
			if(budget > 0)
				budget2change(budget, usr)
				budget = 0
			return TRUE
		if("secrets")
			if(!(H.job in profit_id) || is_public)
				return TRUE
			var/list/options = list()
			if(upgrade_flags & UPGRADE_NOTAX)
				options += "Enable Paying Taxes"
			else
				options += "Stop Paying Taxes"
			var/select = input(usr, "Please select an option.", "", null) as null|anything in options
			if(!select)
				return TRUE
			if(!usr.canUseTopic(src, BE_CLOSE) || (locked && !is_public))
				return TRUE
			switch(select)
				if("Enable Paying Taxes")
					upgrade_flags &= ~UPGRADE_NOTAX
				if("Stop Paying Taxes")
					upgrade_flags |= UPGRADE_NOTAX
			playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
			return TRUE
		if("buy")
			var/path = text2path(params["ref"])
			if(!ispath(path, /datum/supply_pack))
				message_admins("silly MOTHERFUCKER [usr.key] IS TRYING TO BUY A [path] WITH THE [src.name]")
				return TRUE
			var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
			if(!PA)
				return TRUE
			if(PA.not_in_public && is_public)
				return TRUE
			if(!(PA.group in categories) && !(PA.group in categories_gamer))
				return TRUE
			if(is_public && locked)
				return TRUE
			var/cost = compute_pack_price(PA)
			var/tax_amt = compute_pack_tax(PA)
			if(budget < cost)
				say("Not enough!")
				return TRUE
			budget -= cost
			record_round_statistic(value_record_key, cost)
			record_round_statistic(STATS_TRADE_VALUE_IMPORTED, cost)
			if(!(upgrade_flags & UPGRADE_NOTAX) && !bypass_tax)
				SStreasury.mint(SStreasury.discretionary_fund, tax_amt, "[TAX_CATEGORY_IMPORT_TARIFF] ([src.name])")
				SStreasury.apply_concordat_tithe(cost, TAX_CATEGORY_IMPORT_TARIFF, "[src.name]")
				record_featured_stat(FEATURED_STATS_TAX_PAYERS, H, tax_amt)
				record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
				record_round_statistic(STATS_REVENUE_IMPORT_TARIFF, tax_amt)
				tariff_collected_here += tax_amt
			else
				record_round_statistic(STATS_TAXES_EVADED, tax_amt)
				tariff_evaded_here += tax_amt
			for(var/pathi in PA.contains)
				var/obj/item/spawned = new pathi(get_turf(usr))
				if(istype(spawned))
					spawned.atc_sealed = TRUE
			return TRUE
		if("hail")
			if(!is_command_center || !(H.job in profit_id) || !SSmerchant_trade)
				return TRUE
			var/ship_id = "[params["ship_id"]]"
			var/datum/trade_ship/target = SSmerchant_trade.find_ship_by_id(ship_id)
			var/result = SSmerchant_trade.hail_ship(ship_id, usr)
			handle_hail_result(result, target, usr)
			return TRUE
		if("send_away")
			if(!is_command_center || !(H.job in profit_id) || !SSmerchant_trade)
				return TRUE
			var/ship_id = "[params["ship_id"]]"
			var/result = SSmerchant_trade.send_away_ship(ship_id, usr)
			handle_send_away_result(result, usr)
			return TRUE
		if("cultural_buy")
			if(!SSmerchant_trade)
				return TRUE
			var/path = text2path(params["pack"])
			if(!ispath(path, /datum/supply_pack))
				return TRUE
			var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
			if(!PA)
				return TRUE
			var/ship_id = "[params["ship_id"]]"
			var/datum/trade_ship/source_ship = SSmerchant_trade.find_ship_by_id(ship_id)
			if(!source_ship || source_ship.dock_state != TRADE_SHIP_STATE_DOCKED)
				to_chat(H, span_warning("That vessel is no longer at the pier."))
				return TRUE
			var/discounted_base = round(PA.cost * (100 - TRADE_CULTURAL_SHIP_DISCOUNT_PERCENT) / 100)
			var/tax_amt = round(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * discounted_base)
			var/total_cost = discounted_base
			if(!(upgrade_flags & UPGRADE_NOTAX) && !bypass_tax)
				total_cost += tax_amt
			if(budget < total_cost)
				say("Not enough!")
				return TRUE
			if(!SSmerchant_trade.consume_cultural_stock(source_ship, path))
				to_chat(H, span_warning("That stock is no longer available."))
				return TRUE
			budget -= total_cost
			record_round_statistic(value_record_key, total_cost)
			record_round_statistic(STATS_TRADE_VALUE_IMPORTED, total_cost)
			if(!(upgrade_flags & UPGRADE_NOTAX) && !bypass_tax)
				SStreasury.mint(SStreasury.discretionary_fund, tax_amt, "[TAX_CATEGORY_IMPORT_TARIFF] ([src.name])")
				SStreasury.apply_concordat_tithe(total_cost, TAX_CATEGORY_IMPORT_TARIFF, "[src.name]")
				record_featured_stat(FEATURED_STATS_TAX_PAYERS, H, tax_amt)
				record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
				record_round_statistic(STATS_REVENUE_IMPORT_TARIFF, tax_amt)
				tariff_collected_here += tax_amt
			else
				record_round_statistic(STATS_TAXES_EVADED, tax_amt)
				tariff_evaded_here += tax_amt
			for(var/pathi in PA.contains)
				var/obj/item/spawned = new pathi(get_turf(usr))
				if(istype(spawned))
					spawned.atc_sealed = TRUE
			return TRUE
		if("bulk_buy")
			if(!is_command_center || !(H.job in profit_id) || !SSmerchant_trade)
				return TRUE
			var/ship_id = "[params["ship_id"]]"
			var/good_id = "[params["good"]]"
			var/qty = text2num(params["qty"])
			if(!qty || qty < 1)
				return TRUE
			var/datum/trade_ship/source_ship = SSmerchant_trade.find_ship_by_id(ship_id)
			if(!source_ship || source_ship.dock_state != TRADE_SHIP_STATE_DOCKED)
				to_chat(H, span_warning("That vessel is no longer at the pier."))
				return TRUE
			var/list/line = null
			for(var/list/L in source_ship.bulk_supplies)
				if(L["good"] == good_id)
					line = L
					break
			if(!line)
				to_chat(H, span_warning("That cargo is no longer on offer."))
				return TRUE
			var/datum/trade_good/TG = GLOB.trade_goods[good_id]
			if(!TG || !TG.item_type)
				to_chat(H, span_warning("That cargo cannot be handled at this pier."))
				return TRUE
			qty = min(qty, line["qty_target"] - line["qty_fulfilled"])
			if(qty < 1)
				to_chat(H, span_warning("That cargo is sold out."))
				return TRUE
			var/unit_cost = line["offered_price"]
			var/gross = unit_cost * qty
			var/tariff_active = !(upgrade_flags & UPGRADE_NOTAX) && !bypass_tax
			var/tariff_float = SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * gross
			var/total_cost = gross + (tariff_active ? round(tariff_float) : 0)
			if(budget < total_cost)
				say("Not enough!")
				return TRUE
			line["qty_fulfilled"] += qty
			budget -= total_cost
			record_round_statistic(value_record_key, total_cost)
			record_round_statistic(STATS_TRADE_VALUE_IMPORTED, total_cost)
			if(tariff_active)
				if(tariff_float > 0)
					SStreasury.mint_fractional(SStreasury.discretionary_fund, tariff_float, "[TAX_CATEGORY_IMPORT_TARIFF] (bulk import: [TG.name] x[qty])")
					SStreasury.apply_concordat_tithe(gross, TAX_CATEGORY_IMPORT_TARIFF, "bulk import")
					record_featured_stat(FEATURED_STATS_TAX_PAYERS, H, round(tariff_float))
					record_round_statistic(STATS_TAXES_COLLECTED, round(tariff_float))
					record_round_statistic(STATS_REVENUE_IMPORT_TARIFF, round(tariff_float))
					tariff_collected_here += round(tariff_float)
			else
				record_round_statistic(STATS_TAXES_EVADED, round(tariff_float))
				tariff_evaded_here += round(tariff_float)
			var/turf/T = get_turf(src)
			for(var/i in 1 to qty)
				var/obj/item/spawned = new TG.item_type(T)
				if(istype(spawned))
					spawned.atc_sealed = TRUE
			playsound(loc, 'sound/misc/gold_misc.ogg', 70, FALSE, -1)
			to_chat(H, span_notice("You buy [qty] [TG.name] from [source_ship.ship_name] for [total_cost]m[tariff_active && tariff_float > 0 ? " (incl. [round(tariff_float)]m Crown duty)" : ""]."))
			return TRUE

/obj/structure/roguemachine/goldface/proc/handle_hail_result(result, datum/trade_ship/ship, mob/user)
	switch(result)
		if("ok")
			to_chat(user, span_notice("You signal the [ship.ship_name] to make port. She is being brought in now."))
			speak_captain_hail(ship, user)
		if("ok_first")
			var/datum/foreign_realm/realm = SSmerchant_trade.realms[ship.realm_id]
			var/realm_name = realm ? realm.name : ship.realm_id
			to_chat(user, span_notice("You signal the [ship.ship_name] to make port. She is being brought in now."))
			to_chat(user, span_info("The captain of the [ship.ship_name] is the first of [realm_name] to make port this week. They bring fresh dispatches from [realm_name] - their markets and news are now clear to you."))
			speak_captain_hail(ship, user)
		if("no_hails")
			to_chat(user, span_warning("You have no hails left to spend today."))
		if("no_dock_spots")
			to_chat(user, span_warning("The pier is full. Send a docked vessel away first."))
		if("ship_gone")
			to_chat(user, span_warning("That vessel is no longer answering hails."))

/obj/structure/roguemachine/goldface/proc/speak_captain_hail(datum/trade_ship/ship, mob/user)
	if(!ship)
		return
	var/datum/foreign_realm/realm = SSmerchant_trade.realms[ship.realm_id]
	if(!realm)
		return
	var/line = realm.pick_hail_line()
	if(!line)
		return
	say("Captain [ship.captain_name] sends their greeting: \"[line]\"")

/obj/structure/roguemachine/goldface/proc/handle_send_away_result(result, mob/user)
	switch(result)
		if("ok")
			to_chat(user, span_notice("You signal the vessel to cast off. The pier is yours again."))
		if("early")
			to_chat(user, span_warning("She has only just tied up. Give the captain a few moments to settle their business."))
		if("ship_gone")
			to_chat(user, span_warning("There is no vessel by that name at the pier."))

/obj/structure/roguemachine/goldface/obj_break(damage_flag)
	..()
	var/turf/T = get_turf(src)
	budget2change(budget, custom_turf = T)
	set_light(0)
	update_icon()
	icon_state = "goldvendor0"

/obj/structure/roguemachine/goldface/Destroy()
	set_light(0)
	return ..()

/obj/structure/roguemachine/goldface/Initialize()
	. = ..()
	update_icon()

#undef UPGRADE_NOTAX
