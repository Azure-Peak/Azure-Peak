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
	var/blockade_replenish_spent = 0
	var/list/gathering_blockades = list()
	var/list/event_path_cooldowns = list()


/datum/controller/subsystem/economy/proc/get_effective_player_count()
	if(simulated_player_scalar > 0)
		return simulated_player_scalar
	return get_active_player_count()

/datum/controller/subsystem/economy/Initialize(mapload)
	reset_region_capacities()
	daily_report_diff = list(
		"day" = GLOB.dayspassed,
		"events_fired" = list(),
		"events_expired" = list(),
		"blockades_fired" = list(),
		"blockades_cleared" = list(),
		"blockades_gathering" = list(),
		"orders_rolled" = 0,
		"urgent_rolled" = 0,
		"regular_orders_by_region" = list(),
		"urgent_orders_today" = list(),
	)
	roundstart_events()
	roundstart_blockades()
	return ..()

/datum/controller/subsystem/economy/proc/reset_region_capacities()
	var/pop_mult = min(REGION_POP_SCALE_MAX, 1.0 + (get_effective_player_count() * REGION_POP_SCALE_PER_PLAYER))
	var/season = get_current_season()
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		region.reset_day_capacity(pop_mult, season)
	SStreasury.dirty_market_view()

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
			"blockades_gathering" = list(),
			"orders_rolled" = 0,
			"urgent_rolled" = 0,
			"regular_orders_by_region" = list(),
			"urgent_orders_today" = list(),
		)
	daily_report_diff["day"] = GLOB.dayspassed

	// Pop-scaled daily reset: larger rounds have proportionally more commerce.
	var/effective_pop = get_effective_player_count()
	var/order_size_mult = min(STANDING_ORDER_POP_SCALE_MAX, 1.0 + (effective_pop * STANDING_ORDER_POP_SCALE_PER_PLAYER))
	reset_region_capacities()

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

	// Runs after today's prices/events settle, so active orders track current pop/prices.
	recompute_active_order_payouts()

	tick_blockade_replenish()
	run_market_day()
	tick_banditry_drain()

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
				var/list/seen_pairs = list()
				for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
					if(O.region_id != region_id)
						continue
					if(O.pair_id)
						if(seen_pairs[O.pair_id])
							continue
						seen_pairs[O.pair_id] = TRUE
					active_count++
				if(active_count < STANDING_ORDERS_MAX_PER_REGION)
					eligible_ids += region_id
			if(!length(eligible_ids))
				break
			var/chosen_region_id = pick(eligible_ids)
			var/datum/economic_region/region = GLOB.economic_regions[chosen_region_id]
			var/template = pickweight(region.possible_standing_order_types)
			var/datum/standing_order/probe = template
			if(initial(probe.pair_sibling_type))
				instantiate_standing_order_pair(template, initial(probe.pair_sibling_type), region, order_size_mult)
			else
				instantiate_standing_order(template, region, order_size_mult)

	var/list/relieved_today = daily_report_diff["events_relieved"]
	var/list/by_region = daily_report_diff["regular_orders_by_region"]
	var/list/urgents_today = daily_report_diff["urgent_orders_today"]
	var/list/dawn_parts = list()
	if(length(by_region) || length(urgents_today))
		var/total_regular = 0
		for(var/region_name in by_region)
			total_regular += by_region[region_name]
		var/order_line = "[total_regular] new standing order\s"
		if(length(urgents_today))
			order_line += " ([length(urgents_today)] URGENT)"
		dawn_parts += order_line
	if(length(dawn_parts))
		scom_announce("[jointext(dawn_parts, " - ")].")
	if(length(relieved_today))
		scom_announce("<font color='#5cb85c'>RELIEF: [jointext(relieved_today, ", ")] ended. Prices are back to normal.</font>")

	print_steward_report(daily_report_diff)
	daily_report_diff = null

	if(SSmerchant_trade)
		SSmerchant_trade.daily_tick()

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
			continue	// abstract
		if(initial(probe.event_type) == ECON_EVENT_NARRATIVE)
			continue	// narrative events don't roll in v1
		var/cooled_until = event_path_cooldowns[path]
		if(cooled_until && GLOB.dayspassed < cooled_until)
			continue
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
		var/bucket_key = E.event_type == ECON_EVENT_SHORTAGE ? "fired_shortage_names" : "fired_glut_names"
		var/list/bucket = daily_report_diff[bucket_key]
		if(!bucket)
			bucket = list()
			daily_report_diff[bucket_key] = bucket
		bucket += E.name
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
		event_path_cooldowns[E.type] = GLOB.dayspassed + ECON_EVENT_REROLL_COOLDOWN_DAYS
		record_round_statistic(STATS_ECON_EVENTS_EXPIRED, 1)
		if(daily_report_diff)
			var/list/ended = daily_report_diff["events_expired"]
			ended += E.name
		var/datum/standing_order/urgent/O = E.urgent_order_ref?.resolve()
		if(O && !O.is_fulfilled)
			GLOB.standing_order_pool -= O

