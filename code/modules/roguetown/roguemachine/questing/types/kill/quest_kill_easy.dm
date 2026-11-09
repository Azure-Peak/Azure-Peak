/datum/quest/kill/easy
	quest_type = QUEST_KILL_EASY
	chronicle_order = QUEST_CHRONICLE_ORDER_KILL_EASY
	pool_kind = QUEST_POOL_KILL
	pool_weight = QUEST_POOL_WEIGHT_KILL_EASY
	rumor_cost = RUMOR_COST_TRIVIAL
	defense_cost = BURGHER_PLEDGE_COST_TRIVIAL
	eligible_regions = list(
		THREAT_REGION_AZURE_BASIN,
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_TERRORBOG,
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_MOUNT_DECAP,
		THREAT_REGION_UNDERDARK,
	)
	tp_budget = QUEST_TP_BUDGET_KILL_EASY
	min_mobs = 2
	threat_bands_cleared = QUEST_BANDS_KILL_EASY
	fellowship_threat_rate = QUEST_FELLOWSHIP_THREAT_PER_EXTRA_EASY
	fellowship_reward_rate = QUEST_FELLOWSHIP_REWARD_PER_EXTRA_EASY
	objective_verb = "Slay"

/datum/quest/kill/easy/faction_fits(datum/quest_faction/F, datum/threat_region/TR)
	return ..() && F.average_threat_point() <= QUEST_TP_BUDGET_KILL_EASY * TR.tp_budget_multiplier * QUEST_EASY_MAX_FACTION_TP_SHARE

/datum/quest/kill/easy/get_title()
	if(title)
		return title
	if(!faction)
		return "Slay a troublesome creature"
	return "Slay [progress_required] [faction.name_plural]"
