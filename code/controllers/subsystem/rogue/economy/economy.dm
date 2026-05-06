SUBSYSTEM_DEF(economy)
	name = "Economy"
	init_order = INIT_ORDER_ECONOMY
	flags = SS_NO_FIRE
	var/last_processed_day = 0
	var/roundstart_events_fired = FALSE
	var/simulated_player_scalar = 0
	var/list/daily_report_diff = null
	var/last_petition_day = -1
	var/petitions_today = 0


/datum/controller/subsystem/economy/proc/get_effective_player_count()
	if(simulated_player_scalar > 0)
		return simulated_player_scalar
	return get_active_player_count()

/datum/controller/subsystem/economy/Initialize()
	populate_standing_order_templates()
	daily_report_diff = list(
		"day" = GLOB.dayspassed,
		"events_fired" = list(),
		"events_expired" = list(),
		"blockades_fired" = list(),
		"blockades_cleared" = list(),
		"orders_rolled" = 0,
		"urgent_rolled" = 0,
		"regular_orders_by_region" = list(),
		"urgent_orders_today" = list(),
	)
	roundstart_events()
	roundstart_blockades()
	return ..()

/datum/controller/subsystem/economy/proc/populate_standing_order_templates()
	var/list/mapping = list(
		TRADE_REGION_KINGSFIELD = list(
			/datum/standing_order/demand_rations,
			/datum/standing_order/demand_textile,
			/datum/standing_order/demand_smithing,
			/datum/standing_order/demand_exotic,
			/datum/standing_order/demand_fishery,
			/datum/standing_order/demand_orchard,
			/datum/standing_order/demand_salt,
			/datum/standing_order/demand_alchemical,
			/datum/standing_order/demand_alchemical_warband,
			/datum/standing_order/demand_equipment_armaments,
			/datum/standing_order/demand_equipment_armor_heavy,
			/datum/standing_order/demand_equipment_armor_light,
			/datum/standing_order/demand_birthday_gift,
			/datum/standing_order/demand_great_feast,
			/datum/standing_order/demand_frontier_gear,
			/datum/standing_order/demand_court_finery,
			/datum/standing_order/demand_fine_joinery,
			/datum/standing_order/demand_artificery,
			/datum/standing_order/demand_jewelry,
			/datum/standing_order/demand_artificed_panoply,
			/datum/standing_order/demand_tournament_supply,
			/datum/standing_order/demand_arcane_commission,
		),
		TRADE_REGION_ROSAWOOD = list(
			/datum/standing_order/demand_construction,
			/datum/standing_order/demand_exotic,
			/datum/standing_order/demand_birthday_gift,
			/datum/standing_order/demand_fine_joinery,
		),
		TRADE_REGION_ROCKHILL = list(
			/datum/standing_order/demand_orchard,
			/datum/standing_order/demand_construction,
			/datum/standing_order/demand_birthday_gift,
			/datum/standing_order/demand_great_feast,
			/datum/standing_order/demand_court_finery,
			/datum/standing_order/demand_fine_joinery,
			/datum/standing_order/demand_jewelry,
			/datum/standing_order/demand_tournament_supply,
			/datum/standing_order/demand_trophy_heads,
			/datum/standing_order/demand_arcane_commission,
		),
		TRADE_REGION_DAFTSMARCH = list(
			/datum/standing_order/demand_construction,
			/datum/standing_order/demand_smithing,
			/datum/standing_order/demand_victualling_mines,
			/datum/standing_order/demand_birthday_gift,
			/datum/standing_order/demand_artificery,
			/datum/standing_order/demand_artificed_panoply,
		),
		TRADE_REGION_BLACKHOLT = list(
			/datum/standing_order/demand_exotic,
			/datum/standing_order/demand_construction,
			/datum/standing_order/demand_alchemical,
			/datum/standing_order/demand_alchemical_warband,
			/datum/standing_order/demand_birthday_gift,
			/datum/standing_order/demand_artificery,
		),
		TRADE_REGION_SALTWICK = list(
			/datum/standing_order/demand_fishery,
			/datum/standing_order/demand_construction,
			/datum/standing_order/demand_salt,
			/datum/standing_order/demand_victualling_fleet,
		),
		TRADE_REGION_BLEAKCOAST = list(
			/datum/standing_order/demand_rations,
			/datum/standing_order/demand_armaments,
			/datum/standing_order/demand_fishery,
			/datum/standing_order/demand_construction,
			/datum/standing_order/demand_victualling_garrison,
			/datum/standing_order/demand_alchemical,
			/datum/standing_order/demand_equipment_armaments,
			/datum/standing_order/demand_equipment_armor_heavy,
			/datum/standing_order/demand_equipment_armor_light,
			/datum/standing_order/demand_birthday_gift,
			/datum/standing_order/demand_great_feast,
			/datum/standing_order/demand_frontier_gear,
			/datum/standing_order/demand_prosthetic_run,
		),
		TRADE_REGION_NORTHFORT = list(
			/datum/standing_order/demand_rations,
			/datum/standing_order/demand_armaments,
			/datum/standing_order/demand_construction,
			/datum/standing_order/demand_victualling_garrison,
			/datum/standing_order/demand_alchemical,
			/datum/standing_order/demand_alchemical_warband,
			/datum/standing_order/demand_equipment_armaments,
			/datum/standing_order/demand_equipment_armor_heavy,
			/datum/standing_order/demand_equipment_armor_light,
			/datum/standing_order/demand_great_feast,
			/datum/standing_order/demand_frontier_gear,
			/datum/standing_order/demand_artificery,
			/datum/standing_order/demand_prosthetic_run,
			/datum/standing_order/demand_arcane_commission,
		),
		TRADE_REGION_HEARTFELT = list(
			/datum/standing_order/demand_rations,
			/datum/standing_order/demand_armaments,
			/datum/standing_order/demand_textile,
			/datum/standing_order/demand_orchard,
			/datum/standing_order/demand_victualling_garrison,
			/datum/standing_order/demand_alchemical,
			/datum/standing_order/demand_alchemical_warband,
			/datum/standing_order/demand_equipment_armaments,
			/datum/standing_order/demand_equipment_armor_heavy,
			/datum/standing_order/demand_equipment_armor_light,
			/datum/standing_order/demand_birthday_gift,
			/datum/standing_order/demand_great_feast,
			/datum/standing_order/demand_frontier_gear,
			/datum/standing_order/demand_court_finery,
			/datum/standing_order/demand_fine_joinery,
			/datum/standing_order/demand_jewelry,
			/datum/standing_order/demand_prosthetic_run,
			/datum/standing_order/demand_artificed_panoply,
			/datum/standing_order/demand_tournament_supply,
			/datum/standing_order/demand_trophy_heads,
			/datum/standing_order/demand_arcane_commission,
		),
	)
	// possible_standing_order_types is an assoc list of template_path -> roll_weight,
	// so the daily roller can pickweight() finished-goods orders more often than raws.
	for(var/region_id in mapping)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(!region)
			continue
		var/list/templates = mapping[region_id]
		var/list/weighted = list()
		for(var/datum/standing_order/template as anything in templates)
			var/datum/standing_order/probe = new template()
			weighted[template] = probe.roll_weight
			qdel(probe)
		region.possible_standing_order_types = weighted