/datum/controller/subsystem/economy/proc/compute_good_unit_payout(datum/standing_order/order, good_id)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!tg)
		return 0
	var/unit_price = (tg.item_type && GLOB.derived_sellprices[tg.item_type]) || tg.base_price
	var/unit_mult
	if(istype(order, /datum/standing_order/urgent))
		unit_mult = max(1.0, tg.global_price_mod)
	else
		unit_mult = 1 + STANDING_ORDER_BASE_BONUS
	return mammon_round(unit_price * unit_mult)

/datum/controller/subsystem/economy/proc/compute_equipment_delivered_value(datum/standing_order/order, list/equip_avail)
	var/total = 0
	for(var/good_id in equip_avail)
		var/list/entry = equip_avail[good_id]
		var/unit_payout = compute_good_unit_payout(order, good_id)
		var/list/payload = entry["payload"]
		var/delivered = entry["delivered_units"]
		var/counted = 0
		for(var/obj/item/I as anything in payload)
			if(counted >= delivered)
				break
			var/qmult = I.has_item_quality ? ITEM_QUALITY_MULT(I.item_quality) : ITEM_QUALITY_MULT_STANDARD
			total += mammon_round(unit_payout * qmult)
			counted++
	return total

/// Also stamps order.base_payout/scarcity_bonus_pct as a side effect, so the UI and daily
/// recompute don't need to re-derive the breakdown separately.
/datum/controller/subsystem/economy/proc/compute_order_payout(datum/standing_order/order, datum/economic_region/region)
	var/total = 0
	for(var/good_id in order.required_items)
		total += compute_good_unit_payout(order, good_id) * order.required_items[good_id]
	if(order.petitioned)
		total = mammon_round(total * PETITION_TAX_MULT)
	order.base_payout = mammon_round(total)
	// Boosts payout (never required quantity) below reference pop - Crown income only.
	var/scarcity_mult = clamp(1.0 + (STANDING_ORDER_SCARCITY_REFERENCE_POP - get_effective_player_count()) / STANDING_ORDER_SCARCITY_REFERENCE_POP * STANDING_ORDER_SCARCITY_MAX_BONUS, 1.0, 1.0 + STANDING_ORDER_SCARCITY_MAX_BONUS)
	order.scarcity_bonus_pct = round((scarcity_mult - 1) * 100)
	return mammon_round(total * scarcity_mult)

/// Payouts used to lock in at roll time and never catch up to later pop/price shifts while an
/// order sat unfulfilled. Recompute daily so active orders stay current.
/datum/controller/subsystem/economy/proc/recompute_active_order_payouts()
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(O.is_fulfilled)
			continue
		var/datum/economic_region/region = GLOB.economic_regions[O.region_id]
		if(!region)
			continue
		O.total_payout = compute_order_payout(O, region)

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

