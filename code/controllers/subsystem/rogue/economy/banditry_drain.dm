/datum/controller/subsystem/economy/proc/preview_banditry_drain()
	var/list/result = list("total" = 0, "lines" = list(), "debt" = SStreasury?.banditry_debt || 0, "by_region" = list(), "hoard_total" = 0, "skim_pct" = round(BANDITRY_DEBT_SKIM_RATE * 100))
	// Respects simulated_player_scalar so admin testing can drive it, matching get_effective_player_count().
	var/pop = (simulated_player_scalar > 0) ? simulated_player_scalar : get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)
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
		var/cost = base_cost + (per_player * pop)
		if(cost <= 0)
			continue
		result["total"] += cost
		result["by_region"][TR.region_name] = cost
		result["lines"] += "[TR.region_name] ([level]) -[cost]m ([base_cost]m base, plus [per_player]m per active person for [pop] active people)"
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
		SStreasury.burn(SStreasury.discretionary_fund, burn_now, "Brigand losses (untended regions)", LEDGER_CROWN_EXP_BANDITRY)
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
		SStreasury.post_ledger_entry("accrual", "Brigand losses unpaid (added to brigand debt)", list(
			list(LEDGER_CROWN_EXP_BANDITRY, shortfall, 0),
			list(LEDGER_CROWN_BANDITRY_DEBT, 0, shortfall),
		))
	record_round_statistic(STATS_BANDITRY_LOSSES, total_drain)
	GLOB.azure_round_stats[STATS_BANDITRY_DEBT_OUTSTANDING] = SStreasury.banditry_debt
	GLOB.azure_round_stats[STATS_BANDITRY_HOARD_OUTSTANDING] = total_banditry_hoard()
	if(daily_report_diff)
		daily_report_diff["banditry_drain_total"] = total_drain
		daily_report_diff["banditry_drain_burned"] = burn_now
		daily_report_diff["banditry_drain_accrued_debt"] = shortfall
		daily_report_diff["banditry_drain_lines"] = preview["lines"]
		daily_report_diff["banditry_hoard_total"] = total_banditry_hoard()