/datum/controller/subsystem/economy/proc/daily_tick()
	if(GLOB.dayspassed <= last_processed_day)
		return
	last_processed_day = GLOB.dayspassed

	// Roundstart Initialize pre-allocates the diff so Day 0 rolls are captured. Subsequent
	// ticks allocate a fresh diff here. Either way, the day is stamped to the current one.
	if(!daily_report_diff)
		daily_report_diff = list(
			"events_fired" = list(),
			"events_expired" = list(),
			"blockades_fired" = list(),
			"blockades_cleared" = list(),
			"orders_rolled" = 0,
			"urgent_rolled" = 0,
			"regular_orders_by_region" = list(),
			"urgent_orders_today" = list(),
		)
	daily_report_diff["day"] = GLOB.dayspassed

	// Pop-scaled daily reset: larger rounds have proportionally more commerce.
	var/effective_pop = get_effective_player_count()
	var/pop_mult = min(REGION_POP_SCALE_MAX, 1.0 + (effective_pop * REGION_POP_SCALE_PER_PLAYER))
	var/order_size_mult = min(STANDING_ORDER_POP_SCALE_MAX, 1.0 + (effective_pop * STANDING_ORDER_POP_SCALE_PER_PLAYER))
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		region.produces_today = list()
		region.demands_today = list()
		for(var/good_id in region.produces)
			region.produces_today[good_id] = max(1, round(region.produces[good_id] * pop_mult))
		for(var/good_id in region.demands)
			region.demands_today[good_id] = max(1, round(region.demands[good_id] * pop_mult))

	var/list/expired = list()
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(O.is_fulfilled)
			expired += O
			continue
		if(O.day_expires <= GLOB.dayspassed)
			expired += O
	for(var/datum/standing_order/O as anything in expired)
		if(!O.is_fulfilled)
			record_round_statistic(STATS_STANDING_ORDERS_EXPIRED, 1)
		GLOB.standing_order_pool -= O

	expire_economic_events()
	roll_economic_events()
	tick_banditry_drain()

	// Runs after events/blockades so auto-import sees the day's fresh price_mods, blockade
	// flags, and produces_today values. Happens before standing-order rolls - the rolls
	// don't consult produces_today, so order matters only for bookkeeping ordering.
	SStreasury.run_auto_import_tick()

	if(GLOB.standing_order_pool.len < STANDING_ORDERS_POOL_CAP)
		var/total_to_roll = min(STANDING_ORDERS_MAX_PER_DAY, STANDING_ORDERS_BASE_PER_DAY + round(effective_pop * STANDING_ORDERS_PER_ACTIVE_PLAYER))
		for(var/i in 1 to total_to_roll)
			if(GLOB.standing_order_pool.len >= STANDING_ORDERS_POOL_CAP)
				break
			var/list/eligible_ids = list()
			for(var/region_id in GLOB.economic_regions)
				var/datum/economic_region/region = GLOB.economic_regions[region_id]
				if(!length(region.possible_standing_order_types))
					continue
				var/active_count = 0
				for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
					if(O.region_id == region_id)
						active_count++
				if(active_count < STANDING_ORDERS_MAX_PER_REGION)
					eligible_ids += region_id
			if(!length(eligible_ids))
				break
			var/chosen_region_id = pick(eligible_ids)
			var/datum/economic_region/region = GLOB.economic_regions[chosen_region_id]
			var/template = pickweight(region.possible_standing_order_types)
			instantiate_standing_order(template, region, order_size_mult)

	var/list/by_region = daily_report_diff["regular_orders_by_region"]
	if(length(by_region))
		var/total_regular = 0
		var/list/region_parts = list()
		for(var/region_name in by_region)
			var/count = by_region[region_name]
			total_regular += count
			region_parts += "[count] at [region_name]"
		scom_announce("<font color='#7eb84a'>[total_regular] new standing order\s posted at the noticeboard this dawn: [jointext(region_parts, ", ")].</font>")
	var/list/urgents_today = daily_report_diff["urgent_orders_today"]
	for(var/list/U as anything in urgents_today)
		scom_announce("<font color='#c44'>URGENT at [U["region"]]: [U["items"]]. 1d, [U["payout"]]m.</font>")

	print_steward_report(daily_report_diff)
	daily_report_diff = null

