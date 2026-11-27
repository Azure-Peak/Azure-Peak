/datum/controller/subsystem/economy/proc/petitions_remaining_today()
	if(last_petition_day != ECONOMY_DAY)
		return PETITIONS_PER_DAY
	return max(0, PETITIONS_PER_DAY - petitions_today)

/datum/controller/subsystem/economy/proc/petition_category_of(kind)
	for(var/cat_id in GLOB.petition_categories)
		var/list/cat = GLOB.petition_categories[cat_id]
		if(kind in cat["kinds"])
			return cat_id
	return null

/datum/controller/subsystem/economy/proc/petition_kind_label(kind)
	var/datum/request_kind/request_kind = GLOB.request_kinds[kind]
	return request_kind ? request_kind.name : "[kind]"

/datum/controller/subsystem/economy/proc/region_request(region_id)
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(O.region_id == region_id)
			return O
	return null

/datum/controller/subsystem/economy/proc/petition_target_regions(kind)
	var/list/regions = list()
	var/pool_full = length(GLOB.standing_order_pool) >= STANDING_ORDERS_POOL_CAP
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(!(kind in region.request_kinds))
			continue
		var/datum/standing_order/current = region_request(region_id)
		if(current?.petitioned || current?.partly_delivered)
			continue
		if(!current && pool_full)
			continue
		regions += region
	return regions

/datum/controller/subsystem/economy/proc/petition_blocker(kind)
	if(petitions_remaining_today() <= 0)
		return "no petitions left today"
	var/list/cat = GLOB.petition_categories[petition_category_of(kind)]
	if(!cat)
		return "unknown petition category"
	if(!length(petition_target_regions(kind)))
		return "no region can take a [petition_kind_label(kind)] petition right now"
	if(!SStreasury.burgher_pledge_fund)
		return "the Burghers have not made their pledge yet"
	var/cost = cat["cost"]
	if(SStreasury.burgher_pledge_fund.balance < cost)
		return "not enough Burgher Pledge (need [cost]p)"
	return null

/datum/controller/subsystem/economy/proc/petition_for_order(mob/user, kind)
	var/blocker = petition_blocker(kind)
	if(blocker)
		if(user)
			to_chat(user, span_warning("Petition refused: [blocker]."))
		return null
	var/list/cat = GLOB.petition_categories[petition_category_of(kind)]
	var/label = petition_kind_label(kind)
	var/cost = cat["cost"]
	var/datum/economic_region/region = pick(petition_target_regions(kind))
	if(!SStreasury.burn(SStreasury.burgher_pledge_fund, cost, "Steward petition - [label] in [region.name]", ledger_acct(LEDGER_BOOK_PLEDGE, LEDGER_KEY_EXPENSE)))
		if(user)
			to_chat(user, span_warning("Petition refused: the Burgher Pledge could not cover the cost."))
		return null
	record_round_statistic(STATS_PLEDGE_CONSUMED, cost)
	record_round_statistic(STATS_PETITION_PLEDGE_SPENT, cost)
	if(last_petition_day != ECONOMY_DAY)
		petitions_today = 0
		last_petition_day = ECONOMY_DAY
	petitions_today++
	var/datum/standing_order/replaced = region_request(region.region_id)
	if(replaced)
		GLOB.standing_order_pool -= replaced
	var/datum/standing_order/O = instantiate_kind_request(region, kind, petitioned = TRUE)
	if(!O)
		if(replaced)
			GLOB.standing_order_pool += replaced
		SStreasury.mint(SStreasury.burgher_pledge_fund, cost, "Steward petition refund - no order found", null, ledger_acct(LEDGER_BOOK_PLEDGE, LEDGER_KEY_EXPENSE))
		record_round_statistic(STATS_PLEDGE_CONSUMED, -cost)
		record_round_statistic(STATS_PETITION_PLEDGE_SPENT, -cost)
		petitions_today--
		if(user)
			to_chat(user, span_warning("Unable to find the appropriate petition. Pledge returned."))
		return null
	record_round_statistic(STATS_STANDING_ORDERS_PETITIONED, 1)
	log_game("PETITION: [user ? key_name(user) : "system"] petitioned [label]: landed in [region.name], rolled [O.name] (+[O.total_payout]m, -[cost]p)[replaced ? ", replacing [replaced.name]" : ""]")
	if(user)
		to_chat(user, span_notice("Petition accepted in [region.name]: [O.name] posted at the warehouse for [O.total_payout]m.[replaced ? " It replaces [replaced.name]." : ""]"))
	return region

/datum/controller/subsystem/economy/proc/extend_blocker(datum/standing_order/order)
	if(!order || order.is_fulfilled || !(order in GLOB.standing_order_pool))
		return "the order is gone"
	if(!SStreasury.burgher_pledge_fund)
		return "Odd! There's no burgher's pledge fund."
	if(SStreasury.burgher_pledge_fund.balance < STANDING_ORDER_EXTEND_COST)
		return "not enough Burgher Pledge (need [STANDING_ORDER_EXTEND_COST]p)"
	return null

/datum/controller/subsystem/economy/proc/extend_order(mob/user, datum/standing_order/order)
	var/blocker = extend_blocker(order)
	if(blocker)
		if(user)
			to_chat(user, span_warning("No zad sent: [blocker]."))
		return FALSE
	if(!SStreasury.burn(SStreasury.burgher_pledge_fund, STANDING_ORDER_EXTEND_COST, "Order extension - [order.name]", ledger_acct(LEDGER_BOOK_PLEDGE, LEDGER_KEY_EXPENSE)))
		if(user)
			to_chat(user, span_warning("No zad sent: the Burgher Pledge could not cover the cost."))
		return FALSE
	record_round_statistic(STATS_PLEDGE_CONSUMED, STANDING_ORDER_EXTEND_COST)
	order.day_expires += STANDING_ORDER_EXTEND_DAYS
	log_game("ORDER EXTENDED: [user ? key_name(user) : "system"] extended [order.name] to day [order.day_expires] (-[STANDING_ORDER_EXTEND_COST]p)")
	if(user)
		to_chat(user, span_notice("A zad flies off. [order.name] lasts another dae."))
	return TRUE
