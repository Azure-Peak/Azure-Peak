// TEMPORARY: banditry drain is a placeholder consequence until proper raid/siege
// content ships. Delete this file when raids land. See BANDITRY_DRAIN_* in economy.dm.

/// Snapshot of the next banditry tick. Returns list("total" = m, "lines" = list(strings)).
/// Drain is a percentage of the current Crown's Purse per contributing region — a rich
/// Crown feels the bite, a poor Crown never bankrupts from banditry alone.
/datum/controller/subsystem/economy/proc/preview_banditry_drain()
	var/list/result = list("total" = 0, "lines" = list())
	var/purse = SStreasury?.discretionary_fund?.balance
	if(!purse || purse <= 0)
		return result
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		var/level = TR.get_danger_level()
		var/pct = 0
		switch(level)
			if(DANGER_LEVEL_DANGEROUS)
				pct = BANDITRY_DRAIN_DANGEROUS_PCT
			if(DANGER_LEVEL_BLEAK)
				pct = BANDITRY_DRAIN_BLEAK_PCT
		if(pct <= 0)
			continue
		var/cost = round(purse * pct)
		if(cost <= 0)
			continue
		result["total"] += cost
		result["lines"] += "[TR.region_name] ([level]) -[cost]m ([round(pct * 100)]%)"
	return result

/datum/controller/subsystem/economy/proc/tick_banditry_drain()
	if(!SStreasury?.discretionary_fund)
		return
	var/list/preview = preview_banditry_drain()
	var/total_drain = preview["total"]
	if(total_drain <= 0)
		return
	SStreasury.burn(SStreasury.discretionary_fund, total_drain, "Banditry losses (untended regions)")
	if(daily_report_diff)
		daily_report_diff["banditry_drain_total"] = total_drain
		daily_report_diff["banditry_drain_lines"] = preview["lines"]
