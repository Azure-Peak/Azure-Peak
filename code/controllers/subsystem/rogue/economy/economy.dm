SUBSYSTEM_DEF(economy)
	name = "Economy"
	init_order = INIT_ORDER_ECONOMY
	flags = SS_NO_FIRE
	var/last_processed_day = 0
	var/roundstart_events_fired = FALSE
	/// Admin override for the effective player count used by pop scaling.
	/// 0 = use the live count. Set via Economic Panel.
	var/simulated_player_scalar = 0
	/// Populated during daily_tick; written to the Steward's morning report at the end
	/// of the tick. Null between ticks.
	var/list/daily_report_diff = null

/// Single source of truth for pop-scaled economy math. Admin override beats the live count.
/datum/controller/subsystem/economy/proc/get_effective_player_count()
	if(simulated_player_scalar > 0)
		return simulated_player_scalar
	return get_active_player_count()

/datum/controller/subsystem/economy/Initialize()
	populate_standing_order_templates()
	// Allocate the diff so roundstart events/blockades are captured. The first daily_tick
	// appends to it (rather than resetting) so the Steward's first morning report covers
	// Day 0's rolls too.
	daily_report_diff = list(
		"day" = GLOB.dayspassed,
		"events_fired" = list(),
		"events_expired" = list(),
		"blockades_fired" = list(),
		"blockades_cleared" = list(),
		"orders_rolled" = 0,
		"urgent_rolled" = 0,
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
			/datum/standing_order/demand_equipment_armaments,
			/datum/standing_order/demand_equipment_armor,
		),
		TRADE_REGION_ROSAWOOD = list(
			/datum/standing_order/demand_construction,
			/datum/standing_order/demand_exotic,
		),
		TRADE_REGION_ROCKHILL = list(
			/datum/standing_order/demand_orchard,
			/datum/standing_order/demand_construction,
		),
		TRADE_REGION_DAFTSMARCH = list(
			/datum/standing_order/demand_construction,
			/datum/standing_order/demand_smithing,
			/datum/standing_order/demand_victualling_mines,
		),
		TRADE_REGION_BLACKHOLT = list(
			/datum/standing_order/demand_exotic,
			/datum/standing_order/demand_construction,
			/datum/standing_order/demand_alchemical,
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
			/datum/standing_order/demand_equipment_armor,
		),
		TRADE_REGION_NORTHFORT = list(
			/datum/standing_order/demand_rations,
			/datum/standing_order/demand_armaments,
			/datum/standing_order/demand_construction,
			/datum/standing_order/demand_victualling_garrison,
			/datum/standing_order/demand_alchemical,
			/datum/standing_order/demand_equipment_armaments,
			/datum/standing_order/demand_equipment_armor,
		),
		TRADE_REGION_HEARTFELT = list(
			/datum/standing_order/demand_rations,
			/datum/standing_order/demand_armaments,
			/datum/standing_order/demand_textile,
			/datum/standing_order/demand_orchard,
			/datum/standing_order/demand_victualling_garrison,
			/datum/standing_order/demand_alchemical,
			/datum/standing_order/demand_equipment_armaments,
			/datum/standing_order/demand_equipment_armor,
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
	tick_scheduled_blockades()
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
			var/datum/standing_order/O = new template()
			O.region_id = region.region_id
			O.required_items = O.generate_item_mix()
			for(var/good_id in O.required_items)
				O.required_items[good_id] = max(1, round(O.required_items[good_id] * order_size_mult))
			O.name = O.generate_name(region)
			O.description = O.generate_description(region)
			O.day_issued = GLOB.dayspassed
			O.day_expires = GLOB.dayspassed + STANDING_ORDER_DURATION
			O.total_payout = compute_order_payout(O, region)
			GLOB.standing_order_pool += O
			daily_report_diff["orders_rolled"] = (daily_report_diff["orders_rolled"] || 0) + 1

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
		if(base >= 30)
			qty_lo = 2
			qty_hi = 4
		else if(base >= 15)
			qty_lo = 3
			qty_hi = 6
		else
			qty_lo = 6
			qty_hi = 14
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

/datum/controller/subsystem/economy/proc/compute_order_payout(datum/standing_order/order, datum/economic_region/region)
	// Flat additive payout. Regular = base_price * 1.75; urgent = base_price * 2.5.
	// Event price_mod does NOT stack here - urgent orders are ALREADY the shortage's premium
	// payout; letting the shortage mod multiply again compounds into absurd numbers.
	var/is_urgent = istype(order, /datum/standing_order/urgent)
	var/bonus_mult = 1 + STANDING_ORDER_BASE_BONUS + (is_urgent ? URGENT_ORDER_EXTRA_BONUS : 0)
	var/total = 0
	for(var/good_id in order.required_items)
		var/quantity = order.required_items[good_id]
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg)
			continue
		// CEILING: low-base goods (stone=1) must not collapse to parity with the raw qty count
		// after BYOND's floor-round. Guarantees standing orders always beat stockpile sell-back.
		var/unit = CEILING(tg.base_price * bonus_mult, 1)
		total += unit * quantity
	return round(total)

