/datum/quest/kill/clearout
	quest_type = QUEST_CLEAR_OUT
	chronicle_order = QUEST_CHRONICLE_ORDER_CLEAR_OUT
	quest_difficulty = QUEST_DIFFICULTY_MEDIUM
	pool_kind = QUEST_POOL_KILL
	pool_weight = QUEST_POOL_WEIGHT_CLEAR_OUT
	rumor_cost = RUMOR_COST_STANDARD
	defense_cost = BURGHER_PLEDGE_COST_STANDARD
	eligible_regions = list(
		THREAT_REGION_AZURE_BASIN,
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_TERRORBOG,
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_MOUNT_DECAP,
		THREAT_REGION_UNDERDARK,
	)
	tp_budget = QUEST_TP_BUDGET_CLEAR_OUT
	max_region_tp_mult = QUEST_MEDIUM_MAX_REGION_TP_MULT
	threat_bands_cleared = QUEST_BANDS_CLEAR_OUT
	fellowship_threat_rate_first = QUEST_SOLO_SCALE_THREAT_FIRST
	fellowship_threat_rate = QUEST_SOLO_SCALE_THREAT_AFTER
	fellowship_reward_rate = QUEST_FELLOWSHIP_REWARD_PER_EXTRA

/datum/quest/kill/clearout/get_title()
	if(title)
		return title
	if(!faction)
		return "Clear out a nest of monsters"
	return "Clear out a [faction.group_word] of [faction.name_plural]"
