/obj/structure/roguemachine/noticeboard
	name = "Notice Board"
	desc = "A large wooden notice board, carrying postings from all across Azuria. A ZAD perch sits atop it."
	icon = 'icons/roguetown/structure/noticeboard64.dmi'
	icon_state = "noticeboard0"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	blade_dulling = DULLING_BASH
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	var/last_market_refresh = 0

/obj/structure/roguemachine/noticeboard/Initialize()
	. = ..()
	SSroguemachine.noticeboards += src
	update_icon()
	if(SSmerchant_trade)
		SSmerchant_trade.register_market_watcher(src)

/obj/structure/roguemachine/noticeboard/Destroy()
	SSroguemachine.noticeboards -= src
	if(SSmerchant_trade)
		SSmerchant_trade.unregister_market_watcher(src)
	return ..()

/obj/structure/roguemachine/noticeboard/wall
	icon = 'icons/roguetown/structure/noticeboard32.dmi'
	density = FALSE
	layer = ABOVE_MOB_LAYER
	pixel_y = 32

/obj/structure/roguemachine/noticeboard/wall/OnCrafted(dirin, user)
	pixel_x = 0
	pixel_y = 0
	switch(dirin)
		if(NORTH)
			pixel_y = 32
		if(SOUTH)
			pixel_y = -32
		if(EAST)
			pixel_x = 32
		if(WEST)
			pixel_x = -32
	. = ..()

/obj/structure/roguemachine/noticeboard/update_icon()
	. = ..()
	var/total_length = length(GLOB.noticeboard_notices) + length(GLOB.noticeboard_listings)
	switch(total_length)
		if(0)
			icon_state = "noticeboard0"
		if(1 to 3)
			icon_state = "noticeboard1"
		if(4 to 6)
			icon_state = "noticeboard2"
		else
			icon_state = "noticeboard3"

/obj/structure/roguemachine/noticeboard/attack_hand(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	open_noticeboard_tgui(user)

/obj/structure/roguemachine/noticeboard/proc/open_noticeboard_tgui(mob/user)
	var/datum/tgui/ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "Noticeboard")
		ui.open()

/obj/structure/roguemachine/noticeboard/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/noticeboard/ui_interact(mob/user, datum/tgui/ui)
	SStgui.try_update_ui(user, src, ui)

/obj/structure/roguemachine/noticeboard/ui_static_data(mob/user)
	var/list/data = list()
	data["realm_name"] = SSticker.realm_name
	data["market_data"] = build_market_data()
	return data

/obj/structure/roguemachine/noticeboard/ui_data(mob/user)
	var/list/data = list()
	data["scout_regions"] = build_scout_regions()
	data["trade_orders"] = build_trade_orders()
	data["harbor_demands"] = build_harbor_demands()
	data["charters"] = build_charters()
	data["economic_events"] = build_economic_events()
	data["mercenary_roster"] = build_mercenary_roster()
	if(!ishuman(user))
		data["postings"] = list()
		data["can_post_listing"] = FALSE
		data["can_authority_remove"] = FALSE
		data["user_real_name"] = ""
		data["user_default_name"] = ""
		data["user_default_role"] = ""
		data["has_active_notice"] = FALSE
		data["has_active_listing"] = FALSE
		return data
	var/mob/living/carbon/human/H = user
	var/can_listing = (H.job in NOTICEBOARD_LISTING_ROLES) ? TRUE : FALSE
	var/can_auth_remove = (H.job in NOTICEBOARD_AUTHORITY_ROLES) ? TRUE : FALSE
	var/list/postings = list()
	var/has_active_listing = FALSE
	var/has_active_notice = FALSE
	for(var/datum/noticeboard_posting/P in GLOB.noticeboard_listings)
		if(P.truename == H.real_name)
			has_active_listing = TRUE
		postings += list(serialize_posting(P, H, can_auth_remove))
	for(var/datum/noticeboard_posting/P in GLOB.noticeboard_notices)
		if(P.truename == H.real_name)
			has_active_notice = TRUE
		postings += list(serialize_posting(P, H, can_auth_remove))
	data["postings"] = postings
	data["can_post_listing"] = can_listing
	data["can_authority_remove"] = can_auth_remove
	data["user_real_name"] = H.real_name
	data["user_default_name"] = H.real_name
	data["user_default_role"] = H.job || ""
	data["has_active_notice"] = has_active_notice
	data["has_active_listing"] = has_active_listing
	return data