/datum/controller/subsystem/economy/proc/instantiate_standing_order_pair(template_a, template_b, datum/economic_region/region, order_size_mult, petitioned = FALSE)
	var/datum/standing_order/A = instantiate_standing_order(template_a, region, order_size_mult, petitioned)
	if(!A)
		return null
	var/datum/standing_order/B = instantiate_standing_order(template_b, region, order_size_mult, petitioned)
	if(!B)
		GLOB.standing_order_pool -= A
		qdel(A)
		return null
	var/pid = "pair_[GLOB.dayspassed]_[world.time]_[rand(1, 99999)]"
	A.pair_id = pid
	B.pair_id = pid
	B.day_expires = A.day_expires
	return A


/datum/controller/subsystem/economy/proc/fulfill_order(mob/user, datum/standing_order/order, partial = FALSE)
	if(!order || order.is_fulfilled)
		return FALSE
	var/datum/economic_region/ER = GLOB.economic_regions[order.region_id]
	if(ER?.is_region_blockaded)
		if(user)
			to_chat(user, span_warning("[ER.name] is blockaded. You can't deliver this order until the road is cleared."))
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
			to_chat(user, span_warning("There's no warehouse dock manifest, so you can't fulfill warehouse orders."))
		return FALSE

	var/list/equip_avail = length(equip_goods) ? scan_equipment_availability(order, equip_goods) : list()
	var/list/potion_avail = length(potion_goods) ? scan_potion_availability(order, potion_goods) : list()
	var/list/stock_avail = length(stock_goods) ? scan_stockpile_availability(order, stock_goods) : list()

	var/missing_count = 0
	var/list/missing_labels = list()
	var/delivered_pretax = 0
	var/equip_delivered_value = compute_equipment_delivered_value(order, equip_avail)
	delivered_pretax += equip_delivered_value
	for(var/list/avail_set in list(potion_avail, stock_avail))
		for(var/good_id in avail_set)
			var/list/entry = avail_set[good_id]
			delivered_pretax += compute_good_unit_payout(order, good_id) * entry["delivered_units"]
			if(!entry["satisfied"])
				missing_count++
				var/datum/trade_good/tg = GLOB.trade_goods[good_id]
				missing_labels += tg ? tg.name : good_id
	for(var/good_id in equip_avail)
		var/list/entry = equip_avail[good_id]
		if(!entry["satisfied"])
			missing_count++
			var/datum/trade_good/tg = GLOB.trade_goods[good_id]
			missing_labels += tg ? tg.name : good_id

	if(!missing_count)
		consume_equipment_payload(equip_avail)
		consume_potion_payload(potion_avail)
		consume_stockpile_payload(stock_avail)
		var/canonical_equip_value = 0
		for(var/good_id in equip_avail)
			var/list/entry = equip_avail[good_id]
			canonical_equip_value += compute_good_unit_payout(order, good_id) * entry["delivered_units"]
		var/quality_delta = equip_delivered_value - canonical_equip_value
		if(order.petitioned)
			quality_delta = mammon_round(quality_delta * PETITION_TAX_MULT)
		var/full_payout = max(0, mammon_round(order.total_payout + quality_delta))
		SStreasury.mint(SStreasury.discretionary_fund, full_payout, "Standing Order: [order.name]", null, LEDGER_CROWN_REV_STANDING_ORDERS)
		record_round_statistic(STATS_STANDING_ORDER_REVENUE, full_payout)
		record_round_statistic(STATS_STANDING_ORDERS_FULFILLED, 1)
		order.is_fulfilled = TRUE
		GLOB.standing_order_pool -= order
		if(user)
			to_chat(user, span_notice("Order fulfilled: [format_mammon(full_payout)]m paid to the Treasury."))
			if(quality_delta > 0)
				to_chat(user, span_green("Quality bonus: +[format_mammon(quality_delta)]m for quality goods."))
			else if(quality_delta < 0)
				to_chat(user, span_warning("Quality penalty: [format_mammon(quality_delta)]m for shoddy goods."))
			log_game("STANDING ORDER FULFILLED by [user.ckey]: [order.name] (+[format_mammon(full_payout)]m, quality_delta=[format_mammon(quality_delta)]m)")
		return list("status" = "full", "payout" = full_payout, "quality_delta" = quality_delta)

	var/delivered_value = order.petitioned ? mammon_round(delivered_pretax * PETITION_TAX_MULT) : delivered_pretax
	var/total_value = order.total_payout
	var/coverage = total_value > 0 ? (delivered_value / total_value) : 0

	if(coverage < STANDING_ORDER_PARTIAL_THRESHOLD)
		if(user)
			to_chat(user, span_warning("You only have [round(coverage * 100)]% of the goods. You need at least [round(STANDING_ORDER_PARTIAL_THRESHOLD * 100)]% to send part of an order. Missing: [english_list(missing_labels)]."))
		return FALSE

	if(!partial)
		return STANDING_ORDER_FULFILL_NEEDS_PARTIAL_PROMPT

	var/payout = mammon_round(delivered_value * STANDING_ORDER_PARTIAL_PAYOUT_MULT)
	var/canonical_equip_value_partial = 0
	for(var/good_id in equip_avail)
		var/list/entry = equip_avail[good_id]
		canonical_equip_value_partial += compute_good_unit_payout(order, good_id) * entry["delivered_units"]
	var/quality_delta_partial = equip_delivered_value - canonical_equip_value_partial
	if(order.petitioned)
		quality_delta_partial = mammon_round(quality_delta_partial * PETITION_TAX_MULT)
	quality_delta_partial = mammon_round(quality_delta_partial * STANDING_ORDER_PARTIAL_PAYOUT_MULT)
	consume_equipment_payload(equip_avail)
	consume_potion_payload(potion_avail)
	consume_stockpile_payload(stock_avail)
	SStreasury.mint(SStreasury.discretionary_fund, payout, "Standing Order (Partial): [order.name]", null, LEDGER_CROWN_REV_STANDING_ORDERS)
	record_round_statistic(STATS_STANDING_ORDER_REVENUE, payout)
	record_round_statistic(STATS_STANDING_ORDERS_FULFILLED, 1)
	order.is_fulfilled = TRUE
	GLOB.standing_order_pool -= order
	if(user)
		to_chat(user, span_notice("Order partially fulfilled: you sent [round(coverage * 100)]% of the goods and [format_mammon(payout)]m went to the Treasury ([round(STANDING_ORDER_PARTIAL_PAYOUT_MULT * 100)]% of their value)."))
		if(quality_delta_partial > 0)
			to_chat(user, span_green("Quality bonus: +[format_mammon(quality_delta_partial)]m for above-standard goods."))
		else if(quality_delta_partial < 0)
			to_chat(user, span_warning("Quality penalty: [format_mammon(quality_delta_partial)]m for shoddy goods."))
		log_game("STANDING ORDER PARTIAL FULFILLED by [user.ckey]: [order.name] (+[format_mammon(payout)]m, [round(coverage * 100)]% coverage, quality_delta=[format_mammon(quality_delta_partial)]m)")
	return list("status" = "partial", "payout" = payout, "coverage_pct" = round(coverage * 100), "quality_delta" = quality_delta_partial)

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
		var/have = stockpile_entry ? stockpile_entry.royal_stock : 0
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
		var/delivered = entry["delivered_units"]
		var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
		if(stockpile_entry)
			stockpile_entry.royal_stock -= delivered
			record_material_flow(MATERIAL_FLOW_OUT, MATERIAL_SOURCE_STANDING_ORDER, stockpile_entry.item_type, delivered)
		credit_economic_event_saturation(good_id, delivered)
	SStreasury.dirty_market_view()

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
	delivered_pretax += compute_equipment_delivered_value(order, equip_avail)
	for(var/list/avail_set in list(potion_avail, stock_avail))
		for(var/good_id in avail_set)
			var/list/entry = avail_set[good_id]
			delivered_pretax += compute_good_unit_payout(order, good_id) * entry["delivered_units"]
			if(!entry["satisfied"])
				var/datum/trade_good/tg = GLOB.trade_goods[good_id]
				var/short_units = entry["need_units"] - entry["delivered_units"]
				missing_labels += "[short_units] [tg ? tg.name : good_id]"
	for(var/good_id in equip_avail)
		var/list/entry = equip_avail[good_id]
		if(!entry["satisfied"])
			var/datum/trade_good/tg = GLOB.trade_goods[good_id]
			var/short_units = entry["need_units"] - entry["delivered_units"]
			missing_labels += "[short_units] [tg ? tg.name : good_id]"
	var/delivered_value = order.petitioned ? mammon_round(delivered_pretax * PETITION_TAX_MULT) : delivered_pretax
	var/total_value = order.total_payout
	var/coverage = total_value > 0 ? (delivered_value / total_value) : 0
	var/payout = mammon_round(delivered_value * STANDING_ORDER_PARTIAL_PAYOUT_MULT)

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
/datum/controller/subsystem/economy/proc/get_good_route(good_id)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(tg?.behavior == TRADE_BEHAVIOR_EQUIPMENT || tg?.behavior == TRADE_BEHAVIOR_POTION)
		return "warehouse"
	return "stockpile"