/datum/controller/subsystem/economy/proc/roundstart_events()
	if(roundstart_events_fired)
		return
	roundstart_events_fired = TRUE
	for(var/i in 1 to ECON_EVENT_ROUNDSTART_COUNT)
		roll_single_event()

/datum/controller/subsystem/economy/proc/roll_economic_events()
	while(GLOB.active_economic_events.len < ECON_EVENT_TARGET_COUNT)
		if(!roll_single_event())
			break

/datum/controller/subsystem/economy/proc/roll_single_event()
	// Build eligible pool: any concrete subtype whose affected_goods don't overlap an active event's goods.
	// initial() on list vars returns null in BYOND, so we temp-instantiate each candidate to inspect the list.
	var/list/eligible = list()
	for(var/path in subtypesof(/datum/economic_event))
		var/datum/economic_event/probe = path
		if(!initial(probe.name))
			continue  // abstract
		if(initial(probe.event_type) == ECON_EVENT_NARRATIVE)
			continue  // narrative events don't roll in v1
		var/datum/economic_event/tentative = new path()
		var/clash = FALSE
		for(var/active in GLOB.active_economic_events)
			var/datum/economic_event/A = active
			for(var/good in tentative.affected_goods)
				if(good in A.affected_goods)
					clash = TRUE
					break
			if(clash)
				break
		qdel(tentative)
		if(!clash)
			eligible += path
	if(!length(eligible))
		return FALSE
	var/chosen_path = pick(eligible)
	var/datum/economic_event/E = new chosen_path()
	E.day_started = GLOB.dayspassed
	E.day_expires = GLOB.dayspassed + E.duration_days
	GLOB.active_economic_events += E
	E.on_apply()
	record_round_statistic(STATS_ECON_EVENTS_FIRED, 1)
	if(daily_report_diff)
		var/list/fired = daily_report_diff["events_fired"]
		fired += "[E.name] ([E.event_type == ECON_EVENT_SHORTAGE ? "shortage" : "glut"])"
	if(E.event_type == ECON_EVENT_SHORTAGE)
		spawn_urgent_for_event(E)
	return TRUE