/obj/structure/roguemachine/noticeboard/proc/build_scout_regions()
	var/list/blockade_by_threat_name = list()
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		if(B.threat_region_name)
			blockade_by_threat_name[B.threat_region_name] = B
	var/list/rows = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		var/list/row = list()
		row["region_name"] = TR.region_name
		row["danger_level"] = TR.get_danger_level()
		row["danger_color"] = TR.get_danger_color()
		row["ic_descriptions"] = TR.get_ic_description()
		var/datum/blockade/B = blockade_by_threat_name[TR.region_name]
		if(B)
			var/datum/quest_faction/F = B.get_faction()
			var/datum/economic_region/ER = B.get_region()
			row["blockaded"] = TRUE
			row["blockade_writ_out"] = B.has_active_scroll() ? TRUE : FALSE
			row["blockade_faction_label"] = F ? "[F.group_word] of [F.name_plural]" : (B.faction_id || "")
			row["blockade_region_label"] = ER ? ER.name : (B.region_id || "")
			row["blockade_days_active"] = max(0, GLOB.dayspassed - B.day_started)
		else
			row["blockaded"] = FALSE
			row["blockade_writ_out"] = FALSE
			row["blockade_faction_label"] = ""
			row["blockade_region_label"] = ""
			row["blockade_days_active"] = 0
		rows += list(row)
	return rows

/obj/structure/roguemachine/noticeboard/proc/build_trade_orders()
	var/list/rows = list()
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(O.is_fulfilled)
			continue
		var/list/row = list()
		var/datum/economic_region/region = GLOB.economic_regions[O.region_id]
		row["name"] = O.name
		row["region_label"] = region ? region.name : O.region_id
		row["description"] = O.description || ""
		row["days_left"] = max(0, O.day_expires - GLOB.dayspassed)
		row["total_payout"] = O.total_payout
		row["urgent"] = istype(O, /datum/standing_order/urgent) ? TRUE : FALSE
		row["blockaded"] = (region?.is_region_blockaded) ? TRUE : FALSE
		row["petitioned"] = O.petitioned ? TRUE : FALSE
		var/has_warehouse = FALSE
		var/has_stockpile = FALSE
		var/list/requirements = list()
		for(var/good_id in O.required_items)
			var/datum/trade_good/tg = GLOB.trade_goods[good_id]
			if(SSeconomy.get_good_route(good_id) == "warehouse")
				has_warehouse = TRUE
			else
				has_stockpile = TRUE
			requirements += list(list(
				"label" = tg ? tg.name : good_id,
				"quantity" = O.required_items[good_id],
			))
		row["warehouse"] = has_warehouse
		row["stockpile"] = has_stockpile
		row["requirements"] = requirements
		rows += list(row)
	return rows

/obj/structure/roguemachine/noticeboard/proc/build_harbor_demands()
	var/list/rows = list()
	if(!SSmerchant_trade)
		return rows
	for(var/datum/trade_ship/ship in SSmerchant_trade.all_ships)
		if(ship.dock_state != TRADE_SHIP_STATE_DOCKED)
			continue
		var/datum/foreign_realm/realm = SSmerchant_trade.realms[ship.realm_id]
		var/realm_name = realm ? realm.name : ship.realm_id
		var/seconds_left = max(0, round((ship.dock_expires_at - world.time) / 10))
		var/list/lines = list()
		for(var/list/line in ship.bulk_demands)
			var/remaining = line["qty_target"] - line["qty_fulfilled"]
			if(remaining <= 0)
				continue
			lines += list(list(
				"good_name" = line["good_name"],
				"qty_target" = line["qty_target"],
				"qty_fulfilled" = line["qty_fulfilled"],
				"qty_remaining" = remaining,
				"offered_price" = line["offered_price"],
			))
		var/list/cultural = list()
		for(var/list/entry in ship.cultural_stock)
			if(entry["qty"] <= 0)
				continue
			var/discounted = round(entry["base_cost"] * (100 - TRADE_CULTURAL_SHIP_DISCOUNT_PERCENT) / 100)
			cultural += list(list(
				"name" = entry["name"],
				"qty" = entry["qty"],
				"base_cost" = entry["base_cost"],
				"price" = discounted,
			))
		if(!length(lines) && !length(cultural))
			continue
		rows += list(list(
			"ship_id" = ship.ship_id,
			"ship_name" = ship.ship_name,
			"realm_name" = realm_name,
			"realm_id" = ship.realm_id,
			"seconds_until_departure" = seconds_left,
			"lines" = lines,
			"cultural_stock" = cultural,
		))
	return rows