/datum/controller/subsystem/economy/proc/fulfill_order(mob/user, datum/standing_order/order)
	if(!order || order.is_fulfilled)
		return FALSE
	var/datum/economic_region/ER = GLOB.economic_regions[order.region_id]
	if(ER?.is_region_blockaded)
		if(user)
			to_chat(user, span_warning("[ER.name] is blockaded — the order cannot be delivered until the road is cleared."))
		return FALSE

	if(order_is_equipment(order))
		return fulfill_equipment_order(user, order)
	if(order_is_alchemical(order))
		return fulfill_alchemical_order(user, order)

	for(var/good_id in order.required_items)
		var/required = order.required_items[good_id]
		var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
		if(!stockpile_entry || stockpile_entry.stockpile_amount < required)
			if(user)
				to_chat(user, span_warning("Insufficient [good_id]: have [stockpile_entry?.stockpile_amount || 0], need [required]."))
			return FALSE

	for(var/good_id in order.required_items)
		var/required = order.required_items[good_id]
		var/datum/roguestock/stockpile_entry = find_stockpile_by_trade_good(good_id)
		stockpile_entry.stockpile_amount -= required

	SStreasury.mint(SStreasury.discretionary_fund, order.total_payout, "Standing Order: [order.name]")
	record_round_statistic(STATS_STANDING_ORDER_REVENUE, order.total_payout)
	record_round_statistic(STATS_STANDING_ORDERS_FULFILLED, 1)
	order.is_fulfilled = TRUE
	GLOB.standing_order_pool -= order
	if(user)
		to_chat(user, span_notice("Order Fulfilled: [order.total_payout]m paid to the Crown's Purse."))
		log_game("STANDING ORDER FULFILLED by [user.ckey]: [order.name] (+[order.total_payout]m)")
	return TRUE

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

/// Warehouse scan that counts DELIVERED REAGENT VOLUME, not container count. A bottle
/// of 50u healthpot satisfies one unit; a 100u flask satisfies two. Any reagent container
/// works — player brewers use a grab-bag of bottles, flasks, and pouches. Matched
/// containers are consumed in full on fulfillment (simpler than metering a draw).
/datum/controller/subsystem/economy/proc/fulfill_alchemical_order(mob/user, datum/standing_order/order)
	if(!length(GLOB.steward_export_machines))
		if(user)
			to_chat(user, span_warning("No warehouse dock manifest is registered. Cannot fulfill alchemical orders."))
		return FALSE

	var/list/required_volume_by_good = list()
	var/list/found_volume_by_good = list()
	var/list/matched_containers_by_good = list()
	for(var/good_id in order.required_items)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg || tg.behavior != TRADE_BEHAVIOR_POTION)
			continue
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

	for(var/good_id in required_volume_by_good)
		var/need = required_volume_by_good[good_id]
		var/have = found_volume_by_good[good_id]
		if(have < need)
			var/datum/trade_good/tg = GLOB.trade_goods[good_id]
			var/label = tg ? tg.name : good_id
			if(user)
				to_chat(user, span_warning("Warehouse short on [label]: have [have]u, need [need]u."))
			return FALSE

	for(var/good_id in matched_containers_by_good)
		for(var/obj/item/I as anything in matched_containers_by_good[good_id])
			qdel(I)

	SStreasury.mint(SStreasury.discretionary_fund, order.total_payout, "Standing Order: [order.name]")
	record_round_statistic(STATS_STANDING_ORDER_REVENUE, order.total_payout)
	record_round_statistic(STATS_STANDING_ORDERS_FULFILLED, 1)
	order.is_fulfilled = TRUE
	GLOB.standing_order_pool -= order
	if(user)
		to_chat(user, span_notice("Order Fulfilled: [order.total_payout]m paid to the Crown's Purse."))
		log_game("STANDING ORDER (ALCHEMICAL) FULFILLED by [user.ckey]: [order.name] (+[order.total_payout]m)")
	return TRUE