/datum/controller/subsystem/economy/proc/spawn_urgent_for_event(datum/economic_event/E)
	if(!E || !length(E.affected_goods))
		return
	var/current_urgent = 0
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(istype(O, /datum/standing_order/urgent))
			current_urgent++
	if(current_urgent >= STANDING_ORDERS_MAX_URGENT)
		return
	// Pick a region that demands any of the affected goods; fallback to one that produces them.
	var/list/candidate_regions = list()
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(region.is_region_blockaded)
			continue
		for(var/good in E.affected_goods)
			if(region.demands[good])
				candidate_regions += region_id
				break
	if(!length(candidate_regions))
		for(var/region_id in GLOB.economic_regions)
			var/datum/economic_region/region = GLOB.economic_regions[region_id]
			if(region.is_region_blockaded)
				continue
			for(var/good in E.affected_goods)
				if(region.produces[good])
					candidate_regions += region_id
					break
	if(!length(candidate_regions))
		return
	var/chosen_region_id = pick(candidate_regions)
	var/datum/economic_region/region = GLOB.economic_regions[chosen_region_id]
	var/datum/standing_order/urgent/O = new()
	O.region_id = chosen_region_id
	O.source_event_ref = WEAKREF(E)
	var/list/mix = list()
	var/order_size_mult = min(STANDING_ORDER_POP_SCALE_MAX, 1.0 + (get_effective_player_count() * STANDING_ORDER_POP_SCALE_PER_PLAYER))
	for(var/good in E.affected_goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good]
		// Scale qty inversely with base_price so high-value goods (gems, dendor) land
		// in small order sizes instead of blowing out the payout math.
		var/base = tg ? tg.base_price : 5
		var/qty_lo
		var/qty_hi
		if(base >= 40)
			qty_lo = 3
			qty_hi = 5
		else if(base >= 15)
			qty_lo = 6
			qty_hi = 12
		else
			qty_lo = 12
			qty_hi = 25
		mix[good] = max(1, round(rand(qty_lo, qty_hi) * order_size_mult))
	O.required_items = mix
	O.name = O.generate_name(region)
	O.description = O.generate_description(region)
	O.day_issued = GLOB.dayspassed
	O.day_expires = GLOB.dayspassed + URGENT_ORDER_DURATION
	O.total_payout = compute_order_payout(O, region)
	GLOB.standing_order_pool += O
	E.urgent_order_ref = WEAKREF(O)
	record_round_statistic(STATS_URGENT_ORDERS_SPAWNED, 1)
	if(daily_report_diff)
		var/list/items_text = list()
		for(var/good_id in O.required_items)
			var/datum/trade_good/tg = GLOB.trade_goods[good_id]
			items_text += "[O.required_items[good_id]] [tg ? tg.name : good_id]"
		var/list/urgents = daily_report_diff["urgent_orders_today"]
		urgents += list(list(
			"region" = region.name,
			"items" = jointext(items_text, ", "),
			"payout" = O.total_payout,
		))

/datum/controller/subsystem/economy/proc/expire_economic_events()
	var/list/expired = list()
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		if(E.day_expires <= GLOB.dayspassed)
			expired += E
	for(var/datum/economic_event/E as anything in expired)
		E.on_expire()
		GLOB.active_economic_events -= E
		record_round_statistic(STATS_ECON_EVENTS_EXPIRED, 1)
		if(daily_report_diff)
			var/list/ended = daily_report_diff["events_expired"]
			ended += E.name
		var/datum/standing_order/urgent/O = E.urgent_order_ref?.resolve()
		if(O && !O.is_fulfilled)
			GLOB.standing_order_pool -= O

/datum/controller/subsystem/economy/proc/compute_import_unit_price(good_id, datum/economic_region/region, unit_index)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg || !region)
		return 0
	var/daily_pace = max(1, region.produces[good_id] || 0)
	var/overshoot = max(0, (unit_index - daily_pace) / daily_pace)
	var/blockade_mult = region.is_region_blockaded ? BLOCKADE_IMPORT_MULT : 1.0
	var/unit_price = tg.base_price * (1 + overshoot * TRADE_ESCALATION_SLOPE) * tg.global_price_mod * blockade_mult
	return max(1, round(unit_price))

/datum/controller/subsystem/economy/proc/compute_export_unit_price(good_id, datum/economic_region/region, unit_index)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg || !region)
		return 0
	var/daily_pace = max(1, region.demands[good_id] || 0)
	// Oversupply DECAY (not the import-side escalation). When the Steward floods a region past
	// its daily demand, each additional unit fetches a diminishing price: price is divided by
	// (1 + overshoot * slope). At demand = 3 and exported = 12, overshoot = 3 -> unit price
	// falls to 1/4. low_price floor still applies via the max() below.
	var/overshoot = max(0, (unit_index - daily_pace) / daily_pace)
	var/oversupply_mult = 1 / (1 + overshoot * TRADE_ESCALATION_SLOPE)
	var/blockade_mult = region.is_region_blockaded ? BLOCKADE_EXPORT_MULT : 1.0
	var/export_price = tg.base_price * tg.global_price_mod * oversupply_mult * (1 - IMPORT_EXPORT_SPREAD) * blockade_mult
	return max(round(export_price), tg.low_price)

/datum/controller/subsystem/economy/proc/compute_good_unit_payout(datum/standing_order/order, good_id)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg)
		return 0
	var/unit_mult
	if(istype(order, /datum/standing_order/urgent))
		unit_mult = max(1.0, tg.global_price_mod)
	else
		unit_mult = 1 + STANDING_ORDER_BASE_BONUS
	return CEILING(tg.base_price * unit_mult, 1)