/obj/structure/roguemachine/noticeboard/proc/build_charters()
	var/list/rows = list()
	for(var/id in SStreasury.decrees)
		var/datum/decree/D = SStreasury.decrees[id]
		if(!D.has_ever_been_active)
			continue
		rows += list(list(
			"name" = D.name,
			"year" = D.year,
			"active" = D.active ? TRUE : FALSE,
			"flavor_text" = D.get_display_flavor_text(),
		))
	return rows

/obj/structure/roguemachine/noticeboard/proc/build_economic_events()
	var/list/rows = list()
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		var/list/affected = list()
		for(var/good_id in E.affected_goods)
			var/datum/trade_good/tg = GLOB.trade_goods[good_id]
			affected += (tg ? tg.name : good_id)
		rows += list(list(
			"name" = E.name,
			"description" = E.description || "",
			"event_type" = E.event_type,
			"days_left" = max(0, E.day_expires - GLOB.dayspassed),
			"affected_goods" = affected,
		))
	return rows

/obj/structure/roguemachine/noticeboard/proc/build_mercenary_roster()
	var/list/data = list(
		"available" = list(),
		"contracted" = list(),
		"dnd" = list(),
		"available_count" = 0,
		"contracted_count" = 0,
		"dnd_count" = 0,
	)
	var/obj/structure/roguemachine/talkstatue/mercenary/statue = SSroguemachine.mercenary_statue
	if(!statue)
		return data
	for(var/merc_key in statue.mercenary_status)
		var/list/merc_data = statue.mercenary_status[merc_key]
		var/mob/living/carbon/human/merc = merc_data["mob"]
		if(!merc)
			continue
		var/status = merc_data["status"] || "Available"
		var/list/entry = list(
			"name" = merc.real_name,
			"advjob" = merc.advjob || "Mercenary",
			"message" = merc_data["message"] || "",
		)
		switch(status)
			if("Available")
				data["available"] += list(entry)
				data["available_count"]++
			if("Contracted")
				data["contracted"] += list(entry)
				data["contracted_count"]++
			if("Do not Disturb")
				data["dnd"] += list(entry)
				data["dnd_count"]++
	return data

/obj/structure/roguemachine/noticeboard/proc/build_market_data()
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

/obj/structure/roguemachine/noticeboard/proc/serialize_posting(datum/noticeboard_posting/P, mob/living/carbon/human/viewer, viewer_is_authority)
	var/list/entry = list()
	entry["posting_id"] = P.posting_id
	entry["tier"] = P.tier
	entry["title"] = P.title
	entry["body"] = P.body
	entry["poster_name"] = P.poster_name
	entry["poster_title"] = P.poster_title
	entry["poster_job"] = P.poster_job
	entry["signature_attested"] = P.signature_attested ? TRUE : FALSE
	entry["posted_at_label"] = format_posted_at_label(P.posted_at)
	entry["expires_in_label"] = (P.tier == POSTING_TIER_NOTICE) ? format_expires_in_label(P.posted_at) : ""
	entry["is_own"] = (viewer && P.truename == viewer.real_name) ? TRUE : FALSE
	entry["can_authority_remove"] = (viewer_is_authority && P.tier == POSTING_TIER_NOTICE) ? TRUE : FALSE
	return entry

/obj/structure/roguemachine/noticeboard/proc/format_posted_at_label(posted_at)
	var/elapsed = world.time - posted_at
	if(elapsed < 1 MINUTES)
		return "just now"
	var/minutes = round(elapsed / (1 MINUTES))
	if(minutes < 60)
		return "[minutes]m ago"
	var/hours = round(minutes / 60)
	return "[hours]h ago"

/obj/structure/roguemachine/noticeboard/proc/format_expires_in_label(posted_at)
	var/expires_at = posted_at + NOTICEBOARD_NOTICE_LIFETIME
	var/remaining = expires_at - world.time
	if(remaining <= 0)
		return "any moment"
	var/minutes = CEILING(remaining / (1 MINUTES), 1)
	return "in [minutes]m"

