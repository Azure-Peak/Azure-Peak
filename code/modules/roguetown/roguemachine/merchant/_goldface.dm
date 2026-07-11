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
		"Seeds",
		"Tools",
		"Wardrobe",
		"Zadpacks",
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
		"Weapons (Bronze)",
		"Weapons (Steel)",
		"Weapons (Foreign)",
	)
	var/is_public = FALSE // Whether it is a public access vendor.
	var/extra_fee = 0 // Public-tier Porters/Gnomes margin tacked onto base price. Meant to make publicface very unprofitable until Gnomes are unlocked and the margin flows to the Merchant Fund.
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
		"Seeds",
		"Tools",
		"Weapons (Foreign)",
	)
	categories_gamer = list()

/obj/structure/roguemachine/goldface/public/examine()
	. = ..()
	. += "<span class='info'>A public version of the GOLDFACE. The company charges a hefty fee for its usage. Per agreement, it cannot be locked by anyone.</span>"

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
		"Weapons (Bronze)",
		"Weapons (Steel)",
	)
	categories_gamer = list()

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

/obj/structure/roguemachine/goldface/public/apothecary
	name = "Apothecary's SILVERFACE"
	lockid = "apothecary"
	profit_id = list("Head Physician","Apothecary")
	categories = list(
		"Potions",
	)
	categories_gamer = list()

/obj/structure/roguemachine/goldface/public/wretch_cat
	name = "Vile Vheslie"
	desc = "A ferocious little beast that hoards a mountain of goods under its home. The dreaded creechur is willing to part waes with its lower quality items..for a price."
	motto = "Hissss..." //Its a cat, sire.
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "vheslie"
	lockid = "Vheslie"
	profit_id = list("Bathmaster") //Hilarious (not you can unlock this)
	categories = list(
		"Apparel (Ascendant Amulets)", //Wretch Exclusive Supplies
		"Illict Medical Supplies",
		"Illict Utility Supplies",
		"Apparel", //Now just regular catagories
		"Adventuring Supplies",
		"Instruments",
		"Wardrobe",
		"Alcohols",
		"Consumable",
		"Armor (Light)",
		"Armor (Iron)",
		"Weapons (Ranged)",
		"Weapons (Iron and Shields)",
		"Weapons (Bronze)",
	)
	categories_gamer = list()

/obj/structure/roguemachine/goldface/Initialize()
	. = ..()
	update_icon()

/obj/structure/roguemachine/goldface/examine(mob/user)
	. = ..()
	if(SSmerchant_trade?.current_kinship_realm)
		var/datum/foreign_realm/KR = SSmerchant_trade.realms[SSmerchant_trade.current_kinship_realm]
		if(KR)
			. += span_info("The Realm of <b>[KR.name]</b> recognize the Factor as kin - buys cost -[round((1 - KINSHIP_BUY_MULT) * 100)]% and bulk-demand payouts gain +[round((KINSHIP_SELL_MULT - 1) * 100)]%.")
	if(SSmerchant_trade && ishuman(user))
		var/agent_realm = SSmerchant_trade.get_agent_personal_kinship_realm(user)
		if(agent_realm && agent_realm != SSmerchant_trade.current_kinship_realm)
			var/datum/foreign_realm/AKR = SSmerchant_trade.realms[agent_realm]
			if(AKR)
				. += span_info("As an Agent, you personally recognize <b>[AKR.name]</b> as kin - your goldface buys from their ships cost -[round((1 - KINSHIP_BUY_MULT) * 100)]%.")

/obj/structure/roguemachine/goldface/proc/get_effective_fee()
	if(is_public && SSmerchant_trade?.gnome_automation_unlocked)
		return SSmerchant_trade.silverface_margin_percent / 100
	return extra_fee

/obj/structure/roguemachine/goldface/proc/compute_pack_price(datum/supply_pack/PA)
	var/cost = PA.cost + PA.cost * get_effective_fee()
	if(!(upgrade_flags & UPGRADE_NOTAX) && !bypass_tax)
		cost += compute_pack_tax(PA)
	return round(cost)

/obj/structure/roguemachine/goldface/proc/compute_pack_tax(datum/supply_pack/PA)
	return round(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * PA.cost)