/datum/controller/subsystem/economy/proc/find_stockpile_by_trade_good(good_id)
	if(!good_id)
		return null
	return SStreasury.stockpile_by_trade_good[good_id]

/datum/controller/subsystem/economy/proc/sell_to_market(mob/user, good_id, quantity)
	var/datum/roguestock/D = find_stockpile_by_trade_good(good_id)
	if(!D)
		return 0
	if(D.market_never_supplies)
		to_chat(user, span_warning("The market does not take [D.name]."))
		return 0
	if(D.royal_stock <= 0)
		to_chat(user, span_warning("There is no [D.name] in the royal stockpile."))
		return 0
	quantity = min(round(quantity), TRADE_MAX_BULK_UNITS, D.royal_stock)
	if(quantity <= 0)
		return 0
	D.refresh_auto_price()
	var/revenue = D.market_bid(quantity)
	D.royal_stock -= quantity
	D.market_stock += quantity
	credit_economic_event_saturation(good_id, quantity)
	SStreasury.dirty_market_view()
	SStreasury.mint(SStreasury.discretionary_fund, revenue, "Market Sale: [quantity] [D.name] by [user.real_name]", null, LEDGER_CROWN_REV_STOCKPILE_SALES)
	log_game("MARKET SALE by [user.ckey]: [quantity] [D.name] (revenue [revenue]m)")
	to_chat(user, span_notice("Sold [quantity] [D.name] to the market for [format_mammon(revenue)]m."))
	return revenue

