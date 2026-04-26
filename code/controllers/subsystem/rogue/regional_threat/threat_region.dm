/datum/threat_region
	var/region_name = "Generic Region Scream At Coder"
	var/latent_ambush = 0
	var/min_ambush = 0
	var/max_ambush = 150
	var/fixed_ambush = FALSE // Some region like Underdark cannot be reduced in danger
	var/lowpop_tick = 3 // How much TP to tick up every 15 min (<= 30 pop)
	var/highpop_tick = 5 // How much TP to tick up every 15 min (> 30 pop)
	var/last_natural_ambush_time = -AMBUSH_REGION_COOLDOWN // Pre-expired so start-of-round doesn't block ambushes
	var/last_induced_ambush_time = 0 // Time between now and the previous ambush triggered by horn
	var/list/faction_weights = list()
	var/tp_budget_multiplier = 1.0
	// Ambush budget percent - uses the higher one for safer region so that they can still spawn some relevant ambushes without needing to adjust the max_ambush downward
	var/ambush_budget_pct = AMBUSH_BUDGET_PCT_REGULAR
	/// Quest types this region will host. Default is everything; set per region to restrict (e.g. a dangerous region that won't host trivial kill-easy quests).
	var/list/allowed_quest_types
	var/kill_target_floor = 2
	var/evergreen_target = 0

/datum/threat_region/New(_region_name, _latent_ambush, _min_ambush, _max_ambush, _fixed_ambush, _lowpop_tick, _highpop_tick, _ambush_budget_pct = AMBUSH_BUDGET_PCT_REGULAR, _faction_weights, _tp_budget_multiplier = 1.0, _allowed_quest_types, _kill_target_floor = 2, _evergreen_target = 0)
	region_name = _region_name
	latent_ambush = _latent_ambush
	min_ambush = _min_ambush
	max_ambush = _max_ambush
	fixed_ambush = _fixed_ambush
	lowpop_tick = _lowpop_tick
	highpop_tick = _highpop_tick
	if(_faction_weights)
		faction_weights = _faction_weights
	tp_budget_multiplier = _tp_budget_multiplier
	ambush_budget_pct = _ambush_budget_pct
	if(_allowed_quest_types)
		allowed_quest_types = _allowed_quest_types
	else
		allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = _kill_target_floor
	evergreen_target = _evergreen_target

/datum/threat_region/proc/get_kill_target(pop)
	var/scaled = round(pop * QUEST_KILL_FRACTION)
	return clamp(scaled, kill_target_floor, kill_target_floor + QUEST_KILL_CEILING_OFFSET)

/datum/threat_region/proc/allows_quest_type(quest_type)
	return (quest_type in allowed_quest_types)

/datum/threat_region/proc/get_threat_weight()
	if(!max_ambush || latent_ambush <= 0)
		return 0
	return latent_ambush / max_ambush

/datum/threat_region/proc/pick_faction()
	if(!length(faction_weights))
		return null
	var/id = pickweight(faction_weights)
	return get_quest_faction(id)

/datum/threat_region/proc/get_thematic_factions()
	var/list/result = list()
	for(var/id in faction_weights)
		var/datum/quest_faction/F = get_quest_faction(id)
		if(F)
			result += F
	return result

/datum/threat_region/proc/reduce_latent_ambush(amount)
	if(fixed_ambush)
		return
	if(latent_ambush - amount < min_ambush)
		latent_ambush = min_ambush
	else
		latent_ambush -= amount

/datum/threat_region/proc/increase_latent_ambush(amount)
	if(fixed_ambush)
		return
	if(latent_ambush + amount > max_ambush)
		latent_ambush = max_ambush
	else
		latent_ambush += amount

/// Danger level for display — based on percentage of this region's max_ambush.
/datum/threat_region/proc/get_danger_level()
	if(!max_ambush)
		return DANGER_LEVEL_SAFE
	var/pct = (latent_ambush / max_ambush) * 100
	if(pct <= DANGER_PCT_SAFE)
		return DANGER_LEVEL_SAFE
	else if(pct <= DANGER_PCT_LOW)
		return DANGER_LEVEL_LOW
	else if(pct <= DANGER_PCT_MODERATE)
		return DANGER_LEVEL_MODERATE
	else if(pct <= DANGER_PCT_DANGEROUS)
		return DANGER_LEVEL_DANGEROUS
	else
		return DANGER_LEVEL_BLEAK

/// Translates latent_ambush into an IC-flavored breakdown by faction.
/// Returns a list of strings like "12 warbands of bogmen" in descending order of count.
/// Factions with 0 bands (due to small weights at low threat) are dropped. If nothing to report,
/// returns an empty list (caller renders "Safe" or equivalent).
/datum/threat_region/proc/get_ic_description()
	var/list/result = list()
	if(!length(faction_weights) || latent_ambush <= 0)
		return result
	var/total_bands = round(latent_ambush / THREAT_POINTS_PER_BAND)
	if(total_bands <= 0)
		return result
	var/weight_sum = 0
	for(var/id in faction_weights)
		weight_sum += faction_weights[id]
	if(!weight_sum)
		return result
	var/list/shares = list()
	for(var/id in faction_weights)
		var/datum/quest_faction/F = get_quest_faction(id)
		if(!F)
			continue
		var/bands = round(total_bands * faction_weights[id] / weight_sum)
		if(bands <= 0)
			continue
		shares[F] = bands
	sortTim(shares, /proc/cmp_numeric_dsc, associative = TRUE)
	for(var/datum/quest_faction/F as anything in shares)
		result += F.describe_group_count(shares[F])
	return result

/datum/threat_region/proc/get_danger_color(level)
	switch(get_danger_level())
		if(DANGER_LEVEL_SAFE)
			return "#00FF00"
		if(DANGER_LEVEL_LOW)
			return "#FFFF00"
		if(DANGER_LEVEL_MODERATE)
			return "#FFA500"
		if(DANGER_LEVEL_DANGEROUS)
			return "#FF0000"
		if(DANGER_LEVEL_BLEAK)
			return "#800080"
		else
			return "#FFFFFF"