/obj/structure/roguemachine/goldface/proc/serialize_pack(datum/supply_pack/PA, tariff_active)
	var/base = round(PA.cost + PA.cost * get_effective_fee())
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
		if(is_public)
			to_chat(user, span_warning("This is a public vendor. Keys won't work here."))
			return
		if(K.lockid == lockid || istype(K, /obj/item/roguekey/skeleton))
			locked = !locked
			playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
			update_icon()
			if(locked)
				SStgui.close_uis(src)
			return
		else
			to_chat(user, span_warning("Wrong key."))
			return
	else if(istype(P, /obj/item/storage/keyring))
		var/right_key = FALSE
		for(var/obj/item/roguekey/KE in P.contents)
			if(KE.lockid == lockid || istype(KE, /obj/item/roguekey/skeleton))
				if(is_public)
					to_chat(user, span_warning("This is a public vendor. Keys won't work here."))
					return
				right_key = TRUE
				locked = !locked
				playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
				update_icon()
				if(locked)
					SStgui.close_uis(src)
				return
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
	if(locked)
		to_chat(user, span_warning("It's locked. Of course."))
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

/obj/structure/roguemachine/goldface/proc/is_chartered_agent(mob/living/carbon/human/H)
	return istype(H) && HAS_TRAIT(H, TRAIT_AGENT_MERCHANT)

/obj/structure/roguemachine/goldface/proc/can_view_harbor(mob/living/carbon/human/H)
	return istype(H) && ((H.job in profit_id) || is_chartered_agent(H))

/obj/structure/roguemachine/goldface/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/carbon/human/H = user
	var/can_read = istype(H) ? H.can_read(src, TRUE) : FALSE
	var/is_proprietor = istype(H) && (H.job in profit_id)
	var/is_agent_viewer = !is_proprietor && is_chartered_agent(H)
	var/dodging = (upgrade_flags & UPGRADE_NOTAX) || bypass_tax
	data["motto"] = motto
	data["budget"] = budget
	data["locked"] = locked ? TRUE : FALSE
	data["is_public"] = is_public ? TRUE : FALSE
	data["is_proprietor"] = is_proprietor ? TRUE : FALSE
	data["is_agent"] = is_agent_viewer ? TRUE : FALSE
	data["can_read"] = can_read ? TRUE : FALSE
	data["tariff_rate_pct"] = round(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * 100)
	data["tariff_paid"] = tariff_collected_here
	data["tariff_evaded"] = tariff_evaded_here
	data["dodging"] = dodging ? TRUE : FALSE
	if(is_public)
		var/effective_pct = round(get_effective_fee() * 100)
		data["public_margin_pct"] = effective_pct
		data["public_margin_label"] = SSmerchant_trade?.gnome_automation_unlocked ? "Gnomes' Margin" : "Porters' Margin"
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
	if(is_command_center && SSmerchant_trade && !locked)
		data["harbor"] = build_harbor_data(H)
	return data

