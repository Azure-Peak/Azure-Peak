/datum/quest/kill/raid
	quest_type = QUEST_RAID
	chronicle_order = QUEST_CHRONICLE_ORDER_RAID
	quest_difficulty = QUEST_DIFFICULTY_HARD
	pool_kind = QUEST_POOL_KILL
	pool_weight = QUEST_POOL_WEIGHT_RAID
	rumor_cost = RUMOR_COST_MAJOR
	defense_cost = BURGHER_PLEDGE_COST_MAJOR
	eligible_regions = list(
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_TERRORBOG,
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_MOUNT_DECAP,
		THREAT_REGION_UNDERDARK,
	)
	tp_budget = QUEST_TP_BUDGET_RAID
	threat_bands_cleared = QUEST_BANDS_RAID
	required_fellowship_size = 2

/datum/quest/kill/raid/get_title()
	if(title)
		return title
	if(!faction)
		return "Rout an incoming raid"
	return "Rout a [faction.group_word] of [faction.name_plural]"