/// Scans the 3x3 around every registered steward_export machine for finished equipment,
/// two-pass: count first, then consume only if everything required is present.
/datum/controller/subsystem/economy/proc/fulfill_equipment_order(mob/user, datum/standing_order/order)
	if(!length(GLOB.steward_export_machines))
		if(user)
			to_chat(user, span_warning("No warehouse dock manifest is registered. Cannot fulfill equipment orders."))
		return FALSE

	var/list/found_by_good = list()
	var/list/matched_items_by_good = list()
	for(var/good_id in order.required_items)
		found_by_good[good_id] = 0
		matched_items_by_good[good_id] = list()

	for(var/obj/structure/roguemachine/steward_export/M as anything in GLOB.steward_export_machines)
		if(QDELETED(M))
			continue
		for(var/obj/item/I in view(1, M))
			for(var/good_id in order.required_items)
				var/datum/trade_good/tg = GLOB.trade_goods[good_id]
				if(!tg || tg.behavior != TRADE_BEHAVIOR_EQUIPMENT)
					continue
				if(!tg.item_type || !istype(I, tg.item_type))
					continue
				// Exact-type match (not subtypes) to avoid counting donator/unique subtypes
				// against Crown manifest orders.
				if(I.type != tg.item_type)
					continue
				if(found_by_good[good_id] >= order.required_items[good_id])
					continue
				found_by_good[good_id]++
				matched_items_by_good[good_id] += I
				break

	for(var/good_id in order.required_items)
		var/need = order.required_items[good_id]
		var/have = found_by_good[good_id]
		if(have < need)
			var/datum/trade_good/tg = GLOB.trade_goods[good_id]
			var/label = tg ? tg.name : good_id
			if(user)
				to_chat(user, span_warning("Warehouse short on [label]: have [have], need [need]."))
			return FALSE

	for(var/good_id in order.required_items)
		for(var/obj/item/I as anything in matched_items_by_good[good_id])
			qdel(I)

	SStreasury.mint(SStreasury.discretionary_fund, order.total_payout, "Standing Order: [order.name]")
	record_round_statistic(STATS_STANDING_ORDER_REVENUE, order.total_payout)
	record_round_statistic(STATS_STANDING_ORDERS_FULFILLED, 1)
	order.is_fulfilled = TRUE
	GLOB.standing_order_pool -= order
	if(user)
		to_chat(user, span_notice("Order Fulfilled: [order.total_payout]m paid to the Crown's Purse."))
		log_game("STANDING ORDER (EQUIPMENT) FULFILLED by [user.ckey]: [order.name] (+[order.total_payout]m)")
	return TRUE

/datum/controller/subsystem/economy/proc/find_stockpile_by_trade_good(good_id)
	if(!good_id)
		return null
	for(var/datum/roguestock/entry as anything in SStreasury.stockpile_datums)
		if(!("trade_good_id" in entry.vars))
			continue
		if(entry.vars["trade_good_id"] == good_id)
			return entry
	return null

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