/obj/structure/roguemachine/goldface/proc/build_harbor_data(mob/living/carbon/human/viewer)
	var/list/docked = list()
	var/list/pool = list()
	var/kin_realm = SSmerchant_trade.current_kinship_realm
	var/agent_kin_realm = SSmerchant_trade.get_agent_personal_kinship_realm(viewer)
	for(var/datum/trade_ship/ship in SSmerchant_trade.all_ships)
		var/is_docked = ship.dock_state == TRADE_SHIP_STATE_DOCKED
		var/global_kin = (kin_realm && ship.realm_id == kin_realm) ? TRUE : FALSE
		var/agent_kin = (!global_kin && agent_kin_realm && ship.realm_id == agent_kin_realm) ? TRUE : FALSE
		var/any_kin = global_kin || agent_kin
		var/list/row = list(
			"ship_id" = ship.ship_id,
			"ship_name" = ship.ship_name,
			"captain_name" = is_docked ? ship.captain_name : null,
			"port_of_origin" = ship.port_of_origin,
			"realm_id" = ship.realm_id,
			"is_kin" = any_kin ? TRUE : FALSE,
			"ship_type" = ship.ship_type,
			"tonnage" = ship.tonnage,
			"tonnage_mult" = ship.tonnage_scale_mult(),
			"expected_favor" = ship.expected_favor,
			"favor_earned" = ship.favor_earned,
			"auto_hailed" = ship.auto_hailed ? TRUE : FALSE,
		)
		if(is_docked)
			var/seconds_left = max(0, round((ship.dock_expires_at - world.time) / 10))
			row["seconds_until_departure"] = seconds_left
			var/honored = ship.expected_favor > 0 && ship.favor_earned >= ship.expected_favor
			row["can_send_away"] = (ship.auto_hailed || honored || world.time >= ship.docked_at + TRADE_SHIP_SEND_AWAY_GRACE) ? TRUE : FALSE
			if(any_kin)
				var/list/kin_supplies = list()
				for(var/list/L in ship.bulk_supplies)
					var/list/Lc = L.Copy()
					Lc["kin_offered_price"] = max(1, round(L["offered_price"] * KINSHIP_BUY_MULT))
					kin_supplies += list(Lc)
				row["bulk_supplies"] = kin_supplies
				if(global_kin)
					var/list/kin_demands = list()
					for(var/list/L in ship.bulk_demands)
						var/list/Lc = L.Copy()
						Lc["kin_offered_price"] = max(1, round(L["offered_price"] * KINSHIP_SELL_MULT))
						kin_demands += list(Lc)
					row["bulk_demands"] = kin_demands
				else
					row["bulk_demands"] = ship.bulk_demands.Copy()
			else
				row["bulk_supplies"] = ship.bulk_supplies.Copy()
				row["bulk_demands"] = ship.bulk_demands.Copy()
			docked += list(row)
		else
			pool += list(row)
	var/kinship_realm_id = SSmerchant_trade.current_kinship_realm
	var/list/realms = list()
	for(var/realm_id in SSmerchant_trade.realms)
		var/datum/foreign_realm/R = SSmerchant_trade.realms[realm_id]
		var/list/rrow = list(
			"id" = R.id,
			"name" = R.name,
			"is_kin" = (kinship_realm_id && R.id == kinship_realm_id) ? TRUE : FALSE,
			"cultural_goods" = R.cultural_goods ? R.cultural_goods.Copy() : list(),
			"cultural_pack_names" = cultural_pack_names(R.cultural_stock_pool),
			"basic_buys" = filtered_pool_summary(R, FALSE, TRUE),
			"rare_buys" = filtered_pool_summary(R, FALSE, FALSE),
			"basic_sells" = filtered_pool_summary(R, TRUE, TRUE),
			"rare_sells" = filtered_pool_summary(R, TRUE, FALSE),
			"demanded_categories" = R.demanded_categories ? R.demanded_categories.Copy() : list(),
		)
		var/list/condition_entries = list()
		for(var/datum/realm_condition/C as anything in SSmerchant_trade.active_conditions_for(R.id))
			condition_entries += list(list(
				"name" = C.name,
				"description" = C.description,
				"tone" = C.tone,
			))
		rrow["market_conditions"] = condition_entries
		realms += list(rrow)
	var/datum/foreign_realm/kin_realm_datum = kinship_realm_id ? SSmerchant_trade.realms[kinship_realm_id] : null
	var/datum/foreign_realm/agent_kin_datum = agent_kin_realm ? SSmerchant_trade.realms[agent_kin_realm] : null
	return list(
		"ships_docked" = docked,
		"ships_pool" = pool,
		"realms" = realms,
		"hails_remaining" = SSmerchant_trade.hails_remaining,
		"hails_per_day" = TRADE_SHIPS_HAIL_PER_DAY,
		"dock_spots_used" = length(docked),
		"dock_spots_max" = SSmerchant_trade.get_dock_spots_max(),
		"cultural_stock" = build_cultural_stock_data(viewer),
		"catalogs" = build_catalog_data(viewer),
		"merchant_levy_percent" = SSmerchant_trade.merchant_levy_percent,
		"merchant_levy_cap" = TRADE_MERCHANT_LEVY_CAP_PERCENT,
		"merchant_levy_collected" = SSmerchant_trade.merchant_levy_collected,
		"merchant_levy_taxed" = SSmerchant_trade.merchant_levy_taxed,
		"favor" = build_favor_data(),
		"ledger" = build_ledger_data(),
		"market_data" = build_goldface_market_data(),
		"kinship" = list(
			"realm_id" = kinship_realm_id,
			"realm_name" = kin_realm_datum ? kin_realm_datum.name : null,
			"origin_name" = SSmerchant_trade.current_kinship_origin_name,
			"buy_pct" = round((1 - KINSHIP_BUY_MULT) * 100),
			"sell_pct" = round((KINSHIP_SELL_MULT - 1) * 100),
			"agent_realm_id" = agent_kin_realm,
			"agent_realm_name" = agent_kin_datum ? agent_kin_datum.name : null,
		),
	)

