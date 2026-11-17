/datum/controller/subsystem/economy/proc/petitions_remaining_today()
	if(last_petition_day != GLOB.dayspassed)
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

/datum/controller/subsystem/economy/proc/petition_blocker(region_id, kind)
	if(petitions_remaining_today() <= 0)
		return "no petitions left today"
	var/list/cat = GLOB.petition_categories[petition_category_of(kind)]
	if(!cat)
		return "unknown petition category"
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!region)
		return "unknown region"
	if(!(kind in region.request_kinds))
		return "[region.name] does not deal in [petition_kind_label(kind)]"
	if(region.is_region_blockaded)
		return "[region.name] is blockaded"
	if(region.day_last_cleared >= 0)
		var/since = GLOB.dayspassed - region.day_last_cleared
		if(since < PETITION_BLOCKADE_RECOVERY_DAYS)
			var/wait_days = PETITION_BLOCKADE_RECOVERY_DAYS - since
			return "[region.name] is recovering from blockade, [wait_days] more days"
	if(GLOB.standing_order_pool.len >= STANDING_ORDERS_POOL_CAP)
		return "warehouse manifest full, fulfill orders first"
	if(region_order_count(region_id) >= STANDING_ORDERS_MAX_PER_REGION)
		return "[region.name] already has an order"
	if(!SStreasury.burgher_pledge_fund)
		return "the Burghers have not made their pledge yet"
	var/cost = cat["cost"]
	if(SStreasury.burgher_pledge_fund.balance < cost)
		return "not enough Burgher Pledge (need [cost]p)"
	return null

/datum/controller/subsystem/economy/proc/petition_for_order(mob/user, region_id, kind)
	var/blocker = petition_blocker(region_id, kind)
	if(blocker)
		if(user)
			to_chat(user, span_warning("Petition refused: [blocker]."))
		return FALSE
	var/list/cat = GLOB.petition_categories[petition_category_of(kind)]
	var/label = petition_kind_label(kind)
	var/cost = cat["cost"]
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!SStreasury.burn(SStreasury.burgher_pledge_fund, cost, "Steward petition - [label] in [region.name]", ledger_acct(LEDGER_BOOK_PLEDGE, LEDGER_KEY_EXPENSE)))
		if(user)
			to_chat(user, span_warning("Petition refused: the Burgher Pledge could not cover the cost."))
		return FALSE
	record_round_statistic(STATS_PLEDGE_CONSUMED, cost)
	record_round_statistic(STATS_PETITION_PLEDGE_SPENT, cost)
	if(last_petition_day != GLOB.dayspassed)
		petitions_today = 0
		last_petition_day = GLOB.dayspassed
	petitions_today++
	var/datum/standing_order/O = instantiate_kind_request(region, kind, petitioned = TRUE)
	if(!O)
		SStreasury.mint(SStreasury.burgher_pledge_fund, cost, "Steward petition refund - no order found", null, ledger_acct(LEDGER_BOOK_PLEDGE, LEDGER_KEY_EXPENSE))
		record_round_statistic(STATS_PLEDGE_CONSUMED, -cost)
		record_round_statistic(STATS_PETITION_PLEDGE_SPENT, -cost)
		petitions_today--
		if(user)
			to_chat(user, span_warning("Unable to find the appropriate petition. Pledge returned."))
		return FALSE
	record_round_statistic(STATS_STANDING_ORDERS_PETITIONED, 1)
	log_game("PETITION: [user ? key_name(user) : "system"] petitioned [label] in [region.name]: rolled [O.name] (+[O.total_payout]m, -[cost]p)")
	if(user)
		to_chat(user, span_notice("Petition accepted: [O.name] posted at the warehouse for [O.total_payout]m."))
	return TRUE

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
