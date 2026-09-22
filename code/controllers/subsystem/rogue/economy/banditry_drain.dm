/datum/controller/subsystem/economy/proc/preview_banditry_drain()
	var/list/result = list("total" = 0, "lines" = list(), "debt" = SStreasury?.banditry_debt || 0, "by_region" = list(), "hoard_total" = 0)
	// Respects simulated_player_scalar so admin testing can drive it, matching get_effective_player_count().
	var/pop = (simulated_player_scalar > 0) ? simulated_player_scalar : get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)
	var/flat_mult = clamp(pop / BANDITRY_DRAIN_POP_REFERENCE, BANDITRY_DRAIN_FLAT_MIN_MULT, 1.0)
	var/raw_total = 0
	var/list/raw_lines = list() // region_name -> uncapped breakdown text, for the cap step below to annotate
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		result["hoard_total"] += TR.banditry_hoard
		var/level = TR.get_danger_level()
		var/base_cost = 0
		var/per_player = 0
		switch(level)
			if(DANGER_LEVEL_DANGEROUS)
				base_cost = BANDITRY_DRAIN_DANGEROUS_FLAT
				per_player = BANDITRY_DRAIN_DANGEROUS_PER_PLAYER
			if(DANGER_LEVEL_BLEAK)
				base_cost = BANDITRY_DRAIN_BLEAK_FLAT
				per_player = BANDITRY_DRAIN_BLEAK_PER_PLAYER
		if(base_cost <= 0 && per_player <= 0)
			continue
		var/scaled_base = round(base_cost * flat_mult)
		var/cost = scaled_base + (per_player * pop)
		if(cost <= 0)
			continue
		raw_total += cost
		result["by_region"][TR.region_name] = cost
		raw_lines[TR.region_name] = "[TR.region_name] ([level]) -[cost]m ([scaled_base] base + [per_player]m/head x [pop])"

	// Global cap so several regions going Dangerous/Bleak at once can't stack without bound.
	// If it binds, shrink each region's share proportionally (keeps by_region consistent for
	// burn/hoard crediting below) and annotate the math rather than hiding it.
	var/daily_cap = BANDITRY_DRAIN_DAILY_CAP_BASE + (BANDITRY_DRAIN_DAILY_CAP_PER_PLAYER * pop)
	result["raw_total"] = raw_total
	result["cap"] = daily_cap
	var/list/by_region = result["by_region"]
	var/list/lines = list()
	if(raw_total > daily_cap && raw_total > 0)
		var/scale = daily_cap / raw_total
		lines += "Bandits are scarce - stolen funds are currently capped."
		for(var/region_name in by_region)
			var/capped_cost = round(by_region[region_name] * scale)
			by_region[region_name] = capped_cost
			lines += "[raw_lines[region_name]] -> CAPPED to -[capped_cost]m"
		lines += "TOTAL: -[raw_total]m raw drain capped to -[daily_cap]m (daily cap: [BANDITRY_DRAIN_DAILY_CAP_BASE] base + [BANDITRY_DRAIN_DAILY_CAP_PER_PLAYER]m/head x [pop] pop)"
		result["total"] = daily_cap
	else
		for(var/region_name in by_region)
			lines += raw_lines[region_name]
		result["total"] = raw_total
	result["lines"] = lines
	return result

/datum/controller/subsystem/economy/proc/total_banditry_hoard()
	var/total = 0
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		total += TR.banditry_hoard
	return total

/datum/controller/subsystem/economy/proc/tick_banditry_drain()
	if(!SStreasury?.discretionary_fund)
		return
	var/list/preview = preview_banditry_drain()
	var/total_drain = preview["total"]
	if(total_drain <= 0)
		return
	var/balance = SStreasury.discretionary_fund.balance
	var/burnable = max(0, balance - BANDITRY_DEBT_FLOOR)
	var/burn_now = min(total_drain, burnable)
	var/shortfall = total_drain - burn_now
	if(burn_now > 0)
		SStreasury.burn(SStreasury.discretionary_fund, burn_now, "Banditry losses (untended regions)")
		record_treasury_expense(TREASURY_FLOW_BANDITRY, "Crown", burn_now)
		var/list/by_region = preview["by_region"]
		var/remaining = burn_now
		for(var/region_name in by_region)
			if(remaining <= 0)
				break
			var/datum/threat_region/TR = SSregionthreat.get_region(region_name)
			if(!TR)
				continue
			var/share = min(by_region[region_name], remaining)
			TR.banditry_hoard += share
			remaining -= share
	if(shortfall > 0)
		SStreasury.banditry_debt += shortfall
	record_round_statistic(STATS_BANDITRY_LOSSES, total_drain)
	GLOB.azure_round_stats[STATS_BANDITRY_DEBT_OUTSTANDING] = SStreasury.banditry_debt
	GLOB.azure_round_stats[STATS_BANDITRY_HOARD_OUTSTANDING] = total_banditry_hoard()
	if(daily_report_diff)
		daily_report_diff["banditry_drain_total"] = total_drain
		daily_report_diff["banditry_drain_burned"] = burn_now
		daily_report_diff["banditry_drain_accrued_debt"] = shortfall
		daily_report_diff["banditry_drain_lines"] = preview["lines"]
		daily_report_diff["banditry_hoard_total"] = total_banditry_hoard()