/datum/controller/subsystem/economy/proc/compute_order_payout(datum/standing_order/order, datum/economic_region/region)
	var/total = 0
	for(var/good_id in order.required_items)
		total += compute_good_unit_payout(order, good_id) * order.required_items[good_id]
	if(order.petitioned)
		total = round(total * PETITION_TAX_MULT)
	return round(total)

/// Returns the new order, or null if the template's item mix came up empty (caller decides
/// whether that's a skip or a refund).
/datum/controller/subsystem/economy/proc/instantiate_standing_order(template, datum/economic_region/region, order_size_mult, petitioned = FALSE)
	if(!template || !region)
		return null
	var/datum/standing_order/O = new template()
	O.region_id = region.region_id
	O.petitioned = petitioned
	O.required_items = O.generate_item_mix()
	if(!length(O.required_items))
		qdel(O)
		return null
	for(var/good_id in O.required_items)
		O.required_items[good_id] = max(1, round(O.required_items[good_id] * order_size_mult))
	O.name = O.generate_name(region)
	O.description = O.generate_description(region)
	O.day_issued = GLOB.dayspassed
	O.day_expires = GLOB.dayspassed + STANDING_ORDER_DURATION
	O.total_payout = compute_order_payout(O, region)
	GLOB.standing_order_pool += O
	if(daily_report_diff)
		daily_report_diff["orders_rolled"] = (daily_report_diff["orders_rolled"] || 0) + 1
		if(!petitioned)
			var/list/by_region = daily_report_diff["regular_orders_by_region"]
			by_region[region.name] = (by_region[region.name] || 0) + 1
	return O


/datum/controller/subsystem/economy/proc/fulfill_order(mob/user, datum/standing_order/order, partial = FALSE)
	if(!order || order.is_fulfilled)
		return FALSE
	var/datum/economic_region/ER = GLOB.economic_regions[order.region_id]
	if(ER?.is_region_blockaded)
		if(user)
			to_chat(user, span_warning("[ER.name] is blockaded — the order cannot be delivered until the road is cleared."))
		return FALSE

	var/list/equip_goods = list()
	var/list/potion_goods = list()
	var/list/stock_goods = list()
	for(var/good_id in order.required_items)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(tg?.behavior == TRADE_BEHAVIOR_EQUIPMENT)
			equip_goods += good_id
		else if(tg?.behavior == TRADE_BEHAVIOR_POTION)
			potion_goods += good_id
		else
			stock_goods += good_id

	if((length(equip_goods) || length(potion_goods)) && !length(GLOB.steward_export_machines))
		if(user)
			to_chat(user, span_warning("No warehouse dock manifest is registered. Cannot fulfill warehouse orders."))
		return FALSE

	var/list/equip_avail = length(equip_goods) ? scan_equipment_availability(order, equip_goods) : list()
	var/list/potion_avail = length(potion_goods) ? scan_potion_availability(order, potion_goods) : list()
	var/list/stock_avail = length(stock_goods) ? scan_stockpile_availability(order, stock_goods) : list()

	var/missing_count = 0
	var/list/missing_labels = list()
	var/delivered_pretax = 0
	for(var/list/avail_set in list(equip_avail, potion_avail, stock_avail))
		for(var/good_id in avail_set)
			var/list/entry = avail_set[good_id]
			delivered_pretax += compute_good_unit_payout(order, good_id) * entry["delivered_units"]
			if(!entry["satisfied"])
				missing_count++
				var/datum/trade_good/tg = GLOB.trade_goods[good_id]
				missing_labels += tg ? tg.name : good_id

	if(!missing_count)
		consume_equipment_payload(equip_avail)
		consume_potion_payload(potion_avail)
		consume_stockpile_payload(stock_avail)
		var/full_payout = order.total_payout
		SStreasury.mint(SStreasury.discretionary_fund, full_payout, "Standing Order: [order.name]")
		record_round_statistic(STATS_STANDING_ORDER_REVENUE, full_payout)
		record_round_statistic(STATS_STANDING_ORDERS_FULFILLED, 1)
		order.is_fulfilled = TRUE
		GLOB.standing_order_pool -= order
		if(user)
			to_chat(user, span_notice("Order Fulfilled: [full_payout]m paid to the Crown's Purse."))
			log_game("STANDING ORDER FULFILLED by [user.ckey]: [order.name] (+[full_payout]m)")
		return list("status" = "full", "payout" = full_payout)

	var/delivered_value = order.petitioned ? round(delivered_pretax * PETITION_TAX_MULT) : delivered_pretax
	var/total_value = order.total_payout
	var/coverage = total_value > 0 ? (delivered_value / total_value) : 0

	if(coverage < STANDING_ORDER_PARTIAL_THRESHOLD)
		if(user)
			to_chat(user, span_warning("Coverage [round(coverage * 100)]% - below the [round(STANDING_ORDER_PARTIAL_THRESHOLD * 100)]% partial threshold. Short on: [english_list(missing_labels)]."))
		return FALSE

	if(!partial)
		return STANDING_ORDER_FULFILL_NEEDS_PARTIAL_PROMPT

	var/payout = round(delivered_value * STANDING_ORDER_PARTIAL_PAYOUT_MULT)
	consume_equipment_payload(equip_avail)
	consume_potion_payload(potion_avail)
	consume_stockpile_payload(stock_avail)
	SStreasury.mint(SStreasury.discretionary_fund, payout, "Standing Order (Partial): [order.name]")
	record_round_statistic(STATS_STANDING_ORDER_REVENUE, payout)
	record_round_statistic(STATS_STANDING_ORDERS_FULFILLED, 1)
	order.is_fulfilled = TRUE
	GLOB.standing_order_pool -= order
	if(user)
		to_chat(user, span_notice("Order Settled (Partial): [round(coverage * 100)]% coverage, [payout]m paid to the Crown's Purse ([round(STANDING_ORDER_PARTIAL_PAYOUT_MULT * 100)]% of the delivered share)."))
		log_game("STANDING ORDER PARTIAL FULFILLED by [user.ckey]: [order.name] (+[payout]m, [round(coverage * 100)]% coverage)")
	return list("status" = "partial", "payout" = payout, "coverage_pct" = round(coverage * 100))