/obj/structure/roguemachine/goldface/proc/build_goldface_market_data()
	var/list/data = list(
		"categories" = list(),
		"pop_snapshot" = 0,
		"category_count" = 0,
	)
	if(!SSmerchant_trade)
		return data
	data["pop_snapshot"] = SSmerchant_trade.pool_pop_snapshot
	var/list/rows = list()
	for(var/cat in SSmerchant_trade.pool_capacity)
		var/cap = SSmerchant_trade.pool_capacity[cat] || 0
		var/consumed = SSmerchant_trade.pool_consumed[cat] || 0
		var/fill_ratio = cap > 0 ? min(1, consumed / cap) : 0
		var/refused = SSmerchant_trade.get_saturation_factor(cat) <= 0
		var/demand_mult = SSmerchant_trade.get_demand_multiplier(cat)
		var/pending = SSmerchant_trade.pending_ship_demand[cat] || 0
		rows += list(list(
			"category" = cat,
			"capacity" = cap,
			"consumed" = consumed,
			"fill_ratio" = fill_ratio,
			"refused" = refused,
			"demand_mult" = demand_mult,
			"pending_ship_demand" = pending,
		))
	data["categories"] = rows
	data["category_count"] = length(rows)
	data["theme_dispatch"] = build_market_theme_dispatch(SSmerchant_trade.pool_theme_jitters)
	data["realm_demand_matrix"] = SSmerchant_trade.build_realm_demand_matrix()
	data["all_buckets"] = all_navigator_buckets()
	return data

/obj/structure/roguemachine/goldface/proc/build_ledger_data()
	var/list/fund_log = list()
	for(var/list/entry as anything in SSmerchant_trade.merchant_fund_log)
		fund_log += list(entry.Copy())
	return list(
		"merchant_fund_balance" = SStreasury.merchant_fund ? SStreasury.merchant_fund.balance : 0,
		"levy_collected" = SSmerchant_trade.merchant_levy_collected,
		"levy_taxed" = SSmerchant_trade.merchant_levy_taxed,
		"gnome_margin_collected" = SSmerchant_trade.gnome_margin_collected,
		"silverface_margin_percent" = SSmerchant_trade.silverface_margin_percent,
		"fund_log" = fund_log,
	)

/obj/structure/roguemachine/goldface/proc/build_favor_data()
	var/list/ledger = list()
	for(var/list/entry as anything in SSmerchant_trade.favor_ledger)
		ledger += list(entry.Copy())
	return list(
		"current" = SSmerchant_trade.merchant_favor,
		"high_water" = SSmerchant_trade.merchant_favor_high,
		"triumph_bonus" = SSmerchant_trade.favor_triumph_bonus(),
		"triumph_cap" = FAVOR_TRIUMPH_BONUS_CAP,
		"bracket_floor" = SSmerchant_trade.favor_current_bracket_floor(),
		"bracket_next" = SSmerchant_trade.favor_next_bracket(),
		"ledger" = ledger,
		"gnome_cost" = GNOME_AUTOMATION_FAVOR,
		"gnome_unlocked" = SSmerchant_trade.gnome_automation_unlocked,
		"pier_cost" = ADDITIONAL_PIER_FAVOR,
		"pier_rented" = SSmerchant_trade.extra_pier_rented,
		"auto_hailer_cost" = AUTO_HAILER_FAVOR,
		"auto_hailer_unlocked" = SSmerchant_trade.auto_hailer_unlocked,
		"auto_hailer_on" = SSmerchant_trade.auto_hailer_on,
		"brackets" = list(FAVOR_TRIUMPH_BRACKET_1, FAVOR_TRIUMPH_BRACKET_2, FAVOR_TRIUMPH_BRACKET_3, FAVOR_TRIUMPH_BRACKET_4, FAVOR_TRIUMPH_BRACKET_5, FAVOR_TRIUMPH_BRACKET_6),
		"from_sendoffs" = SSmerchant_trade.favor_from_sendoffs,
		"from_navigator" = SSmerchant_trade.favor_from_navigator,
		"from_goldface" = SSmerchant_trade.favor_from_goldface,
		"from_silverface" = SSmerchant_trade.favor_from_silverface,
		"penalties" = SSmerchant_trade.favor_penalties,
	)