/obj/structure/roguemachine/noticeboard/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = usr
	if(!istype(H))
		return TRUE
	if(!H.canUseTopic(src, BE_CLOSE))
		return TRUE
	switch(action)
		if("refresh_market")
			if(world.time < last_market_refresh + 5 SECONDS)
				to_chat(H, span_warning("The factors haven't tallied fresh numbers yet. Wait a moment."))
				return TRUE
			last_market_refresh = world.time
			update_static_data(H)
			return TRUE
		if("make_post")
			handle_make_post(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("remove_post")
			handle_remove_post(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("authority_remove_post")
			handle_authority_remove_post(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("open_assembly")
			SStgui.close_uis(src)
			open_assembly_tgui(H)
			return TRUE
		if("help_market")
			open_economy_guidebook(H, "Merchant", /datum/book_entry/treasury_merchant/avisa_market)
			return TRUE

/obj/structure/roguemachine/noticeboard/proc/handle_make_post(mob/living/carbon/human/H, list/params)
	var/tier = "[params["tier"]]"
	if(tier != POSTING_TIER_NOTICE && tier != POSTING_TIER_LISTING)
		to_chat(H, span_warning("Unknown posting kind."))
		return
	if(tier == POSTING_TIER_LISTING && !(H.job in NOTICEBOARD_LISTING_ROLES))
		to_chat(H, span_warning("Only certain offices may pin a Standing Listing."))
		return
	var/title = sanitize_input("[params["title"]]", NOTICEBOARD_TITLE_MAX_LENGTH)
	var/body = sanitize_input("[params["body"]]", NOTICEBOARD_BODY_MAX_LENGTH, multiline = TRUE)
	var/poster_name = sanitize_input("[params["poster_name"]]", NOTICEBOARD_NAME_MAX_LENGTH)
	var/poster_title = sanitize_input("[params["poster_title"]]", NOTICEBOARD_ROLE_MAX_LENGTH)
	if(!title || !body || !poster_name)
		to_chat(H, span_warning("The posting must bear a title, a body, and a name."))
		return
	noticeboard_add_posting(tier, title, body, poster_name, poster_title, H)
	message_admins("[ADMIN_LOOKUPFLW(H)] has made a [tier] noticeboard post. The message was: [body]")

/obj/structure/roguemachine/noticeboard/proc/handle_remove_post(mob/living/carbon/human/H, list/params)
	var/posting_id = "[params["posting_id"]]"
	var/datum/noticeboard_posting/P = noticeboard_find_post_by_id(posting_id)
	if(!P)
		return
	if(P.truename != H.real_name)
		to_chat(H, span_warning("That posting is not yours to take down."))
		return
	playsound(loc, 'sound/foley/dropsound/paper_drop.ogg', 50, FALSE, -1)
	loc.visible_message(span_smallred("[H] tears down a posting!"))
	noticeboard_remove_posting(P)
	message_admins("[ADMIN_LOOKUPFLW(H)] has removed their noticeboard post.")

/obj/structure/roguemachine/noticeboard/proc/handle_authority_remove_post(mob/living/carbon/human/H, list/params)
	if(!(H.job in NOTICEBOARD_AUTHORITY_ROLES))
		to_chat(H, span_warning("You hold no authority to take down another's posting."))
		return
	var/posting_id = "[params["posting_id"]]"
	var/datum/noticeboard_posting/P = noticeboard_find_post_by_id(posting_id)
	if(!P)
		return
	if(P.tier == POSTING_TIER_LISTING)
		to_chat(H, span_warning("A Standing Listing may not be taken down by authority while its issuer lives."))
		return
	playsound(loc, 'sound/foley/dropsound/paper_drop.ogg', 50, FALSE, -1)
	loc.visible_message(span_smallred("[H] tears down a posting!"))
	noticeboard_remove_posting(P)
	message_admins("[ADMIN_LOOKUPFLW(H)] has authoritatively removed a noticeboard post by [P.truename].")

/obj/structure/roguemachine/noticeboard/proc/sanitize_input(text, max_length, multiline = FALSE)
	if(!text || text == "null")
		return null
	text = copytext(text, 1, max_length + 1)
	text = trim(text)
	if(!length(text))
		return null
	return text