/datum/controller/subsystem/economy/proc/scan_equipment_availability(datum/standing_order/order, list/goods)
	var/list/out = list()
	var/list/matched_by_good = list()
	var/list/found_by_good = list()
	for(var/good_id in goods)
		matched_by_good[good_id] = list()
		found_by_good[good_id] = 0

	for(var/obj/structure/roguemachine/steward_export/M as anything in GLOB.steward_export_machines)
		if(QDELETED(M))
			continue
		for(var/obj/item/I in view(1, M))
			for(var/good_id in goods)
				var/datum/trade_good/tg = GLOB.trade_goods[good_id]
				if(!tg || !tg.item_type || !istype(I, tg.item_type))
					continue
				// Exact-type match by default — avoids counting donator/unique subtypes
				// against Crown manifest orders. Goods with accept_subtypes set opt out
				// (e.g. enchantment scrolls — every spell is a distinct subtype, but the
				// Crown treats each tier as one fungible commodity).
				if(!tg.accept_subtypes && I.type != tg.item_type)
					continue
				if(found_by_good[good_id] >= order.required_items[good_id])
					continue
				found_by_good[good_id]++
				matched_by_good[good_id] += I
				break

	for(var/good_id in goods)
		var/need = order.required_items[good_id]
		var/have = found_by_good[good_id]
		out[good_id] = list(
			"payload" = matched_by_good[good_id],
			"delivered_units" = min(have, need),
			"need_units" = need,
			"satisfied" = (have >= need),
		)
	return out