/obj/structure/roguemachine/goldface/proc/cultural_pack_names(list/pack_paths)
	var/list/result = list()
	if(!length(pack_paths))
		return result
	for(var/path in pack_paths)
		var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
		if(PA)
			result += PA.name
	return result

/obj/structure/roguemachine/goldface/proc/filtered_pool_summary(datum/foreign_realm/R, want_supply, want_always)
	var/list/result = list()
	for(var/list/entry in R.get_pool_ui_summary(want_supply))
		if(want_always && !entry["always"])
			continue
		if(!want_always && entry["always"])
			continue
		result += list(list(
			"name" = entry["name"],
			"delta" = entry["delta_steps"],
			"removed" = entry["removed"],
			"added_only" = entry["added_only"],
		))
	return result

/obj/structure/roguemachine/goldface/proc/build_cultural_stock_data(mob/living/carbon/human/viewer)
	var/list/result = list()
	var/tariff_active = !(upgrade_flags & UPGRADE_NOTAX) && !bypass_tax
	var/tariff_rate = SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF)
	var/kin_realm = SSmerchant_trade?.current_kinship_realm
	var/agent_kin_realm = SSmerchant_trade?.get_agent_personal_kinship_realm(viewer)
	for(var/datum/trade_ship/ship in SSmerchant_trade.all_ships)
		if(ship.dock_state != TRADE_SHIP_STATE_DOCKED)
			continue
		var/global_kin = (kin_realm && ship.realm_id == kin_realm) ? TRUE : FALSE
		var/agent_kin = (!global_kin && agent_kin_realm && ship.realm_id == agent_kin_realm) ? TRUE : FALSE
		var/is_kin = global_kin || agent_kin
		for(var/list/entry in ship.cultural_stock)
			if(entry["qty"] <= 0)
				continue
			var/discounted = round(entry["base_cost"] * (100 - TRADE_CULTURAL_SHIP_DISCOUNT_PERCENT) / 100)
			var/pre_kin = discounted
			if(is_kin)
				discounted = max(1, round(discounted * KINSHIP_BUY_MULT))
			var/tariff = tariff_active ? round(tariff_rate * discounted) : 0
			result += list(list(
				"pack" = entry["pack"],
				"name" = entry["name"],
				"qty" = entry["qty"],
				"pack_qty" = entry["pack_qty"],
				"base_cost" = entry["base_cost"],
				"price_base" = discounted,
				"price_base_pre_kin" = pre_kin,
				"price_tariff" = tariff,
				"price" = discounted + tariff,
				"is_kin" = is_kin,
				"ship_id" = ship.ship_id,
				"ship_name" = ship.ship_name,
			))
	return result

/obj/structure/roguemachine/goldface/proc/build_catalog_data(mob/living/carbon/human/viewer)
	var/list/result = list()
	if(!SSmerchant_trade)
		return result
	var/tariff_active = !(upgrade_flags & UPGRADE_NOTAX) && !bypass_tax
	var/tariff_rate = SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF)
	for(var/cid in SSmerchant_trade.catalogs)
		var/datum/merchant_catalog/C = SSmerchant_trade.catalogs[cid]
		var/unlocked = SSmerchant_trade.catalog_unlocked(cid)
		var/access_basis = SSmerchant_trade.catalog_access_basis(C, viewer)
		var/kin_access = !isnull(access_basis)
		var/accessible = unlocked || kin_access
		var/list/entries = list()
		if(accessible)
			for(var/path in C.stock)
				var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
				if(!PA)
					continue
				var/pre_kin = PA.cost
				var/base = kin_access ? max(1, round(PA.cost * CATALOG_KIN_BUY_MULT)) : PA.cost
				var/tariff = tariff_active ? round(tariff_rate * base) : 0
				entries += list(list(
					"pack" = "[PA.type]",
					"name" = PA.name,
					"pack_qty" = PA.no_name_quantity ? 1 : PA.contains.len,
					"price_base" = base,
					"price_base_pre_kin" = pre_kin,
					"price_tariff" = tariff,
					"price" = base + tariff,
					"qty" = SSmerchant_trade.catalog_stock_remaining(cid, path),
					"stock_max" = C.stock[path],
				))
		result += list(list(
			"id" = C.id,
			"name" = C.name,
			"desc" = C.desc,
			"favor_cost" = C.favor_cost,
			"home_label" = C.home_label,
			"unlocked" = unlocked,
			"origin_access" = kin_access,
			"access_basis" = access_basis,
			"home_realm_name" = C.home_origin_name,
			"accessible" = accessible,
			"discount_pct" = round((1 - CATALOG_KIN_BUY_MULT) * 100),
			"entries" = entries,
		))
	return result

