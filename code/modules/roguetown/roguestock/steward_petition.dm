GLOBAL_LIST_INIT(petition_categories, build_petition_categories())

/proc/build_petition_categories()
	var/list/cats = list()
	cats[PETITION_CATEGORY_MATERIALS] = list(
		"label" = "Materials",
		"description" = "Artificery.",
		"cost" = PETITION_COST_MATERIALS,
		"templates" = list(
			/datum/standing_order/demand_artificery = "Artificer's Workshop",
		),
	)
	cats[PETITION_CATEGORY_ARMS] = list(
		"label" = "Arms & Harness",
		"description" = "Finished weapons and armor - garrison kit, frontier muster, harness orders.",
		"cost" = PETITION_COST_ARMS,
		"templates" = list(
			/datum/standing_order/demand_equipment_armaments = "Arms Order",
			/datum/standing_order/demand_equipment_armor_heavy = "Harness Order",
			/datum/standing_order/demand_equipment_armor_light = "Levy Tunics",
			/datum/standing_order/demand_frontier_gear = "Frontier Garrison Kit",
		),
	)
	cats[PETITION_CATEGORY_LUXURIES] = list(
		"label" = "Luxuries",
		"description" = "Court finery, jewelry and name day tributes.",
		"cost" = PETITION_COST_LUXURIES,
		"templates" = list(
			/datum/standing_order/demand_court_finery = "Court Finery",
			/datum/standing_order/demand_jewelry = "Jewelers' Commission",
			/datum/standing_order/demand_birthday_gift = "Birthday Tribute",
		),
	)
	cats[PETITION_CATEGORY_ALCHEMY] = list(
		"label" = "Alchemy & Care",
		"description" = "Finished potions and prosthetics.",
		"cost" = PETITION_COST_ALCHEMY,
		"templates" = list(
			/datum/standing_order/demand_alchemical = "Apothecary Order",
			/datum/standing_order/demand_alchemical_warband = "Warband Draughts",
			/datum/standing_order/demand_prosthetic_run = "Infirmary's Order",
		),
	)
	cats[PETITION_CATEGORY_MASTERWORK] = list(
		"label" = "Masterwork",
		"description" = "Showpiece commissions - artificed panoply, tournament arms, hunt trophies.",
		"cost" = PETITION_COST_MASTERWORK,
		"templates" = list(
			/datum/standing_order/demand_artificed_panoply = "Artificed Panoply",
			/datum/standing_order/demand_tournament_arms = "Tournament",
			/datum/standing_order/demand_trophy_heads = "Hunt Trophies",
		),
	)
	return cats

/datum/controller/subsystem/economy/proc/petitions_remaining_today()
	if(last_petition_day != GLOB.dayspassed)
		return PETITIONS_PER_DAY
	return max(0, PETITIONS_PER_DAY - petitions_today)

/datum/controller/subsystem/economy/proc/petition_category_of(template)
	for(var/cat_id in GLOB.petition_categories)
		var/list/cat = GLOB.petition_categories[cat_id]
		if(template in cat["templates"])
			return cat_id
	return null

/datum/controller/subsystem/economy/proc/petition_blocker(region_id, template)
	if(petitions_remaining_today() <= 0)
		return "no petitions left today"
	var/list/cat = GLOB.petition_categories[petition_category_of(template)]
	if(!cat)
		return "unknown petition category"
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!region)
		return "unknown region"
	if(!(template in region.possible_standing_order_types))
		return "[region.name] does not deal in [cat["templates"][template]]"
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

/datum/controller/subsystem/economy/proc/petition_for_order(mob/user, region_id, template)
	var/blocker = petition_blocker(region_id, template)
	if(blocker)
		if(user)
			to_chat(user, span_warning("Petition refused: [blocker]."))
		return FALSE
	var/list/cat = GLOB.petition_categories[petition_category_of(template)]
	var/label = cat["templates"][template]
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
	var/datum/standing_order/O = instantiate_standing_order(template, region, petitioned = TRUE)
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