/datum/controller/subsystem/economy/proc/scan_potion_availability(datum/standing_order/order, list/goods)
	var/list/out = list()
	var/list/required_volume_by_good = list()
	var/list/found_volume_by_good = list()
	var/list/matched_containers_by_good = list()
	for(var/good_id in goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		required_volume_by_good[good_id] = order.required_items[good_id] * tg.required_volume
		found_volume_by_good[good_id] = 0
		matched_containers_by_good[good_id] = list()

	for(var/obj/structure/roguemachine/steward_export/M as anything in GLOB.steward_export_machines)
		if(QDELETED(M))
			continue
		for(var/obj/item/reagent_containers/RC in view(1, M))
			if(!RC.reagents)
				continue
			for(var/good_id in required_volume_by_good)
				if(found_volume_by_good[good_id] >= required_volume_by_good[good_id])
					continue
				var/datum/trade_good/tg = GLOB.trade_goods[good_id]
				var/contained = RC.reagents.get_reagent_amount(tg.reagent_type)
				if(contained <= 0)
					continue
				found_volume_by_good[good_id] += contained
				matched_containers_by_good[good_id] += RC
				break

	for(var/good_id in goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		var/need_units = order.required_items[good_id]
		var/found_volume = found_volume_by_good[good_id]
		var/delivered_units = min(need_units, round(found_volume / tg.required_volume))
		out[good_id] = list(
			"payload" = matched_containers_by_good[good_id],
			"delivered_units" = delivered_units,
			"need_units" = need_units,
			"satisfied" = (delivered_units >= need_units),
		)
	return out

/datum/controller/subsystem/economy/proc/scan_stockpile_availability(datum/standing_order/order, list/goods)
	var/list/out = list()
	for(var/good_id in goods)
		var/need = order.required_items[good_id]
		var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
		var/have = stockpile_entry ? stockpile_entry.stockpile_amount : 0
		out[good_id] = list(
			"payload" = null,
			"delivered_units" = min(have, need),
			"need_units" = need,
			"satisfied" = (have >= need),
		)
	return out

/datum/controller/subsystem/economy/proc/consume_equipment_payload(list/avail)
	for(var/good_id in avail)
		var/list/entry = avail[good_id]
		for(var/obj/item/I as anything in entry["payload"])
			qdel(I)

/datum/controller/subsystem/economy/proc/consume_potion_payload(list/avail)
	for(var/good_id in avail)
		var/list/entry = avail[good_id]
		for(var/obj/item/I as anything in entry["payload"])
			qdel(I)

/datum/controller/subsystem/economy/proc/consume_stockpile_payload(list/avail)
	for(var/good_id in avail)
		var/list/entry = avail[good_id]
		var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
		if(stockpile_entry)
			stockpile_entry.stockpile_amount -= entry["delivered_units"]

/datum/controller/subsystem/economy/proc/preview_partial_fulfillment(datum/standing_order/order)
	var/list/equip_goods = list()
	var/list/potion_goods = list()
	var/list/stock_goods = list()
	for(var/good_id in order.required_items)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(tg?.behavior == TRADE_BEHAVIOR_EQUIPMENT)
			equip_goods += good_id
		else if(tg?.behavior == TRADE_BEHAVIOR_POTION)
			potion_goods += good_id
		else
			stock_goods += good_id

	var/list/equip_avail = length(equip_goods) ? scan_equipment_availability(order, equip_goods) : list()
	var/list/potion_avail = length(potion_goods) ? scan_potion_availability(order, potion_goods) : list()
	var/list/stock_avail = length(stock_goods) ? scan_stockpile_availability(order, stock_goods) : list()

	var/delivered_pretax = 0
	var/list/missing_labels = list()
	for(var/list/avail_set in list(equip_avail, potion_avail, stock_avail))
		for(var/good_id in avail_set)
			var/list/entry = avail_set[good_id]
			delivered_pretax += compute_good_unit_payout(order, good_id) * entry["delivered_units"]
			if(!entry["satisfied"])
				var/datum/trade_good/tg = GLOB.trade_goods[good_id]
				var/short_units = entry["need_units"] - entry["delivered_units"]
				missing_labels += "[short_units] [tg ? tg.name : good_id]"
	var/delivered_value = order.petitioned ? round(delivered_pretax * PETITION_TAX_MULT) : delivered_pretax
	var/total_value = order.total_payout
	var/coverage = total_value > 0 ? (delivered_value / total_value) : 0
	var/payout = round(delivered_value * STANDING_ORDER_PARTIAL_PAYOUT_MULT)

	return list(
		"coverage_pct" = round(coverage * 100),
		"payout" = payout,
		"missing_text" = length(missing_labels) ? english_list(missing_labels) : "nothing",
	)


/datum/controller/subsystem/economy/proc/order_is_equipment(datum/standing_order/order)
	for(var/good_id in order.required_items)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(tg?.behavior == TRADE_BEHAVIOR_EQUIPMENT)
			return TRUE
	return FALSE

/datum/controller/subsystem/economy/proc/order_is_alchemical(datum/standing_order/order)
	for(var/good_id in order.required_items)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(tg?.behavior == TRADE_BEHAVIOR_POTION)
			return TRUE
	return FALSE

/datum/controller/subsystem/economy/proc/find_stockpile_by_trade_good(good_id)
	if(!good_id)
		return null
	return SStreasury.stockpile_by_trade_good[good_id]

/datum/controller/subsystem/economy/proc/manual_import(mob/user, region_id, good_id, quantity)
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!region)
		return 0
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg || !tg.importable)
		if(user)
			to_chat(user, span_warning("[good_id] is not importable."))
		return 0
	if(quantity <= 0)
		return 0

	var/daily_pace = region.produces[good_id] || 0
	if(daily_pace <= 0)
		if(user)
			to_chat(user, span_warning("[region.name] does not produce [tg.name]."))
		return 0

	var/produces_today = region.produces_today[good_id] || 0
	var/starting_index = max(0, daily_pace - produces_today)

	var/total_cost = 0
	for(var/i in 1 to quantity)
		total_cost += compute_import_unit_price(good_id, region, starting_index + i)

	if(SStreasury.discretionary_fund.balance < total_cost)
		if(user)
			to_chat(user, span_warning("Crown's Purse insufficient: [SStreasury.discretionary_fund.balance]m < [total_cost]m."))
		return 0

	SStreasury.burn(SStreasury.discretionary_fund, total_cost, "Manual Import: [quantity] [tg.name] from [region.name]")
	region.produces_today[good_id] = max(0, produces_today - quantity)
	var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
	if(stockpile_entry)
		stockpile_entry.stockpile_amount += quantity
	SStreasury.total_import += total_cost
	record_round_statistic(STATS_STOCKPILE_IMPORTS_VALUE, total_cost)

	if(user)
		log_game("MANUAL IMPORT by [user.ckey]: [quantity] [tg.name] from [region.name] (cost [total_cost]m)")
	return total_cost