/obj/structure/roguemachine/goldface/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	if(action == "help")
		open_economy_guidebook(usr, "Merchant", /datum/book_entry/treasury_merchant/goldface)
		return TRUE
	if(locked && !is_public)
		return
	var/mob/living/carbon/human/H = usr
	if(SSmerchant_trade && (H.job in profit_id))
		SSmerchant_trade.touch_merchant_activity()
	switch(action)
		if("changecat")
			var/cat = "[params["category"]]"
			if(cat == "")
				current_cat = ""
			else if(cat in categories)
				current_cat = cat
				search_query = ""
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
			playsound(loc, 'sound/misc/gold_misc.ogg', 70, FALSE, -1)
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
			if(is_public && SSmerchant_trade?.gnome_automation_unlocked)
				var/margin = round(PA.cost * get_effective_fee())
				if(margin > 0)
					SStreasury.mint(SStreasury.merchant_fund, margin, "Company Gnomes margin ([src.name])")
					SSmerchant_trade.gnome_margin_collected += margin
					SSmerchant_trade.log_fund_movement("Gnomes margin ([src.name])", margin)
			if(cost > 0 && SSmerchant_trade)
				var/passive = round(cost * FAVOR_PASSIVE_TRADE_FRACTION)
				SSmerchant_trade.adjust_merchant_favor(passive)
				if(is_public)
					SSmerchant_trade.favor_from_silverface += passive
				else
					SSmerchant_trade.favor_from_goldface += passive
			for(var/pathi in PA.contains)
				var/obj/item/spawned = new pathi(get_turf(usr))
				if(istype(spawned))
					spawned.atc_sealed = TRUE
			return TRUE
		if("hail")
			if(!is_command_center || !can_view_harbor(H) || !SSmerchant_trade)
				return TRUE
			var/ship_id = "[params["ship_id"]]"
			var/datum/trade_ship/target = SSmerchant_trade.find_ship_by_id(ship_id)
			var/result = SSmerchant_trade.hail_ship(ship_id, usr)
			handle_hail_result(result, target, usr)
			return TRUE
		if("send_away")
			if(!is_command_center || !can_view_harbor(H) || !SSmerchant_trade)
				return TRUE
			var/ship_id = "[params["ship_id"]]"
			var/result = SSmerchant_trade.send_away_ship(ship_id, usr)
			handle_send_away_result(result, usr)
			return TRUE
		if("cultural_buy")
			if(!is_command_center || !SSmerchant_trade)
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
			var/kin_saving = 0
			if(SSmerchant_trade)
				var/kin_mult = SSmerchant_trade.get_effective_buy_mult(source_ship.realm_id, H)
				if(kin_mult < 1)
					var/pre_kin = discounted_base
					discounted_base = max(1, round(discounted_base * kin_mult))
					kin_saving = pre_kin - discounted_base
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
			source_ship.favor_earned += discounted_base
			var/tariff_active_cultural = !(upgrade_flags & UPGRADE_NOTAX) && !bypass_tax
			to_chat(H, span_notice("You buy [PA.name] from [source_ship.ship_name] for [total_cost]m[tariff_active_cultural && tax_amt > 0 ? " (incl. [tax_amt]m Crown duty)" : ""][kin_saving > 0 ? " (Kinship saved [kin_saving]m)" : ""]."))
			playsound(loc, 'sound/misc/gold_misc.ogg', 70, FALSE, -1)
			return TRUE
		if("catalog_buy")
			if(!is_command_center || !SSmerchant_trade)
				return TRUE
			var/cid = "[params["catalog"]]"
			var/datum/merchant_catalog/C = SSmerchant_trade.catalogs[cid]
			if(!C)
				return TRUE
			var/kin_access = !isnull(SSmerchant_trade.catalog_access_basis(C, H))
			if(!SSmerchant_trade.catalog_unlocked(cid) && !kin_access)
				to_chat(H, span_warning("The [C.name] is not open."))
				return TRUE
			var/path = text2path(params["pack"])
			if(!ispath(path, /datum/supply_pack) || !(path in C.stock))
				return TRUE
			var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
			if(!PA)
				return TRUE
			if(SSmerchant_trade.catalog_stock_remaining(cid, path) <= 0)
				to_chat(H, span_warning("The [C.name] has none of that left. Wait until the next restock."))
				return TRUE
			var/base_cost = PA.cost
			var/kin_saving = 0
			if(kin_access)
				var/pre_kin = base_cost
				base_cost = max(1, round(base_cost * CATALOG_KIN_BUY_MULT))
				kin_saving = pre_kin - base_cost
			var/tariff_active = !(upgrade_flags & UPGRADE_NOTAX) && !bypass_tax
			var/tax_amt = round(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * base_cost)
			var/total_cost = base_cost
			if(tariff_active)
				total_cost += tax_amt
			if(budget < total_cost)
				say("Not enough!")
				return TRUE
			budget -= total_cost
			SSmerchant_trade.consume_catalog_stock(cid, path)
			record_round_statistic(value_record_key, total_cost)
			record_round_statistic(STATS_TRADE_VALUE_IMPORTED, total_cost)
			if(tariff_active)
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
			to_chat(H, span_notice("You order [PA.name] from the [C.name] for [total_cost]m[tariff_active && tax_amt > 0 ? " (incl. [tax_amt]m Crown duty)" : ""][kin_saving > 0 ? " (Kinship saved [kin_saving]m)" : ""]."))
			playsound(loc, 'sound/misc/gold_misc.ogg', 70, FALSE, -1)
			return TRUE
		if("bulk_buy")
			if(!is_command_center || !can_view_harbor(H) || !SSmerchant_trade)
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
			var/kin_saving = 0
			if(SSmerchant_trade)
				var/kin_mult = SSmerchant_trade.get_effective_buy_mult(source_ship.realm_id, H)
				if(kin_mult < 1)
					var/pre_kin = gross
					var/kin_unit = max(1, round(unit_cost * kin_mult))
					gross = kin_unit * qty
					kin_saving = pre_kin - gross
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
			source_ship.favor_earned += gross
			playsound(loc, 'sound/misc/gold_misc.ogg', 70, FALSE, -1)
			to_chat(H, span_notice("You buy [qty] [TG.name] from [source_ship.ship_name] for [total_cost]m[tariff_active && tariff_float > 0 ? " (incl. [round(tariff_float)]m Crown duty)" : ""][kin_saving > 0 ? " (Kinship saved [kin_saving]m)" : ""]."))
			return TRUE
		if("set_levy")
			if(!is_command_center || !(H.job in profit_id) || !SSmerchant_trade)
				return TRUE
			var/requested = text2num(params["percent"])
			if(isnull(requested))
				return TRUE
			var/applied = SSmerchant_trade.set_merchant_levy(requested)
			to_chat(H, span_notice("Merchant's levy set to <b>[applied]%</b>."))
			playsound(loc, 'sound/misc/gold_misc.ogg', 70, FALSE, -1)
			return TRUE
		if("set_gnome_margin")
			if(!is_command_center || !(H.job in profit_id) || !SSmerchant_trade)
				return TRUE
			if(!SSmerchant_trade.gnome_automation_unlocked)
				to_chat(H, span_warning("The Company Gnomes have not been called in yet."))
				return TRUE
			var/requested = text2num(params["percent"])
			if(isnull(requested))
				return TRUE
			var/applied = SSmerchant_trade.set_silverface_margin(requested)
			to_chat(H, span_notice("Silverface margin set to <b>[applied]%</b>. The Gnomes adjust their pricing accordingly."))
			playsound(loc, 'sound/misc/gold_misc.ogg', 70, FALSE, -1)
			return TRUE
		if("unlock_gnomes")
			if(try_favor_unlock(H, SSmerchant_trade?.gnome_automation_unlocked, GNOME_AUTOMATION_FAVOR, "The Company Gnomes are already on the books.", "Not enough favor with the Company to call in the gnomes."))
				if(SSmerchant_trade.unlock_gnome_automation())
					scom_announce("The Azurian Trading Company has dispatched a gnomish crew to staff the public stalls.")
					to_chat(H, span_notice("The Company Gnomes are now staffing every Silverface. Their margin flows to your fund."))
					playsound(loc, 'sound/misc/gold_misc.ogg', 70, FALSE, -1)
			return TRUE
		if("rent_pier")
			if(try_favor_unlock(H, SSmerchant_trade?.extra_pier_rented, ADDITIONAL_PIER_FAVOR, "The extra pier is already paid up for the week.", "Not enough favor with the Company to lean on the dockmaster."))
				if(SSmerchant_trade.rent_extra_pier())
					scom_announce("Word travels along the wharf - the fishermen's pier has been let to the Azurian Trading Company for the week.")
					to_chat(H, span_notice("The extra pier is yours. The harbor can now hold one more vessel at a time."))
					playsound(loc, 'sound/misc/gold_misc.ogg', 70, FALSE, -1)
			return TRUE
		if("unlock_auto_hailer")
			if(try_favor_unlock(H, SSmerchant_trade?.auto_hailer_unlocked, AUTO_HAILER_FAVOR, "The harbor crew already has a retainer with the Company.", "Not enough favor with the Company to retain the harbor crew."))
				if(SSmerchant_trade.unlock_auto_hailer())
					to_chat(H, span_notice("The harbor crew is on retainer. Toggle the Auto-Hailer when you wish them to work."))
					playsound(loc, 'sound/misc/gold_misc.ogg', 70, FALSE, -1)
			return TRUE
		if("unlock_catalog")
			var/cid = "[params["catalog"]]"
			if(!SSmerchant_trade)
				return TRUE
			var/datum/merchant_catalog/C = SSmerchant_trade.catalogs[cid]
			if(!C)
				return TRUE
			if(try_favor_unlock(H, SSmerchant_trade.catalog_unlocked(cid), C.favor_cost, "The [C.name] is already open to the company.", "Not enough favor with the Company to open the [C.name]."))
				if(SSmerchant_trade.unlock_catalog(cid))
					scom_announce("The Azurian Trading Company has secured a trade agreement with the [C.name].")
					to_chat(H, span_notice("The [C.name] is now open to the company."))
					playsound(loc, 'sound/misc/gold_misc.ogg', 70, FALSE, -1)
			return TRUE
		if("toggle_auto_hailer")
			if(!is_command_center || !(H.job in profit_id) || !SSmerchant_trade)
				return TRUE
			if(!SSmerchant_trade.auto_hailer_unlocked)
				to_chat(H, span_warning("The harbor crew is not yet on retainer."))
				return TRUE
			if(SSmerchant_trade.toggle_auto_hailer())
				if(SSmerchant_trade.auto_hailer_on)
					to_chat(H, span_notice("The harbor crew begins their rounds. Ships will be hailed and dismissed in your absence."))
				else
					to_chat(H, span_notice("The harbor crew stands down. The wharf returns to your sole judgement."))
				playsound(loc, 'sound/misc/gold_misc.ogg', 70, FALSE, -1)
			return TRUE

/obj/structure/roguemachine/goldface/proc/try_favor_unlock(mob/living/carbon/human/H, already_unlocked, cost, already_msg, broke_msg)
	if(!is_command_center || !(H.job in profit_id) || !SSmerchant_trade)
		return FALSE
	if(already_unlocked)
		to_chat(H, span_warning(already_msg))
		return FALSE
	if(SSmerchant_trade.merchant_favor < cost)
		to_chat(H, span_warning(broke_msg))
		return FALSE
	return TRUE

/obj/structure/roguemachine/goldface/proc/handle_hail_result(result, datum/trade_ship/ship, mob/user)
	switch(result)
		if("ok")
			to_chat(user, span_notice("You signal the [ship.ship_name] to make port. She is being brought in now."))
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
