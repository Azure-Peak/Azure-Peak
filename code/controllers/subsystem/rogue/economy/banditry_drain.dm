// TEMPORARY: banditry drain is a placeholder consequence until proper raid/siege
// content ships. Delete this file when raids land. See BANDITRY_DRAIN_* in economy.dm.

/// Snapshot of the next banditry tick. Returns list("total" = m, "lines" = list(strings),
/// "debt" = m). Drain is a flat amount per contributing region. The Crown's Purse will
/// not be cut below BANDITRY_DEBT_FLOOR; the unpaid remainder accrues as banditry_debt
/// and skims all future treasury inflow until paid.
/datum/controller/subsystem/economy/proc/preview_banditry_drain()
	var/list/result = list("total" = 0, "lines" = list(), "debt" = SStreasury?.banditry_debt || 0)
	var/pop = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		var/level = TR.get_danger_level()
		var/cost = 0
		switch(level)
			if(DANGER_LEVEL_DANGEROUS)
				cost = BANDITRY_DRAIN_DANGEROUS_FLAT + (BANDITRY_DRAIN_DANGEROUS_PER_PLAYER * pop)
			if(DANGER_LEVEL_BLEAK)
				cost = BANDITRY_DRAIN_BLEAK_FLAT + (BANDITRY_DRAIN_BLEAK_PER_PLAYER * pop)
		if(cost <= 0)
			continue
		var/base_cost = (level == DANGER_LEVEL_BLEAK) ? BANDITRY_DRAIN_BLEAK_FLAT : BANDITRY_DRAIN_DANGEROUS_FLAT
		var/per_player = (level == DANGER_LEVEL_BLEAK) ? BANDITRY_DRAIN_BLEAK_PER_PLAYER : BANDITRY_DRAIN_DANGEROUS_PER_PLAYER
		result["total"] += cost
		result["lines"] += "[TR.region_name] ([level]) -[cost]m ([base_cost] base + [per_player]m/head x [pop])"
	return result

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
	if(shortfall > 0)
		SStreasury.banditry_debt += shortfall
	record_round_statistic(STATS_BANDITRY_LOSSES, total_drain)
	GLOB.azure_round_stats[STATS_BANDITRY_DEBT_OUTSTANDING] = SStreasury.banditry_debt
	if(daily_report_diff)
		daily_report_diff["banditry_drain_total"] = total_drain
		daily_report_diff["banditry_drain_burned"] = burn_now
		daily_report_diff["banditry_drain_accrued_debt"] = shortfall
		daily_report_diff["banditry_drain_lines"] = preview["lines"]