/datum/controller/subsystem/economy/proc/manual_export(mob/user, region_id, good_id, quantity)
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!region)
		return 0
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg)
		if(user)
			to_chat(user, span_warning("[good_id] is not a known trade good."))
		return 0
	if(quantity <= 0)
		return 0

	var/daily_pace = region.demands[good_id] || 0
	if(daily_pace <= 0)
		if(user)
			to_chat(user, span_warning("[region.name] does not demand [tg.name]."))
		return 0

	var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
	if(!stockpile_entry || stockpile_entry.stockpile_amount < quantity)
		if(user)
			to_chat(user, span_warning("Insufficient [tg.name] in stockpile: have [stockpile_entry?.stockpile_amount || 0], need [quantity]."))
		return 0

	var/demands_today = region.demands_today[good_id] || 0
	var/starting_index = max(0, daily_pace - demands_today)

	var/total_revenue = 0
	for(var/i in 1 to quantity)
		total_revenue += compute_export_unit_price(good_id, region, starting_index + i)

	stockpile_entry.stockpile_amount -= quantity
	region.demands_today[good_id] = max(0, demands_today - quantity)
	SStreasury.mint(SStreasury.discretionary_fund, total_revenue, "Manual Export: [quantity] [tg.name] to [region.name]")
	SStreasury.total_export += total_revenue

	if(user)
		log_game("MANUAL EXPORT by [user.ckey]: [quantity] [tg.name] to [region.name] (revenue [total_revenue]m)")
	return total_revenue

/datum/controller/subsystem/economy/proc/get_best_import_region(good_id, exclude_blockaded = TRUE)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg || !tg.importable)
		return null

	var/best_region_id = null
	var/best_price = INFINITY
	var/best_blockaded = FALSE
	var/nominal_region_id = null
	var/nominal_price = INFINITY

	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		var/daily_pace = region.produces[good_id] || 0
		if(daily_pace <= 0)
			continue
		var/produces_today = region.produces_today[good_id] || 0
		var/starting_index = max(0, daily_pace - produces_today)
		var/unit_price = compute_import_unit_price(good_id, region, starting_index + 1)

		if(unit_price < nominal_price)
			nominal_price = unit_price
			nominal_region_id = region_id

		if(exclude_blockaded && region.is_region_blockaded)
			continue
		if(unit_price < best_price)
			best_price = unit_price
			best_region_id = region_id
			best_blockaded = region.is_region_blockaded

	// Fallback: cheapest blockaded region if no non-blockaded producer exists.
	if(!best_region_id && nominal_region_id)
		best_region_id = nominal_region_id
		best_price = nominal_price
		best_blockaded = TRUE

	if(!best_region_id)
		return null

	var/list/result = list(
		"region_id" = best_region_id,
		"unit_price" = round(best_price),
		"is_blockaded" = best_blockaded,
		"fallback_region_id" = null,
		"fallback_price" = null,
	)
	if(nominal_region_id && nominal_region_id != best_region_id)
		result["fallback_region_id"] = nominal_region_id
		result["fallback_price"] = round(nominal_price)
	return result

/datum/controller/subsystem/economy/proc/get_best_export_region(good_id, exclude_blockaded = TRUE)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg)
		return null

	var/best_region_id = null
	var/best_price = -1
	var/best_blockaded = FALSE
	var/nominal_region_id = null
	var/nominal_price = -1

	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		var/daily_pace = region.demands[good_id] || 0
		if(daily_pace <= 0)
			continue
		var/demands_today = region.demands_today[good_id] || 0
		var/starting_index = max(0, daily_pace - demands_today)
		var/unit_price = compute_export_unit_price(good_id, region, starting_index + 1)

		if(unit_price > nominal_price)
			nominal_price = unit_price
			nominal_region_id = region_id

		if(exclude_blockaded && region.is_region_blockaded)
			continue
		if(unit_price > best_price)
			best_price = unit_price
			best_region_id = region_id
			best_blockaded = region.is_region_blockaded

	if(!best_region_id && nominal_region_id)
		best_region_id = nominal_region_id
		best_price = nominal_price
		best_blockaded = TRUE

	if(!best_region_id)
		return null

	var/list/result = list(
		"region_id" = best_region_id,
		"unit_price" = round(best_price),
		"is_blockaded" = best_blockaded,
		"fallback_region_id" = null,
		"fallback_price" = null,
	)
	if(nominal_region_id && nominal_region_id != best_region_id)
		result["fallback_region_id"] = nominal_region_id
		result["fallback_price"] = round(nominal_price)
	return result