/datum/controller/subsystem/economy/proc/buy_from_market(mob/user, good_id, quantity)
	var/datum/roguestock/D = find_stockpile_by_trade_good(good_id)
	if(!D)
		return 0
	if(D.market_never_supplies)
		to_chat(user, span_warning("The market does not supply [D.name]."))
		return 0
	D.refresh_auto_price()
	quantity = min(round(quantity), TRADE_MAX_BULK_UNITS)
	if(!D.market_has_supply())
		quantity = min(quantity, D.market_stock)
	if(quantity <= 0)
		to_chat(user, span_warning("The market is out of [D.name]."))
		return 0
	var/cost = D.market_ask(quantity)
	if(!SStreasury.burn(SStreasury.discretionary_fund, cost, "Market Purchase: [quantity] [D.name] by [user.real_name]", LEDGER_CROWN_EXP_STOCKPILE))
		to_chat(user, span_warning("The Treasury can't afford this. It has [format_mammon(SStreasury.discretionary_fund.balance)]m and needs [format_mammon(cost)]m."))
		return 0
	D.market_stock = max(0, D.market_stock - quantity)
	D.royal_stock += quantity
	D.check_glut_relief()
	SStreasury.dirty_market_view()
	log_game("MARKET PURCHASE by [user.ckey]: [quantity] [D.name] (cost [cost]m)")
	to_chat(user, span_notice("Bought [quantity] [D.name] from the market for [format_mammon(cost)]m."))
	return cost
